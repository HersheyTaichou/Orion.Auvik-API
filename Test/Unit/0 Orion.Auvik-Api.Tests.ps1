param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    # Remove trailing slash or backslash
    $ModulePath = $ModulePath -replace '[\\/]*$'
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifestName = 'Orion.Auvik-Api.psd1'
    $ModuleManifestPath = Join-Path -Path $ModulePath -ChildPath $ModuleManifestName
    #$ApiCredentials = Get-Credential -Message "Enter the UserName and API key to Auvik"
    #[uri]$BaseUri = Read-Host -Prompt "Enter the API URL for your Auvik Account"
}

Describe 'Core Module Tests' -Tags 'CoreModule', 'Unit' {

    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath
        $? | Should -Be $true
    }

    It 'Loads from module path without errors' {
        {Import-Module "$ModulePath\$ModuleName.psd1" -ErrorAction Stop} | Should -Not -Throw
    }

    <#
    It 'Connects to the Auvik API successfully' {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop | Should -Be 'Connected to the Auvik API'
    }

    Context 'Auvik Tests' {
        BeforeAll {
            $Tenants = Get-AuvikTenant
            $TestTenantId = ($Tenants[$Tenants.Count-1]).ID
            $Devices = Get-AuvikDevice -Tenants $TestTenantId -LimitResults
            $TestDeviceId = $Devices[0].Id
        }

        It 'Returns tenants from the Auvik API' {
            $Tenants | Should -Not -BeNullOrEmpty
        }



        It 'Returns device details from the Auvik API' {
            Get-AuvikDeviceDetail -Id $TestDeviceId | Should -Not -BeNullOrEmpty
        }

        It 'Returns device Extended details from the Auvik API' {
            Get-AuvikDeviceExtendedDetail -Id $TestDeviceId | Should -Not -BeNullOrEmpty
        }

        It 'Returns device Lifecycle details from the Auvik API' {
            Get-AuvikDeviceLifecycle -Tenants $Tenants[0].Id | Should -Not -BeNullOrEmpty
        }

        It 'Returns device Warranty details from the Auvik API' {
            Get-AuvikDeviceWarranty -Tenants $Tenants[0].Id | Should -Not -BeNullOrEmpty
        }
    }
    #>

    AfterAll {
        Get-Module -Name $ModuleName | Remove-Module -Force
    }

}
