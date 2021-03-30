
function __LoopSubfolders_printbranches([String] $Directory, [Int32] $MaxNestingLevel, [Int32] $NestingLevel)
{
    Set-Location $Directory
    Get-ChildItem -Path $Directory -Directory | ForEach-Object {
        $gitfolder = Join-Path -Path $_.FullName -ChildPath ".git"
        if (Test-Path $gitfolder)
        {
            Set-Location $_.FullName
            Write-Host "> " $_.FullName

            $GitCommand = "git branch --show-current"
            Invoke-Expression $GitCommand
        }
        elseif ($NestingLevel -le $MaxNestingLevel)
        {
            $NextNestingLevel = $NestingLevel + 1
            __LoopSubfolders_printbranches $_.FullName $MaxNestingLevel $NextNestingLevel
        }
    }
}

function Print-AllBranches([String] $Path, [Int32] $MaxNestingLevel = 1)
{
    $CurrentLocation = (Get-Location).path

    if ([string]::IsNullOrEmpty($Path)) {
        $Path = $CurrentLocation
    }

    try
    {
        __LoopSubfolders_printbranches $Path $MaxNestingLevel 0
    }
    finally
    {
        Set-Location $CurrentLocation
    }
}

Set-Alias "printbranches" Print-AllBranches
