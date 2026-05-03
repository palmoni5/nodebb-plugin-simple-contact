<div style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; direction: [[language:dir]]; text-align: start; background-color: #f9f9f9; padding: 20px;">
    
    <div style="text-align: center; margin-bottom: 30px;">
        {{{ if brand:emailLogo }}}
            <img src="{url}{brand:emailLogo}" alt="{site_title}" style="max-height: 60px; border: 0;">
        {{{ else }}}
            <img src="{url}{brand:logo}" alt="{site_title}" style="max-height: 60px; border: 0;">
        {{{ end }}}
            <h1 style="color: #333;">{site_title}</h1>
            </div>

    <div style="background-color: #ffffff; border: 1px solid #e0e0e0; border-radius: 8px; padding: 30px; max-width: 600px; margin: 0 auto; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
        
        <h2 style="margin-top: 0; color: #333; font-size: 20px; border-bottom: 1px solid #eee; padding-bottom: 15px;">
            [[simple-contact:email.greeting]]
        </h2>

        <div style="font-size: 16px; color: #444; line-height: 1.6; margin-top: 20px;">
            {body}
        </div>

    </div>

    <div style="text-align: center; margin-top: 20px; font-size: 12px; color: #999;">
        [[simple-contact:email.footer, {url}, {site_title}]]
    </div>

</div>
