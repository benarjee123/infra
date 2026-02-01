
## This code works if all secrets predefined in repos file

trigger:
- main

pool:
  name: 'LinuxPool'

steps:
- checkout: self

# Terraform Init
- task: AzureCLI@2
  displayName: 'Terraform Init'
  inputs:
    azureSubscription: 'Azure-Testing-Connection'
    scriptType: bash
    scriptLocation: inlineScript
    inlineScript: |
      export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
      terraform init -input=false

# Terraform Plan
- task: AzureCLI@2
  displayName: 'Terraform Plan'
  inputs:
    azureSubscription: 'Azure-Testing-Connection'
    scriptType: bash
    scriptLocation: inlineScript
    inlineScript: |
      export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
      terraform plan -out=tfplan -input=false

# Terraform Apply
- task: AzureCLI@2
  displayName: 'Terraform Apply'
  inputs:
    azureSubscription: 'Azure-Testing-Connection'
    scriptType: bash
    scriptLocation: inlineScript
    inlineScript: |
      export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
      terraform apply -auto-approve tfplan
