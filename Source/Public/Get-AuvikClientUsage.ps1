function Get-AuvikClientUsage {
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
        # Array of tenant IDs to request info from.
        [Parameter()]
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
                FromDate {
                    "filter[fromDate]=$(Get-Date -Date $FromDate -Format "yyyy-MM-dd")"
                }
                ThruDate {
                    "filter[thruDate]=$(Get-Date -Date $ThruDate -Format "yyyy-MM-dd")"
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
        $AuvikClientUsage = (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/https://auvikapi.us3.my.auvik.com/v1/billing/usage/client?$($QueryParams -join '&')" @Parameters).data | ForEach-Object {[AuvikClientUsage]::new($_)}
    }

    end {
        return $AuvikClientUsage
    }
}