|##########|
|#MAGIC   #|DEMKANJI
|#PROJECT #|"MemWatcher"
|#PATHS   #|"StdProject"
|#FLAGS   #|xx---x--xx----x-----------------
|#USERSW  #|--------------------------------
|#USERMASK#|--------------------------------
|#SWITCHES#|x----xxxxx-xx---
|##########|
MODULE MemWatcher;
|
| MemWatcher, the Workbench surrogate for drip.
|
| Version 1.0
| Tested with Enforcer, Mungwall, MemWatcher
| No known errors
|
| (c)1995 F.Brandau
|
FROM Intuition   IMPORT WindowGrp,ScreenGrp,BorderGrp,BorderList,DrawInfoPtr,
                        GetScreenDrawInfo,DrawBorder,IntuiTextGrp,
                        IntuiTextLength,PrintIText,GadgetGrp,boolGadget;
FROM Graphics    IMPORT DrawGrp,jam1,PenArrayPtr,ScrollRaster,SetAPen,EraseRect;
FROM Exec        IMPORT MemGrp,MsgPortGrp;
FROM Heap        IMPORT New;
FROM Conversions IMPORT IntToString,StringToInt;
FROM Strings     IMPORT SysStr,Str;
FROM Dos         IMPORT Delay,FileLockPtr,GetProgramDir,CurrentDir;
FROM Icon        IMPORT DiskObjectGrp,ToolTypeGrp;
|
| Exceptions
|
EXCEPTION
  ScreenNotLocked  : "Unable to lock screen.";
  WindowNotOpen    : "Window failed to open.";
  NoDrawInfo       : "Could not get Draw Info.";
|
| Constants
|
CONST
  Vers             = "$VER: MemWatcher 1.0 (21.3.95)";
|
| Variables
|
VAR
  Version          : STRING(50);
  |
  | ToolTypes
  |
  PubScreen        : STRING(80);
  DisplayWidth     : INTEGER                          := 200;
  Time             : INTEGER                          := 10;
  XPos             : INTEGER                          := 100;
  YPos             : INTEGER                          := 100;
  FileLckPtr       ,
  OldDir           : FileLockPtr;
  DiskObjPtr       : DiskObjectPtr;
  SysText          : SysStringPtr;
  ToolTypeTxt      : STRING(80);
  |
  | Screen colours
  |
  MainDrawInfo     : DrawInfoPtr;
  PenPtr           : PenArrayPtr;
  |DetailPen        ,
  BlockPen         ,
  |TextPen          ,
  ShinePen         ,
  ShadowPen        ,
  FillPen          ,
  |FillTextPen      ,
  |BackgroundPen    ,
  HighLightTextPen : SHORTCARD;
  |
  | Workspace
  |
  MainWindow       : WindowPtr;
  WorkScreen       : ScreenPtr;
  FontSize         : INTEGER;
  MainBorder       : BorderPtr;
  oldX,oldY        : INTEGER;
  BaseGadget       : Gadget;
  |
  | Program body
  |
  Msg              : IntuiMessagePtr;
  EndPrg           : BOOLEAN                          := FALSE;
  |
  | Memory handling
  |
  MemBase          : LONGCARD;
  OldMem           ,
  MemDiff          : LONGINT;

|
| Subroutine : Create and initialise border structure
|
PROCEDURE CreateBorder(link : BorderPtr;left,top,width,height : INTEGER):BorderPtr;
|
| ShadowPen and ShinePen must be provided by calling program
|
VAR
  shine,shadow : POINTER TO Border;
  shiD,shaD    : POINTER TO BorderList(6);
  store        : BorderPtr;

BEGIN
  New(shine);
  New(shadow);
  New(shiD);
  New(shaD);
  shiD^              := BorderList:((0,0),(0,0),(0,0),(0,0),(1,0),(1,1));
  shaD^              := BorderList:((1,0),(0,0),(0,0),(0,1),(0,1),(0,0));
  shiD[0].x          := width-2;
  shiD[2].y          := height-1;
  shiD[3].y          := height-2;
  shiD[4].y          := height-2;
  shaD[0].y          := height-1;
  shaD[1].x          := width-1;
  shaD[1].y          := height-1;
  shaD[2].x          := width-1;
  shaD[3].x          := width-1;
  shaD[4].x          := width-2;
  shaD[5].x          := width-2;
  shaD[5].y          := height-2;

  shadow^            := Border:(0,0,0,0,jam1,6,NIL,NIL);
  shine^             := Border:(0,0,0,0,jam1,6,NIL,NIL);

  shadow^.leftEdge   := left;
  shadow^.topEdge    := top;
  shadow^.frontPen   := ShadowPen;
  shine^.leftEdge    := left;
  shine^.topEdge     := top;
  shine^.frontPen    := ShinePen;

  shadow^.xy         := shaD;
  shadow^.nextBorder := shine;
  shine^.xy          := shiD;

  IF link#NIL THEN
    store:=link;
    WHILE store^.nextBorder#NIL DO
      store:=store^.nextBorder
    END;
    store^.nextBorder:=shadow;
    RETURN(link)
  ELSE
    RETURN(shadow)
  END
END CreateBorder;

|
| Subroutine : Center text into window
|
PROCEDURE Center(Win : WindowPtr;AtY : LONGINT;Str : STRING);
VAR
  Text : IntuiText;
BEGIN
  Text           := IntuiText:(1,2,jam1,0,0,NIL,NIL,NIL);
  Text.iTextFont := Win^.wScreen^.font;
  Str.data[Str.len]:=&0;
  Text.iText     := Str.data'PTR;
  Text.leftEdge  := (Win^.width-Win^.borderLeft-Win^.borderRight) DIV 2
                    + Win^.borderLeft - IntuiTextLength(Text'PTR) DIV 2;
  Text.topEdge   := AtY;
  PrintIText(Win^.rPort,Text'PTR,0,0);
END Center;

|
| Subroutine : Scroll and update display
|
PROCEDURE DrawMem;
VAR
  mempoint : INTEGER;
BEGIN
  WITH MainWindow^.rPort AS Rast DO
    |
    | Scroll display
    |
    ScrollRaster(Rast,1,0,
                      MainWindow^.borderLeft+2,
                      MainWindow^.borderTop+1,
                      INTEGER(MainWindow^.borderLeft)+2+DisplayWidth,
                      MainWindow^.borderTop+101);
    |
    | Draw baseline
    |
    SetAPen(Rast,BlockPen);
    FORGET WritePixel(Rast,INTEGER(MainWindow^.borderLeft)+2+DisplayWidth,MainWindow^.borderTop+51);
    SetAPen(Rast,HighLightTextPen);
    |
    | Compute memorypoint
    |
    MemDiff:=LONGINT(MemBase)-LONGINT(AvailMem(MemReqSet:{}));
    IF MemDiff=0 THEN
      SetAPen(Rast,FillPen);
      mempoint:=0
    ELSE
      mempoint:=INTEGER(15*LOG(REAL(ABS(MemDiff))/1000+1));
      mempoint:=mempoint*(MemDiff DIV ABS(MemDiff));
    END;
    |
    | Write memory difference
    |
    IF OldMem#MemDiff THEN
      EraseRect(Rast,MainWindow^.borderLeft+2,
                     MainWindow^.borderTop+104,
                     INTEGER(MainWindow^.borderLeft)+DisplayWidth+2,
                     INTEGER(MainWindow^.borderTop)+103+FontSize+6);
      Center(MainWindow,MainWindow^.borderTop+107,IntToString(MemDiff));
      OldMem:=MemDiff;
    END;
    |
    | Draw memoryline
    |
    IF ABS(mempoint)-50>0 THEN
      mempoint:=50;
      SetAPen(Rast,FillPen)
    END;
    Move(Rast,oldX,oldY);
    oldX:=INTEGER(MainWindow^.borderLeft)+2+DisplayWidth;
    oldY:=MainWindow^.borderTop+51-mempoint;
    Draw(Rast,oldX,oldY);
  END
END DrawMem;

|
| Main
|
BEGIN
  Version:=Vers;
  |
  | Read ToolTypes
  |  currently recognized types:
  |   -PubScreen name (PubScreen)
  |   -XPos
  |   -YPos
  |   -Timebase
  |   -DisplayWidth   (Display)
  |
  FileLckPtr := GetProgramDir();
  OldDir     := CurrentDir(FileLckPtr);
  DiskObjPtr := GetDiskObject("MemWatcher");
  IF DiskObjPtr#NIL THEN
    WITH DiskObjPtr^.toolTypes AS TTyp DO
      |
      | PubScreen name
      |
      SysText:=FindToolType(TTyp,SysStr("PubScreen"));
      IF SysText#NIL THEN
        PubScreen:=Str(SysText);
        PubScreen.data[PubScreen.len]:=&0
      END;
      |
      | XPos
      |
      SysText:=FindToolType(TTyp,SysStr("XPos"));
      IF SysText#NIL THEN
        ToolTypeTxt:=Str(SysText);
        XPos:=StringToInt(ToolTypeTxt)
      END;
      |
      | YPos
      |
      SysText:=FindToolType(TTyp,SysStr("YPos"));
      IF SysText#NIL THEN
        ToolTypeTxt:=Str(SysText);
        YPos:=StringToInt(ToolTypeTxt)
      END;
      |
      | Timebase
      |
      SysText:=FindToolType(TTyp,SysStr("Timebase"));
      IF SysText#NIL THEN
        ToolTypeTxt:=Str(SysText);
        Time:=StringToInt(ToolTypeTxt)
      END;
      |
      | DisplayWidth
      |
      SysText:=FindToolType(TTyp,SysStr("Display"));
      IF SysText#NIL THEN
        ToolTypeTxt:=Str(SysText);
        DisplayWidth:=StringToInt(ToolTypeTxt)
      END;
      |
      | ...
      |
    END;
    FreeDiskObject(DiskObjPtr);
    DiskObjPtr:=NIL
  END;
  |
  | Get the current public screen
  |
  IF PubScreen.len=0 THEN
    WorkScreen:=LockPubScreen(NIL)
  ELSE
    WorkScreen:=LockPubScreen(PubScreen.data'PTR)
  END;
  ASSERT(WorkScreen#NIL,ScreenNotLocked);
  |
  | Initialise colors from screen
  |
  MainDrawInfo:=GetScreenDrawInfo(WorkScreen);
  ASSERT(MainDrawInfo#NIL,NoDrawInfo);
  |
  | Values for pen array taken from include/intuition/screens.h
  |
  PenPtr           := MainDrawInfo^.pens;
  |DetailPen        := PenPtr[$0000];
  BlockPen         := PenPtr[$0001];
  |TextPen          := PenPtr[$0002];
  ShinePen         := PenPtr[$0003];
  ShadowPen        := PenPtr[$0004];
  FillPen          := PenPtr[$0005];
  |FillTextPen      := PenPtr[$0006];
  |BackgroundPen    := PenPtr[$0007];
  HighLightTextPen := PenPtr[$0008];
  |
  | Read current fontsize
  |
  FontSize:=INTEGER(WorkScreen^.font^.ySize);
  |
  | Open main window
  |
  MainWindow:=OpenWindowTags(NIL,
                             left         : XPos,
                             top          : YPos,
                             innerWidth   : DisplayWidth + 5,
                             innerHeight  : FontSize+111,
                             IDCMP        : IDCMPFlagSet:{closeWindow,gadgetUp},
                             customScreen : WorkScreen,
                             title        : "MemWatcher".data'PTR,
                             dragBar      : TRUE,
                             depthGadget  : TRUE,
                             closeGadget  : TRUE,
                             activate     : TRUE,
                             DONE
                            );
  ASSERT(MainWindow#NIL,WindowNotOpen);
  |
  | Window is open
  |
  UnlockPubScreen(NIL,WorkScreen);
  |
  | Draw window graphics
  |
  WITH MainWindow^.rPort AS Rast DO
    MainBorder:=CreateBorder(MainBorder,MainWindow^.borderLeft,MainWindow^.borderTop,DisplayWidth+5,103);
    MainBorder:=CreateBorder(MainBorder,MainWindow^.borderLeft,MainWindow^.borderTop+103,DisplayWidth+5,FontSize+8);
    DrawBorder(Rast,MainBorder,0,0);
    Center(MainWindow,MainWindow^.borderTop+107,"MemWatcher by F.Brandau");
  END;
  |
  | Add gadget
  |
  BaseGadget.nextGadget    := NIL;
  BaseGadget.leftEdge      := MainWindow^.borderLeft+2;
  BaseGadget.topEdge       := MainWindow^.borderTop+104;
  BaseGadget.width         := DisplayWidth+1;
  BaseGadget.height        := FontSize+6;
  BaseGadget.flags         := gadgHComp;
  BaseGadget.activation    := ActivationFlagSet:{relVerify};
  BaseGadget.gadgetType    := boolGadget;
  BaseGadget.gadgetRender  := NIL;
  BaseGadget.selectRender  := NIL;
  BaseGadget.gadgetText    := NIL;
  BaseGadget.mutualExclude := {};
  BaseGadget.specialInfo   := NIL;
  BaseGadget.gadgetID      := 0;
  BaseGadget.userData      := NIL;
  FORGET AddGList(MainWindow,BaseGadget'PTR,65535,1,NIL);
  RefreshGList(BaseGadget'PTR,MainWindow,NIL,-1);
  |
  | Set memorybase
  |
  MemBase:=AvailMem(MemReqSet:{});
  |
  | Draw baseline
  |
  SetAPen(MainWindow^.rPort,BlockPen);
  Move(MainWindow^.rPort,MainWindow^.borderLeft+2,MainWindow^.borderTop+51);
  Draw(MainWindow^.rPort,INTEGER(MainWindow^.borderLeft)+2+DisplayWidth,MainWindow^.borderTop+51);
  oldX:=INTEGER(MainWindow^.borderLeft)+2+DisplayWidth;
  oldY:=MainWindow^.borderTop+51;
  |
  | Main idcmp loop (action type)
  |
  WITH MainWindow^.userPort AS Port DO
    REPEAT
      DrawMem;
      Delay(Time);
      Msg:=GetMsg(Port);
      IF Msg#NIL THEN
        IF KEY Msg^.class
          OF {closeWindow} THEN
            EndPrg:=TRUE
          END
          OF {gadgetUp} THEN
            MemBase:=AvailMem(MemReqSet:{})
          END
        END;
        ReplyMsg(Msg)
      END
    UNTIL EndPrg
  END;

CLOSE
  IF MainWindow#NIL THEN
    CloseWindow(MainWindow)
  END;
  IF DiskObjPtr#NIL THEN
    FreeDiskObject(DiskObjPtr)
  END;
  OldDir:=CurrentDir(OldDir)
END MemWatcher.
