param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Get-AuvikConfiguration Tests' -Tags 'Unit' {
    BeforeAll {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop
        $Tenants = Get-AuvikTenant
        $Configuration = (Get-AuvikConfiguration -TenantID ($Tenants[0]).ID -Pages 1)[0]


    }

    It 'Returns Configuration by Tenant' {
        $Configuration | Should -Not -BeNullOrEmpty
    }

    It 'Returns Configuration by Parent Device ID' {
        (Get-AuvikConfiguration -DeviceId $Configuration.Device.Id -Pages 1).Device.Id | Sort-Object -Unique | Should -Be $Configuration.Device.Id
    }

    It 'Returns Configuration by BackupTimeAfter' {
        (Get-AuvikConfiguration -BackupTimeAfter $Configuration.BackupTime -Pages 1).BackupTime | Sort-Object -Unique -Top 1 | Should -BeGreaterOrEqual $Configuration.BackupTime
    }

    It 'Returns Configuration by backupTimeBefore' {
        (Get-AuvikConfiguration -backupTimeBefore $Configuration.backupTime -Pages 1).CurrentStatus | Sort-Object -Unique -Top 1 | Should -BeLessOrEqual $Configuration.BackupTime
    }

    It 'Returns Configuration by Id' {
        (Get-AuvikConfiguration -Id $Configuration.Id).Id | Should -Be $Configuration.Id
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}