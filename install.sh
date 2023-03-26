#!/bin/bash

export WORKDIR_DB_PATH="/Users/familie/Documents/workspace/worktime/worktime.db"
echo 'export WORKDIR_DB_PATH="/Users/familie/Documents/workspace/worktime/worktime.db"' >> ~/.zshrc

sqlite3 $WORKDIR_DB_PATH <<'END_SQL'
.timeout 2000
CREATE TABLE IF NOT EXISTS worktime(timeslot timestamp NOT NULL, timeslot_begin boolean, symbol character varying(10), comment text);
END_SQL