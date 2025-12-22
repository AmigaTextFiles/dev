-> Get_Filesys.e - Example of examining the FileSysRes list

OPT PREPROCESS

MODULE 'exec/lists',
       'exec/nodes',
       'resources/filesysres'

DEF filesysresbase:PTR TO filesysresource

PROC main()
  DEF fse:PTR TO filesysentry, x
  -> NOTE - you should actually be in a Forbid while accessing any system list
  -> for which no other method of arbitration is available.  However, for this
  -> example we will be printing the information (which would break a Forbid
  -> anyway) so we won't Forbid.  In real life, you should Forbid, copy the
  -> information you need, Permit, then print the info.
  IF NIL=(filesysresbase:=OpenResource(FSRNAME))
    WriteF('Cannot open \s\n', FSRNAME)
  ELSE
    fse:=filesysresbase.filesysentries.head
    WHILE fse.ln.succ
      -> An A3000 running V34 does not have the name field filled in.
      -> An A2000 running V34 with an A590/2091 controller also does not have
      -> the name field filled in.
      IF fse.ln.name THEN WriteF('Found filesystem creator: \s\n', fse.ln.name)

      WriteF('                 DosType: ')
      FOR x:=24 TO 8 STEP -8 DO Out(stdout, Shr(fse.dostype,x) AND $FF)

      Out(stdout, (fse.dostype AND $FF)+$30)

      WriteF('\n                 Version: \d', Shr(fse.version, 16))
      WriteF('.\d\n\n', fse.version AND $FFFF)
      fse:=fse.ln.succ
    ENDWHILE
  ENDIF
ENDPROC
