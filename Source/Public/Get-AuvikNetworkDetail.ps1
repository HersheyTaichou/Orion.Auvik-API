function Get-AuvikNetworkDetail {
    [CmdletBinding(DefaultParameterSetName="Multiple")]
    param (
        # Filter by network type.
        [Parameter(ParameterSetName="Multiple")][ValidateSet("routed","vlan","wifi","loopback","network","layer2","internet",IgnoreCase=$false)]
        [string]
        $NetworkType,
        # Filter by the network's scan status.
        [Parameter(ParameterSetName="Multiple")][ValidateSet("true","false","notAllowed","unknown",IgnoreCase=$false)]
        [string]
        $ScanStatus,
        # Filter by IDs of devices on this network. Filter by multiple values by providing an array
        [Parameter(ParameterSetName="Multiple")]
        [string[]]
        $Devices,
        # Filter by date and time, only returning entities modified after provided value.
        [Parameter(ParameterSetName="Multiple")]
        [datetime]
        $ModifiedAfter,
        # Array of tenant IDs to request info from.
        [Parameter(ParameterSetName="Multiple")][ValidateSet("private","public",IgnoreCase=$false)]
        [string]
        $Scope,
        # Array of tenant IDs to request info from.
        [Parameter(ParameterSetName="Multiple")]
        [string[]]
        $TenantID,
        # ID of a network in Auvik. Not compatible with the other parameters.
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
                NetworkType {
                    "filter[networkType]=$($NetworkType)"
                }
                ScanStatus {
                    "filter[scanStatus]=$($ScanStatus)"
                }
                Devices {
                    "filter[devices]=$($Devices -join ",")"
                }
                ModifiedAfter {
                    "filter[modifiedAfter]=$($ModifiedAfter)"
                }
                Scope {
                    "filter[scope]=$($Scope)"
                }
                TenantID {
                    "tenants=$($TenantID -join ",")"
                }
                default {}
            }
        }

        $Parameters = if ($Pages) {
            @{'Pages' = $Pages}
        }
    }

    process {
        $AuvikNetworkDetail = if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Id | ForEach-Object {
                [AuvikNetworkDetail]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/network/detail/$($_)" @Parameters))
            }
        } else {
            (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/network/detail?$($QueryParams -join '&')" @Parameters).data | ForEach-Object {[AuvikNetworkDetail]::new($_)}
        }
    }

    end {
        return $AuvikNetworkDetail
    }
}