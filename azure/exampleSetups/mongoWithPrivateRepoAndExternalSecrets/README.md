# Node App for podcolors website using docker-compose

This examples deploys mongodb and node 14.

Code

## Usage

1. Generate and add a new github repo key to podcolours github repo
    1. Generate private and public key
    2. Convert private key to RSA format
    3. Add public key to podcolours repo
2. Create Azure SAS token for environment file
    - docker.env for docker-compose and .env for standard mongo installation version
3. Get public key for [github.com](http://github.com)
    1. Generate with ssh-keyscan [github.com](http://github.com) >> github.com.pub
    2. Check fingerprint with ssh-keygen -lf github.com.pub
    3. Compare fingerprint against the fingerprint posted on github.com
4. Update cloud-init yaml file to include
    1. New private RSA key
    2. New public key
    3. New SAS URL for environment file
    4. [github.com](http://github.com) public key known host
5. Convert yaml to oneline json
6. Update parameters file to include the updated online json
7. Create Azure resource group
8. Create Azure resource deployment
9. Point domain to newly deployed server

testCloudInit.py {resourceGroupName}
