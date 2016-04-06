#!/bin/sh
#
# Chouette control script
#
# chkconfig: - 80 20
# description: chouette startup script
# processname: wildfly
# pidfile: /var/run/chouette/chouette.pid
#

# Source function library.
. /etc/init.d/functions


if [ -z "$CHOUETTE_HOME" ]; then
        CHOUETTE_HOME=/home/chouette/
fi

if [ -z "$CHOUETTE_PIDFILE" ]; then
	CHOUETTE_PIDFILE=/var/run/chouette/chouette.pid
fi

if [ -z "$CHOUETTE_USER" ];then
	CHOUETTE_USER="chouette"
fi

if [ -z "$CHOUETTE_CONSOLE_LOG" ]; then
	CHOUETTE_CONSOLE_LOG=/var/log/chouette/console.log
fi

if [ -z "$CHOUETTE_LOCKFILE" ]; then
        CHOUETTE_LOCKFILE=/var/lock/subsys/chouette
fi


if [ -z "$STARTUP_WAIT" ]; then
        STARTUP_WAIT=30
fi

if [ -z "$SHUTDOWN_WAIT" ]; then
        SHUTDOWN_WAIT=30
fi


CHOUETTE_SCRIPT="$CHOUETTE_HOME/bin/chouette.sh"

prog="chouette"
start() {
	echo -n "Starting $prog: "
	if [ -f $CHOUETTE_PIDFILE ]; then
		read ppid < $CHOUETTE_PIDFILE
		if [ `ps --pid $ppid 2> /dev/null | grep -c $ppid 2> /dev/null` -eq '1' ]; then
			echo -n "$prog is already running"
			failure
			echo
			return 1
		else
			rm -f $CHOUETTE_PIDFILE
		fi
	fi

	mkdir -p $(dirname $CHOUETTE_CONSOLE_LOG)
        cat /dev/null > $CHOUETTE_CONSOLE_LOG


	mkdir -p $(dirname $CHOUETTE_PIDFILE)
	chown $CHOUETTE_USER $(dirname $CHOUETTE_PIDFILE) || true

	if [ ! -z "$CHOUETTE_USER" ]; then
		su - $CHOUETTE_USER -c "CHOUETTE_PIDFILE=$CHOUETTE_PIDFILE $CHOUETTE_SCRIPT" >> $CHOUETTE_CONSOLE_LOG 2>&1 &
	fi

	count=0
	launched=false

	until [ $count -gt $STARTUP_WAIT ]
	do
		grep 'Ctrl-C to shutdown server' $CHOUETTE_CONSOLE_LOG > /dev/null
		if [ $? -eq 0 ] ; then
			launched=true
			break
		fi
		sleep 1
		let count=$count+1;
	done

	touch $CHOUETTE_LOCKFILE
	success
	echo
	return 0
}

stop() {
	echo -n $"Stopping $prog: "
	count=0;

	if [ -f $CHOUETTE_PIDFILE ]; then
		read kpid < $CHOUETTE_PIDFILE
		let kwait=$SHUTDOWN_WAIT

		# Try issuing SIGTERM
		kill -15 $kpid
		until [ `ps --pid $kpid 2> /dev/null | grep -c $kpid 2> /dev/null` -eq '0' ] || [ $count -gt $kwait ]
			do
			sleep 1
			let count=$count+1;
		done

		if [ $count -gt $kwait ]; then
			kill -9 $kpid
		fi
	fi
	rm -f $CHOUETTE_PIDFILE
	rm -f $CHOUETTE_LOCKFILE
	success
	echo
}

status() {
	if [ -f $CHOUETTE_PIDFILE ]; then
		read ppid < $CHOUETTE_PIDFILE
		if [ `ps --pid $ppid 2> /dev/null | grep -c $ppid 2> /dev/null` -eq '1' ]; then
			echo "$prog is running (pid $ppid)"
			return 0
		else
			echo "$prog dead but pid file exists"
			return 1
		fi
	fi
	echo "$prog is not running"
	return 3
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		$0 stop
		$0 start
		;;
	status)
		status
		;;
	*)
		## If no parameters are given, print which are avaiable.
		echo "Usage: $0 {start|stop|status|restart|reload}"
		exit 1
		;;
esac
