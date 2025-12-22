MODULE bounce; (* jr/7sep87 *)

(* Modified for Cyclone ! MT *) 

FROM SYSTEM IMPORT
 ADDRESS, ADR,LONGSET;
FROM ModulaLib IMPORT
 Assert;
FROM GraphicsD IMPORT
 BitMap, ViewPortPtr, RastPortFlags, RastPortFlagSet, RastPortPtr, ViewModeSet;
FROM GraphicsL IMPORT
 AllocRaster, BltClear, Draw, FreeRaster, InitBitMap, Move, SetAPen, SetRGB4,
 SetRast;
FROM IntuitionD IMPORT
 stdScreenHeight, customScreen, NewScreen, ScreenFlags, ScreenFlagSet,
 ScreenPtr;
FROM IntuitionL IMPORT
 CloseScreen, MakeScreen, OpenScreen, RethinkDisplay;
FROM MathIEEESingTrans IMPORT
 Sin, Cos;
FROM Random IMPORT
 RND;


CONST
 WIDTH=320;
 HEIGHT=200;
 DEPTH=1;
 nrVerticies=8;
 nrEdges=12;
 nrSides=4;
 nrFaces=6;
 MaxAngle=20;
 MaxCount=8;
 nCubes=1;

VAR
 maxCount: CARDINAL;
 distance, dir: REAL;
  (*
 polygon   : ARRAY [0..nrFaces-1],[0..nrSides-1] OF CARDINAL;
 points    : ARRAY [0..nrFaces-1],[0..nrSides-1] OF CARDINAL;
  *)
 edges     : ARRAY [0..nrEdges-1],[0..1] OF CARDINAL;
 x, y, z   : ARRAY [0..nrVerticies-1] OF REAL;
 sina, cosa: ARRAY [0..MaxAngle] OF REAL;
 x2D, y2D  : ARRAY [0..nrVerticies-1] OF INTEGER;
 maxAngle,
 anglep, phi, phidir,
 anglet, tha, thadir,
 angler, rho, rhodir: INTEGER;
 scr: ScreenPtr;
 rp: RastPortPtr;
 i: INTEGER;
 vp: ViewPortPtr;

(* ----------------- double buffering --------------------- *)

VAR
 now: INTEGER;
 map: ARRAY [0..1] OF BitMap;

PROCEDURE CreateDBufScreen(w, h, d: INTEGER): ScreenPtr;
 VAR
  ns: NewScreen;
  i: INTEGER;
  pl: ADDRESS;
  s: ScreenPtr;
 BEGIN
   (* init the two BitMap structures *)
  FOR now:=0 TO 1 DO
   InitBitMap(map[now], d, w, h);
   FOR i:=0 TO d-1 DO
    pl:=AllocRaster(w, h); Assert(pl#NIL, ADR('cannot alloc raster'));
    BltClear(pl, w DIV 8*h, LONGSET{0}); map[now].planes[i]:=pl
   END
  END;

   (* open a screen *)
  ns.leftEdge:=0; ns.topEdge:=0; ns.width:=w; ns.height:=h; ns.depth:=d;
  ns.detailPen:=0; ns.blockPen:=1;
  ns.viewModes:=ViewModeSet{};
  ns.type:=customScreen+ScreenFlagSet{customBitMap};
  ns.defaultTitle:=NIL; ns.font:=NIL; ns.gadgets:=NIL;
  ns.customBitMap:=ADR(map[0]); now:=0;
  s:=OpenScreen(ns);
   (* Very important statement follows. If missing the system behavior AFTER
   end of program is very starnge. *)
  IF s#NIL THEN s^.rastPort.flags:=RastPortFlagSet{dBuffer} END;
  RETURN s
 END CreateDBufScreen;

PROCEDURE FlipDBufScreen(VAR s: ScreenPtr);
 BEGIN
  s^.viewPort.rasInfo^.bitMap:=ADR(map[now]);
  (* Intuition integrated  MakeVPort(); MrgCop(); LoadView(); *)
  MakeScreen(s); RethinkDisplay;
  now:=1-now; s^.rastPort.bitMap:=ADR(map[now])
 END FlipDBufScreen;

(* ------------------ main ------------------------- *)

PROCEDURE DegToRad(i: INTEGER): REAL;
 BEGIN
  RETURN REAL(LONGINT(i))*0.01745329252 (* = pi/180 *)
 END DegToRad;

PROCEDURE InitAngles;
 VAR i: INTEGER;
 BEGIN
  maxAngle:=RND(MaxAngle DIV 2-1) + MaxAngle DIV 2-1;
  phi:=0; phidir:=1;
  tha:=0; thadir:=1;
  rho:=0; rhodir:=1;
  maxCount:=MaxCount;

  FOR i:=0 TO MaxAngle DO
   sina[i]:=Sin(DegToRad(i));
   cosa[i]:=Cos(DegToRad(i))
  END
 END InitAngles;

 (* Rotate cube about x,y and z axis. *)
PROCEDURE Rotate;
 VAR
  X, Y, Z, cphi, ctha, crho, sphi, stha, srho: REAL;
  i: INTEGER;
 BEGIN
   (* get next rotation angle *)
  INC(maxCount);
  IF maxCount>=MaxCount THEN
    maxCount:=0;
    INC(phi, phidir);
    INC(tha, thadir);
    INC(rho, rhodir);

     (* NOTE: cannot use ABS(phi) >= maxAngle. *)
    IF (phi<=-maxAngle) & (phidir<0) OR
       (phi>= maxAngle) & (phidir>0) THEN
      maxAngle:=RND(MaxAngle DIV 2-1) + MaxAngle DIV 2-1;
      phidir:=-phidir
    END;

     (* NOTE: cannot use ABS(tha) >= maxAngle. *)
    IF (tha<=-maxAngle) & (thadir<0) OR
       (tha>= maxAngle) & (thadir>0) THEN
      maxAngle:=RND(MaxAngle DIV 2-1) + MaxAngle DIV 2-1;
      thadir:=-thadir
    END;

     (* NOTE: cannot use ABS(rho) >= maxAngle. *)
    IF (rho<=-maxAngle) & (rhodir<0) OR
       (rho>= maxAngle) & (rhodir>0) THEN
      maxAngle:=RND(MaxAngle DIV 2-1) + MaxAngle DIV 2-1;
      rhodir:=-rhodir
    END
  END;

  INC(anglep, phi);
  INC(anglet, tha);
  INC(angler, rho);

  anglep:=(anglep+90) MOD 90;
  anglet:=(anglet+90) MOD 90;
  angler:=(angler+90) MOD 90;

  cphi:=cosa[ABS(phi)];
  ctha:=cosa[ABS(tha)];
  crho:=cosa[ABS(rho)];

  IF phi<0 THEN sphi:=-sina[-phi]
  ELSE sphi:=sina[phi]
  END;

  IF tha<0 THEN stha:=-sina[-tha]
  ELSE stha:=sina[tha]
  END;

  IF rho<0 THEN srho:=-sina[-rho]
  ELSE srho:=sina[rho]
  END;

   (* Rotate about Y *)
  FOR i:=0 TO nrVerticies-1 DO
   X:=x[i]; Z:=z[i];
   x[i]:=X*cphi - Z*sphi;
   z[i]:=Z*cphi + X*sphi
  END;

   (* Rotate about X *)
  FOR i:=0 TO nrVerticies-1 DO
    Y:=y[i]; Z:=z[i];
    y[i]:=Y*ctha + Z*stha;
    z[i]:=Z*ctha - Y*stha
  END;

   (* Rotate about Z *)
  FOR i:=0 TO nrVerticies-1 DO
    X:=x[i]; Y:=y[i];
    x[i]:=X*crho - Y*srho;
    y[i]:=Y*crho + X*srho
  END
 END Rotate;

PROCEDURE SetCube;
 BEGIN
  x[0]:=-150.0; y[0]:= 150.0; z[0]:= 150.0;
  x[1]:= 150.0; y[1]:= 150.0; z[1]:= 150.0;
  x[2]:= 150.0; y[2]:= 150.0; z[2]:=-150.0;
  x[3]:=-150.0; y[3]:= 150.0; z[3]:=-150.0;
  x[4]:=-150.0; y[4]:= 0.0; z[4]:= 150.0;
  x[5]:= 150.0; y[5]:= 0.0; z[5]:= 150.0;
  x[6]:= 150.0; y[6]:= 0.0; z[6]:=-150.0;
  x[7]:=-150.0; y[7]:= 0.0; z[7]:=-150.0;

  edges[0,0]:=0;  edges[0,1]:=1;
  edges[1,0]:=1;  edges[1,1]:=2;
  edges[2,0]:=2;  edges[2,1]:=3;
  edges[3,0]:=3;  edges[3,1]:=0;
  edges[4,0]:=0;  edges[4,1]:=4;
  edges[5,0]:=4;  edges[5,1]:=5;
  edges[6,0]:=5;  edges[6,1]:=1;
  edges[7,0]:=5;  edges[7,1]:=6;
  edges[8,0]:=6;  edges[8,1]:=2;
  edges[9,0]:=6;  edges[9,1]:=7;
  edges[10,0]:=7; edges[10,1]:=3;
  edges[11,0]:=7; edges[11,1]:=4;
   (*
  polygon[0,0]:=0;  polygon[0,1]:=1;
  polygon[0,2]:=2;  polygon[0,3]:=3;
  polygon[1,0]:=0;  polygon[1,1]:=4;
  polygon[1,2]:=5;  polygon[1,3]:=6;
  polygon[2,0]:=1;  polygon[2,1]:=6;
  polygon[2,2]:=7;  polygon[2,3]:=8;
  polygon[3,0]:=2;  polygon[3,1]:=8;
  polygon[3,2]:=9;  polygon[3,3]:=10;
  polygon[4,0]:=3;  polygon[4,1]:=4;
  polygon[4,2]:=10; polygon[4,3]:=11;
  polygon[5,0]:=5;  polygon[5,1]:=7;
  polygon[5,2]:=9;  polygon[5,3]:=11;

  points[0,0]:=0; points[0,1]:=1;
  points[0,2]:=2; points[0,3]:=3;
  points[1,0]:=0; points[1,1]:=4;
  points[1,2]:=5; points[1,3]:=1;
  points[2,0]:=1; points[2,1]:=6;
  points[2,2]:=7; points[2,3]:=2;
  points[3,0]:=2; points[3,1]:=6;
  points[3,2]:=7; points[3,3]:=3;
  points[4,0]:=3; points[4,1]:=7;
  points[4,2]:=4; points[4,3]:=0;
  points[5,0]:=4; points[5,1]:=5;
  points[5,2]:=6; points[5,3]:=7;
   *)
 END SetCube;

PROCEDURE DrawCube;
 CONST
  centerX = WIDTH DIV 2;
  centerY = HEIGHT DIV 2;
 VAR
  e: INTEGER;
 BEGIN
  SetRast(rp, 0); (* Clear Screen *)

  FOR e:=0 TO nrEdges-1 DO
   Move(rp, x2D[edges[e,0]] + centerX, y2D[edges[e,0]] + centerY);
   Draw(rp, x2D[edges[e,1]] + centerX, y2D[edges[e,1]] + centerY);
  END;

  FlipDBufScreen(scr)
 END DrawCube;

 (* project 3D image onto 2D surface. *)
PROCEDURE Convert2D;
 VAR
  i: INTEGER;
  f: REAL;
 BEGIN
  FOR i:=0 TO nrVerticies-1 DO
   f:=1000.0 / (distance - z[i]);
   x2D[i]:=LONGINT(x[i]*f);
   y2D[i]:=LONGINT(y[i]*f)
  END
 END Convert2D;

PROCEDURE NewDir(): REAL;
VAR l:LONGINT;
 BEGIN
  l:=RND(150)+50;
  RETURN REAL(l)
 END NewDir;

PROCEDURE Do(n: CARDINAL);
 BEGIN
  WHILE n>0 DO Rotate; Convert2D; DrawCube; DEC(n) END
 END Do;

PROCEDURE Cleanup;
 VAR i: INTEGER;
 BEGIN
  IF scr#NIL THEN CloseScreen(scr) END;
  FOR now:=0 TO 1 DO
   WITH map[now] DO
    FOR i:=0 TO DEPTH-1 DO
     IF planes[i]#NIL THEN FreeRaster(planes[i], WIDTH, HEIGHT) END
    END
   END
  END
 END Cleanup;

BEGIN
 scr:=NIL;

 InitAngles; SetCube;
 scr:=CreateDBufScreen(WIDTH, HEIGHT, DEPTH);
 Assert(scr#NIL, ADR('cannot open screen'));
 rp:=ADR(scr^.rastPort);

  (* Setup screen colors *)
 vp:=ADR(scr^.viewPort);
 SetRGB4(vp, 0, 0, 0, 0);
 SetRGB4(vp, 1, 0, 0, 15);

  (* just rotate on spot at first *)
 distance:=15000.0; Do(10);
 dir:=NewDir();
 FOR i:=0 TO 500 DO
  Do(1);
  distance:=distance + dir;
  IF distance<=4000.0 THEN dir:=NewDir(); Do(1)
  ELSIF distance>=15000.0 THEN dir:=-NewDir(); Do(1)
  END
 END;

CLOSE
  Cleanup;
END bounce.mod
