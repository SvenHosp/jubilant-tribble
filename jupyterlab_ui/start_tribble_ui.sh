#!/bin/bash

if [ -z $JUBILANT_TRIBBLE_HOME ]; then
    echo "Environment Variable JUBILANT_TRIBBLE_HOME is not set. Please install juilant tribble before!"
    exit -1
fi

if [ -z $TRIBBLE_CONDA_ENV_NAME ]; then
    echo "Environment Variable TRIBBLE_CONDA_ENV_NAME is not set. Please install jupyterlab_ui before!"
    exit -1
fi

mkdir -p $JUBILANT_TRIBBLE_HOME_UI
cd $JUBILANT_TRIBBLE_HOME_UI
cp $JUBILANT_TRIBBLE_HOME/tribble.ipynb $JUBILANT_TRIBBLE_HOME_UI
cp $JUBILANT_TRIBBLE_HOME/tribble_status.ipynb $JUBILANT_TRIBBLE_HOME_UI

if [ ! -f "$JUBILANT_TRIBBLE_HOME_UI/special_days.json" ]; then
    cp $JUBILANT_TRIBBLE_HOME/special_days_template.json $JUBILANT_TRIBBLE_HOME_UI/special_days.json
fi

conda run -n $TRIBBLE_CONDA_ENV_NAME python -m jupyter lab workspaces import $JUBILANT_TRIBBLE_HOME/workspaces/tribble.json
conda run -n $TRIBBLE_CONDA_ENV_NAME python -m jupyter lab --port=8081 --LabApp.default_url='/lab/workspaces/tribble' > $JUBILANT_TRIBBLE_HOME/logs/jupyter_ui.log
