
function __LoopSubfolders_updaterepos([String] $Directory, [Int32] $MaxNestingLevel, [Int32] $NestingLevel)
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
            Write-Host ("> " + $_.FullName)

            Write-Host ""
            Invoke-Expression "git branch --show-current"

            Write-Host ""

            $GitCommand = "git pull"
            Write-Verbose -Message $GitCommand
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

function Update-AllRepos([String] $Path, [Int32] $MaxNestingLevel = 1)
{
    $CurrentLocation = (Get-Location).path

    if ([string]::IsNullOrEmpty($Path)) {
        $Path = $CurrentLocation
    }

    Write-Verbose -Message $CurrentLocation

    try
    {
        __LoopSubfolders_updaterepos $Path $MaxNestingLevel 0
    }
    finally
    {
        Set-Location $CurrentLocation
    }

    Write-Verbose -Message "Done."
}

Set-Alias "pullall" Update-AllRepos
