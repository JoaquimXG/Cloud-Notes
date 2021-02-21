suffix=ucc

# Resource Group
group=rg-$suffix
loc=uksouth

# Networking
vnet=vnet-$suffix
nic=nic-$suffix
subnet=subnet-$suffix
prefix=10.0.0.0/24
ipName=ip-$suffix
dns=xjgunifi

#Firewall
nsg=nsg-$suffix
inPorts="8080 8443"
portGroup=UCC_Gui_Ports
protocol=TCP

vm=vm-$suffix
image=Canonical:UbuntuServer:18.04-LTS:latest
user=azureuser
ssh=/home/main/.ssh/public/azure.pub

cloudInit=./dockerWithUnifiController-ubuntu.yml

