#!/bin/bash
cp -f ResolveDB_backup.sh /usr/local/bin/ResolveDB_backup.sh
cp -f CallForBackup.sh /usr/local/bin/CallForBackup.sh
cp -f solo.sh /usr/local/bin/solo.sh
cp -f ResolveDB-cron-install.sh /
chmod +x /usr/local/bin/ResolveDB_backup.sh
chmod +x /usr/local/bin/CallForBackup.sh
chmod +x /usr/local/bin/solo.sh
echo "0 2 * * * perl usr/local/bin/solo.sh -port=2020 ./CallForBackup.sh" >> /etc/config/crontab
