function Get-AuvikDeviceLifecycle {
    [CmdletBinding(DefaultParameterSetName="Multiple")]
    param (
        # Filter by sales availability.
        [Parameter(ParameterSetName="Multiple")]
        [LifecycleStatus]
        $SalesAvailability,
        # Filter by software maintenance status.
        [Parameter(ParameterSetName="Multiple")]
        [LifecycleStatus]
        $SoftwareMaintenanceStatus,
        # Filter by security software maintenance status.
        [Parameter(ParameterSetName="Multiple")]
        [LifecycleStatus]
        $SecuritySoftwareMaintenanceStatus,
        # Filter by last support status.
        [Parameter(ParameterSetName="Multiple")]
        [LifecycleStatus]
        $LastSupportStatus,
        # Array of tenant IDs to request info from.
        [Parameter(ParameterSetName="Multiple")]
        [string[]]
        $TenantID,
        # ID of a device in Auvik. Only accepts one ID at a time and is not compatible with the other parameters
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
                SalesAvailability {
                    "filter[salesAvailability]=$($SalesAvailability)"
                }
                SoftwareMaintenanceStatus {
                    "filter[softwareMaintenanceStatus]=$($SoftwareMaintenanceStatus)"
                }
                SecuritySoftwareMaintenanceStatus {
                    "filter[securitySoftwareMaintenanceStatus]=$($SecuritySoftwareMaintenanceStatus)"
                }
                LastSupportStatus {
                    "filter[lastSupportStatus]=$($LastSupportStatus)"
                }
                TenantID {
                    "tenants=$($TenantID -join ",")"
                }
                Default {}
            }
        }

        $Parameters = if ($Pages) {
            @{'Pages' = $Pages}
        }
    }

    process {
        $AuvikDeviceLifecycle = if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Id | ForEach-Object {
                [AuvikDeviceLifecycle]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/device/lifecycle/$($_)" @Parameters))
            }
        } else {
            (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/device/lifecycle?$($QueryParams -join '&')" @Parameters).data | ForEach-Object {[AuvikDeviceLifecycle]::new($_)}
        }
    }

    end {
        return $AuvikDeviceLifecycle
    }
}