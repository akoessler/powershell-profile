$mrsLocations = New-Object System.Collections.Generic.Dictionary"[String,String]"

$mrsLocations.Add("mrs", "c:\dev\mrs")

$mrsLocations.Add("api", "c:\dev\mrs\api")
$mrsLocations.Add("app", "c:\dev\mrs\app")
$mrsLocations.Add("lib", "c:\dev\mrs\lib")
$mrsLocations.Add("cli", "c:\dev\mrs\cli")
$mrsLocations.Add("system", "c:\dev\mrs\system")
$mrsLocations.Add("test", "c:\dev\mrs\test")
$mrsLocations.Add("tool", "c:\dev\mrs\tool")

$mrsLocations.Add("config", "c:\dev\mrs\build\config")

$mrsLocations.Add("adminapi", "c:\dev\mrs\api\admin-api")
$mrsLocations.Add("authapi", "c:\dev\mrs\api\auth-api")
$mrsLocations.Add("edesapi", "c:\dev\mrs\api\edes-api")
$mrsLocations.Add("eventapi", "c:\dev\mrs\api\event-api")
$mrsLocations.Add("fileapi", "c:\dev\mrs\api\file-api")
$mrsLocations.Add("gatewayapi", "c:\dev\mrs\api\ccs.gateway-api")
$mrsLocations.Add("missionapi", "c:\dev\mrs\api\mission-api")
$mrsLocations.Add("portableapi", "c:\dev\mrs\api\portable-api")
$mrsLocations.Add("resourceapi", "c:\dev\mrs\api\resource-api")
$mrsLocations.Add("userapi", "c:\dev\mrs\api\user-api")

$mrsLocations.Add("example", "c:\dev\mrs\api\portable-api\clients\dart\mrsclient\example")

$mrsLocations.Add("event", "C:\dev\mrs\app\event-app")
$mrsLocations.Add("file", "C:\dev\mrs\app\file-app")
$mrsLocations.Add("landing", "C:\dev\mrs\app\landing-web")
$mrsLocations.Add("mission", "C:\dev\mrs\app\mission-app")
$mrsLocations.Add("news", "C:\dev\mrs\app\news-app")
$mrsLocations.Add("dummy", "C:\dev\mrs\app\portable.dummy-app")
$mrsLocations.Add("privacy", "C:\dev\mrs\app\privacy-policy-web")
$mrsLocations.Add("resource", "C:\dev\mrs\app\resource-app")
$mrsLocations.Add("user", "C:\dev\mrs\app\user-app")
$mrsLocations.Add("admin", "C:\dev\mrs\app\admin.web-app")
$mrsLocations.Add("auth", "C:\dev\mrs\app\auth-app")
$mrsLocations.Add("gateway", "C:\dev\mrs\app\ccs.gateway.edes-app")
$mrsLocations.Add("config", "C:\dev\mrs\app\config-app")
$mrsLocations.Add("console", "C:\dev\mrs\app\console-app")

$mrsLocations.Add("portable", "c:\dev\mrs\portable\mrs-portable")

$mrsLocations.Add("dev", "c:\dev\mrs\portable\mrs-dev")
$mrsLocations.Add("dev2", "c:\dev\mrs\portable\mrs-dev2")
$mrsLocations.Add("dev3", "c:\dev\mrs\portable\mrs-dev3")
$mrsLocations.Add("staging", "c:\dev\mrs\portable\mrs-staging")

$mrsLocations.Add("simulation", "C:\dev\mrs\test\ccs-simulation-app")
$mrsLocations.Add("executablespec", "C:\dev\mrs\test\executable.spec-lib")
$mrsLocations.Add("k6", "C:\dev\mrs\test\k6")
$mrsLocations.Add("test", "C:\dev\mrs\test\test-app")
$mrsLocations.Add("simulationapi", "C:\dev\mrs\test\ccs-simulation-api")

$mrsLocations.Add("dependency", "c:\dev\mrs\tool\dependency-tool")

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
