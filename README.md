Yo! 

**Why it does:**
The Davinci Resolve database is stored on the 24 bay NAS known as "Boris".
Unfortunately, the DaVinci Resolve Project Server program doesn't work on Linux, so any backups have to be created manually.
This is an automated way of doing that without DRPS.





**What it does:**
At 2am every morning, the NAS runs a script. (It's here "/usr/local/bin/CallForBackup.sh")

Each time, a daily backup is created with the day of the week in it's name.
E.g, Friday would be "Day5_DatabaseBackup.gz". 
Next Friday this backup will be overwritten.

Every Saturday a weekly backup is created with the week of the month in it's name.
E.g, 26th of Sept would be "Week4_DatabaseBackup.gz". 
Next month, this will be overwritten.

On the first day of every month a monthly backup is created with the month of the year in it's name.
E.g., 1st of Oct would be "Month10_DatabaseBackup.gz" 
The 1st of Oct next year, this will be overwritten.

This means that we have recent backups with "Daily" if for some goes wrong in a day,
but also weekly if someone accidentally ruined a project and only find out later.
Monthly is a bit overkill, but who knows if we have to ressurect some missing project.





**Ch-ch-ch-changes:**
To modify the script, show hidden files on this directory and five files will show:

- "ResolveDB_backup.sh", which performs the actual backup
- "CallForBackup.sh", which calls the above file and logs output
- "ResolveDB-backup-install", which installs the above files and makes them executable.
- "solo.sh", a perl script which prevents the job running over itself by binding port 2020 until execution finishes.
- "ResolveDB-cron-install", which re-adds "CallForBackup" to the crontab every reboot.
   This file must be in the autorun scripts folder: "/share/CACHEDEV1_DATA/.system/autorun/scripts"

If you make changes, make sure you reinstall by running "ResolveDB-backup-install" manually from SSH.


 