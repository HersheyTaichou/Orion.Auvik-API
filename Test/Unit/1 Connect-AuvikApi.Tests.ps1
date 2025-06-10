param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Connect-AuvikApi Tests' -Tags 'Unit' {
    It 'Connects to the Auvik API successfully' {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop | Should -Be 'Connected to the Auvik API'
    }
}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}