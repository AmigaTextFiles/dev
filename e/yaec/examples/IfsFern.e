/* iterated affine transformations 

   gets you a leaf on the screen in a rather special way.
   be patient: it may take some time for you to actually see something.

*/


OPT OSVERSION=39  /* oh, and we need a 640*512*256 screen */

CONST SCRX=740, SCRY=580, PLANES=8

OBJECT trans
  a:FLOAT,b:FLOAT,c:FLOAT,d:FLOAT,ox:FLOAT,oy:FLOAT,prob
ENDOBJECT

DEF win

PROC main()
  DEF a
  win:=OpenW(0,0,SCRX-1,SCRY-1,$200,$E,'Fern',NIL,1,NIL)
  IF win=NIL
     WriteF('Could not open window!\n')
  ELSE
     do([[ .0,   .0,   .0,   .16, .0,  .0,  1 ]:trans,   -> back to the root!
         [ .2,   .23, -.26,  .22, .0, 1.6,  7 ]:trans,   -> right leaf
         [-.15,  .26,  .28,  .24, .0,  .44, 7 ]:trans,   -> left leaf
        [ .85, -.04,  .04,  .85, .0, 1.6,  85]:trans])  -> body
     WaitIMessage(win)
     CloseW(win)
  ENDIF
ENDPROC

PROC do(t:PTR TO LIST)
  DEF x=1.0:FLOAT,y=1.0:FLOAT,r:LONG,n:LONG,a:LONG,tr:PTR TO trans
  DEF xn:FLOAT,yn:FLOAT,sx,sy,d:LONG
  REPEAT
    r:=Rnd(100)
    n:=0
    FOR a:=1 TO ListLen(t)
      tr:=t[a-1]
    EXIT (r>=n) AND ((tr.prob+n)>r)
      n:=n+tr.prob
    ENDFOR
    sx:=((xn:=(tr.a*x)+(tr.c*y)+tr.ox)*60.)!+(SCRX/2)
    sy:=SCRY - ((( yn:=(tr.b*x)+(tr.d*y)+tr.oy )*50.)!)
    d:=Bounds(ReadPixel(stdrast,sx,sy)+20,64,255)
    Plot(sx,sy,d)
    x:=xn; y:=yn
  UNTIL LeftMouse(win)
ENDPROC

