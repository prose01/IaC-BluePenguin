targetScope='subscription'

@description('Name of the App Service.')
@minLength(5)
@maxLength(30)
param projectName string

@description('The name of the environment. This must be DEV, TEST, or PROD.')
@allowed([
  'DEV'
  'TEST'
  'PROD'
])
param environmentType string

@description('Location. Default is northeurope.')
param location string = 'northeurope'

var tags = {
  '${projectName}': environmentType
}

// Start by creating a new Resource Goup
resource newRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'RG-${projectName}-${environmentType}'
  location: location
  tags: tags
}

// module deployed new storageAccount
module storageAccount 'br/modules:storageaccount:2023-06-09' = {
  name: 'storageAccount'
  scope: newRG
  params: {
    projectName: projectName
    environmentType: environmentType
    location: location
    tags: tags
  }
}

// module add Storage Blob Data Contributor for pipeline
module storageAccountRoleAssignments 'br/modules:roleassignments:2023-06-09' = {
  name: 'storageAccountRoleAssignments'
  scope: newRG
  params: {
    roleDefinitionIds: ['ba92f5b4-2d11-453d-a403-e96b0029c9fe'] // Storage Blob Data Contributor
    principalId: '231bf7bd-9857-477b-acc2-c094a83c54f0' // Development (f060772d-fa8e-4055-9181-bdc18dc90a9a) Service pricipal needs access to storage 
    principalType: 'ServicePrincipal'
  }
}
