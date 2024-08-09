# serve.ps1
$process = Start-Process python -ArgumentList '-m http.server 8000 --directory docs' -NoNewWindow -PassThru -RedirectStandardOutput 'server_log.txt' -RedirectStandardError 'server_error_log.txt'
Start-Sleep -Seconds 30
Stop-Process -Id $process.Id

# Retry mechanism for writing to log file
$logMessage = 'Server stopped after 30 seconds.'
$logFile = 'server_log_temp.txt'
$logFileMain = 'server_log.txt'
$maxRetries = 5
$retryCount = 0
$success = $false

# Write stop message to temporary file
Write-Output $logMessage | Out-File -Append $logFile

while (-not $success -and $retryCount -lt $maxRetries) {
    try {
        Start-Sleep -Seconds 2
        # Append content from temporary log file to main log file
        Get-Content $logFile | Out-File -Append $logFileMain
        $success = $true
    } catch {
        $retryCount++
    }
}

# Remove the temporary log file
Remove-Item $logFile

# Retry mechanism for logging server start message
$retryCount = 0
$success = $false

while (-not $success -and $retryCount -lt $maxRetries) {
    try {
        Start-Sleep -Seconds 2
        Write-Output 'Server started on port 8000.' | Out-File -Append $logFileMain
        $success = $true
    } catch {
        $retryCount++
    }
}

# Output the content of the log file
Get-Content $logFileMain
