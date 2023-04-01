#!/bin/bash

echo "Warm welcome to jubilant-tribble."

# https://stackoverflow.com/questions/2642585/read-a-variable-in-bash-with-a-default-value
read -p "Please enter the installation directory path [~/.tribble]:" USER_INPUT_INSTALL_DIRECTORY
USER_INPUT_INSTALL_DIRECTORY=${USER_INPUT_INSTALL_DIRECTORY:-~/.tribble}

echo "Now, I copy my shell scripts to the directory you have entered: $USER_INPUT_INSTALL_DIRECTORY"

export JUBILANT_TRIBBLE_HOME="$USER_INPUT_INSTALL_DIRECTORY"
MACOS_LOCAL_LAUNCHD="~/Library/LaunchAgents"

if [ ! -d "$JUBILANT_TRIBBLE_HOME/tmp/" ]; then
    mkdir -p $JUBILANT_TRIBBLE_HOME/tmp/
fi
if [ ! -d "$JUBILANT_TRIBBLE_HOME/logs/" ]; then
    mkdir -p $JUBILANT_TRIBBLE_HOME/logs/
fi


cp clear_database.sh $JUBILANT_TRIBBLE_HOME
cp clock.sh $JUBILANT_TRIBBLE_HOME
cp public_holidays.json $JUBILANT_TRIBBLE_HOME
cp special_days_template.json $JUBILANT_TRIBBLE_HOME/special_days_template.json

#cp template_jubilant_tribble.plist $JUBILANT_TRIBBLE_HOME/tmp/

#sed -i "" "s|{tribble_install_path}|$JUBILANT_TRIBBLE_HOME/tribble_loop.sh|g" ${JUBILANT_TRIBBLE_HOME}/tmp/template_jubilant_tribble.plist

# move .plist file to $MACOS_LOCAL_LAUNCHD and rename it to com.$USER.jubilant_tribble.plist
# activate in launchd using launchctl load com.$USER.jubilant_tribble.plist

BACKUP_NAME="backup_$(date +"%Y%m%d%H%M%S")"

echo "Now, I add the path to the scripts to your local .zshrc. Before I do this do a backup of your config: .zshrc_$BACKUP_NAME"

cp ~/.zshrc ~/.zshrc_$BACKUP_NAME

! grep "export JUBILANT_TRIBBLE_HOME=$JUBILANT_TRIBBLE_HOME" ~/.zshrc && echo "export JUBILANT_TRIBBLE_HOME=$JUBILANT_TRIBBLE_HOME" >> ~/.zshrc
! grep "export JUBILANT_TRIBBLE_DATABASE=$JUBILANT_TRIBBLE_HOME" ~/.zshrc && echo "export JUBILANT_TRIBBLE_DATABASE=$JUBILANT_TRIBBLE_HOME/tribble.db" >> ~/.zshrc
! grep "export JUBILANT_TRIBBLE_HOLIDAYS=$JUBILANT_TRIBBLE_HOME" ~/.zshrc && echo "export JUBILANT_TRIBBLE_HOLIDAYS=$JUBILANT_TRIBBLE_HOME/public_holidays.json" >> ~/.zshrc

echo "Now, I add tribble alias to your shell ~/.zshrc to clock in or clock out manually: tribble_start"
! grep "alias tribble=" ~/.zshrc && echo 'alias tribble="$JUBILANT_TRIBBLE_HOME/clock.sh m"' >> ~/.zshrc

echo "Now, I create your database: $JUBILANT_TRIBBLE_HOME/tribble.db"

sqlite3 $JUBILANT_TRIBBLE_HOME/tribble.db <<'END_SQL'
.timeout 2000
CREATE TABLE IF NOT EXISTS worktime(timeslot_begin timestamp NOT NULL, timeslot_end timestamp, timeslot_finish boolean, t_id NUMERIC, symbol text, type text, comment text, timezone TEXT DEFAULT "+0000" NOT NULL);
END_SQL

echo "I finished my work! You can now use jubilant-tribble."