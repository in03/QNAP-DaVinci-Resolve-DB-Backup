#!/bin/bash

# Load Environment variables
. /ResolveDB-backup.conf

# Create logs directory if not exist
cd "$(dirname "$0")"
if [ ! -d logs ]; then
  mkdir logs;
fi

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>logs/"$(date +"%Y-%m-%d_%H_%M")"_database_backup.log 2>&1

echo
echo
echo


# Clean up function
function cleanUp() {
	echo Cleaning up...
	if ! rm -f $ResolveDBpath/~ResolveBackup.pgSQL.gz; then
		if ! rm -f $ResolveDBpath/~ResolveBackup.pgSQL; then
			echo Could not clean up!
            exit 1
        fi
	fi
    echo cleaned up, removing lock.
	rm -f ~backupinprogress.lock
    exit 0
}

# Create lockfile to prevent job running concurrently
 if { set -C; 2>/dev/null >~backupinprogress.lock; }; then
         trap cleanUp EXIT
 else
         echo "Lock file exists… exiting"
         exit 1
 fi

# Run main

# Get times
DOM=$(date +%d)
DOW=$(date +%u)
MOY=$(date +%m)
WOM=$((($(date +%-d)-1)/7+1))
DaysThisMonth=$(date -d "$(($(date +%-m)%12+1))/1 - 1 days" +%d)


# Dump database
echo Backing up Resolve Database...
if docker exec -t "$ContainerName" pg_dumpall --oids  -U postgres > "$ResolveDBpath"/~ResolveBackup.pgSQL; then
	echo [  OK  ]
else
	echo [  FAIL  ]
	cleanUp
fi




# Compress
echo Compressing back up...
if gzip -f "$ResolveDBpath"/~ResolveBackup.pgSQL; then
	echo [  OK  ]
else
	echo [  FAIL  ]
	cleanUp
fi




# Copy daily
echo Creating daily copy of database...
if \cp -f "$ResolveDBpath"/~ResolveBackup.pgSQL.gz "$ResolveDBpath"/Daily/Day"$DOW"_DatabaseBackup.gz
	echo [  OK  ]
else
	echo [  FAIL  ]
	cleanUp
fi


# Copy weekly
if [ "$DOW" -eq 6 ]; then
	echo Creating weekly copy of database...
	if \cp -f "$ResolveDBpath"/~ResolveBackup.pgSQL.gz "$ResolveDBpath"/Weekly/Week"$WOM"_DatabaseBackup.gz; then
		echo [  OK  ]
	else
		echo [  FAIL  ]
        cleanUp
    fi
else
	echo Weekly backup scheduled "$((6 - DOW))" day/s from now
fi

# Copy monthly
if [ "$DOM" -eq 1 ]; then
	echo Creating monthly copy of database...
	if \cp -f "$ResolveDBpath"/~ResolveBackup.pgSQL.gz "$ResolveDBpath"/Monthly/Month"$MOY"_DatabaseBackup.gz; then
        echo [  OK  ]
    else
        echo [  FAIL  ]
        cleanUp
    fi
else
	echo Monthly backup scheduled "$((DaysThisMonth - $(date +%d)))" day/s from now
fi


# Optimize database
echo Optimizing database...
if docker exec -t "$ContainerName" vacuumdb --analyze --host localhost --username "$UserName" "$DatabaseName"; then
	echo [  OK  ]
	cleanUp
else
	echo [  FAIL  ]
	cleanUp
fi

echo
echo
