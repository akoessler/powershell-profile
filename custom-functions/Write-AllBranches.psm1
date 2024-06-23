Import-Module $PSScriptRoot/Invoke-Recursive.psm1 -Force

# Output the current branch of all git repositories recursively.
function Write-AllBranches(
    [String] $Path = $null,
    [Int32] $MaxNestingLevel = 1,
    [switch] $Verbose = $false
)
{
    $mainBranches = ("main", "master")
    $allowedBranches = ("develop", "stable", "release-test")

    Invoke-AllGitFolders -Path $Path -MaxNestingLevel $MaxNestingLevel -Verbose:$Verbose -ScriptBlock {
        $branchName = git branch --show-current

        if ($mainBranches.Contains($branchName))
        {
            Write-Host ("- ok: " + $branchName) -ForegroundColor Green
        }
        elseif ($allowedBranches.Contains($branchName))
        {
            Write-Host ("- ok: " + $branchName) -ForegroundColor Yellow
        }
        else
        {
            throw "not main: " + $branchName
        }
    }
}

Set-Alias -Name printbranches -Value Write-AllBranches
Set-Alias -Name writebranches -Value Write-AllBranches

Export-ModuleMember -Function Write-AllBranches -Alias printbranches, writebranches
