OPT MODULE

MODULE 'icon',
       'other/split',
       'workbench/startup',
       'workbench/workbench'
MODULE 'dos', 'wb'

PRIVATE
DEF cxlib_arg:LIST, cxlib_dobj:PTR TO diskobject
PUBLIC

PROC argArrayInit(str=NILA:ARRAY OF CHAR) RETURNS ret:ARRAY OF ARRAY OF CHAR
  DEF argmsg:PTR TO wbstartup, lock:BPTR
  IF iconbase=NIL
    RETURN NILA
  ELSE IF argmsg:=wbmessage
    IF argmsg.arglist[0].lock THEN lock:=CurrentDir(argmsg.arglist[0].lock)
    cxlib_dobj:=GetDiskObject(argmsg.arglist[0].name !!ARRAY!!ARRAY OF CHAR)
    IF lock THEN CurrentDir(lock)
    RETURN IF cxlib_dobj THEN cxlib_dobj.tooltypes ELSE NILA
  ELSE
    RETURN (cxlib_arg:=argSplit(str)) !!ARRAY!!ARRAY OF ARRAY OF CHAR
  ENDIF
ENDPROC

PROC argArrayDone()
  IF iconbase
    IF wbmessage
      FreeDiskObject(cxlib_dobj)
    ELSE
      DisposeList(cxlib_arg)
    ENDIF
  ENDIF
ENDPROC

PROC argString(tt:ARRAY OF ARRAY OF CHAR, entry:ARRAY OF CHAR, defaultstring:ARRAY OF CHAR)
  DEF res:ARRAY OF CHAR
  res:=NILA
  IF (tt<>NILA) AND (iconbase<>NIL)
    res:=FindToolType(tt, entry)
  ENDIF
ENDPROC IF res THEN res ELSE defaultstring

PROC argInt(tt:ARRAY OF ARRAY OF CHAR, entry:ARRAY OF CHAR, defaultval)
  DEF res:ARRAY OF CHAR, dva[1]:ARRAY OF VALUE
  res:=NILA
  IF (tt<>NILA) AND (iconbase<>NIL)
    dva[0]:=defaultval
    IF res:=FindToolType(tt, entry) THEN StrToLong(res, dva)
    defaultval:=dva[0]
  ENDIF
ENDPROC defaultval
