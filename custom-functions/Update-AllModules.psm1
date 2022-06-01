function Update-AllModules() {
    $installedModules = Get-InstalledModule
    $userDocumentsPath = [environment]::GetFolderPath("mydocuments")
    $userDocumentsPattern = [Regex]::Escape($userDocumentsPath)

    foreach ($installedModule in $installedModules) {
        $moduleName = $installedModule.Name
        $modulePath = $installedModule.InstalledLocation
        $currentVersion = $installedModule.Version

        $isPrerelease = $currentVersion -Match "-"
        $releaseInfo = "stable"
        if ($isPrerelease) {
            $releaseInfo = "prerelease"
        }

        $isUserScope = $modulePath -Match "C:\\Users\\" -or $modulePath -Match $userDocumentsPattern
        $targetScope = "AllUsers"
        if ($isUserScope) {
            $targetScope = "CurrentUser"
        }

        Write-Host -ForegroundColor White "Check module $moduleName - installed: $currentVersion ($releaseInfo, $targetScope) ... $modulePath"

        $moduleInfos = Find-Module -Name $installedModule.Name -AllowPrerelease:$isPrerelease

        $updateVersion = $moduleInfos.Version
        $updateDate = $moduleInfos.PublishedDate

        if ($updateVersion -eq $currentVersion) {
            Write-Host -ForegroundColor Green "  $moduleName already installed in the latest version $currentVersion [$updateDate]"
        }
        else {
            Write-Host -ForegroundColor Cyan "  $moduleName - Update from $currentVersion to $updateVersion [$updateDate] ($releaseInfo, $targetScope)"
            try {
                if ($isPrerelease) {
                    Write-Host "    Update-Module -Name $moduleName -Force -Scope $targetScope -AllowPrerelease -Verbose"
                    Update-Module -Name $moduleName -Force -Scope $targetScope -AllowPrerelease -Verbose
                } else {
                    Write-Host "    Update-Module -Name $moduleName -Force -Scope $targetScope -Verbose"
                    Update-Module -Name $moduleName -Force -Scope $targetScope -Verbose
                }
            }
            catch {
                Write-Host -ForegroundColor Red $_.Exception.Message
            }
        }
    }
}
