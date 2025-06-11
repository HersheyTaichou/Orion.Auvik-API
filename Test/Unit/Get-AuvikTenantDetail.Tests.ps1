param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Get-AuvikTenantDetail Tests' -Tags 'Unit' {
    BeforeAll {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop
        $Tenants = Get-AuvikTenant
    }

    It 'Returns Tenant Details by DomainPrefix' {
        (Get-AuvikTenantDetail -DomainPrefix $Tenants[0].DomainPrefix).DomainPrefix | Should -Contain $Tenants[0].DomainPrefix
    }

    It 'Returns Tenant Details by Id' {
        (Get-AuvikTenantDetail -DomainPrefix $Tenants[0].DomainPrefix -Id $Tenants[0].Id).Id | Should -Contain $Tenants[0].Id
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}