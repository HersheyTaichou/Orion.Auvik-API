param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Get-AuvikEntityAudit Tests' -Tags 'Unit' {
    BeforeAll {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop
        $Tenants = Get-AuvikTenant
        $EntityAudit = (Get-AuvikEntityAudit -TenantID ($Tenants[0]).ID -Pages 1)[0]


    }

    It 'Returns EntityAudit by Tenant' {
        $EntityAudit | Should -Not -BeNullOrEmpty
    }

    It 'Returns EntityAudit by User' {
        (Get-AuvikEntityAudit -User $EntityAudit.User -Pages 1).User | Sort-Object -Unique | Should -Be $EntityAudit.User
    }

    It 'Returns EntityAudit by Category' {
        (Get-AuvikEntityAudit -Category $EntityAudit.Category -Pages 1).Category | Sort-Object -Unique | Should -Be $EntityAudit.Category
    }

    It 'Returns EntityAudit by Status' {
        (Get-AuvikEntityAudit -Status $EntityAudit.Status -Pages 1).Status | Sort-Object -Unique | Should -Be $EntityAudit.Status
    }

    It 'Returns EntityAudit by ModifiedAfter' {
        (Get-AuvikEntityAudit -ModifiedAfter "$((Get-Date).AddDays(-7))" -Pages 1).dateStarted | Sort-Object -Unique -Top 1 | Should -BeGreaterOrEqual $((Get-Date).AddDays(-7))
    }

    It 'Returns EntityAudit by Id' {
        (Get-AuvikEntityAudit -Id $EntityAudit[0].Id).Id | Should -Be $EntityAudit[0].Id
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}