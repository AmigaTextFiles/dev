
ECompile.ced v2.10 - AmigaE compiler script for Cygnus Editor!


WHAT IS SO SPECIAL ABOUT IT?

· It uses reqtools.library for output results ie. compile status.
· Can make duplicates ie. makes a copy of the compiled file into
  another drawer. (configurable)
· Can save backups of source file. (requester option)
· Autoupdates versionstring (configurable)
· You are asked to add a versionstring if none was found! (configurable)
· And it's really simple to use...


SPECIAL FEATURES?

· You can specify duplicate path inside each source
· You can specify EC options inside each source
· You can handle version strings inside source


HOW DO I INSTALL IT?

Just place the script in 'Rexx:'
And then put it as a hotkey in Cygnus Editor!


HOW DO I PUT THE SCRIPT AS A HOTKEY IN CYGNUS EDITOR?

1. Go to Cygnus Editor menu option "Special-Dos/Arexx interface"
2. Choose Fkey to have compiler on (1-10)
3. Write the name of the script 'ECompile.ced'
4. Now you can start compiling :)


CAN'T FIND AMIGAE COMPILER?

Change ECPath inside script!


WANT A AMIGAE COMPILER OPTION TO ALWAYS BE USED?

Change default ECOptions inside script!
This way you don't have to write it inside the sources!


HOW DO I USE SPECIAL FEATURES?

IMPORTANT! Always write these options DIRECT INTO THE ARROW (i.e. NO SPACE)!!!
List of options:

->ECOptions EC options
->ECDupPath "Path to the duplicate"
->ECNoVer
->ECNoBump
->ECBumpRev
->ECComment "comment to place after verstring in the filenote"
->ECPPSet
#define ECVERNAME 'programname'
#define ECVERSHORT 'ver.rev'
#define ECVERLONG 'ver.rev.fixrev'
#define ECVERDATE '(d.m.yy)'


The two first are separate from the rest which are for versionstrings.

Compile handling (both can be used at the same time):
· ECOptions - With this you can specify EC options inside your source.
              Remove if no options should be used (or default from script)!
· ECDupPath - With this a cloned copy of the compiled file can be placed
              anywhere you want.  Do not use it for no clone!

Version string handling:
· NoVer     - No change to or adding of versionstring will be done.
· NoBump    - No change of the actual version number is done but date will
              be changed.
· BumpRev   - Increases revision number by one on each compile
· <nothing> - Increases beta revision number by one on each compile
One of these four can only be used at the same time!

Additional commands & version handling:
· ECComment - Adds the verstring as a filenote to the compiled exe
              Additional text to be added as filenote can be written
              after this command. Note, verstring will ALWAYS be added!
· ECPPSet   - Tells the compiler script to use the defines.
              Compiler option OPT PREPROCESS is necessary because define
              is used...

These four defines are usable! All defines must not be used at the same time!
NEVER use more than ONE space between a define and the string!!!
ECVERNAME 'programname'
ECVERSHORT 'ver.rev'
ECVERLONG 'ver.rev.fixrev'
ECVERDATE '(d.m.yy)'

If you don't want to use any of these features..
Then simply don't write anything!!!  A requester will appear anyway so you
can choose some of these options even if no option was used!

Example source:
-------------------------------------------------------------------------------
/*  Example program  */

->ECOptions OPTI LARGE           /* uses EC options 'OPTI' & 'LARGE'! */
->ECDupPath "Work:OwnPrograms/"  /* Clones compiled file to this path */
->ECBumpRev                      /* Bumps the rev number! */
->ECComment " © 1997 by me!"     /* Adds verstring & comment to filenote */
->ECPPSet                        /* Uses the verstring defines */
#define ECVERNAME 'Example'
#define ECVERSHORT '1.0'
#define ECVERDATE '(11.8.97)'

OPT OSVERSION=37,PREPROCESS

PROC main()
   PrintF('\nHello World\n\nVer: \s \s \s\n\n',ECVERNAME,ECVERSHORT,ECVERDATE)
ENDPROC

VOID '$VER: Example 1.0 (11.8.97) © 1997 by me!'
-------------------------------------------------------------------------------


LOOK OF VERSION STRING:

The versionstring made will look like this:

VOID '$VER: Sourcename 1.0 (11.8.97)'

And will be placed LAST in your source!
Of course will ECompiler.ced update a verstring in ANY place!!!

Beta revisions look like this:

VOID '$VER: Sourcename 1.0.1 (11.8.97)'


WHAT IS THE REQUIREMENTS?

· Cygnus Editor v3+ (v3.5+ rek.)
· ARexx v1.15+
· ReqTools.library v38+
· RexxReqTools.library v37+
· AmigaE Compiler v3.0+
· AmigaOS v2.04+ (v37)
· C:Filenote, C:Copy


CONTACTING THE AUTHOR!

For bug reports etc. write an e-mail to:

Writer of current version (complete rewrite) Johan Nilsson:
jonils@algonet.se

Writer of original version, this doc & beta testing Harry Samwel:
samwel@algonet.se


HISTORY

 1.0-1.3 -  Internal versions
     1.4 -  Fixed a couple of bugs
            Added saving backup of sourcefile
            Optimized code
 1.5-2.1 -  Internal versions
     2.2 -  Fixed a couple of bugs
            Changed finding/output of error codes from EC
            Added version string handling
            Additional changes
 2.3-2.4 -  Internal changes
            Some small fixes
            Added comments handling for verstrings
            Changed backup handling (now a filerequester)
     2.5 -  Changed outlook of requester output
     2.6 -  Added option to make defines of the verstring
     2.7 -  Optimized define handling
     2.8 -  Optimized define handling even more
            Changed backup handling (now a 'overwrite' requester)
     2.9 -  Fixed some problems with the define handling
            Added a BumpFix button
            Added a help page button
    2.10 -  Added centered screen repositioning when jumping back to
            where cursor was when starting compile script


COPYRIGHTS

CygnusEditor is Copyright © 1987-1997 Cygnus Software
ARexx & AmigaOS is Copyright © 1985-1997 Amiga International
ReqTools.library is Copyright © 1991-1994 Nico Francios
ReqTools.library is Copyright © 1996-1997 Magnus Holmgren
RexxReqTools.library is Copyright © 1992-1994 Rafael D'halleweyn
AmigaE/AmigaE Compiler is Copyright © 1991-1997 Wouter van Oortmerssen
