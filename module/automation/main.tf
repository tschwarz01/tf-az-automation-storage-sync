module "vm-worker" {
  source          = "./vm-worker"
  global_settings = var.global_settings
  module_settings = local.vm_worker_settings

}

resource "azurerm_role_assignment" "stg-src-role-assignment" {
  scope                = var.module_settings.source_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.vm-worker.hybrid_worker_vm.identity[0].principal_id
}

resource "azurerm_role_assignment" "stg-dst-role-assignment" {
  scope                = var.module_settings.destination_storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.vm-worker.hybrid_worker_vm.identity[0].principal_id
}

resource "azurerm_automation_account" "auto-acct" {
  name                = var.module_settings.auto_acct_name
  location            = var.global_settings.location
  resource_group_name = var.global_settings.resource_group_name
  sku_name            = "Basic"
}

resource "azurerm_automation_hybrid_runbook_worker_group" "auto-hwg-group" {
  name                    = "example-hybrid-worker-group"
  resource_group_name     = var.global_settings.resource_group_name
  automation_account_name = azurerm_automation_account.auto-acct.name
  depends_on              = [azurerm_automation_account.auto-acct]
}

// Add a resource for azurerm_automation_hybrid_runbook_worker
resource "azurerm_automation_hybrid_runbook_worker" "auto-hwg-worker" {
  resource_group_name     = var.global_settings.resource_group_name
  automation_account_name = azurerm_automation_account.auto-acct.name
  vm_resource_id          = module.vm-worker.hybrid_worker_vm.id
  worker_group_name       = azurerm_automation_hybrid_runbook_worker_group.auto-hwg-group.name
  worker_id               = "10000000-0000-0000-0000-000000000001"
  depends_on              = [module.vm-worker]
}

// Add a schedule for the runbook we created.  The runbook should run once daily at 2:00 AM
resource "azurerm_automation_schedule" "daily" {
  name                    = "sched-daily"
  resource_group_name     = var.global_settings.resource_group_name
  automation_account_name = azurerm_automation_account.auto-acct.name
  frequency               = "Day"
  interval                = 1
  start_time              = "2024-10-15T02:00:00+00:00"
}

resource "azurerm_automation_runbook" "auto-runbook" {
  name                    = "Sync-StorageAccts"
  resource_group_name     = var.global_settings.resource_group_name
  automation_account_name = azurerm_automation_account.auto-acct.name
  location                = var.global_settings.location
  runbook_type            = "PowerShell"
  log_verbose             = true
  log_progress            = true
  content                 = <<-EOT
    Function Check-Dependencies {

    # Define the path to the azcopy.exe file
    $azcopyPath = "C:\azcopy\azcopy.exe"

    # Check if the file exists
    if (-Not (Test-Path $azcopyPath)) {
        # Define the path to the azcopy directory
        $azcopyDir = "C:\azcopy"
        
        # Check if the directory exists
        if (-Not (Test-Path $azcopyDir)) {
            # Create the directory
            New-Item -ItemType Directory -Path $azcopyDir
        }

        # Define the URL to download the zip file
        $downloadUrl = "https://aka.ms/downloadazcopy-v10-windows"
        # Define the path to save the downloaded zip file
        $zipPath = "$azcopyDir\azcopy.zip"
        # Define the extraction path
        $extractPath = $azcopyDir

        # Download the zip file
        Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath
        # Expand the zip file
        Expand-Archive $zipPath $extractPath -Force
        # Move azcopy.ext to install folder
        Get-ChildItem "$extractPath\*\*" | Move-Item -Destination $extractPath -Force
        # Remove the downloaded zip file
        Remove-Item $zipPath

        # Add azcopy directory to the system PATH environment variable if not already set
        $currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
        if ($currentPath -notlike "*$azcopyDir*") {
            [System.Environment]::SetEnvironmentVariable("Path", "$currentPath;$azcopyDir", [System.EnvironmentVariableTarget]::Machine)
        }
    }
}

Function Sync-StorageAccts {

    $env:AZCOPY_CONCURRENCY_VALUE=4000
    # If using SYSTEM Managed Identity (recommended)
    $Env:AZCOPY_AUTO_LOGIN_TYPE="MSI"

    # If using USER Managed Identity, you need the following $Env set in addition to $Env:AZCOPY_AUTO_LOGIN_TYPE="MSI"
    #$Env:AZCOPY_MSI_CLIENT_ID=<client-id>
    #$Env:AZCOPY_MSI_OBJECT_ID=<object-id>
    #$Env:AZCOPY_MSI_RESOURCE_STRING=<resource-id>

    # If using a Service Principal, the following $Env variables must be set 
    #$Env:AZCOPY_AUTO_LOGIN_TYPE=SPN
    #$Env:AZCOPY_SPA_APPLICATION_ID=<application-id>
    #$Env:AZCOPY_SPA_CLIENT_SECRET=<client-secret>
    #$Env:AZCOPY_TENANT_ID=<tenant-id>

    C:\azcopy\azcopy.exe copy 'https://stgdatadw.dfs.core.windows.net/' 'https://stgdatadw2.dfs.core.windows.net' --recursive --overwrite=ifSourceNewer
}

Check-Dependencies
$results = Sync-StorageAccts
Write-Output $results

EOT
  // Add job_schedule block to link with previously defined schedule
  job_schedule {
    schedule_name = azurerm_automation_schedule.daily.name
  }
}

// Add HybridWorkerExtension to the created virtual machine

resource "azurerm_virtual_machine_extension" "example" {
  name = "example-hybrid-worker-extension"
  #virtual_machine_id   = azurerm_windows_virtual_machine.example.id
  virtual_machine_id   = module.vm-worker.hybrid_worker_vm.id
  publisher            = "Microsoft.Azure.Automation.HybridWorker"
  type                 = "HybridWorkerForWindows"
  type_handler_version = "1.1"
  settings             = <<-EOF
    {
      "AutomationAccountURL" : "${azurerm_automation_account.auto-acct.hybrid_service_url}"
    }
  EOF
  depends_on           = [module.vm-worker]
}
