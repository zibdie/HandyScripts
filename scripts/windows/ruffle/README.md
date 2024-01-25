# Ruffle Nightly Updater

As of January 2024, [ruffle](https://ruffle.rs/) does not have a "stable" version. Thus, everyday there are daily builds being pushed. To ensure we always have the latest version, I created a PowerShell script that can automate the download and unzipping of 'ruffle' and register it for all `.swf` files. Please checkout the `ruffle_nightly_updater.ps1`

To ensure this runs daily, you can make a task in the Windows [Task Scheduler](https://en.wikipedia.org/wiki/Windows_Task_Scheduler) to automate this. I have included a `add_to_scheduler.ps1` which you must run as an Administrator that can create the task for you. Feel free to look over, and edit, the script to your liking.