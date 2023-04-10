#!/bin/bash

if [ -z $PURRING_TRIBBLE_CONDA_ENV_NAME ]; then
    echo "Environment Variable PURRING_TRIBBLE_HOME is not set. Please install juilant tribble before!"
    exit -1
fi

if [ -z $PURRING_TRIBBLE_CONDA_ENV_NAME ]; then
    echo "Environment Variable TRIBBLE_CONDA_ENV_NAME is not set. Please install jupyterlab_ui before!"
    exit -1
fi

mkdir -p $PURRING_TRIBBLE_WORKBENCH
cd $PURRING_TRIBBLE_WORKBENCH
cp $PURRING_TRIBBLE_HOME_JUPYTER/tribble.ipynb $PURRING_TRIBBLE_WORKBENCH
cp $PURRING_TRIBBLE_HOME_JUPYTER/tribble_status.ipynb $PURRING_TRIBBLE_WORKBENCH

if [ ! -f "$PURRING_TRIBBLE_WORKBENCH/special_days.json" ]; then
    cp $PURRING_TRIBBLE_HOME_APPLICATION/special_days_template.json $PURRING_TRIBBLE_WORKBENCH/special_days.json
fi

conda run -n $PURRING_TRIBBLE_CONDA_ENV_NAME python -m jupyter lab workspaces import $PURRING_TRIBBLE_WORKSPACES/tribble.json
conda run -n $PURRING_TRIBBLE_CONDA_ENV_NAME python -m jupyter lab --port=8081 --LabApp.default_url='/lab/workspaces/tribble' > $PURRING_TRIBBLE_HOME_LOGS/jupyter_ui.log
