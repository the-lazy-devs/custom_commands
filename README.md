**Note:**
This README is probably out of date and inaccurate.  

custom_commands
================
This project will create a `~/.ccsl` directory, if it doesn't already exist.  
It will then add some symlinks to that directory for each of the custom scripts specified.  
It will update the PATH variable in the file(s) loaded by your shell (by default, the `~/.bash_profile` and `~/.bashrc` files).  
It will also add alias files to be sourced those same rc files


Installation
-------------------
clone this repository

Usage
-------------------
For help or to see the availble flags, run `./create_custom_commands.sh -h`  
To run the script in dry-run mode, without changes to your system, run `./create_custom_commands.sh -d`  

To create symlinks to your custom scripts, use the `-s` flag and specify the directory containing your favorite scripts.  
For example: `./create_custom_commands.sh -s ~/myScripts`

If you're using zsh, you should include either the `-p` or `-r` flags.  
For example:  
`./create_custom_commands.sh -p ~/.zshrc`  
or  
`./create_custom_commands.sh -r ~/.zshrc`


Removal
-------------------

The following are the instructions for bash. If you installed the commands and aliases into different files, update the commands accordingly.

1. Remove the `~/.ccsl` directory
1. Remove the PATH export from your shell startup file (`~/.bashrc` or `~/.bash_profile` by default)
