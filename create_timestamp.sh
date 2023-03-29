#!/bin/bash

if [ "$1" = "start" ]; then
sqlite3 $JUBILANT_TRIBBLE_HOME/tribble.db <<END_SQL
.timeout 2000
INSERT INTO worktime (timeslot, timeslot_begin, symbol, type) VALUES (CURRENT_TIMESTAMP, TRUE, 'N', '$2');
END_SQL
elif [ "$1" = "end" ]; then
sqlite3 $JUBILANT_TRIBBLE_HOME/tribble.db <<END_SQL
.timeout 2000
INSERT INTO worktime (timeslot, timeslot_begin, symbol, type) VALUES (CURRENT_TIMESTAMP, FALSE, 'N', '$2');
END_SQL
fi
