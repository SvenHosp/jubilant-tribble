#!/bin/bash
set -e

TYPE=$1
SYMBOL=$2
COMMENT=$3

TIMESTAMP=$(date -u +"%Y-%m-%d %T")

if [ -z "$TYPE" ]; then
    echo "[error, $TIMESTAMP, clock_in.sh] - missing type, exit unexpected!" >> $JUBILANT_TRIBBLE_HOME/logs/tribble.log
    exit -1
fi

if [ -z "$SYMBOL" ]; then
    echo "[error, $TIMESTAMP, clock_in.sh] - missing symbol, exit unexpected!" >> $JUBILANT_TRIBBLE_HOME/logs/tribble.log
    exit -1
fi

if [ -f "$JUBILANT_TRIBBLE_HOME/tmp/$SYMBOL.token" ]; then

CURRENT_TOKEN=$(cat $JUBILANT_TRIBBLE_HOME/tmp/$SYMBOL.token)
echo "[info, $TIMESTAMP, clock_out.sh] - clock out with token=$CURRENT_TOKEN" >> $JUBILANT_TRIBBLE_HOME/logs/tribble.log

rm $JUBILANT_TRIBBLE_HOME/tmp/$SYMBOL.token

sqlite3 $JUBILANT_TRIBBLE_HOME/tribble.db <<END_SQL
.timeout 2000
UPDATE worktime SET timeslot_end = '$TIMESTAMP', timeslot_finish = TRUE WHERE t_id == '$CURRENT_TOKEN';
END_SQL

echo "[info, $TIMESTAMP, clock_out.sh] - clock entry updated in database for token=$CURRENT_TOKEN." >> $JUBILANT_TRIBBLE_HOME/logs/tribble.log

else

TOKEN=$(date +%s)

echo "$TOKEN" >> $JUBILANT_TRIBBLE_HOME/tmp/$SYMBOL.token

echo "[info, $TIMESTAMP, clock_in.sh] - create $SYMBOL.token with token=$TOKEN." >> $JUBILANT_TRIBBLE_HOME/logs/tribble.log

sqlite3 $JUBILANT_TRIBBLE_HOME/tribble.db <<END_SQL
.timeout 2000
INSERT INTO worktime (t_id, timeslot_begin, timeslot_finish, type, symbol, comment) VALUES ($TOKEN, '$TIMESTAMP', False, '$TYPE', '$SYMBOL', '$COMMENT');
END_SQL

echo "[info, $TIMESTAMP, clock_in.sh] - clock entry created in database for token=$TOKEN." >> $JUBILANT_TRIBBLE_HOME/logs/tribble.log

fi

