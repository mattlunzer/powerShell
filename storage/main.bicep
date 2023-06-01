// location param
param location string = resourceGroup().location
//storage params
param storageAccountName string = 'avblobstor${uniqueString(resourceGroup().id)}'
param tags object = {}
param storageAccountSku string = 'Standard_LRS'
param storageAccountType string = 'StorageV2'
param containerNames array = ['upload', 'quarantine']
// event grid params
param eventGridTopicName string = 'avforblobtopic${uniqueString(resourceGroup().id)}'
// log analtyics param
param logAnalyticsName string = 'avforbloblogs'

// funtion params
param appName string = 'AVforBlobFunctionName${uniqueString(resourceGroup().id)}'
param functionAppPlanName string = 'AVforBlobFunctionPlan${uniqueString(resourceGroup().id)}'
// param functionAppName string = 'AVforBlob'

// Create storage resource
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: storageAccountSku
  }
  kind: storageAccountType
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  parent: storageAccount
  name: 'default'
}

// Create containers if specified
resource containers 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = [for containerName in containerNames: {
  parent: blobService
  name: !empty(containerNames) ? '${toLower(containerName)}' : 'placeholder'
  properties: {
    publicAccess: 'None'
    metadata: {}
  }
}]

// create event grid
resource eventGridTopic 'Microsoft.EventGrid/topics@2021-06-01-preview' = {
  name: eventGridTopicName
  location: location
}

// create azure function
resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: functionAppPlanName
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
}

resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: appName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${appName}-insights'
  location: location
  kind: 'web'
  properties: {
    ApplicationId: functionApp.id
  }
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsName
  location: location
  properties: {
    retentionInDays: 30
    sku: {
      name: 'PerGB2018'
    }
  }
}
