<#
.SYNOPSIS
Get Auvik Tenants

.DESCRIPTION
Use Get-AuvikTenant to pull details for multiple multi-clients and clients associated with your main Auvik account.

.PARAMETER DomainPrefix
Filter the results by one or more DomainPrefixes

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-AuvikTenant {
    [CmdletBinding()]
    param (
        # Auvik Domain Prefix
        [Parameter()]
        [string[]]
        $DomainPrefix
    )

        begin {
        if (-not($ConnectedToAuvik)) {
            Throw "Authentication needed. Please call Connect-AuvikApi"
        }
        [uri]$Uri = "$($AuvikBaseUri)/tenants"
    }

    process {
        [AuvikTenant[]]$Tenants = (Invoke-AuvikApi -Uri $Uri).data

        if ($DomainPrefix) {
            $Tenants = $Tenants | Where-Object {$_.DomainPrefix -in $DomainPrefix}
        }

        if ($Tenants.Count -eq 0 -and $DomainPrefix) {
            Write-Warning "Provided DomainPrefix not found"
        } else {
            Write-Verbose "$($Tenants.Count) tenants found"
        }
    }

    end {
        return $Tenants
    }
}