param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Get-AuvikDeviceLifecycle Tests' -Tags 'Unit' {
    BeforeAll {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop
        $Tenants = Get-AuvikTenant
        $DeviceLifecycle = Get-AuvikDeviceLifecycle -Tenants ($Tenants[0]).ID -LimitResults
        $SalesAvailability = ($DeviceLifecycle | Where-Object {"" -ne $_.SalesAvailability})[0].SalesAvailability
        $SoftwareMaintenanceStatus = ($DeviceLifecycle | Where-Object {"" -ne $_.SoftwareMaintenanceStatus})[0].SoftwareMaintenanceStatus
        $SecuritySoftwareMaintenanceStatus = ($DeviceLifecycle | Where-Object {"" -ne $_.SecuritySoftwareMaintenanceStatus})[0].SecuritySoftwareMaintenanceStatus
        $LastSupportStatus = ($DeviceLifecycle | Where-Object {"" -ne $_.LastSupportStatus})[0].LastSupportStatus
    }

    It 'Returns devices by Tenant' {
        $DeviceLifecycle | Should -Not -BeNullOrEmpty
    }

    It 'Returns devices by SalesAvailability' {
        Get-AuvikDeviceLifecycle -SalesAvailability $SalesAvailability -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns devices by SoftwareMaintenanceStatus' {
        Get-AuvikDeviceLifecycle -SoftwareMaintenanceStatus $SoftwareMaintenanceStatus -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns devices by SecuritySoftwareMaintenanceStatus' {
        Get-AuvikDeviceLifecycle -SecuritySoftwareMaintenanceStatus $SecuritySoftwareMaintenanceStatus -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns devices by LastSupportStatus' {
        Get-AuvikDeviceLifecycle -LastSupportStatus $LastSupportStatus -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns device by Id' {
        Get-AuvikDeviceLifecycle -Id $DeviceLifecycle[0].Id | Should -Not -BeNullOrEmpty
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}