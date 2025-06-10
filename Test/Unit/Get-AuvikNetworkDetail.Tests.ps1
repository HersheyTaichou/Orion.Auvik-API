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
        $NetworkDetail = Get-AuvikNetworkDetail -Tenants ($Tenants[0]).ID -LimitResults
        $Networks = Get-AuvikNetwork -Tenants ($Tenants[0]).ID -LimitResults
        $Devices = Get-AuvikDevice -Tenants ($Tenants[0]).ID -LimitResults
        $NetworkType = $Networks[0].NetworkType
        $ScanStatus = $Networks[0].ScanStatus
        $DeviceId = $Devices[0].id
        $ModifiedAfter = $Networks[0].LastModified
        $Scope = ($NetworkDetail | Where-Object {"Unknown" -ne $_.Scope})[0].Scope

    }

    It 'Returns NetworkDetail by Tenant' {
        $NetworkDetail | Should -Not -BeNullOrEmpty
    }

    It 'Returns NetworkDetail by NetworkType' {
        Get-AuvikNetworkDetail -NetworkType $NetworkType -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns NetworkDetail by ScanStatus' {
        Get-AuvikNetworkDetail -ScanStatus $ScanStatus -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns NetworkDetail by Devices' {
        Get-AuvikNetworkDetail -Devices $DeviceId -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns NetworkDetail by ModifiedAfter' {
        Get-AuvikNetworkDetail -ModifiedAfter $ModifiedAfter -LimitResults | Should -Not -BeNullOrEmpty
    }

    It 'Returns Network by Id' {
        Get-AuvikNetworkDetail -Id $NetworkDetail[0].Id | Should -Not -BeNullOrEmpty
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}