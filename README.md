# Bash-Script-to-Manage-Process-Files
📖Bash script that controls the history of commands.

## Table of Contents

-   [Description](#description)
-   [Usage](#usage)
-   [Options](#options)
-   [Examples](#examples)
-   [License](#license)

## Description

`lastMeu.sh` is a Bash script that controls the history of commands. This script can be used to:

-   Show what commands a user has executed and when they started to run.
-   Show who has executed the introduced commands and when they started to run.
-   Show the commands of any user initiated on the requested date.
-   Show the commands that have the specified flag (S, F, D, X) activated.

This script traps SIGINT and SIGTERM signals, and shows a message indicating that their use is not allowed.

## Usage

`$ ./lastMeu.sh [-u usuario] [-c 'comanda1 comada2'...] [-d aammdd] [-f flag]` 

## Options

|Option  |Description  |
|--|--|
| `-u` | Show what commands a user has executed and when they started to run. |
| `-c` | Show who has executed the introduced commands and when they started to run. |
| `-d` | Show the commands of any user initiated on the requested date. |
|`-f` | Show the commands that have the specified flag (S, F, D, X) activated. |


## Examples

-   Show what commands a user has executed and when they started to run.

`$ ./lastMeu.sh -u usuario` 

-   Show who has executed the introduced commands and when they started to run.

shellCopy code

`$ ./lastMeu.sh -c 'comanda1 comada2'...` 

-   Show the commands of any user initiated on the requested date.

`$ ./lastMeu.sh -d aammdd` 

-   Show the commands that have the specified flag (S, F, D, X) activated.

`$ ./lastMeu.sh -f flag` 
