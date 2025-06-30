param(
    $ModulePath = "$PSScriptRoot\..\..\Source\"
)

BeforeAll {
    $ModuleName = (Get-Item "$ModulePath\..").Name
    $ModuleManifest = Get-Item -Path "$ModulePath\$($ModuleName).psd1"
    Import-Module "$ModuleManifest" -ErrorAction Stop
}

Describe 'Get-AuvikAlert Tests' -Tags 'Unit' {
    BeforeAll {
        Connect-AuvikApi -Credential $ApiCredentials -Uri $BaseUri -ErrorAction Stop
        $Tenants = Get-AuvikTenant
        # Some alerts do not return data when queried based on data or AlertDefinitionId, this ID always seems to work.
        $Alert = (Get-AuvikAlert -TenantID ($Tenants[0]).ID -Pages 1 | Where-Object {$_.AlertDefinitionId -eq "MTA4Mzg0MTYzMjU0OTUxMDkwOSwwLC0zNDAw"})[0]
    }

    It 'Returns Alerts by Tenant' {
        $Alert | Should -Not -BeNullOrEmpty
    }

    It 'Returns Alerts by AlertDefinitionId' {
        (Get-AuvikAlert -AlertDefinitionId $Alert.AlertDefinitionId -Pages 1).AlertDefinitionId | Sort-Object -Unique | Should -Be $Alert.AlertDefinitionId
    }

    It 'Returns Alerts by severity' {
        (Get-AuvikAlert -severity $Alert.severity -Pages 1).severity | Sort-Object -Unique | Should -Be $Alert.severity
    }

    It 'Returns Alerts by status' {
        (Get-AuvikAlert -status $Alert.status -Pages 1).status | Sort-Object -Unique | Should -Be $Alert.status
    }

    It 'Returns Alerts by entityId' {
        (Get-AuvikAlert -entityId $Alert.entity.Id -Pages 1).Entity.Id | Sort-Object -Unique | Should -Be $Alert.Entity.Id
    }

    It 'Returns Alerts by dismissed' {
        (Get-AuvikAlert -dismissed $Alert.dismissed -Pages 1).dismissed | Sort-Object -Unique | Should -Be $Alert.dismissed
    }

    It 'Returns Alerts by dispatched' {
        (Get-AuvikAlert -dispatched $Alert.dispatched -Pages 1).dispatched | Sort-Object -Unique | Should -Be $Alert.dispatched
    }

    It 'Returns Alerts by detectedTimeAfter' {
        (Get-AuvikAlert -detectedTimeAfter $Alert.detectedOn -Pages 1).detectedOn | Sort-Object -Unique -Top 1 | Should -BeGreaterOrEqual $Alert.detectedOn
    }

    It 'Returns Alerts by detectedTimeBefore' {
        (Get-AuvikAlert -detectedTimeBefore $Alert.detectedOn -Pages 1).detectedOn | Sort-Object -Unique -Top 1 | Should -BeLessOrEqual $Alert.detectedOn
    }

    It 'Returns device by Id' {
        (Get-AuvikAlert -Id $Alert.Id).Id | Should -Be $Alert.Id
    }

}

AfterAll {
    Get-Module -Name $ModuleName | Remove-Module -Force
}