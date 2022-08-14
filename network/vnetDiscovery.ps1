
$fileName = "vnetDiscovery.csv"

if (Test-Path $fileName ) {
  Remove-Item $fileName
}

else {
  #doNothing
}

$vNets = Get-AzVirtualNetwork

$vnetReport =
foreach ($vNet in $vNets) {
    $subnetList = @()
    foreach ($subnet in $vNet.Subnets) {
        $subnetList += "[ $($subnet.Name) | $($vNet.Subnets.AddressPrefix -join ', ') ] "
    }

    $vnetPeeringList = @()
    foreach ($vnetPeering in $vNet.VirtualNetworkPeerings) {
        $vnetPeeringGT = $vNet.VirtualNetworkPeerings.AllowGatewayTransit
        $vnetPeeringList += "[ $($vnetPeering.Name) | $($vnetPeering.PeeringState) | $remoteVNETName | $vnetPeeringGT ] "
    }

    [PSCustomObject]@{
        Name = $vNet.Name
        ResourceGroupName = $vNet.ResourceGroupName
        Location = $vNet.Location
        Id = $vNet.Id
        AddressSpace =  $vNet.AddressSpace.AddressPrefixes -join ', '
        dnsSettings = $vnet.DhcpOptions.DnsServers -join ', '
        VnetPeerings = $vnetPeeringList -join ', '
        EnableDdosProtection = $vNet.EnableDdosProtection
    }
}

$vnetReport | Export-Csv $fileName -Append -NoTypeInformation -Force