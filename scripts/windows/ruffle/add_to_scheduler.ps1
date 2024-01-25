$taskName = "Ruffle Nightly Updater"
$taskDescription = "Daily updater of Ruffle nightly build"
$taskScriptPath = "C:\Program Files\ruffle\ruffle_nightly_updater.ps1"  # Path to your PowerShell script
$startTime = "04:15"

$trigger = New-ScheduledTaskTrigger -Daily -At $startTime
$trigger.StartBoundary = (Get-Date).Date.AddHours(4).AddMinutes(15)
$trigger.ExecutionTimeLimit = "PT1H"  # 1 hour
$trigger.IdleDuration = "PT30M"  # 30 minutes idle
$trigger.WaitTimeout = "PT1H"  # Wait for idle for 1 hour
$trigger.StopAtDurationEnd = $true  # Stop if the computer ceases to be idle
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$taskScriptPath`""
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StopIfGoingOffIdle -RunOnlyIfIdle -IdleDuration "PT30M" -DontStopOnIdleEnd -ExecutionTimeLimit "PT1H" -AllowDemandStart -MultipleInstances IgnoreNew
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName $taskName -Description $taskDescription -Trigger $trigger -Action $action -Principal $principal -Settings $settings
