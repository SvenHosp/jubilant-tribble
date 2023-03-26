#!/bin/bash
if [ "$1" = "start" ]; then
sqlite3 $WORKDIR_DB_PATH <<'END_SQL'
.timeout 2000
INSERT INTO worktime (timeslot, timeslot_begin, symbol) VALUES (CURRENT_TIMESTAMP, TRUE, 'N');
END_SQL
elif [ "$1" = "end" ]; then
sqlite3 $WORKDIR_DB_PATH <<'END_SQL'
.timeout 2000
INSERT INTO worktime (timeslot, timeslot_begin, symbol) VALUES (CURRENT_TIMESTAMP, FALSE, 'N');
END_SQL
fi
