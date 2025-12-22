(* REVISION HEADER ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× *
   
 | $VER: Demo.mod 1.01 (26.09.94) by Stefan Schulz [sts]
 
 | Desc: Nonfunctional User Interface as Demonstration
 
 | Dist: This Module is © Copyright 1994 by Stefan Schulz
 |       It may be freely Distributed (Freeware)
 
 | Rqrs: triton.library V1.1
 |       Triton is © Copyright 1993/1994 by Stefan Zeiger
 
 | Lang: M2Amiga
 | Trns: M2Amiga Modula 2 Software Development System
 |       © Copyright by A+L AG, CH-2540 Grenchen
 
 | Hist: Revision 1.01 [sts] \26.09.94\\26.09.94\
 |        `- Names corrected to M2 Standard
 | 
 |       Revision 1.00 [sts] \06.09.94\\06.09.94\
 |        `- initial revision
 
 * ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× *)

MODULE Demo;

(* IMPORTS ********************************************************************** *)

IMPORT	td	: TritonD,
	tl	: TritonL;

IMPORT	A	: Arts,
	ed	: ExecD,
	id	: IntuitionD,
	S	: SYSTEM,
	ud	: UtilityD;

(* ****************************************************************************** *)

(* --- Objects ------------------------------------------------------------------ *)

VAR	App		: td.AppPtr;
	Project		: td.ProjectPtr;

VAR	AppBuffer	: ARRAY [0..3] OF ud.TagItem;
	ProjectBuffer	: ARRAY [0..15] OF ud.TagItem;


PROCEDURE InitApplication;

 BEGIN
 
 App:= tl.CreateApp
	( S.TAG(AppBuffer,
		td.caName,     S.ADR("M2AmigaDemo"),
		td.caLongName, S.ADR("M2Amiga Demo Application"),
		td.caVersion,  S.ADR("1.0"),
	  ud.tagDone)
	); (* CreateApp *)

 A.Assert(App#NIL, S.ADR("Couldn't create Application!"));
 
 END InitApplication;


PROCEDURE InitProject;

 BEGIN
 
 Project:= tl.OpenProject
	( App,
	  S.TAG(ProjectBuffer,
	  td.wiID,    10,
	  td.wiTitle, S.ADR("M2Amiga Demo Application"),
	  
	  td.wiBackfill, td.bfFillBackground,
	  td.wiPosition, td.wpCenterDisplay,
	  td.grVert,     td.grAlign,
	    td.obSpace,    td.stNormal,
	    td.grHoriz,    td.grPropSpaces+td.grCenter,
	      td.obSpace,    td.stNormal,
	      td.obText,     NIL,
			       td.atText,  S.ADR("Demo Demo Demo"),
			       td.atFlags, td.tx3D,
	      td.obSpace,    td.stNormal,
	    td.grEnd,      NIL,
	    td.obSpace,    td.stNormal,
	  td.grEnd,      NIL,  
	  
	  ud.tagEnd)
	); (* OpenProject *)
 
 A.Assert(Project#NIL, S.ADR("Couldn't open Project!"));
 
 END InitProject;



BEGIN

InitApplication;
InitProject;

IGNORE tl.Wait( App, 0 );

CLOSE

IF	Project # NIL
 THEN	tl.CloseProject(Project);
	Project:= NIL;
 END;

IF	App # NIL
 THEN	tl.DeleteApp(App);
	App:= NIL;
 END;

END Demo.
