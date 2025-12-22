-> Encore un autre Mandel, traduit de l'oberon. Entier cette fois.

OPT OSVERSION=37, REG=5

MODULE 'tools/clonescreen'

CONST DEPTH=4,COLOURS=16        -> related :-)
CONST ITERDEPTH=25

PROC main() HANDLE

  DEF zr,zi,ar,ai,dr,di,sr,si,st,x,y,i,
      screen=NIL,font=NIL,win=NIL,xsize,ysize,depth

  screen,font:=openclonescreen('Workbench','EUAM',DEPTH)
  win:=backdropwindow(screen)
  depth,xsize,ysize:=getcloneinfo(screen)

  x:=256/COLOURS*2
  FOR i:=0 TO COLOURS-1 DO SetColour(screen,i,0,i*x,i*x)

  sr:=$400000/xsize     -> réduit horiz
  si:=$300000/ysize     -> réduit vert
  st:=$140000*-2        -> déplace de coté
  zi:=$160000           -> déplace vers le haut

  FOR y:=ysize-1 TO 0 STEP -1
    IF CtrlC() THEN Raise("^C")
    zi:=zi-si
    zr:=st
    FOR x:=0 TO xsize-1
      i:=0; ar:=zr; ai:=zi
      REPEAT
        dr:=Shr(ar,10); di:=Shr(ai,10)
        ai:=dr*2*di+zi
        dr:=dr*dr; di:=di*di
        ar:=dr-di+zr
        i++
      UNTIL (i>ITERDEPTH) OR (dr+di>$400000)
      Plot(x,y,Mod(i,COLOURS))
      zr:=zr+sr
    ENDFOR
  ENDFOR

  EasyRequestArgs(NIL,[20,0,'On se réveille!','j\aai fini !','Ok!'],0,NIL)

EXCEPT DO

  closeclonescreen(screen,font,win)

  SELECT exception
    CASE "SCR"; WriteF('Pas d'écran!\n')
    CASE "WIN"; WriteF('Pas de fenêtre!\n')
  ENDSELECT

ENDPROC
