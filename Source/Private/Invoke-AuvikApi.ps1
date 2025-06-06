function Invoke-AuvikApi {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [uri]
        $Uri
    )

    begin {
        $DeviceParams = @{
            'Uri' = $Uri
            'Credential' = $AuvikApiCredentials
            'Authentication' = 'Basic'
            'StatusCodeVariable' = 'StatusCode'
        }
        $Page = 1

        $TotalPages = 100
        $Backoff = 5
    }

    process {
        $Content = do {
            Write-Progress -Activity "Querying Page $Page" -Status "$($Uri.PathAndQuery)" -PercentComplete ($Page / $TotalPages * 100) -CurrentOperation "$($Uri.Query)"
            try {
                $RestMethod = Invoke-RestMethod @DeviceParams
            }
            catch {
                $StatusCode = $_.Exception.Response.StatusCode.value__
                $ReasonPhrase = $_.Exception.Response.ReasonPhrase
                $RestError = $_
                $Try++
            }
            switch ($StatusCode) {
                200 {
                    $Page++
                    $DeviceParams.Uri = $RestMethod.links.next
                    $TotalPages = $RestMethod.meta.totalPages
                    $Try = 0
                    $RestMethod
                    $Backoff = 5
                }
                400 {
                    Write-Error "$($StatusCode): $($ReasonPhrase). Please verify the request details: $($Uri.PathAndQuery)"
                    throw
                }
                403 {
                    Write-Error "$($StatusCode): $($ReasonPhrase). Please confirm the Uri and Auvik API Credentials are correct."
                    throw
                }
                404 {
                    Write-Error "$($StatusCode): $($ReasonPhrase). Unable to find details based on the Uri: $($Uri.PathAndQuery)"
                    throw
                }
                429 {
                    Write-Error "$($StatusCode): $($ReasonPhrase). Sleeping for $($Backoff) seconds then trying again. (Try #$($Try))"
                    Start-Sleep -Seconds $Backoff
                    $Backoff += $Backoff
                }
                500 {
                    Write-Error "$($StatusCode): $($ReasonPhrase). Sleeping for $($Backoff) seconds then trying again. (Try #$($Try))"
                    Start-Sleep -Seconds $Backoff
                    $Backoff += $Backoff
                }
                Default {
                    Write-Error $RestError
                    Write-Error "Sleeping for $($Backoff) seconds then trying again. (Try #$($Try))"
                    Start-Sleep -Seconds $Backoff
                    $Backoff += $Backoff
                }
            }

        } while ($DeviceParams.Uri -and $Try -lt 5)
    }

    end {
        return $Content
    }
}