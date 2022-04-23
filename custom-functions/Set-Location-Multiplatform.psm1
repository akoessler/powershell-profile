
function Set-LocationMultiplatform
(
    [String]
    $Path
)
{
    $location = $Path
    Write-Host "set-location: $location"

    if ($IsLinux) {
        $match = $location -match '^([a-z]):\\(.*)'
        if ($match) {
            $drive = $Matches[1]
            $drive = $drive.ToLower()

            $folder = $Matches[2]
            $folder = $folder -replace "\\","/"

            if ($env:WSL_DISTRO_NAME) {
                $location = "/mnt/$drive/$folder"
            } else {
                $location = "/$drive/$folder"
            }
        }
        $location = $location -replace "\\","/"
        Write-Host "replaced to linux path: $location"
    }

    Set-Location -Path $location
}

Export-ModuleMember -Function Set-LocationMultiplatform
