#!/bin/bash

echo "Warm welcome to jubilant-tribble."

echo "Please enter the installation directory path:"

read USER_INPUT_INSTALL_DIRECTORY

echo "Now, I copy my shell scripts to the directory you have entered: $USER_INPUT_INSTALL_DIRECTORY"

cp clear_database.sh $USER_INPUT_INSTALL_DIRECTORY
cp create_timestamp.sh $USER_INPUT_INSTALL_DIRECTORY


echo "Now, I add the path to the scripts to your local .zshrc."
export JUBILIANT_TRIBBLE_HOME="$USER_INPUT_INSTALL_DIRECTORY"

echo "export JUBILIANT_TRIBBLE_HOME=$USER_INPUT_INSTALL_DIRECTORY" >> ~/.zshrc

echo "Add tribble alias to your shell: tribble_start, tribble_end"
echo "alias tribble_start=\"$USER_INPUT_INSTALL_DIRECTORY/create_timestamp.sh start\"" >> ~/.zshrc
echo "alias tribble_end=\"$USER_INPUT_INSTALL_DIRECTORY/create_timestamp.sh end\"" >> ~/.zshrc

echo "Now, I create your database: $JUBILIANT_TRIBBLE_HOME/tribble.db"

sqlite3 $JUBILIANT_TRIBBLE_HOME/tribble.db <<'END_SQL'
.timeout 2000
CREATE TABLE IF NOT EXISTS worktime(timeslot timestamp NOT NULL, timeslot_begin boolean, symbol character varying(10), comment text);
END_SQL