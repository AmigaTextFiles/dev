/*
 * Args array adaption for Amiga E (from amiga.lib)
 * $VER: ArgArray 1.0 (18.04.94)
 *
 * ttypes:=_argarrayinit(_argc,_argv)
 * _argarraydone()
 * string:=_argstring(ttypes,entry,default)
 * number:=_argint(ttypes,entry,default)
 *
 */

/* We need to define _argc & _argv before */
PMODULE 'PMODULES:User/astartup'

PROC _argarrayinit(argc,argv)
  DEF tooltypesarray=NIL:LONG
  IF iconbase=NIL THEN Raise("ICON")

  PEA    _argarraydatabase(PC)
  PEA    tooltypesarray
  MOVE.L iconbase,-(A7)
  MOVE.L argv,-(A7)
  MOVE.L argc,-(A7)
  INCBIN 'PMODULES:User/argarray/argarrayinit.bin'
  LEA	20(A7),A7
ENDPROC tooltypesarray

PROC _argarraydone()
  PEA    _argarraydatabase(PC)
  MOVE.L iconbase,-(A7)
  INCBIN 'PMODULES:User/argarray/argarraydone.bin'
  ADDQ.W #8,A7
ENDPROC

PROC _argstring(tooltypesarray,entry,default)
  DEF result

  MOVE.L iconbase,-(A7)
  PEA    result
  MOVE.L default,-(A7)
  MOVE.L entry,-(A7)
  MOVE.L tooltypesarray,-(A7)
  INCBIN 'PMODULES:User/argarray/argstring.bin'
  LEA 20(A7),A7
ENDPROC result

PROC _argint(tooltypesarray,entry,default)
  MOVE.L dosbase,-(A7)
  MOVE.L iconbase,-(A7)
  PEA    default
  MOVE.L entry,-(A7)
  MOVE.L tooltypesarray,-(A7)
  INCBIN 'PMODULES:User/argarray/argint.bin'
  LEA 20(A7),A7
ENDPROC default

_argarraydatabase:
  LONG 0
  LONG 0
  LONG 0
