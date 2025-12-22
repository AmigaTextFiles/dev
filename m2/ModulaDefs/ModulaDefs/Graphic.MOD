(*************************************
 * Name : Graphic.MOD                *
 * Purpose : Graphics library        *
 *           drawing routines        *
 * Author : JSG                      *
 *************************************)

IMPLEMENTATION MODULE Graphic;

FROM SYSTEM IMPORT ADDRESS,ADR;
FROM AMIGABase IMPORT Regs,ExecBase,ExecOpenLib,LibCall;

CONST
     text       = -60;
     drawell    = -180;
     areaell    = -186;
     setrast    = -234;
     move       = -240;
     draw       = -246;
     areamov    = -252;
     areadr     = -258;
     arend      = -264;
     initarea   = -282;
     setrgb4    = -288;
     rectfill   = -306;
     writepix   = -324;
     flood      = -330;
     setapen    = -342;
     setbpen    = -348;

VAR
    gfxbase : ADDRESS;
    reg : Regs;


PROCEDURE Draw(rP : ADDRESS; x,y : LONGINT);

BEGIN

  reg.a[1] := rP;
  reg.d[0] := x;
  reg.d[1] := y;
  LibCall(gfxbase,draw,reg);

END Draw;


PROCEDURE Move(rP:ADDRESS; x,y : LONGINT);

BEGIN
   reg.a[1] := rP;
   reg.d[0] := x;
   reg.d[1] := y;
   LibCall(gfxbase,move,reg);
END Move;

PROCEDURE Text(rP:ADDRESS;VAR st : ARRAY OF CHAR;len : LONGINT);

BEGIN
  reg.a[1] := rP;
  reg.a[0] := ADR(st);
  reg.d[0] := len;
  LibCall(gfxbase,text,reg);
END Text;

PROCEDURE SetAPen(rP:ADDRESS;fg:LONGINT);

BEGIN
  reg.a[1] := rP;
  reg.d[0] := fg;
  LibCall(gfxbase,setapen,reg);
END SetAPen;

PROCEDURE SetBPen(rP:ADDRESS;bg : LONGINT);

BEGIN
  reg.a[1] := rP;
  reg.d[0] := bg;
  LibCall(gfxbase,setbpen,reg);
END SetBPen;

PROCEDURE SetRast(rP:ADDRESS; bg :LONGINT);

BEGIN
  reg.a[1] := rP;
  reg.d[0] := bg;
  LibCall(gfxbase,setrast,reg);
END SetRast;

PROCEDURE RectFill(rP:ADDRESS; xmin,ymin,xmax,ymax : LONGINT);

BEGIN
  reg.a[1] := rP;
  reg.d[0] := xmin;
  reg.d[1] := ymin;
  reg.d[2] := xmax;
  reg.d[3] := ymax;
  LibCall(gfxbase,rectfill,reg);
END RectFill;

PROCEDURE WritePixel(rP:ADDRESS; x,y:LONGINT);

BEGIN
  reg.a[1] := rP;
  reg.d[0] := x;
  reg.d[1] := y;
  LibCall(gfxbase,writepix,reg);
END WritePixel;

PROCEDURE Flood(rP:ADDRESS;dm,x,y : LONGINT);

BEGIN
  reg.a[1] := rP;
  reg.d[2] := dm;
  reg.d[0] := x;
  reg.d[1] := y;
  LibCall(gfxbase,flood,reg);
END Flood;

PROCEDURE SetRGB4(vP:ADDRESS;n,ri,gi,bi:LONGINT);

BEGIN
  reg.a[0] := vP;
  reg.d[0] := n;
  reg.d[1] := ri;
  reg.d[2] := gi;
  reg.d[3] := bi;
  LibCall(gfxbase,setrgb4,reg);
END SetRGB4;

PROCEDURE DrawEllipse(rP:ADDRESS;cx,cy,a,b:LONGINT);

BEGIN
  reg.a[1] := rP;
  reg.d[0] := cx;
  reg.d[1] := cy;
  reg.d[2] := a;
  reg.d[3] := b;
  LibCall(gfxbase,drawell,reg);
END DrawEllipse;

PROCEDURE AreaEllipse(rP:ADDRESS;cx,cy,a,b:LONGINT);

BEGIN
  reg.a[1] := rP;
  reg.d[0] := cx;
  reg.d[1] := cy;
  reg.d[2] := a;
  reg.d[3] := b;
  LibCall(gfxbase,areaell,reg);
END AreaEllipse;

PROCEDURE InitArea(ai,buff:ADDRESS;maxv:LONGINT);

BEGIN
  reg.a[0] := ai;
  reg.a[1] := buff;
  reg.d[0] := maxv;
  LibCall(gfxbase,initarea,reg);
END InitArea;

PROCEDURE AreaMove(rP:ADDRESS;x,y:LONGINT) : LONGINT;

BEGIN
  reg.a[1] := rP;
  reg.d[0] := x;
  reg.d[1] := y;
  LibCall(gfxbase,areamov,reg);
  RETURN reg.d[0];
END AreaMove;

PROCEDURE AreaDraw(rP:ADDRESS;x,y:LONGINT):LONGINT;

BEGIN
  reg.a[1] := rP;
  reg.d[0] := x;
  reg.d[1] := y;
  LibCall(gfxbase,areadr,reg);
  RETURN reg.d[0];
END AreaDraw;

PROCEDURE AreaEnd(rP:ADDRESS);

BEGIN
  reg.a[1] := rP;
  LibCall(gfxbase,arend,reg);
END AreaEnd;


VAR st : ARRAY[0..15] OF CHAR;
    r : Regs;

BEGIN
   st := 'graphics.library';
   r.a[1] := ADR(st);
   r.d[0] := 0D;
   LibCall(ExecBase(),ExecOpenLib(),r);
   gfxbase := r.d[0];
END Graphic.

