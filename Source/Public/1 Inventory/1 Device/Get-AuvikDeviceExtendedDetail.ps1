<#
.SYNOPSIS
Get Extended Device Details from Auvik

.DESCRIPTION
Use Get-AuvikDeviceExtendedDetail to get information collected and tracked by Auvik that are unique to that device type.

.PARAMETER DeviceType
Filter by device type.

.PARAMETER ModifiedAfter
Filter by date and time, only returning entities modified after provided value.

.PARAMETER NotSeenSince
Filter by the last seen online time, returning entities not seen online after the provided value.

.PARAMETER StateKnown
Filter by devices with recently updated data, for more consistent results.

.PARAMETER Tenants
Array of tenant IDs to request info from.

.PARAMETER Id
ID of a device in Auvik. Not compatible with the other parameters.

.EXAMPLE
An example

.NOTES
Multiple always returns a 500 error, appears to be an issue on Auvik's end?
#>
function Get-AuvikDeviceExtendedDetail {
    [CmdletBinding(DefaultParameterSetName="Multiple")]
    param (
        <#
        # Filter by device type.
        [Parameter(ParameterSetName="Multiple",Mandatory)][ValidateSet("unknown","switch","l3Switch","router","accessPoint","firewall","workstation","server","storage","printer","copier","hypervisor","multimedia","phone","tablet","handheld","virtualAppliance","bridge","controller","hub","modem","ups","module","loadBalancer","camera","telecommunications","packetProcessor","chassis","airConditioner","virtualMachine","pdu","ipPhone","backhaul","internetOfThings","voipSwitch","stack","backupDevice","timeClock","lightingDevice","audioVisual","securityAppliance","utm","alarm","buildingManagement","ipmi","thinAccessPoint","thinClient",IgnoreCase=$false)]
        [string]
        $DeviceType,
        # Filter by date and time, only returning entities modified after provided value.
        [Parameter(ParameterSetName="Multiple")]
        [datetime]
        $ModifiedAfter,
        # Filter by the last seen online time, returning entities not seen online after the provided value.
        [Parameter(ParameterSetName="Multiple")]
        [datetime]
        $NotSeenSince,
        # Filter by devices with recently updated data, for more consistent results.
        [Parameter(ParameterSetName="Multiple")]
        [bool]
        $StateKnown,
        # Array of tenant IDs to request info from.
        [Parameter(ParameterSetName="Multiple")]
        [string[]]
        $TenantID,
        #>
        # ID of a device in Auvik. Not compatible with the other parameters.
        [Parameter(ParameterSetName="Single")]
        [string[]]
        $Id
    )

    begin {
        if (-not($ConnectedToAuvik)) {
            Throw "Authentication needed. Please call Connect-AuvikApi"
        }

        <#
        $QueryParams = foreach ($Key in $PSBoundParameters.Keys) {
            switch ($Key) {
                DeviceType {
                    "filter[deviceType]=$($DeviceType)"
                }
                ModifiedAfter {
                    "filter[modifiedAfter]=$($ModifiedAfter)"
                }
                NotSeenSince {
                    "filter[notSeenSince]=$($NotSeenSince)"
                }
                StateKnown {
                    "filter[stateKnown]=$($StateKnown.ToString().ToLower())"
                }
                TenantID {
                    "tenants=$($TenantID -join ",")"
                }
                default {}
            }
        }
        #>
    }

    process {
        $AuvikDeviceExtendedDetail = if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Id | ForEach-Object {
                [AuvikDeviceExtendedDetail]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/device/detail/extended/$($_)"))
            }
        } else {
            Write-Warning "At last test, the 'Read Multiple Devices Extended Details' endpoint was not working."
            #(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/device/detail/extended?$($QueryParams -join '&')").data | ForEach-Object {[AuvikDeviceExtendedDetail]::new($_)}
        }
    }

    end {
        return $AuvikDeviceExtendedDetail
    }
}