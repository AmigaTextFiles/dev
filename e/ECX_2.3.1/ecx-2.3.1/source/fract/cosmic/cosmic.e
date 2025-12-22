/*
**    cosmic.e - Generates cosmic flame fractals :-)
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

/* MorphOS version by LS 2004 */

OPT PREPROCESS

MODULE '*macros'

MODULE 'graphics/modeid'
MODULE 'intuition/intuitionbase','intuition/intuition','intuition/screens'
MODULE 'utility/tagitem'

RAISE "^C" IF CtrlC()=TRUE

CONST MAXFLAMELEVEL   = 15
CONST MAXTOTALPOINTS  = 20000

CONST FLAME_SIZE      = 12

DEF flame[FLAME_SIZE]:ARRAY OF LONG
DEF points,alternate,count,colr

DEF win:PTR TO window
DEF scr:PTR TO screen
DEF rp

PROC main() HANDLE
  openiface()
  LOOP
    cosmic()
  ENDLOOP
EXCEPT
  closeiface()
  ExceptionReport('main()')
ENDPROC

PROC cosmic()
DEF ib:PTR TO intuitionbase
DEF x,r

  ib:=intuitionbase
  r:=/*Eor(*/Eor(ib.micros,ib.seconds)->,Shl(Int($dff006),16)) OR Shl(1,31)
  Rnd(r)

  SetAPen(rp,colr++)
  IF colr>7 THEN colr:=1

  x:=0
  WHILE x<FLAME_SIZE
    ->IF (Int($dff006) AND 8) THEN Rnd(45)
    flame[x]:=Rnd(32768)!/16384.0-1.0
    x++
  ENDWHILE

  alternate:=(r/*Int($dff006)*/ AND 4)=0
  points:=0
  recurse(0.0,0.0,0)

  IF (count++ AND 7)=NIL
    Delay(100)
    SetRast(rp,0)
    colr:=Rnd(7)+1
  ENDIF

ENDPROC

PROC recurse(x,y,level)
DEF f:PTR TO LONG
DEF nx,ny

  CtrlC()

  f:=flame

  IF level>=MAXFLAMELEVEL
    IF (points++)>MAXTOTALPOINTS THEN RETURN FALSE
    WritePixel(rp,!x+1.0*320.0!,!y+1.0*256.0!)
  ELSE

    nx:=!(!f[]++*x)+(!f[]++*y)+f[]++
    ny:=!(!f[]++*x)+(!f[]++*y)+f[]++

    IF alternate
      nx:=Fsin(nx)
      ny:=Fsin(ny)
    ENDIF

    IF recurse(nx,ny,level+1)=FALSE THEN RETURN FALSE


    nx:=!(!f[]++*x)+(!f[]++*y)+f[]++
    ny:=!(!f[]++*x)+(!f[]++*y)+f[]++

    IF alternate
      nx:=Fsin(nx)
      ny:=Fsin(ny)
    ENDIF

    IF recurse(nx,ny,level+1)=FALSE THEN RETURN FALSE


  ENDIF
ENDPROC TRUE


->----------------------------------------------------------------------------<-


cols:
      ColorRange(0,8)     -> Start at #0, 8 colours
      Color(0,0,0)        -> Black
      Color(0,255,0)      -> Green
      Color(255,0,0)      -> Red
      Color(255,128,0)    -> Orange
      Color(255,255,0)    -> Yellow
      Color(0,255,255)    -> Cyan
      Color(255,0,255)    -> Magenta
      Color(0,0,255)      -> Blue
      ColorEnd

PROC openiface()
DEF tags:PTR TO LONG

  TagInit(tags)
  Tag(SA_WIDTH,640)
  Tag(SA_HEIGHT,512)
  Tag(SA_DEPTH,3)
  Tag(SA_TYPE,CUSTOMSCREEN)
  Tag(SA_DISPLAYID,HIRESLACE_KEY)
  Tag(SA_SHOWTITLE,FALSE)
  Tag(SA_OVERSCAN,OSCAN_STANDARD)
  Tag(SA_COLORS32,ADDR(cols))
  Tag(SA_INTERLEAVED,TRUE)
  TagDone

  scr:=OpenScreenTagList(NIL,tags)
  IF scr=NIL THEN Raise("scrn")

  TagInit(tags)
  Tag(WA_WIDTH,640)
  Tag(WA_HEIGHT,512)
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

ENDPROC

PROC closeiface()
  CloseWindow(win)
  CloseScreen(scr)
ENDPROC
