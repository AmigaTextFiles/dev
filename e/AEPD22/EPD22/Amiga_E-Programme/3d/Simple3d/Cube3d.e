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

  DEF pts1,pts2,win

/* define 3d vertices of cube -- centred at the origin */

    pts1:=[[ R, R, R]:point,
           [ R, R,-R]:point,
           [ R,-R,-R]:point,
           [ R,-R, R]:point,
           [ R, R, R]:point,
           [ R,-R, R]:point,
           [-R,-R, R]:point,
           [-R, R, R]:point,
           [ R, R, R]:point]

    pts2:=[[-R,-R,-R]:point,
           [-R,-R, R]:point,
           [-R, R, R]:point,
           [-R, R,-R]:point,
           [-R,-R,-R]:point,
           [-R, R,-R]:point,
           [ R, R,-R]:point,
           [ R,-R,-R]:point,
           [-R,-R,-R]:point]

  IF win:=OpenW(0,11,WIDTH,HEIGHT,
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

    polygon3d(pts1,stdrast,1)
    polygon3d(pts2,stdrast,1)

    WaitIMessage(win)
    CloseW(win)
  ENDIF
ENDPROC