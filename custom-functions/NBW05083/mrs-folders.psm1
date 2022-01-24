$mrsLocations = New-Object System.Collections.Generic.Dictionary"[String,String]"

$mrsLocations.Add("mrs", "D:\dev\mrs")

$mrsLocations.Add("api", "D:\dev\mrs\api")
$mrsLocations.Add("app", "D:\dev\mrs\app")
$mrsLocations.Add("lib", "D:\dev\mrs\lib")
$mrsLocations.Add("cli", "D:\dev\mrs\cli")

$mrsLocations.Add("example", "D:\dev\mrs\api\portable-api\clients\dart\mrsclient\example")

$mrsLocations.Add("portableapi", "D:\dev\mrs\api\portable-api")
$mrsLocations.Add("gatewayapi", "D:\dev\mrs\api\ccs.gateway-api")
$mrsLocations.Add("edesapi", "D:\dev\mrs\api\edes-api")
$mrsLocations.Add("adminapi", "D:\dev\mrs\api\admin-api")
$mrsLocations.Add("authapi", "D:\dev\mrs\api\auth-api")
$mrsLocations.Add("eventapi", "D:\dev\mrs\api\event-api")
$mrsLocations.Add("fileapi", "D:\dev\mrs\api\file-api")
$mrsLocations.Add("missionapi", "D:\dev\mrs\api\mission-api")
$mrsLocations.Add("resourceapi", "D:\dev\mrs\api\resource-api")
$mrsLocations.Add("userapi", "D:\dev\mrs\api\user-api")

$mrsLocations.Add("gatewayapp", "D:\dev\mrs\app\ccs.gateway.edes-app")
$mrsLocations.Add("authapp", "D:\dev\mrs\app\auth-app")
$mrsLocations.Add("missionapp", "D:\dev\mrs\app\mission-app")
$mrsLocations.Add("userapp", "D:\dev\mrs\app\user-app")
$mrsLocations.Add("fileapp", "D:\dev\mrs\app\file-app")
$mrsLocations.Add("newsapp", "D:\dev\mrs\app\news-app")
$mrsLocations.Add("configapp", "D:\dev\mrs\app\config-app")
$mrsLocations.Add("resourceapp", "D:\dev\mrs\app\resource-app")
$mrsLocations.Add("adminapp", "D:\dev\mrs\app\resource-app")

$mrsLocations.Add("portable", "D:\dev\mrs\portable\mrs-portable")

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
        Set-Location -Path $location
    }
}
