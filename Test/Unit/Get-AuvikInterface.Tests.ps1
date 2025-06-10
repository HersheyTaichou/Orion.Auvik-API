param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Get-AuvikNetwork Tests' -Tags 'Unit' {
    BeforeAll {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop
        $Tenants = Get-AuvikTenant
        $Interface = Get-AuvikInterface -Tenants ($Tenants[0]).ID -LimitResults
        $InterfaceType = ($Interface | Where-Object {"" -ne $_.InterfaceType})[0]
        $ParentDevice = ($Interface.parentDevice | Where-Object {"" -ne $_.Id})[0]
        $OperationalStatus = ($Interface | Where-Object {"" -ne $_.OperationalStatus})[0]
        $ModifiedAfter = ($Interface | Where-Object {"" -ne $_.LastModified})[0]

    }

    It 'Returns Interface by Tenant' {
        $Interface | Should -Not -BeNullOrEmpty
    }

    It 'Returns Interface by InterfaceType' {
        (Get-AuvikInterface -InterfaceType $InterfaceType.InterfaceType -LimitResults)[0].Id -eq $InterfaceType.Id | Should -BeTrue
    }

    It 'Returns Interface by ParentDevice' {
        (Get-AuvikInterface -ParentDevice $ParentDevice.Id -LimitResults)[0].ParentDevice.Id -eq $ParentDevice.Id | Should -BeTrue
    }

    It 'Returns Interface by OperationalStatus' {
        (Get-AuvikInterface -OperationalStatus $OperationalStatus.operationalStatus -LimitResults)[0].Id -eq $OperationalStatus.Id | Should -BeTrue
    }

    It 'Returns Interface by ModifiedAfter' {
        (Get-AuvikInterface -ModifiedAfter $ModifiedAfter.LastModified -LimitResults)[0].Id -eq $ModifiedAfter.Id | Should -BeTrue
    }

    It 'Returns Network by Id' {
        Get-AuvikInterface -Id $Interface[0].Id | Should -Not -BeNullOrEmpty
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}