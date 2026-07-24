$ErrorActionPreference = "Stop"
$webRoot = "C:\Users\Dam\.gemini\antigravity\scratch\adam-portfolio"
$port = 3000

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:${port}/")
$listener.Start()

Write-Host ""
Write-Host "=========================================="
Write-Host "  WEB AKTIF di: http://localhost:$port"  
Write-Host "=========================================="
Write-Host ""

while ($true) {
    $context = $listener.GetContext()
    $localPath = $context.Request.Url.LocalPath
    if ($localPath -eq "/") { $localPath = "/index.html" }
    
    $filePath = Join-Path $webRoot ($localPath.TrimStart("/"))
    
    if (Test-Path $filePath) {
        $content = [System.IO.File]::ReadAllBytes($filePath)
        $context.Response.ContentType = "text/html; charset=utf-8"
        $context.Response.ContentLength64 = $content.Length
        $context.Response.StatusCode = 200
        $context.Response.OutputStream.Write($content, 0, $content.Length)
        Write-Host "[OK] $localPath"
    } else {
        $context.Response.StatusCode = 404
        Write-Host "[404] $localPath"
    }
    $context.Response.OutputStream.Close()
}
