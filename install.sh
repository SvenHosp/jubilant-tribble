#!/bin/bash

echo "Warm welcome to jubilant-tribble."

echo "Please enter the installation directory path:"

read USER_INPUT_INSTALL_DIRECTORY

if [ -z $JUBILANT_TRIBBLE_HOME ]; then
echo "Now, I copy my shell scripts to the directory you have entered: $USER_INPUT_INSTALL_DIRECTORY"

cp clear_database.sh $USER_INPUT_INSTALL_DIRECTORY
cp create_timestamp.sh $USER_INPUT_INSTALL_DIRECTORY

echo "Now, I add the path to the scripts to your local .zshrc."
export JUBILANT_TRIBBLE_HOME="$USER_INPUT_INSTALL_DIRECTORY"

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