function Get-AuvikConfiguration {
    [CmdletBinding(DefaultParameterSetName="Multiple")]
    param (
        # Filter by user name associated to the audit.
        [Parameter(ParameterSetName="Multiple")]
        [string]
        $DeviceId,
        # Filter by date and time, filtering out configurations backed up before value.
        [Parameter(ParameterSetName="Multiple")]
        [datetime]
        $BackupTimeAfter,
        # Filter by date and time, filtering out configurations backed up after value.
        [Parameter(ParameterSetName="Multiple")]
        [datetime]
        $BackupTimeBefore,
        # Filter by the audit's category.
        [Parameter(ParameterSetName="Multiple")]
        [bool]
        $isRunning,
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
                BackupTimeAfter {
                    "filter[backupTimeAfter]=$($BackupTimeAfter)"
                }
                BackupTimeBefore {
                    "filter[backupTimeBefore]=$($BackupTimeBefore)"
                }
                IsRunning {
                    "filter[isRunning]=$($IsRunning.ToString().ToLower())"
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
        $AuvikConfiguration = if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Id | ForEach-Object {
                [AuvikConfiguration]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/configuration/$($_)" @Parameters))
            }
        } else {
            (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/configuration?$($QueryParams -join '&')" @Parameters).data | ForEach-Object {[AuvikConfiguration]::new($_)}
        }

    }

    end {
        return $AuvikConfiguration
    }
}