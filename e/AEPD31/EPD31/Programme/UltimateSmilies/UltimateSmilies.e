
/*
** UltimateSmilies 1.0 - Copyright © 17-Feb-1995 by Maik Schreiber
** ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
** Usage: UltimateSmilies
**
**
** It is recommended to redirect the output like this:
**
**   UltimateSmilies >Smilies.txt
*/


DEF hairlst:PTR TO LONG,hairnum=0,eyeslst:PTR TO LONG,eyesnum=0,
    noseslst:PTR TO LONG,nosesnum=0,mouthslst:PTR TO LONG,mouthsnum=0,
    h,e,n,m,tab=1

PROC main()
  hairlst:=['','=','-','#','{',NIL]
  REPEAT; INC hairnum; UNTIL hairlst[hairnum]=NIL
  eyeslst:=[':',';','.',',','B','8','3','`','''',NIL]
  REPEAT; INC eyesnum; UNTIL eyeslst[eyesnum]=NIL
  noseslst:=['-','^','v','<','>','o','u','=','+',NIL]
  REPEAT; INC nosesnum; UNTIL noseslst[nosesnum]=NIL
  mouthslst:=[')','D','>','(','C','<','B','P','S','|','/','\\','O','Q','þ','Þ','1','6','8','9','0',NIL]
  REPEAT; INC mouthsnum; UNTIL mouthslst[mouthsnum]=NIL

  WriteF('\nTHE ULTIMATE SMILIES LIST\n=========================\nCreated by UltimateSmilies 1.0 [FREEWARE]\nCopyright © 17-Feb-1995 by Maik "Blizzer" Schreiber\n')

  WriteF('\n\nHair list (\d entries):\n---------\n',hairnum)
  FOR h:=0 TO (hairnum-1)
    WriteF('\s',hairlst[h])
    IF tab<10; Out(stdout,9); INC tab; ELSE; Out(stdout,10); tab:=1; ENDIF
    IF CtrlC() THEN CleanUp(5)
  ENDFOR

  IF tab>1 THEN Out(stdout,10); tab:=1
  WriteF('\n\nEyes list (\d entries):\n---------\n',eyesnum)
  FOR h:=0 TO (eyesnum-1)
    WriteF('\s',eyeslst[h])
    IF tab<10; Out(stdout,9); INC tab; ELSE; Out(stdout,10); tab:=1; ENDIF
    IF CtrlC() THEN CleanUp(5)
  ENDFOR

  IF tab>1 THEN Out(stdout,10); tab:=1
  WriteF('\n\nNoses list (\d entries):\n----------\n',nosesnum)
  FOR h:=0 TO (nosesnum-1)
    WriteF('\s',noseslst[h])
    IF tab<10; Out(stdout,9); INC tab; ELSE; Out(stdout,10); tab:=1; ENDIF
    IF CtrlC() THEN CleanUp(5)
  ENDFOR

  IF tab>1 THEN Out(stdout,10); tab:=1
  WriteF('\n\nMouths list (\d entries):\n-----------\n',mouthsnum)
  FOR h:=0 TO (mouthsnum-1)
    WriteF('\s',mouthslst[h])
    IF tab<10; Out(stdout,9); INC tab; ELSE; Out(stdout,10); tab:=1; ENDIF
    IF CtrlC() THEN CleanUp(5)
  ENDFOR

  IF tab>1 THEN Out(stdout,10); tab:=1
  WriteF('\n\nFull smilies list (\d entries):\n-----------------\n',Mul(Mul(Mul(mouthsnum,nosesnum),eyesnum),hairnum))
  FOR h:=0 TO (hairnum-1)
    FOR e:=0 TO (eyesnum-1)
      FOR n:=0 TO (nosesnum-1)
        FOR m:=0 TO (mouthsnum-1)
          WriteF('\s\s\s\s',hairlst[h],eyeslst[e],noseslst[n],mouthslst[m])
          IF tab<10; Out(stdout,9); INC tab; ELSE; Out(stdout,10); tab:=1; ENDIF
          IF CtrlC(); Out(stdout,10); CleanUp(5); ENDIF
        ENDFOR
      ENDFOR
    ENDFOR
  ENDFOR
ENDPROC

CHAR '$VER: UltimateSmilies 1.0 (17-Feb-1995) © by Maik Schreiber [FREEWARE]'

