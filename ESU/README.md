# Azure Powershell Scripts

The following Powershell scripts and their use case in this folder are as follows;

Note that ESU does not PowerShell module support today. The scripts in this folder wrap the REST API into a PowerShell script for ease of use. With a little tweaking, this approach might work for any of the REST API actions documented here https://learn.microsoft.com/en-us/azure/azure-arc/servers/api-extended-security-updates

- [UnlinkESULicense.ps1](https://github.com/mattlunzer/powerShell/blob/master/ESU/UnlinkESULicense.ps1) - 
This script unlinks an ESU license from a virtual machine. This is useful if you need to move the license to another VM or you want to reduce the license count in your Azure subscription.