param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Invoke-AuvikApi Tests' -Tags 'Unit' {
    It 'Can query the Auvik API' {
        Invoke-AuvikApi -Uri "https://auvikapi.us3.my.auvik.com/v1/authentication/verify"
    }
}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}