# Output all extensions of all files recursively.
function Write-Extensions()
{
    Get-ChildItem -File -Recurse -Exclude .git | Select-Object -Property Extension -Unique | Sort-Object -Property Extension
}

Export-ModuleMember -Function Write-Extensions
