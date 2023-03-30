#!/bin/bash

if [ -z $JUBILANT_TRIBBLE_HOME ]; then
    echo "Environment Variable JUBILANT_TRIBBLE_HOME is not set. Please install juilant tribble before!"
    exit -1
fi

if [ -z $TRIBBLE_CONDA_ENV_NAME ]; then
    echo "Environment Variable TRIBBLE_CONDA_ENV_NAME is not set. Please install jupyterlab_ui before!"
    exit -1
fi

conda run -n $TRIBBLE_CONDA_ENV_NAME python -m jupyter lab --port=8081 > $JUBILANT_TRIBBLE_HOME/logs/jupyter_ui.log
