OPT AMIGAOS4, MODULE

-> amigalib/argarray.e by LS 2003

MODULE 'icon',
       'other/split',
       'workbench/startup',
       'workbench/workbench'

DEF cxlib_arg, cxlib_dobj:PTR TO diskobject

EXPORT PROC argArrayInit(str=NIL)
  DEF argmsg:PTR TO wbstartup, lock=NIL
  IF iconbase=NIL
    RETURN NIL
  ELSEIF argmsg:=wbmessage
    IF argmsg.arglist.lock THEN lock:=CurrentDir(argmsg.arglist.lock)
    cxlib_dobj:=GetDiskObject(argmsg.arglist.name)
    IF lock THEN CurrentDir(lock)
    RETURN IF cxlib_dobj THEN cxlib_dobj.tooltypes ELSE NIL
  ELSE
    RETURN cxlib_arg:=argSplit(str)
  ENDIF
ENDPROC

EXPORT PROC argArrayDone()
  IF iconbase
    IF wbmessage
      FreeDiskObject(cxlib_dobj)
    ELSE
      DisposeLink(cxlib_arg)
    ENDIF
  ENDIF
ENDPROC

EXPORT PROC argString(tt:PTR TO LONG, entry, defaultstring)
  DEF res=NIL
  IF tt AND (iconbase<>NIL)
    res:=FindToolType(tt, entry)
  ENDIF
ENDPROC IF res THEN res ELSE defaultstring

EXPORT PROC argInt(tt:PTR TO LONG, entry, defaultval)
  DEF res=NIL
  IF tt AND (iconbase<>NIL)
    IF res:=FindToolType(tt, entry) THEN StrToLong(res, {defaultval})
  ENDIF
ENDPROC defaultval



