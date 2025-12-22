(* REVISION HEADER ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× *
   
 | $VER: Example 3.00 (23.11.94) by Stefan Schulz [sts]
 
 | Desc: Example for using EAGUI via M2
 
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
 |              adapted to EAGUI.library V3
 |
 |       1.01   \03.05.94\
 |              exended for recognizing Button-Presses
 |
 |       1.00   \01.05.94\
 |              initial Version
 
 * ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× *)

MODULE Example;

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

CONST	WindowTitle	= "EAGUI-Example";
	HowNice		= "Ah, a size change! How nice.";
	OkButton	= "Oh! You pressed the Ok-Button! Fine.";
	CancelButton	= "Cancel? Why so negative? Tsk tsk.";
	EnterStringHere	= "Enter a string here:";
	ErrNoDrawInfo	= "Couldn't get the draw info.\n";
	ErrNoFont	= "Couldn't open font.\n";
	ErrNoGadList	= "Couldn't create the gadget list.\n";
	ErrNoObjects	= "Couldn't init the objects.\n";
	ErrNoScreenLock	= "Couldn't lock default public screen.\n";
	ErrNoVisualInfo	= "Couldn't get the visual info.\n";
	ErrNoWindow	= "Couldn't open the window.\n";
	Ok		= "OK";
	Cancel		= "Cancel";

CONST	DefaultFont	= "helvetica.font";

CONST	okID		= 1;
	cancelID	= 2;

VAR	WinObj,
	OkObj,
	CancelObj,
	HGroupObj	: d.OPTR;
	
	Win		: id.WindowPtr;
	Scr		: id.ScreenPtr;
	GadList		: id.GadgetPtr;
	StringGadget	: id.GadgetPtr;
	VisualInfo	: S.ADDRESS;
	DrawInfo	: id.DrawInfoPtr;
	TextFont	: gd.TextFontPtr;
	
	TextAttr	:= gd.TextAttr {name  : S.ADR(DefaultFont),
					ySize : 15,
					style : gd.normalFont,
					flags : gd.FontFlagSet{gd.diskFont}
				       };
	RelHook,
	TFMinSizeHook,
	TFRenderHook	: ud.Hook;
	IMsg		: id.IntuiMessage;
	TextField1	: tf.ciTextField;

(* ============================================================================== *)

(* Same Size Relation ----------------------------------------------------------- *)
PROCEDURE RelSameSize	  (	hook{R.A0}  : ud.HookPtr;
				obj{R.A2}   : S.ADDRESS;
				msg{R.A1}   : S.ADDRESS		) : S.ADDRESS;

 VAR	rObj		: d.RelationObjectPtr;
	list		: ed.ListPtr;
	ok,
	minx, miny,
	x, y		: LONGCARD;
	buffer		: ARRAY [1..6] OF LONGINT;
	tagList		: ud.TagItemPtr;

 (*$ SaveA4:= TRUE *)

 BEGIN
 
 S.SETREG( R.A4, hook^.data );
 
 minx:= 0;
 miny:= 0;
 
 (* examine the list of objects that are affected by the relation *)
 list:= S.CAST(ed.ListPtr, obj);
 rObj:= S.CAST(d.RelationObjectPtr, list^.head);
 
 WHILE	(rObj^.node.succ # NIL)
  DO	tagList:= S.TAG(buffer,
			d.minWidth,  0,
			d.minHeight, 0,
		  ud.tagEnd);
	buffer[2]:= S.ADR(x);
	buffer[4]:= S.ADR(y);
	
	ok:= l.GetAttrsA(rObj^.objectPtr, tagList);
	
	(* find the maximum values of the minimum sizes *)
	IF (x > minx) THEN minx:= x  END;
	IF (y > miny) THEN miny:= y  END;
	
	rObj:= S.CAST(d.RelationObjectPtr, rObj^.node.succ);
  END; (* while *)
 
 (* set all objects to the newly found minimum sizes *)
 rObj:= S.CAST(d.RelationObjectPtr, list^.head);
 
 WHILE	(rObj^.node.succ # NIL)
  DO	ok:= l.SetAttrsA
		( rObj^.objectPtr,
		  S.TAG(buffer,
			d.minWidth,  minx,
			d.minHeight, miny,
		  ud.tagEnd)
		);
	
	rObj:= S.CAST(d.RelationObjectPtr, rObj^.node.succ);
  END; (* while *)
 
 RETURN NIL;
  
 END RelSameSize;



(* Recreate the gadget-list ----------------------------------------------------- *)

PROCEDURE ResizeWindow;

 VAR	ok,
	bLeft, bRight,
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
 
 ok:= l.GetAttrsA
	( WinObj,
	  S.TAG(buffer,
		d.borderLeft,   S.ADR(bLeft),
		d.borderRight,  S.ADR(bRight),
		d.borderTop,    S.ADR(bTop),
		d.borderBottom, S.ADR(bBottom),
	  ud.tagDone)
	); (* l.GetAttrsA *)
 
 ok:= l.SetAttrsA
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



(* Init all --------------------------------------------------------------------- *)

PROCEDURE Init;

 VAR	ok,
	width, height,
	bLeft, bRight,
	bTop, bBottom	: LONGINT;
	buffer1,
	buffer2		: ARRAY [1..50] OF LONGINT;
	bool		: BOOLEAN;

 BEGIN
 
 (* open the font *)
 TextFont:= dfl.OpenDiskFont(S.ADR(TextAttr));
 A.Assert(TextFont # NIL, S.ADR(ErrNoFont));
 
 (* initialize the relation *)
 RelHook.entry:= RelSameSize;
 RelHook.data := S.REG(R.A4);
 
 (* initialize textfield hooks *)
 TFMinSizeHook.entry:= tf.MethMinSizeTextField;
 TFMinSizeHook.data := S.REG(R.A4);
 
 TFRenderHook.entry:= tf.MethRenderTextField;
 TFRenderHook.data := S.REG(R.A4);
 
 (* now we can build the object tree *)

 OkObj:= m.GTButton
		( Ok,
		  S.TAG(buffer1,
			d.gtTextAttr, S.ADR(TextAttr),
			d.id, okID,
		  ud.tagEnd)
		);
 
 CancelObj:= m.GTButton
		( Cancel,
		  S.TAG(buffer1,
			d.gtTextAttr, S.ADR(TextAttr),
			d.id, cancelID,
		  ud.tagEnd)
		);
 
 HGroupObj:= m.HGroup
		( S.TAG(buffer1,
			d.borderTop, 4,
			d.child, OkObj,
			d.child, m.EmptyBox(1, NIL),
			d.child, CancelObj,
		  ud.tagEnd)
		);
 
 WinObj:= m.VGroup
		( S.TAG(buffer1,
			d.borderLeft,   4,
			d.borderRight,  4,
			d.borderTop,    4,
			d.borderBottom, 4,
			d.child, l.NewObjectA
			 (d.typeCustomImage,
			  S.TAG(buffer2,
				d.borderBottom,  4,
				d.minSizeMethod, S.ADR(TFMinSizeHook),
				d.renderMethod,  S.ADR(TFRenderHook),
				d.userData,      S.ADR(TextField1),
			  ud.tagDone)),
			d.child, m.GTString
			 ("",
			  S.TAG(buffer2,
				d.gtTextAttr,      S.ADR(TextAttr),
				d.instanceAddress, S.ADR(StringGadget),
				d.minWidth,        20,
			  ud.tagDone)),
			d.child, HGroupObj,
		  ud.tagEnd)
		); (* m.VGroup *)
 
 A.Assert(WinObj # NIL, S.ADR(ErrNoObjects));
 
 ok:= l.NewRelationA
	( HGroupObj, S.ADR(RelHook),
	  S.TAG(buffer1,
		d.object, OkObj,
		d.object, CancelObj,
	  ud.tagEnd)
	);
 
 (* lock the screen *)
 Scr:= il.LockPubScreen(NIL);
 A.Assert(Scr # NIL, S.ADR(ErrNoScreenLock));
 
 (* get VisualInfo and DrawInfo *)
 VisualInfo:= gtl.GetVisualInfoA(Scr, NIL);
 A.Assert(VisualInfo # NIL, S.ADR(ErrNoVisualInfo));
 DrawInfo:= il.GetScreenDrawInfo(Scr);
 A.Assert(DrawInfo # NIL, S.ADR(ErrNoDrawInfo));
 
 (* fill in the textfield structure *)
 TextField1.string  := S.ADR(EnterStringHere);		(* title *)
 TextField1.textAttr:= S.ADR(TextAttr);			(* font  *)
 TextField1.flags   := tf.CITFFlagSet{tf.citfAlignTop};	(* alignment flags *)
 TextField1.frontPen:= 2;				(* frontpen color index *)
 
 (* obtain the minimum dimensions of every object in the tree *)
 l.GetMinSizes(WinObj);
 
 (* get some attributes *)
 ok:= l.GetAttrsA
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
		  -1,
		  height + Win^.borderTop + Win^.borderBottom + bTop + bBottom
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
			(* Just for fun, we put a string in the string gadget after each
			 * resize. This demonstrates how to use the EA_InstanceAddress
			 * tag to obtain pointers to gadgets, which you can use to modify
			 * the gadgets directly.
			 *)
			adr:= S.ADR(HowNice);
			gtl.GTSetGadgetAttrsA
					( StringGadget, Win, NIL,
					  S.TAG(buffer,
						gtd.gtstString, adr,
					  ud.tagDone)
					);
		 ELSIF	(id.gadgetUp IN IMsg.class)
		  THEN	CASE id.GadgetPtr(IMsg.iAddress)^.gadgetID OF
			 | okID :
				adr:= S.ADR(OkButton);
				gtl.GTSetGadgetAttrsA
						( StringGadget, Win, NIL,
						  S.TAG(buffer,
							gtd.gtstString, adr,
						  ud.tagDone)
						);
			 | cancelID :
				adr:= S.ADR(CancelButton);
				gtl.GTSetGadgetAttrsA
						( StringGadget, Win, NIL,
						  S.TAG(buffer,
							gtd.gtstString, adr,
						  ud.tagDone)
						);
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

END Example.
