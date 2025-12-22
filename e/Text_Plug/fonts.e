OPT OSVERSION=37, MODULE

MODULE 'exec/nodes',
       'exec/ports',
       'graphics/gfxbase',
       'graphics/rastport',
       'graphics/text',
       'intuition/screens'

RAISE "FONT" IF OpenFont()=NIL,
      "PUBS" IF LockPubScreen()=NIL

EXPORT DEF deffixedfont:PTR TO textfont, deffont:PTR TO textfont

EXPORT PROC getdeffonts() HANDLE
  DEF scr=NIL:PTR TO screen, gfx:PTR TO gfxbase
  IF deffixedfont=NIL
    gfx:=gfxbase
    deffixedfont:=OpenFont([gfx.defaultfont.mn.ln.name, gfx.defaultfont.ysize,
                            0, 0]:textattr)
  ENDIF
  IF deffont=NIL
    scr:=LockPubScreen('Workbench')
    deffont:=OpenFont(scr.font)
  ENDIF
EXCEPT DO
  IF scr THEN UnlockPubScreen(NIL, scr)
  IF exception
    freedeffonts()
  ENDIF
  ReThrow()
ENDPROC

EXPORT PROC freedeffonts()
  IF deffixedfont
    CloseFont(deffixedfont)
    deffixedfont:=NIL
  ENDIF
  IF deffont
    CloseFont(deffont)
    deffont:=NIL
  ENDIF
ENDPROC