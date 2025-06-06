<#
.SYNOPSIS
Connect to the Auvik API

.DESCRIPTION
Takes the username, API Key and URI needed to connect to the Auvik API and stores them in script level variables, that the other commands can then use.

.PARAMETER Credential
Auvik UserName and API Key needed for authentication

.PARAMETER Uri
The Auvik API endpoint for your account. Validates that it matches the format 'https://auvikapi.{region}.my.auvik.com/' with the regions listed at https://support.auvik.com/hc/en-us/articles/360033412992-Auvik-regions

.PARAMETER ApiVersion
The version of the Auvik API to query. Currently, only v1 is available.

.EXAMPLE
Connect-AuvikApi -Credential (Get-Credential) -Uri "https://auvikapi.us1.my.auvik.com"

Connected to the Auvik API

.NOTES
General notes
#>
function Connect-AuvikApi {
    [CmdletBinding()]
    param (
        # Auvik UserName and API Key
        [Parameter(Mandatory)]
        [pscredential]
        $Credential,
        # Base URL for Auvik
        [Parameter(Mandatory)]
        [uri]
        $Uri,
        # API version number
        [Parameter(DontShow)][ValidateSet("v1",IgnoreCase=$false)]
        [string]
        $ApiVersion = "v1"
    )

    begin {
        $script:AuvikBaseUri = "$($Uri)$($ApiVersion)"

        # Validate the region against the ones listed here: https://support.auvik.com/hc/en-us/articles/360033412992-Auvik-regions
        if ($Uri -match "^https:\/\/auvikapi\.(us[1-6]|eu[1-2]|au1|ca1)\.[a-z]{2}\.auvik\.com\/$") {
            Write-Verbose "Uri successfully validated"
        } else {
            throw "$($Uri) does not match the format 'https://auvikapi.{region}.my.auvik.com/'."
        }

        $ConnectParams = @{
            'Uri' = "$($Uri)authentication/verify"
            'Credential' = $Credential
            'Authentication' = 'Basic'
        }
    }

    process {
        try {
            Invoke-RestMethod @ConnectParams -StatusCodeVariable StatusCode | Out-Null
        }
        catch {
            $StatusCode = $_.Exception.Response.StatusCode.value__
            $ReasonPhrase = $_.Exception.Response.ReasonPhrase
        }
        switch ($StatusCode) {
            200 {
                Write-Output "Connected to the Auvik API"
                $script:AuvikApiCredentials = $Credential
                $script:ConnectedToAuvik = $true
            }
            Default {
                Write-Error "API Error $($StatusCode): $($ReasonPhrase)"
            }
        }
    }

    end {

    }
}