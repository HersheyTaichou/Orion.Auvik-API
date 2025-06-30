function Get-AuvikAlert {
    [CmdletBinding(DefaultParameterSetName="Multiple")]
    param (
        # Filter by alert definition ID.
        [Parameter(ParameterSetName="Multiple")]
        [string]
        $AlertDefinitionId,
        # Deprecated. Filter by alert specification ID. Use 'alertDefinitionId' instead
        [Parameter(ParameterSetName="Multiple")]
        [string]
        $AlertSpecificationId,
        # Filter by alert severity.
        [Parameter(ParameterSetName="Multiple")]
        [AlertSeverity]
        $Severity,
        # Filter by the status of the alert.
        [Parameter(ParameterSetName="Multiple")]
        [AlertStatus]
        $Status,
        # Filter by the related entity ID.
        [Parameter(ParameterSetName="Multiple")]
        [string]
        $entityId,
        # Filter by the dismissed status.
        [Parameter(ParameterSetName="Multiple")]
        [bool]
        $Dismissed,
        # Filter by dispatched status.
        [Parameter(ParameterSetName="Multiple")]
        [bool]
        $Dispatched,
        # Filter by the time which is greater than the given timestamp.
        [Parameter(ParameterSetName="Multiple")]
        [datetime]
        $DetectedTimeAfter,
        # Filter by the time which is less than or equal to the given timestamp.
        [Parameter(ParameterSetName="Multiple")]
        [datetime]
        $DetectedTimeBefore,
        # Array of tenant IDs to request info from.
        [Parameter(ParameterSetName="Multiple")]
        [string[]]
        $TenantID,
        # ID of a configuration. Not compatible with the other parameters.
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
                DeviceId {
                    "filter[deviceId]=$($DeviceId)"
                }
                AlertDefinitionId {
                    "filter[alertDefinitionId]=$($AlertDefinitionId)"
                }
                AlertSpecificationId {
                    Write-Warning "AlertSpecificationId is Deprecated, AlertDefinitionId should be used instead."
                    "filter[alertSpecificationId]=$($alertSpecificationId)"
                }
                Severity {
                    "filter[severity]=$($Severity)"
                }
                Status {
                    "filter[status]=$($Status)"
                }
                EntityId {
                    "filter[entityId]=$($entityId)"
                }
                Dismissed {
                    "filter[dismissed]=$($dismissed.ToString().ToLower())"
                }
                Dispatched {
                    "filter[dispatched]=$($dispatched.ToString().ToLower())"
                }
                DetectedTimeAfter {
                    "filter[detectedTimeAfter]=$($DetectedTimeAfter)"
                }
                DetectedTimeBefore {
                    "filter[detectedTimeBefore]=$($DetectedTimeBefore)"
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
        $AuvikAlert = if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Id | ForEach-Object {
                [AuvikAlert]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/alert/history/info/$($_)" @Parameters))
            }
        } else {
            (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/alert/history/info?$($QueryParams -join '&')" @Parameters).data | ForEach-Object {[AuvikAlert]::new($_)}
        }

    }

    end {
        return $AuvikAlert
    }
}