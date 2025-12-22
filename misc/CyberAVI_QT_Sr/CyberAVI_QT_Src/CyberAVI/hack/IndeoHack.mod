MODULE  IndeoHack;

IMPORT  d:=Dos,
        e:=Exec,
        i2m:=Intel2Mot,
        ol:=OberonLib,
        y:=SYSTEM;

VAR     yt,ub,ug,vr,vg: ARRAY 256 OF LONGINT;
        indeoBufs: e.LSTRPTR;
        f: d.FileHandlePtr;

(* /// ----------------------- "PROCEDURE IndeoGenYUV()" ----------------------- *)
PROCEDURE IndeoGenYUV();

VAR     i: LONGINT;
        val: LONGINT;
        x1,x2,x3,x4,x5: LONGINT;

BEGIN
  val:=04563H;
  FOR i:=127 TO 0 BY -1 DO
    yt[i]:=val;
    DEC(val,149);
  END;
  x3:=-13056;
  x5:=6656;
  x4:=6400;
  x2:=-16640;
  x1:=-16384;
  FOR i:=0 TO 127 DO
    ub[i]:=(x1 DIV 2)+(x2 DIV 2);
    ug[i]:=x4 DIV 2;
    vg[i]:=x5;
    vr[i]:=x3;
    INC(x3,204);
    DEC(x5,104);
    DEC(x4,100);
    INC(x2,260);
    INC(x1,256);
  END;
  FOR i:=0 TO 127 DO
    yt[i+128]:=yt[i];
    ub[i+128]:=ub[i];
    ug[i+128]:=ug[i];
    vg[i+128]:=vg[i];
    vr[i+128]:=vr[i];
  END;
  d.PrintF("writing yBuf\n");
  f:=d.Open("sd0:y",d.newFile);
  IF f#NIL THEN
    IF d.Write(f,yt,1024)=1024 THEN END;
    d.OldClose(f);
  END;
  d.PrintF("writing ubBuf\n");
  f:=d.Open("sd0:ub",d.newFile);
  IF f#NIL THEN
    IF d.Write(f,ub,1024)=1024 THEN END;
    d.OldClose(f);
  END;
  d.PrintF("writing ugBuf\n");
  f:=d.Open("sd0:ug",d.newFile);
  IF f#NIL THEN
    IF d.Write(f,ug,1024)=1024 THEN END;
    d.OldClose(f);
  END;
  d.PrintF("writing vgBuf\n");
  f:=d.Open("sd0:vg",d.newFile);
  IF f#NIL THEN
    IF d.Write(f,vg,1024)=1024 THEN END;
    d.OldClose(f);
  END;
  d.PrintF("writing vrBuf\n");
  f:=d.Open("sd0:vr",d.newFile);
  IF f#NIL THEN
    IF d.Write(f,vr,1024)=1024 THEN END;
    d.OldClose(f);
  END;
END IndeoGenYUV;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------- "PROCEDURE IndeoInitYUVBufs()" --------------------- *)
PROCEDURE IndeoInitYUVBufs(width: LONGINT;
                           height: LONGINT);
VAR     size: LONGINT;
        w16: LONGINT;
        h16: LONGINT;
        cnt: LONGINT;
        ptr: e.LSTRPTR;

BEGIN
  w16:=i2m.Round(width,16);
  h16:=i2m.Round(height,16);
  size:=2*w16*h16+4*w16;
  ol.New(indeoBufs,size);
  ptr:=indeoBufs;
  FOR cnt:=0 TO w16-1 DO ptr[cnt]:=40X; END;
  ptr:=y.VAL(e.LSTRPTR,y.VAL(LONGINT,indeoBufs)+size DIV 2-w16);
  FOR cnt:=0 TO w16-1 DO ptr[cnt]:=40X; END;
  ptr:=y.VAL(e.LSTRPTR,y.VAL(LONGINT,indeoBufs)+size-w16*2);
  FOR cnt:=0 TO w16*2-1 DO ptr[cnt]:=40X; END;
  d.PrintF("writing yuvBufs, %ldx%ld -> %ldx%ld, size: %ld\n",width,height,w16,h16,size);
  f:=d.Open("sd0:yuvBufs",d.newFile);
  IF f#NIL THEN
    IF d.Write(f,indeoBufs^,size)=0 THEN END;
    d.OldClose(f);
  END;
END IndeoInitYUVBufs;
(* \\\ ------------------------------------------------------------------------- *)

BEGIN
  IndeoGenYUV();
  IndeoInitYUVBufs(160,120);
END IndeoHack.

