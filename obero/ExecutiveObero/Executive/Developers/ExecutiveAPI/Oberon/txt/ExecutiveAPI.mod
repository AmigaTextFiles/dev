(*(*
**      $VER: ExecutiveAPI.h 1.00 (03.09.96)
**      ExecutiveAPI Release 1.00
**
**      ExecutiveAPI definitions
**
**      Copyright © 1996 Petri Nordlund. All rights reserved.
**
**      $Id: ExecutiveAPI.h 1.1 1996/10/01 23:08:16 petrin Exp petrin $
**
**      Oberon-Interface by Thomas Igracki (T.Igracki@Jana.berlinet.de)
**
*)*)

MODULE ExecutiveAPI;
(* $StackChk- $RangeChk- $CaseChk- $OvflChk- $ReturnChk- $TypeChk- $NilChk- *)
(* $Implementation- *)
IMPORT
   y: SYSTEM, e: Exec;

(*
 * Public message port to send messages to
 *
 *)
CONST
  portname * = "Executive_server";


(*
 * ExecutiveMessage
 *
 *)
TYPE
  ExecutiveMessagePtr * = UNTRACED POINTER TO ExecutiveMessage;
  ExecutiveMessage * = STRUCT (message *: e.Message)
     ident    *: INTEGER;   (* WORD: This must always be 0  *)

     command  *: INTEGER;   (* WORD: Command to be sent, see below *)
     task     *: e.TaskPtr; (* struct Task*: Task address *)
     taskname *: e.STRPTR;  (* STRPTR: Task name *)
     value1   *: LONGINT;   (* LONG: Depends on command *)
     value2   *: LONGINT;   (* LONG: Depends on command *)
     value3   *: LONGINT;   (* LONG: Depends on command *)
     value4   *: LONGINT;   (* LONG: Depends on command *)
     error    *: INTEGER;   (* WORD: Non-zero if error, see below  *)

     reserved  : ARRAY 4 OF LONGINT; (* LONG: Reserved for future use  *)
  END;


(*
 * Commands
 *
 *)
CONST
  cmdAddClient   * = 0;	(* Add new client				*)
  cmdRemClient   * = 1;	(* Remove client				*)

  cmdGetNice     * = 2;	(* Get nice-value				*)
  cmdSetNice     * = 3;	(* Set nice-value				*)

  cmdGetPriority * = 4;	(* Get task's correct (not scheduling) priority	*)

  cmdWatch       * = 5;	(* Schedle, don't schedle etc. See below	*)


(*
 * These are used with cmdWatch
 *
 *)

(* --> value1 *)
  whichTask       * = 0; (* Current task	    *)
  whichChildtasks * = 1; (* Childtasks of this task *)

(* --> value2 *)
  typeSchedule   * = 0;	(* Schedule	  this task / childtasks	*)
  typeNoSchedule * = 1;	(* Don't schedule this task / childtasks	*)
  typeRelative   * = 2;	(* Childtasks' priority relative to parent's	*)
			(* priority.					*)
(* --> value3 *)
(* These are only used with typeNoSchedule *)
  priLeaveAlone * = 0; (* Ignore task priority				*)
  priAbove      * = 1; (* Task's priority kept above scheduled tasks	*)
  priBelow      * = 2; (* Task's priority kept below scheduled tasks	*)
  priSet        * = 3; (* Set priority to given value (value4)		*)


(*
 * Errors
 *
 *)
  errorOk             * = 0; (* No error					*)
  errorTaskNotFound   * = 1; (* Specified task wasn't found			*)
  errorNoServer       * = 2; (* Server not available (quitting) 		*)
  errorInternal       * = 3; (* Misc. error (e.g. no memory)			*)
  errorAlreadyWatched * = 4; (* Task is already being watched, meaning that	*)
			     (* user has put the task to "Executive.prefs".	*)
END ExecutiveAPI.
