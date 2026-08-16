'use strict';

require(['translator'], function (translator) {
    $(window).on('action:ajaxify.contentLoaded', function (event, data) {
        if (!data || data.tpl !== 'contact') {
            return;
        }
        initContactForm();
    });

    function showAlert(alertBox, type, textOrToken) {
        translator.translate(textOrToken, function (txt) {
            alertBox.removeClass('alert-success alert-danger').addClass('alert-' + type).text(txt).fadeIn();
        });
    }

    function initContactForm() {
        var form = $('#contact-form');
        if (!form.length) return;

        var btn = $('#submit-btn');
        var alertBox = $('#contact-alert');
        var isLoggedIn = !!(app.user && app.user.uid > 0);

        $('#username-group').toggle(!isLoggedIn);

        form.off('submit').on('submit', function (e) {
            e.preventDefault();

            var content = $('#contact-message').val();
            var fullName = $('#fullName').val();
            var email = $('#email').val();
            var username = isLoggedIn ? app.user.username : $('#username').val();

            if (!content || !content.trim()) {
                showAlert(alertBox, 'danger', '[[simple-contact:form.write-message]]');
                return;
            }

            btn.prop('disabled', true);
            translator.translate('[[simple-contact:form.sending]]', function (txt) { btn.text(txt); });
            alertBox.hide().removeClass('alert-success alert-danger');

            $.ajax({
                url: config.relative_path + '/api/contact/send',
                type: 'POST',
                data: {
                    fullName: fullName,
                    email: email,
                    content: content,
                    username: username,
                    _csrf: config.csrf_token,
                },
                headers: { 'x-csrf-token': config.csrf_token },
            }).done(function (response) {
                showAlert(alertBox, 'success', response.message || '[[simple-contact:form.success]]');
                form[0].reset();
            }).fail(function (xhr) {
                var msg = (xhr.responseJSON && xhr.responseJSON.error) || '[[simple-contact:form.send-error]]';
                showAlert(alertBox, 'danger', msg);
            }).always(function () {
                btn.prop('disabled', false);
                translator.translate('[[simple-contact:form.submit]]', function (txt) { btn.text(txt); });
            });
        });
    }

    initContactForm();
});
