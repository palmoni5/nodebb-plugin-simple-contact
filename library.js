'use strict';

const db = require.main.require('./src/database');
const notifications = require.main.require('./src/notifications');
const groups = require.main.require('./src/groups');
const emailer = require.main.require('./src/emailer');
const messaging = require.main.require('./src/messaging');
const user = require.main.require('./src/user');
const meta = require.main.require('./src/meta');
const translator = require.main.require('./src/translator');
const winston = require.main.require('winston');

const MERGE_ID = 'simple-contact:new-contact';
const CONTACT_NID = /^(contact-request:|contact:assigned:|contact:notification:)/;

const ContactPlugin = {};

ContactPlugin.init = async function (params) {
    const router = params.router;
    const middleware = params.middleware;

    router.get('/contact', middleware.buildHeader, renderContactPage);
    router.get('/api/contact', renderContactPage);
    router.post('/api/contact/send', middleware.applyCSRF, handleContactSubmission);

    router.get('/admin/plugins/contact', middleware.admin.buildHeader, renderAdminPage);
    router.get('/api/admin/plugins/contact', renderAdminPage);
    router.get('/api/admin/plugins/contact/details/:id', getContactDetails);
    router.post('/api/admin/plugins/contact/handle', middleware.applyCSRF, markAsHandled);
    router.post('/api/admin/plugins/contact/delete', middleware.applyCSRF, deleteRequest);
    router.post('/api/admin/plugins/contact/reply', middleware.applyCSRF, replyToContact);
    router.post('/api/admin/plugins/contact/chat', middleware.applyCSRF, getChatRoom);
    router.post('/api/admin/plugins/contact/comment', middleware.applyCSRF, addComment);
    router.post('/api/admin/plugins/contact/delete-comment', middleware.applyCSRF, deleteComment);
    router.post('/api/admin/plugins/contact/assign', middleware.applyCSRF, assignRequest);
};

function isTrue(value) {
    return value === true || value === 'true' || value === 'on' || value === 1 || value === '1';
}

async function getContactSettings() {
    const settings = await meta.settings.get('simple-contact') || {};
    return {
        requireTerms: isTrue(settings.requireTerms),
        termsText: settings.termsText || '',
        termsLabel: settings.termsLabel || '',
    };
}

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

async function getAdminDisplayName(uid) {
    try {
        const userData = await user.getUserFields(uid, ['username', 'displayname']);
        return userData.displayname || userData.username || `uid:${uid}`;
    } catch (e) {
        return `uid:${uid}`;
    }
}

async function logActivity(contactId, actorUid, actorName, type, extra) {
    const ts = Date.now();
    const entry = JSON.stringify({ uid: actorUid, username: actorName, type, timestamp: ts, extra: extra || {} });
    await db.sortedSetAdd(`contact-request:${contactId}:activity`, ts, entry);
}

async function getChatRoom(req, res) {
    const language = await getUserLanguage(req.uid);
    const { touid, title, firstMessage, contactId } = req.body;
    const myUid = req.uid;

    if (!touid) {
        return res.status(400).json({ error: await translate(language, 'error.missing-uid') });
    }

    try {
        let roomId = await messaging.hasPrivateChat(myUid, touid);

        if (!roomId) {
            const roomData = { uids: [touid] };
            if (title) {
                roomData.roomName = title;
            }
            roomId = await messaging.newRoom(myUid, roomData);
        } else if (title) {
            await messaging.renameRoom(myUid, roomId, title);
        }

        if (firstMessage) {
            await messaging.addMessage({ uid: myUid, roomId: roomId, content: firstMessage });
        }

        if (contactId) {
            const actorName = await getAdminDisplayName(myUid);
            await logActivity(contactId, myUid, actorName, 'reply_chat', {});
        }

        res.json({ roomId: roomId });
    } catch (err) {
        winston.error(`[simple-contact] failed to open chat room: ${err.stack}`);
        res.status(500).json({ error: `${await translate(language, 'error.internal-prefix')}: ${err.message}` });
    }
}

async function renderContactPage(req, res) {
    const settings = await getContactSettings();
    res.render('contact', {
        requireTerms: settings.requireTerms,
        termsText: settings.termsText,
        termsLabel: settings.termsLabel,
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

    const settings = await getContactSettings();
    if (settings.requireTerms && !isTrue(data.terms)) {
        return res.status(400).json({ error: await translate(language, 'error.terms-required') });
    }

    if (data.username) {
        const exists = await user.getUidByUsername(data.username);
        if (!exists) {
            return res.status(400).json({ error: await translate(language, 'error.username-not-found') });
        }
    }

    const contactId = await db.incrObjectField('global', 'nextContactId');
    const key = 'contact-request:' + contactId;
    const senderUid = req.uid || 0;
    const timestamp = Date.now();

    const contactData = {
        id: contactId,
        fullName: data.fullName,
        username: data.username || '',
        uid: senderUid,
        email: data.email,
        content: data.content,
        timestamp: timestamp,
        handled: false,
        termsAccepted: settings.requireTerms ? 1 : 0,
        assignedUid: 0,
        assignedUsername: '',
    };

    try {
        await db.setObject(key, contactData);
        await db.sortedSetAdd('contact-requests:sorted', timestamp, contactId);

        const submitterName = contactData.fullName || (senderUid > 0 ? `uid:${senderUid}` : 'Guest');
        await logActivity(contactId, senderUid, submitterName, 'submitted', { email: contactData.email });

        const adminUids = await groups.getMembers('administrators', 0, -1);
        if (adminUids && adminUids.length > 0) {
            const notification = await notifications.create({
                type: 'new-contact',
                bodyShort: translator.compile('simple-contact:notification.single', contactData.fullName),
                bodyLong: contactData.content,
                nid: `contact-request:${contactId}`,
                mergeId: MERGE_ID,
                path: '/admin/plugins/contact',
                from: senderUid,
            });
            await notifications.push(notification, adminUids);
        }
        res.json({ success: true, message: await translate(language, 'form.success') });
    } catch (err) {
        winston.error(`[simple-contact] failed to store contact request: ${err.stack}`);
        res.status(500).json({ error: await translate(language, 'error.internal') });
    }
}

async function renderAdminPage(req, res) {
    const language = await getUserLanguage(req.uid);
    if (req.uid) {
        try {
            const unread = await db.getSortedSetRevRange(`uid:${req.uid}:notifications:unread`, 0, -1);
            const ours = unread.filter(nid => CONTACT_NID.test(nid));
            if (ours.length) {
                await notifications.markReadMultiple(ours, req.uid);
            }
        } catch (err) {
            winston.error(`[simple-contact] failed to mark notifications read: ${err.stack}`);
        }
    }
    const ids = await db.getSortedSetRevRange('contact-requests:sorted', 0, -1);
    let items = (ids.length > 0) ? await db.getObjects(ids.map(id => 'contact-request:' + id)) : [];
    const waitingRequests = [], handledRequests = [];

    const commentCounts = await Promise.all(items.map(item =>
        db.sortedSetCard(`contact-request:${item.id}:comments`).catch(() => 0)
    ));

    for (let i = 0; i < items.length; i++) {
        const item = items[i];
        item.date = new Date(parseInt(item.timestamp)).toLocaleString();
        if ((!item.uid || parseInt(item.uid) === 0) && item.username) {
            try {
                const foundUid = await user.getUidByUsername(item.username);
                item.uid = foundUid ? parseInt(foundUid) : 0;
            } catch (err) { item.uid = 0; }
        } else { item.uid = parseInt(item.uid) || 0; }
        item.displayUsername = item.username || await translate(language, 'common.guest');
        item.showChat = (item.uid > 0);
        item.commentCount = commentCounts[i] || 0;
        item.assignedUid = parseInt(item.assignedUid) || 0;
        item.assignedUsername = item.assignedUsername || '';
        item.handledByUsername = item.handledByUsername || '';
        if (item.handled) handledRequests.push(item); else waitingRequests.push(item);
    }
    res.render('admin/plugins/contact', { waitingRequests: waitingRequests, handledRequests: handledRequests });
}

async function getContactDetails(req, res) {
    const { id } = req.params;
    try {
        const contact = await db.getObject(`contact-request:${id}`);
        if (!contact) return res.status(404).json({ error: 'Not found' });

        const commentMembers = await db.getSortedSetRange(`contact-request:${id}:comments`, 0, -1);
        const comments = commentMembers.map(m => {
            try { return JSON.parse(m); } catch (e) { return null; }
        }).filter(Boolean);
        comments.forEach(c => { c.date = new Date(parseInt(c.timestamp)).toLocaleString(); });

        const activityMembers = await db.getSortedSetRange(`contact-request:${id}:activity`, 0, -1);
        const activity = activityMembers.map(m => {
            try { return JSON.parse(m); } catch (e) { return null; }
        }).filter(Boolean);
        activity.forEach(a => { a.date = new Date(parseInt(a.timestamp)).toLocaleString(); });

        const adminUids = await groups.getMembers('administrators', 0, -1);
        const admins = await user.getUsersFields(adminUids, ['uid', 'username']);

        res.json({ contact, comments, activity, admins });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
}

async function addComment(req, res) {
    const { id, content } = req.body;
    if (!id || !content || !content.trim()) {
        return res.status(400).json({ error: 'Missing fields' });
    }
    try {
        const actorName = await getAdminDisplayName(req.uid);
        const ts = Date.now();
        const comment = { id: ts, uid: req.uid, username: actorName, content: content.trim(), timestamp: ts };
        await db.sortedSetAdd(`contact-request:${id}:comments`, ts, JSON.stringify(comment));
        await logActivity(id, req.uid, actorName, 'comment', { preview: content.trim().substring(0, 80) });
        res.json({ success: true, comment: { ...comment, date: new Date(ts).toLocaleString() } });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
}

async function deleteComment(req, res) {
    const { id, commentId } = req.body;
    if (!id || !commentId) return res.status(400).json({ error: 'Missing fields' });
    try {
        const members = await db.getSortedSetRange(`contact-request:${id}:comments`, 0, -1);
        for (const m of members) {
            try {
                const c = JSON.parse(m);
                if (String(c.id) === String(commentId)) {
                    await db.sortedSetRemove(`contact-request:${id}:comments`, m);
                    break;
                }
            } catch (e) {}
        }
        const actorName = await getAdminDisplayName(req.uid);
        await logActivity(id, req.uid, actorName, 'comment_deleted', {});
        res.json({ success: true });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
}

async function assignRequest(req, res) {
    const { id, assignedUid } = req.body;
    if (!id) return res.status(400).json({ error: 'Missing id' });
    try {
        const actorName = await getAdminDisplayName(req.uid);
        const targetUid = parseInt(assignedUid) || 0;
        let targetName = '';

        if (targetUid > 0) {
            targetName = await getAdminDisplayName(targetUid);
        }

        await db.setObject(`contact-request:${id}`, {
            assignedUid: targetUid,
            assignedUsername: targetName,
            assignedAt: Date.now(),
            assignedByUid: req.uid,
        });

        await logActivity(id, req.uid, actorName, 'assigned', { toUid: targetUid, toUsername: targetName });

        if (targetUid > 0 && targetUid !== req.uid) {
            const contact = await db.getObject(`contact-request:${id}`);
            const nid = `contact:assigned:${id}:${targetUid}`;
            const notification = await notifications.create({
                type: 'contact-assigned',
                bodyShort: translator.compile('simple-contact:notification.assigned', actorName, contact ? contact.fullName : ''),
                nid,
                path: '/admin/plugins/contact',
                from: req.uid,
            });
            await notifications.push(notification, [targetUid]);
        }

        res.json({ success: true, assignedUsername: targetName });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
}

async function markAsHandled(req, res) {
    try {
        const actorName = await getAdminDisplayName(req.uid);
        await db.setObject('contact-request:' + req.body.id, {
            handled: true,
            handledByUid: req.uid,
            handledByUsername: actorName,
            handledAt: Date.now(),
        });
        await logActivity(req.body.id, req.uid, actorName, 'handled', {});
        res.json({ success: true });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
}

async function deleteRequest(req, res) {
    try {
        await db.delete('contact-request:' + req.body.id);
        await db.delete(`contact-request:${req.body.id}:comments`);
        await db.delete(`contact-request:${req.body.id}:activity`);
        await db.sortedSetRemove('contact-requests:sorted', req.body.id);
        res.json({ success: true });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
}

async function replyToContact(req, res) {
    const language = await getUserLanguage(req.uid);
    const { email, subject, content, id } = req.body;

    if (!email || !content) {
        return res.status(400).json({ error: await translate(language, 'error.missing-email-data') });
    }

    try {
        const htmlBody = content.replace(/\n/g, '<br>');

        const siteTitle = meta.config['title'] || 'NodeBB';

        await emailer.sendToEmail('contact-reply', email, language, {
            subject: subject || await translate(language, 'reply.default-subject'),
            body: htmlBody,
            site_title: siteTitle,
            url: meta.config['url'],
            "brand:logo": meta.config['brand:logo'],
            "brand:emailLogo": meta.config['brand:emailLogo']
        });

        if (id) {
            const actorName = await getAdminDisplayName(req.uid);
            await logActivity(id, req.uid, actorName, 'reply_email', { subject: subject || '' });
        }

        res.json({ success: true });
    } catch (err) {
        winston.error(`[simple-contact] failed to send reply email: ${err.stack}`);
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

ContactPlugin.addMergeId = async function (data) {
    data.mergeIds.push(MERGE_ID);
    return data;
};

ContactPlugin.mergeNotifications = async function (data) {
    data.notifications.forEach((notification) => {
        if (notification && notification.mergeId === MERGE_ID && notification.mergeCount > 1) {
            notification.bodyShort = translator.compile(
                'simple-contact:notification.multiple', notification.mergeCount
            );
        }
    });
    return data;
};

module.exports = ContactPlugin;
