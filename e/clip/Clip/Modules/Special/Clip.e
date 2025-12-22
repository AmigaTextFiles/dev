OPT MODULE

MODULE 'intuition/intuition',
       'utility/tagitem',
       'graphics/gfx',
       'layers'

EXPORT PROC clip(window:PTR TO window,x,y,xx,yy)
  DEF region,rectangle
  rectangle:=[x,y,xx,yy]:rectangle
  IF region:=NewRegion()
    IF OrRectRegion(region,rectangle)=FALSE
      DisposeRegion(region)
      region:=NIL
    ENDIF
  ENDIF
ENDPROC InstallClipRegion(window.wlayer,region)

EXPORT PROC unclip(window:PTR TO window)
  DEF old_region
  IF old_region:=InstallClipRegion(window.wlayer,NIL)
    DisposeRegion(old_region)
  ENDIF
ENDPROC
