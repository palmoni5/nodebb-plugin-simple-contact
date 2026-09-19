<div class="row justify-content-center mt-4">
    <div class="col-lg-8">
        <div class="card shadow-sm">

            <div class="card-header text-center py-3 bg-primary text-white">
                <h3 class="card-title fw-semibold mb-0">{{tx("simple-contact:contact-page-title")}}</h3>
            </div>

            <div class="card-body p-4">

                <form id="contact-form" role="form" class="mx-auto" style="max-width:600px;">

                    <div class="mb-3">
                        <label for="fullName" class="form-label fw-semibold">{{tx("simple-contact:form.full-name")}} *</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" required>
                    </div>

                    <div class="mb-3" id="username-group">
                        <label for="username" class="form-label fw-semibold">{{tx("simple-contact:form.username")}}</label>
                        <input type="text" class="form-control" id="username" name="username">
                    </div>

                    <div class="mb-3">
                        <label for="email" class="form-label fw-semibold">{{tx("simple-contact:form.email")}} *</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>

                    <div class="mb-4">
                        <label for="contact-message" class="form-label fw-semibold">{{tx("simple-contact:form.message")}} *</label>
                        <textarea class="form-control" id="contact-message" name="content" rows="6" required></textarea>
                    </div>

                    {{{ if requireTerms }}}
                    <div class="mb-3" id="contact-terms-group">
                        {{{ if termsText }}}
                        <div class="border rounded p-3 mb-2 bg-body-secondary overflow-auto" id="contact-terms-text" style="max-height:220px;">
                            {{termsText}}
                        </div>
                        {{{ end }}}
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="contact-terms" name="terms" required>
                            <label class="form-check-label fw-semibold" for="contact-terms">
                                {{{ if termsLabel }}}{termsLabel}{{{ else }}}{{tx("simple-contact:form.terms-agree")}}{{{ end }}}
                            </label>
                        </div>
                    </div>
                    {{{ end }}}

                    <button type="submit" class="btn btn-primary w-100 rounded-pill fw-semibold py-2 mt-2" id="submit-btn">
                        {{tx("simple-contact:form.submit")}}
                    </button>

                </form>

                <div id="contact-alert" class="alert text-center mt-4" style="display:none;"></div>

            </div>
        </div>
    </div>
</div>
