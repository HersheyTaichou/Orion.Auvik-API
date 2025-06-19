param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Get-AuvikInterface Tests' -Tags 'Unit' {
    BeforeAll {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop
        $Tenants = Get-AuvikTenant
        $Interface = Get-AuvikInterface -TenantID ($Tenants[0]).ID -Pages 1
        $InterfaceType = ($Interface | Where-Object {"" -ne $_.InterfaceType})[0].InterfaceType
        $ParentDevice = ($Interface.parentDevice | Where-Object {"" -ne $_.Id})[0]
        $OperationalStatus = ($Interface | Where-Object {"" -ne $_.OperationalStatus})[0].operationalStatus
        $ModifiedAfter = ($Interface | Where-Object {"" -ne $_.LastModified})[0].LastModified

    }

    It 'Returns Interface by Tenant' {
        $Interface | Should -Not -BeNullOrEmpty
    }

    It 'Returns Interface by InterfaceType' {
        (Get-AuvikInterface -InterfaceType $InterfaceType -Pages 1).InterfaceType | Sort-Object -Unique | Should -Be $InterfaceType
    }

    It 'Returns Interface by ParentDevice' {
        (Get-AuvikInterface -ParentDevice $ParentDevice.Id -Pages 1).ParentDevice.Id | Sort-Object -Unique | Should -Be $ParentDevice.Id
    }

    It 'Returns Interface by OperationalStatus' {
        (Get-AuvikInterface -OperationalStatus $OperationalStatus -Pages 1).OperationalStatus | Sort-Object -Unique | Should -Be $OperationalStatus
    }

    It 'Returns Interface by ModifiedAfter' {
        (Get-AuvikInterface -ModifiedAfter $ModifiedAfter -Pages 1).LastModified | Sort-Object -Unique -Top 1 | Should -BeGreaterOrEqual $ModifiedAfter
    }

    It 'Returns Network by Id' {
        (Get-AuvikInterface -Id $Interface[0].Id).Id | Should -Be $Interface[0].Id
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}