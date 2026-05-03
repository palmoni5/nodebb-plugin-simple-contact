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

<script>
(function() {
    if (typeof define === 'function' && define.amd) {
        define('admin/plugins/contact', [], function() { return {}; });
    }

    function showMessage(type, msg) {
        const clean = msg.replace(/<[^>]*>/g, '');
        if (window.app && typeof window.app.require === 'function') {
            window.app.require('alerts').then(function(alerts) {
                type === 'success' ? alerts.success(clean) : alerts.error(clean);
            }).catch(function() { alert(clean); });
            return;
        }
        alert(clean);
    }

    function confirmBox(message, cb) {
        if (window.app && window.app.require) {
            window.app.require('bootbox').then(function(bootbox) {
                bootbox.confirm(message, cb);
            });
        } else if (window.bootbox) {
            window.bootbox.confirm(message, cb);
        } else {
            cb(confirm(message));
        }
    }

    function initContactPage() {
        
        $('.reply-chat').off('click').on('click', function(e) {
            e.preventDefault();
            var btn = $(this);
            var uid = btn.data('uid') || btn.attr('data-uid');
            var originalId = btn.closest('tr').attr('data-id');
            
            if (!uid || uid == 0) {
                return showMessage('error', '[[simple-contact:error.missing-uid]]');
            }

            var row = btn.closest('tr');
            var fullName = row.find('strong').text().trim(); 
            var contentDiv = row.find('.toggle-text');
            var rawContent = contentDiv.text().trim();
            var shortContent = rawContent.length > 50 ? rawContent.substring(0, 50) + '...' : rawContent;

            $('#chat-uid').val(uid);
            $('#chat-original-id').val(originalId);
            $('#chat-title-input').val('[[simple-contact:admin.default-chat-title]]');
            $('#chat-message-input').val('[[simple-contact:admin.default-chat-message]]');

            $('#chatReplyModal').modal('show');
        });

        $('#create-chat-btn').off('click').on('click', function() {
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
            .done(function(data) {
                $('#chatReplyModal').modal('hide');
                
                if (data && data.roomId) {
                    showMessage('success', '[[simple-contact:admin.chat-sent]]');
                    
                    // setTimeout(function() { ajaxify.refresh(); }, 1500);
                } else {
                    showMessage('error', '[[simple-contact:admin.missing-room-id]]');
                }
            })
            .fail(function(xhr) {
                var err = xhr.responseJSON ? xhr.responseJSON.error : '[[simple-contact:admin.chat-send-error]]';
                showMessage('error', err);
            })
            .always(function() {
                btn.prop('disabled', false);
            });
        });

        $('.reply-email').off('click').on('click', function() {
            var email = $(this).data('email');
            var id = $(this).data('id');
            $('#reply-to').val(email);
            $('#reply-id').val(id);
            $('#reply-content').val('');
            $('#emailReplyModal').modal('show');
        });

        $('#send-reply-btn').off('click').on('click', function() {
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
            .done(function(data) {
                $('#emailReplyModal').modal('hide');
                showMessage('success', '[[simple-contact:admin.email-sent]]');
                setTimeout(function() { ajaxify.refresh(); }, 1000);
            })
            .fail(function(xhr) {
                var err = xhr.responseJSON ? xhr.responseJSON.error : '[[simple-contact:admin.send-error]]';
                showMessage('error', err);
            })
            .always(function() {
                btn.prop('disabled', false);
            });
        });

        $('.mark-handled').off('click').on('click', function() {
            var id = $(this).data('id');
            confirmBox('[[simple-contact:admin.confirm-handle]]', function(ok) {
                if (ok) performHandle(id);
            });
        });

        $('.delete-request').off('click').on('click', function() {
            var id = $(this).data('id');
            confirmBox('[[simple-contact:admin.confirm-delete]]', function(ok) {
                if (ok) performDelete(id);
            });
        });

        $('.toggle-text').off('click').on('click', function() {
            var $el = $(this);
            if ($el.css('white-space') === 'nowrap') {
                $el.css({ 'white-space': 'normal', 'word-break': 'break-word', 'overflow': 'visible' });
            } else {
                $el.css({ 'white-space': 'nowrap', 'overflow': 'hidden', 'text-overflow': 'ellipsis' });
            }
        });

        $('.modal').on('click', '[data-dismiss="modal"]', function(e) {
            e.preventDefault();
            $(this).closest('.modal').modal('hide');
        });
    }

    function performHandle(id) {
        $.post(config.relative_path + '/api/admin/plugins/contact/handle', { id: id, _csrf: config.csrf_token }).done(function(data) { if (data.success) { showMessage('success', '[[simple-contact:admin.handled-success]]'); ajaxify.refresh(); } }).fail(function() { showMessage('error', '[[simple-contact:admin.handle-error]]'); });
    }

    function performDelete(id) {
        $.post(config.relative_path + '/api/admin/plugins/contact/delete', { id: id, _csrf: config.csrf_token }).done(function(data) { if (data.success) { showMessage('success', '[[simple-contact:admin.deleted-success]]'); ajaxify.refresh(); } }).fail(function() { showMessage('error', '[[simple-contact:admin.delete-error]]'); });
    }

    $(document).ready(initContactPage);
    $(window).on('action:ajaxify.end', function(e, data) {
        if (data.tpl_url === 'admin/plugins/contact') {
            initContactPage();
        }
    });
})();
</script>
