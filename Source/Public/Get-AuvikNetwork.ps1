function Get-AuvikNetwork {
    [CmdletBinding(DefaultParameterSetName="Multiple")]
    param (
        # Filter by network type.
        [Parameter(ParameterSetName="Multiple")]
        [NetworkType]
        $NetworkType,
        # Filter by the network's scan status.
        [Parameter(ParameterSetName="Multiple")]
        [ScanStatus]
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
        $AuvikNetwork = if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Id | ForEach-Object {
                [AuvikNetwork]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/network/info/$($_)?include=networkDetail" @Parameters))
            }
        } else {
            $Networks = Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/network/info?include=networkDetail&$($QueryParams -join '&')" @Parameters
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