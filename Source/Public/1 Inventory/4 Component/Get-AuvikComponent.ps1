function Get-AuvikComponent {
    [CmdletBinding(DefaultParameterSetName="Multiple")]
    param (
        # Filter by date and time, only returning entities modified after provided value.
        [Parameter(ParameterSetName="Multiple")]
        [datetime]
        $ModifiedAfter,
        # Filter by the component's parent device's ID.
        [Parameter(ParameterSetName="Multiple")]
        [string]
        $DeviceId,
        # Filter by the component's parent device's name.
        [Parameter(ParameterSetName="Multiple")]
        [string]
        $DeviceName,
        # Filter by the component's current status.
        [Parameter(ParameterSetName="Multiple")][ValidateSet("ok","degraded","failed",IgnoreCase=$false)]
        [string]
        $currentStatus,
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
                ModifiedAfter {
                    "filter[modifiedAfter]=$($ModifiedAfter)"
                }
                DeviceId {
                    "filter[deviceId]=$($DeviceId)"
                }
                DeviceName {
                    "filter[deviceName]=$($DeviceName)"
                }
                currentStatus {
                    "filter[currentStatus]=$($currentStatus)"
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
                [AuvikComponent]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/component/info/$($_)" -All:$All))
            }
        } else {
            (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/component/info?$($QueryParams -join '&')" -All:$All).data | ForEach-Object {[AuvikComponent]::new($_)}
        }

    }

    end {
        return $AuvikComponent
    }
}