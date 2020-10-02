# Yo!

## Why it does:
At our office, the Davinci Resolve database is stored on our QNAP 24 bay NAS known as "Boris".
Unfortunately, the DaVinci Resolve Project Server program doesn't work on Linux, so any backups have to be created manually.
This is an automated way of doing that without DRPS.





## What it does:
At 2am every morning, the NAS runs a script:
```/usr/local/bin/CallForBackup.sh```

Each time, a **daily** backup is created with the day of the week in its name.
E.g, Friday would be, ```Day5_DatabaseBackup.gz```
Next Friday this backup will be overwritten.

Every Saturday a **weekly** backup is created with the week of the month in its name.
E.g, 26th of Sept would be ```Week4_DatabaseBackup.gz```
Next month, this will be overwritten.

On the first day of every month a **monthly** backup is created with the month of the year in its name.
E.g., 1st of Oct would be ```Month10_DatabaseBackup.gz```
The 1st of Oct next year, this will be overwritten.

This means that we have recent backups with Daily if for some reason something goes wrong in a day,
but also weekly if someone accidentally ruins a project and only finds out some time later.
Monthly is a bit overkill, but who knows if we have to really ressurect something.




## Ch-ch-ch-changes:
The following files play their respective parts:

- "ResolveDB_backup.sh", performs the actual backup
- "CallForBackup.sh", calls the above file and logs output
- "ResolveDB-backup-install", installs the above files locally and makes them executable.
- "solo.sh", is a perl script written by Tim Kay which prevents the job running over itself by binding port 2020 until execution finishes. https://www.timkay.com/solo/
- "ResolveDB-cron-install",  re-adds "CallForBackup.sh" to the crontab every reboot. Unfortunately, necessary for our QNAP. This file must be in the respective autorun scripts folder, e.g: ```/share/CACHEDEV1_DATA/.system/autorun/scripts```

If you make changes, make sure you reinstall by running "ResolveDB-backup-install" manually from an SSH.

