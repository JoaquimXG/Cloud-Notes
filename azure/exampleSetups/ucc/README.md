# Basic single VM group deployment template for Azure

The aim of the template is to deploy a single vm which will host the Unifi controller.
The controller will be installed using a docker container so this is an example
config for future projects that may require the use of docker to get setup.

## Components

- Microsoft.Network/networkSecurityGroups
- Microsoft.Network/virtualNetworks
- Microsoft.Network/publicIpAddresses
- Microsoft.Network/networkInterfaces
- Microsoft.Compute/virtualMachines

## Parameters

Only a resource suffix (can be anything), a dns label prefix and the
cloud-init yaml file are required as parameters.

An example parameters.json file includes the correctly formatted
yaml file for ucc deployment.

- vmSuffix
- dnsLabelPrefix
- cloudInit
