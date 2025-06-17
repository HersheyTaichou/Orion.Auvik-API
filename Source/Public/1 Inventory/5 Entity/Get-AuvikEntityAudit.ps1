function Get-AuvikEntityNote {
    [CmdletBinding(DefaultParameterSetName="Multiple")]
    param (
        # Filter by user name associated to the audit.
        [Parameter(ParameterSetName="Multiple")]
        [string]
        $User,
        # Filter by the audit’s category.
        [Parameter(ParameterSetName="Multiple")][ValidateSet("unknown","tunnel","terminal","remoteBrowser",IgnoreCase=$false)]
        [string]
        $Category,
        # Filter by the audit’s status.
        [Parameter(ParameterSetName="Multiple")][ValidateSet("unknown","initiated","created","closed","failed",IgnoreCase=$false)]
        [string]
        $Status,
        # Filter by date and time, only returning entities modified after provided value.
        [Parameter(ParameterSetName="Multiple")]
        [datetime]
        $ModifiedAfter,
        # Array of tenant IDs to request info from.
        [Parameter(ParameterSetName="Multiple")]
        [string[]]
        $TenantID,
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
                User {
                    "filter[user]=$($User)"
                }
                Category {
                    "filter[category]=$($Category)"
                }
                Status {
                    "filter[status]=$($Status)"
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

        if ($LimitResults) {
            $All =$false
        } else {
            $All = $true
        }
    }

    process {
        $AuvikComponent = if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Id | ForEach-Object {
                [AuvikEntityNote]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/entity/audit/$($_)" -All:$All))
            }
        } else {
            (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/entity/audit?$($QueryParams -join '&')" -All:$All).data | ForEach-Object {[AuvikEntityNote]::new($_)}
        }

    }

    end {
        return $AuvikComponent
    }
}