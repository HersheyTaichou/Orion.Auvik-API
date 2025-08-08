function Get-AuvikDeviceStatistics {
    [CmdletBinding()]
    param (
        # ID of statistic to return
        [Parameter(Mandatory)]
        [DeviceStatisticsId]
        $StatId,
        # Date from which you want to query
        [Parameter(Mandatory)]
        [datetime]
        $FromTime,
        # Date to which you want to query
        [Parameter(Mandatory)]
        [datetime]
        $ThruTime,
        # Statistics reporting interval
        [Parameter(Mandatory)]
        [TimeInterval]
        $Interval,
        # Filter by device type.
        [Parameter(ParameterSetName="Multiple")]
        [DeviceTypeSchema]
        $DeviceType,
        # Filter by device ID
        [Parameter()]
        [string]
        $DeviceId,
        # Array of tenant IDs to request info from.
        [Parameter(ParameterSetName="Multiple")]
        [string[]]
        $TenantID,
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
                FromTime {
                    "filter[fromTime]=$($FromTime)"
                }
                ThruTime {
                    "filter[thruTime]=$($ThruTime)"
                }
                Interval {
                    "filter[interval]=$($Interval)"
                }
                DeviceType {
                    "filter[deviceType]=$($DeviceType)"
                }
                DeviceId {
                    "filter[deviceId]=$($DeviceId)"
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
        $AuvikDeviceStatistics = (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/stat/device/$($StatId)?$($QueryParams -join '&')" @Parameters).data | ForEach-Object {[AuvikDeviceStatistics]::new($_)}
    }

    end {
        return $AuvikDeviceStatistics
    }
}