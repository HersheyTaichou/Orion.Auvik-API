param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Get-AuvikNetworkDetail Tests' -Tags 'Unit' {
    BeforeAll {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop
        $Tenants = Get-AuvikTenant
        $Networks = (Get-AuvikNetwork -TenantID ($Tenants[0]).ID -LimitResults)[0]
        $Devices = (Get-AuvikDevice -TenantID ($Tenants[0]).ID -LimitResults)[0]

    }

    It 'Returns NetworkDetail by Tenant' {
        (Get-AuvikNetworkDetail -TenantID $Tenants.Id -LimitResults) | Should -Not -BeNullOrEmpty
    }

    It 'Returns NetworkDetail by NetworkType' {
        (Get-AuvikNetworkDetail -NetworkType $Networks.NetworkType -LimitResults).Id | Sort-Object -Unique | Should -Contain $Networks.Id
    }

    It 'Returns NetworkDetail by ScanStatus' {
        (Get-AuvikNetworkDetail -ScanStatus $Networks.ScanStatus -LimitResults).Id | Sort-Object -Unique | Should -Contain $Networks.Id
    }

    It 'Returns NetworkDetail by Devices' {
        (Get-AuvikNetworkDetail -Devices $Devices.Id -LimitResults).Id | Sort-Object -Unique | Should -Not -BeNullOrEmpty
    }

    It 'Returns NetworkDetail by ModifiedAfter' {
        Get-AuvikNetworkDetail -ModifiedAfter $Networks.LastModified -LimitResults | Sort-Object -Unique -Top 1 | Should -BeGreaterOrEqual $Networks.LastModified
    }

    It 'Returns Network by Id' {
        (Get-AuvikNetworkDetail -Id $Networks.Id).Id | Should -Be $Networks.Id
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}