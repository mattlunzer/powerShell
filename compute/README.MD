# Azure Powershell Scripts

The following powershell scripts and their use case in this folder are as follows;

- [deallocateVM.ps1](https://github.com/mattlunzer/powerShell/blob/master/compute/deallocateVM.ps1) - 
This script executes a simple wrapper around the API to deallocate a virtual machine.

- [hybernateVM.ps1](https://github.com/mattlunzer/powerShell/blob/master/compute/hybernateVM.ps1) - 
This script takes advantage of the new deallocate feature and executes a simple wrapper around the API to hybernate a virtual machine. Note, at the time of this writing, this feature is in preview and very limited SKU support.

- [shutdownVmByTag.ps1](https://github.com/mattlunzer/powerShell/blob/master/compute/shutdownVmByTag.ps1) - 
This script shuts down virtual machines with the Resource Tag key "Shutdown", and the value of "True". It was authored to be used by an Azure function with a timing trigger for deallocating virtual machines after business hours.


- [startAllVms.ps1](https://github.com/mattlunzer/powerShell/blob/master/compute/startAllVms.ps1) - This script starts all Azure virtual machines. It was authored to be used by an Azure function with a timing trigger for starting all virtual machines at the beginning of the workweek.

- [vmSkuAvailabilityByRegion.ps1](https://github.com/mattlunzer/powerShell/blob/master/compute/vmSkuAvailabilityByRegion.ps1) - This script will search all Azure public regions for the availability of a specific virtual machine SKU, including availability zone(s). Note this script does NOT check for Azure subscription quota and or regional\az capacity.