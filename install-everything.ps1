#Requires -RunAsAdministrator
#must be admin for chocolatey

function private:Header([String] $Title) {
    Write-Host ""
    Write-Host "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" -ForegroundColor Blue
    Write-Host ""
    Write-Host $Title -ForegroundColor Magenta
}

function private:Begin([String] $Title) {
    Write-Host ""
    Write-Host $Title -ForegroundColor Cyan
    Write-Host ""
    $script:Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
}

function private:End() {
    $script:Stopwatch.Stop()
    Write-Host ""
    Write-Host ("  ... finished: " + $script:Stopwatch.ElapsedMilliseconds + "ms") -ForegroundColor Green
    Write-Host ""
}

Header "Set global settings ..."

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

Header "Install PowerShell modules from gallery ..."

$ModulesToInstall = @(
    "PSColor"
    "PSReadLine"
    "PSScriptTools"
    "Terminal-Icons"
    "ZLocation"
    "Posh-SSH"
    "posh-git"
    "Chocolatey"
    "ExchangeOnlineManagement"
)

foreach($ModuleToInstall in $ModulesToInstall) {
    Begin "Install Module $ModuleToInstall"
    Install-Module -Force -Scope CurrentUser -AllowPrerelease -Verbose -Name $ModuleToInstall
    End
}

if ($IsLinux) {
    Write-Host "Skip PoShFuck, winget, chocolatey on linux." -ForegroundColor DarkRed
    exit
}

Header "Install PowerShell modules from direct source ..."

$ModulesToInstall = @(
    "https://raw.githubusercontent.com/mattparkes/PoShFuck/master/Install-TheFucker.ps1"
    "https://community.chocolatey.org/install.ps1"
)

foreach($ModuleToInstall in $ModulesToInstall) {
    Begin "Install module $ModuleToInstall"
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString($ModuleToInstall)) | Out-Host
    End
}

Header "Install winget modules ..."

$ModulesToInstall = @(
    "GitHub.cli"
    "GitHub.GitHubDesktop"
    "oh-my-posh"
    "gerardog.gsudo"
    "GnuWin32.Wget"
    "Python.Python.2"
    "Python.Python.3"
)

foreach($ModuleToInstall in $ModulesToInstall) {
    Begin "Install winget module $ModuleToInstall"
    winget install $ModuleToInstall --accept-package-agreements --accept-source-agreements | Out-Host
    End
}

Header "Install chocolatey modules ..."

$ModulesToInstall = @(
    "choco-upgrade-all-at-startup"
    "bat"
    "less"
)

foreach($ModuleToInstall in $ModulesToInstall) {
    Begin "Install chocolatey module $ModuleToInstall"
    choco install $ModuleToInstall -y -v | Out-Host
    End
}

Begin "Update chocolatey"
choco upgrade chocolatey -y -v | Out-Host
End

Begin "Update all chocolatey modules"
choco upgrade all -y -v | Out-Host
End

Header "Finished."
Write-Host ""
