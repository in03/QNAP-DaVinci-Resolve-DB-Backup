#!/bin/bash

echo Copying files to NAS...
cp -f ResolveDB_backup.sh /usr/local/bin/ResolveDB_backup.sh
cp -f CallForBackup.sh /usr/local/bin/CallForBackup.sh
cp -f solo.sh /usr/local/bin/solo.sh
cp -f ResolveDB-cron-install.sh /share/CACHEDEV1_DATA/.system/autorun/scripts
echo [  OK  ]

echo Making files executable...
chmod +x /usr/local/bin/ResolveDB_backup.sh
chmod +x /usr/local/bin/CallForBackup.sh
chmod +x /usr/local/bin/solo.sh
chmod +x /share/CACHEDEV1_DATA/.system/autorun/scripts/ResolveDB-cron-install.sh
echo [  OK  ]

echo Adding to crontab...
cd /share/CACHEDEV1_DATA/.system/autorun/scripts
./ResolveDB-cron-install.sh
echo [  OK  ]