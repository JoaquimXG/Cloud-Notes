#!/bin/python3
import subprocess
import json
import glob
import sys

# Replaces all new line characters with a literal \\n and
# replaces all " characters with a literal \"
# returns the new single line string
def yamlToOnelineJson(filePath):
    oneLineJson = ""
    with open(filePath) as yaml:
        for line in yaml:
            oneLineJson += line.replace("\n", "\\n").replace('"', '\\"')

    return oneLineJson


# Replaces string patterns found in a line of a file
# with a corresponding replacement string
# pattern and replacement should be passed as lists
def replacePattern(replacements, filePath):
    returnFile = ""
    with open(filePath) as template:
        for line in template:
            for rep in replacements:
                line = line.replace(rep["pattern"], rep["replacement"])

            returnFile += line
    return returnFile


# Runs an azure template.json and provides the parameters.json
# Takes a group name to run the deployment in as an argument
# Both template.json and parameters.json must be in the current directory
def runAzureTemplateWithParameters(groupName):
    commands = [
        ["az", "group", "create", "-g", groupName, "-l", "uksouth"],
        [
            "az",
            "deployment",
            "group",
            "create",
            "-g",
            groupName,
            "--parameters",
            "@parameters.json",
            "--template-file",
            "template.json",
        ],
    ]
    print(f"[+] Creating group {groupName} for deployment")
    subprocess.run(commands[0])

    print(f"[+] Running template in newly created group {groupName}")
    subprocess.run(commands[1])


# Retrieves all of the IP addresses for VMs in a resource group
# alongside the VM name
def getIpAddressesForVmsInGroup(groupName):
    print(f"[+] Getting list of VMs in {groupName}")
    command = ["az", "vm", "list", "-g", groupName]
    result = subprocess.run(command, capture_output=True)
    vms = json.loads(result.stdout)

    print(f"[+] Getting IP addresses of VMs in {groupName}")
    vmIpInformation = []
    for vm in vms:
        vmName = vm["name"]
        command = [
            "az",
            "vm",
            "show",
            "-d",
            "--id",
            vm["id"],
            "--query",
            "publicIps",
            "-o",
            "tsv",
        ]
        vmIp = (
            subprocess.run(command, capture_output=True)
            .stdout.decode("utf-8")
            .strip("\n")
        )
        vmIpInformation.append(
            f"VM: {vmName}\nIP: {vmIp}\nConnection String: ssh azureuser@{vmIp}"
        )

    return vmIpInformation


# Terrible function to prepare a couple of variables
# Should be replaced with argparse at some point
# Pulls first positional argument into groupName
# and automatically pulls a single yaml file into filename
def prepareVariables():
    args = {}
    if len(sys.argv) != 2:
        print("Please supply resource group name")
        exit()

    args["filename"] = glob.glob("*.yml")[0]
    args["cloudInitReplacementPattern"] = "{#cloudInit#}"

    args["groupName"] = sys.argv[1]

    return args


def main():
    args = prepareVariables()

    print(f"[+] Converting {args['filename']} to json compatible single line string")
    oneLineJson = yamlToOnelineJson(args["filename"])

    print(
        f"[+] Placing single line json compatible cloudInit into parametersTemplate file"
    )
    with open("parameters.json", "w") as parametersOutput:
        replacements = [
            {"pattern": args["cloudInitReplacementPattern"], "replacement": oneLineJson}
        ]
        parametersOutput.write(replacePattern(replacements, "parametersTemplate.json"))

    runAzureTemplateWithParameters(args["groupName"])

    for ipAddressInfo in getIpAddressesForVmsInGroup(args["groupName"]):
        print(ipAddressInfo)


if __name__ == "__main__":
    main()
