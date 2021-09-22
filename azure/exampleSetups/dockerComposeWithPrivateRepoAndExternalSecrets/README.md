# Node App for podcolors website using docker-compose

This examples deploys docker-compose alongside adding a host key which is used
as a repo deployment key for github.

##

az group create -n rg-pod -l uksouth
az deployment group create -g rg-pod --template-file template.json --parameters @parameters.json
