# Variables
$agentDir = "C:\agent"
$agentZip = "agent.zip"
$agentURL = "https://vstsagentpackage.azureedge.net/agent/4.264.2/vsts-agent-win-x64-4.264.2.zip"

$orgUrl = "${var.azure_devops_org_url}"
$poolName = "${var.agent_pool_name}"
$pat = "${var.pat_token}"

# Create folder
New-Item -ItemType Directory -Force -Path $agentDir
Set-Location $agentDir

# Download Agent
Invoke-WebRequest -Uri $agentURL -OutFile $agentZip

# Extract
Expand-Archive -Path $agentZip -DestinationPath $agentDir -Force

# Configure Agent
& .\config.cmd --unattended `
  --url $orgUrl `
  --auth pat `
  --token $pat `
  --pool $poolName `
  --agent "AzureVM-Agent" `
  --acceptTeeEula `
  --runAsService

# Start Service
Start-Service vstsagent*
