function private:Header([String] $Title) {
    Write-Host $Title -ForegroundColor Magenta
}

function private:Begin([String] $Title) {
    Write-Host $Title -ForegroundColor Gray -NoNewline
    $script:Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
}

function private:End() {
    $script:Stopwatch.Stop()
    Write-Host " - done: $($script:Stopwatch.ElapsedMilliseconds)ms" -ForegroundColor DarkGreen
}

$ProfileScriptDir = $PSScriptRoot;
$env:POSH_GIT_ENABLED = $true

Header "Import modules ..."

$ModulesToImport = @(
    "Terminal-Icons"
    "PSColor"
    "Posh-SSH"
    "ZLocation"
    "Chocolatey"
    "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
)

if ($IsWindows) {
    $WindowsOnlyModules = @(
        "posh-git"
        "PoShFuck"
    )
    $ModulesToImport = $WindowsOnlyModules + $ModulesToImport
}

foreach($ModuleToImport in $ModulesToImport) {
    Begin "Import $ModuleToImport"
    Import-Module $ModuleToImport
    End
}

Header "Load custom scripts ..."

$Hostname = [system.environment]::MachineName
$CustomFunctionsScriptPath = "$ProfileScriptDir\custom-functions\"
$CustomFunctionsScriptPathMachine = "$ProfileScriptDir\custom-functions\$Hostname"

if (Test-Path $customFunctionsScriptPathMachine) {
    $CustomFunctionsScripts = Get-ChildItem -File -Filter *.psm1 -Path $CustomFunctionsScriptPath,$CustomFunctionsScriptPathMachine
} else {
    $CustomFunctionsScripts = Get-ChildItem -File -Filter *.psm1 -Path $CustomFunctionsScriptPath
}

foreach($CustomFunctionScript in $CustomFunctionsScripts) {
    Begin "Import $($CustomFunctionScript.Directory.BaseName)/$($CustomFunctionScript.BaseName)"
    Import-Module $CustomFunctionScript.FullName
    End
}

Header "Load special tools ..."

Begin "Load oh-my-posh"
oh-my-posh init pwsh --config $ProfileScriptDir\oh-my-posh-theme.json | Invoke-Expression
End

Begin "Load PSReadLine"
if ($host.Name -eq 'ConsoleHost') {
    Import-Module PSReadLine
    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineKeyHandler -Key Ctrl+UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key Ctrl+DownArrow -Function HistorySearchForward
} else {
    Write-Host " - skipped" - -ForegroundColor DarkGray -NoNewline
}
End

Header "Finished."
Write-Host ""
