enum DeviceTypeSchema {
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

enum LifecycleStatus {
    covered
    available
    expired
    securityOnly
    unpublished
    empty
    unknown
}

enum NetworkType {
    routed
    vlan
    wifi
    loopback
    network
    layer2
    internet
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
}

enum EntityAuditCategory {
    unknown
    tunnel
    terminal
    remoteBrowser
}

enum EntityAuditStatus {
    unknown
    initiated
    created
    closed
    failed
}

enum Severity {
    unknown
    emergency
    critical
    warning
    info
}
enum AlertStatus {
    created
    resolved
    paused
    unpaused
}

enum TimeInterval {
    minute
    hour
    day
}

enum StatId {
    bandwidth
    cpuUtilization
    memoryUtilization
    storageUtilization
    packetUnicast
    packetMulticast
    packetBroadcast
}

class AuvikAuthorizations {
    [string]$Id
    hidden $AuthorizationsObject

    AuvikAuthorizations() { $this.Init(@{}) }

    AuvikAuthorizations([pscustomobject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'AuthorizationsObject' = $content
        })
    }

    AuvikAuthorizations([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikTenant {
    [string]$Id
    [string]$DomainPrefix
    [string]$DisplayName
    [string]$TenantType
    [System.Nullable[bool]]$Enabled
    [string]$Subscribed
    [string]$SubscriptionOwner
    [System.Nullable[bool]]$Running
    [System.Nullable[datetime]]$TrialStartDate
    [System.Nullable[datetime]]$trialEndDate
    [pscustomobject]$Address
    [AuvikTenant]$Parent
    [AuvikAuthorizations[]]$Authorizations
    hidden $TenantObject

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
            "TrialStartDate" = if ($data.attributes.TrialStartDate) {$data.attributes.TrialStartDate}
            "trialEndDate" = if ($data.attributes.trialEndDate) {$data.attributes.trialEndDate}
            "Address" = $Data.attributes.Address
            'Parent' = $Data.relationships.parent.data
            'Authorizations' = $Data.relationships.Authorizations.data
            'TenantObject' = $Data
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
    [System.Nullable[Scope]]$Scope
    [string]$PrimaryCollector
    [string[]]$SecondaryCollectors
    [string]$CollectorSelection
    [string[]]$ExcludedIpAddresses
    [AuvikTenant]$Tenant
    [pscustomobject]$Links
    hidden $NetworkDetailObject

    AuvikNetworkDetail() { $this.Init(@{}) }

    AuvikNetworkDetail([pscustomobject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'Scope' = if ($Data.attributes.Scope) {$Data.attributes.Scope}
            'PrimaryCollector' = $Data.attributes.PrimaryCollector
            'SecondaryCollectors' = $Data.attributes.SecondaryCollectors
            'CollectorSelection' = $Data.attributes.CollectorSelection
            'ExcludedIpAddresses' = $Data.attributes.ExcludedIpAddresses
            'Tenant' = $Data.relationships.tenant.data
            'Links' = $Data.links
            'NetworkDetailObject' = $content
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
    [System.Nullable[NetworkType]]$NetworkType
    [string]$networkName
    [string]$Description
    [System.Nullable[ScanStatus]]$ScanStatus
    [System.Nullable[datetime]]$LastModified
    [AuvikNetworkDetail[]]$NetworkDetail
    [AuvikTenant]$Tenant
    [AuvikDevice[]]$Device
    [pscustomobject]$Links
    hidden $NetworkObject

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
            'NetworkType' = if ($Data.attributes.networkType) {$Data.attributes.networkType}
            'NetworkName' = $Data.attributes.networkName
            'Description' = $Data.attributes.description
            'ScanStatus' = if ($Data.attributes.scanStatus) {$Data.attributes.scanStatus}
            'LastModified' = if ($Data.attributes.lastModified) {$Data.attributes.lastModified}
            'NetworkDetail' = if ($Content.Included) {$Content.Included}
            'Tenant' = $Data.relationships.tenant.data
            'Device' = $Data.relationships.devices.data
            'Links' = $Data.links
            'NetworkObject' = $content
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
    [System.Nullable[DeviceTypeSchema]]$DeviceType
    [string]$MakeModel
    [string]$VendorName
    [string]$SoftwareVersion
    [string]$SerialNumber
    [string]$Description
    [string]$FirmwareVersion
    [System.Nullable[datetime]]$LastModified
    [System.Nullable[datetime]]$LastSeenTime
    [System.Nullable[OnlineStatus]]$OnlineStatus
    [AuvikTenant]$Tenant
    [AuvikNetwork[]]$Network
    [AuvikDeviceDetail[]]$DeviceDetail
    [pscustomobject]$Links
    hidden $DeviceObject

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
            'DeviceType' = if ($Data.attributes.DeviceType) {$Data.attributes.DeviceType}
            'MakeModel' = $Data.attributes.MakeModel
            'VendorName' = $Data.attributes.VendorName
            'SoftwareVersion' = $Data.attributes.SoftwareVersion
            'SerialNumber' = $Data.attributes.SerialNumber
            'Description' = $Data.attributes.Description
            'FirmwareVersion' = $Data.attributes.FirmwareVersion
            'LastModified' = if ($Data.attributes.LastModified) {$Data.attributes.LastModified}
            'LastSeenTime' = if ($Data.attributes.LastSeenTime) {$Data.attributes.LastSeenTime}
            'OnlineStatus' = if ($Data.attributes.OnlineStatus) {$Data.attributes.OnlineStatus}
            'Tenant' = $Data.relationships.tenant.data
            'Network' = $Data.relationships.Networks.data #| ForEach-Object {[AuvikNetwork]::new($_)}
            'DeviceDetail' = $Content.included
            'Links' = $Data.Links
            'DeviceObject' = $content
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
    [System.Nullable[DiscoveryStatus]]$SnmpStatus
    [System.Nullable[DiscoveryStatus]]$LoginStatus
    [System.Nullable[DiscoveryStatus]]$WmiStatus
    [System.Nullable[DiscoveryStatus]]$VMwareStatus
    [System.Nullable[TrafficInsightsStatus]]$TrafficInsightsStatus
    [AuvikTenant]$Tenant
    [AuvikDevice[]]$ConnectedDevices
    [AuvikInterface[]]$Interfaces
    [AuvikConfiguration[]]$Configurations
    [AuvikComponent[]]$Components
    [pscustomobject]$Links
    hidden $DeviceDetailObject


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
            'SnmpStatus' = if ($Data.attributes.discoveryStatus.snmp) {$Data.attributes.discoveryStatus.snmp}
            'LoginStatus' = if ($Data.attributes.discoveryStatus.login) {$Data.attributes.discoveryStatus.login}
            'WmiStatus' = if ($Data.attributes.discoveryStatus.wmi) {$Data.attributes.discoveryStatus.wmi}
            'VMwareStatus' = if ($Data.attributes.discoveryStatus.vmware) {$Data.attributes.discoveryStatus.vmware}
            'TrafficInsightsStatus' = if ($Data.attributes.TrafficInsightsStatus) {$Data.attributes.TrafficInsightsStatus}
            'Tenant' = $Data.relationships.tenant.data
            'ConnectedDevices' = $Data.relationships.ConnectedDevices.data
            'Interfaces' = $Data.relationships.Interfaces.data
            'Configurations' = $Data.relationships.Configurations.data
            'Components' = $Data.relationships.Components.data
            'Links' = $Data.Links
            'DeviceDetailObject' = $content
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
    [DeviceTypeSchema]$DeviceType
    [datetime]$LastModified
    [datetime]$LastSeenTime
    [pscustomobject]$Attributes
    [AuvikTenant]$Tenant
    #[AuvikNetwork[]]$Networks
    #[AuvikDeviceDetail[]]$DeviceDetail
    #[AuvikDevice[]]$Members
    hidden $DeviceExtendedDetailObject


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
            'DeviceType' = if ($Data.attributes.DeviceType) {$Data.attributes.DeviceType}
            'LastModified' = if ($Data.attributes.LastModified) {$Data.attributes.LastModified}
            'LastSeenTime' = if ($Data.attributes.LastSeenTime) {$Data.attributes.LastSeenTime}
            'Attributes' = $NoteProperty | ForEach-Object {@{$_ = $Data.attributes.$_}}
            'Tenant' = $Data.relationships.tenant.data
            #'Networks' = $Data.relationships.Networks.data
            #'DeviceDetail' = $Data.relationships.deviceDetail.data
            #'Members' = $Data.relationships.members
            'DeviceExtendedDetailObject' = $content
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
    hidden $DeviceWarrantyObject

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
            'DeviceWarrantyObject' = $content
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
    [System.Nullable[LifecycleStatus]]$SalesAvailability
    [System.Nullable[LifecycleStatus]]$SoftwareMaintenanceStatus
    [System.Nullable[LifecycleStatus]]$SecuritySoftwareMaintenanceStatus
    [System.Nullable[LifecycleStatus]]$LastSupportStatus
    [AuvikTenant]$Tenant
    [AuvikDevice]$Device
    [pscustomobject]$Links
    hidden $deviceLifecycleObject

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
            'salesAvailability' = if ($Data.attributes.salesAvailability) {$Data.attributes.salesAvailability}
            'softwareMaintenanceStatus' = if ($Data.attributes.softwareMaintenanceStatus) {$Data.attributes.softwareMaintenanceStatus}
            'securitySoftwareMaintenanceStatus' = if ($Data.attributes.securitySoftwareMaintenanceStatus) {$Data.attributes.securitySoftwareMaintenanceStatus}
            'lastSupportStatus' = if ($Data.attributes.lastSupportStatus) {$Data.attributes.lastSupportStatus}
            'Tenant' = $Data.relationships.tenant.data
            'Device' = $Data.relationships.Device.data
            'Links' = $Data.Links
            'DeviceLifecycleObject' = $content
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
    [System.Nullable[InterfaceType]]$InterfaceType
    [string]$MacAddress
    [System.Nullable[Int64]]$NegotiatedSpeed
    [string]$Duplex
    [System.Nullable[bool]]$CustomConnections
    [ipaddress[]]$IpAddresses
    [System.Nullable[OperationalStatus]]$OperationalStatus
    [System.Nullable[bool]]$AdminStatus
    [System.Nullable[datetime]]$LastModified
    [pscustomobject]$Links
    [AuvikTenant]$Tenant
    [AuvikInterface[]]$ConnectedTo
    [AuvikNetwork[]]$Networks
    [AuvikDevice]$ParentDevice
    hidden $InterfaceObject

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
            'InterfaceType' = if ($Data.attributes.InterfaceType) {$Data.attributes.InterfaceType}
            'MacAddress' = $Data.attributes.MacAddress
            'NegotiatedSpeed' = $Data.attributes.NegotiatedSpeed
            'Duplex' = $Data.attributes.Duplex
            'CustomConnections' = $Data.attributes.CustomConnections
            'IpAddresses' = $Data.attributes.IpAddresses
            'OperationalStatus' = if ($Data.attributes.OperationalStatus) {$Data.attributes.OperationalStatus}
            'AdminStatus' = $Data.attributes.AdminStatus
            'LastModified' = if ($Data.attributes.LastModified) {$Data.attributes.LastModified}
            'Links' = $Data.Links
            'Tenant' = $Data.relationships.tenant.data
            'ConnectedTo' = $Data.relationships.ConnectedTo.data
            'Networks' = $Data.relationships.Networks.data
            'ParentDevice' = $Data.relationships.ParentDevice.data
            'InterfaceObject' = $content
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
    [System.Nullable[datetime]]$LastModified
    [pscustomobject]$Links
    [AuvikTenant]$Tenant
    [AuvikDevice]$ParentDevice
    hidden $ComponentObject

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
            'LastModified' = if ($Data.attributes.LastModified) {$Data.attributes.LastModified}
            'Links' = $Data.Links
            'Tenant' = $Data.relationships.tenant.data
            'ParentDevice' = $Data.relationships.ParentDevice.data
            'ComponentObject' = $content
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
    [System.Nullable[EntityType]]$EntityType
    [string]$EntityName
    [string]$LastModifiedBy
    [datetime]$LastModified
    [AuvikTenant]$Tenant
    [pscustomobject]$Links
    hidden $EntityNoteObject

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
            'LastModified' = if ($Data.attributes.LastModified) {$Data.attributes.LastModified}
            'Tenant' = $Data.relationships.tenant.data
            'Links' = $Data.Links
            'EntityNoteObject' = $content
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
    [System.Nullable[datetime]]$LastActive
    [AuvikTenant]$Tenant
    [AuvikDevice]$Device
    [pscustomobject]$Links
    hidden $EntityAuditObject

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
            'Data' = $ContentData.attributes.Data
            'DateStarted' = if ($ContentData.attributes.DateStarted) {$ContentData.attributes.DateStarted}
            'LastActive' = if ($ContentData.attributes.LastActive) {$ContentData.attributes.LastActive}
            'Tenant' = $ContentData.relationships.tenant.data
            'Device' = $ContentData.relationships.Device.data
            'Links' = $ContentData.Links
            'EntityAuditObject' = $content
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
    hidden $ConfigurationObject

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
            'ConfigurationObject' = $content
        })
    }

    AuvikConfiguration([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikAlert {
    [string]$Id
    [string]$Name
    [Severity]$Severity
    [AlertStatus]$Status
    [string]$AlertDefinitionId
    [string]$SpecificationId
    [datetime]$DetectedOn
    [string]$Description
    [bool]$Dismissed
    [bool]$Dispatched
    [pscustomobject[]]$ExternalTicket
    [AuvikTenant]$Tenant
    [pscustomobject]$RelatedAlert
    $Entity
    [pscustomobject]$Links
    hidden $AlertObject

    AuvikAlert() { $this.Init(@{}) }

    AuvikAlert([pscustomobject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'Name' = $Data.attributes.Name
            'Severity' = $Data.attributes.Severity
            'Status' = $Data.attributes.Status
            'AlertDefinitionId' = $Data.attributes.AlertDefinitionId
            'SpecificationId' = $Data.attributes.SpecificationId
            'DetectedOn' = $Data.attributes.DetectedOn
            'Description' = $Data.attributes.Description
            'Dismissed' = $Data.attributes.Dismissed
            'Dispatched' = $Data.attributes.Dispatched
            'ExternalTicket' = $Data.attributes.ExternalTicket
            'Tenant' = $Data.relationships.tenant.data
            'RelatedAlert' = $Data.relationships.RelatedAlert.data
            'Entity' = switch ($Data.relationships.entity.data.type) {
                device {
                    [AuvikDevice]::new($Data.relationships.entity.data)
                }
                interface {
                    [AuvikInterface]::new($Data.relationships.entity.data)
                }
                Default {
                    if ($Data.relationships.entity.data) {
                        Write-Debug "Add $($Data.relationships.entity.data.type)"
                        [PSCustomObject]::new($Data.relationships.entity.data)
                    }
                }
            }
            'Links' = $Data.Links
            'AlertObject' = $content
        })
    }

    AuvikAlert([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikClientUsage {
    [string]$Id
    [MonitoredEndpoints[]]$MonitoredWorkstations
    [MonitoredEndpoints[]]$MonitoredServers
    [System.Nullable[int]]$MaxMonitoredWorkstations
    [System.Nullable[int]]$MaxMonitoredServers
    [string]$DomainPrefix
    [System.Nullable[int]]$BillableDays
    [UsagePeriod]$UsagePeriod
    [AuvikUsage]$DeviceUsage
    [AuvikUsage]$ClientUsage
    [System.Nullable[int]]$TotalAsmUsers
    [AuvikDeviceUsage[]]$Devices
    [AuvikClientUsage[]]$Clients
    [string[]]$AsmUsers # Change to AuvikAsmUser type?
    [pscustomobject]$Links
    hidden $ClientUsageObject

    AuvikClientUsage() { $this.Init(@{}) }

    AuvikClientUsage([pscustomobject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'MonitoredWorkstations' = $Data.attributes.MonitoredWorkstations
            'MonitoredServers' = $Data.attributes.MonitoredServers
            'MaxMonitoredWorkstations' = $Data.attributes.MaxMonitoredWorkstations
            'MaxMonitoredServers' = $Data.attributes.MaxMonitoredServers
            'DomainPrefix' = $Data.attributes.DomainPrefix
            'BillableDays' = $Data.attributes.BillableDays
            'UsagePeriod' = $Data.attributes.UsagePeriod
            'DeviceUsage' = $Data.attributes.DeviceUsage
            'ClientUsage' = $Data.attributes.ClientUsage
            'TotalAsmUsers' = $Data.attributes.asmUserUsage.totalAsmUsers
            'Devices' = $Data.relationships.Devices.Data
            'Clients' = $Data.relationships.Clients.Data
            'AsmUsers' = $Data.relationships.AsmUsers.data.Id
            'Links' = $Data.Links
            'ClientUsageObject' = $content
        })
    }

    AuvikClientUsage([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikDeviceUsage {
    [string]$Id
    [string]$DeviceName
    [UsagePeriod]$UsagePeriod
    [int]$totalDays
    [int]$averageDays
    [DaysByClientType]$TotalDaysByClientType
    [DaysByClientType]$AverageDaysByClientType
    [AuvikClientUsage]$Client
    [pscustomobject]$Links
    hidden $DeviceUsageObject

    AuvikDeviceUsage() { $this.Init(@{}) }

    AuvikDeviceUsage([pscustomobject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }
        $this.Init(@{
            'Id' = $Data.id
            'DeviceName' = $Data.attributes.DeviceName
            'UsagePeriod' = $Data.attributes.UsagePeriod
            'totalDays' = $Data.attributes.totalDays
            'averageDays' = $Data.attributes.averageDays
            'TotalDaysByClientType' = $Data.attributes.TotalDaysByClientType
            'AverageDaysByClientType' = $Data.attributes.AverageDaysByClientType
            'Client' = $Data.relationships.Client.data
            'Links' = $Data.Links
            'DeviceUsageObject' = $content
        })
    }

    AuvikDeviceUsage([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class UsagePeriod {
    [datetime]$StartDate
    [datetime]$EndDate
    [int]$lengthInDays

    usagePeriod() { $this.Init(@{}) }

    usagePeriod([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikUsage {
    [int]$TotalDays
    [int]$AverageDays
    [DaysByClientType]$TotalDaysByClientType
    [DaysByClientType]$AverageDaysByClientType

    AuvikUsage() { $this.Init(@{}) }

    AuvikUsage([hashtable]$Properties) { $this.Init($Properties) }

    AuvikUsage([pscustomobject]$Content) {
        if ($Content.averageDays) {
            $Days = $Content.averageDays
            write-verbose "PSC averageDays"
        } elseif ($Content.averagedDays) {
            $Days = $Content.averagedDays
            write-verbose "PSC averagedDays"
        } else {
            $Days = 0
        }
        $this.Init(@{
            'TotalDays' = $Content.TotalDays
            'AverageDays' = $Days
            'TotalDaysByClientType' = $Content.TotalDaysByClientType
            'AverageDaysByClientType' = $Content.AverageDaysByClientType
        })
    }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class MonitoredEndpoints {
    [datetime]$Date
    [int]$TotalEndpoints

    MonitoredEndpoints() { $this.Init(@{}) }

    MonitoredEndpoints([pscustomobject]$Content) {
        if ($Content.totalEndpoints) {
            $Endpoints = $Content.totalEndpoints
        } elseif ($Content.totalServers) {
            $Endpoints = $Content.totalServers
        } else {
            $Endpoints = 0
        }
        $this.Init(@{
            'Date' = $Content.Date
            'TotalEndpoints' = $Endpoints
        })
    }

    MonitoredEndpoints([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class DaysByClientType {
    [int]$NoTier
    [int]$Light
    [int]$Essentials
    [int]$Performance

    DaysByClientType() { $this.Init(@{}) }

    DaysByClientType([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikDeviceStatistics {
    [string]$Id
    [datetime]$FromTime
    [datetime]$ThruTime
    [TimeInterval]$interval
    [string]$StatType
    [AuvikStats[]]$Stats
    [AuvikDevice]$Device
    [AuvikTenant]$Tenant
    [pscustomobject]$Links
    hidden $DeviceStatisticsObject

    AuvikDeviceStatistics() { $this.Init(@{}) }

    AuvikDeviceStatistics([pscustomobject]$Content) {
        if ($Content.data) {
            $Data = $Content.data
        } else {
            $Data = $Content
        }

        $this.Init(@{
            'Id' = $Data.id
            'FromTime' = $Data.attributes.reportPeriod.FromTime
            'ThruTime' = $Data.attributes.reportPeriod.ThruTime
            'interval' = $Data.attributes.interval
            'StatType' = $Data.attributes.StatType
            'Stats' = $Data.attributes.Stats | ForEach-Object {
                for ($d = 0; $d -lt $_.data.Count; $d++) {
                    [AuvikStats]::new([pscustomobject]@{
                        'Name' = $_.name
                        'Index' = $_.index
                        'Legend' = $_.legend
                        'Unit' = $_.unit
                        'Data' = $_.data[$d]
                    })
                }
            }
            'Device' = $Data.relationships.Device.Data
            'Tenant' = $Data.relationships.tenant.data
            'Links' = $Data.Links
            'DeviceStatisticsObject' = $content
        })
    }

    AuvikDeviceStatistics([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class AuvikStats {
    [string]$Name
    [System.Nullable[int]]$Index
    #[string]$Legend
    #[string]$Unit
    #$Data
    [datetime]$RecordedAt
    [string]$Percent
    [string]$Transmit
    [string]$Receive
    [string]$Bandwidth
    hidden $StatsObject

    AuvikStats() { $this.Init(@{}) }

    AuvikStats([pscustomobject]$Content) {
        [hashtable]$Properties = @{
            'Name' = $Content.Name
            'Index' = $Content.Index
        }
        for ($l = 0; $l -lt $Content.legend.Count; $l++) {
            switch ($Content.unit[$l]) {
                unix_mins {
                    $Properties[$Content.legend[$l].replace(" ",'')] = (Get-Date 01.01.1970).AddMinutes($Content.Data[$l])
                }
                percent {
                    $Properties[$Content.legend[$l]] = "$($Content.Data[$l])%"
                }
                bits_per_sec {
                    $Properties[$Content.legend[$l]] = "$($Content.Data[$l]) bps"
                }
                packets_per_second {
                    $Properties[$Content.legend[$l]] = "$($Content.Data[$l]) pps"
                }
                Default {}
            }
        }
        $this.Init($Properties)
    }

    AuvikStats([hashtable]$Properties) {
        $this.Init($Properties)
    }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class ChangeMe {
    [string]$Id
    [string]$Name
    [AuvikTenant]$Tenant
    [pscustomobject]$Links
    hidden $ChangeMeObject

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
            'ChangeMeObject' = $content
        })
    }

    ChangeMe([hashtable]$Properties) { $this.Init($Properties) }

    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}