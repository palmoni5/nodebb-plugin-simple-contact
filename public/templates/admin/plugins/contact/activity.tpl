{{{ if !activity.length }}}
<div style="color:#aaa; font-size:13px; text-align:center;">{{tx("simple-contact:admin.no-activity")}}</div>
{{{ end }}}
{{{ each activity }}}
<div style="padding:5px 0; border-bottom:1px solid #f0f0f0; font-size:13px;">
	<i class="fa {./icon} {./cls}" style="width:18px;"></i>
	<strong>{./username}</strong> &mdash;
	{{{ if ./assigned }}}
	{{tx("simple-contact:admin.activity.assigned")}}
	{{{ if ./toUsername }}}<strong>{./toUsername}</strong>{{{ end }}}
	{{{ if !./toUsername }}}<strong>{{tx("simple-contact:admin.not-assigned")}}</strong>{{{ end }}}
	{{{ end }}}
	{{{ if !./assigned }}}
	{{tx(./labelKey)}}
	{{{ end }}}
	<span style="color:#aaa; font-size:11px; margin-right:6px;">{./date}</span>
</div>
{{{ end }}}
