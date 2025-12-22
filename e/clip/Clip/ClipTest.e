OPT OSVERSION=37

MODULE 'intuition/intuition',
       'intuition/screens',
       'utility/tagitem',
       'graphics/gfx',
       'graphics/rastport',
       'layers'
MODULE 'special/clip'

DEF window:PTR TO window,
    wb:PTR TO screen

PROC main()
  IF layersbase:=OpenLibrary('layers.library',37)
    IF wb:=LockPubScreen('Workbench')
      IF window:=OpenWindowTagList(NIL,
        [WA_LEFT,100,
         WA_TOP,28,
         WA_WIDTH,440,
         WA_HEIGHT,200,
         WA_IDCMP,IDCMP_CLOSEWINDOW,
         WA_FLAGS,WFLG_DRAGBAR OR
                  WFLG_ACTIVATE OR
                  WFLG_RMBTRAP,
         WA_TITLE,'Clip Test',
         WA_SCREENTITLE,'Workbench Screen',
         TAG_END])
        SetStdRast(window.rport)
        clip(window,window.borderleft,window.bordertop,window.width-window.borderright-1,window.height-window.borderbottom-1)
        REPEAT
          BltBitMapRastPort(wb.rastport.bitmap,0,0,window.rport,MouseX(window)-(wb.width/2),MouseY(window)-(wb.height/2),wb.width,wb.height,$c0)
        UNTIL Mouse()=2
        unclip(window)
        CloseWindow(window)
      ELSE
        WriteF('Can`t open window!\n')
      ENDIF
      UnlockPubScreen(NIL,wb)
    ELSE
      WriteF('Can`t lock workbench!\n')
    ENDIF
    CloseLibrary(layersbase)
  ELSE
    WriteF('Can`t open layers.library v37+!\n')
  ENDIF
ENDPROC
