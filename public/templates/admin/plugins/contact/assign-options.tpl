<option value="0">&mdash; {{tx("simple-contact:admin.not-assigned")}} &mdash;</option>
{{{ each admins }}}
<option value="{./uid}"{{{ if ./selected }}} selected{{{ end }}}>{./username}</option>
{{{ end }}}
