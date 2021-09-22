# Node App for podcolors website
Deploys docker container and pulls website code from github.

The parameters file has a grep replace for the azure git repo password containing the web files. 

The password has to be passed on the command line, a temporary password should be generated.

## 
az deployment group create -g rg-pod --template-file template.json --parameters @parameters.json gitPass=
