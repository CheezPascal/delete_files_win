# Define what the script does
# This script moves files from the specified folder to the Recycle Bin

# Define the folder path
$ScreenshotPath = "C:\Users\ezeaniec\Music\screenshots"

# Load required assembly for Recycle Bin functionality
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class RecycleBin
{
    [DllImport("shell32.dll", CharSet = CharSet.Unicode)]
    public static extern int SHFileOperation(ref SHFILEOPSTRUCT FileOp);

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct SHFILEOPSTRUCT
    {
        public IntPtr hwnd;
        public uint wFunc;
        public string pFrom;
        public string pTo;
        public ushort fFlags;
        public bool fAnyOperationsAborted;
        public IntPtr hNameMappings;
        public string lpszProgressTitle;
    }
    public const int FO_DELETE = 3;
    public const ushort FOF_ALLOWUNDO = 0x40;
    public const ushort FOF_NOCONFIRMATION = 0x10;
    public const ushort FOF_SILENT = 0x04;
    public static bool MoveToRecycleBin(string path)
    {
        SHFILEOPSTRUCT fs = new SHFILEOPSTRUCT
        {
            wFunc = FO_DELETE,
            pFrom = path + "\0",
            fFlags = FOF_ALLOWUNDO | FOF_NOCONFIRMATION | FOF_SILENT
        };
        return SHFileOperation(ref fs) == 0;
    }
}
"@ -Language CSharp

# Function to send files to Recycle Bin
function Move-FilesToRecycleBin {
    param (
        [string]$Path
    )
    
    if (Test-Path $Path) {
        $Files = Get-ChildItem -Path $Path -File
        foreach ($File in $Files) {
            [RecycleBin]::MoveToRecycleBin($File.FullName)
            Write-Host "Moved $($File.FullName) to Recycle Bin"
        }
    } else {
        Write-Host "The folder path does not exist."
    }
}

# Main code to move files to Recycle Bin
Move-FilesToRecycleBin -Path $ScreenshotPath
