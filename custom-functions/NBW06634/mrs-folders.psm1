$mrsLocations = New-Object System.Collections.Generic.Dictionary"[String,String]"

$mrsLocations.Add("mrs", "c:\dev\mrs")

$mrsLocations.Add("api", "c:\dev\mrs\api")
$mrsLocations.Add("app", "c:\dev\mrs\app")
$mrsLocations.Add("lib", "c:\dev\mrs\lib")
$mrsLocations.Add("cli", "c:\dev\mrs\cli")

$mrsLocations.Add("example", "c:\dev\mrs\api\portable-api\clients\dart\mrsclient\example")

$mrsLocations.Add("portableapi", "c:\dev\mrs\api\portable-api")
$mrsLocations.Add("gatewayapi", "c:\dev\mrs\api\ccs.gateway-api")
$mrsLocations.Add("edesapi", "c:\dev\mrs\api\edes-api")
$mrsLocations.Add("adminapi", "c:\dev\mrs\api\admin-api")
$mrsLocations.Add("authapi", "c:\dev\mrs\api\auth-api")
$mrsLocations.Add("eventapi", "c:\dev\mrs\api\event-api")
$mrsLocations.Add("fileapi", "c:\dev\mrs\api\file-api")
$mrsLocations.Add("missionapi", "c:\dev\mrs\api\mission-api")
$mrsLocations.Add("resourceapi", "c:\dev\mrs\api\resource-api")
$mrsLocations.Add("userapi", "c:\dev\mrs\api\user-api")

$mrsLocations.Add("gatewayapp", "c:\dev\mrs\app\ccs.gateway.edes-app")
$mrsLocations.Add("authapp", "c:\dev\mrs\app\auth-app")
$mrsLocations.Add("missionapp", "c:\dev\mrs\app\mission-app")
$mrsLocations.Add("userapp", "c:\dev\mrs\app\user-app")
$mrsLocations.Add("fileapp", "c:\dev\mrs\app\file-app")
$mrsLocations.Add("newsapp", "c:\dev\mrs\app\news-app")
$mrsLocations.Add("configapp", "c:\dev\mrs\app\config-app")
$mrsLocations.Add("resourceapp", "c:\dev\mrs\app\resource-app")
$mrsLocations.Add("adminapp", "c:\dev\mrs\app\resource-app")

$mrsLocations.Add("portable", "c:\dev\mrs\portable\mrs-portable")

function mrs(
    [String]
    [Parameter(Mandatory = $false)]
    $key
)
{
    if ([string]::IsNullOrEmpty($key)) {
        $key = "mrs"
    }
    $location = ""
    if ($mrsLocations.TryGetValue($key, [ref] $location)) {
        Set-LocationMultiplatform -Path $location
    } else {
        Write-Host "no location found for key: $key" -ForegroundColor Red
    }
}

Export-ModuleMember -Function mrs
