#!/bin/bash

TIME_SPAN_BEGIN=$1
TIME_SPAN_END=$2
EXPORT_PATH=$3

TIMESTAMP=$(date -u +"%Y-%m-%d %T")

if [ -z "$TIME_SPAN_BEGIN" ]; then
    echo "[error, $TIMESTAMP, calculate_working_hours.sh] - missing TIME_SPAN_BEGIN, exit unexpected!" >> $PURRING_TRIBBLE_HOME_LOGS/tribble.log
    exit -1
fi

if [ -z "$TIME_SPAN_END" ]; then
    echo "[error, $TIMESTAMP, calculate_working_hours.sh] - missing TIME_SPAN_END, exit unexpected!" >> $PURRING_TRIBBLE_HOME_LOGS/tribble.log
    exit -1
fi

if [ -z "$EXPORT_PATH" ]; then
    echo "[error, $TIMESTAMP, calculate_working_hours.sh] - missing EXPORT_PATH, exit unexpected!" >> $PURRING_TRIBBLE_HOME_LOGS/tribble.log
    exit -1
fi

if [ -z $PURRING_TRIBBLE_HOME ]; then
    echo "[error, $TIMESTAMP, calculate_working_hours.sh] - missing environment variable PURRING_TRIBBLE_HOME, exit unexpected!" >> $PURRING_TRIBBLE_HOME_LOGS/tribble.log
    exit -1
fi

if [ -z $PURRING_TRIBBLE_CONDA_ENV_NAME ]; then
    echo "[error, $TIMESTAMP, calculate_working_hours.sh] - missing environment variable PURRING_TRIBBLE_CONDA_ENV_NAME, exit unexpected!" >> $PURRING_TRIBBLE_HOME_LOGS/tribble.log
    exit -1
fi

cp $PURRING_TRIBBLE_HOME_JUPYTER/tribble_status.ipynb $PURRING_TRIBBLE_HOME_TMP

sed -i "" "s|<TIMESPAN_BEGIN>|$TIME_SPAN_BEGIN|g" $PURRING_TRIBBLE_HOME_TMP/tribble_status.ipynb
sed -i "" "s|<TIMESPAN_END>|$TIME_SPAN_END|g" $PURRING_TRIBBLE_HOME_TMP/tribble_status.ipynb
sed -i "" "s|<EXPORT_PATH>|$EXPORT_PATH|g" $PURRING_TRIBBLE_HOME_TMP/tribble_status.ipynb

conda run -n $PURRING_TRIBBLE_CONDA_ENV_NAME python -m  jupyter nbconvert --to notebook --execute $PURRING_TRIBBLE_HOME_TMP/tribble_status.ipynb
