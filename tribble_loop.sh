#!/bin/bash

TIMESTAMP_UNIX=$(date +%s)

sqlite3 $JUBILANT_TRIBBLE_HOME/tribble.db <<END_SQL
.timeout 2000
INSERT INTO worktime (timeslot, timeslot_begin, symbol, type) VALUES (CURRENT_TIMESTAMP, TRUE, 'N', 'A');
END_SQL

sqlite3 $JUBILANT_TRIBBLE_HOME/tribble.db <<END_SQL
.timeout 2000
INSERT INTO worktime (t_id, timeslot, timeslot_begin, symbol, type) VALUES ($TIMESTAMP_UNIX, CURRENT_TIMESTAMP, FALSE, 'N', 'A');
END_SQL

onLogout() {
sqlite3 $JUBILANT_TRIBBLE_HOME/tribble.db <<END_SQL
.timeout 2000
UPDATE worktime
SET timeslot = CURRENT_TIMESTAMP
WHERE
t_id = $TIMESTAMP_UNIX;
END_SQL
exit
}

trap 'onLogout' SIGINT SIGHUP SIGTERM
while true; do
sleep 60
sqlite3 $JUBILANT_TRIBBLE_HOME/tribble.db <<END_SQL
.timeout 2000
UPDATE worktime
SET timeslot = CURRENT_TIMESTAMP
WHERE
t_id = $TIMESTAMP_UNIX;
END_SQL
done

# get unix timestamp store it to database, hold it in memory, every minute update database entry, update ends when script ends