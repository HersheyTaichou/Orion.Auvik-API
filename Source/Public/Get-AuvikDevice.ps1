<#
.SYNOPSIS
Get Device Info from Auvik

.DESCRIPTION
Use Get-AuvikDeviceInfo to gather collected information about the various devices Auvik has discovered

.PARAMETER Networks
Filter by IDs of networks this device is on.

.PARAMETER DeviceType
Filter by device type.

.PARAMETER MakeModel
Filter by the device's make and model.

.PARAMETER VendorName
Filter by the device's vendor/manufacturer.

.PARAMETER OnlineStatus
Filter by the device's online status.

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
General notes
#>
function Get-AuvikDevice {
    [CmdletBinding(DefaultParameterSetName="Multiple")]
    param (
        # Filter by IDs of networks this device is on.
        [Parameter(ParameterSetName="Multiple")]
        [string[]]
        $Networks,
        # Filter by device type.
        [Parameter(ParameterSetName="Multiple")][ValidateSet("unknown","switch","l3Switch","router","accessPoint","firewall","workstation","server","storage","printer","copier","hypervisor","multimedia","phone","tablet","handheld","virtualAppliance","bridge","controller","hub","modem","ups","module","loadBalancer","camera","telecommunications","packetProcessor","chassis","airConditioner","virtualMachine","pdu","ipPhone","backhaul","internetOfThings","voipSwitch","stack","backupDevice","timeClock","lightingDevice","audioVisual","securityAppliance","utm","alarm","buildingManagement","ipmi","thinAccessPoint","thinClient",IgnoreCase=$false)]
        [string]
        $DeviceType,
        # Filter by the device's make and model.
        [Parameter(ParameterSetName="Multiple")]
        [string]
        $MakeModel,
        # Filter by the device's vendor/manufacturer.
        [Parameter(ParameterSetName="Multiple")]
        [string]
        $VendorName,
        # Filter by the device's online status.
        [Parameter(ParameterSetName="Multiple")][ValidateSet("online","offline","unreachable","testing","unknown","dormant","notPresent","lowerLayerDown",IgnoreCase=$false)]
        [string]
        $OnlineStatus,
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
        $Tenants,
        # ID of a device in Auvik. Not compatible with the other parameters.
        [Parameter(ParameterSetName="Single")]
        [string[]]
        $Id,
        # Get all results
        [Parameter()]
        [switch]
        $LimitResults
    )

    begin {
        if (-not($ConnectedToAuvik)) {
            Throw "Authentication needed. Please call Connect-AuvikApi"
        }

        $QueryParams = foreach ($Key in $PSBoundParameters.Keys) {
            switch ($Key) {
                Networks {
                    "filter[networks]=$($Networks  -join ",")"
                }
                DeviceType {
                    "filter[deviceType]=$DeviceType"
                }
                MakeModel {
                    "filter[makeModel]=$MakeModel"
                }
                VendorName {
                    "filter[vendorName]=$VendorName"
                }
                OnlineStatus {
                    "filter[onlineStatus]=$OnlineStatus"
                }
                ModifiedAfter {
                    "filter[modifiedAfter]=$ModifiedAfter"
                }
                NotSeenSince {
                    "filter[notSeenSince]=$NotSeenSince"
                }
                StateKnown {
                    "filter[stateKnown]=$($StateKnown.ToString().ToLower())"
                }
                Tenants {
                    "tenants=$($Tenants -join ",")"
                }
                default {}
            }
        }

        if ($LimitResults) {
            $All =$false
        } else {
            $All = $true
        }
    }

    process {
        $AuvikDevice = if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Id | ForEach-Object {
                [AuvikDevice]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/device/info/$($_)?include=deviceDetail" -All:$All))
            }
        } else {
            $Devices = Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/device/info?include=deviceDetail&$($QueryParams -join '&')" -All:$All
            for ($i = 0; $i -lt $Devices.data.Count; $i++) {
                $Content = [PSCustomObject]@{
                    'Data' = $Devices.data[$i]
                    'Included' = $Devices.included | Where-Object {$Devices.data[$i].id -eq $_.id}
                }
                [AuvikDevice]::new($Content)
            }
        }

    }

    end {
        return $AuvikDevice
    }
}