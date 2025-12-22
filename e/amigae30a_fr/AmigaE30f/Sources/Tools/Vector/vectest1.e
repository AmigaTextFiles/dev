MODULE 'tools/vector'

CONST R=100

PROC main()
  DEF w
  IF w:=OpenW(0,11,400,160,$200,$F,'test du module vecteur3d!',NIL,1,NIL)
    init3d(75,60)
    setmiddle3d(200,80)
    setpers3d(500,200)
    polygon3d([R,R,R,     R,R,-R,   R,-R,-R,  R,-R,R,   R,R,R,    R,-R,R,    -R,-R,R,  -R,R,R,   R,R,R],3)
    polygon3d([-R,-R,-R,  -R,-R,R,  -R,R,R,   -R,R,-R,  -R,-R,-R, -R,R,-R,   R,R,-R,   R,-R,-R,  -R,-R,-R],3)
    WaitIMessage(w)
    CloseW(w)
  ENDIF
ENDPROC
