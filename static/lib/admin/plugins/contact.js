'use strict';

const translator = require('translator');

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
    if (window.app && window.app.require) {
        window.app.require('bootbox').then(function (bootbox) {
            bootbox.confirm(message, cb);
        });
    } else if (window.bootbox) {
        window.bootbox.confirm(message, cb);
    } else {
        cb(confirm(message));
    }
}

function performHandle(id) {
    $.post(config.relative_path + '/api/admin/plugins/contact/handle', { id: id, _csrf: config.csrf_token }).done(function (data) { if (data.success) { showMessage('success', '[[simple-contact:admin.handled-success]]'); ajaxify.refresh(); } }).fail(function () { showMessage('error', '[[simple-contact:admin.handle-error]]'); });
}

function performDelete(id) {
    $.post(config.relative_path + '/api/admin/plugins/contact/delete', { id: id, _csrf: config.csrf_token }).done(function (data) { if (data.success) { showMessage('success', '[[simple-contact:admin.deleted-success]]'); ajaxify.refresh(); } }).fail(function () { showMessage('error', '[[simple-contact:admin.delete-error]]'); });
}

function initContactPage() {
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

        if (!uid) return;
        btn.prop('disabled', true);

        $.post(config.relative_path + '/api/admin/plugins/contact/chat', {
            touid: uid,
            title: title,
            firstMessage: message,
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
