#!/bin/bash

grep -F -q "CallForBackup.sh" /etc/config/crontab; 
if ["$?" -eq 0]; then
	echo "CallForBackup.sh" is already listed in crontab
	exit 1
else
	echo Inserting "CallForBackup.sh" in crontab.
	echo "0 2 * * * perl usr/local/bin/solo.sh -port=2020 ./CallForBackup.sh" >> /etc/config/crontab
	
	echo Setting and restarting crontab.
	crontab /etc/config/crontab && /etc/init.d/crond.sh restart
	echo [  OK  ]
fi
