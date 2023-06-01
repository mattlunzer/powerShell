PARAM(
    [string] [Parameter(Mandatory = $True, HelpMessage = "Choose subscription you want be inventored")] $SubscriptionName
    )

Get-AzSubscription -SubscriptionName $SubscriptionName | Select-AzSubscription

$AzureSQLServers = Get-AzResource  | Where-Object ResourceType -EQ Microsoft.SQL/servers
#Write-Output $($AzureSQLServer).ResourceGroupName
#Write-Output $($AzureSQLServers).Name

foreach ($AzureSQLServer in $AzureSQLServers){
    $AzureSQLServerDataBases = Get-AzSqlDatabase -ServerName $AzureSQLServer.Name -ResourceGroupName $AzureSQLServer.ResourceGroupName | Where-Object DatabaseName -NE "master"
    #Write-Host $AzureSQLServerDataBases
    foreach ($AzureSQLServerDataBase in $AzureSQLServerDataBases){
        #Write-Host "Database: " $($AzureSQLServerDataBase).DatabaseName
        Set-AzSqlDatabaseVulnerabilityAssessmentRuleBaseline `
        -ResourceGroupName  $AzureSQLServer.ResourceGroupName `
        -ServerName $AzureSQLServer.Name `
        -DatabaseName $AzureSQLServerDataBase.DatabaseName `
        -BaselineResult @('sql_maint', 'pentaho', 'dip_admin', 'birt') `
        -RuleID 'VA1258'
        Start-AzSqlDatabaseVulnerabilityAssessmentScan `
        -ResourceGroupName  $AzureSQLServer.ResourceGroupName `
        -ServerName $AzureSQLServer.Name `
        -DatabaseName $AzureSQLServerDataBase.DatabaseName
    }
}