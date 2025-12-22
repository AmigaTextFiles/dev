/* C'est celui qui est supposé qui magnifie les vecteurs de classe,
   mais il marche pas très bien (implémentation = expérience).
   Changez WINX et WINY en dessous
*/

MODULE 'tools/vector'

CONST R=100,S=-100,MAXD=24,N=3            /* met N=1..7 (nombre de gris) */
CONST DISTANCE=80,WINX=639,WINY=282

OBJECT status
  phi,theta,depth,x,y
ENDOBJECT

DEF depth:PTR TO LONG,stats[N]:ARRAY OF status, translist:PTR TO LONG

PROC main()
  DEF w,curphi=75,curtheta=40,curd=0,curs=0,a,fact=1,x,y,nx,ny,ox,oy
  IF w:=OpenW(0,0,WINX,WINY,$200,$E,'3d VectorZ en E! (déplacez la souris!)',NIL,1,NIL)
    SetRast(stdrast,1)
    translist:=[0,-16,-28,-36,-40,-40,-36,-28,-16,0,16,28,36,40,40,36,28,16,0]
    FOR x:=0 TO WINX STEP 16
      FOR y:=0 TO WINY STEP 16
        nx,ny:=posttrans(x,y)
        ox,oy:=posttrans(x,y+16)
        Line(nx,ny,ox,oy,4)
        ox,oy:=posttrans(x+16,y)
        Line(nx,ny,ox,oy,4)
      ENDFOR
    ENDFOR
    RefreshWindowFrame(w)
    SetDrMd(stdrast,2)
    PutChar(stdrast+24,3)
    FOR a:=0 TO N-1 DO stats[a].phi:=-1
    depth:=[200,201,202,205,208,211,215,220,224,230,238,246,254,262,270,276,280,285,289,292,295,298,299,300]
    REPEAT
      stats[curs].phi:=curphi
      stats[curs].theta:=curtheta
      stats[curs].depth:=curd
      stats[curs].x:=Bounds(MouseX(w),DISTANCE,WINX-DISTANCE)
      stats[curs].y:=Bounds(MouseY(w),DISTANCE,WINY-DISTANCE)
      drawshape(stats[curs],2)
      curs++
      IF curs>=N THEN curs:=0
      curd:=curd+fact
      IF curd>=(MAXD-1) THEN (curd:=MAXD-1) BUT fact:=-fact
      IF curd<=0 THEN (curd:=0) BUT fact:=-fact
      curphi:=curphi+2
      IF curphi>=360 THEN curphi:=0
      curtheta:=curtheta+2
      IF curtheta>=360 THEN curtheta:=0
      IF stats[curs].phi>=0 THEN drawshape(stats[curs],1)
    UNTIL GetMsg(Long(w+$56))
    CloseW(w)
  ELSE
    WriteF('um,...\n')
  ENDIF
ENDPROC

PROC drawshape(s:PTR TO status,col)
  setmiddle3d(s.x,s.y)
  setpers3d(750,depth[s.depth])
  init3d(s.phi,s.theta)
  polygon([R,R,S, R,R,R, R,S,R, R,S,S, R,R,S, S,R,S, S,R,R, S,S,R, S,S,S, S,R,S],col)
  polygon([R,S,R, S,S,R],col)
  polygon([R,R,R, S,R,R],col)
  polygon([R,S,S, S,S,S],col)
ENDPROC

PROC posttrans(x,y)
  IF x>DISTANCE
    IF y>DISTANCE
      IF DISTANCE+288>x
        IF DISTANCE+288>y
          x:=ListItem(translist,Shr(x-DISTANCE,4))+x
          y:=ListItem(translist,Shr(y-DISTANCE,4))+y
        ENDIF
      ENDIF
    ENDIF
  ENDIF
ENDPROC x,y

PROC polygon(list:PTR TO LONG,col=1)
  DEF n,i,sx,sy,ox,oy,f=FALSE
  n:=ListLen(list)/3
  FOR i:=1 TO n
    sx,sy:=vec3d(list[]++,list[]++,list[]++)
    sx,sy:=posttrans(sx,sy)
    IF f THEN Line(ox,oy,sx,sy,col) ELSE f:=TRUE
    ox:=sx; oy:=sy;
  ENDFOR
ENDPROC
