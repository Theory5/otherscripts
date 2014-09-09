#Dionaea continuity script

#!/bin/sh


#see if dionaea.pid exists

PIDFILE=dionaea.pid

if ! [ -f /var/run/$PIDFILE ]
then
echo "Dionaea is not running, restarting..."

/etc/init.d/dionaea start

PID=$(cat $PIDFILE 2>/dev/null)

if ! [ -n "$PID" ]

then

/etc/init.d/dionaea status

echo "Dionaea is up and running again! YAY!"
fi
else
echo "Dionaea is running"
fi
