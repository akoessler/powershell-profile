
function __LoopSubfolders([String] $Directory, [Int32] $MaxNestingLevel, [Int32] $NestingLevel)
{
    Write-Host ""
    Write-Host "=====  " $Directory
    Write-Host ""

    Set-Location $Directory
    Get-ChildItem -Path $Directory -Directory | ForEach-Object {
        $gitfolder = Join-Path -Path $_.FullName -ChildPath ".git"
        if (Test-Path $gitfolder)
        {
            Write-Host "- " $_.Name ": is a git repo => do update"

            Set-Location $_.FullName
            Write-Host "> " $_.FullName
            Write-Host ""

            $GitCommand = "git pull"
            Write-Host $GitCommand
            Invoke-Expression $GitCommand

            Write-Host ""
        }
        elseif ($NestingLevel -le $MaxNestingLevel)
        {
            Write-Host "- " $_.Name ": not a repo => check subfolders"
            $NextNestingLevel = $NestingLevel + 1
            __LoopSubfolders $_.FullName $MaxNestingLevel $NextNestingLevel
        }
        else
        {
            Write-Host "- " $_.Name ": not a repo => max nesting reached"
        }
    }

    Write-Host ""
}

function Update-AllRepos([String] $Path, [Int32] $MaxNestingLevel = 1)
{
    $CurrentLocation = (Get-Location).path

    if ([string]::IsNullOrEmpty($Path)) {
        $Path = $CurrentLocation
    }

    try
    {
        __LoopSubfolders $Path $MaxNestingLevel 0
    }
    finally
    {
        Set-Location $CurrentLocation
    }
}

Set-Alias "pullall" Update-AllRepos
