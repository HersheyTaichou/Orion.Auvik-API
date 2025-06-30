function Get-AuvikInterface {
    [CmdletBinding(DefaultParameterSetName="Multiple")]
    param (
        # Filter by IDs of networks this device is on.
        [Parameter(ParameterSetName="Multiple")]
        [InterfaceType]
        $InterfaceType,
        # Filter by device type.
        [Parameter(ParameterSetName="Multiple")]
        [string]
        $ParentDevice,
        # Filter by the device's make and model.
        [Parameter(ParameterSetName="Multiple")]
        [bool]
        $AdminStatus,
        # Filter by the device's vendor/manufacturer.
        [Parameter(ParameterSetName="Multiple")]
        [OperationalStatus]
        $OperationalStatus,
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
                InterfaceType {
                    "filter[interfaceType]=$($InterfaceType)"
                }
                ParentDevice {
                    "filter[parentDevice]=$($ParentDevice)"
                }
                AdminStatus {
                    "filter[adminStatus]=$($AdminStatus.ToString().ToLower())"
                }
                OperationalStatus {
                    "filter[operationalStatus]=$($OperationalStatus)"
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
        $AuvikInterface = if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Id | ForEach-Object {
                [AuvikInterface]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/interface/info/$($_)" @Parameters))
            }
        } else {
            (Invoke-AuvikApi -Uri "$($AuvikBaseUri)/inventory/interface/info?$($QueryParams -join '&')" @Parameters).data | ForEach-Object {[AuvikInterface]::new($_)}
        }

    }

    end {
        return $AuvikInterface
    }
}