#!/bin/bash
set -e

TYPE=$1
SYMBOL=$2
COMMENT=$3

TIMESTAMP=$(date +"%d-%m-%Y %T %z")

if [ -z "$TYPE" ]; then
    echo "[error, $TIMESTAMP, clock_in.sh] - missing type, exit unexpected!" >> $JUBILANT_TRIBBLE_HOME/logs/tribble.log
    exit -1
fi

if [ -z "$SYMBOL" ]; then
    echo "[error, $TIMESTAMP, clock_in.sh] - missing symbol, exit unexpected!" >> $JUBILANT_TRIBBLE_HOME/logs/tribble.log
    exit -1
fi

if [ -f "$JUBILANT_TRIBBLE_HOME/tmp/$SYMBOL.token" ]; then
    echo "[error, $TIMESTAMP, clock_in.sh] - $SYMBOL.token exists, please clock out before clock in. Exit unexpected!" >> $JUBILANT_TRIBBLE_HOME/logs/tribble.log
    exit -1
fi

TOKEN=$(date +%s)

echo "$TOKEN" >> $JUBILANT_TRIBBLE_HOME/tmp/$SYMBOL.token

echo "[info, $TIMESTAMP, clock_in.sh] - create $SYMBOL.token with token=$TOKEN." >> $JUBILANT_TRIBBLE_HOME/logs/tribble.log

sqlite3 $JUBILANT_TRIBBLE_HOME/tribble.db <<END_SQL
.timeout 2000
INSERT INTO worktime (t_id, timeslot, timeslot_begin, type, symbol, comment) VALUES ($TOKEN, '$TIMESTAMP', TRUE, '$TYPE', '$SYMBOL', '$COMMENT');
END_SQL

echo "[info, $TIMESTAMP, clock_in.sh] - clock entry created in database for token=$TOKEN." >> $JUBILANT_TRIBBLE_HOME/logs/tribble.log