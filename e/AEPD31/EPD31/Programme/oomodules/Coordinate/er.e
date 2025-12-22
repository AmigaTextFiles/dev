/*

Just opens a tiny window and rotates a line. Use it to see if your
kite's still running :)

*/

OPT PREPROCESS

MODULE 'oomodules/coordinate/line2', 'oomodules/coordinate', 'intuition/intuition',
        'oomodules/sort/number/float'

#define NULL_X (30)
#define NULL_Y (15)

DEF hauptwin:PTR TO window, /* Hauptfenster */
    meineintmessage:PTR TO intuimessage /* Kopie der intmsg */



PROC main()
DEF coo:PTR TO coordinate,co2:PTR TO coordinate,
    line:PTR TO line,flt:PTR TO float

  NEW coo.new(["set",0.0,0.0,0.0])
  NEW co2.new(["set",30.0,30.0,0.0])

  NEW flt.new()
  flt.set(2.0)

  NEW line.new()

  line.setStart(coo)

  line.setEnd(coo)
  line.end.shift(co2)

  co2.x.neg()
  co2.y.neg()
  co2.z.neg()
  line.shift(co2)

  hauptwin := OpenWindowTagList(NIL,
  [WA_TITLE,'ER',
   WA_IDCMP,IDCMP_RAWKEY OR IDCMP_CLOSEWINDOW OR IDCMP_MOUSEMOVE OR IDCMP_GADGETUP OR IDCMP_GADGETDOWN OR IDCMP_MOUSEBUTTONS OR IDCMP_MENUPICK OR IDCMP_REFRESHWINDOW,
   WA_FLAGS,WFLG_ACTIVATE+WFLG_CLOSEGADGET+WFLG_DRAGBAR+WFLG_DEPTHGADGET,
   WA_INNERWIDTH, 90, WA_INNERHEIGHT, 50,
   WA_REPORTMOUSE,TRUE,WA_GIMMEZEROZERO,TRUE,NIL])

  SetStdRast(hauptwin.rport)

  REPEAT
    meineintmessage := GetMsg(hauptwin.userport)

    line.rotateZ(3.0)

    line.x.add(flt)
->    line.y.substract(flt)

    Line(NULL_X+(!line.getX()!/2),NULL_Y+(!line.getY()!/4),
         NULL_X+(!line.end.getX()!/2)  ,NULL_Y+(!line.end.getY()!/4))
    WaitTOF()
    Line(NULL_X+(!line.getX()!/2),NULL_Y+(!line.getY()!/4),
         NULL_X+(!line.end.getX()!/2)  ,NULL_Y+(!line.end.getY()!/4),0)

  UNTIL (meineintmessage.class = IDCMP_CLOSEWINDOW)

  CloseWindow(hauptwin)

  CleanUp(0)

ENDPROC
