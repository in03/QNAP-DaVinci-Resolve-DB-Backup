#!/bin/bash

# Load Environment variables
. /ResolveDB-backup.conf

echo Copying files to NAS...
cp -f ResolveDB-backup.sh $ScriptInstallPath/ResolveDB-backup.sh
cp -f ResolveDB-cron-install.sh $AutorunScriptsDir/ResolveDB-cron-install.sh
echo [  OK  ]

echo Making files executable...
chmod +x $ScriptInstallPath/ResolveDB-backup.sh
chmod +x $AutorunScriptsDir/ResolveDB-cron-install.sh
echo [  OK  ]

echo Adding to crontab...
cd $AutorunScriptsDir
./ResolveDB-cron-install.sh
echo [  OK  ]