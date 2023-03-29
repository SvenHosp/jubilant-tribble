#!/bin/bash

onLogout() {
    echo 'Logging out' >> ~/Logs/logout.sh.log
    exit
}
mkdir ~/Logs
trap 'onLogout' SIGINT SIGHUP SIGTERM
while true; do
    sleep 86400 &
    wait $!
done

# get unix timestamp store it to database, hold it in memory, every minute update database entry, update ends when script ends