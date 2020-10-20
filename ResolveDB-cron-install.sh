#!/bin/bash

# Load Environment variables
. /ResolveDB-backup.conf

grep -F -q "ResolveDB-backup.sh" $crontabPath; 
if ["$?" -eq 0]; then
	echo "ResolveDB-backup.sh" is already listed in crontab
	exit 1
else
	echo Inserting "ResolveDB-backup.sh" in crontab.
	echo "0 2 * * * /usr/local/bin/ResolveDB-backup.sh" >> $crontabPath
	
	echo Setting and restarting crontab.
	crontab $crontabPath && /etc/init.d/crond.sh restart
	echo [  OK  ]
fi
