/* -------------------------------------------
   file:    Surf3d.e
   by:      Sean Harbour Copyright (C) 1994
   Compile: EC Surf3d.e

   Animate a 3d solid model of a Cube.

------------------------------------------- */

MODULE 'exec/memory','intuition/intuition','graphics/gfx','graphics/rastport','*view3d'

CONST R=60                         /* scaling parameter for cube */

CONST WIDTH=190                    /* dimensions of window */
CONST HEIGHT=120

CONST DEPTH=3

CONST MAXAREA=MAXPTS*5             /* maximum number of vertices allowed */
CONST MAXTRAS=WIDTH*HEIGHT/8       /* maximum size of temporary Rastport */

PROC main()

  DEF ainfo:areainfo,area[MAXAREA]:ARRAY,bm:PTR TO bitmap,i,faces,normals,pts,rast:rastport,tras:tmpras,win

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
          'Surf3d',NIL,1,NIL)

-> initialise spare Rastport for double buffering

    bm:=AllocBitMap(WIDTH,HEIGHT,DEPTH,0,NIL)
    rast:=AllocVec(SIZEOF rastport,MEMF_CLEAR OR MEMF_PUBLIC)
    InitRastPort(rast)
    rast.bitmap:=bm

-> initialise TmpRast for area filling

    rast.aolpen:=1
    rast.flags:=rast.flags OR RPF_AREAOUTLINE
    rast.tmpras:=InitTmpRas(tras,NewM(MAXTRAS,2),MAXTRAS)
    InitArea(ainfo,area,MAXAREA)
    rast.areainfo:=ainfo

-> display solid rotating 3d model of cube

    setorigin3d(WIDTH/2,HEIGHT/2)
    setpers3d(500,200)

    Colour(2,0)

    i:=0
    REPEAT
      init3d(i,i,0)

      SetRast(rast,0)
      setpers3d(500,200)
      net3d(pts,faces,normals,rast)

      setpers3d(500,140)
      net3d(pts,faces,normals,rast)

      BltBitMapRastPort(bm,0,0,stdrast,0,0,WIDTH,HEIGHT,$C0)

      IF (i:=i+1) > 359 THEN i:=0

    UNTIL GetMsg(Long(win+$56))

    CloseW(win)

    FreeBitMap(bm)
  ENDIF
ENDPROC