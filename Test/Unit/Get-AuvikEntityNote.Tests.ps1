param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Get-AuvikEntityNote Tests' -Tags 'Unit' {
    BeforeAll {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop
        $Tenants = Get-AuvikTenant
        $EntityNote = (Get-AuvikEntityNote -TenantID ($Tenants[0]).ID -Pages 1)[0]


    }

    It 'Returns EntityNote by Tenant' {
        $EntityNote | Should -Not -BeNullOrEmpty
    }

    It 'Returns EntityNote by Entity ID' {
        (Get-AuvikEntityNote -EntityId $EntityNote.EntityId -Pages 1).EntityId | Sort-Object -Unique | Should -Be $EntityNote.EntityId
    }

    It 'Returns EntityNote by Entity Type' {
        (Get-AuvikEntityNote -EntityType $EntityNote.EntityType -Pages 1).EntityType | Sort-Object -Unique | Should -Be $EntityNote.EntityType
    }

    It 'Returns EntityNote by Entity Name' {
        (Get-AuvikEntityNote -EntityName $EntityNote.EntityName -Pages 1).EntityName | Sort-Object -Unique | Should -Be $EntityNote.EntityName
    }

    It 'Returns EntityNote by LastModifiedBy' {
        (Get-AuvikEntityNote -LastModifiedBy $EntityNote.LastModifiedBy -Pages 1).LastModifiedBy | Sort-Object -Unique | Should -Be $EntityNote.LastModifiedBy
    }

    It 'Returns EntityNote by ModifiedAfter' {
        (Get-AuvikEntityNote -ModifiedAfter $EntityNote.LastModified -Pages 1).LastModified | Sort-Object -Unique -Top 1 | Should -BeGreaterOrEqual $EntityNote.LastModified
    }

    It 'Returns EntityNote by Id' {
        (Get-AuvikEntityNote -Id $EntityNote[0].Id).Id | Should -Be $EntityNote[0].Id
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}