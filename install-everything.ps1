
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine
Set-ExecutionPolicy RemoteSigned -Scope MachinePolicy

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12

Install-Module -Force -Scope AllUsers -AllowPrerelease -Name PSColor
Install-Module -Force -Scope AllUsers -AllowPrerelease -Name PSReadLine
Install-Module -Force -Scope AllUsers -AllowPrerelease -Name PSScriptTools
Install-Module -Force -Scope AllUsers -AllowPrerelease -Name Terminal-Icons
Install-Module -Force -Scope AllUsers -AllowPrerelease -Name ZLocation
Install-Module -Force -Scope AllUsers -AllowPrerelease -Name PoShFuck
Install-Module -Force -Scope AllUsers -AllowPrerelease -Name Posh-SSH
Install-Module -Force -Scope AllUsers -AllowPrerelease -Name posh-git
Install-Module -Force -Scope AllUsers -AllowPrerelease -Name oh-my-posh

Invoke-Expression ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/mattparkes/PoShFuck/master/Install-TheFucker.ps1'))

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install choco-upgrade-all-at-startup
choco install sudo
choco install bat
