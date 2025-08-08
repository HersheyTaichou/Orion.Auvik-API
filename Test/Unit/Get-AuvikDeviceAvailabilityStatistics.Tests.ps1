param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Get-AuvikDevice Tests' -Tags 'Unit','New' {
    BeforeAll {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop
        $Tenants = Get-AuvikTenant
        $AuvikDeviceAvailabilityStatistics = (Get-AuvikDeviceAvailabilityStatistics -StatId uptime -FromTime (Get-Date).AddDays(-1) -ThruTime (Get-Date) -Interval hour -TenantID ($Tenants[0]).ID -Pages 1)[0]
        $AuvikDevice = Get-AuvikDevice -Id $AuvikDeviceAvailabilityStatistics.Device.Id
    }

    It 'Returns AuvikDeviceAvailabilityStatistics by StatId' {
        $AuvikDeviceAvailabilityStatistics | Should -Not -BeNullOrEmpty
    }

    It 'Returns AuvikDeviceAvailabilityStatistics by DeviceType' {
        (Get-AuvikDeviceAvailabilityStatistics -StatId uptime -FromTime (Get-Date).AddDays(-1) -ThruTime (Get-Date) -Interval hour -DeviceType $AuvikDevice.DeviceType)[0] | Should -Not -BeNullOrEmpty
    }

    It 'Returns AuvikDeviceAvailabilityStatistics by DeviceId' {
        (Get-AuvikDeviceAvailabilityStatistics -StatId uptime -FromTime (Get-Date).AddDays(-1) -ThruTime (Get-Date) -Interval hour -DeviceId $AuvikDevice.Id) | Should -Not -BeNullOrEmpty
    }
}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}