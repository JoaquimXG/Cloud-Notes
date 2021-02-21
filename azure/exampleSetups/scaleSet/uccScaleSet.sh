suffix=uccScaleSetScript

# Resource Group
group=rg-$suffix
loc=uksouth

# Networking
vnet=vnet-$suffix
#nic=nic-$suffix
#subnet=subnet-$suffix
prefix=10.0.0.0/24
ipName=ip-$suffix
dns=xjgunifi

#Firewall
nsg=nsg-$suffix
inPorts="8080 8443"
portGroup=UCC_Gui_Ports
protocol=TCP

vmss=vmss-$suffix
image=Canonical:UbuntuServer:18.04-LTS:latest
sku=Standard_B1s
numInstances=1
user=azureuser
ssh=/home/main/.ssh/public/azure.pub

cloudInit=./dockerWithUnifiController-ubuntu.yml

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

# Scale set
az vmss create -g $group \
    --name $vmss -l $loc -z 1 2 \
    --image $image \
    --custom-data $cloudInit \
    --ssh-key-values $ssh \
    --admin-username $user \
    --vm-sku $sku \
    --instance-count $numInstances \
    --public-ip-address-dns-name $dns \
    --nsg $nsg

# Load balancer rules
az network lb rule create \
    --resource-group $group \
    --name httpForward \
    --lb-name ${vmss}LB \
    --backend-pool-name ${vmss}LBBEPool \
    --backend-port 8080 \
    --frontend-ip-name loadBalancerFrontEnd \
    --frontend-port 8080 \
    --protocol tcp

az network lb rule create \
    --resource-group $group \
    --name httpsForward \
    --lb-name ${vmss}LB \
    --backend-pool-name ${vmss}LBBEPool \
    --backend-port 8443 \
    --frontend-ip-name loadBalancerFrontEnd \
    --frontend-port 8443 \
    --protocol tcp
