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

