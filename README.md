# Orion.Auvik-Api

A PowerShell wrapper for the Auvik API

## Introduction

This module is a wrapper for the Auvik API. It was built with and requires PowerShell 7.0 support.

### Similar projects

Here are similar projects I found when looking into this.

- [Celerium.Auvik](https://github.com/Celerium/Celerium.Auvik?tab=readme-ov-file)
- [Auvik-PowerShell-Module](https://github.com/DarrenWhite99/Auvik-PowerShell-Module)

### Why Build Another?

The Auvik API buries a lot of the information under multiple levels and I wanted to take the data returned and arange it into Classes, while moving the relevant data to the top level, making reports and investigations easier.

## Getting Started

Before you can query the Auvik API, you will need to authenticate with it. To authenticate, you will need to know the following information:

1. The API endpoint for your Auvik tenant
   1. Log into your Auvik account.
   2. At the top, note the URL in the browser, it should look like "<https://domain.us1.my.auvik.com/>"
   3. Replace "domain" in your URL with "auvikapi", this is your API endpoint
2. The API key for your account
   1. Log into your Auvik account.
   2. At the top left corner, use the dropdown to select the relevant account
   3. At the bottom left corner, click on your name
   4. On the right side, use the API Key box to generate an API key
      - When regenerating a key, it is not saved until you click Save

Once you have the above information, you will need to run "Connect-AuvikApi" in PowerShell:

```PowerShell
$AuvikCreds = Get-Credential -Message "Enter your username and API key to Auvik"
Connect-AuvikApi -Credential $AuvikCreds -Uri "https://auvikapi.us1.my.auvik.com"
```

You can now run any of the other commands for the Auvik API.

For automated tasks, the credentials and Uri can be stored, but the credentials need to be passed to Connect-AuvikApi as a PSCredential object.

## Naming and Output Conventions

### Functions

The functions start with the correct verb based on PowerShell best practices. Get queries are replaced with "Get-" and Post queries are replaced with the closest equivalent based on the action performed.

The Noun section starts with "Auvik", to indicate it is interacting with Auvik. For Get- commands, the final part is the data type returned. For other commands, it is based on the action taken.

By default, all results are returned.

### Classes

The PowerShell classes are prepended with "Auvik" then named after the data type that is returned by the Auvik API. Taking the json output from the API and formatting it into PowerShell objects is done in the class.

[Here is an example output of a query](./Example-Device.json), taken from Auvik's API documentation

Anything under "attributes" is moved up one level and everything related is sent to create it's own data type object. The top-level links and meta sections are dropped as unneeded.

```PowerShell
$AuvikDevice

Id              : MTk5NTAyNzg2ODc3MDYzNDI1LDE5OTUwMjc5MTExMzAyODg2Nw
IpAddresses     : {10.0.0.1}
DeviceName      : MyAccessPoint
DeviceType      : accessPoint
MakeModel       : M Series Access Point
VendorName      : Ubiquiti
SoftwareVersion : 3.9.3.7537
SerialNumber    : 1Q2W3E4R5T6Y
Description     : Linux 3.3.8 #1 Fri Oct 13 11:12:44 PDT 2017 mips
FirmwareVersion : unifi-v1.6.7.249-gb74e0282
LastModified    : 3/12/2018 12:00:00 PM
LastSeenTime    : 11/30/2018 6:34:39 PM
OnlineStatus    : online
Tenant          : AuvikTenant
Network         : {MTk5NTAyNzg2ODc3MDYzMTY5LDE5OTUwMjc5MTExMjc4NTkyMw}
DeviceDetail    : {MTk5NTAyNzg2ODc3MDYzNDI1LDE5OTUwMjc5MTExMzAyODg2Nw}
Links           : @{dashboard=https://sampledomain.my.auvik.com/#entity/device/199502791112896003/dashboard; self=https://auvikapi.us3.my.auvik.com/v1/inventory/device/info/MTk5NTAyNzg2ODc3MDYzNDI1LDE5OTUwMjc5MTExMzAyODg2Nw}
```

Each class also contains a hidden object with the original data used to build the class, named after the data type. In the above example, it would be this:

```PowerShell
$AuvikDevice.Device

$AuvikDevice.Device | fl

data     : {@{type=device; id=MTk5NTAyNzg2ODc3MDYzNDI1LDE5OTUwMjc5MTExMzAyODg2Nw; attributes=; relationships=; links=}}
included : {@{type=deviceDetail; id=MTk5NTAyNzg2ODc3MDYzNDI1LDE5OTUwMjc5MTExMzAyODg2Nw; attributes=; relationships=;
           links=}}
links    : @{next=https://auvikapi.us3.my.auvik.com/v1/inventory/device/info?page[after]=Y3Vyc29yOk16TXpPVE0wT0RRNU1UQT
           ROemN4TlRneExETXpNemt6TkRnME56QXpORFF5TmpFeU5R&page[first]=300; prev=https://auvikapi.us3.my.auvik.com/v1/in
           ventory/device/info?page[before]=Y3Vyc29yOk16TXpPVE0wT0RRNU1UQTROemN4TlRneExETXpNemt6TkRnME56QXpORFF5TmpFeU5
           R&page[last]=300; first=https://auvikapi.us3.my.auvik.com/v1/inventory/device/info?page[first]=300;
           last=https://auvikapi.us3.my.auvik.com/v1/inventory/device/info?page[last]=300}
meta     : @{totalPages=5}
```

## Progress

| Endpoint | Status | Command | Tests |
| -- | -- | -- | -- |
| /inventory/device/info | Done | Get-AuvikDevice | Pass |
| /inventory/device/info/{id} | Done | Get-AuvikDevice | Pass |
| /inventory/device/detail | Done | Get-AuvikDeviceDetail | Pass |
| /inventory/device/detail/{id} | Done | Get-AuvikDeviceDetail | Pass |
| /inventory/device/detail/extended | Error | Get-AuvikDeviceExtendedDetail | - |
| /inventory/device/detail/extended/{id} | Done | Get-AuvikDeviceExtendedDetail | Pass |
| /inventory/device/warranty | Done | Get-AuvikDeviceWarranty | Pass |
| /inventory/device/warranty/{id} | Done | Get-AuvikDeviceWarranty | Pass |
| /inventory/device/lifecycle | Done | Get-AuvikDeviceLifecycle | Pass |
| /inventory/device/lifecycle/{id} | Done | Get-AuvikDeviceLifecycle | Pass |
| /inventory/network/info | Done | Get-AuvikNetwork | Pass |
| /inventory/network/info/{id} | Done | Get-AuvikNetwork | Pass |
| /inventory/network/detail | Done | Get-AuvikNetworkDetail | Pass |
| /inventory/network/detail/{id} | Done | Get-AuvikNetworkDetail | Pass |
| /inventory/interface/info | Done | Get-AuvikInterface | Pass |
| /inventory/interface/info/{id} | Done | Get-AuvikInterface | Pass |
| /inventory/component/info | Done | Get-AuvikComponent | Pass |
| /inventory/component/info/{id} | Done | Get-AuvikComponent | Pass |
| /inventory/entity/note | Done | Get-AuvikEntityNote | Pass |
| /inventory/entity/note/{id} | Done | Get-AuvikEntityNote | Pass |
| /inventory/entity/audit | To-Do | Get-AuvikEntityAudit | - |
| /inventory/entity/audit/{id} | To-Do | Get-AuvikEntityAudit | - |
| /inventory/configuration | To-Do | Get-AuvikConfiguration | - |
| /inventory/configuration/{id} | To-Do | Get-AuvikConfiguration | - |
| /alert/history/info | To-Do | Get-AuvikAlert | - |
| /alert/history/info/{id} | To-Do | Get-AuvikAlert | - |
| /alert/dismiss/{id} | To-Do | Clear-AuvikAlert | - |
| /authentication/verify | Done | Connect-AuvikApi | Pass |
| /tenants | Done | Get-AuvikTenant | Pass |
| /tenants/detail | Done | Get-AuvikTenantDetail | Pass |
| /tenants/detail/{id} | Done | Get-AuvikTenantDetail | Pass |
| /billing/usage/client | To-Do | Get-AuvikClientUsage | - |
| /billing/usage/device/{id} | To-Do | Get-AuvikClientUsage | - |
| /stat/device/{statId} | To-Do | Get-AuvikDeviceStatistics | - |
| /stat/deviceAvailability/{statId} | To-Do | Get-AuvikDeviceAvailabilityStatistics | - |
| /stat/service/{statId} | To-Do | Get-AuvikServiceStatistics | - |
| /stat/interface/{statId} | To-Do | Get-AuvikInterfaceStatistics | - |
| /stat/component/{componentType}/{statId} | To-Do | Get-AuvikComponentStatistics | - |
| /stat/oid/{statId} | To-Do | Get-AuvikDeviceOidMonitor | - |
| /settings/snmppoller | To-Do | Get-AuvikSnmpPollerSetting | - |
| /settings/snmppoller/{snmpPollerSettingId} | To-Do | Get-AuvikSnmpPollerSetting | - |
| /settings/snmppoller/{snmpPollerSettingId}/devices | To-Do | Get-AuvikSnmpPollerSettingDevice | - |
| /stat/snmppoller/string | To-Do | Get-AuvikSnmpPollerHistoryStatistics | - |
| /stat/snmppoller/int | To-Do | Get-AuvikSnmpPollerHistoryStatistics | - |
| /asm/app/info | To-Do | Get-AuvikAsmApp | - |
| /asm/client/info | To-Do | Get-AuvikAsmClient | - |
| /asm/securityLog/info | To-Do | Get-AuvikAsmSecurityLog | - |
| /asm/tag/info | To-Do | Get-AuvikAsmTag | - |
| /asm/user/info | To-Do | Get-AuvikAsmUser | - |

---
Maintained by Mike Hiersche
