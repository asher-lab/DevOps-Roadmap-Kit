BEST VIEW RAW UNLTIL EDITED <br>

Chapter 3
a. Working with the Shell <br>
  i. Talking to the Interpreter with the sys module <br>
  ii. Dealing with the Operating System using the os Module
  iii. Spawn Processes with the subprocess Module
b. Creating Command-line tools
  i. Using sys.argv
  ii. using argparse
  iii. Using clikc
  iv. fire
  v. Implementing Plugins
C. Case Study: Turbocharging Python with the Command Line tools
  i. Using the numba just in time compiler (JIT) Compiler
  ii. Using the GPU with CUDA Python
  iii. Running True Multicore Multithreaded Python Using Numba
  iv. KMeans Clustering
  v. Exercises
  
  ----
  i. Talking to the intepreter with the sys module
  
  Python offers tools for interacting with systems and shells. You
should become familiar with the sys, os, and subprocess
modules, as all are essential tools.
Important keys: sys, os, subprocess

Sys module, offers access to variables and methods closely tied to the Python Interpreter
``` 
#will output the byte order of the current architecture
import sys
sys.byteorder
```
What is byte order?
It is the Endian check [https://en.wikipedia.org/wiki/Endianness]
In computing, endianness is the order or sequence of bytes of a word of digital data in computer memory. Endianness is primarily expressed as big-endian (BE) or little-endian (LE). A big-endian system stores the most significant byte of a word at the smallest memory address and the least significant byte at the largest. A little-endian system, in contrast, stores the least-significant byte at the smallest address. Endianness may also be used to describe the order in which the bits are transmitted over a communication channel, e.g., big-endian in a communications channel transmits the most significant bits first.[1] Bit-endianness is seldom used in other contexts.

```
#will output the size of my python object
sys.getsizeof(1)
#will outout the platform
sys.platform
#will output system version info
sys.version_info.major
sys.version_info.minor
```
----
ii. Dealing with the Operating System using the os module
```
import os
# get current working directory
os.getcwd()
# change the current working directory
os.chdir('/src')
# the os.environ holds the environment variables that were set when the OS modules was loaded
os.environ.get('LOGLEVEL')
# This is the setting and environment variable. This setting exists
for subprocesses spawned from this code.
os.environ['LOGLEVEL'] = 'DEBUG'
os.environ('DEBUG')
#This is the login of the user in the terminal that spawned this
process
os.getlogin()
```
----
Spawn processes with the subprocess module
There are many instances when you need to run applications outside
of Python from within your Python code. This could be built-in shell
commands, Bash scripts, or any other command-line application. To
do this, you spawn a new process (instance of the application). The
subprocess module is the right choice when you want to spawn a
process and run commands within it. With subprocess, you can
run your favorite shell command or other command-line software and
collect its output from within Python. For the majority of use cases,
you should use the subprocess.run function to spawn processes:

```
#tried to run this on windows but it show me some errors, tried using linux and is working
#https://www.blog.pythonlibrary.org/2020/06/30/python-101-launching-subprocesses-with-python/
cp = subprocess.run(['ls', '-l'], capture_output=True, universal_newlines=True)
cp.stdout
```
Subprocess are helpful if you want to run an application inside an application

----

































