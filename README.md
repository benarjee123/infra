# infra
Azure_pipeline


# Azure DevOps Pipelines – Source Options

You can connect your pipeline to either **Azure Repos** or **GitHub**.

---

## Option 1: Using Azure Repos

1. Go to **Azure DevOps → Pipelines → New Pipeline**.  
2. When asked for the source, choose **Azure Repos Git**.  
3. Select the repository you want to build.  

### Example Pipeline YAML (Azure Repos)
  

trigger:
- main

pool:
  name: 'LinuxPool'

steps:
- script: echo "Hello from Azure Repos"
  displayName: 'Test pipeline with Azure Repos'

  
##3# Azure DevOps Self-Hosted Agent Setup with Service Principal ## Prerequisites - Azure subscription and resource group created - Azure DevOps organization and project (e.g., `test`) - Linux VM available for hosting the agent --- ## 
Step 1: Create a Service Principal in Azure

appId → Client ID

password → Client Secret

tenant → Tenant ID

Assign Contributor role at the Resource Group level to this Service Principal.

Step 2: Create Key Vault and Assign Role
Create a Key Vault in the same resource group.

Assign the Service Principal Key Vault Secrets User or appropriate role so it can access secrets.

Step 3: Create Service Connection in Azure DevOps
Go to Project Settings → Service connections → New service connection → Azure Resource Manager.

Choose Service Principal (manual).

Enter:

App ID (Client ID)

Tenant ID

Subscription ID

Secret (Client Secret)

This allows pipelines to authenticate securely with Azure.

Step 4: Create Repository for Infrastructure
Create a repo named infra with Terraform files:

main.tf

providers.tf

variables.tf

output.tf

Step 5: Create Pipeline (pipeline.yaml)


# Azure DevOps Self-Hosted Agent Setup We initially attempted to run pipelines using Microsoft‑hosted agents, but encountered a **subscription error** because the organization did not have a Pay‑As‑You‑Go Azure subscription linked. To overcome this limitation, we configured a **self‑hosted agent** on our own VM. This allows pipelines to run without depending on Microsoft‑hosted agents or subscription constraints, while giving us full control over networking, security, and installed tools. ---
## Step 6: Self-Hosted Agent Setup (Option 1: Service Principal)
sudo apt-get update
sudo apt-get install -y curl wget tar
wget https://vstsagentpackage.azureedge.net/agent/4.268.0/vsts-agent-linux-x64-4.268.0.tar.gz
tar zxvf vsts-agent-linux-x64-4.268.0.tar.gz
cd vsts-agent-linux-x64-4.268.0


After downloading and extracting the agent package: ```bash ./config.sh

./config.sh
Provide the following details when prompted:

Server URL → https://dev.azure.com/<your-org>

Authentication type → Service Principal

Tenant ID → from Service Principal output

Service Principal Client ID (appId)

Service Principal Secret (password)

Agent Pool → e.g., LinuxPool

Agent Name → e.g., linux-vm-agent

Work folder → press Enter for _work

## Option 2: Configure Agent with Personal Access Token (PAT)
bash
./config.sh
Provide the following details when prompted:

Server URL → https://dev.azure.com/<your-org>

Authentication type → PAT

Personal Access Token → paste PAT created in Azure DevOps (scope: Agent Pools Read, manage)

Agent Pool → e.g., LinuxPool

Agent Name → e.g., linux-vm-agent

Work folder → press Enter for _work

#### Final Step: Install and Start Agent Service
After configuration (either Option 1 or Option 2), run:

sudo ./svc.sh install
sudo ./svc.sh start
sudo ./svc.sh status

Go back to Azure DevOps → Pipelines and trigger your pipeline (e.g., pipeline.yaml).
The job will now execute on your self‑hosted agent VM (LinuxPool).





