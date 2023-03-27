#!/bin/bash

echo "Warm welcome to jubilant-tribble."

# https://stackoverflow.com/questions/2642585/read-a-variable-in-bash-with-a-default-value
read -p "Please enter the installation directory path [~/.tribble]:" USER_INPUT_INSTALL_DIRECTORY
USER_INPUT_INSTALL_DIRECTORY=${USER_INPUT_INSTALL_DIRECTORY:-~/.tribble}

if [ -z $JUBILANT_TRIBBLE_HOME ]; then
echo "Now, I copy my shell scripts to the directory you have entered: $USER_INPUT_INSTALL_DIRECTORY"

export JUBILANT_TRIBBLE_HOME="$USER_INPUT_INSTALL_DIRECTORY"
MACOS_LOCAL_LAUNCHD="~/Library/LaunchAgents"

mkdir -p $JUBILANT_TRIBBLE_HOME/tmp/
mkdir -p $JUBILANT_TRIBBLE_HOME/logs/

cp clear_database.sh $JUBILANT_TRIBBLE_HOME
cp create_timestamp.sh $JUBILANT_TRIBBLE_HOME

cp jubilant.tribble.plist $JUBILANT_TRIBBLE_HOME/tmp/

sed -i "" "s|{tribble_install_path}|$MACOS_LOCAL_LAUNCHD/jubilant.tribble.plist|g" ${JUBILANT_TRIBBLE_HOME}/tmp/jubilant.tribble.plist

echo "Now, I add the path to the scripts to your local .zshrc."

echo "export JUBILANT_TRIBBLE_HOME=$USER_INPUT_INSTALL_DIRECTORY" >> ~/.zshrc

echo "Now, I add tribble alias to your shell ~/.zshrc to clock in or clock out manually: tribble_start, tribble_end"
echo 'alias tribble_start="$JUBILANT_TRIBBLE_HOME/create_timestamp.sh start manual"' >> ~/.zshrc
echo 'alias tribble_end="$JUBILANT_TRIBBLE_HOME/create_timestamp.sh end manual"' >> ~/.zshrc

echo "Now, I add tribble alias to your shell ~/.zshrc to clock in or clock out with automatism: automatic_tribble_start, automatic_tribble_end"
echo 'alias automatic_tribble_start="$JUBILANT_TRIBBLE_HOME/create_timestamp.sh start"' >> ~/.zshrc
echo 'alias automatic_tribble_end="$JUBILANT_TRIBBLE_HOME/create_timestamp.sh end"' >> ~/.zshrc

echo "Now, I create your database: $JUBILANT_TRIBBLE_HOME/tribble.db"

sqlite3 $JUBILANT_TRIBBLE_HOME/tribble.db <<'END_SQL'
.timeout 2000
CREATE TABLE IF NOT EXISTS worktime(timeslot timestamp NOT NULL, timeslot_begin boolean, symbol character varying(10), comment text);
END_SQL

echo "I finished my work! You can now use jubilant-tribble."
else

echo "Variable JUBILANT_TRIBBLE_HOME is set to: $JUBILANT_TRIBBLE_HOME."

echo "jubilant-tribble appears to be installed. Better I do nothing."

fi