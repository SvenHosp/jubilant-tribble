# purring-tribble

Tool to record your working hours.

This is a tool developed in my free time and I give no warranties on the topicality, correctness, completeness or quality of this tool.

## Installation

You need to install following packages before:

- sqlite3, for example:

https://formulae.brew.sh/formula/sqlite

To install purring-tribble run in your shell

```shell
install.sh
```

and follow the instructions. I recommend to install at least the tribble ui, see section __install tribble ui?__ below and add the application as a shortcut, see section __Add Shortcuts__.

```shell
source ~/.zshrc
tribble
```

### Where to install tribble scripts?

Basically purring tribble is a toolbox and depends on bash scripts. Therefore you can install them anywhere you want.

### Install Jupyterlab?

The second question asks you to install jupyterlab. It installs a conda environment with jupyterlab, some other python libraries and installs some scripts to help you analyse your working time.

You need to install conda, for example using:

https://formulae.brew.sh/cask/miniconda

### install tribble ui?

The last question asks you to install tribble ui. It installs a small ui for comfort during clocking your working hours.

You need to install nvm, for example using:

https://formulae.brew.sh/formula/nvm

## Add Shortcuts

To make it simple to execute the shell commands you can add shortcuts to your menu bar for example.

### Common steps to add a shortcut

Go to shortcuts app, click on __+__ button (new shortcut), look for __execute shell script__, copy shell script from above to the edit field. With click on the information symbol (i) you can configure to pin your shortcut to menu bar for example.

## Tools to analyze your worktime

### Get hours worked per day and topic

During Installation, after choosing the jupyterlab option to yes, you can run

```shell
tribble_visualize "01.04.2023" "11.04.2023" "enter/your/path.html"
```

It analyse the given time span and reports it to html.

### Get hours worked per day

During Installation, after choosing the jupyterlab option to yes, you can run

```shell
tribble_hours "01.04.2023" "11.04.2023" "enter/your/path.csv"
```

It calculates worked hours and needed hours to be worked for a given time span. It takes public holidays, holidays and illness into account.

## Supported Environments

- MacOS:
  - shell: zsh

## Applications Architecture
