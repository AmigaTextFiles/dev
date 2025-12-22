/* general routines to allocate/deallocate bitmaps.
** same syntax as v39+ AllocBitMap()/FreeBitMap() but also works
** on lower OS-versions
**
** Does *not* throw exceptions!
*/

OPT MODULE
OPT REG=5

MODULE 'graphics/gfx',
       'exec/memory'
MODULE 'sven/getConfigSoftware'

EXPORT PROC allocBitMap(width,height,depth,flags=BMF_CLEAR,friend=NIL)
DEF bm:PTR TO bitmap,
    i,
    planeptr

  IF getGfxVersion()<39
    IF bm:=AllocMem(SIZEOF bitmap,MEMF_PUBLIC OR MEMF_CLEAR)
      InitBitMap(bm,depth,width,height)
      FOR i:=0 TO depth-1
        IF planeptr:=AllocRaster(bm.bytesperrow*8,bm.rows)
          IF (flags AND BMF_CLEAR)
            BltClear(planeptr,Mul(bm.bytesperrow,bm.rows),0)
          ENDIF
          bm.planes[i]:=planeptr
        ELSE
          freeBitMap(bm)
          RETURN NIL
        ENDIF
      ENDFOR
    ENDIF
  ELSE
    bm:=AllocBitMap(width,height,depth,flags,friend)
  ENDIF

ENDPROC bm

EXPORT PROC freeBitMap(bm:PTR TO bitmap)
DEF i

  IF bm
    IF getGfxVersion()<39
      FOR i:=0 TO bm.depth-1
        IF bm.planes[i] THEN FreeRaster(bm.planes[i],bm.bytesperrow*8,bm.rows)
      ENDFOR
      FreeMem(bm,SIZEOF bitmap)
    ELSE
      FreeBitMap(bm)
    ENDIF
  ENDIF

ENDPROC NIL

