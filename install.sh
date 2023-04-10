#!/bin/bash

echo "Warm welcome to purring-tribble."

# https://stackoverflow.com/questions/2642585/read-a-variable-in-bash-with-a-default-value
read -p "Please enter the installation directory path [~/tribble]:" USER_INPUT_INSTALL_DIRECTORY
USER_INPUT_INSTALL_DIRECTORY=${USER_INPUT_INSTALL_DIRECTORY:-~/tribble}

echo "Now, I copy my shell scripts to the directory you have entered: $USER_INPUT_INSTALL_DIRECTORY"

export PURRING_TRIBBLE_HOME="$USER_INPUT_INSTALL_DIRECTORY"
export PURRING_TRIBBLE_HOME_APPLICATION="$PURRING_TRIBBLE_HOME/application"
export PURRING_TRIBBLE_HOME_JUPYTER="$PURRING_TRIBBLE_HOME/jupyter"
export PURRING_TRIBBLE_HOME_UI="$PURRING_TRIBBLE_HOME/ui"
export PURRING_TRIBBLE_HOME_TMP="$PURRING_TRIBBLE_HOME/tmp"
export PURRING_TRIBBLE_HOME_LOGS="$PURRING_TRIBBLE_HOME/logs"

if [ ! -d "$PURRING_TRIBBLE_HOME_TMP" ]; then
    mkdir -p $PURRING_TRIBBLE_HOME_TMP
fi
if [ ! -d "$PURRING_TRIBBLE_HOME_LOGS" ]; then
    mkdir -p $PURRING_TRIBBLE_HOME_LOGS
fi
if [ ! -d "$PURRING_TRIBBLE_HOME_UI" ]; then
    mkdir -p $PURRING_TRIBBLE_HOME_UI
fi
if [ ! -d "$PURRING_TRIBBLE_HOME_APPLICATION" ]; then
    mkdir -p $PURRING_TRIBBLE_HOME_APPLICATION
fi
if [ ! -d "$PURRING_TRIBBLE_HOME_JUPYTER" ]; then
    mkdir -p $PURRING_TRIBBLE_HOME_JUPYTER
fi

cp clock.sh $PURRING_TRIBBLE_HOME_APPLICATION
cp public_holidays.json $PURRING_TRIBBLE_HOME_APPLICATION
cp special_days_template.json $PURRING_TRIBBLE_HOME_APPLICATION/special_days_template.json
cp run_tribble.sh $PURRING_TRIBBLE_HOME_APPLICATION
cp config.json $PURRING_TRIBBLE_HOME_APPLICATION

sed -i "" "s|PURRING_TRIBBLE_HOME_VARIABLE|$PURRING_TRIBBLE_HOME|g" $PURRING_TRIBBLE_HOME_APPLICATION/run_tribble.sh

BACKUP_NAME="backup_$(date +"%Y%m%d%H%M%S")"

! grep "source $PURRING_TRIBBLE_HOME_APPLICATION/run_tribble.sh" ~/.zshrc && \
BACKUP_NAME="backup_$(date +"%Y%m%d%H%M%S")" \
echo "Now, I add the path to the scripts to your local .zshrc. Before I do this do a backup of your config: .zshrc_$BACKUP_NAME" && \
cp ~/.zshrc ~/.zshrc_$BACKUP_NAME && \
echo "source $PURRING_TRIBBLE_HOME_APPLICATION/run_tribble.sh" >> ~/.zshrc

echo "Now, I create your database: $PURRING_TRIBBLE_HOME/tribble.db"

sqlite3 $PURRING_TRIBBLE_HOME_APPLICATION/tribble.db <<'END_SQL'
.timeout 2000
CREATE TABLE IF NOT EXISTS worktime(timeslot_begin timestamp NOT NULL, timeslot_end timestamp, timeslot_finish boolean, t_id NUMERIC, symbol text, type text, comment text, timezone TEXT DEFAULT "+0000" NOT NULL);
END_SQL

read -p "Do you want to install jupyterlab to analyse your data? [yes/no, default is yes]:" USER_INPUT_INSTALL_JUPYTER
USER_INPUT_INSTALL_JUPYTER=${USER_INPUT_INSTALL_JUPYTER:-yes}

if [ "$USER_INPUT_INSTALL_JUPYTER" = "yes" ]; then
    cd jupyterlab_ui
    zsh install_jupyterlab_conda.sh
    cd ..
fi

read -p "Do you want to install tribble ui? [yes/no, default is yes]:" USER_INPUT_INSTALL_UI
USER_INPUT_INSTALL_UI=${USER_INPUT_INSTALL_UI:-yes}

if [ "$USER_INPUT_INSTALL_UI" = "yes" ]; then
    mkdir -p $PURRING_TRIBBLE_HOME_UI
    cp -r electron_ui/ $PURRING_TRIBBLE_HOME_UI
    current_dir=$(pwd)
    cd $PURRING_TRIBBLE_HOME_UI
    npm install
    cd $current_dir
fi

echo "I finished my work! You can now use purring-tribble."