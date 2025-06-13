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

    AfterAll {
        Get-Module -Name $ModuleName | Remove-Module -Force
    }

}
