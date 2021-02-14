function Update-AllModules() {
    $installedModules = Get-InstalledModule

    foreach ($installedModule in $installedModules) {
        $moduleName = $installedModule.Name
        $currentVersion = $installedModule.Version
        $isPrerelease = $installedModule.Version -Match "-"

        if ($isPrerelease) {
            Write-Host -ForegroundColor White "Check module $moduleName - installed: $currentVersion (prerelease) ..."
            $moduleInfos = Find-Module -Name $installedModule.Name -AllowPrerelease
        } else {
            Write-Host -ForegroundColor White "Check module $moduleName - installed: $currentVersion ..."
            $moduleInfos = Find-Module -Name $installedModule.Name
        }

        $updateVersion = $moduleInfos.Version
        $updateDate = $moduleInfos.PublishedDate

        if ($updateVersion -eq $currentVersion) {
            Write-Host -ForegroundColor Green " $moduleName already installed in the latest version $currentVersion ($updateDate)"
        }
        else {
            Write-Host -ForegroundColor Cyan " $moduleName - Update from $currentVersion to $updateVersion ($updateDate)" 
            try {
                if ($isPrerelease) {
                    Update-Module -Name $module -Force -AllowPrerelease
                } else {
                    Update-Module -Name $module -Force
                }
            }
            catch {
                Write-Host -ForegroundColor Red $_.Exception.Message
            }
        }
    }
}
