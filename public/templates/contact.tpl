<div class="row text-center" style="display:flex; justify-content:center; align-items:center;">
    <div class="col-lg-8 col-lg-offset-2" style="margin-top:20px;">
        <div class="panel panel-default shadow-sm" style="border-radius:14px; border:none;">

            <div class="panel-heading text-center" style="background:linear-gradient(135deg,#2b6cb0,#2c5282); color:#fff; border-radius:14px 14px 0 0; padding:15px;">
                <h3 class="panel-title" style="font-weight:600; margin:0;">{{tx("simple-contact:contact-page-title")}}</h3>
            </div>

            <div class="panel-body text-center" style="background:#fafafa; padding:20px 25px;">

                <form id="contact-form" role="form" style="max-width:600px; margin:0 auto;">

                    <div class="form-group" style="margin-bottom:16px;">
                        <label for="fullName" style="font-weight:600; display:block; margin-bottom:6px;">{{tx("simple-contact:form.full-name")}} *</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" required style="border-radius:10px; padding:10px;">
                    </div>

                    <div class="form-group" id="username-group" style="margin-bottom:16px;">
                        <label for="username" style="font-weight:600; display:block; margin-bottom:6px;">{{tx("simple-contact:form.username")}}</label>
                        <input type="text" class="form-control" id="username" name="username" style="border-radius:10px; padding:10px;">
                    </div>

                    <div class="form-group" style="margin-bottom:16px;">
                        <label for="email" style="font-weight:600; display:block; margin-bottom:6px;">{{tx("simple-contact:form.email")}} *</label>
                        <input type="email" class="form-control" id="email" name="email" required style="border-radius:10px; padding:10px;">
                    </div>

                    <div class="form-group" style="margin-bottom:20px;">
                        <label for="contact-message" style="font-weight:600; display:block; margin-bottom:6px;">{{tx("simple-contact:form.message")}} *</label>
                        <textarea class="form-control" id="contact-message" name="content" rows="6" required style="border-radius:10px; padding:10px;"></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block" id="submit-btn" style="border-radius:22px; font-weight:600; padding:12px; margin-top:10px;">
                        {{tx("simple-contact:form.submit")}}
                    </button>

                </form>

                <div id="contact-alert" class="alert text-center" style="display:none; margin-top:20px; border-radius:10px;"></div>

            </div>
        </div>
    </div>
</div>
