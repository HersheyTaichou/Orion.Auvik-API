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
        $DeviceLifecycle = Get-AuvikDeviceLifecycle -TenantID ($Tenants[0]).ID -Pages 1
        $SalesAvailability = ($DeviceLifecycle | Where-Object {"" -ne $_.SalesAvailability})[0].SalesAvailability
        $SoftwareMaintenanceStatus = ($DeviceLifecycle | Where-Object {"" -ne $_.SoftwareMaintenanceStatus})[0].SoftwareMaintenanceStatus
        $SecuritySoftwareMaintenanceStatus = ($DeviceLifecycle | Where-Object {"" -ne $_.SecuritySoftwareMaintenanceStatus})[0].SecuritySoftwareMaintenanceStatus
        $LastSupportStatus = ($DeviceLifecycle | Where-Object {"" -ne $_.LastSupportStatus})[0].LastSupportStatus
    }

    It 'Returns devices by Tenant' {
        $DeviceLifecycle | Should -Not -BeNullOrEmpty
    }

    It 'Returns devices by SalesAvailability' {
        (Get-AuvikDeviceLifecycle -SalesAvailability $SalesAvailability -Pages 1).SalesAvailability | Sort-Object -Unique | Should -Be $SalesAvailability
    }

    It 'Returns devices by SoftwareMaintenanceStatus' {
        (Get-AuvikDeviceLifecycle -SoftwareMaintenanceStatus $SoftwareMaintenanceStatus -Pages 1).SoftwareMaintenanceStatus | Sort-Object -Unique | Should -Be $SoftwareMaintenanceStatus
    }

    It 'Returns devices by SecuritySoftwareMaintenanceStatus' {
        (Get-AuvikDeviceLifecycle -SecuritySoftwareMaintenanceStatus $SecuritySoftwareMaintenanceStatus -Pages 1).SecuritySoftwareMaintenanceStatus | Sort-Object -Unique | Should -Be $SecuritySoftwareMaintenanceStatus
    }

    It 'Returns devices by LastSupportStatus' {
        (Get-AuvikDeviceLifecycle -LastSupportStatus $LastSupportStatus -Pages 1).LastSupportStatus | Sort-Object -Unique | Should -Be $LastSupportStatus
    }

    It 'Returns device by Id' {
        (Get-AuvikDeviceLifecycle -Id $DeviceLifecycle[0].Id).Id | Should -Be $DeviceLifecycle[0].Id
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}