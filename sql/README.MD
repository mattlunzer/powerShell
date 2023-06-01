# Azure Powershell Scripts

The following powershell scripts and their use case in this folder are as follows;

- [adfcSqlSetClassicBaselineRuleExample.ps1](https://github.com/mattlunzer/powerShell/blob/master/sql/adfcSqlSetClassicBaselineRuleExample.ps1) - 
This script enumerates all the servers under the microsoft.sql resource provider and sets an example baseline rule for each database. This script is useful for setting a baseline rule for all servers in a subscription. Then, the script starts an assessment per datasbse to refelct the results in defender for sql (classic) The script can be modified to set a baseline rule for a specific server or database.
