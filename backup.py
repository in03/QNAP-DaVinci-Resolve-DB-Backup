#!/usr/bin/env python3

import os
import sys
import glob
import subprocess
import datetime
import calendar

ResolveDBpath="/share/DaVinciDatabase/ResolveDatabaseBackups"
ContainerName="postgres-1"
UserName="postgres"
DatabaseName="boris"

# Get date data
today = datetime.datetime.today().date()
dow = today.weekday()
dom = today.day
ldom = calendar.monthrange(today.year, today.month)[1]
wom = today.isocalendar()[1] - today.replace(day=1).isocalendar()[1] + 1
moy = today.month

print(f"Today is day {dow} of the week, {dom}-{moy}. It's week {wom} of the month, with {ldom} days in this month total.")
sys.exit


# def cleanUp() {
	# print("Cleaning up...")

	# for file in 
	# if [ $? -eq 1 ]
	# then
		# rm -f ~ResolveBackup.pgSQL
	# fi
# }

# def dump_database:
    # print(Backing up Resolve Database...)

    # docker
    # subprocess.run(['docker', 'exec', '-t', ],
    #Probably don't forget these, too
    # check=True, text=True)
    # process = subprocess.Popen(bashcommand.split()), stdout=subprocess.PIPE)
    # output, error = process.communicate()

    # docker exec -t "$ContainerName" pg_dumpall --oids  -U postgres > "$ResolveDBpath"/~ResolveBackup.pgSQL
    # if [ $? -eq 0 ]
    # then
        # echo [  OK  ]
    # else
        # echo [  FAIL  ]
        # cleanUp
        # exit 1
    # fi




#Compress
# echo Compressing back up...
# gzip -f "$ResolveDBpath"/~ResolveBackup.pgSQL
# if [ $? -eq 0 ]
# then
	# echo [  OK  ]
# else
	# echo [  FAIL  ]
	# cleanUp
	# exit 1
# fi




#Copy daily
# echo Creating daily copy of database...
# \cp -f "$ResolveDBpath"/~ResolveBackup.pgSQL.gz "$ResolveDBpath"/Daily/Day"$DOW"_DatabaseBackup.gz
# if [ $? -eq 0 ]
# then
	# echo [  OK  ]
# else
	# echo [  FAIL  ]
	# cleanUp
	# exit 1
# fi



#Copy weekly
# if [ "$DOW" -eq 6 ]
# then
	# echo Creating weekly copy of database...
	# \cp -f "$ResolveDBpath"/~ResolveBackup.pgSQL.gz "$ResolveDBpath"/Weekly/Week"$WOM"_DatabaseBackup.gz
	# if [ $? -eq 0 ]
	# then
		# echo [  OK  ]
	# else
		# echo [  FAIL  ]
        # cleanUp
		# exit 1
    # fi
# else
	# echo Weekly backup scheduled "$((6 - DOW))" day/s from now
# fi

#Copy monthly
# if [ "$DOM" -eq 1 ]
# then
	# echo Creating monthly copy of database...
	# \cp -f "$ResolveDBpath"/~ResolveBackup.pgSQL.gz "$ResolveDBpath"/Monthly/Month"$MOY"_DatabaseBackup.gz
	# exitSafely
# else
	# echo Monthly backup scheduled "$((DaysThisMonth - $(date +%d)))" day/s from now
# fi


#Optimize database
# echo Optimizing database...
# docker exec -t "$ContainerName" vacuumdb --analyze --host localhost --username "$UserName" "$DatabaseName"
# if [ $? -eq 0 ]
# then
	# echo [  OK  ]
	# cleanUp
# else
	# echo [  FAIL  ]
	# cleanUp
	# exit 1
# fi


# echo
# echo
# exit 0