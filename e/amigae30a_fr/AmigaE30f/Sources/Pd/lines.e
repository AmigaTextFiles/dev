/* Démo de lignes en E par EA van Breemen */
/* v1.0 ©1994                        */

/* C'est un petit exemple de graphisme en E                    */
/* Désolé pour la pauvreté des commentaires                    */
/* Si peu de temps et tant de programme (en E bien sûr 8-))    */


CONST MAX_X=600
CONST MAX_Y=225
CONST MIN_X=25
CONST MIN_Y=25

CONST MAX=15
CONST MAXCOL=16
CONST BITPLANES=4

ENUM NO_ERROR,NO_SCREEN,NO_WINDOW

PROC main() HANDLE
 DEF window=NIL,screen=NIL
 DEF x1,y1,x2,y2
 DEF vx1,vy1,vx2,vy2
 DEF col,i
 DEF cx1[MAX]:ARRAY OF LONG
 DEF cx2[MAX]:ARRAY OF LONG
 DEF cy1[MAX]:ARRAY OF LONG
 DEF cy2[MAX]:ARRAY OF LONG
 DEF collist[MAX]:ARRAY OF LONG

 DEF r=0, g=0, b=0
 DEF sr=1,sg=1,sb=1

 DEF q,switch
 DEF viewport

 screen  :=  OpenS(640,256,BITPLANES,$8000,'Démo de lignes en E')
 IF screen=NIL THEN Raise(NO_SCREEN)
 window:=OpenW(0,0,640,256,0,$1800,0, screen,15,0)
 IF window=NIL THEN Raise(NO_WINDOW)
 viewport := ViewPortAddress(window)
 col:=0
 FOR i:=1 TO MAXCOL-1 STEP 1
  col:=col+1
  IF col=MAXCOL THEN col:=0
  SetRGB4(viewport,i,col,15,15-col)
 ENDFOR
 SetDrMd(stdrast,2)
 x1:=30; y1:=30; x2:=100; y2:=100

 vx1:=2; vy1:=3; vx2:=-3; vy2:=-1
 col:=1; q:=1; switch:=1

 FOR i:=0 TO MAX-1 STEP 1
  cx1[i]:=0
 ENDFOR

 WHILE Mouse()<>1
 IF cx1[q]<>0
    Colour(collist[q],0)
    PutChar(stdrast+24,collist[q])

    Move (stdrast,cx1[q],cy1[q])
    Draw (stdrast,cx2[q],cy2[q])

    Move (stdrast,MAX_X-cx1[q],MAX_Y-cy1[q])
    Draw (stdrast,MAX_X-cx2[q],MAX_Y-cy2[q])

    Move (stdrast,cx1[q],MAX_Y-cy1[q])
    Draw (stdrast,cx2[q],MAX_Y-cy2[q])

    Move (stdrast,MAX_X-cx1[q],cy1[q])
    Draw (stdrast,MAX_X-cx2[q],cy2[q])
 ENDIF

 x1:=x1+vx1
 y1:=y1+vy1
 y2:=y2+vy2
 x2:=x2+vx2

 IF ((x1<MIN_X) OR (x1>MAX_X)) THEN vx1:=-vx1
 IF ((y1<MIN_Y) OR (y1>MAX_Y)) THEN vy1:=-vy1
 IF ((x2<MIN_X) OR (x2>MAX_X)) THEN vx2:=-vx2
 IF ((y2<MIN_Y) OR (y2>MAX_Y)) THEN vy2:=-vy2

 Colour(col,0)
 PutChar(stdrast+24,col)
 SetRGB4(viewport,col,r,g,b)
 IF q AND $8
  r:=r+sr
  IF r>14 THEN sr:=-1
  IF r<1  THEN sr:=1
  IF r AND 8
    g:=g+sg
    IF g>14 THEN sg:=-1
    IF g<1  THEN sg:=1
  ENDIF
  IF r AND 10
    b:=b+sb
    IF b>14 THEN sb:=-1
    IF b<1  THEN sb:=1
  ENDIF
  IF Rnd(100) > 95
    r:=(r+Rnd(3)) AND $f
    g:=(g+Rnd(3)) AND $f
    b:=(b+Rnd(3)) AND $f
  ENDIF
 ENDIF

 Move (stdrast,x1,y1)
 Draw (stdrast,x2,y2)

 Move (stdrast,MAX_X-x1,MAX_Y-y1)
 Draw (stdrast,MAX_X-x2,MAX_Y-y2)

 Move (stdrast,x1,MAX_Y-y1)
 Draw (stdrast,x2,MAX_Y-y2)

 Move (stdrast,MAX_X-x1,y1)
 Draw (stdrast,MAX_X-x2,y2)

 cx1[q]:=x1
 cy1[q]:=y1
 cx2[q]:=x2
 cy2[q]:=y2
 collist[q]:=col
 q:=q+1
 IF q=MAX
  q:=0
  switch:=-switch
 ENDIF
 col:=col+1
 IF col=MAXCOL THEN col:=1
 ENDWHILE
 Raise(NO_ERROR)

EXCEPT
 IF window THEN CloseW(window)
 IF screen THEN CloseS(screen)
SELECT exception
 CASE NO_ERROR
  /* Ne fait rien */
 CASE NO_SCREEN
  WriteF('Ne peut ouvrir l\aécran\n')
 CASE NO_WINDOW
  WriteF('Ne peut pas ouvrir la fenêtre\n')
 DEFAULT
  WriteF('Exception inconnue:\d\n',exception)
ENDSELECT
ENDPROC
