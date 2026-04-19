// AMPT-prod Secure Landing Zone - Infrastructure as Code

targetScope = 'subscription' // This allows us to create the Resource Group

param rgName string
param location string
param prefix string
param tags object

// 1. Create Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
  tags: tags
} 

// 2. Deploy the Network using a Module
module networkResources './modules/network.bicep' = {
  name: 'networkDeployment'
  scope: resourceGroup(rg.name) // Tells the module to deploy INSIDE the new Resource Group
  params: {
    location: location
    prefix: prefix
    tags: tags
  }
}

// 3. Outputs for Reference
output resourceGroupName string = rg.name
output spokeVnetName string = networkResources.outputs.spokeVnetId
output hubVnetName string = networkResources.outputs.hubVnetId
