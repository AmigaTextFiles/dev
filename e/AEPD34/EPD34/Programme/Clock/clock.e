/*
  clock.e

  Author: Horst Schumann
          Helmstedter Str. 18
          39167 Irxleben
          Germany

          e-mail: hschuman@cs.uni-magdeburg.de (until June, 1996)


  A little clock program written with Amiga E
  -------------------------------------------

  Thanks to Wouter van Oortmerssen for the programming environment
  of Amiga E (and for the release of version 3.2a with which my
  code for the timer.device finally worked).

  This is just an example for an analogue clock. I tried to do it
  as system friendly as possible, but a few calculations are still
  in there that take some time, so the system is getting slower,
  if the program is running more than 10 times simultaneously.
  That might be due to some trigonometric calculations. (I did not
  want to put in a look-up table to keep the program small.)

  As stated before, this is a simple clock program. I wrote it in
  E just to try the language and to have a clock I can customize
  to my personal preferences. These personal things are not in
  this release, but maybe in the future I release it again as
  shareware, when I added some features. Here it is for the
  E-community to work with. Maybe it is included in the Amiga E
  distribution in the future.

  Bugs: - might be possible to optimize further
        - when resizing the window, sometimes the lines are drawn
          in the window borders (rather ugly)
*/

MODULE 'intuition/screens',
       'devices/timer',
       'intuition/intuition',
       'exec/ports',
       'exec/io',
       'graphics/text'

DEF  win:PTR TO window,           -> pointer to window structure
     hourlen=0.5,                 -> \
     minutelen=0.8,               ->  > relative length of hands
     secondlen=0.9,               -> /
     pi_div_6=0.52359,            -> value for PI/6 (for speed)
     pi_div_30=0.10471,           -> value for PI/30 (for speed)
     hour,minute,second,micro,    -> kind of obvious
     oldhour=0,                   -> \
     oldminute=0,                 ->  > time of last get_time
     oldsecond=0,                 -> /
     midx,midy,                   -> center of window x and y
     radx,rady                    -> length from center to border

PROC main()
DEF screen:PTR TO screen,         -> pointer to screen structure
    tr:PTR TO timerequest,        -> timerequest structure
    imess:PTR TO intuimessage,    -> intuition message dtructure
    msg:PTR TO mp,                -> pointer to message port
    quit=FALSE,                   -> flag for main loop
    sig,                          -> space for signal bits
    class                         -> message class

  IF screen:=(LockPubScreen(NIL))
    IF win:=OpenWindowTagList(NIL,
                             [WA_TOP,         screen.height/2,
                              WA_LEFT,        screen.width/2,
                              WA_WIDTH,       screen.width/6,
                              WA_HEIGHT,      screen.height/4,
                              WA_CLOSEGADGET, TRUE,
                              WA_ACTIVATE,    TRUE,
                              WA_DRAGBAR,     TRUE,
                              WA_DEPTHGADGET, TRUE,
                              WA_SIZEBBOTTOM, TRUE,
                              WA_SIZEGADGET,  TRUE,
                              WA_MINHEIGHT,   60,
                              WA_MINWIDTH,    90,
                              WA_MAXHEIGHT,   -1,
                              WA_MAXWIDTH,    -1,
                              WA_IDCMP,       IDCMP_CLOSEWINDOW OR
                                              IDCMP_CHANGEWINDOW,
                              WA_TITLE,       'Simple E Clock',
                              0,0]) /* */
      SetStdRast(win.rport)
      /*
        claculate the center of the window and the distance
        from there to the borders
      */
      radx:=win.width-win.borderleft-win.borderright/2-1
      midx:=radx+win.borderleft
      rady:=win.height-win.bordertop-win.borderbottom/2-1
      midy:=rady+win.bordertop
      dialplate()
      IF msg:=CreateMsgPort()    -> create port for timer
        IF tr:=CreateIORequest(msg,SIZEOF timerequest)
          IF OpenDevice('timer.device',UNIT_MICROHZ,tr,0)=0
            tr.io.command:=TR_ADDREQUEST
            tr.time.secs:=0
            tr.time.micro:=1000000-micro
            SendIO(tr)
            sig:=0
            WHILE quit=FALSE
              class:=NIL
              IF sig AND Shl(1,win.userport.sigbit)
                IF imess:=GetMsg(win.userport)
                  class:=imess.class
                  IF class=IDCMP_CHANGEWINDOW
                    radx:=win.width-win.borderleft-win.borderright/2-1
                    midx:=radx+win.borderleft
                    rady:=win.height-win.bordertop-win.borderbottom/2-1
                    midy:=rady+win.bordertop
                    dialplate()
                  ENDIF
                  IF class=IDCMP_CLOSEWINDOW
                    quit:=TRUE
                  ENDIF
                  ReplyMsg(imess)
                ENDIF
              ENDIF
              IF sig AND Shl(1,msg.sigbit)
                IF GetMsg(msg)=tr
                  get_time()
                  tr.time.secs:=0
                  tr.time.micro:=1000000-micro   -> wait for next second
                  SendIO(tr)
                  clock()
                ENDIF
              ENDIF
                IF quit
                  AbortIO(tr)
                  WaitIO(tr)
                ELSE
                  sig:=Wait(Shl(1,msg.sigbit) OR Shl(1,win.userport.sigbit))
                ENDIF
            ENDWHILE
            CloseDevice(tr)
          ENDIF -> if OpenDevice
          DeleteIORequest(tr)
        ENDIF -> if CreateIORequest
        DeleteMsgPort(msg)
      ENDIF     -> if CreateMsgPort
      CloseWindow(win)
    ENDIF -> if OpenWindow
    UnlockPubScreen(NIL,screen)
  ENDIF   -> if LockPubScreen
ENDPROC


PROC get_time()            -> puts the current time into global variables
                           -> hour, minute, second and updates
                           -> oldhour, oldminute, oldsecond

DEF curtime                -> space for current time

  CurrentTime({curtime},{micro})
  oldsecond:=second                             -> save last value
  second:=curtime-Mul(Div(curtime,86400),86400) -> take days out of number
  oldhour:=hour                                 -> save last value
  hour:=Div(second,3600)                        -> calculate hours of day
  second:=second-Mul(hour,3600)                 -> take hours out
  oldminute:=minute                             -> save last value
  minute:=Div(second,60)                        -> get the mins of the hour
  second:=second-Mul(minute,60)                 -> take mins out leave secs
ENDPROC


PROC clock()               -> erase old display, if necessary
                           -> and redraw with new values

DEF xoff,yoff,             -> x and y offsets from center
    hrad,mrad,srad         -> radians for hour, minute ands second

  /*
    convert to radians (minus 1.57... to normalize)
  */
  srad:=second!*pi_div_30-1.57075
  hrad:=hour!+(minute!/60.0)*pi_div_6-1.57075
  mrad:=minute!*pi_div_30-1.57075

  /*
    erase changed hands
  */
  IF second<>oldsecond
    xoff:=(radx)!*secondlen*Fcos(oldsecond!*pi_div_30-1.57075)!
    yoff:=(rady)!*secondlen*Fsin(oldsecond!*pi_div_30-1.57075)!
    Line(midx,midy,midx+xoff,midy+yoff,0)
  ENDIF
  IF minute<>oldminute
    xoff:=(radx)!*minutelen*Fcos(oldminute!*pi_div_30-1.57075)!
    yoff:=(rady)!*minutelen*Fsin(oldminute!*pi_div_30-1.57075)!
    Line(midx,midy,midx+xoff,midy+yoff,0)
  ENDIF
  IF hour<>oldhour OR minute<>oldminute
    xoff:=(radx)!*hourlen*Fcos(oldhour!+(oldminute!/60.0)*pi_div_6-1.57075)!
    yoff:=(rady)!*hourlen*Fsin(oldhour!+(oldminute!/60.0)*pi_div_6-1.57075)!
    Line(midx,midy,midx+xoff,midy+yoff,0)
  ENDIF

  /*
    redraw hands
  */
  xoff:=(radx)!*secondlen*Fcos(srad)!
  yoff:=(rady)!*secondlen*Fsin(srad)!
  Line(midx,midy,midx+xoff,midy+yoff,3)    -> second hand
  xoff:=(radx)!*minutelen*Fcos(mrad)!
  yoff:=(rady)!*minutelen*Fsin(mrad)!
  Line(midx,midy,midx+xoff,midy+yoff,2)    -> minute hand
  xoff:=(radx)!*hourlen*Fcos(hrad)!
  yoff:=(rady)!*hourlen*Fsin(hrad)!
  Line(midx,midy,midx+xoff,midy+yoff,1)    -> hour hand
ENDPROC


PROC dialplate()           -> clear window and draw dialpate

DEF xoff,yoff,xoff2,yoff2, -> x and y offsets from center
    marks,                 -> counter variable
    angle                  -> angle in radians

  /*
    erase window contents
  */
  SetAPen(win.rport,0)
  RectFill(win.rport,win.borderleft,
                     win.bordertop,
                     win.width-win.borderright-1,
                     win.height-win.borderbottom-1)

  /*
    draw hour marks as dialplate
  */
  FOR marks:=1 TO 12
    angle:=marks!*pi_div_6-1.57075
    xoff:=(radx)!*0.95*Fcos(angle)!
    yoff:=(rady)!*0.95*Fsin(angle)!
    xoff2:=(radx)!*Fcos(angle)!
    yoff2:=(rady)!*Fsin(angle)!
    Line(midx+xoff,midy+yoff,midx+xoff2,midy+yoff2,1)
  ENDFOR
  get_time()
  clock()
ENDPROC
