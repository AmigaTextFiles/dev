(* ==================================================================== *)
(* === OPL - Oberon Portability Library =============================== *)
(* ==================================================================== *)

(*
******* OPLTermination/--about-- *******
*
*    $RCSfile: OPLTermination.mod $
*   $Revision: 1.1 $
*       $Date: 1995/09/01 05:00:58 $
*     $Author: phf $
*
* Description: Handle termination in a portable and safer way.
*
*   Copyright: Copyright (c) 1995 by Peter Fröhlich [phf].
*              All rights reserved.
*
*     License: This  file  is  freely distributable as long as no
*              money is made by distributing it.  You are allowed
*              (and   actually   encouraged)   to  modify  it  as
*              necessary for your Oberon-2 implementation but you
*              must  tell me about your changes.  Public releases
*              of  modified  versions  may  only  be made with my
*              written and signed (PGP) approval.
*
*      e-mail: p.froehlich@amc.cube.net
*
*     $Source: Users:Homes/phf/Programming/Development/OPL/TXT/REPOSITORY/OPLTermination.mod $
*
**************
*
**************
*)

(* ==================================================================== *)

MODULE OPLTermination;

(* ==================================================================== *)

IMPORT
(* SYSTEM: Amiga, AmigaOberon *)
  Dos, Alerts,
(* SYSTEM: Amiga, AmigaOberon *)
  SYSTEM;

(* ==================================================================== *)

(*
******* OPLTermination/--background-- *******
*
*   PURPOSE
*
*	Handle termination in a portable and safer way.
*
*   NOTES
*
*	An additional abstraction layer between applications and the
*	predeclared procedure HALT() is necessary since	the allowed
*	integer constants vary between different implementations of
*	the Oberon-2 language.
*
*	To be "symetric" the procedure ASSERT() is also dealt with
*	in this module, since it can cause program termination just
*	like HALT().
*
*	The module provides two interfaces:
*
*	1. HALT(), ASSERT(): This interface attempts to be compatible
*	   to the original predeclared procedures as far as signatures
*	   are concerned. Since polymorphic procedures are not allowed
*	   in Oberon-2 we provide only _one_ version of ASSERT(), the
*	   language definition provides _two_ predeclared versions.
*
*	2. Halt(), Assert(): This interface provides two additional
*	   parameters for a description of where and why the program
*	   terminated. I suggest a format for these messages but how
*	   they are displayed is implementation dependent.
*
*	Opposed to the language definition the integer representing the
*	"return code" to the underlying operating system must be one of
*	the following constants exported by this module:
*
*	okay
*
*	  The termination was not caused by an error.
*
*	warning
*
*	  The termination was caused by a small and easily fixed problem.
*	  This return code is only useful for operating systems featuring
*	  warnings, eg. in batch jobs.
*
*	error
*
*	  The termination was caused by a user error, eg. syntax errors
*	  in a compiler application.
*
*	fatal
*
*	  The termination was caused by a internal error, eg. a failed
*	  assertion or memory allocation.
*
*	Descriptions are only displayed for fatal errors, failed assertions
*	are considered to be fatal errors.
*
*	In addition to a portable interface to termination this module
*	provides a simple replacement for the CLOSE part of modules
*	which was supported by the original Oberon language and removed
*	in later revisions.
*
*	You can register hook procedures (using Register()) which will
*	be executed whenever a termination occurs through this module.
*	We suggest calling Register() only in the BEGIN part of modules
*	to ensure the correct order of calls to hook procedures.
*
*	The hook procedures are currently managed on a static stack of
*	maxHooks elements. If you need more hooks change that constant
*	and recompile. Sorry for any inconvinience.
*
*	I expect problems with this mechanism under the Oberon System.
*	Only the hook procedure associated with the module causing the
*	termination should be executed there, the other hooks should
*	be processed when their module is unloaded or System.Quit is
*	invoked. If anyone knows how this could be done, please contact
*	me! I'm desperate for good ideas...
*
*   ADAPTING TO YOUR OBERON-2 IMPLEMENTATION
*
*	To adapt this module to your Oberon-2 implementation you have
*	to choose suitable values for the following internal constants
*	defining the actual values passed to the predeclared HALT().
*
*	internalOkay
*	internalWarning
*	internalError
*	internalFatal
*
*	Additionally you have to implement Alert() for your system. If
*	you introduce further extensions or change the algorithms used
*	in this module, please mark these changes using
*
*			(* SYSTEM: <system>, <compiler> *)
*
*	on both ends, eg.
*
*	(* SYSTEM: Amiga, AmigaOberon *)
*	CLOSE
*	  IF ~processed THEN
*	    Alert (
*	      "Portability warning!",
*	      "OPLTermination",
*	      "Using AmigaOberon's CLOSE to process hooks"
*	    );
*	    ProcessHooks ();
*	  END;
*	(* SYSTEM: Amiga, AmigaOberon *)
*
*	This simplifies my job when updating the portable parts of this
*	module. System specific extensions should be described with a
*	new entry in this document as shown for the Amiga, AmigaOberon
*	version below.
*
*   NOTES ON SYSTEM: Amiga, AmigaOberon
*
*	The implementation of OPLTermination for the Amiga under the
*	AmigaOberon compiler by A+L uses Intuition-Alerts to display
*	the descriptions.
*
*	The CLOSE part language extension provided by the compiler is
*	used to ensure execution of hooks even if the program was
*	terminated using the predeclared procedures HALT() or ASSERT()
*	or by a run-time error.
*
*   SEE ALSO
*
*   REFERENCES
*
*	H. Mössenböck: The Programming Language Oberon-2. October
*	1993. Provided in electronic form with each Oberon System
*	implementation.
*
*	This report provides definitions of the predeclared HALT()
*	and ASSERT() procedures.
*
**************
*
**************
*)

(* === Versioning ===================================================== *)

CONST
  rcsId = "$Id: OPLTermination.mod 1.1 1995/09/01 05:00:58 phf Exp $";

VAR
  dummy: CHAR; (* Dummy variable to keep optimizer from doing his work. *)

(* ==================================================================== *)

CONST
  (* --- standard return codes *)
  okay*    = 0;
  warning* = 1;
  error*   = 2;
  fatal*   = 3;

CONST
(* SYSTEM: Amiga, AmigaOberon *)
  internalOkay    = Dos.ok;
  internalWarning = Dos.warn;
  internalError   = Dos.error;
  internalFatal   = Dos.fail;
(* SYSTEM: Amiga, AmigaOberon *)

CONST
  maxHooks* = 32;

TYPE
  String* = ARRAY 80 OF CHAR;
  Hook* = PROCEDURE ();

VAR
  hooks: ARRAY maxHooks OF Hook; (* --- stack of hooks *)
  top: INTEGER; (* --- index of next free slot on hook stack *)
  processed: BOOLEAN; (* --- hooks have already been processed *)

(* ==================================================================== *)

(*
******* OPLTermination/Alert *********************************************
*
*   SYNOPSIS
*	PROCEDURE Alert (title, location, cause: String);
*
*   FUNCTION
*	Display an alert message.
*
*   INPUTS
*	title - A string describing the type of alert that occured,
*	  eg. "Assertion failed", "Abstract method called", etc.
*	  This string will be prepended with "Alert: ".
*	location - A string describing where the alert occured. Be
*	  as exact as possible here and be consistent in format.
*	  This string will be prepended with "Location: ".
*	cause - A string describing the cause of the alert. Be as
*	  exact as possible here and be consistent in format.
*	  This string will be prepended with "Cause: ".
*
*   RESULT
*
*   BUGS
*
*   NOTES
*	This procedure is mainly provided for use in libraries where
*	fatal errors can occur that justify the use of alerts.
*
*	Application programs should _not_ use this procedure because
*	they usually deal with user errors which are better handled
*	by standard error messages.
*
*	Note that empty strings will be filled to "Undefined" by this
*	procedure, so you better fill them anyway.
*
*   SEE ALSO
*
**************************************************************************
*
**************************************************************************
*)

PROCEDURE Alert* (title, location, cause: String);
BEGIN

  (* --- fill empty strings *)

  IF (title = "") THEN title := "Title undefined"; END;
  IF (location = "") THEN location := "Location undefined"; END;
  IF (cause = "") THEN cause := "Cause undefined"; END;

  (* --- display the alert *)

(* SYSTEM: Amiga, AmigaOberon *)
  IF Alerts.Alert (
    "Alert: %s\nLocation: %s\nCause: %s",
    SYSTEM.ADR (title),
    SYSTEM.ADR (location),
    SYSTEM.ADR (cause)
  ) THEN END;
(* SYSTEM: Amiga, AmigaOberon *)

END Alert;

PROCEDURE ProcessHooks ();
(* --- Process all hooks on the stack. *)
VAR hook: Hook;
BEGIN
  WHILE (top > 0) DO
    DEC (top);
    hook := hooks[top];
    hook ();
  END;
  processed := TRUE;
END ProcessHooks;

PROCEDURE^ Assert* (expression: BOOLEAN; location, cause: String);

PROCEDURE ActualHalt (code: LONGINT);
(* --- Call the predeclared HALT() procedure. *)
VAR codeString: String;
BEGIN
  Assert (
    (code >= okay) & (code <= fatal),
    "OPLTermination.ActualHalt",
    "(code >= okay) & (code <= fatal) -- Illegal return code."
  );

  ProcessHooks ();

  CASE code OF
    okay:      HALT (internalOkay);
   |warning:   HALT (internalWarning);
   |error:     HALT (internalError);
   |fatal:     HALT (internalFatal);
  END;
END ActualHalt;

(* === Compatible Interface =========================================== *)

(*
******* OPLTermination/HALT **********************************************
*
*   SYNOPSIS
*	HALT (code: LONGINT);
*
*   FUNCTION
*	Terminate program execution.
*
*   INPUTS
*	code - The abstract error code you want to return to the
*	  calling environment.
*
*   RESULT
*
*   BUGS
*
*   NOTES
*	The code will be converted to a value that is considered correct
*	by the current compiler/architecture. This procedure should be
*	used in each and every module to achieve portability.
*
*   SEE ALSO
*	ASSERT(), Halt()
*
**************************************************************************
*
**************************************************************************
*)

PROCEDURE HALT* (code: LONGINT);
(* --- This declaration shadows the predeclared procedure HALT()! *)
BEGIN
  ActualHalt (code);
END HALT;

(*
******* OPLTermination/ASSERT ********************************************
*
*   SYNOPSIS
*	PROCEDURE ASSERT (expression: BOOLEAN);
*
*   FUNCTION
*	Assert truth of a boolean expression and terminate program if
*	it does not hold.
*
*   INPUTS
*	expression - Result of a BOOLEAN expression, eg. "ptr # NIL".
*
*   RESULT
*
*   BUGS
*
*   NOTES
*	ASSERT() should be used for procedure pre- and post-conditions
*	only. Other errors should use HALT().
*
*   SEE ALSO
*	Assert(), HALT()
*
**************************************************************************
*
**************************************************************************
*)

PROCEDURE ASSERT* (expression: BOOLEAN);
(* --- This declaration shadows the predeclared procedure ASSERT()! *)
BEGIN
  IF ~expression THEN HALT (fatal); END;
END ASSERT;

(* === Advanced Interface ============================================= *)

(*
******* OPLTermination/Halt **********************************************
*
*   SYNOPSIS
*	PROCEDURE Halt (code: LONGINT; location, cause: String);
*
*   FUNCTION
*	Terminate program execution.
*
*   INPUTS
*	code - The abstract error code you want to return to the
*	  calling environment.
*	location - A string describing where the termination occured,
*	  use "<module>.<procedure>" or "<module>.<class>.<method>"as
*	  a template.
*	cause - A string describing the cause of the termination.
*
*   RESULT
*
*   BUGS
*
*   NOTES
*	The code will be converted to a value that is considered correct
*	by the current compiler/architecture.
*
*   SEE ALSO
*	Assert(), HALT()
*
**************************************************************************
*
**************************************************************************
*)

PROCEDURE Halt* (code: LONGINT; location, cause: String);
BEGIN
  IF code = fatal THEN
    Alert ("OPLTermination.Halt() invoked!", location, cause);
  END;
  HALT (code);
END Halt;

(*
******* OPLTermination/Assert ********************************************
*
*   SYNOPSIS
*	PROCEDURE Assert (expression: BOOLEAN; location, cause: String);
*
*   FUNCTION
*	Assert truth of a boolean expression and terminate program if
*	it does not hold.
*
*   INPUTS
*	expression - Result of a BOOLEAN expression, eg. "ptr # NIL".
*	location - A string describing where the termination occured,
*	  use "<module>.<procedure>" or "<module>.<class>.<method>"as
*	  a template.
*	cause - A string describing the cause of the assertion, use
*	  "<assertion> -- <comment>" as a template.
*
*   RESULT
*
*   BUGS
*
*   NOTES
*	Assert() should be used for procedure pre- and post-conditions
*	only. Other errors should use Halt().
*
*   SEE ALSO
*	ASSERT(), Halt()
*
**************************************************************************
*
**************************************************************************
*)

PROCEDURE Assert* (expression: BOOLEAN; location, cause: String);
BEGIN
  IF ~expression THEN
    Alert ("OPLTermination.Assert()ion failed!", location, cause);
    HALT (fatal);
  END;
END Assert;

(*
******* OPLTermination/Register ******************************************
*
*   SYNOPSIS
*	PROCEDURE Register* (hook: Hook);
*
*   FUNCTION
*	Register "hook" as a procedure to be executed during termination.
*
*   INPUTS
*	hook - The procedure to be executed during termination, must be
*	  # NIL.
*
*   RESULT
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*	--background--
*
**************************************************************************
*
**************************************************************************
*)

PROCEDURE Register* (hook: Hook);
BEGIN
  Assert (
    hook # NIL,
    "OPLTermination.Register",
    "hook # NIL -- Can't register NIL hook"
  );
  Assert (top < maxHooks,
    "OPLTermination.Register",
    "top < maxHooks -- Stack of hooks full"
  );
  hooks[top] := hook;
  INC (top);
END Register;

(* ==================================================================== *)

BEGIN
  dummy := rcsId[0];

  top := 0; processed := FALSE;

(* SYSTEM: Amiga, AmigaOberon *)

CLOSE

  IF ~processed THEN
    Alert (
      "Portability warning!",
      "OPLTermination.",
      "Using AmigaOberon's CLOSE to process hooks."
    );
    ProcessHooks ();
  END;

(* SYSTEM: Amiga, AmigaOberon *)

END OPLTermination.

(* ==================================================================== *)

(*
******* OPLTermination/--history-- *******
*
* $Log: OPLTermination.mod $
* Revision 1.1  1995/09/01  05:00:58  phf
* Initial revision
*
* History before introduction of RCS:
*
*   v0.5 (01-Sep-1995) [phf]
*
*	Editorial changes to the autodocs. Started using RCS so a
*	jump to version 1.1 occurs without technical reasons.
*
*   v0.4 (22-Jul-1995) [phf]
*
*	Editorial changes to the autodocs. Alerts are now displayed
*	only for fatal errors.
*
*   v0.3 (22-Jun-1995) [phf]
*
*	Extended autodocs, renamed library from NML to OPL.
*
*   v0.2 (03-Jun-1995) [phf]
*
*	Renamed TYPE Message to String to avoid some confusion with my
*	beta-testers. Alert() is now exported for client libraries that
*	define special alerts. Fixed some typos in the documentation.
*
*   v0.1 (31-May-1995) [phf]
*
*	Added extensive documentation. Introduced HALT() and ASSERT()
*	for compatability, replaced Terminate() by Halt(). Added
*	support for multiple termination hooks. Moved from NCL to NML.
*
*   v0.0 (29-May-1995) [phf]
*
*	Extracted from NCLTerminationHandler.mod. Introduced simple
*	termination hook.
*
**************
*
**************
*)

(* ==================================================================== *)
