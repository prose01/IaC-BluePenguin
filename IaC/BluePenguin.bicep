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
