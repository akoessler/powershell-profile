$ExecuteTimedIndentation = 0;
function ExecuteTimed([String] $Title, [ConsoleColor] $Color, [bool] $NewLine, [ScriptBlock] $Script) {
    $Indent = " " * $ExecuteTimedIndentation
    $script:ExecuteTimedIndentation = $ExecuteTimedIndentation + 2;

    if ($NewLine) {
        Write-Host ($Indent + $Title + " ...") -ForegroundColor $Color
    } else {
        Write-Host ($Indent + $Title) -ForegroundColor $Color -NoNewline
    }

    $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    $Script.Invoke();

    $Stopwatch.Stop();

    if ($NewLine) {
        Write-Host ($Indent + "finished (" + $Stopwatch.ElapsedMilliseconds + "ms)") -ForegroundColor $Color
    } else {
        Write-Host (" - done (" + $Stopwatch.ElapsedMilliseconds + "ms)") -ForegroundColor $Color
    }

    $script:ExecuteTimedIndentation = $ExecuteTimedIndentation - 2;
}

ExecuteTimed "Loading profile" Cyan $True {

    ExecuteTimed "Imports" DarkMagenta $True {

        $ModulesToImport = @(
            "oh-my-posh"
            "Terminal-Icons"
            "PSColor"
            "Posh-SSH"
            "ZLocation"
            "PoShFuck"
            "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
        )

        foreach($ModuleToImport in $ModulesToImport) {
            ExecuteTimed ("Import " + $ModuleToImport) DarkGray $false {
                Import-Module $ModuleToImport
            }
        }

    }

    ExecuteTimed "Init" DarkMagenta $True {

        ExecuteTimed "Set Variables" DarkGray $False {
            Set-StrictMode -Version Latest
            $script:ProfileScriptDir = $PSScriptRoot;
            $env:POSH_GIT_ENABLED = $true
        }

        ExecuteTimed "Load oh-my-posh" DarkGray $false {
            Set-PoshPrompt -Theme $ProfileScriptDir\oh-my-posh-theme.json
        }

        ExecuteTimed "Load PSReadLine" DarkGray $false {
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
        }

    }

    ExecuteTimed "Load custom scripts" DarkMagenta $True {

        $CustomFunctionsScriptPath = "$ProfileScriptDir\custom-functions\"
        $CustomFunctionsScriptPathMachine = "$ProfileScriptDir\custom-functions\$env:COMPUTERNAME"

        if (Test-Path $customFunctionsScriptPathMachine) {
            $CustomFunctionsScripts = Get-ChildItem -File -Path $CustomFunctionsScriptPath,$CustomFunctionsScriptPathMachine
        } else {
            $CustomFunctionsScripts = Get-ChildItem -File -Path $CustomFunctionsScriptPath
        }

        foreach($CustomFunctionScript in $CustomFunctionsScripts) {
            $ScriptName = ($CustomFunctionScript.FullName -replace [regex]::Escape($CustomFunctionsScriptPath), "")
            ExecuteTimed ("Import " + $ScriptName) DarkGray $false {
                Import-Module $CustomFunctionScript.FullName
            }
        }

    }
}
