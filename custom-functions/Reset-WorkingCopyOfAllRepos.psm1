
function __LoopSubfolders_ResetWorkingCopy([String] $Directory, [Int32] $MaxNestingLevel, [Int32] $NestingLevel)
{
    Write-Verbose -Message ""
    Write-Verbose -Message ("=====  " + $Directory)
    Write-Verbose -Message ""

    Set-Location $Directory
    Get-ChildItem -Path $Directory -Directory | ForEach-Object {
        $gitfolder = Join-Path -Path $_.FullName -ChildPath ".git"
        if (Test-Path $gitfolder)
        {
            Write-Verbose -Message ("- " + $_.Name + ": is a git repo => do reset")

            Set-Location $_.FullName
            Write-Host ""
            Write-Host ("> " + $_.FullName) -ForegroundColor Cyan
            Write-Host ""

            Write-Host "Check for local changes..." -ForegroundColor Magenta
            Invoke-Expression "git status --porcelain" | Tee-Object -Variable UncomittedChanges
            if ([string]::IsNullOrEmpty($UncomittedChanges) -eq $false)
            {
                Write-Host "Warning: This repo has local changes!" -ForegroundColor Yellow

                $decision = $Host.UI.PromptForChoice("Confirm reset", "Continue and loose the local changes?", ('&Yes', '&No'), 1)
                if ($decision -eq 0) {
                    Write-Host 'Continuing...'
                }
                else
                {
                    Write-Host 'Skipping this folder'
                    return
                }
            }
            else
            {
                Write-Host 'no local changes.'
            }

            Write-Host ""
            Write-Host "Delete all files" -ForegroundColor Magenta
            Get-ChildItem -Path $_.FullName -Directory | ForEach-Object {
                if ($_.Name -ne ".git" -and $_.Name -ne ".idea") {
                    [System.IO.Directory]::Delete($_.FullName, $true)
                }
            }
            Get-ChildItem -Path $_.FullName -File | ForEach-Object {
                [System.IO.File]::Delete($_.FullName)
            }

            Write-Host ""
            $GitCommand = "git reset --hard"
            Write-Host -Message $GitCommand -ForegroundColor Magenta
            Invoke-Expression $GitCommand

            Write-Host ""
            Write-Host ""
        }
        elseif ($NestingLevel -le $MaxNestingLevel)
        {
            Write-Verbose -Message ("- " + $_.Name + ": not a repo => check subfolders")
            $NextNestingLevel = $NestingLevel + 1
            __LoopSubfolders_ResetWorkingCopy $_.FullName $MaxNestingLevel $NextNestingLevel
        }
        else
        {
            Write-Verbose -Message ("- " + $_.Name + ": not a repo => max nesting reached")
        }
    }

    Write-Verbose ""
}

function Reset-WorkingCopyOfAllRepos([String] $Path, [Int32] $MaxNestingLevel = 1)
{
    $CurrentLocation = (Get-Location).path

    if ([string]::IsNullOrEmpty($Path)) {
        $Path = $CurrentLocation
    }

    Write-Verbose -Message $CurrentLocation

    try
    {
        __LoopSubfolders_ResetWorkingCopy $Path $MaxNestingLevel 0
    }
    finally
    {
        Set-Location $CurrentLocation
    }

    Write-Verbose -Message "Done."
}

Export-ModuleMember -Function Reset-WorkingCopyOfAllRepos
