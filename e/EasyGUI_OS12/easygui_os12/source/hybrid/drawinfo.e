/* RST: hybrid "any kick" replacement for intuition library
   GetScreenDrawInfo() and FreeScreenDrawInfo()

   Please do not redistribute modified versions of this code. If you have
   any ideas how to make things better contact me at metamonk@yahoo.com.

   Also, please do not distribute further 'hybrid/#?' modules since there
   is already a large amount of additional stuff in work. Contact me...

   This code is Copyright (c) 2000, Ralf 'hippie2000' Steines, and
   inherits the legal state from the original EasyGUI disctribution. */

OPT MODULE
OPT EXPORT

MODULE 'intuition/screens',
       'graphics/gfx', 'exec/memory',
       'hybrid/version'

PROC getScreenDrawInfo(screen:PTR TO screen)
  DEF dri=NIL:PTR TO drawinfo,newlook=FALSE
  IF intuiVersion(36)
    dri:=GetScreenDrawInfo(screen)
  ELSE
    IF screen
      IF dri:=AllocMem(SIZEOF drawinfo+9,MEMF_ANY OR MEMF_CLEAR)
        dri.depth:=screen.bitmap.depth
        IF dri.depth>1 THEN newlook:=TRUE
        dri.version:=1 -> corresponds to V37 release
        dri.numpens:=9
        dri.pens:=dri+SIZEOF drawinfo
        dri.pens[DETAILPEN]:=screen.detailpen
        dri.pens[BLOCKPEN]:=screen.blockpen
        dri.pens[TEXTPEN]:=1
        dri.pens[SHINEPEN]:=IF newlook THEN 2 ELSE 1
        dri.pens[SHADOWPEN]:=1
        dri.pens[FILLPEN]:=IF newlook THEN 3 ELSE 1
        dri.pens[FILLTEXTPEN]:=IF newlook THEN 1 ELSE 0
        dri.pens[BACKGROUNDPEN]:=0
        dri.pens[HIGHLIGHTTEXTPEN]:=IF newlook THEN 2 ELSE 1
        dri.font:=screen.font
        dri.resolutionx:=44
        dri.resolutiony:=44
        dri.flags:=IF newlook THEN DRIF_NEWLOOK ELSE NIL
      ENDIF
    ENDIF
  ENDIF
ENDPROC dri

PROC freeScreenDrawInfo(screen:PTR TO screen,dri)
  IF intuiVersion(36)
    FreeScreenDrawInfo(screen,dri)
  ELSE
    IF dri THEN FreeMem(dri,SIZEOF drawinfo+9)
  ENDIF
ENDPROC
