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
        $DeviceDetail = Get-AuvikDeviceDetail -TenantID ($Tenants[0]).ID -Pages 1
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
        (Get-AuvikDeviceDetail -ManageStatus $true -Pages 1).ManageStatus | Sort-Object -Unique | Should -BeTrue
    }

    It 'Returns devices by DiscoverySNMP' {
        (Get-AuvikDeviceDetail -DiscoverySNMP $DiscoverySNMP -Pages 1).SnmpStatus | Sort-Object -Unique | Should -Be $DiscoverySNMP
    }

    It 'Returns devices by DiscoveryWMI' {
        (Get-AuvikDeviceDetail -DiscoveryWMI $DiscoveryWMI -Pages 1).WmiStatus | Sort-Object -Unique | Should -Be $DiscoveryWMI
    }

    # When testing, this returned more than just disabled logins
    It 'Returns devices by DiscoveryLogin' {
        (Get-AuvikDeviceDetail -DiscoveryLogin $DiscoveryLogin -Pages 1).LoginStatus | Sort-Object -Unique | Should -Contain $DiscoveryLogin
    }

    It 'Returns devices by DiscoveryVMware' {
        (Get-AuvikDeviceDetail -DiscoveryVMware $DiscoveryVMware -Pages 1).VMwareStatus | Sort-Object -Unique | Should -Be $DiscoveryVMware
    }

    It 'Returns devices by trafficInsightsStatus' {
        (Get-AuvikDeviceDetail -TrafficInsightsStatus $TrafficInsightsStatus -Pages 1).TrafficInsightsStatus | Sort-Object -Unique | Should -Be $TrafficInsightsStatus
    }

    It 'Returns device by Id' {
        (Get-AuvikDeviceDetail -Id $DeviceDetail[0].Id).Id | Should -Be $DeviceDetail[0].Id
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}