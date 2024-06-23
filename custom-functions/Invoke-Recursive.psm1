# Invoke a script block for all subfolders of a given path, if the folders are a git repository.
# The script block is invoked with the path of the processed directory as parameter ($_).
# The script block can throw an exception to mark that folder as failed.
function Invoke-AllGitFolders(
    [scriptblock] $ScriptBlock,
    [String] $Path = $null,
    [Int32] $MaxNestingLevel = 1,
    [switch] $Verbose = $false
)
{
    InvokeRecursive `
        -ScriptBlock $ScriptBlock `
        -Path $Path `
        -OnlyGitFolder $true `
        -MaxNestingLevel $MaxNestingLevel `
        -Verbose:$Verbose
}

# Invoke a script block for all subfolders of a given path.
# The script block is invoked with the path of the processed directory as parameter ($_).
# The script block can throw an exception to mark that folder as failed.
function Invoke-AllFolders(
    [scriptblock] $ScriptBlock,
    [String] $Path = $null,
    [Boolean] $OnlyGitFolder = $false,
    [Int32] $MaxNestingLevel = 1,
    [switch] $Verbose = $false
)
{
    InvokeRecursive `
        -ScriptBlock $ScriptBlock `
        -Path $Path `
        -OnlyGitFolder $false `
        -MaxNestingLevel $MaxNestingLevel `
        -Verbose:$Verbose
}

##############################
# Private functions
##############################

function InvokeRecursive(
    [scriptblock] $ScriptBlock,
    [String] $Path = $null,
    [Boolean] $OnlyGitFolder = $false,
    [Int32] $MaxNestingLevel = 1,
    [switch] $Verbose = $false
)
{
    Write-Host ""

    if ($ScriptBlock -eq $null)
    {
        Write-Host "ERROR: no script set, abort" -ForegroundColor Red
        Write-Host ""
        return -1
    }

    $currentLocation = (Get-Location).Path

    if ([string]::IsNullOrEmpty($Path))
    {
        if ($Verbose -eq $true)
        {
            Write-Host ("# path not specified, use current location: " + $currentLocation) -ForegroundColor DarkGray
        }
        $Path = $currentLocation
    }

    Write-Host ("Start directory: " + $currentLocation) -ForegroundColor DarkMagenta

    $failedFolders = New-Object System.Collections.Generic.List[System.String]
    try
    {
        InvokeRecursiveSubfolder `
            -ScriptBlock $ScriptBlock `
            -Directory $Path `
            -OnlyGitFolder $OnlyGitFolder `
            -MaxNestingLevel $MaxNestingLevel `
            -NestingLevel 0 `
            -FailedFolders $failedFolders `
            -Verbose:$Verbose
    }
    finally
    {
        if ($Verbose -eq $true)
        {
            Write-Host ("# restore current location: " + $currentLocation) -ForegroundColor DarkGray
        }
        Set-Location $currentLocation
    }

    Write-Host ""
    Write-Host "Finished." -ForegroundColor DarkMagenta
    Write-Host ""

    if ($failedFolders.Count -gt 0)
    {
        Write-Host "ERROR: Failed folders:" -ForegroundColor Red
        foreach ($failedFolder in $failedFolders)
        {
            Write-Host ("- " + $failedFolder) -ForegroundColor Red
        }
    }
    else
    {
        Write-Host "All successful." -ForegroundColor Green
    }

    if ($Verbose -eq $true)
    {
        Write-Host "" -ForegroundColor DarkGray
        Write-Host "# done." -ForegroundColor DarkGray
        Write-Host "" -ForegroundColor DarkGray
    }
}

function InvokeRecursiveSubfolder(
    [scriptblock] $ScriptBlock,
    [String] $Directory,
    [Boolean] $OnlyGitFolder,
    [Int32] $MaxNestingLevel,
    [Int32] $NestingLevel,
    [System.Collections.Generic.List[System.String]] $FailedFolders,
    [switch] $Verbose
)
{
    if ($Verbose -eq $true)
    {
        Write-Host ("# do subfolders of: " + $Directory + " (level: " + $NestingLevel + ")") -ForegroundColor DarkGray
    }

    Set-Location $Directory
    Get-ChildItem -Path $Directory -Directory | ForEach-Object {
        $childDirectory = $_.FullName
        if ($Verbose -eq $true)
        {
            Write-Host ""
            Write-Host ("# process: " + $childDirectory + " (level: " + $NestingLevel + ")") -ForegroundColor DarkGray
        }

        # execute action - if it is a git folder, or all folders if OnlyGitFolder is false

        $executed = $false
        $gitfolder = Join-Path -Path $childDirectory -ChildPath ".git"
        if (($OnlyGitFolder -eq $false) -or (Test-Path($gitfolder)))
        {
            $executed = $true
            Set-Location $childDirectory

            if ($Verbose -eq $false)
            {
                Write-Host "" # in verbose the empty line is written above already
            }
            Write-Host ("> " + $childDirectory) -ForegroundColor Magenta

            try
            {
                $scriptReturn = $ScriptBlock.Invoke($childDirectory)
                if ($Verbose -eq $true)
                {
                    Write-Host "# script return: " -ForegroundColor DarkGray
                    Write-Host $scriptReturn -ForegroundColor DarkGray
                }
            }
            catch
            {
                $FailedFolders.Add($childDirectory)
                $e = $_.Exception
                if ($null -ne $e -and $e.GetType() -eq [System.Management.Automation.MethodInvocationException]) {
                    $e = $e.InnerException
                }
                Write-Host ("ERROR: " + $e.Message) -ForegroundColor Red
                if ($Verbose -eq $true)
                {
                    Write-Host ("# script error: " + $e.Message) -ForegroundColor DarkGray
                    Write-Host "-----" -ForegroundColor DarkGray
                    Write-Host $e -ForegroundColor DarkGray
                    Write-Host "-----" -ForegroundColor DarkGray
                }
            }
        }

        # do recursive

        $ignoreRecursiveFile = Join-Path -Path $childDirectory -ChildPath ".ignore-recursive"
        if ($executed -eq $true)
        {
            if ($Verbose -eq $true)
            {
                Write-Host ("# skip recursive, folder was executed (level: " + $NestingLevel + ")") -ForegroundColor DarkGray
            }
        }
        elseif (Test-Path $ignoreRecursiveFile)
        {
            if ($Verbose -eq $true)
            {
                Write-Host ("# skip recursive, .ignore-recursive file found (level: " + $NestingLevel + ")") -ForegroundColor DarkGray
            }
        }
        elseif ($NestingLevel -ge $MaxNestingLevel)
        {
            if ($Verbose -eq $true)
            {
                Write-Host ("# skip recursive, max level reached (level: " + $NestingLevel + ")") -ForegroundColor DarkGray
            }
        }
        else
        {
            $NextNestingLevel = $NestingLevel + 1
            InvokeRecursiveSubfolder `
                -ScriptBlock $ScriptBlock `
                -Directory $childDirectory `
                -OnlyGitFolder $OnlyGitFolder `
                -MaxNestingLevel $MaxNestingLevel `
                -NestingLevel $NextNestingLevel `
                -FailedFolders $FailedFolders `
                -Verbose:$Verbose
        }
    }

    if ($Verbose -eq $true)
    {
        Write-Host ("# finished subfolders of: " + $Directory + " (level: " + $NestingLevel + ")") -ForegroundColor DarkGray
    }
}

Export-ModuleMember -Function Invoke-AllFolders
Export-ModuleMember -Function Invoke-AllGitFolders
