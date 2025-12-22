OPT TURBO

MODULE 'exec/memory'

CONST SIZEOF_POINTER=18*4

PROC newPointer(pointerImage)
  DEF pointer=NIL
  IF pointer:=AllocMem(SIZEOF_POINTER,
                       MEMF_CHIP) THEN CopyMemQuick(pointerImage,
                                                    pointer, SIZEOF_POINTER)
ENDPROC pointer
  /* newPointer */

PROC freePointer(pointer)
  FreeMem(pointer, SIZEOF_POINTER)
ENDPROC
  /* freePointer */

PROC setPointer(win, pointer)
  SetPointer(win, pointer, 16, 16, -6, 0)
ENDPROC
  /* setPointer */

