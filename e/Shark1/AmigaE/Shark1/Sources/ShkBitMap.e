OPT MODULE
OPT EXPORT

MODULE 'graphics/gfx','exec/memory'


PROC mRasSize(w,h) IS Shr(w+15,3) AND $FFFE * h

PROC mCreateBitMap(width,height,depth,flags,friend:PTR TO bitmap)
  DEF bm:PTR TO bitmap,memflags,pl:PTR TO LONG,i
  IF KickVersion(39)
    bm:=AllocBitMap(width,height,depth,flags,friend)
  ELSE
    memflags:=MEMF_CHIP
    IF bm:=New(SIZEOF bitmap)
      InitBitMap(bm,depth,width,height)
      pl:=bm.planes
      IF flags AND BMF_CLEAR THEN memflags:=memflags OR MEMF_CLEAR
      pl[0]:=AllocVec(depth*mRasSize(width,height),memflags)
      IF pl[0]
        FOR i:=1 TO depth-1 DO pl[i]:=pl[i-1]+mRasSize(width,height)
      ELSE
        Dispose(bm)
      ENDIF
    ENDIF
  ENDIF
BltBitMap(friend,0,0,bm,0,0,width,height,$C0,-1,NIL)
ENDPROC bm

PROC mDeleteBitMap(bm:PTR TO bitmap)
  IF bm
    IF KickVersion(39)
      FreeBitMap(bm)
     ELSE
       FreeVec(Long(bm.planes))
       Dispose(bm)
     ENDIF
  ENDIF
ENDPROC

PROC mBitMapDepth(bm:PTR TO bitmap) IS
  IF KickVersion(39) THEN GetBitMapAttr(bm,BMA_DEPTH) ELSE bm.depth
