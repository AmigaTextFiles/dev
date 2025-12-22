(*(*
 * ExecutiveAPI example
 *
 * This file is public domain.
 *
 * Author: Petri Nordlund <petrin@megabaud.fi>
 *
 * $Id: Example.c 1.1 1996/10/01 23:06:09 petrin Exp petrin $
 *
 * Oberon-Interface by Thomas Igracki (T.Igracki@Jana.berlinet.de)
 *
 *)*)

MODULE TestExecutiveAPI;
IMPORT
   y: SYSTEM, d: Dos, e: Exec, u: Utility, ol: OberonLib, 
   NoGuru2,
   ex: ExecutiveAPI;
CONST
  STACKSIZE = 10000;
VAR
  msg         : ex.ExecutiveMessagePtr;
  parentTask  : e.TaskPtr;
  parentSignal: SHORTINT;
  activeTasks : INTEGER;
  
  ls	      : LONGSET;

  oldnice     : LONGINT;

(* $IF SmallData *)
   "SmallData has to be switched off! I don't know why.."
(* $END *)

PROCEDURE ^WatchMeEntry;
PROCEDURE ^WatchRelativeEntry;
PROCEDURE ^SendMessage (message: ex.ExecutiveMessagePtr): BOOLEAN;

(**
 ** This is an example on how to use ExecutiveAPI.
 ** All ExecutiveAPI features are demonstrated.
 **
 **)

(**
 ** Send message to Executive's public message port.
 ** Return TRUE if success, FALSE if error occurred.
 ** See msg.error for the specific error code.
 **
 **)
(* $Debug- *)
PROCEDURE SendMessage (message: ex.ExecutiveMessagePtr): BOOLEAN;
VAR
  port : e.MsgPortPtr;
BEGIN
(**
 ** Find Executive public message port and send the message.
 ** Wait for reply.
 **
 **)
	e.Forbid();

        port := e.FindPort(ex.portname);
	IF port # NIL THEN
		e.PutMsg (port, message);
		e.Permit();
		e.WaitPort (message.message.replyPort);
		REPEAT UNTIL e.GetMsg(message.message.replyPort) = NIL;
			
		IF message.error = 0 THEN RETURN TRUE END;
	ELSE
		(** Executive is not running **)
		e.Permit();
	END;

	RETURN FALSE;
END SendMessage;
(* $Debug= *)


(**
 ** Create a new task. The new task will send a message to Executive and ask
 ** that its priority is kept below all scheduled tasks. This is like having
 ** the following entry in Executive.prefs:
 **
 **   TASK  Example_childtask NOSCHEDULE  BELOW
 **
 ** Start the Top client and you'll se what happens to the childtask's
 ** priority.
 **
 **)

PROCEDURE WatchMe;
VAR proc: d.ProcessPtr;
BEGIN
	parentSignal := e.AllocSignal(-1);
	IF parentSignal # -1 THEN
		parentTask := e.FindTask(NIL);

		proc := d.CreateNewProcTags(d.npEntry, 		y.VAL(y.ADDRESS,WatchMeEntry),
					    d.npName,		y.ADR("Example_childtask"),
					    d.npPriority,	0,
					    d.npStackSize,	STACKSIZE,
					    d.npOutput,         y.VAL(LONGINT,d.Output()),
					    d.npCloseOutput,    d.DOSFALSE,
					    u.done);
		IF proc # NIL THEN
			d.PrintF("Childtask started. Wait...\n");
			ls := e.Wait(LONGSET{parentSignal});
			d.PrintF("Childtask finished.\n");
		ELSE
			e.FreeSignal(parentSignal);
			d.PrintF("Can't create new process.\n");
			HALT(d.fail);
		END;

		e.FreeSignal(parentSignal);
	ELSE
		d.PrintF("Can't allocate signal.\n");
		HALT (d.fail);
	END;
END WatchMe;

(* $SaveAllRegs+ $ClearVars- $StackChk- *)
PROCEDURE *WatchMeEntry();
VAR
	message : ex.ExecutiveMessagePtr;
	t,i: LONGINT;
BEGIN
	(** This routine needs DosBase, parent_task and parent_signal **)
	ol.SetA5;

	d.PrintF("%s: Getting started.\n", e.FindTask(NIL).node.name);

	message := e.AllocVec(SIZE(ex.ExecutiveMessage), LONGSET{e.public,e.memClear});
	IF message # NIL THEN
		message.message.replyPort := e.CreateMsgPort();
		IF message.message.replyPort # NIL THEN
			message.message.node.type := e.message;
			message.message.length    := SIZE(ex.ExecutiveMessage);

			(** Make sure this is always initialized to zero! **)
			message.ident := 0;

			message.command := ex.cmdWatch;
			message.task    := e.FindTask(NIL);
			message.value1  := ex.whichTask;
			message.value2  := ex.typeNoSchedule;
			message.value3  := ex.priBelow;

			(** Ignore error **)
			IF SendMessage(message) THEN END;
		END;
	END;

	d.PrintF ("%s: Use some CPU time!\n", e.FindTask(NIL).node.name);
	(** Use some CPU time **)
	FOR t := 0 TO 20-1 DO
		FOR i := 0 TO 1000000-1 DO END;
		d.Delay(30);
	END;

	IF message # NIL THEN
		IF message.message.replyPort # NIL THEN
			e.DeleteMsgPort(message.message.replyPort);
		END;

		e.FreeVec(message);
	END;

	(** Forbid so we can finish completely, before the parent cleans up. **)
	e.Forbid();

	d.PrintF("%s: Quitting.\n", e.FindTask(NIL).node.name);
	e.Signal(parentTask, LONGSET{parentSignal});
END WatchMeEntry;
(* $ClearVars= *)


(**
 ** Create three tasks with priorities -1, 0 and +1. Assume that this task's
 ** priority is 0. Configure Executive to schedule all childtasks of this
 ** task so that their priority is relative to this task's priority. This is
 ** like having the following entry in Executive.prefs:
 **
 **   CHILDTASKS  Example  RELATIVE
 **
 ** Start the Top client and you'll se what happens to childtask priorities.
 ** Try using the PGRP option with Ps: "ps PGRP=<this task's pid>". You'll
 ** see that the childtasks don't seem to use any CPU time. CPU usage is
 ** transferred to the parent task, because its CPU usage is used when
 ** scheduling priority is calculated.
 **
 ** IMPORTANT! You'll have to issue the WATCH-command BEFORE starting any
 ** childtasks!
 **
 **)

PROCEDURE WatchRelative();
VAR
   proc1, proc2, proc3: d.ProcessPtr;
BEGIN
	msg.command := ex.cmdWatch;
	msg.task    := e.FindTask(NIL);
	msg.value1  := ex.whichChildtasks;
	msg.value2  := ex.typeRelative;

	IF ~SendMessage(msg) THEN
		d.PrintF("ex.cmdWatch command failed.\n");
		IF msg.error = ex.errorAlreadyWatched THEN
			d.PrintF("You can only issue an ex.cmdWatch command once for each task.\n");
			d.PrintF("Executive remembers the task name, and if that task is started again,\n");
			d.PrintF("it knows what to do with it.\n");
			d.PrintF("If ex.cmdWatch fails, check for ex.errorAlreadyWatched\n");
			d.PrintF("in msg.error. You can safely ignore this error. It's also possible\n");
			d.PrintF("that user has put the task to Executive.prefs.\n");
		ELSE
			HALT(d.fail);
		END;
	END;

	parentSignal := e.AllocSignal(-1);
	IF parentSignal # -1 THEN

		parentTask := e.FindTask(NIL);

		(** Forbid so all tasks start to run at the same time **)
		e.Forbid();

                activeTasks := 0;

		proc1 := d.CreateNewProcTags(d.npEntry,	y.VAL(y.ADDRESS,WatchRelativeEntry),
					  d.npName,	y.ADR("Example_childtask1"),
					  d.npPriority,	-1,
					  d.npStackSize,STACKSIZE,
					  d.npOutput,         y.VAL(LONGINT,d.Output()),
					  d.npCloseOutput,    d.DOSFALSE,
					  u.done);
		proc2 := d.CreateNewProcTags(d.npEntry,	y.VAL(y.ADDRESS,WatchRelativeEntry),
					  d.npName,	y.ADR("Example_childtask2"),
					  d.npPriority,	0,
					  d.npStackSize,STACKSIZE,
					  d.npOutput,         y.VAL(LONGINT,d.Output()),
					  d.npCloseOutput,    d.DOSFALSE,
					  u.done);
		proc3 := d.CreateNewProcTags(d.npEntry,	y.VAL(y.ADDRESS,WatchRelativeEntry),
					  d.npName,	y.ADR("Example_childtask3"),
					  d.npPriority,	1,
					  d.npStackSize,STACKSIZE,
					  d.npOutput,         y.VAL(LONGINT,d.Output()),
					  d.npCloseOutput,    d.DOSFALSE,
					  u.done);
		e.Permit();

		IF (proc1 # NIL) THEN INC(activeTasks) END;
		IF (proc2 # NIL) THEN INC(activeTasks) END;
		IF (proc3 # NIL) THEN INC(activeTasks) END;

		IF (activeTasks > 0) THEN
			d.PrintF("Childtasks started. Wait...\n");
			REPEAT
				ls := e.Wait(LONGSET{parentSignal});
			UNTIL activeTasks <= 0;
			d.PrintF("Childtasks finished.\n");
		ELSE
			e.FreeSignal(parentSignal);
			d.PrintF("Can't create new process.\n");
			HALT(d.fail);
		END;

		e.FreeSignal(parentSignal);
	ELSE
		d.PrintF("Can't allocate signal.\n");
		HALT(d.fail);
	END;
END WatchRelative;

(* $SaveAllRegs+ $ClearVars- $StackChk- *)
PROCEDURE *WatchRelativeEntry();
VAR
	t,i: LONGINT;
BEGIN
	(** We need DosBase, parentTask, parentSignal and activeTasks **)
	ol.SetA5();

	d.PrintF ("%s: Use some CPU time!\n", e.FindTask(NIL).node.name);
	(** Use some CPU time **)
	FOR t := 0 TO 20-1 DO
		FOR i := 0 TO 350000-1 DO END;
		d.Delay(40);
	END;

	(** Forbid so we can finish completely, before the parent cleans up. **)
	e.Forbid();

	DEC(activeTasks);

	d.PrintF("%s: Quitting.\n", e.FindTask(NIL).node.name);
	e.Signal(parentTask, LONGSET{parentSignal});
END WatchRelativeEntry;
(* $ClearVars= *)

BEGIN
(**
 ** Allocate ExecutiveMessage structure and initialize it.
 **
 **)

	msg := e.AllocVec(SIZE(ex.ExecutiveMessage), LONGSET{e.public,e.memClear});
	IF msg = NIL THEN
		d.PrintF("Can't allocate ExecutiveMessage structure.\n");
		HALT(d.fail);
	END;

	msg.message.replyPort := e.CreateMsgPort();
	IF msg.message.replyPort = NIL THEN
		d.PrintF("Can't create message port.\n");
		HALT(d.fail);
	END;

	msg.message.node.type := e.message;
	msg.message.length    := SIZE(ex.ExecutiveMessage);

	(** Make sure this is always initialized to zero! **)
	msg.ident := 0;

(**
 ** Add this program as Executive client. Executive can't quit
 ** before all clients have been removed.
 **
 **)

	msg.command := ex.cmdAddClient;

	IF ~SendMessage(msg) THEN
		d.PrintF("Can't add new client.\n");
		HALT(d.fail);
	END;

(**
 ** Ask Executive to return the real (not the scheduling) priority of this
 ** task. If this task is currently scheduled and you read the priority
 ** directly from task-structure, it will be somewhere in the dynamic
 ** range. There's no GetTaskPri() routine in exec.library which could
 ** be patched to return the real priority.
 **
 ** In a case a new task is launched with its parent task's priority, which
 ** is in the dynamic range, Executive notices this, and sets the real
 ** priority of the new task to its parent task's real priority. But if
 ** wish to create a childtask whose priority will be the priority of the 
 ** parent task plus one, and you read the priority from task-structure, it
 ** might be something like -58. Add one to this value, and you'll get -57.
 ** Executive can't correct this, so in this case use the
 ** ex.CMD_GET_PRIORITY command to obtain task's real priority.
 **
 **)

	msg.command := ex.cmdGetPriority;
	msg.task    := e.FindTask(NIL);

	IF ~SendMessage(msg) THEN
		d.PrintF("Can't obtain this task's real priority.\n");
		HALT(d.fail);
	END;

	d.PrintF("Scheduling priority: %ld --- Real priority: %ld\n",
			e.FindTask(NIL).node.pri, msg.value1);

(**
 ** Set this task's nice-value to -10. Store old value and restore it later.
 ** You should restore the nice-value, if the program can be executed in a
 ** shell, as the shell process will then get the nice-value.
 **
 **)

	msg.command := ex.cmdSetNice;
	msg.task    := e.FindTask(NIL);
	msg.value1  := -10;						(* new nice-value *)

	IF ~SendMessage(msg) THEN
		d.PrintF("Can't set this task's nice-value.\n");
		HALT(d.fail);
	END;

	oldnice := msg.value1;

	d.PrintF("Old nice-value: %ld\n",oldnice);

(**
 ** Get current nice-value.
 **
 **)

	msg.command := ex.cmdGetNice;
	msg.task    := e.FindTask(NIL);

	IF ~SendMessage(msg) THEN
		d.PrintF("Can't obtain this task's nice-value.\n");
		HALT(d.fail);
	END;

	d.PrintF("Current nice-value: %ld\n",msg.value1);

(**
 ** Restore old nice-value.
 **
 **)

	msg.command := ex.cmdSetNice;
	msg.task    := e.FindTask(NIL);
	msg.value1  := oldnice;

	IF ~SendMessage(msg) THEN
		d.PrintF("Can't set this task's nice-value.\n");
		HALT(d.fail);
	END;

(**
 ** Two ex.cmdWatch examples.
 **
 **)

	WatchMe();
	d.Delay(2*50);
	WatchRelative();

(**
 ** Client is removed in MyExit(). Don't forget to do it.
 **
 **)

	HALT(d.ok);


CLOSE (* MyExit() *)

(**
 ** Remove the client. This can't fail.
 **
 **)

	IF (msg # NIL) & (msg.message.replyPort # NIL) THEN
		msg.command := ex.cmdRemClient;

		IF SendMessage(msg) THEN END;
	END;

(**
 ** Delete the message.
 **
 **)

	IF msg # NIL THEN
		IF msg.message.replyPort # NIL THEN
			e.DeleteMsgPort(msg.message.replyPort);
		END;
		e.FreeVec(msg);
	END;
END TestExecutiveAPI.
