PROGRAM Example;

{ Example.p
	
  Shows a fontsensitive GUI
  
  written 1996 by Björn Schotte, PUBLIC DOMAIN }
  
USES OS2;

CONST
  NOMEM = "Not enough memory free!";
  
VAR
  psfont		: p_TextFont;
  vi			: PTR;
  ng			: NewGadget;
  drinf		: p_DrawInfo;
  ps			: p_Screen;
  gl,
  g1,g2,g3	: p_Gadget;
  dummy     : BOOLEAN;
  msg			: p_IntuiMessage;
  class,
  code,i,
  ww,wh		: LONG;
  KlickG		: p_Gadget;
  GadNum		: CARDINAL;
  wp			: p_Window;
  t			: ARRAY[1..12] OF TagItem;
  file_buf,
  datei,pfad  : STRING[256];

PROCEDURE CloseLibs;
BEGIN
  CloseASL;
  CloseGadTools;
END;

PROCEDURE CleanUp(why : STRING; rc : INTEGER);
BEGIN
  IF wp <> NIL THEN CloseWindow(wp);
  IF gl <> NIL THEN FreeGadgets(gl);
  IF vi <> NIL THEN FreeVisualInfo(vi);
  IF why <> "" THEN i := UserReq(NIL,"OS2Unit-Example",why,"OK");
  CloseLibs;
  HALT(rc);
END;  

PROCEDURE CloneDatas;
BEGIN
  ps := LockPubScreen(NIL);
  IF ps <> NIL THEN
  BEGIN
	 ScreenW := ps^.Width;
	 ScreenH := ps^.height;
	 WBRight := ps^.wBorRight;
	 WBBottom := ps^.WBorBottom;
	 drinf := GetScreenDrawInfo(ps);
	 IF drinf <> NIL THEN
	 BEGIN
		psfont := drinf^.dri_Font;
		XOff := ps^.WBorLeft;
		YOff := ps^.WBorTop + psfont^.tf_YSize + 1;
		FreeScreenDrawInfo(ps,drinf);
	 END ELSE
	 BEGIN
	   UnLockPubScreen(NIL,ps);
		CleanUp("Couldn't get ScreenDrawInfo!",20);
	 END;
	 vi := GetVisualInfoA(ps,NIL);
	 IF vi = NIL THEN
	 BEGIN
		UnLockPubScreen(NIL,ps);
		CleanUp("Couldn't get visualinfo!",20);
    END ELSE UnLockPubScreen(NIL,ps);
	 ComputeFont(psfont,0,0);
  END ELSE CleanUp("Couldn't lock default public screen!",20);
END;

PROCEDURE OpenMyWin;
BEGIN
  { Calculating dimensions }
  ComputeFont(psfont,400,60); { Windowidth: 200; Windowheight: 60 }
	  
  { Creating gadget context }
  gl := NIL; gl := CreateContext(^gl);
  IF gl = NIL THEN CleanUp(NOMEM,20);	
  
  t[1] := TagItem(GT_Underscore, LONG("_"));
  t[2].ti_Tag := TAG_DONE;
  ng := NewGadget(2,2,100,13,
                  "_File...",mytattr,
						1,PLACETEXT_IN,
						vi,NIL);
  { Make gadget sensitive }
  sensitivgadget(ng);		
  { Create it }
  g1 := CreateGadgetA(BUTTON_KIND,gl,^ng,^t);
  IF g1 = NIL THEN CleanUp(NOMEM,20);				

  { The same as above }
  t[1] := TagItem(GTTX_Text, LONG(^file_buf));
  t[2] := TagItem(GTTX_Border, LONG(TRUE));
  t[3].ti_Tag := TAG_DONE;
  ng := NewGadget(103,2,280,13,
                  NIL,mytattr,
						2,0,
						vi,NIL);
  sensitivgadget(ng);
  g2 := CreateGadgetA(TEXT_KIND,g1,^ng,^t);
  IF g2 = NIL THEN cleanUp(NOMEM,20);
  
  { Calculate our window width and height }
  ww := ComputeX(400); wh := ComputeY(60);
  
  t[1] := TagItem(WA_InnerWidth, ww);
  t[2] := TagItem(WA_InnerHeight, wh);
  t[3] := TagItem(WA_Gadgets, LONG(gl));
  t[4] := TagItem(WA_IDCMP, IDCMP_GADGETUP OR IDCMP_CLOSEWINDOW OR IDCMP_RAWKEY);
  t[5] := TagItem(WA_Flags, WFLG_CLOSEGADGET OR WFLG_ACTIVATE OR
                  WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_NOCAREREFRESH OR
						WFLG_SMART_REFRESH);
  t[6].ti_Tag := WA_title;
  t[6].ti_Data := "OS2Unit - Example";
  t[7].ti_Tag := TAG_DONE;
  { Opening window }
  wp := OpenWindowTagList(NIL, ^T);
  IF wp = NIL THEN CleanUp("Couldn't open window!",20);																		
  { Draw a bevel line }
  DrawBevelLine(wp^.RPort,vi,2,20,380,TRUE);
END;

PROCEDURE Choosefile;
VAR as : ASLFileStruct;
BEGIN
  { Init Struct }
  InitASLStruct(as);
  { Initialize some variables }
  as.initp := pfad; as.initd := datei;
  as.pattern := "~(#?.info)"; as.display_pat := TRUE;
  as.win := wp; as.winsleep := TRUE; as.titel := "Please choose a file!";
  i := ASLFileReq(as);
  IF i = 0 THEN
  BEGIN
	 { User has NOT canceled! }
	 IF as.canceled = FALSE THEN
	 BEGIN
		{ Extracting variables }
		pfad := as.pfad;
		datei := as.datei;
		{ Extract our complete filename }
		file_buf := as.filename;
		{ Display it in Text-Gadget }
		t[1] := TagItem(GTTX_Text, LONG(^file_buf));
		t[2].ti_Tag := TAG_DONE;
		GT_SetGadgetAttrsA(g2,wp,NIL,^t);
	 END ELSE i := UserReq(wp,"OS2Unit-Example","You have canceled","OK");
  END ELSE i := UserReq(wp,"OS2Unit-Example","Allocation failed!","OK");
END;

PROCEDURE Main;
BEGIN
  dummy := FALSE;
  REPEAT
    msg := p_IntuiMessage(WaitPort(wp^.UserPort));
	 msg := GT_GetIMsg(wp^.UserPort);
	 WHILE msg <> NIL DO
	 BEGIN
		class := msg^.Class;
		code := msg^.Code;
		IF class IN [IDCMP_GADGETUP] THEN
		BEGIN
		  KlickG := msg^.IAddress; GadNum := KlickG^.GadgetID;
	   END;
		GT_ReplyIMSg(msg);
		CASE class OF
		  IDCMP_CLOSEWINDOW : dummy := TRUE;
		  IDCMP_GADGETUP:
		    CASE GadNum OF
			   1 : ChooseFile;
			 ELSE END;
		  IDCMP_RAWKEY :
		    CASE code OF
			   35 { F } :
			    { User has pressed "F" }
				 BEGIN
				   GadSelect(wp,g1);
					Choosefile;
			    END;
			 ELSE END;
		ELSE END;
	   msg := GT_GetIMsg(wp^.UserPort);
	 END;
  UNTIL dummy;
END;

BEGIN
  vi := NIL; ps := NIL; gl := NIL; wp := NIL; file_buf := "";
  datei := ""; pfad := "SYS:";
  dummy := OpenGadTools(37);
  IF dummy = FALSE THEN CleanUp("Couldn't open gadtools.library V37+!",20);
  dummy := OpenASL(37);
  IF dummy = FALSE THEN CleanUp("Couldn't open asl.library V37+!",20);
  CloneDatas;
  OpenMyWin;
  Main;
  CleanUp("",0);
END.
