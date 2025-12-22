/* An old YAEC example converted to PortablE.
   Included with permission from Leif. */

/* iterated affine transformations 

   gets you a leaf on the screen in a rather special way.
   be patient: it may take some time for you to actually see something.

*/

->OPT OSVERSION=39  /* oh, and we need a 640*512*256 screen */
MODULE 'intuition', 'graphics'

CONST SCRX=740, SCRY=580, PLANES=8

OBJECT trans
  a:FLOAT,b:FLOAT,c:FLOAT,d:FLOAT,ox:FLOAT,oy:FLOAT,prob
ENDOBJECT

DEF win:PTR TO window

PROC main()
  win:=OpenW(0,0,SCRX-1,SCRY-1,$200,$E,'Fern',NIL,1,NIL)
  IF win=NIL
     Print('Could not open window!\n')
  ELSE
     do([[ 0.0,   0.0,   0.0,   0.16, 0.0, 0.0,  1 ]:trans,   -> back to the root!
         [ 0.2,   0.23, -0.26,  0.22, 0.0, 1.6,  7 ]:trans,   -> right leaf
         [-0.15,  0.26,  0.28,  0.24, 0.0, 0.44, 7 ]:trans,   -> left leaf
         [ 0.85, -0.04,  0.04,  0.85, 0.0, 1.6,  85]:trans])  -> body
     WaitIMessage(win)
     CloseW(win)
  ENDIF
ENDPROC

PROC do(t:ILIST)
  DEF x:FLOAT,y:FLOAT,r,n,a,tr:PTR TO trans
  DEF xn:FLOAT,yn:FLOAT,sx,sy,d
  DEF exit
  x:=1.0 ; y:=1.0
  REPEAT
    r:=Rnd(100)
    n:=0
    FOR a:=1 TO ListLen(t)
      tr:=t[a-1]::trans
      exit:=(r>=n) AND ((tr.prob+n)>r)
      IF NOT exit THEN n:=n+tr.prob
    ENDFOR IF exit
    sx:=((xn:=(tr.a*x)+(tr.c*y)+tr.ox)*60.0)!!VALUE +(SCRX/2)
    sy:=SCRY - ((( yn:=(tr.b*x)+(tr.d*y)+tr.oy )*50.0)!!VALUE)
    d:=Bounds(ReadPixel(stdrast,sx,sy)+20,64,255)
    Plot(sx,sy,d)
    x:=xn; y:=yn
  UNTIL LeftMouse(win)
ENDPROC

