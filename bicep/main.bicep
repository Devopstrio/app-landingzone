// Devopstrio App Landing Zone - Platform Infrastructure
targetScope = 'subscription'

param location string = 'uksouth'
param prefix string = 'alz'
param env string = 'prod'

// 1. Foundation Network Resource Group
resource rgNetwork 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${prefix}-network-${env}'
  location: location
}

// 2. Foundation Compute Resource Group
resource rgPlatform 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${prefix}-platform-${env}'
  location: location
}

// 3. Deploy Platform Components
module platform './modules/app-platform.bicep' = {
  scope: rgPlatform
  name: 'platformDeploy'
  params: {
    location: location
    clusterName: 'aks-${prefix}-host-${env}'
  }
}

// 4. State DB for Provisioning Engine
module db './modules/database.bicep' = {
  scope: rgPlatform
  name: 'dbDeploy'
  params: {
    location: location
    serverName: 'psql-${prefix}-state-${env}'
  }
}

output platformClusterId string = platform.outputs.aksClusterId
