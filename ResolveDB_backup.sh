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
CurrentTime=$(date +"%Y-%m-%d_%H_%M")
DaysThisMonth=$(date -d "$(($(date +%-m)%12+1))/1 - 1 days" +%d)



# Dump database
echo Backing up Resolve Database...
docker exec -t "$ContainerName" pg_dumpall --oids  -U postgres > "$ResolveDBpath"/~ResolveBackup.pgSQL
echo [  OK  ]


# Compress
echo Compressing back up...
gzip -f "$ResolveDBpath"/~ResolveBackup.pgSQL
echo [  OK  ]

# Copy daily
echo Creating daily copy of database...
\cp -f "$ResolveDBpath"/~ResolveBackup.pgSQL.gz "$ResolveDBpath"/Daily/Day"$DOW"_DatabaseBackup.gz
echo [  OK  ]

# Copy weekly
if [ $DOW -eq 6 ]
then
	echo Creating weekly copy of database...
	\cp -f "$ResolveDBpath"/~ResolveBackup.pgSQL.gz "$ResolveDBpath"/Weekly/Week"$WOM"_DatabaseBackup.gz
	echo [  OK  ]
else
	echo Weekly backup scheduled "$((6 - $DOW))" day/s from now
fi

# Copy monthly
if [ $DOM -eq 1 ]
then
	echo Creating monthly copy of database...
	\cp -f "$ResolveDBpath"/~ResolveBackup.pgSQL.gz "$ResolveDBpath"/Monthly/Month"$MOY"_DatabaseBackup.gz
	echo [  OK  ]
else
	echo Monthly backup scheduled "$(($DaysThisMonth - $(date +%d)))" day/s from now
fi


# Optimize database
echo Optimizing database...
docker exec -t "$ContainerName" vacuumdb --analyze --host localhost --username "$UserName" "$DatabaseName"
echo [  OK  ]
