Import-Module $PSScriptRoot/Invoke-Recursive.psm1 -Force

# Reset the working copy of all git repositories in all folders recursively.
# Attention! This is a destructive operation and will delete all uncommitted changes!
function Reset-WorkingCopyOfAllRepos(
    [String] $Path = $null,
    [Int32] $MaxNestingLevel = 1,
    [switch] $Verbose = $false
)
{
    ResetRepos -Path $Path -SwitchToDefault $false -MaxNestingLevel $MaxNestingLevel -Verbose:$Verbose
}

Export-ModuleMember -Function Reset-WorkingCopyOfAllRepos


##############################
# Private functions
##############################


function ResetRepos(
    [String] $Path,
    [Int32] $MaxNestingLevel = 1,
    [switch] $Verbose = $false
)
{
    $foldersToKeep = (".git", ".idea")

    Invoke-AllGitFolders -Path $Path -MaxNestingLevel $MaxNestingLevel -Verbose:$Verbose -ScriptBlock {

        Write-Host "Check for local changes..." -ForegroundColor Cyan
        $uncomittedChanges = git status --porcelain 2>&1 | Format-List | Out-String
        if ([string]::IsNullOrEmpty($uncomittedChanges) -eq $false)
        {
            Write-Host "Warning: This repo has local changes!" -ForegroundColor Yellow
            Write-Host $uncomittedChanges

            $decision = $Host.UI.PromptForChoice("Confirm reset", "Continue and loose the local changes?", ('&Yes', '&No'), 1)
            if ($decision -eq 0)
            {
                Write-Host 'Continuing...' -ForegroundColor DarkYellow
            }
            else
            {
                Write-Host 'Skipping this folder' -ForegroundColor DarkYellow
                return
            }
        }
        else
        {
            Write-Host 'no local changes.' -ForegroundColor DarkGreen
        }

        Write-Host ""
        Write-Host "Delete all files..." -ForegroundColor Cyan
        Get-ChildItem -Directory | ForEach-Object {
            if ($foldersToKeep.Contains($_.Name))
            {
                [System.IO.Directory]::Delete($_.FullName, $true)
            }
        }
        Get-ChildItem -File | ForEach-Object {
            [System.IO.File]::Delete($_.FullName)
        }
        Write-Host "Done." -ForegroundColor Green

        Write-Host ""
        Write-Host "git reset --hard" -ForegroundColor Cyan
        $result = git reset --hard 2>&1 | Format-List | Out-String

        Write-Host $result
        Write-Host ""
        Write-Host ""
    }
}
