
function Connect-SSH(
    [String]
    [Parameter(Mandatory = $true)]
    $hostname,
    [String]
    [Parameter(Mandatory = $false)]
    $username = "",
    [Int32]
    [Parameter(Mandatory = $false)]
    $port = 0,
    [String]
    [Parameter(Mandatory = $false)]
    $macspec = ""
)
{
    $command = "ssh"
    if ($username -ne "") {
        $command += " $username@$hostname"
    } else {
        $command += " $hostname"
    }

    if ($port -ne 0) {
        $command += " -p $port"
    }

    if ($macspec -ne "") {
        $command += " -m $macspec"
    }

    Write-Host ""
    Write-Host ""
    Write-Host "Connecting to $hostname" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "$command" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host ""

    Invoke-Expression "$command"

    Write-Host ""
    Write-Host ""
    Write-Host "Disconnected from $hostname" -ForegroundColor DarkYellow
    Write-Host ""
    Write-Host ""
}

Export-ModuleMember -Function Connect-SSH
