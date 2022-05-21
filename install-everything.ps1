#Requires -RunAsAdministrator
#must be admin for chocolatey

function ExecuteTimed([String] $Title, [ConsoleColor] $Color, [ScriptBlock] $Script) {
    Write-Host ($Title + " ...") -ForegroundColor $Color
    $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    try {
        $Script.Invoke();
    }
    catch {
        Write-Host -ForegroundColor Red $_.Exception.Message
    }

    $Stopwatch.Stop();
    Write-Host ("finished (" + $Stopwatch.ElapsedMilliseconds + "ms)") -ForegroundColor $Color
}

ExecuteTimed "Set ExecutionPolicy" Cyan {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    Set-ExecutionPolicy RemoteSigned -Scope LocalMachine
    Set-ExecutionPolicy RemoteSigned -Scope MachinePolicy
}

ExecuteTimed "Set global options" Cyan {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12
}

ExecuteTimed "Install PowerShell modules from gallery" Cyan {
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
        Write-Host ""
        ExecuteTimed "Install Module $ModuleToInstall" DarkMagenta {
            Install-Module -Force -Scope CurrentUser -AllowPrerelease -Verbose -Name $ModuleToInstall
        }
        Write-Host ""
    }
}

# cannot install PoShFuck and choco on linux/wsl
if ($IsLinux) {
    exit
}

ExecuteTimed "Install PowerShell modules from direct source" Cyan {
    $ModulesToInstall = @(
        "https://raw.githubusercontent.com/mattparkes/PoShFuck/master/Install-TheFucker.ps1"
        "https://community.chocolatey.org/install.ps1"
    )

    foreach($ModuleToInstall in $ModulesToInstall) {
        Write-Host ""
        ExecuteTimed "Install module $ModuleToInstall" DarkMagenta {
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString($ModuleToInstall)) | Out-Host
        }
        Write-Host ""
    }
}

ExecuteTimed "Install winget modules" Cyan {
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
        Write-Host ""
        ExecuteTimed "Install winget module $ModuleToInstall" DarkMagenta {
            winget install $ModuleToInstall --accept-package-agreements | Out-Host
        }
        Write-Host ""
    }
}

ExecuteTimed "Install chocolatey modules" Cyan {
    $ModulesToInstall = @(
        "choco-upgrade-all-at-startup"
        "bat"
        "less"
        "dart-sdk"
    )

    foreach($ModuleToInstall in $ModulesToInstall) {
        Write-Host ""
        ExecuteTimed "Install chocolatey module $ModuleToInstall" DarkMagenta {
            choco install $ModuleToInstall -y -v | Out-Host
        }
        Write-Host ""
    }
}

ExecuteTimed "Update chocolatey" DarkMagenta {
    choco upgrade chocolatey -y -v | Out-Host
}

ExecuteTimed "Update all chocolatey modules" DarkMagenta {
    choco upgrade all -y -v | Out-Host
}
