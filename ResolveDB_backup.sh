#!/bin/bash


ResolveDBpath="/share/DaVinciDatabase/ResolveDatabaseBackups"
ContainerName="postgres-1"
UserName="postgres"
DatabaseName="boris"

# Get times
DOM=$(date +%d)
DOW=$(date +%u)
MOY=$(date +%m)
WOM=$((($(date +%-d)-1)/7+1))
DaysThisMonth=$(date -d "$(($(date +%-m)%12+1))/1 - 1 days" +%d)


function cleanUp {
	echo Cleaning up...
	rm -f $ResolveDBpath/~ResolveBackup.pgSQL.gz
	if [ $? -eq 1 ]
	then
		rm -f $ResolveDBpath/~ResolveBackup.pgSQL
		if [ $? -eq 1 ]
		then
			echo Could not clean up!
	fi
}


# Dump database
echo Backing up Resolve Database...
docker exec -t "$ContainerName" pg_dumpall --oids  -U postgres > "$ResolveDBpath"/~ResolveBackup.pgSQL
if [ $? -eq 0 ]
then
	echo [  OK  ]
else
	echo [  FAIL  ]
	cleanUp
	exit 1
fi




# Compress
echo Compressing back up...
gzip -f "$ResolveDBpath"/~ResolveBackup.pgSQL
if [ $? -eq 0 ]
then
	echo [  OK  ]
else
	echo [  FAIL  ]
	cleanUp
	exit 1
fi




# Copy daily
echo Creating daily copy of database...
\cp -f "$ResolveDBpath"/~ResolveBackup.pgSQL.gz "$ResolveDBpath"/Daily/Day"$DOW"_DatabaseBackup.gz
if [ $? -eq 0 ]
then
	echo [  OK  ]
else
	echo [  FAIL  ]
	cleanUp
	exit 1
fi



# Copy weekly
if [ "$DOW" -eq 6 ]
then
	echo Creating weekly copy of database...
	\cp -f "$ResolveDBpath"/~ResolveBackup.pgSQL.gz "$ResolveDBpath"/Weekly/Week"$WOM"_DatabaseBackup.gz
	if [ $? -eq 0 ]
	then
		echo [  OK  ]
	else
		echo [  FAIL  ]
        cleanUp
		exit 1
    fi
else
	echo Weekly backup scheduled "$((6 - DOW))" day/s from now
fi

# Copy monthly
if [ "$DOM" -eq 1 ]
then
	echo Creating monthly copy of database...
	\cp -f "$ResolveDBpath"/~ResolveBackup.pgSQL.gz "$ResolveDBpath"/Monthly/Month"$MOY"_DatabaseBackup.gz
	exitSafely
else
	echo Monthly backup scheduled "$((DaysThisMonth - $(date +%d)))" day/s from now
fi


# Optimize database
echo Optimizing database...
docker exec -t "$ContainerName" vacuumdb --analyze --host localhost --username "$UserName" "$DatabaseName"
if [ $? -eq 0 ]
then
	echo [  OK  ]
	cleanUp
else
	echo [  FAIL  ]
	cleanUp
	exit 1
fi


echo
echo
exit 0