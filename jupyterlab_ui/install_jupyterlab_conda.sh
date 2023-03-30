#!/bin/bash

TRIBBLE_CONDA_ENV_NAME=jubilant_tribble_jupyterlab

# https://stackoverflow.com/questions/70597896/check-if-conda-env-exists-and-create-if-not-in-bash
find_in_conda_env(){
   conda env list | grep "${@}" >/dev/null 2>/dev/null
}

if [ ! -z $JUBILANT_TRIBBLE_HOME ]; then

    if find_in_conda_env "$TRIBBLE_CONDA_ENV_NAME" ; then
        echo "The conda env exists. I only run pip install to update your library."
        conda run -n $TRIBBLE_CONDA_ENV_NAME pip install -r requirements.txt
    else
        echo "The conda env $TRIBBLE_CONDA_ENV_NAME doesn't exist. I'll create it."
        echo "I add the name of the jupyter conda env to  .zshrc."
        ! grep "export TRIBBLE_CONDA_ENV_NAME=$TRIBBLE_CONDA_ENV_NAME" ~/.zshrc && echo "export TRIBBLE_CONDA_ENV_NAME=$TRIBBLE_CONDA_ENV_NAME" >> ~/.zshrc
        conda create -n $TRIBBLE_CONDA_ENV_NAME python=3.11 pip
        conda run -n $TRIBBLE_CONDA_ENV_NAME pip install  -r requirements.txt
    fi

    ! grep "alias tribble_ui=" ~/.zshrc && echo 'alias tribble_ui="$JUBILANT_TRIBBLE_HOME/start_tribble_ui.sh"' >> ~/.zshrc
    cp start_tribble_ui.sh $JUBILANT_TRIBBLE_HOME

else
    echo "Environment Variable JUBILANT_TRIBBLE_HOME is not set. Please install juilant tribble before!"
fi
