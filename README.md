# purring-tribble

Tool to record your working hours.

This is a tool developed in my free time and I give no warranties on the topicality, correctness, completeness or quality of this tool.

## Installation

You need to install sqlite3 before. For example:

https://formulae.brew.sh/formula/sqlite

To install jubilant-tribble run in your shell

```shell
install.sh
```

and follow the instructions. I recommend to install at least the tribble ui and add the application as a shortcut.

```shell
source ~/.zshrc
tribble
```

## Add Shortcuts

To make it simple to execute the shell commands you can add shortcuts to your menu bar for example.

### Common steps to add a shortcut

Go to shortcuts app, click on __+__ button (new shortcut), look for __execute shell script__, copy shell script from below to the edit field. With click on the information symbol (i) you can configure to pin your shortcut to menu bar for example.

### script to execute tribble start
```shell
source ~/.zshrc
tribble_start
```

### script to execute tribble end
```shell
source ~/.zshrc
tribble_end
```

## Supported Environments

- MacOS:
  - shell: zsh
