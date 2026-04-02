$files = @("index.html", "about.html", "services.html", "contact.html", "sectors.html", "why-us.html")
$newForm = '<form class="wpcf7-form" action="https://api.web3forms.com/submit" method="POST">
  <input type="hidden" name="access_key" value="bb0f1e09-f838-477e-a739-dd94e9ddc493">'

foreach ($f in $files) {
    if (Test-Path $f) {
        $content = Get-Content $f -Raw
        $newContent = $content -replace '(?i)<form\s+class="wpcf7-form"\s+action="https://formsubmit\.co/[^"]*"\s+method="POST">', $newForm
        Set-Content $f -Value $newContent
        Write-Host "Updated templates in $f"
    } else {
        Write-Host "File not found: $f"
    }
}
