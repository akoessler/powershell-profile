Write-Host "Loading profile ..." -ForegroundColor Cyan
$StopwatchProfile = [System.Diagnostics.Stopwatch]::StartNew()


Write-Host "  Init basic stuff ..." -ForegroundColor DarkYellow
$StopwatchInit = [System.Diagnostics.Stopwatch]::StartNew()


Write-Host "    Import modules" -NoNewLine -ForegroundColor DarkGray
$StopwatchInitDetail = [System.Diagnostics.Stopwatch]::StartNew()

Import-Module posh-git -Global
Import-Module oh-my-posh -Global
Import-Module Terminal-Icons -Global

Write-Host (" - done (" + $StopwatchInitDetail.ElapsedMilliseconds + "ms)") -ForegroundColor DarkGray


Write-Host "    Set settings" -NoNewLine -ForegroundColor DarkGray
$StopwatchInitDetail = [System.Diagnostics.Stopwatch]::StartNew()


Set-StrictMode -Version Latest

$ProfileScriptDir = $PSScriptRoot;
$env:POSH_GIT_ENABLED = $true


Write-Host (" - done (" + $StopwatchInitDetail.ElapsedMilliseconds + "ms)") -ForegroundColor DarkGray


Write-Host "    Load oh-my-posh" -NoNewLine -ForegroundColor DarkGray
$StopwatchInitDetail = [System.Diagnostics.Stopwatch]::StartNew()

Set-PoshPrompt -Theme $ProfileScriptDir\oh-my-posh-theme.json

Write-Host (" - done (" + $StopwatchInitDetail.ElapsedMilliseconds + "ms)") -ForegroundColor DarkGray


Write-Host "    Load PSReadLine" -NoNewLine -ForegroundColor DarkGray
$StopwatchInitDetail = [System.Diagnostics.Stopwatch]::StartNew()

if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine
    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineKeyHandler -Key Ctrl+UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key Ctrl+DownArrow -Function HistorySearchForward
    Write-Host (" - done (" + $StopwatchInitDetail.ElapsedMilliseconds + "ms)") -ForegroundColor DarkGray
}
else {
    Write-Host (" - skipped (" + $StopwatchInitDetail.ElapsedMilliseconds + "ms)") -ForegroundColor DarkGray
}


Write-Host ("  Init finished (" + $StopwatchInit.ElapsedMilliseconds + "ms)") -ForegroundColor DarkGreen


Write-Host "  Load custom scripts ..." -ForegroundColor DarkYellow
$StopwatchScripts = [System.Diagnostics.Stopwatch]::StartNew()

$customFunctionsScriptPath = "$ProfileScriptDir\custom-functions\"
$customFunctionsScriptPathMachine = "$ProfileScriptDir\custom-functions\$env:COMPUTERNAME"

if (Test-Path $customFunctionsScriptPathMachine) {
    $customFunctionsScripts = Get-ChildItem -File -Path $customFunctionsScriptPath,$customFunctionsScriptPathMachine
} else {
    $customFunctionsScripts = Get-ChildItem -File -Path $customFunctionsScriptPath
}

foreach($script in $customFunctionsScripts) {
    $scriptName = ($script.FullName -replace [regex]::Escape($customFunctionsScriptPath), "")
    Write-Host "    Import $scriptName" -NoNewLine -ForegroundColor DarkGray
    $StopwatchImport = [System.Diagnostics.Stopwatch]::StartNew()
    Import-Module $script.FullName
    Write-Host (" - done (" + $StopwatchImport.ElapsedMilliseconds + "ms)") -ForegroundColor DarkGray
}

Write-Host ("  Custom scripts finished (" + $StopwatchScripts.ElapsedMilliseconds + "ms)") -ForegroundColor DarkGreen


Write-Host ("Profile load complete (" + $StopwatchProfile.ElapsedMilliseconds + "ms)") -ForegroundColor Cyan
Write-Host ""
