function Get-AuvikNetwork {
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
        [Parameter(ParameterSetName="Multiple")]
        [string[]]
        $TenantID,
        # ID of a network in Auvik. Not compatible with the other parameters.
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
                Tenants {
                    "tenants=$($TenantID -join ",")"
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
        $AuvikNetwork = if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Id | ForEach-Object {
                [AuvikNetwork]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/network/info/$($_)?include=networkDetail" -All:$All))
            }
        } else {
            $Networks = Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/network/info?include=networkDetail&$($QueryParams -join '&')" -All:$All
            for ($i = 0; $i -lt $Networks.data.Count; $i++) {
                $Content = [PSCustomObject]@{
                    'Data' = $Networks.data[$i]
                    'Included' = $Networks.included | Where-Object {$Networks.data[$i].id -eq $_.id}
                }
                [AuvikNetwork]::new($Content)
            }
        }
    }

    end {
        return $AuvikNetwork
    }
}