MODULE 'intuition/intuition', 'intuition/screens'

PROC main()
  DEF sn:PTR TO screen, firstscreen:PTR TO screen, wn:PTR TO window
  IF (firstscreen:=LockPubScreen(NIL))
    sn:=firstscreen
    WHILE sn
      PrintF('\e[42m\s\e[40m:\t\s\n', sn.defaulttitle, sn.title)
      wn:=sn.firstwindow
      WHILE wn
        IF StrCmp(wn.title,'')=-1
          PrintF('\t**No title**\n')
        ELSE
          PrintF('\t\s\n', wn.title)
        ENDIF
        wn:=wn.nextwindow
      ENDWHILE
      sn:=sn.nextscreen
    ENDWHILE
    UnlockPubScreen(NIL,firstscreen)
  ENDIF
ENDPROC
