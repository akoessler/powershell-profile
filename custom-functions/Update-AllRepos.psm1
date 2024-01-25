
function __LoopSubfolders_updaterepos(
    [String] $Directory,
    [Boolean] $CheckoutDefaultBranch = $false,
    [Int32] $MaxNestingLevel,
    [Int32] $NestingLevel,
    [System.Collections.Generic.List[System.String]] $FailedFolders)
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
            $BranchName = git branch --show-current

            Write-Host ("current branch: " + $BranchName) -ForegroundColor Yellow

            if ($CheckoutDefaultBranch)
            {
                $DefaultBranchName = git config init.defaultBranch
                if ([string]::IsNullOrEmpty($DefaultBranchName))
                {
                    $DefaultBranchName = "main"
                }

                if ($BranchName -eq $DefaultBranchName)
                {
                    Write-Host "already default branch" -ForegroundColor Green
                }
                else
                {
                    Write-Host -Message ("git checkout " + $DefaultBranchName) -ForegroundColor Magenta
                    git checkout $DefaultBranchName
                }

                Write-Host ""
            }

            $GitCommand = "git pull"
            Write-Host -Message $GitCommand -ForegroundColor Magenta
            git pull 2>&1 | Tee-Object -Variable GitPullOutput

            #Write-Host -Message $GitPullOutput -ForegroundColor Blue
            if ($GitPullOutput -match "(error:|fatal:|Aborting)")
            {
                Write-Host -Message ("Pull failed: " + $_.FullName) -ForegroundColor Red
                $FailedFolders.Add($_.FullName)
            }
            else
            {
                Write-Host -Message ("Pull successful: " + $_.FullName) -ForegroundColor Green
            }

            Write-Host ""
        }
        elseif ($NestingLevel -le $MaxNestingLevel)
        {
            Write-Verbose -Message ("- " + $_.Name + ": not a repo => check subfolders")
            $NextNestingLevel = $NestingLevel + 1
            __LoopSubfolders_updaterepos $_.FullName $CheckoutDefaultBranch $MaxNestingLevel $NextNestingLevel $FailedFolders
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
    $FailedFolders = New-Object System.Collections.Generic.List[System.String]
    try
    {
        __LoopSubfolders_updaterepos $Path $CheckoutDefaultBranch $MaxNestingLevel 0 $FailedFolders
    }
    finally
    {
        Set-Location $CurrentLocation
    }

    Write-Host ""
    Write-Host -Message "Finished." -ForegroundColor Gray
    Write-Host ""
    foreach ($FailedFolder in $FailedFolders)
    {
        Write-Host -Message ("Failed: " + $FailedFolder) -ForegroundColor Red
    }

    Write-Verbose -Message "Done."
}

function Update-AllReposAndCheckoutDefaultBranch([String] $Path)
{
    Update-AllRepos $Path $true
}

Set-Alias -Name pullall -Value Update-AllRepos
Set-Alias -Name pullallmain -Value Update-AllReposAndCheckoutDefaultBranch

Export-ModuleMember -Function Update-AllRepos -Alias pullall
Export-ModuleMember -Function Update-AllReposAndCheckoutDefaultBranch -Alias pullallmain
