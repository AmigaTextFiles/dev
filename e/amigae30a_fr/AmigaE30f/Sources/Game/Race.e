/* version ordinateur du jeu autorace

   Jouez juste pour voir comment il marche. L'objectif est
   de bien choisir sa vitesse pour allez rapidement sans rentrer
   chez les autres. Si vous conduisez trop vite pour prendre un
   virage, vous perdez. Ce jeu est facile aussi à jouer sur le
   papier. A part le fait que vous pouvez dessiner de belles
   courbes avec :-)

*/

OPT OSVERSION=37

MODULE 'tools/clonescreen', 'gadtools', 'libraries/gadtools',
       'intuition/screens', 'graphics/text', 'intuition/intuition',
       'graphics/rastport'

CONST MAXP=10,
      MAXBOUND=1000,
      MAXTRAS=50000,
      OFF=7
CONST MAXAREA=MAXBOUND*5+10,
      OURIDCMP=IDCMP_MENUPICK+IDCMP_MOUSEMOVE+IDCMP_MOUSEBUTTONS

DEF xres=60,yres=40,xpixel,ypixel,xoff=20,yoff,xsize,ysize,window=NIL,
    curx[MAXP]:LIST, cury[MAXP]:LIST, lastx[MAXP]:LIST, lasty[MAXP]:LIST,
    players=2,curp,stat,midx,midy,pointx,pointy,p[18]:LIST,
    kx1,kx2,ky1,ky2,boundary[MAXBOUND]:LIST,area[MAXAREA]:ARRAY,
    ainfo:areainfo,tras:tmpras,nogreen=FALSE

PROC main()
  DEF screen=NIL:PTR TO screen,font=NIL:PTR TO textfont,depth,title,menu,visual
  title:='AutoRace v0.1'
  IF gadtoolsbase:=OpenLibrary('gadtools.library',37)
    screen,window,font:=openscreenwindow(title)
    IF screen
      font:=Long(stdrast+52)
      depth,xsize,ysize:=getcloneinfo(screen)
      yoff:=screen.wbortop+font.ysize+1+30
      xpixel:=xsize-10-xoff/xres
      ypixel:=ysize-10-yoff/yres
      SetColour(screen,0,$04,$C2,$73)
      SetColour(screen,1,$00,$00,$00)
      SetColour(screen,2,$DF,$DF,$DF)
      SetColour(screen,3,$E1,$5A,$03)
      IF window
        Colour(3,2)
        TextF(10,20,'\d \d',xpixel,ypixel)
        IF menu:=CreateMenusA([1,0,'Projet',0,0,0,0,
                                 2,0,'Nouveau','n',0,0,0,
                                 2,0,'Pas de vert','g',0,0,0,
                                 2,0,'Quitter','q',0,0,0,
                               1,0,'Joueur',0,0,0,0,
                                 2,0,'Un','1',0,0,0,
                                 2,0,'Deux','2',0,0,0,
                                 2,0,'Trois','3',0,0,0,
                                 2,0,'Quatre','4',0,0,0,
                                 2,0,'Cinq','5',0,0,0,
                               0,0,0,0,0,0,0]:newmenu,NIL)
          IF visual:=GetVisualInfoA(screen,NIL)
            IF LayoutMenusA(menu,visual,NIL)
              IF SetMenuStrip(window,menu)
                loop()
                ClearMenuStrip(window)
              ELSE
                WriteF('Ne peut pas mettre le menu!\n')
              ENDIF
            ELSE
              WriteF('Ne peut pas mettre en place les menus!\n')
            ENDIF
            FreeVisualInfo(visual)
          ELSE
            WriteF('ne peut pas prendre les visual infos!\n')
          ENDIF
          FreeMenus(menu)
        ELSE
          WriteF('Ne peut pas créer les menus!\n')
        ENDIF
      ELSE
        WriteF('Ne peut pas ouvrir de fenêtre!\n')
      ENDIF
    ELSE
      WriteF('Ne peut pas ouvrir d\aécran!\n')
    ENDIF
    closeclonescreen(screen,font,window)
    CloseLibrary(gadtoolsbase)
  ELSE
    WriteF('ne peut ouvrir la gadtools v37+\n')
  ENDIF
ENDPROC

PROC openscreenwindow(t) HANDLE
  DEF s=NIL,w=NIL,f=NIL
  s,f:=openclonescreen('Workbench',t,3)
  w:=backdropwindow(s,OURIDCMP,$1B00)
EXCEPT
ENDPROC s,w,f


PROC wait4message(window:PTR TO window)
  DEF mes:PTR TO intuimessage,type,infos
  REPEAT
    type:=0
    IF mes:=Gt_GetIMsg(window.userport)
      type:=mes.class
      IF type=IDCMP_MENUPICK
        infos:=mes.code
        IF infos=-1 THEN type:=0
      ELSEIF type=IDCMP_MOUSEBUTTONS
        IF mes.code<>SELECTUP THEN type:=0
      ELSEIF type=IDCMP_REFRESHWINDOW
        Gt_BeginRefresh(window)
        Gt_EndRefresh(window,TRUE)
        type:=0
      ENDIF
      Gt_ReplyIMsg(mes)
    ELSE
      Wait(-1)
    ENDIF
  UNTIL type
ENDPROC type,infos

ENUM NO_ACTION,SELECTING,GAME_OVER   -> stat
CONST BACKC=2,FRONTC=1,PLAYERC=3,GRASSC=0

PROC loop() HANDLE
  DEF quit=FALSE,class,infos,menu,item,rast:PTR TO rastport
  ListCopy(boundary,[11,7, 24,5, 42,10, 45,16, 43,26, 39,29, 25,33, 10,30, 7,23, 6,17, 11,7])

  rast:=stdrast
  rast.aolpen:=GRASSC
  ->rast.flags:=rast.flags OR RPF_AREAOUTLINE
  rast.tmpras:=InitTmpRas(tras,NewM(MAXTRAS,2),MAXTRAS)
  InitArea(ainfo,area,MAXAREA)
  rast.areainfo:=ainfo

  resetgame()
  REPEAT
    IF stat=NO_ACTION THEN startselection()
    class,infos:=wait4message(window)  ->WaitIMessage(window) -> planté?
    SELECT class
      CASE IDCMP_MENUPICK
        menu:=infos AND %11111
        item:=Shr(infos AND %11111100000,5)
        SELECT menu
          CASE 0
            SELECT item
              CASE 0; nogreen:=FALSE; resetgame()
              CASE 1; nogreen:=TRUE;  resetgame()
              CASE 2; quit:=TRUE
            ENDSELECT
          CASE 1
            players:=item+1
            resetgame()
        ENDSELECT
      CASE IDCMP_MOUSEMOVE
        IF stat<GAME_OVER THEN updateselection()
      CASE IDCMP_MOUSEBUTTONS
        IF stat<GAME_OVER THEN finishselection()
    ENDSELECT
  UNTIL quit
EXCEPT
  WriteF('Pas de mémoire pour tmpras!\n')
ENDPROC

PROC resetgame()
  DEF x,y,a,l
  Box(0,0,xsize-1,ysize-1,BACKC)
  FOR x:=0 TO xres DO FOR y:=0 TO yres DO vplot(x,y,FRONTC)
  Line(xcoord(0),ycoord(0),xcoord(15),ycoord(15),FRONTC)
  Colour(GRASSC,BACKC)
  IF nogreen=FALSE
    AreaMove(stdrast,xcoord(boundary[0]),ycoord(boundary[1]))
    l:=ListLen(boundary)
    FOR a:=2 TO l-1 STEP 2 DO AreaDraw(stdrast,xcoord(boundary[a]),ycoord(boundary[a+1]))
    AreaEnd(stdrast)
  ENDIF
  FOR a:=0 TO players-1
    curx[a]:=OFF-a; cury[a]:=OFF-a; lastx[a]:=OFF-a; lasty[a]:=OFF-a
  ENDFOR
  stat:=NO_ACTION
  curp:=0
ENDPROC

PROC startselection()
  DEF posm=0,a,b,pc:PTR TO LONG,distx,disty,x,y
  midx:=curx[curp]-lastx[curp]+curx[curp]
  midy:=cury[curp]-lasty[curp]+cury[curp]
  pc:=p
  stat:=SELECTING
  FOR a:=-1 TO 1
    FOR b:=-1 TO 1
      IF valid(midx+a,midy+b)
        posm++
        pc[]++:=xcoord(midx+a)
        pc[]++:=ycoord(midy+b)
      ELSE
        pc[]++:=0
        pc[]++:=0
      ENDIF
    ENDFOR
  ENDFOR
  IF posm
    message('Joueur \d a \d déplacement(s) possible(s)',curp+1,posm)
    plotplayer(curp)
    x:=xcoord(midx); y:=ycoord(midy)
    distx:=xpixel/2+xpixel
    disty:=ypixel/2+ypixel
    kx1:=x-distx
    kx2:=x+distx
    ky1:=y-disty
    ky2:=y+disty
    drawkader()
    computemouse()
    selectline(2)
  ELSE
    message('Joueur \d a perdu!',curp+1,0)
    stat:=GAME_OVER
  ENDIF
ENDPROC

PROC updateselection()
  selectline(2)
  computemouse()
  selectline(2)
ENDPROC

PROC finishselection()
  selectline(2)
  drawkader()
  selectline(1)
  vplot(curx[curp],cury[curp],FRONTC)
  lastx[curp]:=curx[curp]
  lasty[curp]:=cury[curp]
  curx[curp]:=xvirtua(pointx)
  cury[curp]:=yvirtua(pointy)
  stat:=NO_ACTION
  curp++
  IF curp=players THEN curp:=0
  plotplayer(curp)
ENDPROC

PROC computemouse()
  DEF pc:PTR TO LONG,a,x,y,mx,my
  pc:=p
  pointx:=pointy:=10000
  mx:=MouseX(window)
  my:=MouseY(window)
  FOR a:=0 TO 8
    x:=pc[]++; y:=pc[]++
    IF x
      IF (Abs(x-mx)+Abs(y-my))<(Abs(pointx-mx)+Abs(pointy-my))
        pointx:=x; pointy:=y
      ENDIF
    ENDIF
  ENDFOR
  IF (pointx=10000) OR (pointy=10000)
    pointx:=0
    pointy:=0
  ENDIF
ENDPROC

PROC selectline(mode)
  SetDrMd(stdrast,mode)
  Line(xcoord(curx[curp]),ycoord(cury[curp]),pointx,pointy,FRONTC)
  SetDrMd(stdrast,1)
ENDPROC

PROC xcoord(vx) RETURN vx*xpixel+xoff
PROC ycoord(vy) RETURN vy*ypixel+yoff
PROC col(vx,vy) RETURN ReadPixel(stdrast,xcoord(vx),ycoord(vy))
PROC valid(x,y) RETURN col(x,y)=FRONTC
PROC xvirtua(x) RETURN x-xoff/xpixel
PROC yvirtua(y) RETURN y-yoff/ypixel

PROC drawkader()
  SetDrMd(stdrast,2)
  Line(kx1,ky1,kx1,ky2,FRONTC)
  Line(kx1,ky1,kx2,ky1,FRONTC)
  Line(kx2,ky2,kx1,ky2,FRONTC)
  Line(kx2,ky2,kx2,ky1,FRONTC)
  SetDrMd(stdrast,1)
ENDPROC

PROC vplot(vx,vy,col)
  DEF x,y
  x:=xcoord(vx)
  y:=ycoord(vy)
  Box(x,y,x+1,y+1,col)
ENDPROC

PROC plotplayer(player)
  DEF x,y
  x:=xcoord(curx[player])
  y:=ycoord(cury[player])
  Box(x-1,y-1,x+2,y+2,PLAYERC+player)
ENDPROC

PROC message(s,p1,p2)
  TextF(10,30,'                                             ')
  TextF(10,30,s,p1,p2)
ENDPROC
