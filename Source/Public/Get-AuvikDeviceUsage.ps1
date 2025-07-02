function Get-AuvikDeviceUsage {
    [CmdletBinding()]
    param (
        # Date from which you want to query
        [Parameter(Mandatory)]
        [datetime]
        $FromDate,
        # Date to which you want to query
        [Parameter(Mandatory)]
        [datetime]
        $ThruDate,
        # ID of Device
        [Parameter()]
        [string[]]
        $ID,
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
                FromDate {
                    "filter[fromDate]=$(Get-Date -Date $FromDate -Format "yyyy-MM-dd")"
                }
                ThruDate {
                    "filter[thruDate]=$(Get-Date -Date $ThruDate -Format "yyyy-MM-dd")"
                }
                default {}
            }
        }

        $Parameters = if ($Pages) {
            @{'Pages' = $Pages}
        }
    }

    process {
        $AuvikDeviceUsage = $Id | ForEach-Object {
            [AuvikDeviceUsage]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/billing/usage/device/$($_)?$($QueryParams -join '&')" @Parameters))
        }
    }

    end {
        return $AuvikDeviceUsage
    }
}