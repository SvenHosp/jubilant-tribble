#!/bin/bash

TIME_SPAN_BEGIN=$1
TIME_SPAN_END=$2

TIMESTAMP=$(date -u +"%Y-%m-%d %T")

if [ -z "$TIME_SPAN_BEGIN" ]; then
    echo "[error, $TIMESTAMP, analyse_time_span.sh] - missing TIME_SPAN_BEGIN, exit unexpected!" >> $PURRING_TRIBBLE_HOME_LOGS/tribble.log
    exit -1
fi

if [ -z "$TIME_SPAN_END" ]; then
    echo "[error, $TIMESTAMP, analyse_time_span.sh] - missing TIME_SPAN_END, exit unexpected!" >> $PURRING_TRIBBLE_HOME_LOGS/tribble.log
    exit -1
fi

if [ -z $PURRING_TRIBBLE_HOME ]; then
    echo "[error, $TIMESTAMP, analyse_time_span.sh] - missing environment variable PURRING_TRIBBLE_HOME, exit unexpected!" >> $PURRING_TRIBBLE_HOME_LOGS/tribble.log
    exit -1
fi

if [ -z $PURRING_TRIBBLE_CONDA_ENV_NAME ]; then
    echo "[error, $TIMESTAMP, analyse_time_span.sh] - missing environment variable PURRING_TRIBBLE_CONDA_ENV_NAME, exit unexpected!" >> $PURRING_TRIBBLE_HOME_LOGS/tribble.log
    exit -1
fi

cp $PURRING_TRIBBLE_HOME_JUPYTER/tribble.ipynb $PURRING_TRIBBLE_HOME_TMP

sed -i "" "s|<TIMESPAN_BEGIN>|$TIME_SPAN_BEGIN|g" $PURRING_TRIBBLE_HOME_TMP/tribble.ipynb
sed -i "" "s|<TIMESPAN_END>|$TIME_SPAN_END|g" $PURRING_TRIBBLE_HOME_TMP/tribble.ipynb

conda run -n $PURRING_TRIBBLE_CONDA_ENV_NAME python -m  jupyter nbconvert --to html --no-input --execute $PURRING_TRIBBLE_HOME_TMP/tribble.ipynb
