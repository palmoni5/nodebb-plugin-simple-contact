<div class="row justify-content-center">
    <div class="col-lg-8" style="margin-top:20px;">
        <div class="card shadow-sm" style="border-radius:14px; border:none;">

            <div class="card-header text-center" style="background:linear-gradient(135deg,#2b6cb0,#2c5282); color:#fff; border-radius:14px 14px 0 0; padding:15px; border:none;">
                <h3 class="card-title" style="font-weight:600; margin:0;">{{tx("simple-contact:contact-page-title")}}</h3>
            </div>

            <div class="card-body" style="border-radius:0 0 14px 14px; padding:20px 25px;">

                <form id="contact-form" role="form" style="max-width:600px; margin:0 auto;">

                    <div class="mb-3">
                        <label for="fullName" class="form-label" style="font-weight:600;">{{tx("simple-contact:form.full-name")}} *</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" required style="border-radius:10px; padding:10px;">
                    </div>

                    <div class="mb-3" id="username-group">
                        <label for="username" class="form-label" style="font-weight:600;">{{tx("simple-contact:form.username")}}</label>
                        <input type="text" class="form-control" id="username" name="username" style="border-radius:10px; padding:10px;">
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label" style="font-weight:600;">{{tx("simple-contact:form.email")}} *</label>
                        <input type="email" class="form-control" id="email" name="email" required style="border-radius:10px; padding:10px;">
                    </div>

                    <div class="mb-4">
                        <label for="contact-message" class="form-label" style="font-weight:600;">{{tx("simple-contact:form.message")}} *</label>
                        <textarea class="form-control" id="contact-message" name="content" rows="6" required style="border-radius:10px; padding:10px;"></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary w-100" id="submit-btn" style="border-radius:22px; font-weight:600; padding:12px; margin-top:10px;">
                        {{tx("simple-contact:form.submit")}}
                    </button>

                </form>

                <div id="contact-alert" class="alert text-center" style="display:none; margin-top:20px; border-radius:10px;"></div>

            </div>
        </div>
    </div>
</div>
