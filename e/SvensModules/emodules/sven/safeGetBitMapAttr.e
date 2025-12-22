/* implements graphics GetBitMapAttr() which also works on
** pre v39 systems.
*/

OPT MODULE

MODULE 'graphics/gfx'
MODULE 'sven/getConfigSoftware'

EXPORT PROC safeGetBitMapAttr(bm:PTR TO bitmap,attr)
DEF ret=0:REG

  IF getGfxVersion()<39
    SELECT attr
      CASE BMA_HEIGHT ; ret:=bm.rows
      CASE BMA_WIDTH  ; ret:=bm.bytesperrow*8
      CASE BMA_DEPTH  ; ret:=bm.depth
      CASE BMA_FLAGS  ; ret:=bm.flags
    ENDSELECT
  ELSE
    ret:=GetBitMapAttr(bm,attr)
  ENDIF

ENDPROC ret


