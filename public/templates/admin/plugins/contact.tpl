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
                                <th class="text-center">[[simple-contact:admin.table.assigned]]</th>
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
                                <td style="max-width:220px;">
                                    <div class="toggle-text" style="white-space:nowrap; overflow:hidden; text-overflow:ellipsis; cursor:pointer;" title="[[simple-contact:admin.toggle-content]]">
                                        {./content}
                                    </div>
                                </td>
                                <td style="white-space:nowrap;">
                                    {{{ if ./assignedUsername }}}
                                        <span class="label label-info" style="border-radius:8px; font-size:11px;">{./assignedUsername}</span>
                                    {{{ else }}}
                                        <span style="color:#aaa; font-size:12px;">—</span>
                                    {{{ end }}}
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

                                        <button class="btn btn-default view-details" data-id="{./id}" style="margin-left:2px; border-radius:4px;" title="[[simple-contact:admin.details-tooltip]]">
                                            <i class="fa fa-sticky-note-o"></i>
                                            {{{ if ./commentCount }}}
                                                <span class="badge" style="background:#e74c3c; color:#fff;">{./commentCount}</span>
                                            {{{ end }}}
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
                                <th class="text-center">[[simple-contact:admin.table.assigned]]</th>
                                <th class="text-center">[[simple-contact:admin.table.handled-by]]</th>
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
                                <td style="max-width:220px;">
                                    <div class="toggle-text" style="white-space:nowrap; overflow:hidden; text-overflow:ellipsis; cursor:pointer;" title="[[simple-contact:admin.toggle-content]]">
                                        {./content}
                                    </div>
                                </td>
                                <td style="white-space:nowrap;">
                                    {{{ if ./assignedUsername }}}
                                        <span class="label label-info" style="border-radius:8px; font-size:11px;">{./assignedUsername}</span>
                                    {{{ else }}}
                                        <span style="color:#aaa; font-size:12px;">—</span>
                                    {{{ end }}}
                                </td>
                                <td style="white-space:nowrap; font-size:12px; color:#555;">
                                    {{{ if ./handledByUsername }}}
                                        {./handledByUsername}
                                    {{{ else }}}
                                        <span style="color:#aaa;">—</span>
                                    {{{ end }}}
                                </td>
                                <td>
                                    <span class="label label-success" style="border-radius:10px; padding:3px 6px; font-size:11px;">[[simple-contact:admin.status.handled]]</span>
                                </td>
                                <td class="text-center">
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-default view-details" data-id="{./id}" style="border-radius:4px;" title="[[simple-contact:admin.details-tooltip]]">
                                            <i class="fa fa-sticky-note-o"></i>
                                            {{{ if ./commentCount }}}
                                                <span class="badge" style="background:#e74c3c; color:#fff;">{./commentCount}</span>
                                            {{{ end }}}
                                        </button>
                                        <button class="btn btn-xs btn-danger delete-request" data-id="{./id}" style="border-radius:4px; font-size:11px; padding:4px 8px;">
                                            × [[simple-contact:admin.delete]]
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
                    [[simple-contact:admin.no-handled]]
                </div>
                {{{ end }}}
            </div>
        </div>
    </div>
</div>

<!-- Details / Notes / Assign Modal -->
<div id="detailsModal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"><i class="fa fa-sticky-note-o"></i> [[simple-contact:admin.details-modal-title]] — <span id="details-full-name"></span></h4>
      </div>
      <div class="modal-body" style="max-height:75vh; overflow-y:auto;">
        <input type="hidden" id="details-contact-id">

        <!-- Assign section -->
        <div class="panel panel-default" style="border-radius:8px;">
          <div class="panel-heading" style="border-radius:8px 8px 0 0; font-weight:600; font-size:13px;">
            <i class="fa fa-user-o"></i> [[simple-contact:admin.assign-section-title]]
          </div>
          <div class="panel-body" style="padding:10px 15px;">
            <div class="form-inline">
              <select id="assign-uid-select" class="form-control" style="min-width:180px; margin-left:8px;">
                <option value="0">— [[simple-contact:admin.not-assigned]] —</option>
              </select>
              <button id="assign-btn" class="btn btn-primary btn-sm" style="margin-right:8px;">
                <i class="fa fa-check"></i> [[simple-contact:admin.assign-btn]]
              </button>
              <span id="assign-current" style="font-size:12px; color:#777;"></span>
            </div>
          </div>
        </div>

        <!-- Comments section -->
        <div class="panel panel-default" style="border-radius:8px; margin-top:12px;">
          <div class="panel-heading" style="border-radius:8px 8px 0 0; font-weight:600; font-size:13px;">
            <i class="fa fa-commenting-o"></i> [[simple-contact:admin.comments-section-title]]
            <span class="badge" id="comments-badge" style="background:#888; margin-right:6px;">0</span>
          </div>
          <div class="panel-body" style="padding:10px 15px;">
            <div id="comments-list" style="margin-bottom:12px;"></div>
            <div class="input-group">
              <textarea id="new-comment-text" class="form-control" rows="2" placeholder="[[simple-contact:admin.comment-placeholder]]" style="resize:vertical; border-radius:6px 0 0 6px;"></textarea>
              <span class="input-group-btn" style="vertical-align:bottom;">
                <button id="add-comment-btn" class="btn btn-success" style="border-radius:0 6px 6px 0; height:100%;">
                  <i class="fa fa-plus"></i> [[simple-contact:admin.add-comment-btn]]
                </button>
              </span>
            </div>
          </div>
        </div>

        <!-- Activity log section -->
        <div class="panel panel-default" style="border-radius:8px; margin-top:12px;">
          <div class="panel-heading" style="border-radius:8px 8px 0 0; font-weight:600; font-size:13px;">
            <i class="fa fa-history"></i> [[simple-contact:admin.activity-section-title]]
          </div>
          <div class="panel-body" style="padding:10px 15px;">
            <div id="activity-list"></div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">[[modules:bootbox.cancel]]</button>
      </div>
    </div>
  </div>
</div>

<!-- Email Reply Modal -->
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

<!-- Chat Reply Modal -->
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
            <input type="hidden" id="chat-original-id">
            <div class="form-group">
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
