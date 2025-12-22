/* 
Introduction
------------
This little program should be named MultiView and placed in the C: directory.
It was written out of frustration. If you are using OS 2.x and often download
archives from Aminet or the like, you probably know this situation: doubleclick
on an icon and a requester pops up "program multiview cannot be located".
Here is where this program comes in. It is called instead of the 3.x multiview
and for all the usual file extensions there is a configured viewer that you like
best.

How to use it?
--------------
Very simple, if you have AmigaE by Wouter van Oortmerssen. 
Thanks Wouter for this incredible piece of software and the support!
It was written using version 3.1a, but might work with earlier versions too. 
(If not, get the latest version from Aminet and try the demo and register 
afterwards 8-) )
I put in my favourite viewers (players can also be used). To change that, just
edit the source code to fit your needs and compile it. As the last step, put it
in your C: directory as MultiView. Now you are set

Some problems
-------------
- viewers must be in C: or given with complete path, when used from WB
  (DOS.library`s Execute function related)
  (any ideas for fixing, please contact me)
- doesn`t replace OS 3.x data types
  (it doesn`t even try 8-( )
- no external prefs file/program
  (faster for same reason)
- can handle only commands up to 512 characters (including parameters, quotes...)
  (max. CLI command length is 512)
- file needs to have an extension (.something)
  (currently up to 6 characters)

Legal Stuff
-----------
This program was written, using some example routines from the AmigaE_v3.1a package,
(thanks again to Wouter) by: Horst Schumann
                             Helmstedter Str. 18
                             39167 Irxleben
                             Germany

                             e-mail: hschuman@cs.uni-magdeburg.de
                 WWW: http://www.cs.uni-magddeburg.de/~hschuman/hschuman.html

I call it anythingware! Everybody can use it, modify it, compile it, re-release it,
etc. provided he/she (Are there any girls using the Amiga? Love to hear from you!)
sends me anything like e-mails, postcards, letters, money, Amigas (no PCs, please!), 
etc., but if you can`t afford any of it, please use it anyway, it might be useful.
Own programs, especially those of the useful kind, are very much welcome too.

And now the standard disclaimer
-------------------------------
NO WARRANTY
If something happens you don`t want, blame somebody else!

Future Plans?
-------------
Who knows what the future will bring...
*/



OPT OSVERSION=37

MODULE 'workbench/startup'


PROC get_extension(string,extension)
  DEF pos
  pos:=StrLen(string)-1
  WHILE string[pos]<>"."
    pos--
  ENDWHILE
  MidStr(extension,string,pos+1)
ENDPROC


PROC get_command(extension,command)     -> add own commands in this procedure
  LowerStr(extension)
  IF StrCmp(extension,'guide')
    StrCopy(command,'amigaguide "')
  ELSEIF StrCmp(extension,'doc')
    StrCopy(command,'muchmore "')
  ELSEIF StrCmp(extension,'txt')
    StrCopy(command,'muchmore "')
  ELSEIF StrCmp(extension,'readme')
    StrCopy(command,'muchmore "')
  ELSEIF StrCmp(extension,'iff')
    StrCopy(command,'work:utilities/display "')
  ELSEIF StrCmp(extension,'ham')
    StrCopy(command,'work:utilities/display "')
  ELSE
    WriteF('File type unknown: \s\nusing default viewer\n',extension)
    StrCopy(command,'muchmore "')
  ENDIF
ENDPROC


PROC main()
  DEF wb:PTR TO wbstartup       -> pointer to WBstartup object
  DEF wbargs:PTR TO wbarg       -> pointer to WBarg object
  DEF a                         -> just a counter
  DEF template                  -> template for CLI argument parsing
  DEF rdargs                    -> flag for ReadArgs result
  DEF cliargs=NIL:PTR TO LONG   -> pointer where ReadArgs can store arguments
  DEF command[512]:STRING       -> max. CLI command string length is 511
  DEF currentdir                -> save current dir when started from WB
  DEF ext[6]:STRING             -> extension
  
  IF wbmessage=NIL                              -> started from CLI
    template:='FILE/M'
    rdargs:=ReadArgs(template,{cliargs},NIL)
    IF rdargs
      IF cliargs
        a:=0
        WHILE cliargs[a]                    -> Loop through arguments
          IF InStr(cliargs[a],'.') > -1
            get_extension(cliargs[a],ext)
            get_command(ext,command)
          ENDIF
          StrAdd(command,cliargs[a])
          StrAdd(command,'"')
          Execute(command,0,stdout)
          a++
        ENDWHILE
      ENDIF
      FreeArgs(rdargs)
    ENDIF
  ELSE                                              -> started from WB
    currentdir:=CurrentDir(wbargs[0].lock)
    wb:=wbmessage
    wbargs:=wb.arglist
    FOR a:=1 TO wb.numargs-1
      IF InStr(wbargs[a].name,'.') > -1
        get_extension(wbargs[a].name,ext)
        get_command(ext,command)
      ENDIF
      CurrentDir(wbargs[a].lock)
      StrAdd(command,wbargs[a].name)
      StrAdd(command,'"')
      Execute(command,0,stdout)
    ENDFOR
    CurrentDir(currentdir)
    IF stdout<>NIL
      WriteF('\n\nPress RETURN to close this window.\n')
    ENDIF
  ENDIF
ENDPROC
