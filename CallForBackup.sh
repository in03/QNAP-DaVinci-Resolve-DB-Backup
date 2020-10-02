#!/bin/bash
echo
echo
echo

cd "$(dirname "$0")"

./ResolveDB_backup.sh |tee -a logs/"$(date +"%Y-%m-%d_%H_%M")"_database_backup.log

# Remove leftover
echo Cleaning up...
rm -f ~ResolveBackup.pgSQL.gz
echo [  OK  ]

echo
echo
echo
