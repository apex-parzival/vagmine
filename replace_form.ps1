$files = @("index.html", "about.html", "services.html", "contact.html", "sectors.html", "why-us.html")
$replacement = @"
<div class="custom-contact-form" style="width: 100%; max-width: 100%;">
    <script>
    function sendContactEmail(e, form) {
        e.preventDefault();
        var name = form.querySelector('[name="user-name"]').value;
        var email = form.querySelector('[name="user-email"]').value;
        var msg = form.querySelector('[name="user-message"]').value;
        var subject = "Website Inquiry - Vagmine Biz Solutions";
        var body = "Hello Lokesh,\n\nI would like to get in touch regarding your IT services.\n\nName: " + name + "\nEmail: " + email + "\n\nMessage:\n" + msg;
        window.location.href = "mailto:lokesh@vagminebiz.com?subject=" + encodeURIComponent(subject) + "&body=" + encodeURIComponent(body);
    }
    </script>
    <form class="wpcf7-form" onsubmit="sendContactEmail(event, this)">
        <p>
            <span class="wpcf7-form-control-wrap">
                <input class="wpcf7-form-control wpcf7-text" required name="user-name" placeholder="Your name" type="text" style="width: 100%; margin-bottom: 15px; padding: 10px; border: 1px solid #ddd;" />
            </span><br />
            <span class="wpcf7-form-control-wrap">
                <input class="wpcf7-form-control wpcf7-email" required name="user-email" placeholder="Your email" type="email" style="width: 100%; margin-bottom: 15px; padding: 10px; border: 1px solid #ddd;" />
            </span><br />
            <span class="wpcf7-form-control-wrap">
                <textarea class="wpcf7-form-control wpcf7-textarea" required name="user-message" placeholder="Your message" rows="6" style="width: 100%; padding: 10px; border: 1px solid #ddd;"></textarea>
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
        $newContent = $content -replace '(?s)<div class="wpcf7 js"(.*?)</div>\s*</form>\s*</div>', $replacement
        Set-Content $f -Value $newContent
        Write-Host "Replaced form in $f"
    }
}
