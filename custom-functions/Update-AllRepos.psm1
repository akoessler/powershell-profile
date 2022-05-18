
function __LoopSubfolders_updaterepos([String] $Directory, [Boolean] $CheckoutDefaultBranch = $false, [Int32] $MaxNestingLevel, [Int32] $NestingLevel)
{
    Write-Verbose -Message ""
    Write-Verbose -Message ("=====  " + $Directory)
    Write-Verbose -Message ""

    Set-Location $Directory
    Get-ChildItem -Path $Directory -Directory | ForEach-Object {
        $gitfolder = Join-Path -Path $_.FullName -ChildPath ".git"
        if (Test-Path $gitfolder)
        {
            Write-Verbose -Message ("- " + $_.Name + ": is a git repo => do update")

            Set-Location $_.FullName
            Write-Host ""
            Write-Host ("> " + $_.FullName) -ForegroundColor Cyan

            Write-Host ""
            Invoke-Expression "git branch --show-current" | Tee-Object -Variable BranchName | out-null

            Write-Host ("current branch: " + $BranchName) -ForegroundColor Yellow

            if ($CheckoutDefaultBranch)
            {
                Invoke-Expression "git config init.defaultBranch" | Tee-Object -Variable DefaultBranchName | out-null
                if ([string]::IsNullOrEmpty($DefaultBranchName))
                {
                    $DefaultBranchName = "master"
                }

                if ($BranchName -eq $DefaultBranchName)
                {
                    Write-Host "already default branch" -ForegroundColor Green
                }
                else
                {
                    $GitCommand = ("git checkout " + $DefaultBranchName)
                    Write-Host $GitCommand -ForegroundColor Magenta
                    Invoke-Expression $GitCommand
                }

                Write-Host ""
            }

            $GitCommand = "git pull"
            Write-Host -Message $GitCommand -ForegroundColor Magenta
            Invoke-Expression $GitCommand

            Write-Host ""
        }
        elseif ($NestingLevel -le $MaxNestingLevel)
        {
            Write-Verbose -Message ("- " + $_.Name + ": not a repo => check subfolders")
            $NextNestingLevel = $NestingLevel + 1
            __LoopSubfolders_updaterepos $_.FullName $MaxNestingLevel $NextNestingLevel
        }
        else
        {
            Write-Verbose -Message ("- " + $_.Name + ": not a repo => max nesting reached")
        }
    }

    Write-Verbose ""
}

function Update-AllRepos([String] $Path, [Boolean] $CheckoutDefaultBranch = $false, [Int32] $MaxNestingLevel = 1)
{
    $CurrentLocation = (Get-Location).path

    if ([string]::IsNullOrEmpty($Path)) {
        $Path = $CurrentLocation
    }

    Write-Verbose -Message $CurrentLocation

    try
    {
        __LoopSubfolders_updaterepos $Path $CheckoutDefaultBranch $MaxNestingLevel 0
    }
    finally
    {
        Set-Location $CurrentLocation
    }

    Write-Verbose -Message "Done."
}

function Update-AllReposAndCheckoutDefaultBranch([String] $Path)
{
    Update-AllRepos $Path $true
}

Set-Alias -Name pullall -Value Update-AllRepos
Set-Alias -Name pullallmaster -Value Update-AllReposAndCheckoutDefaultBranch

Export-ModuleMember -Function Update-AllRepos -Alias pullall
Export-ModuleMember -Function Update-AllReposAndCheckoutDefaultBranch -Alias pullallmaster
