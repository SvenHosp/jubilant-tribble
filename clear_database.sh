#!/bin/bash

sqlite3 $WORKDIR_DB_PATH <<'END_SQL'
.timeout 2000
DELETE from worktime;
VACUUM;
END_SQL