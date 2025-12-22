                   C P u m p

An Amiga Intuition-based C development environment.

© Copyright 1992, 1993, 1994, David A. Faught, All right reserved.
This program is provided "as is", no warranties are made.
All use is at your own risk. No liability or responsibility
is assumed.

Several other products are mentioned in this document. Each
trademark is owned by it's respective owner.

The right to freely distribute this program at no cost is
hereby granted, as long all files listed below are included
and all files included remain UNALTERED. These files may be
included in a collection of freely distributable software,
as long as the cost of that collection is previously deemed
reasonable by the author. Fred Fish is specifically given the
right to distribute these files.

The files included are:

-----rwed       1      961 Apr  4 21:42 CPump
-----rwed      18    18340 Apr  4 21:42 CPump17
-----rwed      26    26312 Apr  4 21:42 CPump17.c
-----rwed      17    16636 Apr  4 21:42 CTags
-----rwed      25    25179 Apr  4 21:42 CTags.c
-----rwed       9     8428 Apr  4 21:42 CTagSel
-----rwed       8     7290 Apr  4 21:42 CTagSel.c
-----rwed       1      505 Apr  4 21:42 EdErr.rexx
-----rwed       1      826 Apr  4 21:42 EdTag.rexx
-----rwed      13    13137 Apr  4 21:47 ReadMe.txt
Dirs:0    Files:10   Blocks:119   Bytes:117614
  
-----------------------------------------------------------

If you like this program, or would like to support my future
developments, please send a monetary or Amiga hardware gift
(not deductible) to:

    David Faught
    8701 North 64th Street
    Brown Deer, WI  53223

You will be added to my mailing list for a fee of $10
or more, and will be notified of my future developments.


This program requires AmigaDos 2.04 or better. It will not
function at all with 1.3.


I can also be contacted by email only (no files shipped please) at:
   akcs.dfaught@vpnet.chi.il.us

------------------------------------------------------------
Version 1.7, April 1994

Enhanced some utilities so that their output is redirected to a
temporary file that can be browsed.  Enhanced CTags so that it
accepts an Amiga wildcard pattern as the input file(s) and
Edtag.rexx to use this facility.  This will also work for ".cxx"
and ".cc" files.  Upgraded GCC support so that it works with
version 2.5.8 of C and C++.  Other little things here and there
that I have forgotten about.

Version 1.6, January 1993

Several enhancements including EdTag facility, better environment
variable handling, smaller CPump window to allow better view of
shell window being driven. Also added the Amiga "E" compiler for
the heck of it.

Version 1.5, January 1993

The Open and Save functions were fixed so that any number of
selected files will be copied. Also added the keyboard equivalents
for all the main functions and the ARexx Test tool.

Version 1.4, December 1992

The "CPump.env" environment variable was added to the CPump script
and to the main program to select initial settings for the four
cycle gadgets. These settings start with 0 (zero) and specify the
element of each of the four cycle gadgets to initially display.
The gcc (GNU C Compiler) and the Textra editor were added.
I think there were a few other minor things fixed too.

Version 1.3, August 1992

This is to fix a bug with the "initcc" script. This did not work
as distributed. Now you MUST edit the script file "CPump" for your
environment and execute it to start up the program. The "initcc"
script was replaced by this. It happens that this change actually
makes it easier to run CPump from the WorkBench than from the
shell.

Version 1.2, August 1992

I have added support for (old) version 4.0 of the SAS/Lattice
C compiler. This may work for newer versions, too.  I did this
mainly because I found it gathering dust in an old box of disks.

An icon and script for the AmigaDos IconX command now allow
CPump to be run from the WorkBench.

I have changed the "Utility" gadgets to be a single list-type
selector. Just click on the utility you want to use.

The zoom gadget in the upper right now "iconifies" the CPump
window.

Running all commands is now done using the new "System()" call
instead of the old "Execute()". This allows the proper return
code to be displayed.

Source code is now included. You may make modifications for
your own personal use only. The unregistered version of DICE
along with the NDU from CATS will work to compile this program.
I highly recommend registering DICE.

Various other minor modifications have been made.

Version 1.1

Not released.

Version 1.0

This little utility was born from my frustrations with
using the CLI for compiling and testing my C programs. Even
with the shell command history, it just seemed like too much
trouble to remember the right commands and options,
especially after one of my attempts would get the guru's boot
and a reboot.

This program is an easy to use shell that invokes a number
of other programs. These other programs are not included
here, but are easily accessible in collections of freely
distributable software for the Amiga. It is not necessary to
have ALL of the programs listed here. For example, there is
no real reason to use both the DICE and PDC compilers, but
one or the other is required.

If you have them, this program will make use of:
  ED & MEmacs text editors included with AmigaDos,
  Dillon's Integrated C Environment (DICE) - including the
    DME text editor and ANSI C compiler available on Fred
    Fish disk 491,
  Publicly Distributable C (PDC) - compiler and several
    utilities with complete source available on Fred Fish
    disk 351,
  MuchMore - text display program available on Fred Fish
    disk 560 (and several others in the :c directory),
  CRef - C cross reference lister available on Fred Fish
    disk 166,
  Indent - provides consistent indentation of C source
    available on Fred Fish disk 262.

It is also highly recommended that you get a copy of the
Native Developer Update (NDU) from Commodore Amiga Technical
Support (CATS) as it contains all the Amiga specific headers
needed to take advantage of the great Amiga features. It
also contains lots of examples, development tools,
debugging tools, and the AutoDocs. Information on how to
acquire the NDU is included with both PDC and DICE.


--------------------------------------------------------
INSTRUCTIONS:

This program can be used from the CLI or the Workbench. It
must be started using the CPump script. When started from the
Workbench, iconx is used to execute the CPump script.
Consider the CPump script included to be a starting point
that you should edit to reflect your own Amiga's environment.
In particular, the directory containing either the DICE or PDC
commands (or both) must be added to the command search path
using the "path add" command.

When you run this program, it presents a window with a bunch
of gadgets on it. These gadgets define the steps that I use
when developing a C program, along with the tools used at
each step and a few options. Down the left side of the window
are 6 pushbuttons which execute the 6 development steps.
Down the middle are some cycle gadgets which determine
the tool to be used for each step. In a line across the
middle are some boxes you can check to set certain options
for the Compile step.

Select the tools you wish to use by clicking on the cycle
gadgets on the right. You should probably do this first,
before you attempt to execute any of the 6 steps on the
left. Then, when you push any of the 6 pushbuttons to
execute a step, a filerequester will appear so that you can
select the file(s) you wish to use for that step.

Some steps allow multiple files to be selected, and other
steps only allow a single file. Sometimes, the filerequester
will have a pattern selector that filters the files you see
to include only those with certain suffixes. You can edit
this selection pattern on the filerequester, if you wish.

When you have selected the file(s) for that step, push the
"OK" button on the filerequester. The tool that you have
selected for that step will be executed with the file(s)
you have selected. Pretty simple, huh? You can also double-
click on a filename in the filerequester.

While the tool you have selected is executing, the Status
indicator in the upper right of the window will say
"Running". If no tool is executing, it will say "Waiting".

OPEN:
This step will copy all .c and .h files that you select
from where they are to the working directory. The working
directory is either RAM: or RAD: as selected by the cycle
gadget to the right. Note that this step also saves the
directory where the files originally were in the bottom
right string gadget, so that the files can be saved back
where they came from.

EDIT:
This step runs the text editor you have chosen with the .c
or .h file you select. Note that you can change the pattern
for selection or just type a specific file name, if you
wish. The editor is executed with the RUN command, so that
it has its own task and this program doesn't wait for it to
end. This allows the editor to stay on the screen while you
proceed to the other steps, or execute 2 or more editors at
the same time.

COMPILE:
This step executes the cc-like processor for the compiler
you have chosen. The check-box options just below this
gadget are interpreted properly for the chosen compiler.
The Verbose option affects not only the compile step, but
also allows you to see the commands that this program uses.

TEST:
This step is minimally implemented at this time. It will
execute the program you just compiled to try it out. I tend
to be a printf-in-the-source-code debugger, so I'm not very
familiar with some of the tools available.

UTILITY:
Several handy utilities can be executed from here. Most are
C language specific. Currently, all of these utilities will
print their output on the screen. In a future version of
this program, they will probably be redirected to create
output files instead, which can then be browsed.

SAVE:
This step will copy the file(s) you select back to the
directory that they came from. You can also directly edit
the target directory name to the right of this gadget. This
program will only remember the one most recent directory that
you "OPENed" a project from, so if you "OPEN" files from
several different directories, you will have to remember
where to put them back.

---------------------------------------------------------
NEW UTILITIES:

The CTags and CTagSel programs are now included (with source)
along with a couple of ARexx programs to interface them to
CPump. CTags is a (very slightly) modified version of the
program available on Fred Fish disk #197 by Ken Arnold, Jim
Kleckner, Bill Joy, and G. R. (Fred) Walter. The CTags program
builds a list of procedure names defined within a C source
program.

The EdTag.rexx drives this program to collect a list
of procedures in ALL the .c source programs in the working
directory and feeds this list to the CTagSel program. The CTagSel
program then builds a ListView gadget in a new window to allow
you to scroll through the list of procedure names and select one
for editing. The EdTag.rexx then takes the output of the CTagSel
program and invokes the AmigaDos "Ed" editor on the proper
source program and positions the display to the procedure name
that you selected. At this time, the "Ed" editor is the only one
supported for this process.

The "EdTag Bld" entry in the edit tools list invokes this entire
process. The "EdTag" entry in the Utility list bypasses the CTag
build and invokes CTagSel using the tag list built by a previous
use of "EdTag Bld". This can be usefull when working on a large
project when you don't want to rebuild the tag list for every
edit.

The "EdErr" entry in the Utility list does a similar type of
thing with the error listing file from the DICE compiler. This
entry only works with DICE at this time. This allows you to
select an error message and start the "Ed" editor at the line
of the error you select.

The CTagSel program is actually a pretty handy little utility.
It can be invoked with basically any text file as input and will
present this file in a ListView gadget. The text of the line you
select is put in the Arexx clip list under the name CTagSel. There
are hard-coded limits in the program of 1000 lines of text and
40000 characters of text.

----------------------------------------------------------
Future Plans:

Planned improvements are:  including either the HCC or NorthC
compiler, and redirecting certain utility outputs to files for
later browsing.

I thought about adding an ARexx port, but if you could make good
use of it, you could just drive the programs that this one
does directly from ARexx and be better off. I would also like
to figure out how to use the DMEMacros from Fred Fish disk 146
or possibly rewrite them for the new ED 2.0, now that it talks
ARexx. I have also thought about making use of the Revision
Control System (RCS) on Fred Fish disk 451 as an option for the
Open and Save functions. CWeb from Fred Fish disk 551 is also a
possibility.

END OF README.TXT

