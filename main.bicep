@sys.description('The Web App Backend name .')
@minLength(3)
@maxLength(40)
param appServiceAppNameBE string = 'bmazari-assignment-app-be-bicep'
@sys.description('The Web App FrontEnd name .')
@minLength(3)
@maxLength(40)
param appServiceAppNameFE string = 'bmazari-assignment-app-fe-bicep'
@sys.description('The App Service Plan name.')
@minLength(3)
@maxLength(40)
param appServicePlanName string = 'bmazari-assignment-ASP-bicep'
@sys.description('The Storage Account name.')
@minLength(3)
@maxLength(40)
param storageAccountName string = 'jseijasstorage'
@allowed([
  'nonprod'
  'prod'
])
param environmentType string = 'nonprod'
param location string = resourceGroup().location

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

module appServiceBE 'module/appStuff.bicep' = {
  name: 'appServiceBE'
  params: {
    location: location
    appServiceAppName: appServiceAppNameBE
    appServicePlanName: appServicePlanName
    environmentType: environmentType
  }
}


module appServiceFE 'module/appStuff.bicep' = {
  name: 'appServiceFE'
  params: {
    location: location
    appServiceAppName: appServiceAppNameFE
    appServicePlanName: appServicePlanName
    environmentType: environmentType
  }
}




output appServiceAppHostNameBE string = appServiceBE.outputs.appServiceAppHostName
output appServiceAppHostNameFE string = appServiceFE.outputs.appServiceAppHostName













