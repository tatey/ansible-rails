#!/bin/sh
### BEGIN INIT INFO
# Provides:          unicorn
# Required-Start:    $local_fs $remote_fs mysql
# Required-Stop:     $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: unicorn initscript
# Description:       Unicorn is an HTTP server for Rack application
### END INIT INFO

# Author: Troex Nevelin <troex@fury.scancode.ru>, Tate Johnson <tate@tatey.com>
# based on http://gist.github.com/308216 by http://github.com/mguterl

# A sample /etc/unicorn/my_app.conf. No defaults, you must be explicit.
#
## RAILS_ENV=production
## RAILS_ROOT=/var/apps/www/my_app/current
## UNICORN_CMD="$RAILS_ROOT/bin/unicorn"
## UNICORN_CONFIG="$RAILS_ROOT/config/unicorn.rb"
## UNICORN_LOG=$RAILS_ROOT/log/unicorn.log
## UNICORN_PID=$RAILS_ROOT/tmp/pids/unicorn.pid
## UNICORN_SOCKET=$RAILS_ROOT/tmp/sockets/unicorn.sock
## UNICORN_USER="www-data"
## UNICORN_RESTART_SLEEP=5

# A recommended config/unicorn.rb
#
## working_directory File.expand_path("../..", __FILE__)
## worker_processes 1

set -e

sig () {
  test -s "$UNICORN_PID" && kill -$1 `cat "$UNICORN_PID"`
}

oldsig () {
  test -s "$UNICORN_OLD_PID" && kill -$1 `cat "$UNICORN_OLD_PID"`
}

cmd () {
  case $1 in
    start)
      sig 0 && echo >&2 "Already running" && return
      echo "Starting"
      $CMD
      ;;  
    stop)
      sig QUIT && echo "Stopping" && return
      echo >&2 "Not running"
      ;;  
    force-stop)
      sig TERM && echo "Forcing a stop" && return
      echo >&2 "Not running"
      ;;  
    restart|reload)
      sig USR2 && sleep $UNICORN_RESTART_SLEEP && oldsig QUIT && echo "Killing old master" `cat $UNICORN_OLD_PID` && return
      echo >&2 "Couldn't reload, starting '$CMD' instead"
      $CMD
      ;;  
    upgrade)
      sig USR2 && echo Upgraded && return
      echo >&2 "Couldn't upgrade, starting '$CMD' instead"
      $CMD
      ;;  
    rotate)
      sig USR1 && echo rotated logs OK && return
      echo >&2 "Couldn't rotate logs" && return
      ;;
    status)
      sig 0 && echo >&2 "Already running" && return
      echo >&2 "Not running" && return
      ;;
    *)
      echo >&2 "Usage: $0 <start|stop|restart|reload|status|upgrade|rotate|force-stop>"
      return
      ;;  
    esac
}

setup () {
  echo -n "$RAILS_ROOT: "
  cd $RAILS_ROOT || exit 1

  if [ -z "$UNICORN_CMD" ]; then
    echo "UNICORN_CMD not set"
    exit 1
  fi

  if [ -z "$UNICORN_CONFIG" ]; then
    echo "UNICORN_CONFIG not set"
    exit 1
  fi

  if [ -z "$UNICORN_LOG" ]; then
    echo "UNICORN_LOG not set"
    exit 1
  fi

  if [ -z "$UNICORN_PID" ]; then
    echo "UNICORN_PID not set"
    exit 1
  fi

  if [ -z "$UNICORN_SOCKET" ]; then
    echo "UNICORN_PID not set"
    exit 1
  fi

  if [ -z "$UNICORN_USER" ]; then
    echo "UNICORN_RESTART_SLEEP not set"
    exit 1
  fi

  if [ -z "$UNICORN_RESTART_SLEEP" ]; then
    echo "UNICORN_RESTART_SLEEP not set"
    exit 1
  fi

  export RAILS_ROOT
  export UNICORN_PID
  export UNICORN_OLD_PID="$PID.oldbin"
  export UNICORN_RESTART_SLEEP
  export CMD="sudo -u $UNICORN_USER -- env UNICORN_LOG=$UNICORN_LOG UNICORN_PID=$UNICORN_PID UNICORN_SOCKET=$UNICORN_SOCKET $UNICORN_CMD -c $UNICORN_CONFIG -E $RAILS_ENV -D"
}

start_stop () {
  # either run the start/stop/reload/etc command for every config under /etc/unicorn
  # or just do it for a specific one

  # $1 contains the start/stop/etc command
  # $2 if it exists, should be the specific config we want to act on
  if [ -n "$2" ]; then
    if [ -f "/etc/unicorn/$2.conf" ]; then
      . /etc/unicorn/$2.conf
      setup
      cmd $1
    else
      echo >&2 "/etc/unicorn/$2.conf: not found"
    fi
  else
    for CONFIG in /etc/unicorn/*.conf; do
      # import the variables
      . $CONFIG
      setup

      # run the start/stop/etc command
      cmd $1

      # clean enviroment
      unset CMD
      unset RAILS_ROOT
      unset RAILS_ENV
      unset UNICORN_CMD
      unset UNICORN_CONFIG
      unset UNICORN_LOG
      unset UNICORN_PID
      unset UNICORN_SOCKET
      unset UNICORN_USER
      unset UNICORN_RESTART_SLEEP
    done
   fi
}

ARGS="$1 $2"
start_stop $ARGS
