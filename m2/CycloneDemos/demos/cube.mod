MODULE cube; (* jr/8sep87 *)

(* modified for amc MT *)

FROM SYSTEM IMPORT
 ADDRESS, ADR, LONGSET;
FROM ModulaLib IMPORT
 Assert;
FROM GraphicsD IMPORT
 AreaInfo, BitMap, RastPortFlags, RastPortFlagSet, RastPortPtr, TmpRas,
 ViewPortPtr, ViewModeSet;
FROM GraphicsL IMPORT
 AllocRaster, AreaMove, AreaDraw, AreaEnd, BltClear, FreeRaster, InitArea,
 InitBitMap, InitTmpRas, SetAPen, SetRast, SetRGB4;
FROM IntuitionD IMPORT
 customScreen, NewScreen, ScreenFlags, ScreenFlagSet, ScreenPtr;
FROM IntuitionL IMPORT
 CloseScreen, MakeScreen, OpenScreen, RethinkDisplay;
FROM MathIEEESingTrans IMPORT
 Sin, Cos;
FROM Random IMPORT
 RND;

CONST
 WIDTH=320;
 HEIGHT=200;
 DEPTH=2;

 nrVerticies=4;
 MaxAngle=20;
 MaxCount=8;

VAR
 trp : ADDRESS;
 scr : ScreenPtr;
 rp  : RastPortPtr;
 vp  : ViewPortPtr;
 x, y, z: ARRAY [0..nrVerticies-1] OF REAL;
 sinphi, cosphi: ARRAY [0..MaxAngle] OF REAL;
 x2D, y2D: ARRAY [0..nrVerticies-1] OF INTEGER;
 distance: REAL;
 dir: REAL;
 phi, phidir: INTEGER;  (* how much to rotate, and in which direction *)
 angle: INTEGER;  (* current facial angle of left side *)
 maxAngle: INTEGER;
 maxCount: CARDINAL;

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

PROCEDURE YRotation;
  (* rotate cube about y axis by phi degrees. *)
 VAR
  i: CARDINAL;
  X, Z, sphi, cphi: REAL;
 BEGIN
   (* get next rotation angle *)
  INC(maxCount);
  IF maxCount>=MaxCount THEN
    maxCount:=0;
    INC(phi,phidir);
    (* NOTE: cannot use ABS(phi) >= maxAngle. *)
    IF (phi<=-maxAngle) & (phidir<0) OR
       (phi>= maxAngle) & (phidir>0) THEN
      maxAngle:=RND(MaxAngle DIV 2-1) + MaxAngle DIV 2-1;
      phidir:=-phidir
    END
  END;

  INC(angle, phi);
  angle:=(angle+90) MOD 90;

  cphi:=cosphi[ABS(phi)];
  IF phi<0 THEN sphi:=-sinphi[-phi]
  ELSE sphi:=sinphi[phi]
  END;
  FOR i:=0 TO nrVerticies-1 DO
    X:=x[i]; Z:=z[i];
    x[i]:=X*cphi - Z*sphi;
    z[i]:=Z*cphi + X*sphi;
  END;
 END YRotation;

PROCEDURE DegToRad(i: INTEGER): REAL;
 BEGIN
  RETURN REAL(i)*0.07
 END DegToRad;

PROCEDURE InitRotation;
 VAR
  i: CARDINAL; s: REAL;
 BEGIN
  maxAngle:=RND(MaxAngle DIV 2-1) + MaxAngle DIV 2-1;
  phi:=0; phidir:=1;
  angle:=0;
  maxCount:=MaxCount;
  FOR i:=0 TO MaxAngle DO
    sinphi[i]:=Sin(DegToRad(i));
    cosphi[i]:=Cos(DegToRad(i))
  END
 END InitRotation;

PROCEDURE Convert2D;
 (* project 3D image onto 2D surface. *)
 VAR i: CARDINAL; f: REAL;
 BEGIN
  FOR i:=0 TO nrVerticies-1 DO
    f:=1000.0 / (distance - z[i]);
    x2D[i]:=INTEGER(x[i]*f);
    y2D[i]:=INTEGER(y[i]*f);
  END;
 END Convert2D;

PROCEDURE InitCube;
 BEGIN
  x[0]:=-150.0; y[0]:= 150.0; z[0]:= 150.0;
  x[1]:= 150.0; y[1]:= 150.0; z[1]:= 150.0;
  x[2]:= 150.0; y[2]:= 150.0; z[2]:=-150.0;
  x[3]:=-150.0; y[3]:= 150.0; z[3]:=-150.0;
 END InitCube;

PROCEDURE NewDir(): REAL;
 BEGIN
  RETURN REAL(RND(60)+40);
 END NewDir;

PROCEDURE DrawCube;
 CONST
  centerX=WIDTH DIV 2;
  centerY=HEIGHT DIV 2;
 VAR
  left: INTEGER;
  i, j, k: CARDINAL;
  vertex: CARDINAL;
  rightObscured: BOOLEAN;
  err: BOOLEAN;
  res: BOOLEAN;
 BEGIN
  SetRast(rp, 0);
   (* find leftmost vertex of base plane *)
  left:=x2D[0]; i:=0;
  FOR vertex:=1 TO nrVerticies-1 DO
    IF x2D[vertex]<left THEN left:=x2D[vertex]; i:=vertex; END;
  END;

  j:=(i+1) MOD nrVerticies;
  k:=(i+2) MOD nrVerticies;

   (* see if right plane is obscured by left plane *)
  rightObscured:=x2D[j]>=x2D[k];

   (* draw left visible plane *)
  IF rightObscured THEN SetAPen(rp,3) ELSE SetAPen(rp,1); END;

  err:=AreaMove(rp, centerX+x2D[i],centerY+y2D[i]);
  err:=AreaDraw(rp, centerX+x2D[j],centerY+y2D[j]);
  err:=AreaDraw(rp, centerX+x2D[j],centerY-y2D[j]);
  err:=AreaDraw(rp, centerX+x2D[i],centerY-y2D[i]);
  err:=AreaDraw(rp, centerX+x2D[i],centerY+y2D[i]);
  res:=AreaEnd(rp);

  IF NOT rightObscured THEN
    (* draw right visible plane *)
    SetAPen(rp, 2);
    err:=AreaMove(rp, centerX+x2D[j],centerY+y2D[j]);
    err:=AreaDraw(rp, centerX+x2D[k],centerY+y2D[k]);
    err:=AreaDraw(rp, centerX+x2D[k],centerY-y2D[k]);
    err:=AreaDraw(rp, centerX+x2D[j],centerY-y2D[j]);
    res:=AreaEnd(rp);
  END;

  FlipDBufScreen(scr);

  SetRGB4(vp, 1, (89-angle) DIV 8 + 4, 0, 0);
  SetRGB4(vp, 2, angle DIV 8 + 4, 0, 0);
 END DrawCube;

PROCEDURE Do(n: CARDINAL);
 BEGIN
  WHILE n>0 DO YRotation; Convert2D; DrawCube; DEC(n) END;
 END Do;

PROCEDURE Cleanup;
 VAR i: INTEGER;
 BEGIN
  IF trp#NIL THEN FreeRaster(trp, WIDTH, HEIGHT) END;
  IF scr#NIL THEN CloseScreen(scr) END;
  FOR now:=0 TO 1 DO
   WITH map[now] DO
    FOR i:=0 TO DEPTH-1 DO
     IF planes[i]#NIL THEN FreeRaster(planes[i], WIDTH, HEIGHT) END
    END
   END
  END
 END Cleanup;

VAR
 ai: AreaInfo;
 tr: TmpRas;
 abuf: ARRAY [0..49] OF CARDINAL;
 i: INTEGER;
BEGIN
 scr:=NIL; trp:=NIL;
 InitCube;
 InitRotation;

 scr:=CreateDBufScreen(WIDTH, HEIGHT, DEPTH);
 Assert(scr#NIL, ADR('cannot open screen'));
 rp:=ADR(scr^.rastPort);
 vp:=ADR(scr^.viewPort);
 SetRGB4(vp, 0, 0, 0, 0);
 SetRGB4(vp, 1, 0, 0, 0);
 SetRGB4(vp, 2, 0, 0, 0);
 SetRGB4(vp, 3, 15, 0, 0);

 trp:=AllocRaster(WIDTH, HEIGHT);
 Assert(trp#NIL, ADR('cannot alloc trp'));
 InitTmpRas(tr, trp, ((WIDTH+15) DIV 16) * HEIGHT);
 InitArea(ai, ADR(abuf), SIZE(abuf) DIV 5);
 rp^.areaInfo:=ADR(ai);
 rp^.tmpRas:=ADR(tr);

  (* just rotate on spot at first *)
 distance:=6500.0; Do(40);
 dir:=NewDir();
 FOR i:=0 TO 250 DO
  Do(1);
  distance:=distance + dir;
  IF distance<=1800.0 THEN dir:=NewDir(); Do(RND(30)+20)
  ELSIF distance>=6500.0 THEN dir:=-NewDir(); Do(RND(30)+20)
  END
 END
CLOSE
 Cleanup
END cube.mod
