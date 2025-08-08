function Get-AuvikDeviceAvailabilityStatistics {
    [CmdletBinding()]
    param (
        # ID of statistic to return
        [Parameter(Mandatory)]
        [DeviceAvailabilityStatisticsId]
        $StatId,
        # Date from which you want to query
        [Parameter(Mandatory)]
        [datetime]
        $FromTime,
        # Date to which you want to query
        [Parameter()]
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
                    "filter[fromTime]=$(Get-Date -Date $FromTime -Format "yyyy-MM-ddThh:mm:ss" -AsUTC)"
                }
                ThruTime {
                    "filter[thruTime]=$(Get-Date -Date $ThruTime -Format "yyyy-MM-ddThh:mm:ss" -AsUTC)"
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
        $AuvikDeviceStatistics = (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/stat/deviceAvailability/$($StatId)?$($QueryParams -join '&')" @Parameters).data #| ForEach-Object {[AuvikDeviceAvailabilityStatistics]::new($_)}
    }

    end {
        return $AuvikDeviceStatistics
    }
}