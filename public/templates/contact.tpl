<div class="row text-center" style="display:flex; justify-content:center; align-items:center;">
    <div class="col-lg-8 col-lg-offset-2" style="margin-top:20px;">
        <div class="panel panel-default shadow-sm" style="border-radius:14px; border:none;">

            <div class="panel-heading text-center" style="background:linear-gradient(135deg,#2b6cb0,#2c5282); color:#fff; border-radius:14px 14px 0 0; padding:15px;">
                <h3 class="panel-title" style="font-weight:600; margin:0;">[[simple-contact:contact-page-title]]</h3>
            </div>

            <div class="panel-body text-center" style="background:#fafafa; padding:20px 25px;">

                <form id="contact-form" role="form" style="max-width:600px; margin:0 auto;">

                    <div class="form-group" style="margin-bottom:16px;">
                        <label for="fullName" style="font-weight:600; display:block; margin-bottom:6px;">[[simple-contact:form.full-name]] *</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" required style="border-radius:10px; padding:10px;">
                    </div>

                    <div class="form-group" id="username-group" style="margin-bottom:16px;">
                        <label for="username" style="font-weight:600; display:block; margin-bottom:6px;">[[simple-contact:form.username]]</label>
                        <input type="text" class="form-control" id="username" name="username" style="border-radius:10px; padding:10px;">
                    </div>

                    <div class="form-group" style="margin-bottom:16px;">
                        <label for="email" style="font-weight:600; display:block; margin-bottom:6px;">[[simple-contact:form.email]] *</label>
                        <input type="email" class="form-control" id="email" name="email" required style="border-radius:10px; padding:10px;">
                    </div>

                    <div class="form-group" style="margin-bottom:20px;">
                        <label for="contact-message" style="font-weight:600; display:block; margin-bottom:6px;">[[simple-contact:form.message]] *</label>
                        <textarea class="form-control" id="contact-message" name="content" rows="6" required style="border-radius:10px; padding:10px;"></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block" id="submit-btn" style="border-radius:22px; font-weight:600; padding:12px; margin-top:10px;">
                        [[simple-contact:form.submit]]
                    </button>

                </form>

                <div id="contact-alert" class="alert text-center" style="display:none; margin-top:20px; border-radius:10px;"></div>

            </div>
        </div>
    </div>
</div>

<script>
(function() {
    var loadContactForm = function() {
        if (typeof window.jQuery === 'undefined' || typeof window.app === 'undefined') {
            setTimeout(loadContactForm, 200);
            return;
        }

        var $ = window.jQuery;
        var form = $('#contact-form');
        if (!form.length) return;

        var btn = $('#submit-btn');
        var alertBox = $('#contact-alert');
        var isLoggedIn = (app.user && app.user.uid > 0);

        if (isLoggedIn) {
            $('#username-group').hide();
        }

        form.off('submit').on('submit', function(e) {
            e.preventDefault();
            
            var contentVal = $('#contact-message').val(); 
            var fullNameVal = $('#fullName').val();
            var emailVal = $('#email').val();
            var usernameVal = isLoggedIn ? app.user.username : $('#username').val();

            if (!contentVal || contentVal.trim() === '') {
                alertBox.removeClass('alert-success').addClass('alert-danger').text('[[simple-contact:form.write-message]]').fadeIn();
                return;
            }

            btn.prop('disabled', true).text('[[simple-contact:form.sending]]');
            alertBox.hide().removeClass('alert-success alert-danger');

            var payload = {
                fullName: fullNameVal,
                email: emailVal,
                content: contentVal, 
                username: usernameVal,
                _csrf: config.csrf_token
            };

            console.log('Sending Payload:', payload);

            $.ajax({
                url: config.relative_path + '/api/contact/send',
                type: 'POST',
                data: payload,
                headers: {
                    'x-csrf-token': config.csrf_token
                },
                success: function(response) {
                    alertBox.addClass('alert-success').text(response.message || '[[simple-contact:form.success]]').fadeIn();
                    form[0].reset();
                },
                error: function(xhr) {
                    console.error('Error:', xhr);
                    var msg = (xhr.responseJSON && xhr.responseJSON.error) ? xhr.responseJSON.error : '[[simple-contact:form.send-error]]';
                    alertBox.addClass('alert-danger').text(msg).fadeIn();
                },
                complete: function() {
                    btn.prop('disabled', false).text('[[simple-contact:form.submit]]');
                }
            });
        });
    };

    loadContactForm();

    if (typeof window.jQuery !== 'undefined') {
        $(window).on('action:ajaxify.end', function(ev, data) {
            if (data.url.indexOf('contact') !== -1) {
                loadContactForm();
            }
        });
    }
})();
</script>
