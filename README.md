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
   2. At the top, note the URL in the browser, it should look like "https://domain.us1.my.auvik.com/
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
Connect-AuvikApi -Credential $AuvikCreds -Uri "https://auvikapi.us3.my.auvik.com"
```

You can now run any of the other commands for the Auvik API.

For automated tasks, the credentials and Uri can be stored, but the credentials need to be passed to Connect-AuvikApi as a PSCredential object.

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
| /inventory/network/detail | Done | Get-AuvikNetworkDetail |
| /inventory/network/detail/{id} | Done | Get-AuvikNetworkDetail |
| /inventory/interface/info | Done | Get-AuvikInterface |
| /inventory/interface/info/{id} | Done | Get-AuvikInterface |
| /inventory/component/info | To-Do | - |
| /inventory/component/info/{id} | To-Do | - |
| /inventory/entity/note | To-Do | - |
| /inventory/entity/note/{id} | To-Do | - |
| /inventory/entity/audit | To-Do | - |
| /inventory/entity/audit/{id} | To-Do | - |
| /inventory/configuration | To-Do | - |
| /inventory/configuration/{id} | To-Do | - |
| /alert/history/info | To-Do | - |
| /alert/history/info/{id} | To-Do | - |
| /alert/dismiss/{id} | To-Do | - |
| /authentication/verify | Done | Connect-AuvikApi | Pass |
| /tenants | Done | Get-AuvikTenant | Pass |
| /tenants/detail | Done | Get-AuvikTenantDetail |
| /tenants/detail/{id} | Done | Get-AuvikTenantDetail |
| /billing/usage/client | To-Do | - |
| /billing/usage/device/{id} | To-Do | - |
| /stat/device/{statId} | To-Do | - |
| /stat/deviceAvailability/{statId} | To-Do | - |
| /stat/service/{statId} | To-Do | - |
| /stat/interface/{statId} | To-Do | - |
| /stat/component/{componentType}/{statId} | To-Do | - |
| /stat/oid/{statId} | To-Do | - |
| /settings/snmppoller | To-Do | - |
| /settings/snmppoller/{snmpPollerSettingId} | To-Do | - |
| /settings/snmppoller/{snmpPollerSettingId}/devices | To-Do | - |
| /stat/snmppoller/string | To-Do | - |
| /stat/snmppoller/int | To-Do | - |
| /asm/app/info | To-Do | - |
| /asm/client/info | To-Do | - |
| /asm/securityLog/info | To-Do | - |
| /asm/tag/info | To-Do | - |
| /asm/user/info | To-Do | - |

---
Maintained by Mike Hiersche
