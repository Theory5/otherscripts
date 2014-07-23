#Kippo anti-suicide pill
#use as directed
#written to keep kippo from killing itself by removing /kippo/kippo.pid from /var/run/
#not sure if this is part of a larger issue (or operator error), hence why this is not a push request to the actual repo.
#I just want to keep kippo running constantly so I can leave it running for weeks without checking it and it'll feed logs to my SIEM.
#add to crontab I will add it for every 5 minutes, you may want to do it differently.
#by Theory5 using components and code snippets taken from stop.sh among other things. Use this as you wish, please give credit if you publish this somewhere else

#!/bin/sh

#see if kippo.pid exists

PIDFILE=kippo.pid

if ! [ -f /var/run/kippo/$PIDFILE ]
then
        
         echo "Kippo is not running, activating soul stone..."
        mkdir -p /var/run/kippo/
        chown -R kippo:kippo /var/run/kippo/
        exit
        
        echo "Restarting Kippo"

        twistd -y kippo.tac -l /var/kippo/log/kippo.log --pidfile /var/run/kippo/kippo.pid

        PID=$(cat $PIDFILE 2>/dev/null)

        if ! [ -n "$PID" ]
                then
                echo "Kippo is up and running again! YAY!"
                exit
fi
else
 
 echo "Kippo is running"      

fi

