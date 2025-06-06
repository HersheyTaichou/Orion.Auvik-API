@{
    Path = "Orion.Auvik-Api.psd1"
    OutputDirectory = "..\bin\Orion.Auvik-Api"
    Prefix = '.\_PrefixCode.ps1'
    SourceDirectories = 'Classes','Private','Public'
    PublicFilter = 'Public\*.ps1'
    VersionedOutputDirectory = $true
}
