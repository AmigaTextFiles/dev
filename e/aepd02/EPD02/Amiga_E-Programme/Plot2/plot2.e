/* first funcplot setup */

MODULE 'mathtrans'

CONST RES=7, OX=100, OY=20, SX=-5, SY=5, YSTEP=10, XSTEP=20, FLTFAC=10.0
CONST SIDE=RES*2+1, NRES=-RES
CONST SIZE=SIDE*SIDE, LSIDE=SIDE-2

DEF win,dat[SIZE]:ARRAY OF LONG

PROC main()
  mathtransbase:=OpenLibrary('mathtrans.library',0)
  IF mathtransbase=NIL
    WriteF('No MathTrans!\n')
  ELSE
    win:=OpenW(0,0,640,256,$200,$F,'Funky 3d Plot',NIL,1,NIL)
    IF win=NIL
      WriteF('No Window!\n')
    ELSE
      calc()
      plotall()
      WaitPort(Long(win+$56))
    ENDIF
  ENDIF
  stop()
ENDPROC

PROC calc()
  DEF x,y
  FOR x:=NRES TO RES
    FOR y:=NRES TO RES
      dat[y+RES*SIDE+x+RES]:=sin(x)+cos(y)    /* the formula */
    ENDFOR
  ENDFOR
ENDPROC

PROC sin(x) RETURN SpSin(x|)*FLTFAC|
PROC cos(x) RETURN SpCos(x|)*FLTFAC|

PROC plotall()
  DEF x,y,x1,y1,x2,y2,x3,y3,x4,y4,ar
  FOR x:=0 TO LSIDE
    FOR y:=0 TO LSIDE
      IF CtrlC() THEN stop()
      ar:=y*SIDE+x
      x1:=y*SX+OX+(x*XSTEP)
      y1:=(x*SY)+OY+(y*YSTEP)+dat[ar]
      x2:=y*SX+OX+(x+1*XSTEP)
      y2:=(x+1*SY)+OY+(y*YSTEP)+dat[ar+1]
      x3:=y+1*SX+OX+(x+1*XSTEP)
      y3:=(x+1*SY)+OY+(y+1*YSTEP)+dat[ar+1+SIDE]
      x4:=y+1*SX+OX+(x*XSTEP)
      y4:=(x*SY)+OY+(y+1*YSTEP)+dat[ar+SIDE]
      SetAPen(stdrast,3)
      Move(stdrast,x1,y1)
      Draw(stdrast,x2,y2)
      Draw(stdrast,x3,y3)
      Draw(stdrast,x4,y4)
      Draw(stdrast,x1,y1)
      SetAPen(stdrast,1)
      stdrast[27]:=3
      Flood(stdrast,0,x1+x2+x3+x4/4,y1+y2+y3+y4/4)
      SetAPen(stdrast,2)
      Move(stdrast,x1,y1)
      Draw(stdrast,x2,y2)
      Draw(stdrast,x3,y3)
      Draw(stdrast,x4,y4)
      Draw(stdrast,x1,y1)
    ENDFOR
  ENDFOR
ENDPROC

PROC stop()
  IF win THEN CloseW(win)
  IF mathbase THEN CloseLibrary(mathbase)
  IF mathtransbase THEN CloseLibrary(mathtransbase)
  CleanUp(0)
ENDPROC
