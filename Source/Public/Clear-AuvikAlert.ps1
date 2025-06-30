function Clear-AuvikAlert {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # ID of an alert. Not compatible with the other parameters.
        [Parameter()]
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
    }

    process {
        $Id | ForEach-Object {
            if ($PSCmdlet.ShouldProcess($_,'Dismiss')) {
                [AuvikAlert]::new($(Invoke-AuvikApi -Uri "$($AuvikBaseUri)/alert/dismiss/$($_)"))
            }
        }
    }

    end {
        return $AuvikAlert
    }
}