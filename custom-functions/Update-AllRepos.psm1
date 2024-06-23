Import-Module $PSScriptRoot/Invoke-Recursive.psm1 -Force

# Update all git repositories in all folders recursively.
function Update-AllRepos(
    [String] $Path = $null,
    [Int32] $MaxNestingLevel = 1,
    [switch] $Verbose = $false
)
{
    UpdateRepos -Path $Path -SwitchToDefault $false -MaxNestingLevel $MaxNestingLevel -Verbose:$Verbose
}

# Update all git repositories in all folders recursively and switch to the default branch.
function Update-AllReposSwitchToDefault(
    [String] $Path = $null,
    [Int32] $MaxNestingLevel = 1,
    [switch] $Verbose = $false
)
{
    UpdateRepos -Path $Path -SwitchToDefault $true -MaxNestingLevel $MaxNestingLevel -Verbose:$Verbose
}

Set-Alias -Name pullall -Value Update-AllRepos
Set-Alias -Name pullalldefault -Value Update-AllReposSwitchToDefault
Set-Alias -Name pullallmain -Value Update-AllReposSwitchToDefault

Export-ModuleMember -Function Update-AllRepos -Alias pullall
Export-ModuleMember -Function Update-AllReposSwitchToDefault -Alias pullalldefault, pullallmain


##############################
# Private functions
##############################


$DefaultBranchName = "main"

function UpdateRepos(
    [String] $Path,
    [Boolean] $SwitchToDefault = $false,
    [Int32] $MaxNestingLevel = 1,
    [switch] $Verbose = $false
)
{
    Invoke-AllGitFolders -Path $Path -MaxNestingLevel $MaxNestingLevel -Verbose:$Verbose -ScriptBlock {
        Write-Host ""
        Write-Host "git branch --show-current" -ForegroundColor Cyan
        $currentBranch = git branch --show-current
        Write-Host ("current branch: " + $currentBranch) -ForegroundColor Yellow

        if ($SwitchToDefault)
        {
            $defaultBranch = git config init.defaultBranch
            if ([string]::IsNullOrEmpty($defaultBranch))
            {
                $defaultBranch = $DefaultBranchName
            }

            if ($currentBranch -eq $defaultBranch)
            {
                Write-Host "already default branch" -ForegroundColor Green
            }
            else
            {
                Write-Host ""
                Write-Host ("git switch " + $defaultBranch) -ForegroundColor Cyan
                $result = git switch $defaultBranch 2>&1 | Format-List | Out-String
                Write-Host $result

                Write-Host ""
                Write-Host "git branch --show-current" -ForegroundColor Cyan
                $currentBranch = git branch --show-current
                Write-Host ("now branch: " + $currentBranch) -ForegroundColor Yellow
                if ($currentBranch -ne $defaultBranch)
                {
                    throw "git switch $defaultBranch failed"
                }
            }
        }

        Write-Host ""
        Write-Host "git pull" -ForegroundColor Cyan
        $result = git pull 2>&1 | Format-List | Out-String
        Write-Host $result
        if ($result -match "(error:|fatal:|Aborting|There is no tracking information for the current branch)")
        {
            throw "git pull failed"
        }
    }
}
