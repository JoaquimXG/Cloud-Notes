source ./variables.sh

az group create \
    --resource-group $group \
    --location $loc

# security group
az network nsg create \
    --resource-group $group \
    --name $nsg

az network nsg rule create \
    --name $portGroup \
    --resource-group $group \
    --nsg-name $nsg \
    --priority 111 \
    --protocol $protocol \
    --destination-port-ranges $inPorts

az network nsg rule create \
    --name "ssh" \
    --resource-group $group \
    --nsg-name $nsg \
    --priority 101 \
    --protocol $protocol \
    --destination-port-ranges "22"


#vnet
az network vnet create \
    --resource-group $group \
    --name $vnet

az network vnet subnet create \
    --resource-group $group  \
    --vnet-name $vnet \
    --name $subnet \
    --address-prefixes $prefix

#nic with public ip
az network public-ip create \
    --dns-name $dns \
    --resource-group $group \
    --name $ipName


### Up to here

az network nic create \
    --resource-group $group \
    --name $nic \
    --network-security-group $nsg \
    --subnet $subnet \
    --vnet-name $vnet

az network nic ip-config update \
    --name ipconfig1 \
    --resource-group $group \
    --nic-name $nic \
    --public-ip-address $ipName


#vm
az vm create \
    --resource-group $group \
    --name $vm \
    --image $image \
    --custom-data $cloudInit \
    --ssh-key-value $ssh \
    --public-ip-address-dns-name $dns \
    --location $loc \
    --admin-username $user \
    --nics $nic
