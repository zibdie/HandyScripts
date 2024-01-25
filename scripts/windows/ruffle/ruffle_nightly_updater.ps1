$downloadPath = "C:\Program Files\ruffle\ruffle-download.zip"
$extractionPath = "C:\Program Files\ruffle\ruffle-build"
$today = Get-Date -Format "yyyy-MM-dd"
$todayFormatted = Get-Date -Format "yyyy_MM_dd"
$ruffleURL = "https://github.com/ruffle-rs/ruffle/releases/download/nightly-$today/ruffle-nightly-$todayFormatted-windows-x86_64.zip"

Function Ensure-Directory {
    param (
        [string]$Path
    )

    if (!(Test-Path -Path $Path)) {
        New-Item -ItemType Directory -Force -Path $Path
    }
}

try {
    Ensure-Directory -Path (Split-Path -Path $downloadPath -Parent)
    Invoke-WebRequest -Uri $ruffleURL -OutFile $downloadPath
    Ensure-Directory -Path $extractionPath
    Expand-Archive -Path $downloadPath -DestinationPath $extractionPath -Force
}
catch {
    # If download fails, silently exit the script
    Exit
}

# Delete the downloaded nightly build
if (Test-Path -Path $downloadPath) {
    Remove-Item -Path $downloadPath
}

# Register Ruffle as the default SWF handler
$rufflePath = 'C:\Program Files\ruffle\ruffle-build\ruffle.exe'
$classesRoot = 'HKCU:\Software\Classes'
$swfKeyPath = "$classesRoot\.swf"
$ruffleKeyPath = "$classesRoot\RuffleSWF"
$commandKeyPath = "$ruffleKeyPath\shell\open\command"
if (-not (Test-Path $swfKeyPath)) {
    New-Item -Path $swfKeyPath -Force
}
Set-ItemProperty -Path $swfKeyPath -Name "(Default)" -Value "RuffleSWF"
if (-not (Test-Path $ruffleKeyPath)) {
    New-Item -Path $ruffleKeyPath -Force
}
Set-ItemProperty -Path $ruffleKeyPath -Name "(Default)" -Value "Ruffle Flash Player"
if (-not (Test-Path $commandKeyPath)) {
    New-Item -Path $commandKeyPath -Force
}
Set-ItemProperty -Path $commandKeyPath -Name "(Default)" -Value "`"$rufflePath`" `"%1`""
# Notify the system of the change
[System.Diagnostics.Process]::Start("cmd.exe", "/c ftype RuffleSWF=`"$rufflePath`" `"%1`" & assoc .swf=RuffleSWF")
