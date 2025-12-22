/* Transformations affines itératives

   vous donne une page à l'écran d'une façon spéciale.
   Soyez patient : ca prendra un peu de temps avant que
   ne voyez quelque chose.

*/

OPT OSVERSION=39  /* oh, and we need a 640*512*256 screen */

CONST SCRX=740, SCRY=580, PLANES=8

OBJECT trans
  a,b,c,d,ox,oy,prob
ENDOBJECT

DEF win,scr

PROC main()
  DEF a
  scr:=OpenS(SCRX,SCRY,PLANES,$8004,'Fern')
  IF scr=NIL
    WriteF('Ne peut pas ouvrir d\aécran!\n')
  ELSE
    win:=OpenW(0,0,SCRX-1,SCRY-1,$200,$F,'Fern',scr,15,NIL)
    IF win=NIL
      WriteF('Ne peut pas ouvrir de fenêtre!\n')
    ELSE
      FOR a:=0 TO 255 DO SetColour(scr,a,a,a,a)
      do([[  .0,   .0,   .0,  .16,.0, .0, 1 ]:trans,   -> retour à la racine!
          [  .2,   .23,(-.26),.22,.0,1.6, 7 ]:trans,   -> feuille de droite
          [(-.15), .26,  .28, .24,.0, .44,7 ]:trans,   -> feuille de gauche
          [  .85,(-.04), .04, .85,.0,1.6, 85]:trans])  -> corps
      ->WaitIMessage(win)
      CloseW(win)
    ENDIF
    CloseS(scr)
  ENDIF
ENDPROC

PROC do(t:PTR TO LONG)
  DEF x=1.,y=1.,r,n,a,tr:PTR TO trans,xn,yn,sx,sy,d
  REPEAT
    r:=Rnd(100)
    n:=0
    FOR a:=1 TO ListLen(t)
      tr:=t[a-1]
    EXIT (r>=n) AND (tr.prob+n>r)
      n:=n+tr.prob
    ENDFOR
    sx:=!(xn:=!(!tr.a*x)+(!tr.c*y)+tr.ox)*60.!+(SCRX/2)
    sy:=SCRY-(!(yn:=!(!tr.b*x)+(!tr.d*y)+tr.oy)*50.!)
    d:=Bounds(ReadPixel(stdrast,sx,sy)+20,64,255)
    Plot(sx,sy,d)
    x:=xn; y:=yn
  UNTIL LeftMouse(win)
ENDPROC
