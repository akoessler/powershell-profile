$mrsLocations = New-Object System.Collections.Generic.Dictionary"[String,String]"

$mrsLocations.Add("mrs", "d:\dev\mrs")

$mrsLocations.Add("api", "d:\dev\mrs\api")
$mrsLocations.Add("app", "d:\dev\mrs\app")
$mrsLocations.Add("lib", "d:\dev\mrs\lib")
$mrsLocations.Add("cli", "d:\dev\mrs\cli")

$mrsLocations.Add("example", "d:\dev\mrs\api\portable-api\clients\dart\mrsclient\example")

$mrsLocations.Add("portableapi", "d:\dev\mrs\api\portable-api")
$mrsLocations.Add("gatewayapi", "d:\dev\mrs\api\ccs.gateway-api")
$mrsLocations.Add("edesapi", "d:\dev\mrs\api\edes-api")
$mrsLocations.Add("adminapi", "d:\dev\mrs\api\admin-api")
$mrsLocations.Add("authapi", "d:\dev\mrs\api\auth-api")
$mrsLocations.Add("eventapi", "d:\dev\mrs\api\event-api")
$mrsLocations.Add("fileapi", "d:\dev\mrs\api\file-api")
$mrsLocations.Add("missionapi", "d:\dev\mrs\api\mission-api")
$mrsLocations.Add("resourceapi", "d:\dev\mrs\api\resource-api")
$mrsLocations.Add("userapi", "d:\dev\mrs\api\user-api")

$mrsLocations.Add("gatewayapp", "d:\dev\mrs\app\ccs.gateway.edes-app")
$mrsLocations.Add("authapp", "d:\dev\mrs\app\auth-app")
$mrsLocations.Add("missionapp", "d:\dev\mrs\app\mission-app")
$mrsLocations.Add("userapp", "d:\dev\mrs\app\user-app")
$mrsLocations.Add("fileapp", "d:\dev\mrs\app\file-app")
$mrsLocations.Add("newsapp", "d:\dev\mrs\app\news-app")
$mrsLocations.Add("configapp", "d:\dev\mrs\app\config-app")
$mrsLocations.Add("resourceapp", "d:\dev\mrs\app\resource-app")
$mrsLocations.Add("adminapp", "d:\dev\mrs\app\resource-app")

$mrsLocations.Add("portable", "d:\dev\mrs\portable\mrs-portable")

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
    }
}

Export-ModuleMember -Function mrs
