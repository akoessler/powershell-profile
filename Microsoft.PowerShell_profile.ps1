Write-Host "Loading profile ..."

Import-Module posh-git
Import-Module oh-my-posh

Set-StrictMode -Version Latest

$ProfileScriptDir = $PSScriptRoot;

Set-PoshPrompt -Theme $ProfileScriptDir\oh-my-posh-theme.json

if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine
    Set-PSReadLineKeyHandler -Key Ctrl+UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key Ctrl+DownArrow -Function HistorySearchForward
}

Write-Host "Load custom scripts ..."

$customFunctionsScriptPath = "$ProfileScriptDir\custom-functions\"
$customFunctionsScriptPathMachine = "$ProfileScriptDir\custom-functions\$env:COMPUTERNAME"

if (Test-Path $customFunctionsScriptPathMachine) {
    $customFunctionsScripts = Get-ChildItem -File -Path $customFunctionsScriptPath,$customFunctionsScriptPathMachine
} else {
    $customFunctionsScripts = Get-ChildItem -File -Path $customFunctionsScriptPath
}

foreach($script in $customFunctionsScripts) {
    $scriptName = ($script.FullName -replace [regex]::Escape($customFunctionsScriptPath), "")
    Write-Host "  Import $scriptName"
    Import-Module $script.FullName
}

Write-Host "Profile load complete." -ForegroundColor Green
Write-Host ""
