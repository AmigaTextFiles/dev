(* REVISION HEADER ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× *
   
 | $VER: Pages 3.00 (23.11.94) by Stefan Schulz [sts]
 
 | Desc: Advanced Example for using EAGUI via M2
 
 | Dist: This Module is © Copyright 1994 by Stefan Schulz
 
 | Rqrs: Amiga OS 2.0 or higher
 |       EAGUI.library V3
 |       EAGUI - Environment Adaptive Graphic User Interface
 |       Copyright © 1993, 1994 by Marcel Offermans and Frank Groen
 
 | Lang: M2Amiga
 | Trns: M2Amiga Modula 2 Software Development System
 |       © Copyright by A+L AG, CH-2540 Grenchen
 
 | Hist: Version \date\
 |
 |       3.00   \23.11.94\
 |              initial Version
 
 * ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× *)

MODULE Pages;

(*$ DEFINE	Small:= FALSE

    IF	Small
	StackChk   := FALSE
	RangeChk   := FALSE
	OverflowChk:= FALSE
	NilChk     := FALSE
	EntryClear := FALSE
	CaseChk    := FALSE
	ReturnChk  := FALSE
	LargeVars  := FALSE
    ENDIF			*)

(* IMPORTS ********************************************************************** *)

IMPORT	tf	: TextField;

IMPORT	d	: EAGuiD,
	l	: EAGuiL,
	m	: EAGuiMacros;

IMPORT	A	: Arts,
	ar	: Arguments,
	cv	: Conversions,
	dfl	: DiskFontL,
	dl	: DosL,
	ed	: ExecD,
	el	: ExecL,
	gtd	: GadToolsD,
	gtl	: GadToolsL,
	gd	: GraphicsD,
	gl	: GraphicsL,
	hp	: Heap,
	id	: IntuitionD,
	il	: IntuitionL,
	R,
	S	: SYSTEM,
	ud	: UtilityD;

(* ****************************************************************************** *)

(* GLOBALS ====================================================================== *)

CONST	WindowTitle	= "EAGUI pages Example";
	ErrNoDrawInfo	= "Couldn't get the draw info.\n";
	ErrNoFont	= "Couldn't open font.\n";
	ErrNoGadList	= "Couldn't create the gadget list.\n";
	ErrNoObjects	= "Couldn't init the objects.\n";
	ErrNoScreenLock	= "Couldn't lock default public screen.\n";
	ErrNoVisualInfo	= "Couldn't get the visual info.\n";
	ErrNoWindow	= "Couldn't open the window.\n";

CONST	DefaultFont	= "helvetica.font";

CONST	LayoutSpacing	= 4;
	CycleGadgetID	= 666;

VAR	WinObj,
	PGroupObj,
	Page1,
	Page2,
	Page3		: d.OPTR;
	
	Win		: id.WindowPtr;
	Scr		: id.ScreenPtr;
	GadList		: id.GadgetPtr;
	CycleGadget	: id.GadgetPtr;
	
	VisualInfo	: S.ADDRESS;
	DrawInfo	: id.DrawInfoPtr;
	TextFont	: gd.TextFontPtr;
	
	TextAttr	:= gd.TextAttr {name  : S.ADR(DefaultFont),
					ySize : 15,
					style : gd.normalFont,
					flags : gd.FontFlagSet{gd.diskFont}
				       };
	PgMinSizeHook,
	TFMinSizeHook,
	TFRenderHook	: ud.Hook;
	IMsg		: id.IntuiMessage;
	TextField	: tf.ciTextField;

TYPE	LabelArray	= ARRAY [0..3] OF d.StrPtr;
	CyTagList	= ARRAY [0..2] OF ud.TagItem;

VAR	Labels		:= LabelArray
	{ S.ADR("Page One"),
	  S.ADR("Page Two"),
	  S.ADR("Page Three"),
	  NIL
	};

	cyTagList	: CyTagList;

(* ============================================================================== *)

(* page group minsize method ---------------------------------------------------- *)
PROCEDURE MethMinSizePGroup(	hook{R.A0}  : ud.HookPtr;
				obj{R.A2}   : S.ADDRESS;
				msg{R.A1}   : S.ADDRESS		) : S.ADDRESS;

 TYPE	MsgTagListPtr	= POINTER TO MsgTagList;
	MsgTagList	= ARRAY [1..16] OF LONGINT;

 VAR	current		: d.OPTR;
	minwidth,
	minheight,
	width, height,
	mwidth, mheight,
	bleft, bright,
	btop, bbottom	: LONGCARD;
	msgTagListBuf	: MsgTagList;
	msgTagList	: MsgTagListPtr;

 (*$ SaveA4:= TRUE *)

 BEGIN
 
 S.SETREG( R.A4, hook^.data );
 
 (* starting values *)
 minwidth  := 0;
 minheight := 0;
 current   := l.GetAttr(obj, d.firstChild);
 
 msgTagList:= S.TAG(msgTagListBuf,
		    d.minWidth,		0,
		    d.minHeight,	0,
		    d.borderLeft,	0,
		    d.borderRight,	0,
		    d.borderTop,	0,
		    d.borderBottom,	0,
		    d.nextObject,	0,
	      ud.tagDone);
 
 msgTagListBuf[2] := S.ADR(mwidth);
 msgTagListBuf[4] := S.ADR(mheight);
 msgTagListBuf[6] := S.ADR(bleft);
 msgTagListBuf[8] := S.ADR(bright);
 msgTagListBuf[10]:= S.ADR(btop);
 msgTagListBuf[12]:= S.ADR(bbottom);
 msgTagListBuf[14]:= S.ADR(current);

 (* do all children *)
 WHILE (current # NIL)
  DO	(* get the required attributes *)
	IGNORE l.GetAttrsA(current, S.ADDRESS(msgTagList));
	
	(* determine the minimum dimensions of this child *)
	width := mwidth + bleft + bright;
	height:= mheight + btop + bbottom;
	
	(* check and use these dimensions if they were larger than the largest    *)
	(* up to now								  *)
	IF (height > minheight) THEN minheight:= height  END;
	IF (width > minwidth)   THEN minwidth := width   END;
	
  END; (* while *)

 (* set the minimum dimensions of the object *)
 IGNORE l.SetAttr(obj, d.minWidth,  minwidth);
 IGNORE l.SetAttr(obj, d.minHeight, minheight);

 (* return zero for success *)
 RETURN NIL;

 END MethMinSizePGroup;



(* Recreate the gadget-list ----------------------------------------------------- *)

PROCEDURE ResizeWindow;

 VAR	bLeft, bRight,
	bTop, bBottom	: LONGINT;
	int		: INTEGER;
	buffer		: ARRAY [1..10] OF LONGINT;

 BEGIN
 
 (* if necessary, remove the gadget list from the window, and clean it up	  *)
 IF	(GadList # NIL)
  THEN	int:= il.RemoveGList(Win, GadList, -1);
	l.FreeGadgetList(WinObj, GadList);
	GadList:= NIL;
  END; (* if *)
 
 IGNORE l.GetAttrsA
	( WinObj,
	  S.TAG(buffer,
		d.borderLeft,   S.ADR(bLeft),
		d.borderRight,  S.ADR(bRight),
		d.borderTop,    S.ADR(bTop),
		d.borderBottom, S.ADR(bBottom),
	  ud.tagDone)
	); (* l.GetAttrsA *)
 
 IGNORE l.SetAttrsA
	( WinObj,
	  S.TAG(buffer,
		d.width, Win^.width - Win^.borderLeft - Win^.borderRight
			 - bLeft - bRight,
		d.height, Win^.height - Win^.borderTop - Win^.borderBottom
			 - bTop - bBottom,
		d.left,  Win^.borderLeft,
		d.top,   Win^.borderTop,
	  ud.tagDone)
	); (* l.SetAttrsA *)
 
 l.LayoutObjects(WinObj);
 
 A.Assert(l.CreateGadgetList(WinObj, S.ADR(GadList), VisualInfo, DrawInfo)
	  = d.errorOK,
	  S.ADR(ErrNoGadList)
	 );
 
 gl.EraseRect(Win^.rPort, Win^.borderLeft, Win^.borderTop,
	      Win^.width - Win^.borderRight - 1,
	      Win^.height - Win^.borderBottom - 1
	     );
 
 il.RefreshWindowFrame(Win);
 
 int:= il.AddGList(Win, GadList, -1, -1, NIL);
 il.RefreshGList(GadList, Win, NIL, -1);
 gtl.GTRefreshWindow(Win, NIL);
 
 (* finally, we render the imagery, if there is any			  *)
 l.RenderObjects(WinObj, Win^.rPort);
 
 END ResizeWindow;



(* (re)create the gadget list after a page change ------------------------------- *)
PROCEDURE RePageWindow;

 VAR	bLeft, bRight,
	bTop, bBottom,
	gwidth, gheight,
	gtop, gleft	: LONGINT;
	buffer		: ARRAY [1..10] OF LONGINT;

 BEGIN
 
 (* if necessary, remove the gadget list from the window, and clean it up *)
 (* if necessary, remove the gadget list from the window, and clean it up	  *)
 IF	(GadList # NIL)
  THEN	IGNORE il.RemoveGList(Win, GadList, -1);
	l.FreeGadgetList(WinObj, GadList);
	GadList:= NIL;
  END; (* if *)
 
 IGNORE l.GetAttrsA
	( WinObj,
	  S.TAG(buffer,
		d.borderLeft,   S.ADR(bLeft),
		d.borderRight,  S.ADR(bRight),
		d.borderTop,    S.ADR(bTop),
		d.borderBottom, S.ADR(bBottom),
	  ud.tagDone)
	); (* l.GetAttrsA *)
 
 IGNORE l.SetAttrsA
	( WinObj,
	  S.TAG(buffer,
		d.width, Win^.width - Win^.borderLeft - Win^.borderRight
			 - bLeft - bRight,
		d.height, Win^.height - Win^.borderTop - Win^.borderBottom
			 - bTop - bBottom,
		d.left,  Win^.borderLeft,
		d.top,   Win^.borderTop,
	  ud.tagDone)
	); (* l.SetAttrsA *)
 
 l.LayoutObjects(WinObj);
 
 A.Assert(l.CreateGadgetList(WinObj, S.ADR(GadList), VisualInfo, DrawInfo)
	  = d.errorOK,
	  S.ADR(ErrNoGadList)
	 );
 
 (* now determine the exact position of the page in the window *)
 gleft  := l.GetObjectLeft(WinObj, PGroupObj);
 gtop   := l.GetObjectTop(WinObj, PGroupObj);
 gwidth := l.GetAttr(PGroupObj, d.width);
 gheight:= l.GetAttr(PGroupObj, d.height);

 (* clear only the page instead of the complete window *)
 gl.EraseRect(Win^.rPort, gleft, gtop, gleft+gwidth-1, gtop+gheight-1);
 
 IGNORE il.AddGList(Win, GadList, -1, -1, NIL);
 il.RefreshGList(GadList, Win, NIL, -1);
 gtl.GTRefreshWindow(Win, NIL);

 (* finally, we render the imagery, if there is any *)
 l.RenderObjects(WinObj, Win^.rPort);
 
 END RePageWindow;



(* Init all --------------------------------------------------------------------- *)

PROCEDURE Init;

 VAR	width, height,
	bLeft, bRight,
	bTop, bBottom	: LONGINT;
	buffer1,
	buffer2		: ARRAY [1..50] OF LONGINT;
	buffer3		: ARRAY [1..8] OF LONGINT;
	bool		: BOOLEAN;

 BEGIN

 (* Initialize CycleTagList *) 
 IGNORE  S.TAG( cyTagList,
		gtd.gtcyLabels, S.ADR(Labels),
		gtd.gtcyActive, 0,
	 ud.tagDone);

 (* open the font *)
 TextFont:= dfl.OpenDiskFont(S.ADR(TextAttr));
 A.Assert(TextFont # NIL, S.ADR(ErrNoFont));
 
 (* initialize the pagegroup minsize hook *)
 PgMinSizeHook.entry:= MethMinSizePGroup;
 PgMinSizeHook.data := S.REG(R.A4);

 (* initialize textfield hooks *)
 TFMinSizeHook.entry:= tf.MethMinSizeTextField;
 TFMinSizeHook.data := S.REG(R.A4);
 
 TFRenderHook.entry:= tf.MethRenderTextField;
 TFRenderHook.data := S.REG(R.A4);
 
 (* set up some defaults for all objects *)
 IGNORE l.SetAttr(NIL, d.defGTTextAttr, S.ADR(TextAttr));
 
 (* now we can build the object tree *)

 Page1:= m.GTListView( "", S.TAG(buffer1, d.weight, 1, ud.tagEnd) );

 Page2:= m.VGroup
	( S.TAG(buffer1,
		d.weight,	1,
		d.child,	m.EmptyBox(2, NIL),
		d.child,	m.GTString("Username:",NIL),
		d.child,	m.EmptyBox(1, NIL),
		d.child,	m.GTString("Password:", NIL),
		d.child,	m.EmptyBox(2, NIL),
	  ud.tagEnd)
	); (* VGroup *)

 Page3:= l.NewObjectA
	( d.typeCustomImage,
	  S.TAG(buffer1,
		d.weight,	1,
		d.borderBottom,	4,
		d.minSizeMethod,S.ADR(TFMinSizeHook),
		d.renderMethod,	S.ADR(TFRenderHook),
		d.userData,	S.ADR(TextField),
	  ud.tagEnd)
	); (* NewObjectA *)

 PGroupObj:= l.NewObjectA
		( d.typeHGroup,
		  S.TAG(buffer1,
			d.standardMethod,	d.smBorder,
			d.weight,		1,
			d.minSizeMethod,	S.ADR(PgMinSizeHook),
			d.child, Page1,
			d.child, Page2,
			d.child, Page3,
		  ud.tagEnd)
		); (* NewObjectA *)

 WinObj:= m.HGroup
		( S.TAG(buffer1,
			d.borderLeft,   LayoutSpacing,
			d.borderRight,  LayoutSpacing,
			d.borderTop,    LayoutSpacing,
			d.borderBottom, LayoutSpacing,
			d.child, m.VGroup
			 (S.TAG(buffer2,
				d.weight,	1,
				d.borderRight,	LayoutSpacing,
				d.child,	m.EmptyBox(1, NIL),
				d.child,	m.GTButton("Help...", NIL),
				d.child,	m.EmptyBox(1, NIL),
				d.child,	m.GTButton("Ok", NIL),
				d.child,	m.GTButton("Cancel", NIL),
			  ud.tagEnd)),
			d.child, m.VGroup
			 (S.TAG(buffer2,
				d.weight,	2,
				d.child, m.GTCycle
				 (S.TAG(buffer3,
					d.gtTagList,	   S.ADR(cyTagList),
					d.instanceAddress, S.ADR(CycleGadget),
					d.id,		   CycleGadgetID,
				  ud.tagEnd)),
				d.child, PGroupObj,
			  ud.tagEnd)),
		  ud.tagEnd)
		); (* HGroup *)

 A.Assert(WinObj # NIL, S.ADR(ErrNoObjects));
 
 (* lock the screen *)
 Scr:= il.LockPubScreen(NIL);
 A.Assert(Scr # NIL, S.ADR(ErrNoScreenLock));
 
 (* get VisualInfo and DrawInfo *)
 VisualInfo:= gtl.GetVisualInfoA(Scr, NIL);
 A.Assert(VisualInfo # NIL, S.ADR(ErrNoVisualInfo));
 DrawInfo:= il.GetScreenDrawInfo(Scr);
 A.Assert(DrawInfo # NIL, S.ADR(ErrNoDrawInfo));
 
 (* fill in the textfield structure *)
 TextField.string  := S.ADR("Connection Established");	(* title *)
 TextField.textAttr:= S.ADR(TextAttr);			(* font  *)
 TextField.flags   := tf.CITFFlagSet{};			(* alignment flags *)
 TextField.frontPen:= 2;				(* frontpen color index *)
 
 (* obtain the minimum dimensions of every object in the tree *)
 l.GetMinSizes(WinObj);
 
 (* get some attributes *)
 IGNORE l.GetAttrsA
	( WinObj,
	  S.TAG(buffer1,
		d.minWidth,	S.ADR(width),
		d.minHeight,	S.ADR(height),
		d.borderLeft,	S.ADR(bLeft),
		d.borderRight,	S.ADR(bRight),
		d.borderTop,	S.ADR(bTop),
		d.borderBottom,	S.ADR(bBottom),
	  ud.tagEnd)
	);

 IGNORE l.SetAttr(Page1, d.disabled, 0);
 IGNORE l.SetAttr(Page2, d.disabled, 1);
 IGNORE l.SetAttr(Page3, d.disabled, 1);
 
 (* open the window *)
 Win:= il.OpenWindowTagList
		( NIL,
		  S.TAG(buffer1,
			id.waTitle,       S.ADR(WindowTitle),
			id.waFlags,       id.WindowFlagSet{id.windowDrag,
							   id.windowDepth,
							   id.windowClose,
							   id.windowSizing,
							   id.sizeBBottom,
							   id.windowActive},
			id.waIDCMP,       id.IDCMPFlagSet{ id.closeWindow,
							   id.gadgetUp,
							   id.refreshWindow,
							   id.newSize},
			id.waInnerHeight, height + bTop + bBottom,
		  ud.tagEnd)
		);
 
 (* set the window limits *)
 bool:= il.WindowLimits
		( Win,
		  width + Win^.borderLeft + Win^.borderRight + bLeft + bRight,
		  height + Win^.borderTop + Win^.borderBottom + bTop + bBottom,
		  0, 0
		);
 
 (* create the gadgets and add them to the window *)
 ResizeWindow;

 END Init;



(* Clean up --------------------------------------------------------------------- *)
PROCEDURE CleanUp;

 VAR	int	: INTEGER;

 BEGIN
 
 IF	(GadList # NIL)
  THEN	int:= il.RemoveGList(Win, GadList, -1);
	l.FreeGadgetList(WinObj, GadList);
	GadList:= NIL;
  END; (* if *)
 
 IF	(Win # NIL)
  THEN	il.CloseWindow(Win);
	Win:= NIL;
  END;
 
 IF	(DrawInfo # NIL)
  THEN	il.FreeScreenDrawInfo(Scr, DrawInfo);
	DrawInfo:= NIL;
  END;
 
 IF	(VisualInfo # NIL)
  THEN	gtl.FreeVisualInfo(VisualInfo);
	VisualInfo:= NIL;
  END;
 
 IF	(Scr # NIL)
  THEN	il.UnlockPubScreen(NIL, Scr);
	Scr:= NIL;
  END;
 
 IF	(WinObj # NIL)
  THEN	l.DisposeObject(WinObj);
	WinObj:= NIL;
  END;
 
 IF	(TextFont # NIL)
  THEN	gl.CloseFont(TextFont);
	TextFont:= NIL;
  END;
 
 END CleanUp;



(* Message Handling ------------------------------------------------------------- *)

PROCEDURE HandleMsgs () : LONGCARD;

 VAR	iMsg		: id.IntuiMessagePtr;
	rc		: LONGCARD;
	buffer		: ARRAY [1..4] OF LONGINT;
	adr		: S.ADDRESS;
	test		: ARRAY [1..10] OF LONGCARD;

 BEGIN
 
 rc:= 0;
 
 REPEAT	iMsg:= gtl.GTGetIMsg(Win^.userPort);
	IF	(iMsg # NIL)
	 THEN	el.CopyMem(iMsg, S.ADR(IMsg), SIZE(IMsg));
		gtl.GTReplyIMsg(iMsg);
		
		IF	(id.refreshWindow IN IMsg.class)
		 THEN	gtl.GTBeginRefresh(Win);
			gtl.GTEndRefresh(Win, TRUE);
		 ELSIF	(id.closeWindow IN IMsg.class)
		  THEN	rc:= 10;
		 ELSIF	(id.newSize IN IMsg.class)
		  THEN	ResizeWindow;
		 ELSIF	(id.gadgetUp IN IMsg.class)
		  THEN	(* check if the user clicked on the cycle gadget *)
			IF (id.GadgetPtr(IMsg.iAddress)^.gadgetID = CycleGadgetID)
			 THEN	(* the user clicked on the cycle gadget and       *)
				(* selected a different page                      *)
				cyTagList[1].data:= IMsg.code;
				
				(* enable and disable the right pages *)
				IF	(IMsg.code = 0)
				 THEN	IGNORE l.SetAttr(Page1, d.disabled, 0);
					IGNORE l.SetAttr(Page2, d.disabled, 1);
					IGNORE l.SetAttr(Page3, d.disabled, 1);
				 ELSIF	(IMsg.code = 1)
				  THEN	IGNORE l.SetAttr(Page1, d.disabled, 1);
					IGNORE l.SetAttr(Page2, d.disabled, 0);
					IGNORE l.SetAttr(Page3, d.disabled, 1);
				 ELSE	IGNORE l.SetAttr(Page1, d.disabled, 1);
					IGNORE l.SetAttr(Page2, d.disabled, 1);
					IGNORE l.SetAttr(Page3, d.disabled, 0);
				 END; (* if *)
				
				(* refresh the window and the gadgets *)
				RePageWindow;
			 ELSE (* ooops :*)
			 END; (* if *)
		 END; (* if *)
	 END; (* if *)
 UNTIL (iMsg = NIL);
 
 RETURN rc;
 
 END HandleMsgs;



(* Get submitted arguments ------------------------------------------------------ *)

PROCEDURE GetArguments;

 VAR	strBuf		: ARRAY [0..127] OF CHAR;
	argNum, len	: INTEGER;
	signed, err	: BOOLEAN;
	long		: LONGINT;
 
 BEGIN
 
 argNum:= ar.NumArgs();
 IF	(argNum > 0)
  THEN	ar.GetArg(1, strBuf, len);
	hp.Allocate(TextAttr.name, len);
	el.CopyMem(S.ADR(strBuf), TextAttr.name, len);
	
	IF	(argNum > 1)
	 THEN	ar.GetArg(2, strBuf, len);
		cv.StrToVal(strBuf, long, signed, 10, err);
		TextAttr.ySize:= INTEGER(long);
	 END; (* if *)
  END; (* if *)
 
 END GetArguments;



(* MAIN ========================================================================= *)

VAR	idcmpMask,
	signals		: S.LONGSET;
	winSig		: SHORTCARD;
	done		: BOOLEAN;

BEGIN

GetArguments;
Init;

winSig:= Win^.userPort^.sigBit;
idcmpMask:= S.LONGSET{winSig};

WHILE	NOT done
 DO	signals:= el.Wait(idcmpMask);
	IF	(winSig IN signals)
	 THEN	done:= HandleMsgs() # 0;
	 END; (* if *)
 END; (* while *)


CLOSE

CleanUp;

END Pages.
