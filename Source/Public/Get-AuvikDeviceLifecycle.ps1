function Get-AuvikDeviceLifecycle {
    [CmdletBinding(DefaultParameterSetName="Multiple")]
    param (
        # Filter by sales availability.
        [Parameter(ParameterSetName="Multiple")][ValidateSet("covered","available","expired","securityOnly","unpublished","empty",IgnoreCase=$false)]
        [string]
        $SalesAvailability,
        # Filter by software maintenance status.
        [Parameter(ParameterSetName="Multiple")][ValidateSet("covered","available","expired","securityOnly","unpublished","empty",IgnoreCase=$false)]
        [string]
        $SoftwareMaintenanceStatus,
        # Filter by security software maintenance status.
        [Parameter(ParameterSetName="Multiple")][ValidateSet("covered","available","expired","securityOnly","unpublished","empty",IgnoreCase=$false)]
        [string]
        $SecuritySoftwareMaintenanceStatus,
        # Filter by last support status.
        [Parameter(ParameterSetName="Multiple")][ValidateSet("covered","available","expired","securityOnly","unpublished","empty",IgnoreCase=$false)]
        [string]
        $LastSupportStatus,
        # Array of tenant IDs to request info from.
        [Parameter(ParameterSetName="Multiple")]
        [string[]]
        $Tenants,
        # ID of a device in Auvik. Only accepts one ID at a time and is not compatible with the other parameters
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
                CoveredUnderWarranty {
                    "filter[coveredUnderWarranty]=$($CoveredUnderWarranty.ToString().ToLower())"
                }
                CoveredUnderService {
                    "filter[coveredUnderService]=$($CoveredUnderService.ToString().ToLower())"
                }
                Tenants {
                    "tenants=$($Tenants -join ",")"
                }
                Default {}
            }
        }

        if ($LimitResults) {
            $All =$false
        } else {
            $All = $true
        }
    }

    process {
        $AuvikDeviceLifecycle = if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Id | ForEach-Object {
                [AuvikDeviceLifecycle]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/device/lifecycle/$($_)" -All:$All))
            }
        } else {
            (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/device/lifecycle?$($QueryParams -join '&')" -All:$All).data | ForEach-Object {[AuvikDeviceLifecycle]::new($_)}
        }
    }

    end {
        return $AuvikDeviceLifecycle
    }
}