function Get-AuvikEntityAudit {
    [CmdletBinding(DefaultParameterSetName="Multiple")]
    param (
        # Filter by user name associated to the audit.
        [Parameter(ParameterSetName="Multiple")]
        [string]
        $User,
        # Filter by the audit's category.
        [Parameter(ParameterSetName="Multiple")]
        [EntityAuditCategory]
        $Category,
        # Filter by the audit's status.
        [Parameter(ParameterSetName="Multiple")]
        [EntityAuditStatus]
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

        $Parameters = if ($Pages) {
            @{'Pages' = $Pages}
        }
    }

    process {
        $AuvikComponent = if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Id | ForEach-Object {
                [AuvikEntityAudit]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/entity/audit/$($_)" @Parameters))
            }
        } else {
            (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/entity/audit?$($QueryParams -join '&')" @Parameters).data | ForEach-Object {[AuvikEntityAudit]::new($_)}
        }

    }

    end {
        return $AuvikComponent
    }
}