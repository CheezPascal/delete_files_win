$DownloadsPath = "C:\Users\ezeaniec\Downloads"
$ScreenshotsPath = "C:\Users\ezeaniec\Pictures\Screenshots"

# Create Shell Object
$Shell = New-Object -ComObject Shell.Application

# Function to move files to Recycle Bin
function Move-ToRecycleBin {
    param ([string]$FolderPath)
    Get-ChildItem -Path $FolderPath -File | ForEach-Object { $Shell.Namespace(10).ParseName($_.FullName).InvokeVerb("Delete") }
}

# Move files to Recycle Bin
Move-ToRecycleBin -FolderPath $DownloadsPath
Move-ToRecycleBin -FolderPath $ScreenshotsPath
