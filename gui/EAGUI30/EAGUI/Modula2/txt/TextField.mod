(* REVISION HEADER ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× *
   
 | $VER: TextField.imp 3.00 (23.11.94) by Stefan Schulz [sts]
 
 | Desc: Example of implementing custom images using EAGUI
 
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
 |       1.00   \01.05.94\
 |              initial Version
 
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
 
 VAR	minWidth,
	minHeight	: LONGCARD;
	tf		: ciTextFieldPtr;
 
 (*$ SaveA4:= TRUE *)
 
 BEGIN
 
 S.SETREG( R.A4, hook^.data );
 
 (* get a pointer to our structure, and check if we actually got it *)
 tf:= S.CAST(ciTextFieldPtr, l.GetAttr(obj, d.userData));
 
 IF	(tf # NIL)
  THEN	(* now, we use the library to determine the dimensions of the string *)
	minWidth := l.TextLength(tf^.textAttr, tf^.string, "\o");
	minHeight:= l.TextHeight(tf^.textAttr);
	
	(* and finally, we set these values *)
	IGNORE l.SetAttr(obj, d.minWidth, minWidth);
	IGNORE l.SetAttr(obj, d.minHeight, minHeight);
  END; (* if *)
 
 RETURN NIL;
 
 END MethMinSizeTextField;


(* Render Method ---------------------------------------------------------------- *)

PROCEDURE MethRenderTextField
			( hook{R.A0}	: ud.HookPtr;
			  obj{R.A2}	: S.ADDRESS;
			  msg{R.A1}	: S.ADDRESS	) : S.ADDRESS;

 VAR	tf		: ciTextFieldPtr;
	minWidth,
	minHeight,
	width, height,
	left, top	: LONGCARD;
	rm		: d.RenderMessagePtr;
	buffer		: ARRAY [1..10] OF LONGINT;
	tagList		: ud.TagItemPtr;

 (*$ SaveA4:= TRUE *)
 
 BEGIN
 
 S.SETREG( R.A4, hook^.data );
 
 rm:= S.CAST(d.RenderMessagePtr, msg);
 
 (* get a pointer to our structure, and check if we actually got it *)
 tf:= S.CAST(ciTextFieldPtr, l.GetAttr(obj, d.userData));
 
 IF	(tf # NIL)
  THEN	(* get sizes of the object *)
	tagList:= S.TAG(buffer,
			d.minWidth,	0,
			d.minHeight,	0,
			d.width,	0,
			d.height,	0,
		  ud.tagEnd);
	buffer[2]:= S.ADR(minWidth);
	buffer[4]:= S.ADR(minHeight);
	buffer[6]:= S.ADR(width);
	buffer[8]:= S.ADR(height);  
	
	IGNORE l.GetAttrsA(obj,tagList);
	
	(* get offsets of object relative to root (window) *)
	left:= l.GetObjectLeft(rm^.rootPtr, obj);
	top := l.GetObjectTop(rm^.rootPtr, obj);
	
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
