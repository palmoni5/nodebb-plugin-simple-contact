{{{ if error }}}
<div style="color:#c00; font-size:13px; text-align:center;">{{tx("simple-contact:error.internal")}}</div>
{{{ end }}}
{{{ if !error }}}
{{{ if !comments.length }}}
<div style="color:#aaa; font-size:13px; text-align:center;">{{tx("simple-contact:admin.no-comments")}}</div>
{{{ end }}}
{{{ each comments }}}
<div class="contact-comment" data-comment-id="{./id}" style="background:#fffbe6; border-right:3px solid #f0c040; padding:8px 12px; border-radius:4px; margin-bottom:8px;">
	<div style="font-size:12px; color:#888; margin-bottom:4px;">
		<strong>{./username}</strong> &middot; {./date}
		<button class="btn btn-xs btn-link delete-comment-btn" data-id="{./contactId}" data-comment-id="{./id}" style="color:#c0392b; padding:0 4px; float:left;">
			<i class="fa fa-trash-o"></i>
		</button>
	</div>
	<div style="white-space:pre-wrap; word-break:break-word;">{./content}</div>
</div>
{{{ end }}}
{{{ end }}}
