function Get-AuvikInterface {
    [CmdletBinding(DefaultParameterSetName="Multiple")]
    param (
        # Filter by IDs of networks this device is on.
        [Parameter(ParameterSetName="Multiple")][ValidateSet("ethernet","wifi","bluetooth","cdma","coax","cpu","distributedVirtualSwitch","firewire","gsm","ieee8023AdLag","inferredWired","inferredWireless","interface","linkAggregation","loopback","modem","wimax","optical","other","parallel","ppp","radiomac","rs232","tunnel","unknown","usb","virtualBridge","virtualNic","virtualSwitch","vlan",IgnoreCase=$false)]
        [string]
        $InterfaceType,
        # Filter by device type.
        [Parameter(ParameterSetName="Multiple")]
        [string]
        $ParentDevice,
        # Filter by the device's make and model.
        [Parameter(ParameterSetName="Multiple")]
        [bool]
        $AdminStatus,
        # Filter by the device's vendor/manufacturer.
        [Parameter(ParameterSetName="Multiple")][ValidateSet("online","offline","unreachable","testing","unknown","dormant","notPresent","lowerLayerDown",IgnoreCase=$false)]
        [string]
        $OperationalStatus,
        # Filter by date and time, only returning entities modified after provided value.
        [Parameter(ParameterSetName="Multiple")]
        [datetime]
        $ModifiedAfter,
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
                InterfaceType {
                    "filter[interfaceType]=$InterfaceType"
                }
                ParentDevice {
                    "filter[parentDevice]=$ParentDevice"
                }
                AdminStatus {
                    "filter[adminStatus]=$($AdminStatus.ToString().ToLower())"
                }
                OperationalStatus {
                    "filter[operationalStatus]=$OperationalStatus"
                }
                ModifiedAfter {
                    "filter[modifiedAfter]=$ModifiedAfter"
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
        $AuvikInterface = if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Id | ForEach-Object {
                [AuvikInterface]::new($(Invoke-AuvikApi -Uri "$AuvikBaseUri/inventory/interface/info/$($_)" -All:$All))
            }
        } else {
            (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/interface/info?$($QueryParams -join '&')" -All:$All).data | ForEach-Object {[AuvikInterface]::new($_)}
        }

    }

    end {
        return $AuvikInterface
    }
}