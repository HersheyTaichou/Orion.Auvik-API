function Get-AuvikEntityNote {
    [CmdletBinding(DefaultParameterSetName="Multiple")]
    param (
        # Filter by the entity's ID.
        [Parameter(ParameterSetName="Multiple")]
        [string]
        $EntityId,
        # Filter by the entity's type.
        [Parameter(ParameterSetName="Multiple")]
        [EntityType]
        $EntityType,
        # Filter by the entity's name.
        [Parameter(ParameterSetName="Multiple")]
        [string]
        $EntityName,
        # Filter by the user the note was last modified by.
        [Parameter(ParameterSetName="Multiple")]
        [string]
        $LastModifiedBy,
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
                EntityId {
                    "filter[entityId]=$($EntityId)"
                }
                EntityType {
                    "filter[entityType]=$($EntityType)"
                }
                EntityName {
                    "filter[entityName]=$($EntityName)"
                }
                LastModifiedBy {
                    "filter[lastModifiedBy]=$($LastModifiedBy)"
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
                [AuvikEntityNote]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/entity/note/$($_)" @Parameters))
            }
        } else {
            (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/entity/note?$($QueryParams -join '&')" @Parameters).data | ForEach-Object {[AuvikEntityNote]::new($_)}
        }

    }

    end {
        return $AuvikComponent
    }
}