This is how I use this repository.  
It works for me.  
You are encouraged to use it in a way that works for *you*.  
-- spargonaut

------
tl;dr  
.custom_commands will create a directory to hold symlinks, add that directory to your path variable, and create symlinks in that directory which point to your own custom scripts.  It makes them available to you on your CLI as the name of the script without the suffix ```.sh```  
checkout the initialize.sh script to get started

-----

### Example

On each of my workstations, I have cloned this repository.  
```  
git clone https://github.com/the-lazy-devs/.custom_commands.git
```  

On each workstation, I also have at least one other repository, each containing shortcut scripts.  
my generic, public scripts can be found at https://github.com/spargonaut/myScripts  
```  
git clone https://github.com/spargonaut/myScripts  
```  
for the sake of this write up, lets say I cloned both repositories to my home directory,  
so when I do an ```ls -a```, I get something like this....   
```  
.  
..  
.custom_commands  
myScripts  
```  

To create my symlinks, I usually follow this process:  
- navigate to the .custom_commands directory...   
```  
cd ~/.custom_commands  
```  

I'll execute the 'initialize.sh' script in dry-run mode, so I can see what its doing.  
I need to set a couple of flags on the command to do this.  
I use '-s <path_name>' to point to my custom scripts  
and I use '-d' to execute it in dry-run mode  
(its got some *really* nice output, thanks to @javatarz)  

The whole command ends up looking something like this...  
```  
./initialize -s ~/myScripts/ -d  
```  

I'll read over everything its doing, and if everything looks ok, I'll remove the dry-run flag and execute it again.  
```  
./initialize -s ~/myScripts/  
```  

This gives me access to my scripts, as shortcuts, just like they were common commands found on my cli.  
If I had another directory of scripts, lets say they reside in a directory called 'yourScripts'  
I would then use the command...  
```
./initialize -s ~/yourScripts/  
```  
this would give me access to the scripts in both myScripts, and yourScipts as normal cli commands  


As time goes on, when I find myself frequently typing a command with lots of flags and parameters, over and over and over again, I'll usually put it into a script, and add it to the myScripts repository (or the equivalent)
Since I'm frequently working for various clients, none of whom what to share their IP, I've been keeping private repositories with scripts for operating on their proprietary software (build commands, proxies and networks, etc) and store that repository somewhere on their private internal repositories.  


question:  what happens when one of your commands conflicts with the system commands?  
answer:  as of this writing, it shouldn't do anything.  the .bin directory (where the symlinks are kept), are later in the path variable, giving system commands priority (i.e. the shortcut for your script won't work :bummerforyou:)  

question: what happens if I have scripts of the same name in separate script repositories?  
answer:  thats a good question.  try that and let me know how it works for you.  K and I have discussed that issue briefly, but we haven't really done anything about it.  

question:  what happens if I delete a script from the myScripts directory?  
answer:  thats another great question.  I'm betting you'll get a 'command not found' error, even though the symlink still exists.  This is an enhancement that will soon be implemented.  
