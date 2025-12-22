/*

  Example for ScrBuffer.m double buffered screen module

  by Michael Zucchi, 1994 this code in the public domain

 */


MODULE 'intuition/intuition', 'intuition/screens',
    'graphics/rastport',
    'tools/scrbuffer'

DEF bscr, scr:PTR TO screen, win:PTR TO window

PROC main()

DEF x,y,x2,y2,x3,y3, dx, dy, rp, myrp:rastport, c, go, im:PTR TO intuimessage

bscr:=sb_OpenScreen([SA_WIDTH, 320, SA_HEIGHT, 256, SA_DEPTH, 4,
   SA_OVERSCAN, OSCAN_STANDARD, SA_AUTOSCROLL, -1, SA_PENS, [-1]:INT, 0], 0);

-> find the screen we are using, and make a copy of the rastport so we can use it
scr:=sb_GetScreen(bscr);
CopyMem(scr.rastport, myrp, SIZEOF rastport);
myrp.layer:=0;      -> must set layer to 0 'cause we dont have one!

-> open a window so we can get REAL input events
win:=OpenWindowTagList(0, [WA_CUSTOMSCREEN, scr, WA_BACKDROP, -1,
 WA_FLAGS, WFLG_BORDERLESS+WFLG_ACTIVATE+WFLG_RMBTRAP,
 WA_IDCMP, IDCMP_VANILLAKEY, 0]);

dx:=2;dy:=1;
x:=50;y:=50;   -> position
x2:=0;y2:=0;
x3:=0;y3:=0;   -> where to erase
c:=1      -> colour
go:=1;

WHILE go
  IF (im:=GetMsg(win.userport))      -> get any vanillakey events
    IF im.class=IDCMP_VANILLAKEY AND im.code=27 THEN go:=0;
    ReplyMsg(im);
  ENDIF

  myrp.bitmap:=sb_NextBuffer(bscr);   -> change screen buffers, and get its bitmap

  SetAPen(myrp, 0);         -> erase the old image
  RectFill(myrp, x3, y3, x3+100, y3+50);
  SetAPen(myrp, c);         -> draw the new box
  RectFill(myrp, x, y, x+100, y+50);

  Move(myrp, 50,50);
  Text(myrp, 'ESC to quit!', 12);

  x3:=x2;y3:=y2;         -> roll coordinates
  x2:=x;y2:=y;

  x:=x+dx;            -> new position
  y:=y+dy;

  IF (x>(320-110)) OR (x<10)      -> bounce the box off of walls
    dx:=-dx;c++
  ENDIF
  IF (y>(256-60)) OR (y<10)
    dy:=-dy;c++
  ENDIF
ENDWHILE

-> clean up.  In 'real life' all the open functions would be tested after use
CloseWindow(win);
sb_CloseScreen(bscr);

ENDPROC

