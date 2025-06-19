param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Get-AuvikComponent Tests' -Tags 'Unit' {
    BeforeAll {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop
        $Tenants = Get-AuvikTenant
        $Component = Get-AuvikComponent -TenantID ($Tenants[0]).ID -Pages 1
        #$ModifiedAfter = ($Component | Where-Object {$_.LastModified -gt 1})[0]
        $ParentDevice = ($Component.parentDevice | Where-Object {("" -ne $_.Id) -and ("" -ne $_.DeviceName)})[0]
        $CurrentStatus = ($Component | Where-Object {$_.CurrentStatus -in @('ok','degraded','failed')})[0].CurrentStatus


    }

    It 'Returns Component by Tenant' {
        $Component | Should -Not -BeNullOrEmpty
    }

    # In testing, the ModifiedAfter field was not populated
    <#It 'Returns Component by ModifiedAfter' {
        (Get-AuvikComponent -ModifiedAfter $ModifiedAfter.LastModified -Pages 1).LastModified | Sort-Object -Unique | Should -BeTrue
    }#>

    It 'Returns Component by Parent Device ID' {
        (Get-AuvikComponent -DeviceId $ParentDevice.Id -Pages 1).ParentDevice.Id | Sort-Object -Unique | Should -Be $ParentDevice.Id
    }

    It 'Returns Component by Parent Device Name' {
        (Get-AuvikComponent -DeviceName $ParentDevice.DeviceName -Pages 1).ParentDevice.DeviceName | Sort-Object -Unique | Should -Be $ParentDevice.DeviceName
    }

    It 'Returns Component by Current Status' {
        (Get-AuvikComponent -CurrentStatus $CurrentStatus -Pages 1).CurrentStatus | Sort-Object -Unique | Should -Be $CurrentStatus
    }

    It 'Returns Component by Id' {
        (Get-AuvikComponent -Id $Component[0].Id).Id | Should -Be $Component[0].Id
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}