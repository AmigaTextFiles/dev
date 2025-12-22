OPT OSVERSION=37  

DEF win=NIL, a:LONG, b:LONG, x:LONG, y:LONG, col:LONG

PROC main()
 win:=OpenW(0,0,640,256,0,0,'Random GFX ©1995 Andreas Rehm - Linker+Rechter Mausknopf für Ende',NIL,1,NIL)
 IF win
  WHILE Mouse()<>3
   process()
  ENDWHILE
  CloseW(win)
 ELSE
  EasyRequestArgs(0,[20,0,'Random GFX ©1995 Andreas Rehm','Kann das Fenster nicht öffnen!','OK'],0,NIL)
 ENDIF
 CleanUp(0)
ENDPROC

CHAR '\0$VER: \e[32mRnd\e[0m 1.01 (10.03.95) (©1995 Andreas Rehm)\0'

PROC process()
 a:=Rnd(619)
 b:=Rnd(253)
 x:=Rnd(619)
 y:=Rnd(253)
 col:=Rnd(5)
 a:=a+5
 b:=b+11
 x:=x+5
 x:=x+11
 IF col=0 THEN col:=1 
 Box(a,b,x,y,col)
ENDPROC
