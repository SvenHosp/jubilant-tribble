#!/bin/bash

PURRING_TRIBBLE_CONDA_ENV_NAME=purring_tribble_jupyterlab

# https://stackoverflow.com/questions/70597896/check-if-conda-env-exists-and-create-if-not-in-bash
find_in_conda_env(){
   conda env list | grep "${@}" >/dev/null 2>/dev/null
}

if [ ! -z $PURRING_TRIBBLE_HOME ]; then

    if find_in_conda_env "$PURRING_TRIBBLE_CONDA_ENV_NAME" ; then
        echo "The conda env exists. I only run pip install to update your library."
        conda run -n $PURRING_TRIBBLE_CONDA_ENV_NAME pip install -r requirements.txt
    else
        echo "The conda env $PURRING_TRIBBLE_CONDA_ENV_NAME doesn't exist. I'll create it."
        echo "I add the name of the jupyter conda env to  .zshrc."
        sed -i "" "s|PURRING_TRIBBLE_CONDA_ENV_NAME_VARIABLE|$PURRING_TRIBBLE_CONDA_ENV_NAME|g" $PURRING_TRIBBLE_HOME_APPLICATION/run_tribble.sh
        conda create -n $PURRING_TRIBBLE_CONDA_ENV_NAME python=3.11 pip
        echo "I install jupyterlab libraries."
        conda run -n $PURRING_TRIBBLE_CONDA_ENV_NAME pip install  -r requirements.txt
    fi

    echo "Begin copying scripts to PURRING_TRIBBLE_HOME_JUPYTER."
    cp start_tribble_jupyter.sh $PURRING_TRIBBLE_HOME_JUPYTER/start_tribble_jupyter.sh
    cp analyse_time_span.sh $PURRING_TRIBBLE_HOME_JUPYTER/analyse_time_span.sh
    
    mkdir -p $PURRING_TRIBBLE_WORKSPACES
    cp workspaces/* $PURRING_TRIBBLE_WORKSPACES/

    sed -i "" "s|<TRIBBLE_MAIN_PATH>|$PURRING_TRIBBLE_WORKBENCH|g" ${PURRING_TRIBBLE_WORKSPACES}/tribble.json

    cp tribble_status.ipynb $PURRING_TRIBBLE_HOME_JUPYTER
    cp tribble.ipynb $PURRING_TRIBBLE_HOME_JUPYTER
    cp tribble_helper.ipynb $PURRING_TRIBBLE_HOME_JUPYTER

else
    echo "Environment Variable PURRING_TRIBBLE_HOME is not set. Please install purring tribble before!"
fi
