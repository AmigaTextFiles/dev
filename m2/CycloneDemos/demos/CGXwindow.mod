(*------------------------------------------

  :Program.     CGXWindow
  :Author.      Marcel Timmermans [mt]
  :Address.     A.Dekenstr 22, NL 6836 RM, Arnhem
  :EMail.       mtimmerm@worldaccess.nl
  :Version.     V1.0
  :Date.        24-Dec-1995
  :Copyright.   Mario Kemper
  :Language.    Amiga Modula-2 System
  :Translator.  Amc 0.61 (Internal release)
  :Contents.    Demo for the Cybergraphics.library
  :Remarks.     Original C-Source by Matthias Scheler (Tron)
  :Remarks.     Conversion from Oberon source by Mario Kemper
  :Remarks.     Conversion to Cyclone Modula-2 [mt]
  :Usage.       Just start it from the cli
  :History.     1.0 [mt] 24-Dec-1995 : First Release

--------------------------------------------*)

(*$ RangeChk- *)
(* For M2Amgia use RangeChk:=FALSE *)

MODULE CGXWindow;

IMPORT cgfx:CyberGraphXL,cgfxD:CyberGraphXD,
       id:IntuitionD,il:IntuitionL,el:ExecL,ed:ExecD,
       dd:DosD,s:SYSTEM,ud:UtilityD,gfx:GraphicsD,
       A:ModulaLib; (* For M2Amiga use A:Arts *)



TYPE
  DataPtr = POINTER TO SHORTCARD;


CONST screenWantedWidth  = 640;
      screenWantedHeight = 480;
      screenWantedDepth  =  24;
      screenMinDepth     =  15;
      imageWidth         = 256;
      imageHeight        = 256;
      imageBpp           =   3;


PROCEDURE Min(a,b:INTEGER) : INTEGER;
BEGIN
  IF a<b THEN
    RETURN a;
  ELSE
    RETURN b;
  END;
END Min;


PROCEDURE CreateImageData(image : DataPtr;width,height:LONGINT);
VAR x,y:LONGCARD;
BEGIN
  FOR y:=0 TO height-1 DO
    FOR x:=0 TO width-1 DO
     image^:=SHORTCARD(x); INC(image); (* Red   *)
     image^:=SHORTCARD(y); INC(image); (* Green *)
     image^:=0;            INC(image); (* Blue  *)
    END;
  END;
END CreateImageData;


(* window handling *)

PROCEDURE InnerWidth (window : id.WindowPtr):LONGINT;
BEGIN
  RETURN (window^.width - window^.borderLeft - window^.borderRight);
END InnerWidth;

PROCEDURE InnerHeight (window : id.WindowPtr):LONGINT;
BEGIN
  RETURN (window^.height - window^.borderTop - window^.borderBottom);
END InnerHeight;


PROCEDURE RedrawScaleWindow (scaleWindow : id.WindowPtr; imageData : DataPtr);
VAR long:LONGINT;
BEGIN
  long:=cgfx.ScalePixelArray(imageData,imageWidth,imageHeight,imageWidth*imageBpp,
                       scaleWindow^.rPort,scaleWindow^.borderLeft,scaleWindow^.borderTop,
                       InnerWidth(scaleWindow), InnerHeight(scaleWindow),
                       cgfxD.rectfmtRGB);
END RedrawScaleWindow;


PROCEDURE RedrawWriteWindow(writeWindow : id.WindowPtr;imageData : DataPtr);
VAR long:LONGINT;

BEGIN
  long:=cgfx.WritePixelArray(imageData,0,0,imageWidth*imageBpp,
                             writeWindow^.rPort,writeWindow^.borderLeft,writeWindow^.borderTop,
                             InnerWidth(writeWindow),
                             InnerHeight(writeWindow),
                             cgfxD.rectfmtRGB);
END RedrawWriteWindow;

(* screen depth fallback *)

PROCEDURE NextDepth (depth : LONGINT):LONGINT;
VAR
result:LONGINT;

BEGIN
  CASE depth OF
  |24 : result:=16;
  |16 : result:=15;
  ELSE
   result:=0;
  END;
  RETURN result;
END NextDepth;

(* main program *)

VAR
  displayID,depth : LONGINT;
  cyberScreen     : id.ScreenPtr;
  scaleWindow,
  writeWindow     : id.WindowPtr;
  imageData       : DataPtr;
  done            : BOOLEAN;
  signal          : s.LONGSET;
  bool            : BOOLEAN;
  intMsg          : id.IntuiMessagePtr;
  tags            : ARRAY[0..10] OF ud.TagItem;
BEGIN
  done := FALSE;
  depth := screenWantedDepth;
  WHILE ((depth # 0) AND (NOT done)) DO
    displayID:=cgfx.BestCModeID(s.TAG(tags,cgfxD.cbmidNominalWidth,screenWantedWidth,
                                    cgfxD.cbmidNominalHeight,screenWantedHeight,
                                    cgfxD.cbmidDepth,depth,
                                    ud.tagDone));
    IF displayID # gfx.invalidID THEN
      depth:=cgfx.GetCyberIDAttr(LONGCARD(cgfxD.cidaDepth),displayID);
      done:=TRUE;
    ELSE
      depth:=NextDepth(depth);
    END;

  END (*WHILE*);

  A.Assert(~(depth < screenMinDepth),s.ADR("Cannot open screen"));

(* open screen, but let intuition choose the actual dimensions *)

  cyberScreen:=il.OpenScreenTagList(NIL,s.TAG(tags,id.saTitle,s.ADR("CyberGraphX Demo"),
                                  id.saDisplayID,displayID,
                                  id.saDepth,depth,ud.tagDone));

  A.Assert(cyberScreen#NIL,s.ADR("Can't open screen"));

  (* create scale Window *)

  scaleWindow:=il.OpenWindowTagList(NIL,s.TAG(tags,
                                  id.waTitle,s.ADR("Scale"),
                                  id.waFlags,id.WindowFlagSet{id.activate,id.simpleRefresh,
                                    id.windowSizing,id.rmbTrap,id.windowDrag,
                                    id.windowDepth,id.windowClose},
                                  id.waIDCMP,id.IDCMPFlagSet{
                                   id.closeWindow,id.refreshWindow,
                                   id.sizeVerify,id.newSize},
                                  id.waLeft,16,
                                  id.waTop,cyberScreen^.barHeight+16,
                                  id.waWidth,imageWidth,
                                  id.waHeight,imageHeight,
                                  id.waCustomScreen,cyberScreen,
                                  ud.tagDone));

  A.Assert(scaleWindow#NIL,s.ADR("Can't open scale window"));

  IF il.WindowLimits(scaleWindow,
                      scaleWindow^.borderLeft+scaleWindow^.borderRight+1,
                      scaleWindow^.borderTop+scaleWindow^.borderBottom+1,
                      cyberScreen^.width,cyberScreen^.height) THEN
  END;

  (* create Write window *)

  writeWindow:=il.OpenWindowTagList(NIL,s.TAG(tags,
                                  id.waTitle,s.ADR("Write"),
                                  id.waFlags,id.WindowFlagSet{id.activate,id.simpleRefresh,
                                    id.windowSizing,id.rmbTrap,id.windowDrag,
                                    id.windowDepth,id.windowClose},
                                  id.waIDCMP,id.IDCMPFlagSet{
                                   id.closeWindow,id.refreshWindow,
                                   id.sizeVerify,id.newSize},
                                  id.waLeft,cyberScreen^.width-16-imageWidth,
                                  id.waTop,cyberScreen^.barHeight+16,
                                  id.waWidth,imageWidth,
                                  id.waHeight,imageHeight,
                                  id.waCustomScreen,cyberScreen,
                                  ud.tagDone));

  A.Assert(writeWindow#NIL,s.ADR("Can't open write window"));

  IF il.WindowLimits(writeWindow,
                      writeWindow^.borderLeft+writeWindow^.borderRight+1,
                      writeWindow^.borderTop+writeWindow^.borderBottom+1,
                      Min(cyberScreen^.width,writeWindow^.borderLeft+
                          writeWindow^.borderRight+imageWidth),
                      Min(cyberScreen^.height,writeWindow^.borderTop+
                          writeWindow^.borderBottom+imageHeight)) THEN
  END;

  (* allocate and create image data *)

  imageData:=el.AllocVec(imageWidth*imageHeight*imageBpp,ed.MemReqSet{ed.public});
  A.Assert(imageData#NIL,s.ADR("out of memory"));

  CreateImageData (imageData,imageWidth,imageHeight);

(* event loop *)

  RedrawScaleWindow(scaleWindow,imageData);
  RedrawWriteWindow(writeWindow,imageData);

  done:=FALSE;

  WHILE ~done DO
    signal:=el.Wait(s.LONGSET{scaleWindow^.userPort^.sigBit,writeWindow^.userPort^.sigBit});
    intMsg:=el.GetMsg(scaleWindow^.userPort);
    WHILE (intMsg#NIL) DO
      IF id.refreshWindow IN intMsg^.class THEN
         il.BeginRefresh(scaleWindow);
         RedrawScaleWindow(scaleWindow,imageData);
         il.EndRefresh(scaleWindow,TRUE);
      END;
      IF id.newSize IN intMsg^.class THEN
         RedrawScaleWindow(scaleWindow,imageData);
      END;
      IF id.closeWindow IN intMsg^.class THEN
         done:=TRUE;
      END;

      el.ReplyMsg(intMsg);
      intMsg:=el.GetMsg(scaleWindow^.userPort);
    END (*WHILE*);

    intMsg:=el.GetMsg(writeWindow^.userPort);

    WHILE (intMsg#NIL) DO

      IF id.refreshWindow IN intMsg^.class THEN
         il.BeginRefresh(writeWindow);
         RedrawWriteWindow(writeWindow,imageData);
         il.EndRefresh(writeWindow,TRUE);
      END;
      IF id.newSize IN intMsg^.class THEN
         RedrawWriteWindow(writeWindow,imageData);
      END;

      IF id.closeWindow IN intMsg^.class THEN
         done:=TRUE;
      END;
      el.ReplyMsg(intMsg);
      intMsg:=el.GetMsg(writeWindow^.userPort);
    END (*WHILE *);

  END (*WHILE*);

  (* CleanUP *)
CLOSE

  IF imageData   # NIL THEN el.FreeVec(imageData) END;
  IF writeWindow # NIL THEN il.CloseWindow(writeWindow) END;
  IF scaleWindow # NIL THEN il.CloseWindow (scaleWindow) END;
  IF cyberScreen # NIL THEN il.CloseScreen(cyberScreen) END;

END CGXWindow.
