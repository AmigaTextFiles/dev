/* -------------------------------------------
   file:    Cube3d.e
   by:      Sean Harbour Copyright (C) 1994
   Compile: EC Cube3d.e

   Display a 3d wireframe model of a Cube.

------------------------------------------- */

MODULE 'intuition/intuition','*view3d'

CONST R=60                         /* scaling parameter for cube */

CONST WIDTH=190                    /* dimensions of window */
CONST HEIGHT=120

PROC main()

  DEF faces,pts,win

/* define 3d vertices of cube -- centred at the origin */

    pts:=[[-R,-R,-R]:point,
          [-R,-R, R]:point,
          [-R, R, R]:point,
          [ R, R, R]:point,
          [ R,-R,-R]:point,
          [ R, R,-R]:point,
          [-R, R,-R]:point,
          [ R,-R, R]:point]

  /* define faces which make up our model of a cube */

  faces:=[[0,4,7,1],
          [0,6,2,1],
          [2,3,5,6],
          [3,7,4,5],
          [0,4,5,6],
          [1,7,3,2]]

  IF win:=OpenW(0,11,190,120,
            IDCMP_CLOSEWINDOW,
            WFLG_SMART_REFRESH OR
            WFLG_DEPTHGADGET   OR
            WFLG_DRAGBAR       OR
            WFLG_CLOSEGADGET   OR
            WFLG_GIMMEZEROZERO OR
            WFLG_ACTIVATE,
          'Cube3d',NIL,1,NIL)

    setorigin3d(WIDTH/2,HEIGHT/2)
    setpers3d(500,200)
    init3d(20,30,0)

    net3d(pts,faces,stdrast,3)

    WaitIMessage(win)
    CloseW(win)
  ENDIF
ENDPROC