#!/bin/bash
set -e

TYPE=$1
SYMBOL=$2
COMMENT=$3

TIMESTAMP=$(date +"%d-%m-%Y %T %z")

if [ -z "$TYPE" ]; then
    echo "[error, $TIMESTAMP, clock_out.sh] - missing type, exit unexpected!" >> $JUBILANT_TRIBBLE_HOME/logs/tribble.log
    exit -1
fi

if [ -z "$SYMBOL" ]; then
    echo "[error, $TIMESTAMP, clock_out.sh] - missing symbol, exit unexpected!" >> $JUBILANT_TRIBBLE_HOME/logs/tribble.log
    exit -1
fi

if [ -f "$JUBILANT_TRIBBLE_HOME/tmp/$SYMBOL.token" ]; then

CURRENT_TOKEN=$(cat $JUBILANT_TRIBBLE_HOME/tmp/$SYMBOL.token)
echo "[info, $TIMESTAMP, clock_out.sh] - clock out with token=$CURRENT_TOKEN" >> $JUBILANT_TRIBBLE_HOME/logs/tribble.log

rm $JUBILANT_TRIBBLE_HOME/tmp/$SYMBOL.token

sqlite3 $JUBILANT_TRIBBLE_HOME/tribble.db <<END_SQL
.timeout 2000
INSERT INTO worktime (t_id, timeslot, timeslot_begin, type, symbol, comment) VALUES ($CURRENT_TOKEN, '$TIMESTAMP', FALSE, '$TYPE', '$SYMBOL', '$COMMENT');
END_SQL

echo "[info, $TIMESTAMP, clock_out.sh] - clock entry created in database for token=$TOKEN." >> $JUBILANT_TRIBBLE_HOME/logs/tribble.log
else
    echo "[error, $TIMESTAMP, clock_out.sh] - No $SYMBOL.token file found, have you run clock_in before? Exit unexpected!" >> $JUBILANT_TRIBBLE_HOME/logs/tribble.log
    exit -1
fi
