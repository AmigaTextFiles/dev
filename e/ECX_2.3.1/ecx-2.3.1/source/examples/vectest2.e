MODULE 'tools/vector'

CONST R=100,MAXD=24,N=7            /* set N=1..7 (number of shades) */

OBJECT status
  phi,theta,depth,x,y
ENDOBJECT

DEF depth:PTR TO LONG,stats[N]:ARRAY OF status

PROC main()
  DEF w,curphi=75,curtheta=40,curd=0,curs=0,a,fact=1,curx=100,cury=100
  IF w:=OpenW(0,11,220,189,$200,$E,'3d VectorZ in E!',NIL,1,NIL)
    SetRast(stdrast,1)
    RefreshWindowFrame(w)
    FOR a:=0 TO N-1 DO stats[a].phi:=-1
    depth:=[200,201,202,205,208,211,215,220,224,230,238,246,254,262,270,276,280,285,289,292,295,298,299,300]
    REPEAT
      stats[curs].phi:=curphi
      stats[curs].theta:=curtheta
      stats[curs].depth:=curd
      stats[curs].x:=curx
      stats[curs].y:=cury
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
  ENDIF
ENDPROC

PROC drawshape(s:PTR TO status,col)
  setmiddle3d(s.x,s.y)
  setpers3d(750,depth[s.depth])
  init3d(s.phi,s.theta)
  polygon3d([R,R,R,R,R,-R,R,-R,-R,R,-R,R,R,R,R,R,-R,R,-R,-R,R,-R,R,R,R,R,R],col)
  polygon3d([-R,-R,-R,-R,-R,R,-R,R,R,-R,R,-R,-R,-R,-R,-R,R,-R,R,R,-R,R,-R,-R,-R,-R,-R],col)
ENDPROC
