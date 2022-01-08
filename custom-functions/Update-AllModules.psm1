function Update-AllModules() {
    $installedModules = Get-InstalledModule

    foreach ($installedModule in $installedModules) {
        $moduleName = $installedModule.Name
        $modulePath = $installedModule.Path
        $currentVersion = $installedModule.Version

        $isPrerelease = $currentVersion -Match "-"
        $isUserScope = $modulePath -Match "C:\\Users\\"

        if ($isPrerelease) {
            Write-Host -ForegroundColor White "Check module $moduleName - installed: $currentVersion (prerelease) ... $modulePath"
            $moduleInfos = Find-Module -Name $installedModule.Name -AllowPrerelease
        } else {
            Write-Host -ForegroundColor White "Check module $moduleName - installed: $currentVersion ... $modulePath"
            $moduleInfos = Find-Module -Name $installedModule.Name
        }

        $updateVersion = $moduleInfos.Version
        $updateDate = $moduleInfos.PublishedDate

        if ($updateVersion -eq $currentVersion) {
            Write-Host -ForegroundColor Green "  $moduleName already installed in the latest version $currentVersion ($updateDate)"
        }
        else {
            $targetScope = $isUserScope ? "CurrentUser" : "AllUsers"
            Write-Host -ForegroundColor Cyan "  $moduleName - Update from $currentVersion to $updateVersion ($updateDate) - prerelease:$isPrerelease, scope:$targetScope"
            try {
                Update-Module -Name $moduleName -Force -Scope $targetScope -AllowPrerelease:$isPrerelease -Verbose
            }
            catch {
                Write-Host -ForegroundColor Red $_.Exception.Message
            }
        }
    }
}
