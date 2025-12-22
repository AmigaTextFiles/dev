OPT NOHEAD,NOEXE,CPU='WUP'
MODULE 'graphics','graphics/gfxbase','intuition/screens'
PROC SetColour(scr:PTR TO Screen,n,r,g,b)
  IF GfxBase::GfxBase.LibNode.Version<39
    SetRGB4(scr.RastPort,n,r>>4,g>>4,b>>4)
  ELSE
    SetRGB32(scr.RastPort,n,r<<24,g<<24,b<<24)
  ENDIF
ENDPROC
