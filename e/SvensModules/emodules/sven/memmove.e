/* Copies memory blocks. They may overlap (forwards and backwards).
** returns the destination.
*/

OPT MODULE

/*EXPORT PROC memmove(dest:PTR TO CHAR,src:PTR TO CHAR,size)
DEF dummy

  dummy:=dest
  IF src>dest
    WHILE size-->=0 DO dest[]++:=src[]++
  ELSEIF src<dest
    src:=src+size
    dest:=dest+size
    WHILE size-->=0 DO dest[]--:=src[]--
  ENDIF

ENDPROC dummy
*/

/*
EXPORT PROC memmove(dest:PTR TO CHAR,src:PTR TO CHAR,size)

  MOVE.W  size.W,D1
  MOVE.W  D1,D2
  SUBQ.W  #1,D1
  BMI.S   memmove_ende

  MOVEA.L dest,A1
  MOVEA.L src,A0
  MOVE.L  A1,D0
  SUB.L   A0,D0
  BMI.S   memmove_loop2

  ADDA.L  D2,A0
  ADDA.L  D2,A1
memmove_loop1:
  MOVE.B  -(A0),-(A1)
  DBRA.S  D1,memmove_loop1
  BRA.S   memmove_ende

memmove_loop2:
  MOVE.B  (A0)+,(A1)+
  DBRA.S  D1,memmove_loop2

memmove_ende:
ENDPROC dest
*/

/* does all the fancy stuff like LONG-copies etc.
**
** Taken from the sources of an C-compiler. Don't remember which
** one it was.
*/
EXPORT PROC memmove(dest:PTR TO CHAR,src:PTR TO CHAR,size)

       MOVEA.L src,A1
       MOVEA.L dest,A0
       MOVE.L  size,D0
       BLE.S   memmove_ret
       CMPA.L  A0,A1
       BHI.S   memmove_forward
-> Rückwärts kopieren:
       ADD.L   D0,A0
       ADD.L   D0,A1
       CMPI.L  #8,D0           -> weniger als 8 Bytes?
       BLT.S   memmove_loop1
       MOVE.L  A0,D1
       LSR.L   #1,D1           -> a0 ungerade?
       BCC.S   memmove_a0even1
       MOVE.B  -(A1),-(A0)     -> dann gerade machen!
       SUBQ.L  #1,D0

memmove_a0even1:
       MOVE.L  A1,D1
       LSR.L   #1,D1           -> a1 ungerade?
       BCS.S   memmove_loop1   -> dann hilft nix mehr
-> Langwortweise kopieren:
       SUBQ.L  #4,D0
       BLT.S   memmove_nolw1

memmove_lw1:
       MOVE.L  -(A1),-(A0)
       SUBQ.L  #4,D0
       BHI.S   memmove_lw1

memmove_nolw1:
       ADDQ.L  #4,D0
       BEQ.S   memmove_ret

memmove_loop1:
       MOVE.B  -(A1),-(A0)
       SUBQ.L  #1,D0
       BNE.S   memmove_loop1
       BRA.S   memmove_ret

memmove_forward:
-> Vorwärts verschieben
       CMP.L   #8,D0           -> weniger als 8 Bytes?
       BLT.S   memmove_loop2
       MOVE.L  A0,D1
       LSR.L   #1,D1           -> a0 ungerade?
       BCC.S   memmove_a0even2
       MOVE.B  (A1)+,(A0)+     -> dann gerade machen!
       SUBQ.L  #1,D0

memmove_a0even2:
       MOVE.L  A1,D1
       LSR.L   #1,D1           -> a1 ungerade?
       BCS.S   memmove_loop2   -> dann hilft nix mehr
-> Langwortweise kopieren:
       SUBQ.L  #4,D0
       BLT.S   memmove_nolw2

memmove_lw2:
       MOVE.L  (A1)+,(A0)+
       SUBQ.L  #4,D0
       BHI.S   memmove_lw2

memmove_nolw2:
       ADDQ.L  #4,D0
       BEQ.S   memmove_ret

memmove_loop2:
-> Byteweise kopieren:
       MOVE.B  (A1)+,(A0)+
       SUBQ.L  #1,D0
       BNE.S   memmove_loop2

memmove_ret:

ENDPROC dest

