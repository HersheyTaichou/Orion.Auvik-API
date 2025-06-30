<#
.SYNOPSIS
Get Device Details from Auvik

.DESCRIPTION
Use Get-AuvikDeviceDetail gather extra collected information about the various devices Auvik has discovered not already included in the Get-AuvikDeviceInfo

.PARAMETER ManageStatus
Filter by managed status

.PARAMETER DiscoverySNMP
Filter by the device's SNMP discovery status.

.PARAMETER DiscoveryWMI
Filter by the device's WMI discovery status.

.PARAMETER DiscoveryLogin
Filter by the device's Login discovery status.

.PARAMETER DiscoveryVMware
Filter by the device's VMware discovery status.

.PARAMETER TrafficInsightsStatus
Filter by the device's TrafficInsights status.

.PARAMETER Tenants
Array of tenant IDs to request info from.

.PARAMETER Id
ID of a device in Auvik. Only accepts one ID at a time and is not compatible with the other parameters

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-AuvikDeviceDetail {
    [CmdletBinding(DefaultParameterSetName="Multiple")]
    param (
        # Filter by managed status
        [Parameter(ParameterSetName="Multiple")]
        [bool]
        $ManageStatus,
        # Filter by the device's SNMP discovery status.
        [Parameter(ParameterSetName="Multiple")]
        [DiscoveryStatus]
        $DiscoverySNMP,
        # Filter by the device's WMI discovery status.
        [Parameter(ParameterSetName="Multiple")]
        [DiscoveryStatus]
        $DiscoveryWMI,
        # Filter by the device's Login discovery status.
        [Parameter(ParameterSetName="Multiple")]
        [DiscoveryStatus]
        $DiscoveryLogin,
        # Filter by the device's VMware discovery status.
        [Parameter(ParameterSetName="Multiple")]
        [DiscoveryStatus]
        $DiscoveryVMware,
        # Filter by the device's TrafficInsights status.
        [Parameter(ParameterSetName="Multiple")]
        [TrafficInsightsStatus]
        $TrafficInsightsStatus,
        # Array of tenant IDs to request info from.
        [Parameter(ParameterSetName="Multiple")]
        [string[]]
        $TenantID,
        # ID of a device in Auvik. Only accepts one ID at a time and is not compatible with the other parameters
        [Parameter(ParameterSetName="Single")]
        [string[]]
        $Id,
        # Maximum number of pages of results to get
        [Parameter()]
        [int]
        $Pages
    )

    begin {
        if (-not($ConnectedToAuvik)) {
            Throw "Authentication needed. Please call Connect-AuvikApi"
        }

        $QueryParams = foreach ($Key in $PSBoundParameters.Keys) {
            switch ($Key) {
                ManageStatus {
                    "filter[manageStatus]=$($ManageStatus.ToString().ToLower())"
                }
                DiscoverySNMP {
                    "filter[discoverySNMP]=$($DiscoverySNMP)"
                }
                DiscoveryWMI {
                    "filter[discoveryWMI]=$($DiscoveryWMI)"
                }
                DiscoveryLogin {
                    "filter[discoveryLogin]=$($DiscoveryLogin)"
                }
                DiscoveryVMware {
                    "filter[discoveryVMware]=$($DiscoveryVMware)"
                }
                TrafficInsightsStatus {
                    "filter[trafficInsightsStatus]=$($TrafficInsightsStatus)"
                }
                TenantID {
                    "tenants=$($TenantID -join ",")"
                }
                Default {}
            }
        }

        $Parameters = if ($Pages) {
            @{'Pages' = $Pages}
        }
    }

    process {
        $AuvikDeviceDetail = if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Id | ForEach-Object {
                [AuvikDeviceDetail]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/device/detail/$($_)" @Parameters))
            }
        } else {
            (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/device/detail?$($QueryParams -join '&')" @Parameters).data | ForEach-Object {[AuvikDeviceDetail]::new($_)}
        }
    }

    end {
        return $AuvikDeviceDetail
    }
}