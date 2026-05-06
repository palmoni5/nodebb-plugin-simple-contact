<div class="row text-center">
    <div class="col-xs-12">

        <div class="panel panel-warning shadow-sm" style="border:none; border-radius:12px;">
            <div class="panel-heading text-center" style="border-radius:12px 12px 0 0; font-weight:600;">
                [[simple-contact:admin.waiting-title]]
            </div>

            <div class="panel-body" style="background:#fafafa;">
                {{{ if waitingRequests.length }}}
                <div class="table-responsive">
                    <table class="table table-hover text-center" style="margin-bottom:0;">
                        <thead>
                            <tr>
                                <th class="text-center">[[simple-contact:admin.table.date]]</th>
                                <th class="text-center">[[simple-contact:admin.table.full-name]]</th>
                                <th class="text-center">[[simple-contact:admin.table.username]]</th>
                                <th class="text-center">[[simple-contact:admin.table.email]]</th>
                                <th class="text-center">[[simple-contact:admin.table.content]]</th>
                                <th class="text-center">[[simple-contact:admin.table.status]]</th>
                                <th class="text-center">[[simple-contact:admin.table.actions]]</th>
                            </tr>
                        </thead>
                        <tbody id="contact-list-waiting">
                            {{{ each waitingRequests }}}
                            <tr data-id="{./id}" class="text-center">
                                <td>{./date}</td>
                                <td><strong>{./fullName}</strong></td>
                                <td>
                                    {{{ if ./showChat }}}
                                        <a href="{config.relative_path}/admin/manage/users?searchBy=uid&query={./uid}&page=1&sortBy=lastonline" target="_blank" title="[[simple-contact:admin.manage-user]]">
                                            {./displayUsername}
                                        </a>
                                    {{{ else }}}
                                        {./displayUsername}
                                    {{{ end }}}
                                </td>
                                <td><a href="mailto:{./email}">{./email}</a></td>
                                <td style="max-width:260px;">
                                    <div class="toggle-text" style="white-space:nowrap; overflow:hidden; text-overflow:ellipsis; cursor:pointer;" title="[[simple-contact:admin.toggle-content]]">
                                        {./content}
                                    </div>
                                </td>
                                <td>
                                    <span class="label label-warning" style="border-radius:10px; padding:3px 6px; font-size:11px;">[[simple-contact:admin.status.waiting]]</span>
                                </td>
                                <td class="text-left">
                                    <div class="btn-group btn-group-sm">
                                        {{{ if ./showChat }}}
                                        <button class="btn btn-success reply-chat" data-uid="{./uid}" style="margin-left:2px; border-radius:4px;">
                                            <i class="fa fa-comments"></i> [[simple-contact:admin.reply-chat]]
                                        </button>
                                        {{{ end }}}

                                        <button class="btn btn-info reply-email" data-id="{./id}" data-email="{./email}" style="margin-left:2px; border-radius:4px;">
                                            <i class="fa fa-envelope-o"></i> [[simple-contact:admin.reply-email]]
                                        </button>

                                        <button class="btn btn-primary mark-handled" data-id="{./id}" style="border-radius:4px;">
                                            ✓ [[simple-contact:admin.mark-handled]]
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            {{{ end }}}
                        </tbody>
                    </table>
                </div>
                {{{ else }}}
                <div class="alert alert-info text-center" style="border-radius:10px;">
                    [[simple-contact:admin.no-waiting]]
                </div>
                {{{ end }}}
            </div>
        </div>

        <hr style="opacity:.2;">

        <div class="panel panel-success shadow-sm" style="border:none; border-radius:12px;">
            <div class="panel-heading text-center" style="border-radius:12px 12px 0 0; font-weight:600;">
                [[simple-contact:admin.handled-title]]
            </div>

            <div class="panel-body" style="background:#fafafa;">
                {{{ if handledRequests.length }}}
                <div class="table-responsive">
                    <table class="table table-hover text-center" style="margin-bottom:0;">
                        <thead>
                            <tr>
                                <th class="text-center">[[simple-contact:admin.table.date]]</th>
                                <th class="text-center">[[simple-contact:admin.table.full-name]]</th>
                                <th class="text-center">[[simple-contact:admin.table.username]]</th>
                                <th class="text-center">[[simple-contact:admin.table.email]]</th>
                                <th class="text-center">[[simple-contact:admin.table.content]]</th>
                                <th class="text-center">[[simple-contact:admin.table.status]]</th>
                                <th class="text-center">[[simple-contact:admin.table.actions]]</th>
                            </tr>
                        </thead>
                        <tbody id="contact-list-handled">
                            {{{ each handledRequests }}}
                            <tr data-id="{./id}" class="text-center">
                                <td>{./date}</td>
                                <td><strong>{./fullName}</strong></td>
                                <td>
                                    {{{ if ./showChat }}}
                                        <a href="{config.relative_path}/admin/manage/users?searchBy=uid&query={./uid}&page=1&sortBy=lastonline" target="_blank" title="[[simple-contact:admin.manage-user]]">
                                            {./displayUsername}
                                        </a>
                                    {{{ else }}}
                                        {./displayUsername}
                                    {{{ end }}}
                                </td>
                                <td><a href="mailto:{./email}">{./email}</a></td>
                                <td style="max-width:260px;">
                                    <div class="toggle-text" style="white-space:nowrap; overflow:hidden; text-overflow:ellipsis; cursor:pointer;" title="[[simple-contact:admin.toggle-content]]">
                                        {./content}
                                    </div>
                                </td>
                                <td>
                                    <span class="label label-success" style="border-radius:10px; padding:3px 6px; font-size:11px;">[[simple-contact:admin.status.handled]]</span>
                                </td>
                                <td class="text-center">
                                    <button class="btn btn-xs btn-danger delete-request" data-id="{./id}" style="border-radius:14px; font-size:11px; padding:3px 8px;">
                                        × [[simple-contact:admin.delete]]
                                    </button>
                                </td>
                            </tr>
                            {{{ end }}}
                        </tbody>
                    </table>
                </div>
                {{{ else }}}
                <div class="alert alert-info text-center" style="border-radius:10px;">
                    [[simple-contact:admin.no-handled]]
                </div>
                {{{ end }}}
            </div>
        </div>
    </div>
</div>

<div id="emailReplyModal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">[[simple-contact:admin.email-modal-title]]</h4>
      </div>
      <div class="modal-body">
        <form id="emailReplyForm">
            <input type="hidden" id="reply-id" name="id">
            <input type="hidden" id="reply-to">
            <div class="form-group">
                <label>[[simple-contact:admin.subject]]</label>
                <input type="text" class="form-control" id="reply-subject" value="[[simple-contact:reply.default-subject]]">
            </div>
            <div class="form-group">
                <label>[[simple-contact:admin.message-content]]</label>
                <textarea class="form-control" id="reply-content" rows="6"></textarea>
            </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">[[modules:bootbox.cancel]]</button>
        <button type="button" class="btn btn-primary" id="send-reply-btn">[[simple-contact:admin.send-email]]</button>
      </div>
    </div>
  </div>
</div>

<div id="chatReplyModal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">[[simple-contact:admin.chat-modal-title]]</h4>
      </div>
      <div class="modal-body">
        <form id="chatReplyForm">
            <input type="hidden" id="chat-uid">
            <input type="hidden" id="chat-original-id"> <div class="form-group">
                <label>[[simple-contact:admin.chat-title]]</label>
                <input type="text" class="form-control" id="chat-title-input">
                <p class="help-block" style="font-size:12px;">[[simple-contact:admin.chat-title-help]]</p>
            </div>
            
            <div class="form-group">
                <label>[[simple-contact:admin.message]]</label>
                <textarea class="form-control" id="chat-message-input" rows="4"></textarea>
                <p class="help-block" style="font-size:12px;">[[simple-contact:admin.chat-message-help]]</p>
            </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">[[modules:bootbox.cancel]]</button>
        <button type="button" class="btn btn-success" id="create-chat-btn">
            <i class="fa fa-paper-plane"></i> [[simple-contact:admin.send-chat]]
        </button>
      </div>
    </div>
  </div>
</div>

