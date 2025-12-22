/* setftest 1.0 (12.6.97) © Frédéric RODRIGUES
*/

OPT PREPROCESS

#define NEWF
->#define OLDF
#define OFFSET -30
#define BASE dosbase

MODULE 'tools/geta4'

#ifdef NEWF
MODULE '*setf'

DEF setf:PTR TO setf

PROC main()
  NEW setf.setf(BASE,OFFSET,{new})
  storea4()
  WHILE CtrlC()<>TRUE DO Delay(10)
  IF setf.attemptend()=FALSE THEN WriteF('Someone patched your function\n')
  WHILE setf.attemptend()=FALSE DO Delay(10)
  END setf
ENDPROC

PROC new()
  DEF name,mode,fh
  MOVE.L D1,name
  MOVE.L D2,mode
  geta4()
  WriteF('\s opened with mode \s\n',name,IF mode=NEWFILE THEN 'NEWFILE' ELSE 'OLDFILE')
  MOVE.L name,D1
  MOVE.L mode,D2
  fh:=setf.oldfunc()
  WriteF('fh: \d\n',fh)
ENDPROC fh
#endif

#ifdef OLDF
PROC main()
   DEF old
   IF old:=SetFunction(BASE,OFFSET,{new})
      PutLong({oldfunc},old)
      storea4()
      WHILE CtrlC()<>TRUE DO Delay(10)
      SetFunction(BASE,OFFSET,old)
   ENDIF
ENDPROC

PROC codenew()
  DEF name,mode
  MOVE.L D1,name
  MOVE.L D2,mode
  geta4()
  WriteF('\s opened with mode \s\n',name,IF mode=NEWFILE THEN 'NEWFILE' ELSE 'OLDFILE')
ENDPROC

oldfunc: LONG 0

new:
  MOVEM.L D0-D7/A0-A6, -(A7)
  codenew()
  MOVEM.L (A7)+, D0-D7/A0-A6
  MOVE.L oldfunc(PC), -(A7)
  RTS
#endif
