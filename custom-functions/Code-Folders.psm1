$codeLocations = New-Object System.Collections.Generic.Dictionary"[String,String]"

$hostname = [system.environment]::MachineName
$files = (
    "$PSScriptRoot/code-folders.txt",
    "$PSScriptRoot/$hostname/code-folders.txt"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        foreach ($line in Get-Content $file) {
            $match = [regex]::Match($line, '"([^"]*)"\W*"([^"]*)"')
            if ($match.Success) {
                $codeLocations.Add($match.Groups[1], $match.Groups[2])
            }
        }
    }
}

function Set-CodeFolder(
    [String]
    [Parameter(Mandatory = $false)]
    $key
)
{
    if ([string]::IsNullOrEmpty($key)) {
        Write-Host "Usage: g <code-folder-key>"
        return
    }
    $location = ""
    if ($codeLocations.TryGetValue($key, [ref] $location)) {
        Write-Verbose "location for key: $key is $location"
        Set-LocationMultiplatform -Path $location
    } else {
        Write-Host "no location found for key: $key" -ForegroundColor Red
        $mrsLocations.getenumerator() | Format-Table | Out-String | Write-Verbose
    }
}

Export-ModuleMember -Function Set-CodeFolder -Alias g
