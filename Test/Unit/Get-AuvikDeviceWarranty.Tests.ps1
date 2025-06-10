param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Get-AuvikDeviceWarranty Tests' -Tags 'Unit' {
    BeforeAll {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop
        $Tenants = Get-AuvikTenant
        $DeviceWarranty = Get-AuvikDeviceWarranty -Tenants ($Tenants[0]).ID -LimitResults
    }

    It 'Returns devices by Tenant' {
        $DeviceWarranty | Should -Not -BeNullOrEmpty
    }

    It 'Returns devices by ManageStatus' {
        Get-AuvikDeviceWarranty -CoveredUnderWarranty $false -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns devices by DiscoverySNMP' {
        Get-AuvikDeviceWarranty -CoveredUnderService $false -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns device by Id' {
        Get-AuvikDeviceWarranty -Id $DeviceWarranty[0].Id | Should -Not -BeNullOrEmpty
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}