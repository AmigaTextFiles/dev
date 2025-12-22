MODULE 'tools/vector'


CONST R=100,S=40

DEF r1=R,n1=-R,r2=R,n2=-R,fac1=-1,fac2=1,fac3=1,fac4=-1
DEF o1,o2,l1,l2

PROC main()
  DEF w,sx1,sx2,sy1,sy2,phi,theta
  o1:=List(S)
  o2:=List(S)
  IF w:=OpenW(0,11,200,189,$200,$E,'3d VectorZ in E!',NIL,1,NIL)
    SetRast(stdrast,1)
    RefreshWindowFrame(w)
    phi:=74
    theta:=60
    setmiddle3d(100,100)
    setpers3d(750,300)
    REPEAT
      dofac({r1},{fac1})
      dofac({r2},{fac2})
      dofac({n1},{fac3})
      dofac({n2},{fac4})
      WaitTOF()
      polygon3d(o1,1)
      polygon3d(o2,1)
      phi:=phi+2; IF phi>=360 THEN phi:=phi-360
      theta:=theta+2; IF theta>=360 THEN theta:=theta-360
      init3d(phi,theta)
      polygon3d(l1:=[r1,r1,r1,r1,r1,n1,r1,n1,n1,r1,n1,r1,r1,r1,r1,r1,n1,r1,n1,n1,r1,n1,r1,r1,r1,r1,r1],2)
      polygon3d(l2:=[n2,n2,n2,n2,n2,r2,n2,r2,r2,n2,r2,n2,n2,n2,n2,n2,r2,n2,r2,r2,n2,r2,n2,n2,n2,n2,n2],3)
      ListCopy(o1,l1,ALL)
      ListCopy(o2,l2,ALL)
      Delay(1)
    UNTIL GetMsg(Long(w+$56))
    CloseW(w)
  ENDIF
ENDPROC

PROC dofac(var:PTR TO LONG,f:PTR TO LONG)
  var[] := var[] + f[] ->^var:=^var+^f
  IF var[]>0 THEN IF (var[]>120) OR (var[]<80) THEN f[] := -f[]->^var>0 THEN IF (^var>120) OR (^var<80) THEN ^f:=-^f
  IF var[]<0 THEN IF (var[]<-120) OR (var[]>-80) THEN f[] := -f[]->IF ^var<0 THEN IF (^var<-120) OR (^var>-80) THEN ^f:=-^f
ENDPROC
