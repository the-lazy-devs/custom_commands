.custom_commands
================
This project is where I keep some of my custom commands.  They're shortcuts for many of the bash command line commands that I use frequently.

Usage
-------------------
The project adds aliases to be sourced and updates the path in a file loaded by your shell.
This file is `~/.bash_profile` by default.

If you're using bash and you would like this file updated, run `./initialize.sh`.
If you're using zsh, you should run `./initialize.sh ~/.zshrc`.

Script will ensure that no changes are made to files unless required.
![execution output](https://cloud.githubusercontent.com/assets/911203/19718088/7665f90c-9b81-11e6-8fd8-3fbd815e583b.png)
