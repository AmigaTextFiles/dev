
MODULE 'intuition/intuition'
MODULE 'graphics/rastport'
MODULE 'graphics/text'
MODULE 'diskfont'

PROC main()

DEF fortune, class
DEF eightwin:PTR TO window
DEF arinf:PTR TO areainfo
DEF artmpras:PTR TO tmpras
DEF arcoords[60]:ARRAY
DEF armem
DEF myrast:PTR TO rastport
DEF myitext:PTR TO intuitext
DEF mytextattr:PTR TO textattr
DEF myfont:PTR TO textfont

  IF diskfontbase := OpenLibrary('diskfont.library',36)
    mytextattr := ['times.font',18,0,1]:textattr
    myfont := OpenDiskFont(mytextattr)
    CloseLibrary(diskfontbase)
  ENDIF

  Rnd(-VbeamPos())

  IF eightwin := OpenW(0,0,200,210,
                       (IDCMP_MOUSEBUTTONS OR IDCMP_CLOSEWINDOW),
                       (WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR
                        WFLG_CLOSEGADGET OR WFLG_ACTIVATE),
                       'Magic 8 Ball',0,1,0)

    fortune := ['Cannot predict now',
                'Better not tell you now',
                'Reply hazy try again',
                'Concentrate & ask again',
                'Ask again later',
                'My sources say no',
                'Outlook not so good',
                'My reply is no',
                'Don''t count on it',
                'Very doubtful',
                'No',
                'It is certain',
                'Signs point to yes',
                'Most likely',
                'It is decidedly so',
                'Outlook good',
                'Yes, definitely',
                'As I see it, yes',
                'You may rely on it',
                'Yes']

    arinf := New(SIZEOF areainfo)
    artmpras := New(SIZEOF tmpras)
    myrast := stdrast

    IF armem := AllocRaster(eightwin.width, eightwin.height)

      InitTmpRas(artmpras, armem, 5000)
      InitArea(arinf, arcoords, 6)

      myrast.tmpras := artmpras
      myrast.areainfo := arinf

      SetAPen(stdrast,1)
      SetBPen(stdrast,0)
      /*SetOPen(stdrast,4)*/
      /*myrast.aolpen := 7    Neither of these seem to work */
      AreaMove(stdrast,100,100)
      AreaEllipse(stdrast,100,110,92,92)
      AreaEnd(stdrast)

      IF myfont<>0 THEN SetFont(stdrast,myfont)
      Colour(7,1)
      myitext := [7,1,RP_JAM2,NIL,103,mytextattr,NIL,0]:intuitext

      WHILE (class := WaitIMessage(eightwin)) <> IDCMP_CLOSEWINDOW

        IF (class=IDCMP_MOUSEBUTTONS) AND (MsgCode()=SELECTUP)
          /*TextF(46,108,'\s',ListItem(fortune,(Rnd(8))) )*/
          myitext.itext := ListItem(fortune,(Rnd(20)))
          myitext.leftedge := 100-(IntuiTextLength(myitext)/2)
          PrintIText(myrast, myitext, 0, 0)
          Delay(75)
          Box(9,94,190,120,1)
        ENDIF

      ENDWHILE

      FreeRaster(armem, eightwin.width, eightwin.height)

    ELSE
      TextF(70,100,'No mem for circle drawing!')
      Delay(75)

    ENDIF

    IF myfont THEN CloseFont(myfont)
    CloseW(eightwin)

  ENDIF

  CleanUp(0)
ENDPROC
