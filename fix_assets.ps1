$files = @("index.html", "about.html", "services.html", "contact.html", "sectors.html", "why-us.html")

foreach ($f in $files) {
    if (Test-Path $f) {
        $content = Get-Content $f -Raw
        
        # Remove broken CSS file links (e.g., /index_files/css and /index_files/css(1))
        $newContent = $content -replace '(?i)<link[^>]*href="(/[^"]*)?_files/css(\(1\))?"[^>]*>', ''
        
        # Remove broken wp-emoji script
        $newContent = $newContent -replace '(?i)<script[^>]*src="(/[^"]*)?_files/wp-emoji-release\.min\.js\.download"[^>]*>\s*</script>', ''
        
        # Write content back
        Set-Content $f -Value $newContent
        Write-Host "Processed $f"
    } else {
        Write-Host "File not found: $f"
    }
}
