'use strict';

const db = require.main.require('./src/database');
const notifications = require.main.require('./src/notifications');
const groups = require.main.require('./src/groups');
const socketIndex = require.main.require('./src/socket.io/index'); 
const emailer = require.main.require('./src/emailer');
const user = require.main.require('./src/user');
const meta = require.main.require('./src/meta');
const translator = require.main.require('./src/translator');

let chats = null;
let messaging = null;

const possiblePaths = ['./src/chats', './src/messaging'];

try { chats = require.main.require('./src/chats'); } catch (e) {}
try { messaging = require.main.require('./src/messaging'); } catch (e) {}

const ContactPlugin = {};

ContactPlugin.init = async function (params) {
    const router = params.router;
    const middleware = params.middleware;

    router.get('/contact', middleware.buildHeader, renderContactPage);
    router.get('/api/contact', renderContactPage);
    router.post('/api/contact/send', middleware.applyCSRF, handleContactSubmission);

    router.get('/admin/plugins/contact', middleware.admin.buildHeader, renderAdminPage);
    router.get('/api/admin/plugins/contact', renderAdminPage);
    router.post('/api/admin/plugins/contact/handle', middleware.admin.buildHeader, markAsHandled);
    router.post('/api/admin/plugins/contact/delete', middleware.admin.buildHeader, deleteRequest);
    router.post('/api/admin/plugins/contact/reply', middleware.admin.buildHeader, replyToContact);
    router.post('/api/admin/plugins/contact/chat', middleware.admin.buildHeader, getChatRoom);
};

async function getUserLanguage(uid) {
    if (parseInt(uid, 10) > 0) {
        const settings = await user.getSettings(uid);
        return settings.userLang || meta.config.defaultLang || 'en-GB';
    }
    return meta.config.defaultLang || 'en-GB';
}

async function translate(language, key, ...args) {
    return await translator.translate(
        translator.compile(`simple-contact:${key}`, ...args),
        language
    );
}

async function getChatRoom(req, res) {
    const language = await getUserLanguage(req.uid);

    if (!chats && !messaging) {
        return res.status(500).json({ error: await translate(language, 'error.chat-modules-not-found') });
    }

    const { touid, title, firstMessage } = req.body;
    const myUid = req.uid;

    if (!touid) {
        return res.status(400).json({ error: await translate(language, 'error.missing-uid') });
    }

    try {
        let roomId = null;

        const chatModule = chats || messaging;

        if (chatModule.getRoomId) {
            roomId = await chatModule.getRoomId(myUid, touid);
        } else if (chatModule.getRoomIdForUser) {
            roomId = await chatModule.getRoomIdForUser(myUid, touid);
        }

        if (!roomId) {
            if (chatModule.create) {
                const newRoom = await chatModule.create([myUid, touid]);
                roomId = (newRoom && newRoom.roomId) ? newRoom.roomId : newRoom;
            } else if (chatModule.newRoom) {
                roomId = await chatModule.newRoom(myUid, [touid]);
            } else if (chatModule.createRoom) {
                roomId = await chatModule.createRoom([myUid, touid]);
            }
        }

        if (!roomId) {
            throw new Error(await translate(language, 'error.unable-to-create-room'));
        }

        if (typeof roomId === 'object' && roomId.roomId) {
            roomId = roomId.roomId;
        }

        if (title) {
            try {
                if (chats && chats.renameRoom) {
                    await chats.renameRoom(myUid, roomId, title);
                } else if (messaging && messaging.renameRoom) {
                    await messaging.renameRoom(myUid, roomId, title);
                }
            } catch (err) {
                console.warn('[Contact Plugin] Failed to rename room:', err.message);
            }
        }

        if (firstMessage) {
            let sent = false;
            console.log('[Contact Plugin] Attempting to send message to Room ' + roomId);

            if (!sent && messaging && messaging.sendMessage) {
                try {
                    await messaging.sendMessage({ uid: myUid, roomId: roomId, content: firstMessage });
                    sent = true;
                    console.log('[Contact Plugin] Sent via messaging.sendMessage (Object)');
                } catch (e) { console.log('Try 1 failed:', e.message); }
            }

            if (!sent && chats && chats.addMessage) {
                try {
                    await chats.addMessage(myUid, roomId, firstMessage);
                    sent = true;
                    console.log('[Contact Plugin] Sent via chats.addMessage');
                } catch (e) { console.log('Try 2 failed:', e.message); }
            }

            if (!sent && chats && chats.send) {
                try {
                    await chats.send(myUid, roomId, firstMessage);
                    sent = true;
                    console.log('[Contact Plugin] Sent via chats.send');
                } catch (e) { console.log('Try 3 failed:', e.message); }
            }
            
            if (!sent && chats && chats.reply) {
                try {
                    await chats.reply(roomId, myUid, firstMessage);
                    sent = true;
                    console.log('[Contact Plugin] Sent via chats.reply');
                } catch (e) { console.log('Try 4 failed:', e.message); }
            }

            if (!sent) {
                console.error('[Contact Plugin] Failed to send message with all known methods.');
            }
        }

        res.json({ roomId: roomId });

    } catch (err) {
        console.error('[Contact Plugin Chat Error]', err);
        res.status(500).json({ error: `${await translate(language, 'error.internal-prefix')}: ${err.message}` });
    }
}

async function renderContactPage(req, res) {
    res.render('contact', {
        title: '[[simple-contact:contact-page-title]]',
        breadcrumbs: [
            { text: '[[global:home]]', url: '/' },
            { text: '[[simple-contact:contact-page-title]]' },
        ],
    });
}

async function handleContactSubmission(req, res) {
    const language = await getUserLanguage(req.uid);
    const data = req.body;
    if (!data.fullName || !data.email || !data.content) {
        return res.status(400).json({ error: await translate(language, 'error.required-fields') });
    }

    if (data.username) {
        const exists = await user.getUidByUsername(data.username);
        if (!exists) {
            return res.status(400).json({ error: await translate(language, 'error.username-not-found') });
        }
    }

    const contactId = Date.now(); 
    const key = 'contact-request:' + contactId;
    const senderUid = req.uid || 0;

    const contactData = {
        id: contactId,
        fullName: data.fullName,
        username: data.username || '',
        uid: senderUid,
        email: data.email,
        content: data.content,
        timestamp: contactId,
        handled: false
    };

    try {
        await db.setObject(key, contactData);
        await db.sortedSetAdd('contact-requests:sorted', contactId, contactId);

        const adminUids = await groups.getMembers('administrators', 0, -1);
        if (adminUids && adminUids.length > 0) {
            await Promise.all(adminUids.map(async (uid) => {
                const userUnreadKey = 'contact:unread_names:' + uid;
                const userNid = 'contact:notification:' + uid;
                await db.listAppend(userUnreadKey, contactData.fullName);
                const myNames = await db.getListRange(userUnreadKey, 0, -1);
                const notificationTitle = (myNames.length === 1) ?
                    translator.compile('simple-contact:notification.single', myNames[0]) :
                    translator.compile('simple-contact:notification.multiple', myNames.length, myNames.join(', '));
                const notification = await notifications.create({
                    type: 'new-contact', bodyShort: notificationTitle, bodyLong: contactData.content, nid: userNid, path: '/admin/plugins/contact', from: senderUid
                });
                await notifications.push(notification, [uid]);
            }));
        }
        res.json({ success: true, message: await translate(language, 'form.success') });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: await translate(language, 'error.internal') });
    }
}

async function renderAdminPage(req, res) {
    const language = await getUserLanguage(req.uid);
    if (req.uid) {
        try {
            const userUnreadKey = 'contact:unread_names:' + req.uid;
            const userNid = 'contact:notification:' + req.uid;
            await notifications.markRead(userNid, req.uid);
            await db.delete(userUnreadKey);
        } catch (e) { console.error('Error handling notifications logic', e); }
    }
    const ids = await db.getSortedSetRevRange('contact-requests:sorted', 0, -1);
    let items = (ids.length > 0) ? await db.getObjects(ids.map(id => 'contact-request:' + id)) : [];
    const waitingRequests = [], handledRequests = [];

    for (const item of items) {
        item.date = new Date(parseInt(item.timestamp)).toLocaleString();
        if ((!item.uid || parseInt(item.uid) === 0) && item.username && item.username !== 'אורח') {
            try {
                const foundUid = await user.getUidByUsername(item.username);
                item.uid = foundUid ? parseInt(foundUid) : 0;
            } catch (err) { item.uid = 0; }
        } else { item.uid = parseInt(item.uid) || 0; }
        item.displayUsername = item.username && item.username !== 'אורח' ? item.username : await translate(language, 'common.guest');
        item.showChat = (item.uid > 0);
        if (item.handled) handledRequests.push(item); else waitingRequests.push(item);
    }
    res.render('admin/plugins/contact', { waitingRequests: waitingRequests, handledRequests: handledRequests });
}

async function markAsHandled(req, res) {
    try { await db.setObjectField('contact-request:' + req.body.id, 'handled', true); res.json({ success: true }); } catch (err) { res.status(500).json({ error: err.message }); }
}
async function deleteRequest(req, res) {
    try { await db.delete('contact-request:' + req.body.id); await db.sortedSetRemove('contact-requests:sorted', req.body.id); res.json({ success: true }); } catch (err) { res.status(500).json({ error: err.message }); }
}

async function replyToContact(req, res) {
    const language = await getUserLanguage(req.uid);
    const { email, subject, content } = req.body;
    
    if (!email || !content) {
        return res.status(400).json({ error: await translate(language, 'error.missing-email-data') });
    }

    try {
        const htmlBody = content.replace(/\n/g, '<br>');
        
        const siteTitle = meta.config['title'] || 'NetFree';
        const logo = meta.config['brand:emailLogo'] || meta.config['brand:logo'];

        await emailer.sendToEmail('contact-reply', email, language, { 
            subject: subject || await translate(language, 'reply.default-subject'),
            body: htmlBody,
            
            site_title: siteTitle,
            url: meta.config['url'],
            "brand:logo": meta.config['brand:logo'],
            "brand:emailLogo": meta.config['brand:emailLogo']
        });

        res.json({ success: true });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: `${await translate(language, 'error.email-send-prefix')}: ${err.message}` });
    }
}

ContactPlugin.addNavigation = async function (header) {
    if (header && Array.isArray(header.navigation)) {
        header.navigation.push({
            route: '/contact',
            iconClass: 'fa-envelope',
            text: '[[simple-contact:navigation.contact]]',
            title: '[[simple-contact:navigation.contact]]',
        });
    }
    return header;
};
ContactPlugin.addAdminNavigation = async function (header) {
    if (header && Array.isArray(header.plugins)) {
        header.plugins.push({
            route: '/plugins/contact',
            icon: 'fa-envelope',
            name: '[[simple-contact:navigation.admin]]',
        });
    }
    return header;
};

module.exports = ContactPlugin;
