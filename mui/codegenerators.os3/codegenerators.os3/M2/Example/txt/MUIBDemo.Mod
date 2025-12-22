(* REVISION HEADER ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× *
   
 | $VER: MUIBDemo 1.00 (30.11.94) by Stefan Schulz [sts]
 
 | Desc: Testprogram for the MUIBDemoGui-Example
 
 | Dist: This Module is © Copyright 1994 by Stefan Schulz
 
 | Rqrs: Amiga OS 2.0 or higher
 |       muimaster.library © Copyright by Stefan Stuntz
 
 | Lang: M2Amiga
 | Trns: M2Amiga Modula 2 Software Development System
 |       © Copyright by A+L AG, CH-2540 Grenchen
 
 | Hist: Version \date\
 |
 |       1.00   \30.11.94\
 |              initial Version
 
 * ×××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××××× *)

MODULE MUIBDemo;

(* IMPORTS ********************************************************************** *)

IMPORT	gm	: MUIBDemoMui,
	el	: ExecL,
	md	: MBMuiD,
	ms	: MBMuiSupport,
	S	: SYSTEM;

(* DEFINITIONS ****************************************************************** *)

VAR	(* Pointer to our Application *)
	app	: gm.ObjAppPtr;
	
	(* Signals to wait on *)
	signals	: S.LONGSET;
	
	(* Message of our GUI *)
	Result	: LONGINT;
	
	(* Buffer for DoMethod *)
	doBuffer: ARRAY [1..2] OF LONGINT;

(* MAIN PROGRAM ***************************************************************** *)

BEGIN

(* --- First let's create the Application --------------------------------------- *)
app:= gm.CreateApp();

(* --- Main loop. Check for Messages and Wait for signals ----------------------- *)
signals:= S.LONGSET{};
LOOP	(* --- Check, if a message is up and get signals to wait on ------------- *)
	Result:= ms.DOMethod( app^.App,
			      S.TAG(doBuffer,
				    md.mmApplicationInput, S.ADR(signals))
			    ); (* DOMethod *)
	
	(* --- Someone sent the Quit-Message (Close-Gadget) --------------------- *)
	IF (Result = md.mvApplicationReturnIDQuit) THEN EXIT  END;
	
	(* --- Wait for signals ------------------------------------------------- *)
	IF (signals # S.LONGSET{}) THEN signals:= el.Wait(signals)  END;
	
END; (* loop *)


CLOSE

(* --- That's it. Clean up memory ----------------------------------------------- *)
gm.DisposeApp;

END MUIBDemo.
