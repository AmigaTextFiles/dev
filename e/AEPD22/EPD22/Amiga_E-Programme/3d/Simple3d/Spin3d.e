/* -------------------------------------------
   file:    Spin3d.e
   by:      Sean Harbour Copyright (C) 1994
   Compile: EC Spin3d.e

   Animate a 3d wireframe model of a Cube.

------------------------------------------- */

MODULE 'exec/memory','intuition/intuition','graphics/gfx','graphics/rastport','*view3d'

CONST R=60                         /* scaling parameter for cube */

CONST WIDTH=190                    /* dimensions of window */
CONST HEIGHT=120

CONST DEPTH=3                      /* 2^(DEPTH) colours allowed in spare bitmap */

PROC main()

  DEF bm:PTR TO bitmap,i,pts1,pts2,rast:PTR TO rastport,win

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
          'Spin3d',NIL,1,NIL)

-> initialise spare Rastport for double buffering

    bm:=AllocBitMap(WIDTH,HEIGHT,DEPTH,0,NIL)
    rast:=AllocVec(SIZEOF rastport,MEMF_CLEAR OR MEMF_PUBLIC)
    InitRastPort(rast)
    rast.bitmap:=bm

    SetRast(rast,0)                /* clear the spare rastport */

    setorigin3d(WIDTH/2,HEIGHT/2)
    setpers3d(500,200)

    i:=0
    REPEAT
      init3d(i,i,0)

      polygon3d(pts1,rast,1)
      polygon3d(pts2,rast,1)

      BltBitMapRastPort(bm,0,0,stdrast,0,0,WIDTH,HEIGHT,$C0)

      polygon3d(pts1,rast,0)
      polygon3d(pts2,rast,0)

      IF (i:=i+1) > 359 THEN i:=0

    UNTIL GetMsg(Long(win+$56))

    CloseW(win)

    FreeBitMap(bm)
  ENDIF
ENDPROC