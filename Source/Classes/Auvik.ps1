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

enum DiscoveryStatus {
    disabled
    determining
    notSupported
    notAuthorized
    authorizing
    authorized
    privileged
    unknown
}

enum TrafficInsightsStatus {
    notDetected
    detected
    notApproved
    approved
    linking
    linkingFailed
    forwarding
    unknown
}

enum LifecycleStatus {
    covered
    available
    expired
    securityOnly
    unpublished
    empty
    unknown
E
}

enum NetworkType {
    routed
    vlan
    wifi
    loopback
    network
    layer2
    internet
    unknown
}

enum ScanStatus {
    true
    false
    notAllowed
    unknown
}

enum Scope {
    private
    public
    unknown
}

enum CurrentStatus {
    notAvailable
    ok
    degraded
    failed
}

enum InterfaceType {
    ethernet
    wifi
    bluetooth
    cdma
    coax
    cpu
    distributedVirtualSwitch
    firewire
    gsm
    ieee8023AdLag
    inferredWired
    inferredWireless
    interface
    linkAggregation
    loopback
    modem
    wimax
    optical
    other
    parallel
    ppp
    radiomac
    rs232
    tunnel
    unknown
    usb
    virtualBridge
    virtualNic
    virtualSwitch
    vlan
}

enum OperationalStatus {
    online
    offline
    unreachable
    testing
    unknown
    dormant
    notPresent
    lowerLayerDown
}

enum EntityType {
    root
    device
    network
    interface
    unknown
}

enum EntityAuditStatus {
    unknown
    initiated
    created
    closed
    failed
}

enum EntityAuditCategory {
    unknown
    tunnel
    terminal
    remoteBrowser
}

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
    [pscustomobject]$Address
    [AuvikTenant]$Parent
    [pscustomobject]$Authorizations
    hidden $Tenant

    AuvikTenant() { $this.Init(@{}) }

    AuvikTenant([pscustomobject]$Content) {
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

class AuvikNetworkDetail {
    [string]$Id
    [Scope]$Scope
    [string]$PrimaryCollector
    [string[]]$SecondaryCollectors
    [string]$CollectorSelection
    [string[]]$ExcludedIpAddresses
    [AuvikTenant]$Tenant
    [pscustomobject]$Links
    hidden $NetworkDetail

    AuvikNetworkDetail() { $this.Init(@{}) }

    AuvikNetworkDetail([pscustomobject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'Scope' = if ($Data.attributes.Scope) {$Data.attributes.Scope} else {"unknown"}
            'PrimaryCollector' = $Data.attributes.PrimaryCollector
            'SecondaryCollectors' = $Data.attributes.SecondaryCollectors
            'CollectorSelection' = $Data.attributes.CollectorSelection
            'ExcludedIpAddresses' = $Data.attributes.ExcludedIpAddresses
            'Tenant' = $Data.relationships.tenant.data
            'Links' = $Data.links
            'NetworkDetail' = $Content
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
    [NetworkType]$NetworkType
    [string]$networkName
    [string]$Description
    [ScanStatus]$ScanStatus
    [datetime]$LastModified
    [AuvikNetworkDetail[]]$NetworkDetail
    [AuvikTenant]$Tenant
    [AuvikDevice[]]$Device
    [pscustomobject]$Links
    hidden $Network

    AuvikNetwork() {
        $this.Init(@{})
    }

    AuvikNetwork([pscustomobject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'NetworkType' = if ($Data.attributes.networkType) {$Data.attributes.networkType} else {"unknown"}
            'NetworkName' = $Data.attributes.networkName
            'Description' = $Data.attributes.description
            'ScanStatus' = if ($Data.attributes.scanStatus) {$Data.attributes.scanStatus} else {"unknown"}
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
    [DeviceType]$DeviceType
    [string]$MakeModel
    [string]$VendorName
    [string]$SoftwareVersion
    [string]$SerialNumber
    [string]$Description
    [string]$FirmwareVersion
    [datetime]$LastModified
    [datetime]$LastSeenTime
    [OnlineStatus]$OnlineStatus
    [AuvikTenant]$Tenant
    [AuvikNetwork[]]$Network
    [AuvikDeviceDetail[]]$DeviceDetail
    [pscustomobject]$Links
    hidden $Device

    AuvikDevice() { $this.Init(@{}) }

    AuvikDevice([pscustomobject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'IpAddresses' = $Data.attributes.ipAddresses
            'DeviceName' = $Data.attributes.DeviceName
            'DeviceType' = if ($Data.attributes.DeviceType) {$Data.attributes.DeviceType} else {"unknown"}
            'MakeModel' = $Data.attributes.MakeModel
            'VendorName' = $Data.attributes.VendorName
            'SoftwareVersion' = $Data.attributes.SoftwareVersion
            'SerialNumber' = $Data.attributes.SerialNumber
            'Description' = $Data.attributes.Description
            'FirmwareVersion' = $Data.attributes.FirmwareVersion
            'LastModified' = if ($Data.attributes.LastModified) {$Data.attributes.LastModified} else {0}
            'LastSeenTime' = if ($Data.attributes.LastSeenTime) {$Data.attributes.LastSeenTime} else {0}
            'OnlineStatus' = if ($Data.attributes.OnlineStatus) {$Data.attributes.OnlineStatus} else {"unknown"}
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
    [DiscoveryStatus]$SnmpStatus
    [DiscoveryStatus]$LoginStatus
    [DiscoveryStatus]$WmiStatus
    [DiscoveryStatus]$VMwareStatus
    [TrafficInsightsStatus]$TrafficInsightsStatus
    [AuvikTenant]$Tenant
    [AuvikDevice[]]$ConnectedDevices
    [AuvikInterface[]]$Interfaces
    [pscustomobject[]]$Configurations
    [pscustomobject[]]$Components
    [pscustomobject]$Links
    hidden $DeviceDetail


    AuvikDeviceDetail() { $this.Init(@{}) }

    AuvikDeviceDetail([pscustomobject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'ManageStatus' = $Data.attributes.ManageStatus
            'SnmpStatus' = if ($Data.attributes.discoveryStatus.snmp) {$Data.attributes.discoveryStatus.snmp} else {"unknown"}
            'LoginStatus' = if ($Data.attributes.discoveryStatus.login) {$Data.attributes.discoveryStatus.login} else {"unknown"}
            'WmiStatus' = if ($Data.attributes.discoveryStatus.wmi) {$Data.attributes.discoveryStatus.wmi} else {"unknown"}
            'VMwareStatus' = if ($Data.attributes.discoveryStatus.vmware) {$Data.attributes.discoveryStatus.vmware} else {"unknown"}
            'TrafficInsightsStatus' = if ($Data.attributes.TrafficInsightsStatus) {$Data.attributes.TrafficInsightsStatus} else {"unknown"}
            'Tenant' = $Data.relationships.tenant.data
            'ConnectedDevices' = $Data.relationships.ConnectedDevices.data
            'Interfaces' = $Data.relationships.Interfaces.data
            'Configurations' = $Data.relationships.Configurations.data
            'Components' = $Data.relationships.Components.data
            'Links' = $Data.Links
            'DeviceDetail' = $Content
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
    [pscustomobject]$Links
    [string]$DeviceName
    [DeviceType]$DeviceType
    [datetime]$LastModified
    [datetime]$LastSeenTime
    [pscustomobject]$Attributes
    [AuvikTenant]$Tenant
    [AuvikNetwork[]]$Networks
    [AuvikDeviceDetail[]]$DeviceDetail
    [AuvikDevice]$Members
    hidden $DeviceExtendedDetail


    AuvikDeviceExtendedDetail() { $this.Init(@{}) }

    AuvikDeviceExtendedDetail([pscustomobject]$Content) {
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
            'DeviceType' = if ($Data.attributes.DeviceType) {$Data.attributes.DeviceType} else {"unknown"}
            'LastModified' = if ($Data.attributes.LastModified) {$Data.attributes.LastModified} else {0}
            'LastSeenTime' = if ($Data.attributes.LastSeenTime) {$Data.attributes.LastSeenTime} else {0}
            'Attributes' = $NoteProperty | ForEach-Object {@{$_ = $Data.attributes.$_}}
            'Tenant' = $Data.relationships.tenant.data
            #'Networks' = $Data.relationships.Networks.data
            #'DeviceDetail' = $Data.relationships.deviceDetail.data
            #'Members' = $Data.relationships.members
            'DeviceExtendedDetail' = $Content
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
    [pscustomobject]$Links
    hidden $DeviceWarranty

    AuvikDeviceWarranty() { $this.Init(@{}) }

    AuvikDeviceWarranty([pscustomobject]$Content) {
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
    [LifecycleStatus]$SalesAvailability
    [LifecycleStatus]$SoftwareMaintenanceStatus
    [LifecycleStatus]$SecuritySoftwareMaintenanceStatus
    [LifecycleStatus]$LastSupportStatus
    [AuvikTenant]$Tenant
    [AuvikDevice]$Device
    [pscustomobject]$Links
    hidden $deviceLifecycle

    AuvikDeviceLifecycle() { $this.Init(@{}) }

    AuvikDeviceLifecycle([pscustomobject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'DeviceName' = $Data.attributes.DeviceName
            'salesAvailability' = if ($Data.attributes.salesAvailability) {$Data.attributes.salesAvailability} else {"unknown"}
            'softwareMaintenanceStatus' = if ($Data.attributes.softwareMaintenanceStatus) {$Data.attributes.softwareMaintenanceStatus} else {"unknown"}
            'securitySoftwareMaintenanceStatus' = if ($Data.attributes.securitySoftwareMaintenanceStatus) {$Data.attributes.securitySoftwareMaintenanceStatus} else {"unknown"}
            'lastSupportStatus' = if ($Data.attributes.lastSupportStatus) {$Data.attributes.lastSupportStatus} else {"unknown"}
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

class AuvikInterface {
    [string]$Id
    [string]$InterfaceName
    [InterfaceType]$InterfaceType
    [string]$MacAddress
    [Int64]$NegotiatedSpeed
    [string]$Duplex
    [bool]$CustomConnections
    [ipaddress[]]$IpAddresses
    [OperationalStatus]$OperationalStatus
    [bool]$AdminStatus
    [datetime]$LastModified
    [pscustomobject]$Links
    [AuvikTenant]$Tenant
    [AuvikInterface[]]$ConnectedTo
    [AuvikNetwork[]]$Networks
    [AuvikDevice]$ParentDevice
    hidden $Interface

    AuvikInterface() { $this.Init(@{}) }

    AuvikInterface([pscustomobject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'InterfaceName' = $Data.attributes.DeviceName
            'InterfaceType' = if ($Data.attributes.InterfaceType) {$Data.attributes.InterfaceType} else {"unknown"}
            'MacAddress' = $Data.attributes.MacAddress
            'NegotiatedSpeed' = $Data.attributes.NegotiatedSpeed
            'Duplex' = $Data.attributes.Duplex
            'CustomConnections' = $Data.attributes.CustomConnections
            'IpAddresses' = $Data.attributes.IpAddresses
            'OperationalStatus' = if ($Data.attributes.OperationalStatus) {$Data.attributes.OperationalStatus} else {"unknown"}
            'AdminStatus' = $Data.attributes.AdminStatus
            'LastModified' = if ($Data.attributes.LastModified) {$Data.attributes.LastModified} else {0}
            'Links' = $Data.Links
            'Tenant' = $Data.relationships.tenant.data
            'ConnectedTo' = $Data.relationships.ConnectedTo.data
            'Networks' = $Data.relationships.Networks.data
            'ParentDevice' = $Data.relationships.ParentDevice.data
            'Interface' = $Content
        })
    }

    AuvikInterface([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikComponent {
    [string]$Id
    [string]$ComponentName
    [string]$ComponentType
    [currentStatus]$CurrentStatus
    [datetime]$LastModified
    [pscustomobject]$Links
    [AuvikTenant]$Tenant
    [AuvikDevice]$ParentDevice
    hidden $Component

    AuvikComponent() { $this.Init(@{}) }

    AuvikComponent([pscustomobject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'ComponentName' = $Data.attributes.ComponentName
            'ComponentType' = $Data.attributes.ComponentType
            'CurrentStatus' = $Data.attributes.CurrentStatus
            'LastModified' = if ($Data.attributes.LastModified) {$Data.attributes.LastModified} else {0}
            'Links' = $Data.Links
            'Tenant' = $Data.relationships.tenant.data
            'ParentDevice' = $Data.relationships.ParentDevice.data
            'Component' = $Content
        })
    }

    AuvikComponent([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikEntityNote {
    [string]$Id
    [string]$Title
    [string]$Body
    [string]$EntityId
    [EntityType]$EntityType
    [string]$EntityName
    [string]$LastModifiedBy
    [datetime]$LastModified
    [AuvikTenant]$Tenant
    [pscustomobject]$Links
    hidden $EntityNote

    AuvikEntityNote() { $this.Init(@{}) }

    AuvikEntityNote([pscustomobject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'Title' = $Data.attributes.Title
            'Body' = $Data.attributes.Body
            'EntityId' = $Data.attributes.EntityId
            'EntityType' = $Data.attributes.EntityType
            'EntityName' = $Data.attributes.EntityName
            'LastModifiedBy' = $Data.attributes.LastModifiedBy
            'LastModified' = if ($Data.attributes.LastModified) {$Data.attributes.LastModified} else {0}
            'Tenant' = $Data.relationships.tenant.data
            'Links' = $Data.Links
            'EntityNote' = $Content
        })
    }

    AuvikEntityNote([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikEntityAudit {
    [string]$Id
    [string]$User
    [EntityAuditCategory]$Category
    [string]$Action
    [string]$Direction
    [EntityAuditStatus]$Status
    [string]$Cause
    [string]$Data
    [datetime]$DateStarted
    [datetime]$LastActive
    [AuvikTenant]$Tenant
    [AuvikDevice]$Device
    [pscustomobject]$Links
    hidden $EntityAudit

    AuvikEntityAudit() { $this.Init(@{}) }

    AuvikEntityAudit([pscustomobject]$Content) {
        if ($Content.data) {
            $ContentData = $Content.data
        } else {
            $ContentData = $Content
        }
        $this.Init(@{
            'Id' = $ContentData.id
            'User' = $ContentData.attributes.User
            'Category' = $ContentData.attributes.Category
            'Action' = $ContentData.attributes.Action
            'Direction' = $ContentData.attributes.Direction
            'Status' = $ContentData.attributes.Status
            'Cause' = $ContentData.attributes.Cause
            'Data' = $ContentData.attributes.Data # if ($Data.attributes.LastModified) {$Data.attributes.LastModified} else {0}
            'DateStarted' = if ($ContentData.attributes.DateStarted) {$ContentData.attributes.DateStarted} else {0}
            'LastActive' = if ($ContentData.attributes.LastActive) {$ContentData.attributes.LastActive} else {0}
            'Tenant' = $ContentData.relationships.tenant.data
            'Device' = $ContentData.relationships.Device.data
            'Links' = $ContentData.Links
            'EntityAudit' = $Content
        })
    }

    AuvikEntityAudit([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikConfiguration {
    [string]$Id
    [datetime]$BackupTime
    [bool]$IsRunning
    [AuvikTenant]$Tenant
    [AuvikDevice]$Device
    [pscustomobject]$Links
    hidden $Configuration

    AuvikConfiguration() { $this.Init(@{}) }

    AuvikConfiguration([pscustomobject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'BackupTime' = if ($Data.attributes.BackupTime) {$Data.attributes.backupTime}
            'IsRunning' = $Data.attributes.isRunning
            'Tenant' = $Data.relationships.tenant.data
            'Device' = $Data.relationships.device.data
            'Links' = $Data.Links
            'Configuration' = $Content
        })
    }

    AuvikConfiguration([hashtable]$Properties) { $this.Init($Properties) }

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
    [pscustomobject]$Links
    hidden $ChangeMe

    ChangeMe() { $this.Init(@{}) }

    ChangeMe([pscustomobject]$Content) {
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