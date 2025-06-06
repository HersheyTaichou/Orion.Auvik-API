<#
.SYNOPSIS
Retrieve a list of the universal common parameters

.DESCRIPTION
Retrieve a list of the universal common parameters, so you can determine the difference between common parameters and parameters passed to a function

.EXAMPLE
Get-CommonParameterNames
Verbose
Debug
ErrorAction
WarningAction
InformationAction
ProgressAction
ErrorVariable
WarningVariable
InformationVariable
OutVariable
OutBuffer
PipelineVariable

.NOTES
This is an internal function, and not meant to be published with the module
#>
Function Get-CommonParameterName
{
    [CmdletBinding()]
    param()
    process
    {
        (Get-Command Get-CommonParameterName).Parameters.Keys
    }
}