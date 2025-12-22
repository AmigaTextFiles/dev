(* REVISION HEADER ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× *
 | 
 | $VER: EAGuiL.def 1.00 (02.05.95) by Stefan Schulz
 | 
 | Module          : TextField
 | Last Modified   : Thursday, 02.05.94
 | Author          : Marcel Offermans, Stefan Schulz
 | Actual Revision : 1.00
 | 
 | 
 | Description
 | -----------
 |   Example of implementing custom images using EAGUI
 | 
 | Requirements
 | ------------
 |   - EAGUI.library V2
 | 
 | Language
 | --------
 |   - M2Amiga Modula 2 Software Development System
 |     © Copyright by A+L AG, CH-2540 Grenchen
 | 
 | Revision 1.00  \01.05.94\
 |  - initial revision
 |
 * ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× *)

IMPLEMENTATION MODULE TextField;

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

IMPORT	d	: EAGuiD,
	l	: EAGuiL;

IMPORT	gd	: GraphicsD,
	id	: IntuitionD,
	il	: IntuitionL,
	R,
	S	: SYSTEM,
	ud	: UtilityD;

(* ****************************************************************************** *)

(* GLOBALS ====================================================================== *)

VAR	IText		:= id.IntuiText{frontPen:1, drawMode:gd.jam1};

(* ============================================================================== *)

(* MinSize Method --------------------------------------------------------------- *)

PROCEDURE MethMinSizeTextField
			( hook{R.A0}	: ud.HookPtr;
			  obj{R.A2}	: S.ADDRESS;
			  msg{R.A1}	: S.ADDRESS	) : S.ADDRESS;
 
 VAR	ok,
	minWidth,
	minHeight	: LONGCARD;
	tf		: ciTextFieldPtr;
 
 (*$ SaveA4:= TRUE *)
 
 BEGIN
 
 S.SETREG( R.A4, hook^.data );
 
 (* get a pointer to our structure, and check if we actually got it *)
 tf:= S.CAST(ciTextFieldPtr, l.EaGetAttr(obj, d.eaUserData));
 
 IF	(tf # NIL)
  THEN	(* now, we use the library to determine the dimensions of the string *)
	minWidth := l.EaTextLength(tf^.textAttr, tf^.string, "\o");
	minHeight:= l.EaTextHeight(tf^.textAttr);
	
	(* and finally, we set these values *)
	ok:= l.EaSetAttr(obj, d.eaMinWidth, minWidth);
	ok:= l.EaSetAttr(obj, d.eaMinHeight, minHeight);
  END; (* if *)
 
 RETURN NIL;
 
 END MethMinSizeTextField;


(* Render Method ---------------------------------------------------------------- *)

PROCEDURE MethRenderTextField
			( hook{R.A0}	: ud.HookPtr;
			  obj{R.A2}	: S.ADDRESS;
			  msg{R.A1}	: S.ADDRESS	) : S.ADDRESS;

 VAR	tf		: ciTextFieldPtr;
	ok,
	minWidth,
	minHeight,
	width, height,
	left, top	: LONGCARD;
	rm		: d.EaRenderMessagePtr;
	buffer		: ARRAY [1..10] OF LONGINT;
	tagList		: ud.TagItemPtr;

 (*$ SaveA4:= TRUE *)
 
 BEGIN
 
 S.SETREG( R.A4, hook^.data );
 
 rm:= S.CAST(d.EaRenderMessagePtr, msg);
 
 (* get a pointer to our structure, and check if we actually got it *)
 tf:= S.CAST(ciTextFieldPtr, l.EaGetAttr(obj, d.eaUserData));
 
 IF	(tf # NIL)
  THEN	(* get sizes of the object *)
	tagList:= S.TAG(buffer,
			d.eaMinWidth,	0,
			d.eaMinHeight,	0,
			d.eaWidth,	0,
			d.eaHeight,	0,
		  ud.tagEnd);
	buffer[2]:= S.ADR(minWidth);
	buffer[4]:= S.ADR(minHeight);
	buffer[6]:= S.ADR(width);
	buffer[8]:= S.ADR(height);  
	
	ok:= l.EaGetAttrsA(obj,tagList);
	
	(* get offsets of object relative to root (window) *)
	left:= l.EaGetObjectLeft(rm^.rootPtr, obj);
	top := l.EaGetObjectTop(rm^.rootPtr, obj);
	
	(* now align the object *)
	IF	(citfAlignRight IN tf^.flags)
	 THEN	INC(left, width - minWidth);
	 ELSIF	~(citfAlignLeft IN tf^.flags)
	  THEN	INC(left, (width - minWidth) / 2);
	 END; (* if *)
	
	IF (citfAlignBottom IN tf^.flags)
	 THEN	INC(top, height - minHeight)
	 ELSIF	~(citfAlignTop IN tf^.flags)
	  THEN	INC(top, (height - minHeight) / 2);
	 END; (* if *)
	
	(* and finally render it *)
	IText.iTextFont:= tf^.textAttr;
	IText.iText    := tf^.string;
	IText.frontPen := tf^.frontPen;
	il.PrintIText(rm^.rastportPtr, S.ADR(IText), left, top);
  END; (* if *)
 
 RETURN NIL;
 
 END MethRenderTextField;

END TextField.imp
