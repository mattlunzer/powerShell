$fdname = "myFrontDoor$(Get-Random)"
$rg = "myWebApp"
$routingrule1 = 
$backendpool1 = 
$frontendEndpoint1 = 
$loadBalancingSetting1 = 
$healthProbeSetting1 = 
$backendPoolsSetting1 = 

New-AzFrontDoor `
-Name $fdname `
-ResourceGroupName "rg" `
-RoutingRule $routingrule1 `
-BackendPool $backendpool1 `
-FrontendEndpoint $frontendEndpoint1 `
-LoadBalancingSetting $loadBalancingSetting1 `
-HealthProbeSetting $healthProbeSetting1 `
-BackendPoolsSetting $backendPoolsSetting1