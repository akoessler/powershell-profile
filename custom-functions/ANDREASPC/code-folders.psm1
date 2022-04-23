$codeLocations = New-Object System.Collections.Generic.Dictionary"[String,String]"

$codeLocations.Add("dcode", "d:\Code")

$codeLocations.Add("gh", "d:\Code\github")
$codeLocations.Add("github", "d:\Code\github")


function dcode(
    [String]
    [Parameter(Mandatory = $false)]
    $key
)
{
    if ([string]::IsNullOrEmpty($key)) {
        $key = "dcode"
    }
    $location = ""
    if ($codeLocations.TryGetValue($key, [ref] $location)) {
        Set-LocationMultiplatform -Path $location
    }
}

Export-ModuleMember -Function dcode
