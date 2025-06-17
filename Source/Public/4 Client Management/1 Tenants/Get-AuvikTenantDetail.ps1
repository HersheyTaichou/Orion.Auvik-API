<#
.SYNOPSIS
Get Tenant Details from Auvik

.DESCRIPTION
Use Get-AuvikTenantDetail to pull details for multiple multi-clients and clients associated with your main Auvik account.

.PARAMETER DomainPrefix
Domain prefix of your main Auvik account (tenant).

.PARAMETER Id
ID of a tenant in Auvik

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-AuvikTenantDetail {
    [CmdletBinding()]
    param (
        # Domain prefix of your main Auvik account (tenant).
        [Parameter(Mandatory)]
        [string]
        $DomainPrefix,
        # ID of a tenant in Auvik.
        [Parameter()]
        [string[]]
        $Id
    )

    begin {
        if (-not($ConnectedToAuvik)) {
            Throw "Authentication needed. Please call Connect-AuvikApi"
        }
    }

    process {
        $AuvikTenant = if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Id | ForEach-Object {
                [AuvikTenant]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/tenants/detail/$($_)?tenantDomainPrefix=$(($DomainPrefix).ToLower())"))
            }
        } else {
            (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/tenants/detail?tenantDomainPrefix=$(($DomainPrefix).ToLower())").data | ForEach-Object {[AuvikTenant]::new($_)}
        }
    }

    end {
        return $AuvikTenant
    }
}