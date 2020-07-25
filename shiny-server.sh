#!/bin/sh

# Make sure the directory for individual app logs exists
mkdir -p /var/log/supervisord/shiny-server
chown shiny.shiny /var/log/supervisord/shiny-server
chown shiny.shiny /var/log/shiny-server

if [ "$APPLICATION_LOGS_TO_STDOUT" != "false" ];
then
    # push the "real" application logs to stdout with xtail in detached mode
    exec xtail /var/log/supervisord/shiny-server &
fi

# start shiny server
exec /usr/bin/shiny-server 2>&1