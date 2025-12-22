/* An ECX example converted to PortablE.
   Included with permission from Leif. */

/*
**    cosmic_deluxe.e - Generates cosmic flame fractals :-)
**
**    Based on cosmic.e, this version uses more colours, more detail
**    and is alot slower :) Also removed accesses to customchips.
**    Copyright © 2004 Leif Salomonsson.
**
**    Copyright © 1996 by Chris Sumner
**
**
**    Cosmic flame fractal code derived from FracBlank source code
**    Copyright © 1991-1992 by Olaf `Olsen' Barthel
**
**    Cosmic flame fractal code derived from xlock source code
**    Copyright © 1988-1991 by Patrick J. Naughton.
**
**   Permission to use, copy, modify, and distribute this software and its
**   documentation for any purpose and without fee is hereby granted,
**   provided that the above copyright notice appear in all copies and that
**   both that copyright notice and this permission notice appear in
**   supporting documentation.
*/

/* MorphOS PPC version by LS 2004, uses REAL so needs ECX */

OPT POINTER
OPT PREPROCESS
OPT STACK=700000

MODULE '*macros'

MODULE 'graphics/modeid'
MODULE 'intuition/intuitionbase','intuition/intuition','intuition/screens'
MODULE 'utility/tagitem'
MODULE 'intuition', 'graphics', 'exec', 'dos'

RAISE "^C" IF CtrlC()=TRUE
RAISE "STCK" IF FreeStack() <= 4000

CONST MAXFLAMELEVEL   = 25
CONST MAXTOTALPOINTS  = 200000
CONST FLAME_SIZE      = 50
CONST WIDTH = 800, HEIGHT = 600, NUMCOLOURS = 256


DEF flame[FLAME_SIZE]:ARRAY OF FLOAT
DEF points,alternate,count,colr=1

DEF win:PTR TO window
DEF scr:PTR TO screen
DEF rp:PTR TO rastport

DEF cols:ARRAY OF VALUE -> used to be static

PROC main()
  openiface()
  LOOP
    cosmic()
    IF LeftMouse(win) THEN RETURN
  ENDLOOP
FINALLY
  closeiface()
  ExceptionReport('main()')
ENDPROC

PROC cosmic()
DEF ib:PTR TO intuitionbase
DEF x,r

  ib:=intuitionbase !!PTR!!PTR TO intuitionbase
  r:=ib.micros XOR ib.seconds OR %1
  Rnd(r)


  SetAPen(rp,colr++)
  IF colr = NUMCOLOURS THEN colr:=1

  x:=0
  WHILE x<FLAME_SIZE
    flame[x]:=Rnd(32768)/16384.0-1.0*0.9
    x++
  ENDWHILE

  alternate:= (r AND 4) = 0
  points:=0
  recurse(0.0,0.0,0)


  IF (count++ AND 7)=NIL
    Delay(120)
    SetRast(rp,0)
    colr:=Rnd(NUMCOLOURS-2)+1
  ENDIF

ENDPROC

PROC recurse(x:FLOAT,y:FLOAT,level)
   DEF f:ARRAY OF FLOAT
   DEF nx:FLOAT,ny:FLOAT

  FreeStack()

  f:=flame


  IF level>=MAXFLAMELEVEL
    IF (points++)>MAXTOTALPOINTS THEN RETURN FALSE
    IF Fabs(x) < 1.0
       IF Fabs(y) < 1.0
         WritePixel(rp,x+1.0*(WIDTH/2)!!LONG,y+1.0*(HEIGHT/2)!!LONG)
       ENDIF
    ENDIF
  ELSE

    nx:=(f[0]*x)+(f[1]*y)+(f[2]*f[3])
    ny:=(f[4]*x)+(f[5]*y)+(f[6]*f[7])

    IF alternate
      nx:=Fsin(nx)
      ny:=Fcos(ny)
    ENDIF

    IF recurse(nx,ny,level+1)=FALSE THEN RETURN FALSE


    nx:=(f[ 8]*x)+(f[ 9]*y)+(f[10]*f[11])
    ny:=(f[12]*x)+(f[13]*y)+(f[14]*f[15])

    IF alternate
      nx:=Fcos(nx)
      ny:=Fsin(ny)
    ENDIF

    IF recurse(nx,ny,level+1)=FALSE THEN RETURN FALSE



  ENDIF
ENDPROC TRUE



->----------------------------------------------------------------------------<-

PROC openiface()
   DEF tags:ARRAY OF tagitem
   DEF a, ib:PTR TO intuitionbase
  /* generate random colourable */
  ib := intuitionbase !!PTR!!PTR TO intuitionbase
  Rnd(-(ib.micros XOR ib.seconds OR %1))
  NEW cols[1+(NUMCOLOURS*3)+1]
  PutInt(cols !!VALUE!!PTR TO INT, NUMCOLOURS)
  PutInt(cols+2 !!VALUE!!PTR TO INT, 0)
  FOR a := 4 TO NUMCOLOURS*3 DO cols[a] := Shl(Rnd(200)+50,24)

  TagInit(tags)
  Tag(SA_WIDTH,WIDTH)
  Tag(SA_HEIGHT,HEIGHT)
  Tag(SA_DEPTH,8)
  Tag(SA_TYPE,CUSTOMSCREEN)
  Tag(SA_DISPLAYID,HIRESLACE_KEY)
  Tag(SA_SHOWTITLE,FALSE)
  Tag(SA_OVERSCAN,OSCAN_STANDARD)
  Tag(SA_COLORS32,cols)
  Tag(SA_INTERLEAVED,TRUE)
  TagDone

  scr:=OpenScreenTagList(NIL,tags)
  IF scr=NIL THEN Raise("scrn")

  TagInit(tags)
  Tag(WA_WIDTH,WIDTH)
  Tag(WA_HEIGHT,HEIGHT)
  Tag(WA_CLOSEGADGET,FALSE)
  Tag(WA_DRAGBAR,FALSE)
  Tag(WA_DEPTHGADGET,FALSE)
  Tag(WA_NOCAREREFRESH,TRUE)
  Tag(WA_BORDERLESS,TRUE)
  Tag(WA_BACKDROP,TRUE)
  Tag(WA_CUSTOMSCREEN,scr)
  Tag(WA_RMBTRAP,TRUE)
  TagDone

  win:=OpenWindowTagList(NIL,tags)
  IF win=NIL THEN Raise("wndw")

  rp:=win.rport
  SetStdRast(rp)

ENDPROC

PROC closeiface()
  CloseWindow(win)
  CloseScreen(scr)
ENDPROC
