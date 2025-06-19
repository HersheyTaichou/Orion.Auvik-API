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
        $Devices = Get-AuvikDevice -TenantID ($Tenants[0]).ID -Pages 1
        $NetworkId = ($Devices.Network | Where-Object {$_.Id -ne ""})[0].Id
        $DeviceType = ($Devices | Where-Object {"" -ne $_.DeviceType})[0].DeviceType
        $MakeModel = ($Devices | Where-Object {"" -ne $_.MakeModel})[0].MakeModel
        $VendorName = ($Devices | Where-Object {"" -ne $_.VendorName})[0].VendorName
        $OnlineStatus = ($Devices | Where-Object {"" -ne $_.OnlineStatus})[0].OnlineStatus
        $ModifiedAfter = ($Devices | Where-Object {"" -ne $_.LastModified})[0].LastModified
        $NotSeenSince = ($Devices | Where-Object {"" -ne $_.LastSeenTime})[0].LastSeenTime
    }

    It 'Returns devices by Tenant' {
        $Devices | Should -Not -BeNullOrEmpty
    }

    It 'Returns devices by Network' {
        (Get-AuvikDevice -Networks $NetworkId -Pages 1).Network.Id | Sort-Object -Unique | Should -Contain $NetworkId
    }

    It 'Returns devices by DeviceType' {
        (Get-AuvikDevice -DeviceType $DeviceType -Pages 1).DeviceType | Sort-Object -Unique | Should -Be $DeviceType
    }

    It 'Returns devices by MakeModel' {
        (Get-AuvikDevice -MakeModel $MakeModel -Pages 1).MakeModel | Sort-Object -Unique | Should -Be $MakeModel
    }

    It 'Returns devices by VendorName' {
        (Get-AuvikDevice -VendorName $VendorName -Pages 1).VendorName | Sort-Object -Unique | Should -Be $VendorName
    }

    It 'Returns devices by OnlineStatus' {
        (Get-AuvikDevice -OnlineStatus $OnlineStatus -Pages 1).OnlineStatus | Sort-Object -Unique | Should -Be $OnlineStatus
    }

    It 'Returns devices by ModifiedAfter' {
        (Get-AuvikDevice -ModifiedAfter $ModifiedAfter -Pages 1).LastModified | Sort-Object -Unique -Top 1 | Should -BeGreaterOrEqual $ModifiedAfter
    }

    It 'Returns devices by NotSeenSince' {
        (Get-AuvikDevice -NotSeenSince $NotSeenSince -Pages 1).LastSeenTime |  Sort-Object -Unique -Top 1 | Should -BeLessOrEqual $NotSeenSince
    }

    It 'Returns devices by StateKnown' {
        Get-AuvikDevice -StateKnown $true -Pages 1 | Should -Not -BeNullOrEmpty
    }

    It 'Returns device by Id' {
        (Get-AuvikDevice -Id $Devices[0].Id).Id | Should -Be $Devices[0].Id
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}