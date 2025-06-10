param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Get-AuvikNetwork Tests' -Tags 'Unit' {
    BeforeAll {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop
        $Tenants = Get-AuvikTenant
        $Networks = Get-AuvikNetwork -Tenants ($Tenants[0]).ID -LimitResults
        $NetworkType = ($Networks | Where-Object {"" -ne $_.NetworkType})[0].NetworkType
        $ScanStatus = ($Networks | Where-Object {"" -ne $_.ScanStatus})[0].ScanStatus
        $DeviceId = ($Networks.Device | Where-Object {$_.Id -ne ""})[0].Id
        $ModifiedAfter = ($Networks | Where-Object {"" -ne $_.LastModified})[0].LastModified

    }

    It 'Returns Networks by Tenant' {
        $Networks | Should -Not -BeNullOrEmpty
    }

    It 'Returns Networks by NetworkType' {
        Get-AuvikNetwork -NetworkType $NetworkType -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns Networks by ScanStatus' {
        Get-AuvikNetwork -ScanStatus $ScanStatus -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns Networks by Devices' {
        Get-AuvikNetwork -Devices $DeviceId -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns Networks by ModifiedAfter' {
        Get-AuvikNetwork -ModifiedAfter $ModifiedAfter -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns Network by Id' {
        Get-AuvikNetwork -Id $Networks[0].Id | Should -Not -BeNullOrEmpty
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}