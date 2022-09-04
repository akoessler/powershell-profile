$exchangeOnlineDomainExternal = "@akoessler.com"
$exchangeOnlineDomainInternal = "@akoessler.onmicrosoft.com"

$mainMailboxName = "andreas"
$mainMailboxAddress = "${mainMailboxName}${exchangeOnlineDomainExternal}"

$groupDisplayName = "Andreas Kössler"

$groupFormatProperties = @("Name", "Alias", "DisplayName", "RecipientType", "Managedby", "GrantSendOnBehalfTo", "RequireSenderAuthenticationEnabled", "WindowsEmailAddress", "PrimarySmtpAddress", "EmailAddresses")
$memberFormatProperties = @("Id", "Name", "DisplayName", "PrimarySmtpAddress")
$permissionFormatProperties = @("Identity", "Trustee", "AccessControlType", "AccessRights", "IsValid")

function Connect-ExchangeAkoessler()
{
    Write-Host ""
    Write-Host "----------------------------------------"   -ForegroundColor Magenta
    Write-Host "       Connect to Exchange Online"          -ForegroundColor Magenta
    Write-Host "----------------------------------------"   -ForegroundColor Magenta
    Write-Host ""

    Connect-ExchangeOnline -UserPrincipalName "$mainMailboxAddress" -ShowProgress $true

    Write-Host ""
    Write-Host "Connect successful" -ForegroundColor Green
    Write-Host ""

    Get-ConnectionInformation
}

function Get-ExchangeGroups()
{
    Write-Host ""
    Write-Host "----------------------------------------"   -ForegroundColor Magenta
    Write-Host "    All distribution groups"                -ForegroundColor Magenta
    Write-Host "----------------------------------------"   -ForegroundColor Magenta
    Write-Host ""

    Get-DistributionGroup | Format-Table -Property $groupFormatProperties
}

function Get-ExchangeGroupsDetails()
{
    Get-DistributionGroup | Select Name | ForEach-Object { Get-ExchangeGroupDetails $_.Name }
}

function Get-ExchangeGroupDetails([String] $identity)
{
    Write-Host ""
    Write-Host "----------------------------------------"   -ForegroundColor Magenta
    Write-Host "    Details for group: $identity"           -ForegroundColor Magenta
    Write-Host "----------------------------------------"   -ForegroundColor Magenta
    Write-Host ""

    Write-Host ""
    Write-Host "Group details:" -ForegroundColor Cyan
    Write-Host ""

    Get-DistributionGroup -Identity "$identity" | Format-Table -Property $groupFormatProperties

    Write-Host ""
    Write-Host "Members:" -ForegroundColor Cyan
    Write-Host ""

    Get-DistributionGroupMember -identity "$identity" | Format-Table -Property $memberFormatProperties

    Write-Host ""
    Write-Host "Send-As permission:" -ForegroundColor Cyan
    Write-Host ""

    Get-RecipientPermission -identity "$identity" | Format-Table -Property $permissionFormatProperties
}

function New-ExchangeGroup([String] $newGroupName)
{
    $newGroupAddressExternal = "$newGroupName${exchangeOnlineDomainExternal}"
    $newGroupAddressInternal = "$newGroupName${exchangeOnlineDomainInternal}"

    Write-Host ""
    Write-Host "------------------------------------------------------------"   -ForegroundColor Magenta
    Write-Host "    Add new distribution group: $newGroupName"                  -ForegroundColor Magenta
    Write-Host "      - $newGroupAddressExternal"                               -ForegroundColor Magenta
    Write-Host "      - $newGroupAddressInternal"                               -ForegroundColor Magenta
    Write-Host "------------------------------------------------------------"   -ForegroundColor Magenta
    Write-Host ""


    $recipient = Get-Recipient -Identity $newGroupName -ErrorAction SilentlyContinue
    $recipient ??= Get-Recipient -Identity $newGroupAddressExternal -ErrorAction SilentlyContinue
    $recipient ??= Get-Recipient -Identity $newGroupAddressInternal -ErrorAction SilentlyContinue
    if ($null -ne $recipient) {
        Write-Error "There is already a receiver for this alias:"
        Write-Output $recipient | Format-Table -Property $groupFormatProperties
        throw "Cannot create group, receiver already exists!"
    }


    Write-Host ""
    Write-Host "Create group ..." -ForegroundColor DarkYellow
    Write-Host ""

    New-DistributionGroup -Name "$newGroupName" -DisplayName "$groupDisplayName" -Alias "$newGroupName" -ManagedBy "$mainMailboxAddress" -CopyOwnerToMember -Verbose

    Write-Host ""
    Write-Host "...done" -ForegroundColor Cyan
    Write-Host ""


    Write-Host ""
    Write-Host "Set addresses ..." -ForegroundColor DarkYellow
    Write-Host ""

    # "SMTP:" is the primary address (only one), "smtp:" is for additional addresses
    Set-DistributionGroup -Identity "$newGroupName" -EmailAddresses "SMTP:$newGroupAddressExternal","smtp:$newGroupAddressInternal" -Verbose

    Write-Host ""
    Write-Host "...done" -ForegroundColor Cyan
    Write-Host ""


    Write-Host ""
    Write-Host "Set group permissions ..." -ForegroundColor DarkYellow
    Write-Host ""

    Set-DistributionGroup -Identity "$newGroupName" -GrantSendOnBehalfTo "$mainMailboxAddress" -RequireSenderAuthenticationEnabled $false -Verbose

    Write-Host ""
    Write-Host "...done" -ForegroundColor Cyan
    Write-Host ""


    Write-Host ""
    Write-Host "Set SendAs permission ..." -ForegroundColor DarkYellow
    Write-Host ""

    Add-RecipientPermission -Identity "$newGroupName" -AccessRights SendAs -Trustee "$mainMailboxAddress" -Confirm:$false

    Write-Host ""
    Write-Host "...done" -ForegroundColor Cyan
    Write-Host ""


    Write-Host ""
    Write-Host "Group created successfully" -ForegroundColor Green
    Write-Host ""


    Get-ExchangeGroupDetails "$newGroupName"
}

Export-ModuleMember -Function Connect-ExchangeAkoessler
Export-ModuleMember -Function Get-ExchangeGroups
Export-ModuleMember -Function Get-ExchangeGroupsDetails
Export-ModuleMember -Function Get-ExchangeGroupDetails
Export-ModuleMember -Function New-ExchangeGroup
