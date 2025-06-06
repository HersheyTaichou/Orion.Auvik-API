function Get-AuvikDeviceWarranty {
    [CmdletBinding(DefaultParameterSetName="Multiple")]
    param (
        # Filter by warranty coverage status.
        [Parameter(ParameterSetName="Multiple")]
        [bool]
        $CoveredUnderWarranty,
        # Filter by service coverage status.
        [Parameter(ParameterSetName="Multiple")]
        [bool]
        $CoveredUnderService,
        # Array of tenant IDs to request info from.
        [Parameter(ParameterSetName="Multiple")]
        [string[]]
        $Tenants,
        # ID of a device in Auvik. Only accepts one ID at a time and is not compatible with the other parameters
        [Parameter(ParameterSetName="Single")]
        [string[]]
        $Id
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
    }

    process {
        $AuvikDeviceDetail = if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Id | ForEach-Object {
                [AuvikDeviceWarranty]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/device/warranty/$($_)"))
            }
        } else {
            (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/device/warranty?$($QueryParams -join '&')").data | ForEach-Object {[AuvikDeviceWarranty]::new($_)}
        }
    }

    end {
        return $AuvikDeviceDetail
    }
}