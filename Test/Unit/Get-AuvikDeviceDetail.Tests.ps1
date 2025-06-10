param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Get-AuvikDeviceDetail Tests' -Tags 'Unit' {
    BeforeAll {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop
        $Tenants = Get-AuvikTenant
        $DeviceDetail = Get-AuvikDeviceDetail -Tenants ($Tenants[0]).ID -LimitResults
        $DiscoverySNMP = $DeviceDetail[0].SnmpStatus
        $DiscoveryWMI = $DeviceDetail[0].WmiStatus
        $DiscoveryLogin = $DeviceDetail[0].LoginStatus
        $DiscoveryVMware = $DeviceDetail[0].VMwareStatus
        $TrafficInsightsStatus = $DeviceDetail[0].TrafficInsightsStatus
    }

    It 'Returns devices by Tenant' {
        $DeviceDetail | Should -Not -BeNullOrEmpty
    }

    It 'Returns devices by ManageStatus' {
        Get-AuvikDeviceDetail -ManageStatus $true -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns devices by DiscoverySNMP' {
        Get-AuvikDeviceDetail -DiscoverySNMP $DiscoverySNMP -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns devices by DiscoveryWMI' {
        Get-AuvikDeviceDetail -DiscoveryWMI $DiscoveryWMI -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns devices by DiscoveryLogin' {
        Get-AuvikDeviceDetail -DiscoveryLogin $DiscoveryLogin -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns devices by DiscoveryVMware' {
        Get-AuvikDeviceDetail -DiscoveryVMware $DiscoveryVMware -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns devices by trafficInsightsStatus' {
        Get-AuvikDeviceDetail -TrafficInsightsStatus $TrafficInsightsStatus -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns device by Id' {
        Get-AuvikDeviceDetail -Id $DeviceDetail[0].Id | Should -Not -BeNullOrEmpty
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}