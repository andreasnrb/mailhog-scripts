#! /bin/sh
# /etc/init.d/mailhog
#
# MailHog init script.
#
# @author Jeff Geerling

### BEGIN INIT INFO
# Provides:          mailhog
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start MailHog at boot time.
# Description:       Enable MailHog.
### END INIT INFO

PID=/var/run/mailhog.pid
LOCK=/var/lock/mailhog.lock
USER=nobody
BIN=/opt/mailhog/mailhog
DAEMONIZE_BIN=/usr/sbin/daemonize

# Carry out specific functions when asked to by the system
case "$1" in
  start)
    echo "Starting mailhog."
    $DAEMONIZE_BIN -p $PID -l $LOCK -u $USER $BIN
    ;;
  stop)
    if [ -f $PID ]; then
      echo "Stopping mailhog.";
      kill -TERM $(cat $PID);
      rm -f $PID;
    else
      echo "MailHog is not running.";
    fi
    ;;
  restart)
    echo "Restarting mailhog."
    if [ -f $PID ]; then
      kill -TERM $(cat $PID);
      rm -f $PID;
    fi
    $DAEMONIZE_BIN -p $PID -l $LOCK -u $USER $BIN
    ;;
  status)
    if [ -f $PID ]; then
      echo "MailHog is running.";
    else
      echo "MailHog is not running.";
      exit 3
    fi
    ;;
  *)
    echo "Usage: /etc/init.d/mailhog {start|stop|status|restart}"
    exit 1
    ;;
esac

exit 0