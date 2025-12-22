/* An Amiga E program to Create ASCII sirds  */

MODULE 'dos/dos'

ENUM ER_FILE=1,ER_MEM,ER_C

CONST DEPTHOF = 16,
      COLS = 79,
      EOL=10

DEF  i,                          /*  Counters          */
     out,                        /*  Output            */
     field[DEPTHOF]:STRING,      /*  Random characters */
     slen,name[100]:STRING,file,test

PROC main()

  loadfile()
  out:=String(slen+100)
  IF out=NIL THEN error(ER_MEM)

  FOR i:=0 TO slen
    IF CtrlC() THEN error(ER_C)
    IF (file[i]>="a") AND (file[i]<="z")
      out[i]:=file[i]+13
      IF (out[i]>"z") THEN out[i]:=out[i]-26
    ELSEIF (file[i]>="A") AND (file[i]<="Z")
      out[i]:=file[i]+13
      IF (out[i]>"Z") THEN out[i]:=out[i]-26
    ELSE
      out[i]:=file[i]
    ENDIF
  ENDFOR

  WriteF('\s\n',out)

ENDPROC

PROC loadfile()
  DEF suxxes=FALSE,handle,read
  IF StrCmp(arg,'?',ALL) OR StrCmp(arg,'',ALL)
    WriteF('USAGE: rot13 <input file>\n')
    error(0)
  ELSE
    StrCopy(name,arg,ALL)
    slen:=FileLength(name)
    handle:=Open(name,1005)
    IF (handle=NIL) OR (slen=-1)
      error(ER_FILE)
    ELSE
      file:=New(slen+10)
      IF file=NIL
        error(ER_MEM)
      ELSE
        read:=Read(handle,file,slen)
        Close(handle)
        IF read=slen
          suxxes:=TRUE
          file[slen]:=0
        ELSE
          error(ER_FILE)
        ENDIF
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC error(er)

  IF er=ER_C THEN WriteF('***Break\n\n')
  IF er=ER_MEM THEN WriteF('Memory error\n')
  IF er=ER_FILE THEN WriteF('File error\n')
  CleanUp(0)

ENDPROC