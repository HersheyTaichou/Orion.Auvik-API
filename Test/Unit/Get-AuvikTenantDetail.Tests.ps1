param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Get-AuvikDevice Tests' -Tags 'Unit' {
    BeforeAll {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop
        $Tenants = Get-AuvikTenant
    }

    It 'Returns Tenant Details by DomainPrefix' {
        Get-AuvikTenantDetail -DomainPrefix $Tenants[0].DomainPrefix | Should -not -BeNullOrEmpty
    }

    It 'Returns Tenant Details by Id' {
        Get-AuvikTenantDetail -DomainPrefix $Tenants[0].DomainPrefix -Id $Tenants[0].Id | Should -not -BeNullOrEmpty
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}