'use strict';

const translator = require('translator');
const modals = require('modals');

function showMessage(type, msg) {
    const clean = msg.replace(/<[^>]*>/g, '');
    if (window.app && typeof window.app.require === 'function') {
        window.app.require('alerts').then(function (alerts) {
            type === 'success' ? alerts.success(clean) : alerts.error(clean);
        }).catch(function () { alert(clean); });
        return;
    }
    alert(clean);
}

function confirmBox(message, cb) {
    modals.confirm(message, cb);
}

function performHandle(id) {
    $.post(config.relative_path + '/api/admin/plugins/contact/handle', { id: id, _csrf: config.csrf_token })
        .done(function (data) { if (data.success) { showMessage('success', '[[simple-contact:admin.handled-success]]'); ajaxify.refresh(); } })
        .fail(function () { showMessage('error', '[[simple-contact:admin.handle-error]]'); });
}

function performDelete(id) {
    $.post(config.relative_path + '/api/admin/plugins/contact/delete', { id: id, _csrf: config.csrf_token })
        .done(function (data) { if (data.success) { showMessage('success', '[[simple-contact:admin.deleted-success]]'); ajaxify.refresh(); } })
        .fail(function () { showMessage('error', '[[simple-contact:admin.delete-error]]'); });
}

// ---- Activity type labels ----
var activityLabels = {
    submitted:      { icon: 'fa-paper-plane', cls: 'text-primary',  key: 'simple-contact:admin.activity.submitted' },
    handled:        { icon: 'fa-check-circle', cls: 'text-success', key: 'simple-contact:admin.activity.handled' },
    assigned:       { icon: 'fa-user',         cls: 'text-info',    key: 'simple-contact:admin.activity.assigned' },
    reply_email:    { icon: 'fa-envelope',     cls: 'text-warning', key: 'simple-contact:admin.activity.reply_email' },
    reply_chat:     { icon: 'fa-comments',     cls: 'text-warning', key: 'simple-contact:admin.activity.reply_chat' },
    comment:        { icon: 'fa-comment-o',    cls: 'text-muted',   key: 'simple-contact:admin.activity.comment' },
    comment_deleted:{ icon: 'fa-trash-o',      cls: 'text-danger',  key: 'simple-contact:admin.activity.comment_deleted' },
};

function prepareActivityItem(a) {
    var meta = activityLabels[a.type] || { icon: 'fa-circle-o', cls: 'text-muted', key: a.type };
    return {
        icon: meta.icon,
        cls: meta.cls,
        labelKey: meta.key,
        assigned: a.type === 'assigned',
        toUsername: (a.extra && a.extra.toUsername) || '',
        username: a.username,
        date: a.date,
    };
}

function renderAssignBadge(container, assignedUsername) {
    app.parseAndTranslate('admin/plugins/contact/assign-badge', { assignedUsername: assignedUsername || '' }, function (html) {
        container.empty().append(html);
    });
}

function openDetailsModal(contactId) {
    var modal = $('#detailsModal');
    $('#details-contact-id').val(contactId);
    $('#details-full-name').text('...');
    $('#comments-list').html('<div style="color:#aaa; text-align:center;"><i class="fa fa-spinner fa-spin"></i></div>');
    $('#activity-list').html('');
    app.parseAndTranslate('admin/plugins/contact/assign-options', { admins: [] }, function (html) {
        $('#assign-uid-select').empty().append(html);
    });
    modal.modal('show');

    $.get(config.relative_path + '/api/admin/plugins/contact/details/' + contactId)
        .done(function (data) {
            var contact = data.contact || {};
            $('#details-full-name').text(contact.fullName || '');

            // Populate assign dropdown
            var admins = (data.admins || []).map(function (admin) {
                return {
                    uid: admin.uid,
                    username: admin.username,
                    selected: String(admin.uid) === String(contact.assignedUid),
                };
            });
            app.parseAndTranslate('admin/plugins/contact/assign-options', { admins: admins }, function (html) {
                $('#assign-uid-select').empty().append(html);
            });

            var assignCurrent = $('#assign-current');
            if (contact.assignedUsername) {
                translator.translateKey('simple-contact:admin.assigned-to', [contact.assignedUsername]).then(function (txt) {
                    assignCurrent.text(txt);
                });
            } else {
                translator.translate('[[simple-contact:admin.not-assigned]]', function (txt) { assignCurrent.text(txt); });
            }

            // Render comments
            var comments = data.comments || [];
            $('#comments-badge').text(comments.length);
            var commentItems = comments.slice().reverse().map(function (c) {
                return { id: c.id, username: c.username, date: c.date, content: c.content, contactId: contactId };
            });
            app.parseAndTranslate('admin/plugins/contact/comments', { comments: commentItems }, function (html) {
                $('#comments-list').empty().append(html);
            });

            // Render activity
            var activityItems = (data.activity || []).slice().reverse().map(prepareActivityItem);
            app.parseAndTranslate('admin/plugins/contact/activity', { activity: activityItems }, function (html) {
                $('#activity-list').empty().append(html);
            });
        })
        .fail(function () {
            app.parseAndTranslate('admin/plugins/contact/comments', { comments: [], error: true }, function (html) {
                $('#comments-list').empty().append(html);
            });
        });
}

function bindDetailsModalEvents() {
    // Assign button
    $('#assign-btn').off('click').on('click', function () {
        var btn = $(this);
        var contactId = $('#details-contact-id').val();
        var assignedUid = $('#assign-uid-select').val();
        btn.prop('disabled', true);

        $.post(config.relative_path + '/api/admin/plugins/contact/assign', {
            id: contactId,
            assignedUid: assignedUid,
            _csrf: config.csrf_token
        })
        .done(function (data) {
            if (data.success) {
                showMessage('success', '[[simple-contact:admin.assign-success]]');
                var assignCurrent = $('#assign-current');
                if (data.assignedUsername) {
                    translator.translateKey('simple-contact:admin.assigned-to', [data.assignedUsername]).then(function (txt) {
                        assignCurrent.text(txt);
                    });
                } else {
                    translator.translate('[[simple-contact:admin.not-assigned]]', function (txt) { assignCurrent.text(txt); });
                }
                // Refresh activity section
                openDetailsModal(contactId);
                // Update badge in table row
                var row = $('tr[data-id="' + contactId + '"]');
                renderAssignBadge(row.find('td').eq(5), data.assignedUsername);
            }
        })
        .fail(function () { showMessage('error', '[[simple-contact:admin.assign-error]]'); })
        .always(function () { btn.prop('disabled', false); });
    });

    // Add comment button
    $('#add-comment-btn').off('click').on('click', function () {
        var btn = $(this);
        var contactId = $('#details-contact-id').val();
        var content = $('#new-comment-text').val().trim();
        if (!content) return showMessage('error', '[[simple-contact:admin.comment-empty]]');
        btn.prop('disabled', true);

        $.post(config.relative_path + '/api/admin/plugins/contact/comment', {
            id: contactId,
            content: content,
            _csrf: config.csrf_token
        })
        .done(function (data) {
            if (data.success) {
                $('#new-comment-text').val('');
                showMessage('success', '[[simple-contact:admin.comment-added]]');
                openDetailsModal(contactId);
                // Update comment badge on row
                var row = $('tr[data-id="' + contactId + '"]');
                var viewBtn = row.find('.view-details');
                var badge = viewBtn.find('.badge');
                var newCount = (parseInt(badge.text()) || 0) + 1;
                if (badge.length) { badge.text(newCount); } else {
                    viewBtn.append('<span class="badge" style="background:#e74c3c; color:#fff;">' + newCount + '</span>');
                }
            }
        })
        .fail(function () { showMessage('error', '[[simple-contact:error.internal]]'); })
        .always(function () { btn.prop('disabled', false); });
    });

    // Delete comment (delegated)
    $('#detailsModal').off('click', '.delete-comment-btn').on('click', '.delete-comment-btn', function () {
        var btn = $(this);
        var contactId = btn.data('id');
        var commentId = btn.data('comment-id');
        confirmBox('[[simple-contact:admin.confirm-delete-comment]]', function (ok) {
            if (!ok) return;
            $.post(config.relative_path + '/api/admin/plugins/contact/delete-comment', {
                id: contactId,
                commentId: commentId,
                _csrf: config.csrf_token
            })
            .done(function (data) {
                if (data.success) {
                    showMessage('success', '[[simple-contact:admin.comment-deleted]]');
                    openDetailsModal(contactId);
                    // Update row badge
                    var row = $('tr[data-id="' + contactId + '"]');
                    var viewBtn = row.find('.view-details');
                    var badge = viewBtn.find('.badge');
                    var newCount = Math.max(0, (parseInt(badge.text()) || 0) - 1);
                    if (newCount > 0) { badge.text(newCount); } else { badge.remove(); }
                }
            })
            .fail(function () { showMessage('error', '[[simple-contact:error.internal]]'); });
        });
    });
}

function initContactPage() {
    bindDetailsModalEvents();

    $('.view-details').off('click').on('click', function () {
        var id = $(this).data('id');
        openDetailsModal(String(id));
    });

    $('.reply-chat').off('click').on('click', function (e) {
        e.preventDefault();
        var btn = $(this);
        var uid = btn.data('uid') || btn.attr('data-uid');
        var originalId = btn.closest('tr').attr('data-id');

        if (!uid || uid == 0) {
            return showMessage('error', '[[simple-contact:error.missing-uid]]');
        }

        var row = btn.closest('tr');
        var contentDiv = row.find('.toggle-text');
        var rawContent = contentDiv.text().trim();

        $('#chat-uid').val(uid);
        $('#chat-original-id').val(originalId);
        translator.translate('[[simple-contact:admin.default-chat-title]]', function (title) {
            $('#chat-title-input').val(title);
        });
        translator.translate('[[simple-contact:admin.default-chat-message]]', function (msg) {
            $('#chat-message-input').val(msg.replace(/\\n/g, '\n'));
        });
        $('#chatReplyModal').modal('show');
    });

    $('#create-chat-btn').off('click').on('click', function () {
        var btn = $(this);
        var uid = $('#chat-uid').val();
        var title = $('#chat-title-input').val();
        var message = $('#chat-message-input').val();
        var contactId = $('#chat-original-id').val();

        if (!uid) return;
        btn.prop('disabled', true);

        $.post(config.relative_path + '/api/admin/plugins/contact/chat', {
            touid: uid,
            title: title,
            firstMessage: message,
            contactId: contactId,
            _csrf: config.csrf_token
        })
        .done(function (data) {
            $('#chatReplyModal').modal('hide');
            if (data && data.roomId) {
                showMessage('success', '[[simple-contact:admin.chat-sent]]');
            } else {
                showMessage('error', '[[simple-contact:admin.missing-room-id]]');
            }
        })
        .fail(function (xhr) {
            var err = xhr.responseJSON ? xhr.responseJSON.error : '[[simple-contact:admin.chat-send-error]]';
            showMessage('error', err);
        })
        .always(function () { btn.prop('disabled', false); });
    });

    $('.reply-email').off('click').on('click', function () {
        var email = $(this).data('email');
        var id = $(this).data('id');
        $('#reply-to').val(email);
        $('#reply-id').val(id);
        $('#reply-content').val('');
        $('#emailReplyModal').modal('show');
    });

    $('#send-reply-btn').off('click').on('click', function () {
        var btn = $(this);
        var email = $('#reply-to').val();
        var subject = $('#reply-subject').val();
        var content = $('#reply-content').val();
        var id = $('#reply-id').val();

        if (!content) return showMessage('error', '[[simple-contact:admin.write-message]]');
        btn.prop('disabled', true);

        $.post(config.relative_path + '/api/admin/plugins/contact/reply', {
            email: email,
            subject: subject,
            content: content,
            id: id,
            _csrf: config.csrf_token
        })
        .done(function () {
            $('#emailReplyModal').modal('hide');
            showMessage('success', '[[simple-contact:admin.email-sent]]');
            setTimeout(function () { ajaxify.refresh(); }, 1000);
        })
        .fail(function (xhr) {
            var err = xhr.responseJSON ? xhr.responseJSON.error : '[[simple-contact:admin.send-error]]';
            showMessage('error', err);
        })
        .always(function () { btn.prop('disabled', false); });
    });

    $('.mark-handled').off('click').on('click', function () {
        var id = $(this).data('id');
        confirmBox('[[simple-contact:admin.confirm-handle]]', function (ok) {
            if (ok) performHandle(id);
        });
    });

    $('.delete-request').off('click').on('click', function () {
        var id = $(this).data('id');
        confirmBox('[[simple-contact:admin.confirm-delete]]', function (ok) {
            if (ok) performDelete(id);
        });
    });

    $('.toggle-text').off('click').on('click', function () {
        var $el = $(this);
        if ($el.css('white-space') === 'nowrap') {
            $el.css({ 'white-space': 'normal', 'word-break': 'break-word', 'overflow': 'visible' });
        } else {
            $el.css({ 'white-space': 'nowrap', 'overflow': 'hidden', 'text-overflow': 'ellipsis' });
        }
    });

    $('.modal').on('click', '[data-dismiss="modal"]', function (e) {
        e.preventDefault();
        $(this).closest('.modal').modal('hide');
    });
}

module.exports = {
    init: initContactPage,
};
