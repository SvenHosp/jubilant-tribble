#!/bin/bash

sqlite3 $JUBILIANT_TRIBBLE_HOME/tribble.db <<'END_SQL'
.timeout 2000
DELETE from worktime;
VACUUM;
END_SQL