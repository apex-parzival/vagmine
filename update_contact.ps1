$files = @("index.html", "about.html", "services.html", "contact.html", "sectors.html", "why-us.html")
$replacement = @"
<div class="custom-contact-form" style="width: 100%; max-width: 100%;">
    <form class="wpcf7-form" action="https://formsubmit.co/lokesh@vagminebiz.com" method="POST">
        <input type="hidden" name="_subject" value="Website Inquiry - Vagmine Biz Solutions">
        <input type="hidden" name="_captcha" value="false">
        <p>
            <span class="wpcf7-form-control-wrap">
                <input class="wpcf7-form-control wpcf7-text" required name="Name" placeholder="Your name" type="text" style="width: 100%; margin-bottom: 15px; padding: 10px; border: 1px solid #ddd;" />
            </span><br />
            <span class="wpcf7-form-control-wrap">
                <input class="wpcf7-form-control wpcf7-email" required name="email" placeholder="Your email" type="email" style="width: 100%; margin-bottom: 15px; padding: 10px; border: 1px solid #ddd;" />
            </span><br />
            <span class="wpcf7-form-control-wrap">
                <textarea class="wpcf7-form-control wpcf7-textarea" required name="Message" placeholder="Your message" rows="6" style="width: 100%; padding: 10px; border: 1px solid #ddd;"></textarea>
            </span><br />
            <br>
            <input class="wpcf7-form-control wpcf7-submit" type="submit" value="Send message" style="background-color: #FAA524; color: white; border: none; padding: 10px 20px; font-weight: bold; cursor: pointer; border-radius: 4px;" />
        </p>
    </form>
</div>
"@

foreach ($f in $files) {
    if (Test-Path $f) {
        $content = Get-Content $f -Raw
        $newContent = $content -replace '(?s)<div class="custom-contact-form".*?</div>', $replacement
        Set-Content $f -Value $newContent
        Write-Host "Updated contact form in $f"
    }
}
