OPT MODULE
OPT PREPROCESS

MODULE 'graphics/displayinfo'
MODULE 'sven/eVec'


/*
** Calls graphics.library/GetDisplayInfoData().
** Where 'id' is the Monitor-ID and 'type' the wanted infos
** (graphics/displayinfo/DTAG_XXX).
**
** Returns an appropriate structure which must be freed
** with freeDisplayInfoData() or NIL in case of an error.
** May raise "MEM" exception.
*/
EXPORT PROC getDisplayInfoData(id, type)
DEF buffer,
    size

  SELECT type
    CASE DTAG_DISP ; size:=SIZEOF displayinfo
    CASE DTAG_DIMS ; size:=SIZEOF dimensioninfo
    CASE DTAG_MNTR ; size:=SIZEOF monitorinfo
    CASE DTAG_NAME ; size:=SIZEOF nameinfo
    CASE DTAG_VEC  ; size:=SIZEOF vecinfo
    DEFAULT        ; RETURN NIL
  ENDSELECT

  buffer:=eAllocVec(size)
  IF GetDisplayInfoData(NIL, buffer, size, type, id)=0
    buffer:=eFreeVec(buffer)
  ENDIF

ENDPROC buffer


/*
** Frees the memory used for an DisplayInfoData-structure
*/
EXPORT PROC freeDisplayInfoData(info:PTR TO CHAR) IS eFreeVec(info)

