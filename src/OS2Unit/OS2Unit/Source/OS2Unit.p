UNIT OS2;

{** OS2-Unit, (C) 1995 by Björn Schotte
 **
 ** GIFTWARE
 **
 **
 ** Björn Schotte
 ** Am Burkardstuhl 45
 ** D-97267 Himmelstadt
 ** (Rückporto nicht vergessen!)
 **
 **
 ** EMail: bjoern@bomber.mayn.de
 **
 **
 ** Pascal-FTP-Server: ftp@bomber.mayn.de
 ** (Subject/Body: HELPALL)
 **
 **}

INTERFACE

USES Intuition, Exec;

{$incl "gadtools.lib",
	    "graphics/text.h",
		 "asl.lib",
		 "dos.lib"}

CONST
  FREQ_NOTALLOC = -100;
		
TYPE
  p_ASLFileStruct = ^ASLFileStruct;
  ASLFileStruct = RECORD
     left, top,
	  width,
	  height     : INTEGER;
     titel      : STRING[80];
	  pfad,
	  datei,
	  initp,
	  initd,
	  filename   : STRING[256];
	  pattern    : STRING[80];
	  display_pat: BOOLEAN;
	  win        : p_Window;
	  winsleep,
	  canceled   : BOOLEAN;
	  negativ,
	  positiv    : STRING;
  END;

VAR
  topaz80						: TextAttr;
  MyTattr                  : ^TextAttr;
  WBRight, WBBottom,
  ScreenW, ScreenH, FontX,
  FontY, XOff, YOff        : LONG;
  MyPrgName                : STR;
  
FUNCTION OpenGadTools(version:INTEGER) : BOOLEAN;
FUNCTION OpenASL(version:INTEGER) : BOOLEAN;
PROCEDURE CloseGadTools;
PROCEDURE CloseASL;

FUNCTION ComputeX(value:INTEGER) : INTEGER;
FUNCTION ComputeY(value:INTEGER) : INTEGER;
PROCEDURE ComputeFont(VAR f        : p_TextFont;
                      width,height : INTEGER);
PROCEDURE SensitivGadget(VAR ng:NewGadget);
PROCEDURE FS_BevelBox(VAR wo   : p_Window;
                      VAR vi   : PTR;
							 x,y,b,h  : INTEGER;
							 recessed : BOOLEAN);
PROCEDURE GadSelect(VAR wp:p_Window; VAR gad:p_Gadget);
PROCEDURE SetCheckBox(VAR wp:p_Window; VAR gad:p_Gadget; req:p_Requester;
                      flag:BOOLEAN);							 
PROCEDURE SetMXGad(VAR wp:p_Window; VAR gad:p_Gadget; req:p_Requester;
                   active:LONG); 							 
PROCEDURE SetCycleGad(VAR wp:p_Window; VAR gad:p_Gadget; req:p_Requester;
                      active:LONG); 							 
PROCEDURE SetListViewGad(VAR wp:p_Window; VAR gad:p_Gadget; req:p_Requester;
                         active,top:LONG); 							 
PROCEDURE SetListViewList(VAR wp:p_Window; VAR gad:p_Gadget; req:p_Requester;
                          VAR NeueList : p_List); 							 
PROCEDURE SetNumberGad(VAR wp:p_Window; VAR gad:p_Gadget; req:p_Requester;
                          nummer:LONG); 							 
PROCEDURE GhostGadget(VAR wp:p_Window; VAR gad:p_Gadget; req:p_Requester;
                      dis:BOOLEAN); 							 
PROCEDURE ActStringGad(VAR wp:p_Window; VAR gad:p_Gadget; req:p_Requester);
PROCEDURE InitASLStruct(VAR asls : ASLFileStruct);
FUNCTION ASLFileReq(VAR ASLStruct : ASLFileStruct) : LONG;
FUNCTION UserReq(win:p_Window;tit,txt,gad:STR) : LONG;
PROCEDURE DrawBevelLine(MyRp : p_RastPort; VAR vi : PTR; x,y,b:INTEGER; recessed : BOOLEAN);

IMPLEMENTATION


FUNCTION OpenGadTools;
BEGIN
  OpenGadTools := FALSE;
  GadToolsBase := OpenLibrary("gadtools.library", version);
  IF GadToolsBase <> NIL THEN OpenGadTools := TRUE;
END;

FUNCTION OpenASL;
BEGIN
  OpenASL := FALSE;
  ASLBase := OpenLibrary("asl.library", version);
  IF ASLBase <> NIL THEN OpenASL := TRUE;
END;

PROCEDURE CloseGadTools;
BEGIN
  IF GadToolsBase <> NIL THEN CloseLibrary(GadToolsBase);
  GadToolsBase := NIL;
END;

PROCEDURE CloseASL;
BEGIN
  IF ASLBase <> NIL THEN CloseLibrary(ASLBase);
  ASLBase := NIL;
END;

FUNCTION ComputeX;
BEGIN
  ComputeX := ((FontX * value)+4) DIV 8;
END;

FUNCTION ComputeY;
BEGIN
  ComputeY := ((FontY*value)+4) DIV 8;
END;

PROCEDURE ComputeFont;
LABEL UseTopaz;
BEGIN
  Forbid;
  MyTattr := ^topaz80;
  MyTattr^.ta_Name := f^.tf_Message.mn_Node.ln_Name;
  MyTattr^.ta_YSize := f^.tf_YSize;
  FontY := f^.tf_YSize;
  FontX := f^.tf_XSize;
  Permit;
  IF (width>0) AND (height>0) THEN
  BEGIN
    IF ( (ComputeX(width)+xoff+WBRight)>ScreenW) THEN GOTO UseTopaz;
    IF ( (ComputeY(height)+yoff+WBBottom)>ScreenH) THEN GOTO UseTopaz;
  END;
  EXIT;
UseTopaz:
  MyTattr^.ta_Name := "topaz.font";
  FontX := 8;
  FontY := 8;
  MyTattr^.ta_Flags := FPF_ROMFONT;
  MyTattr^.ta_YSize := 8;
END;

{ Modifiziert die Koordinaten eines Gadgets so, daß }
{  sie sich fontsensitiv anpassen.                  }
PROCEDURE SensitivGadget;
BEGIN
  ng.ng_LeftEdge := ComputeX(ng.ng_LeftEdge)+xoff;
  ng.ng_TopEdge  := ComputeY(ng.ng_TopEdge)+yoff;
  ng.ng_Width    := ComputeX(ng.ng_Width);
  ng.ng_Height   := ComputeY(ng.ng_Height);
END;

PROCEDURE FS_BevelBox;
VAR
  t : ARRAY[1..3] OF TagItem;
BEGIN
  t[1] := TagItem(GT_VisualInfo,LONG(vi));
  t[2] := TagItem(GTBB_Recessed, LONG(recessed));
  t[3].ti_Tag := TAG_DONE;

  DrawBevelBoxA(wo^.RPort,
                xoff+ComputeX(x),
                yoff+ComputeY(y),
					 ComputeX(b),
					 ComputeY(h),
					 ^t);
END;

PROCEDURE GadSelect;
VAR
  next        : p_Gadget;
  old         : LONG;
  dummy       : BOOLEAN;
  class, code : LONG;
  msg         : p_IntuiMessage;
BEGIN
  old := wp^.IDCMPFlags;
  dummy:=ModifyIDCMP(wp,IDCMP_RAWKEY);
  next := gad^.NextGadget;
  gad^.NextGadget := NIL;
  gad^.Flags := gad^.Flags + SELECTED;
  RefreshGadgets(gad,wp,NIL);
  REPEAT
    msg := p_IntuiMessage(WaitPort(wp^.UserPort));
	 msg := GT_GetIMsg(wp^.UserPort);
	 class := msg^.Class;
	 code  := msg^.Code;
	 GT_ReplyIMsg(msg);
  UNTIL (class = IDCMP_RAWKEY) AND ( (code AND IECODE_UP_PREFIX)=IECODE_UP_PREFIX);
  dummy:=ModifyIDCMP(wp,old);
  gad^.Flags := gad^.Flags - SELECTED;
  RefreshGadgets(gad,wp,NIL);
  gad^.NextGadget := next;
END;

PROCEDURE SetCheckBox;
VAR
  t : ARRAY[1..2] OF TagItem;
BEGIN
  t[1] := TagItem(GTCB_Checked, ORD(flag));
  t[2].ti_Tag := TAG_DONE;
  GT_SetGadgetAttrsA(gad, wp, req, ^t);
END;

PROCEDURE SetMXGad;
VAR
  t : ARRAY[1..2] OF TagItem;
BEGIN
  t[1] := TagItem(GTMX_Active, active);
  t[2].ti_Tag := TAG_DONE;
  GT_SetGadgetAttrsA(gad,wp,req,^t);
END;

PROCEDURE SetCycleGad;
VAR
  t : ARRAY[1..2] OF TagItem;
BEGIN
  t[1] := TagItem(GTCY_Active, active);
  t[2].ti_Tag := TAG_DONE;
  GT_SetGadgetAttrsA(gad,wp,req,^t);
END;

PROCEDURE SetListViewGad;
VAR
  t : ARRAY[1..3] OF TagItem;
BEGIN
  t[1] := TagItem(GTLV_Selected, active);
  t[2] := TagItem(GTLV_Top, top);
  t[3].ti_Tag := TAG_DONE;
  GT_SetGadgetAttrsA(gad,wp,req,^t);
END;

PROCEDURE SetListViewList;
VAR
  t : ARRAY[1..2] OF TagItem;
BEGIN
  t[1] := TagItem(GTLV_Labels, LONG(NeueList));
  t[2].ti_Tag := TAG_DONE;
  GT_SetGadgetAttrsA(gad,wp,req,^t);
END;

PROCEDURE SetNumberGad;
VAR
  t : ARRAY[1..2] OF TagItem;
BEGIN
  t[1] := TagItem(GTNM_Number, nummer);
  t[2].ti_Tag := TAG_DONE;
  GT_SetGadgetAttrsA(gad,wp,req,^t);
END;

PROCEDURE GhostGadget;
VAR
  t : ARRAY[1..2] OF TagItem;
BEGIN
  t[1] := TagItem(GA_Disabled, ORD(dis));
  t[2].ti_Tag := TAG_DONE;
  GT_SetGadgetAttrsA(gad,wp,req,^t);
END;

PROCEDURE ActStringGad;
VAR
  dummy : BOOLEAN;
BEGIN
  dummy := ActivateGadget(gad,wp,req);
END;

PROCEDURE InitASLStruct;
BEGIN
  asls := ASLFileStruct(-1,-1,-1,-1,"","","","","","","",TRUE,NIL,FALSE,FALSE,
                        "","");
END;

FUNCTION ASLFileReq;
VAR
  t : ARRAY[0..12] OF TagItem;
  fre : p_FileRequester;
  bool : BOOLEAN;
BEGIN
  ASLFileReq := 0;
  t[0].ti_Tag := ASLFR_InitialDrawer;
  IF ASLStruct.initp <> "" THEN t[0].ti_Data := LONG(^ASLStruct.initp)
                           ELSE t[0].ti_Tag := TAG_IGNORE;
  t[1].ti_Tag := ASLFR_InitialFile;
  IF ASLStruct.initd <> "" THEN t[1].ti_Data := LONG(^ASLStruct.initd)
                           ELSE t[1].ti_Tag := TAG_IGNORE;
  t[2] := TagItem(ASLFR_Window, LONG(ASLStruct.win));
  IF ASLStruct.win <> NIL THEN t[2] := TagItem(ASLFR_SleepWindow, ORD(ASLStruct.winsleep))
                          ELSE t[2].ti_Tag := TAG_IGNORE;
  t[3] := TagItem(ASLFR_TitleText, LONG(^ASLStruct.titel));
  IF ASLStruct.pattern <> "" THEN
  BEGIN
    t[4] := TagItem(ASLFR_InitialPattern, LONG(^ASLStruct.pattern))
  END ELSE
  BEGIN
    t[4].ti_Tag := TAG_IGNORE;					
  END;
  IF ASLStruct.display_pat THEN
	 t[5] := TagItem(ASLFR_DoPatterns, ORD(TRUE))
  ELSE
	 t[5].ti_Tag := TAG_IGNORE;		  
	 
  IF ASLStruct.left > -1 THEN t[6] := TagItem(ASLFR_InitialLeftEdge, ASLStruct.left)
                         ELSE t[6].ti_Tag := TAG_IGNORE;
  IF ASLStruct.top > -1 THEN t[7] := TagItem(ASLFR_InitialTopEdge, ASLStruct.top)
                         ELSE t[7].ti_Tag := TAG_IGNORE;
  IF ASLStruct.width > -1 THEN t[8] := TagItem(ASLFR_InitialWidth, ASLStruct.width)
                         ELSE t[8].ti_Tag := TAG_IGNORE;
  IF ASLStruct.height > -1 THEN t[9] := TagItem(ASLFR_InitialHeight, ASLStruct.height)
                         ELSE t[9].ti_Tag := TAG_IGNORE;
								 
  IF ASLStruct.negativ <> "" THEN
    t[10] := TagItem(ASLFR_NegativeText, LONG(^ASLStruct.negativ))
  ELSE
    t[10].ti_Tag := TAG_IGNORE;

  IF ASLStruct.positiv <> "" THEN
    t[11] := TagItem(ASLFR_PositiveText, LONG(^ASLStruct.positiv))
  ELSE
    t[11].ti_Tag := TAG_IGNORE;
	 
  t[12].ti_Tag := TAG_DONE;
  
  fre := AllocASLRequest(ASL_FileRequest, ^t);
  IF fre <> NIL THEN
  BEGIN
	 IF ASLRequest(fre, ^t) THEN
	 BEGIN
	   ASLStruct.pfad := fre^.rf_Dir;
		ASLStruct.datei := fre^.rf_File;
		ASLStruct.canceled := FALSE;
		ASLStruct.filename := ASLStruct.pfad;
		bool := AddPart(ASLStruct.filename,ASLStruct.datei,256);
		ASLStruct.pattern := fre^.rf_Pat;
		ASLStruct.initp := ASLStruct.pfad;
		ASLStruct.initd := ASLStruct.datei;
	 END ELSE
	 BEGIN
		IF IOErr = 0 THEN ASLStruct.canceled := TRUE
		ELSE
		BEGIN
		  ASLStruct.canceled := FALSE;
		  ASLFileReq := IOErr;
		END;
    END;
	 FreeASLRequest(fre);
  END ELSE ASLFileReq := FREQ_NOTALLOC;
END;

PROCEDURE GetPrgName;
TYPE
  BCPLStrPtr = ^BCPLStr;
  BCPLStr = ARRAY[0..MaxByte] OF CHAR;
VAR
  MyTask : p_Task;
  MyProc : p_Process;
  ThisCli : p_CommandLineInterface;
  ThisName : BCPLStrPtr;
  tn : BCPLStr;
  name : STRING[256];
  s : STR;
BEGIN
  MyTask := FindTask(NIL);
  MyProc := p_Process(MyTask);
  ThisCli := PTR(4*MyProc^.pr_Cli);
  ThisName := BCPLStrPtr(4*ThisCli^.cli_CommandName);
  tn := ThisName^;
  s := STR(^TN[1]);
  name := s;
  name[ord(TN[0])+1]:=CHR(0);
  MyPrgName := name;  	
END;

FUNCTION UserReq;
VAR
  es : EasyStruct;
BEGIN
  es := EasyStruct(SizeOf(EasyStruct),0,tit,txt,gad);
  UserReq := EasyRequestArgs(win,^es,NIL,NIL);
END;

PROCEDURE DrawBevelLine;
VAR t : ARRAY[1..3] OF TagItem;
BEGIN
  t[1] := TagItem(GT_VisualInfo,LONG(vi));
  t[2] := TagItem(GTBB_Recessed,LONG(recessed));
  t[3].ti_Tag := TAG_DONE;
  DrawBevelBoxA(MyRp,xoff+ComputeX(x),yoff+ComputeY(y),ComputeX(b),2{Höhe},^t);
END;

BEGIN
  topaz80 := TextAttr("topaz.font", 8, 0, 0);
  GetPrgName;
END.
