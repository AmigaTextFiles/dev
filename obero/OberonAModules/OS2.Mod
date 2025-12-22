(*
OS2.Mod for Oberon-A:
This module makes it much easier to make fontsensitive GUI's with GadTools
in Oberon-A.
This module was originally a Unit for Pascal done by Björn Schotte.

OS2.Mod was converted by:
  Morten Bjergstrøm
  EMail: mbjergstroem@hotmail.com
*)



<*STANDARD-*>
MODULE OS2;

IMPORT
  d:=Dos,
  e:=Exec,
  g:=Graphics,
  gt:=GadTools,
  i:=Intuition,
  ie:=InputEvent,
  u:=Utility,
  Sets,
  SYS:=SYSTEM;


VAR
  topaz80 : g.TextAttr;
  MyTattr* : g.TextAttrPtr;
  WBRight*,WBBottom*,ScreenW*,ScreenH*,FontX*,FontY*,XOff*,YOff* : INTEGER;



PROCEDURE ComputeX*(value:INTEGER):INTEGER;

BEGIN
  RETURN (((FontX*value)+4) DIV 8);
END ComputeX;

PROCEDURE ComputeY*(value:INTEGER):INTEGER;

BEGIN
  RETURN (((FontY*value)+4) DIV 8);
END ComputeY;

PROCEDURE ComputeTopazX*(value:INTEGER):INTEGER;

BEGIN
  RETURN (8*value-4) DIV FontX+1;
END ComputeTopazX;

PROCEDURE ComputeTopazY*(value:INTEGER):INTEGER;

BEGIN
  RETURN (8*value-4) DIV FontY+1;
END ComputeTopazY;

PROCEDURE ComputeFont*(VAR f:g.TextFontPtr; width,height:INTEGER);

  PROCEDURE UseTopaz();

  BEGIN
    MyTattr.name:=SYS.ADR("topaz.font");
    FontX:=8;
    FontY:=8;
    MyTattr.flags:={g.romFont};
    MyTattr.ySize:=8;
  END UseTopaz;


BEGIN
  e.Forbid;
  MyTattr:=SYS.ADR(topaz80);
  MyTattr.name:=f.message.node.name;
  MyTattr.ySize:=f.ySize;
  FontY:=f.ySize;
  FontX:=f.xSize;
  e.Permit;
  IF (width>0) & (height>0) THEN
    IF ((ComputeX(width)+XOff+WBRight)>ScreenW) THEN UseTopaz() END;
    IF ((ComputeY(height)+YOff+WBBottom)>ScreenH) THEN UseTopaz() END;
  END;
END ComputeFont;

PROCEDURE SensitivGadget*(VAR ng:gt.NewGadget);

BEGIN
  ng.leftEdge:=ComputeX(ng.leftEdge)+XOff;
  ng.topEdge:=ComputeY(ng.topEdge)+YOff;
  ng.width:=ComputeX(ng.width);
  ng.height:=ComputeY(ng.height);
END SensitivGadget;

PROCEDURE FS_BevelBox*(VAR wo:i.WindowPtr; VAR vi:gt.VisualInfo; x,y,b,h:INTEGER; recessed:BOOLEAN);

BEGIN
  gt.DrawBevelBox(wo.rPort,
                   XOff+ComputeX(x),
                   YOff+ComputeY(y),
                   ComputeX(b),
                   ComputeY(h),
                   gt.visualInfo,vi,
                   gt.bbRecessed,recessed,
                   u.done);
END FS_BevelBox;

PROCEDURE GadSelect*(VAR wp:i.WindowPtr; VAR gad:i.GadgetPtr);

VAR
  next:i.GadgetPtr;
  old:Sets.SET32;
  dummy:BOOLEAN;
  class:Sets.SET32;
  code:INTEGER;
  msg:i.IntuiMessagePtr;

BEGIN
  old:=wp.idcmpFlags;
  dummy:=i.ModifyIDCMP(wp,{i.rawKey});
  next:=gad.nextGadget;
  gad.nextGadget:=NIL;
  gad.flags:=gad.flags+{i.selected};
  i.RefreshGadgets(gad,wp,NIL);
  REPEAT
    e.WaitPort(wp.userPort);
    msg:=gt.GetIMsg(wp.userPort);
    class:=msg.class;
    code:=msg.code;
    gt.ReplyIMsg(msg);
  UNTIL (i.rawKey IN class) & (code=ie.upPrefix); (*Skal laves om*)
  dummy:=i.ModifyIDCMP(wp,old);
  gad.flags:=gad.flags-{i.selected};
  i.RefreshGadgets(gad,wp,NIL);
  gad.nextGadget:=next;
END GadSelect;

PROCEDURE SetCheckBox*(VAR wp:i.WindowPtr; VAR gad:i.GadgetPtr; req:i.RequesterPtr; flag:BOOLEAN);

BEGIN
  gt.SetGadgetAttrs(gad^,wp,req,
                     gt.cbChecked,flag,
                     u.done);
END SetCheckBox;

PROCEDURE SetMXGad*(VAR wp:i.WindowPtr; VAR gad:i.GadgetPtr; req:i.RequesterPtr; active:INTEGER);

BEGIN
  gt.SetGadgetAttrs(gad^,wp,req,
                    gt.mxActive,active,
                    u.done);
END SetMXGad;

PROCEDURE SetCycleGad*(VAR wp:i.WindowPtr; VAR gad:i.GadgetPtr; req:i.RequesterPtr; active:INTEGER);

BEGIN
  gt.SetGadgetAttrs(gad^,wp,req,
                    gt.cyActive,active,
                    u.done);
END SetCycleGad;

PROCEDURE SetListViewGad*(VAR wp:i.WindowPtr; VAR gad:i.GadgetPtr; req:i.RequesterPtr; active,top:INTEGER);

BEGIN
  gt.SetGadgetAttrs(gad^,wp,req,
                    gt.lvSelected,active,
                    gt.lvTop,top,
                    u.done);
END SetListViewGad;

PROCEDURE SetListViewList*(VAR wp:i.WindowPtr; VAR gad:i.GadgetPtr; req:i.RequesterPtr; VAR NeueList:e.ListPtr);

BEGIN
  gt.SetGadgetAttrs(gad^,wp,req,
                    gt.lvLabels,NeueList,
                    u.done);
END SetListViewList;

PROCEDURE SetNumberGad*(VAR wp:i.WindowPtr; VAR gad:i.GadgetPtr; req:i.RequesterPtr; nummer:INTEGER);

BEGIN
  gt.SetGadgetAttrs(gad^,wp,req,
                    gt.nmNumber,nummer,
                    u.done);
END SetNumberGad;


PROCEDURE GhostGadget*(VAR wp:i.WindowPtr; VAR gad:i.GadgetPtr; req:i.RequesterPtr; dis:BOOLEAN);

BEGIN
  gt.SetGadgetAttrs(gad^,wp,req,
                    i.gaDisabled,dis,
                    u.done);
END GhostGadget;

PROCEDURE ActStringGad*(VAR wp:i.WindowPtr; VAR gad:i.GadgetPtr; req:i.RequesterPtr);

VAR
  dummy:BOOLEAN;

BEGIN
  dummy:=i.ActivateGadget(gad^,wp,req);
END ActStringGad;

PROCEDURE DrawBevelLine*(MyRp:g.RastPortPtr; VAR vi:gt.VisualInfo; x,y,b:INTEGER; recessed:BOOLEAN);

BEGIN
  gt.DrawBevelBox(MyRp,XOff+ComputeX(x),YOff+ComputeY(y),ComputeX(b),2,
                  gt.visualInfo,vi,
                  gt.bbRecessed,recessed,
                  u.done);
END DrawBevelLine;

PROCEDURE MakeGadget*(VAR NytGadget:gt.NewGadget; LeftEdge,TopEdge,Width,Height:INTEGER; Text:ARRAY OF CHAR; TextAttr:g.TextAttrPtr; ID: INTEGER; Flags:Sets.SET32; VisualInfo:gt.VisualInfo; UserData:e.APTR);

BEGIN

  NytGadget.leftEdge:=LeftEdge;
  NytGadget.topEdge:=TopEdge;
  NytGadget.width:=Width;
  NytGadget.height:=Height;
  NytGadget.gadgetText:=SYS.ADR(Text);
  NytGadget.textAttr:=TextAttr;
  NytGadget.gadgetID:=ID;
  NytGadget.flags:=Flags;
  NytGadget.visualInfo:=VisualInfo;
  NytGadget.userData:=UserData;

END MakeGadget;

PROCEDURE InitOS2*(Screen:i.ScreenPtr; VAR ScreenFont:g.TextFontPtr; VAR VisualInfo:gt.VisualInfo):BOOLEAN;

VAR
  DrawInfo:i.DrawInfoPtr;

BEGIN

  IF Screen=NIL THEN RETURN FALSE END;

  ScreenW:=Screen.width;
  ScreenH:=Screen.height;
  WBRight:=Screen.wBorRight;
  WBBottom:=Screen.wBorBottom;

  DrawInfo:=i.GetScreenDrawInfo(Screen);
  IF DrawInfo=NIL THEN RETURN FALSE END;

  ScreenFont:=DrawInfo.font;
  XOff:=Screen.wBorLeft;
  YOff:=Screen.wBorTop+ScreenFont.ySize+1;
  i.FreeScreenDrawInfo(Screen,DrawInfo);

  VisualInfo:=gt.GetVisualInfo(Screen,NIL);

  IF VisualInfo=NIL THEN RETURN FALSE END;

  ComputeFont(ScreenFont,0,0);

  RETURN TRUE;

END InitOS2;

BEGIN
  topaz80.name:=SYS.ADR("topaz.font");
  topaz80.ySize:=8;
  topaz80.style:={};
  topaz80.flags:={};
END OS2.
