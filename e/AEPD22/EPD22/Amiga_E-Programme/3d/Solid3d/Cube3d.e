/* -------------------------------------------
   file:    Cube3d.e
   by:      Sean Harbour Copyright (C) 1994
   Compile: EC Cube3d.e

   Display a 3d solid model of a Cube.

------------------------------------------- */

MODULE 'intuition/intuition','graphics/rastport','*view3d'

CONST R=60                         /* scaling parameter for cube */

CONST WIDTH=190                    /* dimensions of window */
CONST HEIGHT=120

CONST MAXAREA=MAXPTS*5             /* maximum number of vertices allowed */
CONST MAXTRAS=WIDTH*HEIGHT/8       /* maximum size of temporary Rastport */

PROC main()

  DEF ainfo:areainfo,area[MAXAREA]:ARRAY,faces,normals
  DEF pts,rast:PTR TO rastport,tras:tmpras,win

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

  /* define normals to faces of cube */

  normals:=[[ 0,-R, 0]:point,
            [-R, 0, 0]:point,
            [ 0, R, 0]:point,
            [ R, 0, 0]:point,
            [ 0, 0,-R]:point,
            [ 0, 0, R]:point]

  IF win:=OpenW(0,11,WIDTH,HEIGHT,
            IDCMP_CLOSEWINDOW,
            WFLG_SMART_REFRESH OR
            WFLG_DEPTHGADGET   OR
            WFLG_DRAGBAR       OR
            WFLG_CLOSEGADGET   OR
            WFLG_GIMMEZEROZERO OR
            WFLG_ACTIVATE,
          'Cube3d',NIL,1,NIL)

-> initialise TmpRast for area filling

    rast:=stdrast
    rast.aolpen:=1
    rast.flags:=rast.flags OR RPF_AREAOUTLINE
    rast.tmpras:=InitTmpRas(tras,NewM(MAXTRAS,2),MAXTRAS)
    InitArea(ainfo,area,MAXAREA)
    rast.areainfo:=ainfo

-> display 3d model of cube

    setorigin3d(WIDTH/2,HEIGHT/2)
    setpers3d(500,200)
    init3d(20,30,0)
    Colour(2,0)

    net3d(pts,faces,normals,rast)

    WaitIMessage(win)
    CloseW(win)
  ENDIF
ENDPROC