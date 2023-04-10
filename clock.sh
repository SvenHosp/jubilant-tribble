#!/bin/bash
set -e

TYPE=$1
SYMBOL=$2
COMMENT=$3

TIMESTAMP=$(date -u +"%Y-%m-%d %T")

if [ -z "$TYPE" ]; then
    echo "[error, $TIMESTAMP, clock_in.sh] - missing type, exit unexpected!" >> $PURRING_TRIBBLE_HOME_LOGS/tribble.log
    exit -1
fi

if [ -z "$SYMBOL" ]; then
    echo "[error, $TIMESTAMP, clock_in.sh] - missing symbol, exit unexpected!" >> $PURRING_TRIBBLE_HOME_LOGS/tribble.log
    exit -1
fi

if [ -f "$PURRING_TRIBBLE_HOME_TMP/$SYMBOL.token" ]; then

CURRENT_TOKEN=$(cat $PURRING_TRIBBLE_HOME_TMP/$SYMBOL.token)
echo "[info, $TIMESTAMP, clock_out.sh] - clock out with token=$CURRENT_TOKEN" >> $PURRING_TRIBBLE_HOME_LOGS/tribble.log

rm $PURRING_TRIBBLE_HOME_TMP/$SYMBOL.token

sqlite3 $PURRING_TRIBBLE_DATABASE <<END_SQL
.timeout 2000
UPDATE worktime SET timeslot_end = '$TIMESTAMP', timeslot_finish = TRUE WHERE t_id == '$CURRENT_TOKEN';
END_SQL

echo "[info, $TIMESTAMP, clock_out.sh] - clock entry updated in database for token=$CURRENT_TOKEN." >> $PURRING_TRIBBLE_HOME_LOGS/tribble.log

else

TOKEN=$(date +%s)

echo "$TOKEN" >> $PURRING_TRIBBLE_HOME_TMP/$SYMBOL.token

echo "[info, $TIMESTAMP, clock_in.sh] - create $SYMBOL.token with token=$TOKEN." >> $PURRING_TRIBBLE_HOME_LOGS/tribble.log

sqlite3 $PURRING_TRIBBLE_DATABASE <<END_SQL
.timeout 2000
INSERT INTO worktime (t_id, timeslot_begin, timeslot_finish, type, symbol, comment) VALUES ($TOKEN, '$TIMESTAMP', False, '$TYPE', '$SYMBOL', '$COMMENT');
END_SQL

echo "[info, $TIMESTAMP, clock_in.sh] - clock entry created in database for token=$TOKEN." >> $PURRING_TRIBBLE_HOME_LOGS/tribble.log

fi

