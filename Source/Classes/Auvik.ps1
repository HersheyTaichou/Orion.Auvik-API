<#
enum OnlineStatus {
    online
    offline
    unreachable
    testing
    unknown
    dormant
    notPresent
    lowerLayerDown
}

enum DeviceType {
    unknown
    switch
    l3Switch
    router
    accessPoint
    firewall
    workstation
    server
    storage
    printer
    copier
    hypervisor
    multimedia
    phone
    tablet
    handheld
    virtualAppliance
    bridge
    controller
    hub
    modem
    ups
    module
    loadBalancer
    camera
    telecommunications
    packetProcessor
    chassis
    airConditioner
    virtualMachine
    pdu
    ipPhone
    backhaul
    internetOfThings
    voipSwitch
    stack
    backupDevice
    timeClock
    lightingDevice
    audioVisual
    securityAppliance
    utm
    alarm
    buildingManagement
    ipmi
    thinAccessPoint
    thinClient
}

enum DiscoveryStatus {
    disabled
    determining
    notSupported
    notAuthorized
    authorizing
    authorized
    privileged
}

enum TrafficInsightsStatus {
    notDetected
    detected
    notApproved
    approved
    linking
    linkingFailed
    forwarding
}
#>
class AuvikTenant {
    [string]$Id
    [string]$DomainPrefix
    [string]$DisplayName
    [string]$TenantType
    [bool]$Enabled
    [string]$Subscribed
    [string]$SubscriptionOwner
    [bool]$Running
    [datetime]$TrialStartDate
    [datetime]$trialEndDate
    [PSCustomObject]$Address
    [AuvikTenant]$Parent
    [PSCustomObject]$Authorizations
    hidden $Tenant

    AuvikTenant() { $this.Init(@{}) }

    AuvikTenant([PSCustomObject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'DomainPrefix' = $Data.attributes.domainPrefix
            "DisplayName" = $Data.attributes.DisplayName
            'TenantType' = $Data.attributes.tenantType
            "Enabled" = $Data.attributes.Enabled
            "Subscribed" = $Data.attributes.Subscribed
            "SubscriptionOwner" = $Data.attributes.SubscriptionOwner
            "Running" = $Data.attributes.Running
            "TrialStartDate" = if ($Content.data.attributes.TrialStartDate) {$Content.data.attributes.TrialStartDate} else {0}
            "trialEndDate" = if ($Content.data.attributes.trialEndDate) {$Content.data.attributes.trialEndDate} else {0}
            "Address" = $Data.attributes.Address
            'Parent' = $Data.relationships.parent.data
            'Authorizations' = $Data.relationships.Authorizations.data
            'Tenant' = $Data
        })
    }

    AuvikTenant([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikLink {
    [uri]$Dashboard
    [uri]$Info
    [uri]$Self

    AuvikLink() { $this.Init(@{}) }

    AuvikLink([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikAddress {
    [string]$Address1
    [string]$Address2
    [string]$City
    [string]$State
    [string]$PostalCode
    [string]$Country

    AuvikAddress() { $this.Init(@{}) }

    AuvikAddress([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikNetworkDetail {
    [string]$Id
    [string]$Scope
    [string]$PrimaryCollector
    [string[]]$SecondaryCollectors
    [string]$CollectorSelection
    [string[]]$ExcludedIpAddresses
    [AuvikTenant]$Tenant
    [AuvikLink]$Links
    hidden $NetworkDetail

    AuvikNetworkDetail() { $this.Init(@{}) }

    AuvikNetworkDetail([PSCustomObject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'Scope' = $Data.attributes.Scope
            'PrimaryCollector' = $Data.attributes.PrimaryCollector
            'SecondaryCollectors' = $Data.attributes.SecondaryCollectors
            'CollectorSelection' = $Data.attributes.CollectorSelection
            'ExcludedIpAddresses' = $Data.attributes.ExcludedIpAddresses
            'Tenant' = $Data.relationships.tenant.data
            'Links' =$Content.data.links
            'NetworkDetail' = $Data
        })
    }

    AuvikNetworkDetail([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikNetwork {
    [string]$Id
    [string]$NetworkType
    [string]$networkName
    [string]$Description
    [string]$ScanStatus
    [datetime]$LastModified
    [AuvikNetworkDetail[]]$NetworkDetail
    [AuvikTenant]$Tenant
    [AuvikDevice[]]$Device
    [AuvikLink]$Links
    hidden $Network

    AuvikNetwork() {
        $this.Init(@{})
    }

    AuvikNetwork([PSCustomObject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'NetworkType' = $Data.attributes.networkType
            'NetworkName' = $Data.attributes.networkName
            'Description' = $Data.attributes.description
            'ScanStatus' = $Data.attributes.scanStatus
            'LastModified' = if ($Data.attributes.lastModified) {$Data.attributes.lastModified} else {0}
            'NetworkDetail' = if ($Content.Included) {$Content.Included} else {$null}
            'Tenant' = $Data.relationships.tenant.data
            'Device' = $Data.relationships.devices.data
            'Links' = $Data.links
            'Network' = $Content
        })
    }

    AuvikNetwork([hashtable]$Properties) {
        $this.Init($Properties)
    }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }

    }
}

class AuvikDevice {
    [string]$Id
    [ipaddress[]]$IpAddresses
    [string]$DeviceName
    [string]$DeviceType
    [string]$MakeModel
    [string]$VendorName
    [string]$SoftwareVersion
    [string]$SerialNumber
    [string]$Description
    [string]$FirmwareVersion
    [datetime]$LastModified
    [datetime]$LastSeenTime
    [string]$OnlineStatus
    [AuvikTenant]$Tenant
    [AuvikNetwork[]]$Network
    [AuvikDeviceDetail[]]$DeviceDetail
    [AuvikLink]$Links
    hidden $Device

    AuvikDevice() { $this.Init(@{}) }

    AuvikDevice([PSCustomObject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'IpAddresses' = $Data.attributes.ipAddresses
            'DeviceName' = $Data.attributes.DeviceName
            'DeviceType' = $Data.attributes.DeviceType
            'MakeModel' = $Data.attributes.MakeModel
            'VendorName' = $Data.attributes.VendorName
            'SoftwareVersion' = $Data.attributes.SoftwareVersion
            'SerialNumber' = $Data.attributes.SerialNumber
            'Description' = $Data.attributes.Description
            'FirmwareVersion' = $Data.attributes.FirmwareVersion
            'LastModified' = if ($Content.data.attributes.LastModified) {$Content.data.attributes.LastModified} else {0}
            'LastSeenTime' = if ($Content.data.attributes.LastSeenTime) {$Content.data.attributes.LastSeenTime} else {0}
            'OnlineStatus' = $Data.attributes.OnlineStatus
            'Tenant' = $Data.relationships.tenant.data
            'Network' = $Data.relationships.Networks.data #| ForEach-Object {[AuvikNetwork]::new($_)}
            'DeviceDetail' = $Content.included
            'Links' = $Data.Links
            'Device' = $Content
        })
    }

    AuvikDevice([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikDeviceDetail {
    [string]$Id
    [bool]$ManageStatus
    [string]$SnmpStatus
    [string]$LoginStatus
    [string]$WmiStatus
    [string]$VMwareStatus
    [string]$TrafficInsightsStatus
    [AuvikTenant]$Tenant
    [AuvikDevice[]]$ConnectedDevices
    [PSCustomObject[]]$Interfaces
    [PSCustomObject[]]$Configurations
    [PSCustomObject[]]$Components
    [AuvikLink]$Links
    hidden $DeviceDetail


    AuvikDeviceDetail() { $this.Init(@{}) }

    AuvikDeviceDetail([PSCustomObject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'ManageStatus' = $Data.attributes.ManageStatus
            'SnmpStatus' = $Data.attributes.discoveryStatus.snmp
            'LoginStatus' = $Data.attributes.discoveryStatus.login
            'WmiStatus' = $Data.attributes.discoveryStatus.wmi
            'VMwareStatus' = $Data.attributes.discoveryStatus.vmware
            'TrafficInsightsStatus' = $Data.attributes.TrafficInsightsStatus
            'Tenant' = $Data.relationships.tenant.data
            'ConnectedDevices' = $Data.relationships.ConnectedDevices.data #| ForEach-Object {[AuvikDevice]::new($_)}
            'Interfaces' = $Data.relationships.Interfaces.data #| ForEach-Object {[PSCustomObject]::new($_)}
            'Configurations' = $Data.relationships.Configurations.data #| ForEach-Object {[PSCustomObject]::new($_)}
            'Components' = $Data.relationships.Components.data #| ForEach-Object {[PSCustomObject]::new($_)}
            'Links' = $Data.Links
            'DeviceDetail' = $Data
        })
    }

    AuvikDeviceDetail([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikDeviceExtendedDetail {
    [string]$Id
    [AuvikLink]$Links
    [string]$DeviceName
    [string]$DeviceType
    [datetime]$LastModified
    [datetime]$LastSeenTime
    [pscustomobject]$Attributes
    [AuvikTenant]$Tenant
    [AuvikNetwork[]]$Networks
    [AuvikDeviceDetail[]]$DeviceDetail
    [AuvikDevice]$Members
    hidden $DeviceExtendedDetail


    AuvikDeviceExtendedDetail() { $this.Init(@{}) }

    AuvikDeviceExtendedDetail([PSCustomObject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $NoteProperty = ($Data.attributes | Get-Member -MemberType "NoteProperty" | Where-Object {$_.Name -notin @('DeviceName','DeviceType','LastModified','LastSeenTime')}).Name
        $this.Init(@{
            'Id' = $Data.id
            'Links' = $Data.Links
            'DeviceName' = $Data.attributes.DeviceName
            'DeviceType' = $Data.attributes.DeviceType
            'LastModified' = if ($Content.data.attributes.LastModified) {$Content.data.attributes.LastModified} else {0}
            'LastSeenTime' = if ($Content.data.attributes.LastSeenTime) {$Content.data.attributes.LastSeenTime} else {0}
            'Attributes' = $NoteProperty | ForEach-Object {@{$_ = $Data.attributes.$_}}
            'Tenant' = $Data.relationships.tenant.data
            #'Networks' = $Data.relationships.Networks.data
            #'DeviceDetail' = $Data.relationships.deviceDetail.data
            #'Members' = $Data.relationships.members
            'DeviceExtendedDetail' = $Data
        })
    }

    AuvikDeviceExtendedDetail([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikDeviceWarranty {
    [string]$Id
    [string]$DeviceName
    [string]$ServiceCoverageStatus
    [string]$ServiceAttachmentStatus
    [string]$ContractRenewalAvailability
    [string]$WarrantyCoverageStatus
    [string]$WarrantyExpirationDate
    [string]$RecommendedSoftwareVersion
    [AuvikTenant]$Tenant
    [AuvikLink]$Links
    hidden $DeviceWarranty

    AuvikDeviceWarranty() { $this.Init(@{}) }

    AuvikDeviceWarranty([PSCustomObject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'DeviceName' = $Data.attributes.DeviceName
            'ServiceCoverageStatus' = $Data.attributes.ServiceCoverageStatus
            'ServiceAttachmentStatus' = $Data.attributes.ServiceAttachmentStatus
            'ContractRenewalAvailability' = $Data.attributes.ContractRenewalAvailability
            'WarrantyCoverageStatus' = $Data.attributes.WarrantyCoverageStatus
            'WarrantyExpirationDate' = $Data.attributes.WarrantyExpirationDate
            'RecommendedSoftwareVersion' = $Data.attributes.RecommendedSoftwareVersion
            'Tenant' = $Data.relationships.tenant.data
            'Links' = $Data.Links
            'DeviceWarranty' = $Content
        })
    }

    AuvikDeviceWarranty([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikDeviceLifecycle {
    [string]$Id
    [string]$DeviceName
    [string]$SalesAvailability
    [string]$SoftwareMaintenanceStatus
    [string]$SecuritySoftwareMaintenanceStatus
    [string]$LastSupportStatus
    [AuvikTenant]$Tenant
    [AuvikDevice]$Device
    [AuvikLink]$Links
    hidden $deviceLifecycle

    AuvikDeviceLifecycle() { $this.Init(@{}) }

    AuvikDeviceLifecycle([PSCustomObject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'DeviceName' = $Data.attributes.DeviceName
            'salesAvailability' = $Data.attributes.salesAvailability
            'softwareMaintenanceStatus' = $Data.attributes.softwareMaintenanceStatus
            'securitySoftwareMaintenanceStatus' = $Data.attributes.securitySoftwareMaintenanceStatus
            'lastSupportStatus' = $Data.attributes.lastSupportStatus
            'Tenant' = $Data.relationships.tenant.data
            'Device' = $Data.relationships.Device.data
            'Links' = $Data.Links
            'DeviceLifecycle' = $Content
        })
    }

    AuvikDeviceLifecycle([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class ChangeMe {
    [string]$Id
    [string]$DeviceName
    [AuvikTenant]$Tenant
    [AuvikLink]$Links
    hidden $ChangeMe

    ChangeMe() { $this.Init(@{}) }

    ChangeMe([PSCustomObject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'DeviceName' = $Data.attributes.DeviceName
            'Tenant' = $Data.relationships.tenant.data
            'Links' = $Data.Links
            'ChangeMe' = $Content
        })
    }

    ChangeMe([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}