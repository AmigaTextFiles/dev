/*
 * ExecutiveAPI example
 *
 * This file is public domain.
 *
 * Original Author: Petri Nordlund <petrin@megabaud.fi>
 * Converted to E by Jaco Schoonen (jaco@stack.urc.tue.nl)
 *
 * $Id: Example.c 1.1 1996/10/01 23:06:09 petrin Exp petrin $
 *
 */


OPT PREPROCESS

MODULE 'exec/types','exec/memory','exec/ports','exec/tasks','exec/nodes',
       'dos/dos','dos/dostags',
       'other/geta4','other/executiveapi'

ENUM NO_ERROR,FAIL


#define STACK_SIZE 10000

DEF msg:PTR TO executivemessage,
    parent_task:tc,
    parent_signal,
    active_tasks


/**
 ** This is an example on how to use ExecutiveAPI. All ExecutiveAPI features
 ** are demonstrated.
 **
 **/

PROC main() HANDLE
DEF oldnice,
    task:tc


/**
 ** Allocate ExecutiveMessage structure and initialize it.
 **
 **/
	IF (msg:=AllocVec(SIZEOF executivemessage,MEMF_PUBLIC OR MEMF_CLEAR))=0
	    WriteF('Can''t allocate ExecutiveMessage structure.\n')
	    Raise(FAIL)
	ENDIF

	msg.message.replyport:=CreateMsgPort()
	IF msg.message.replyport=0
	    WriteF('Can''t create message port.\n')
	    Raise(FAIL)
	ENDIF

	msg.message.ln.type := NT_MESSAGE
	msg.message.length  := SIZEOF executivemessage

	/** Make sure this is always initialized to zero! **/
	msg.ident := 0

/**
 ** Add this program as Executive client. Executive can't quit
 ** before all clients have been removed.
 **
 **/

	msg.command := EXAPI_CMD_ADD_CLIENT

	IF (sendmessage(msg))=FALSE
	   WriteF('Can''t add new client.')
	   Raise(FAIL)
	ENDIF

/**
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
 ** EXAPI_CMD_GET_PRIORITY command to obtain task's real priority.
 **
 **/

	msg.command := EXAPI_CMD_GET_PRIORITY
	msg.task    := FindTask(NIL)

	IF (sendmessage(msg))=0
		WriteF('Can''t obtain this task''s real priority.\n')
		Raise(FAIL)
	ENDIF

	task:=FindTask(NIL)
	WriteF('Scheduling priority: \d --- Real priority: \d\n',
			signed_char(task.ln.pri),
			msg.value1
	      )

/**
 ** Set this task's nice-value to -10. Store old value and restore it later.
 ** You should restore the nice-value, if the program can be executed in a
 ** shell, as the shell process will then get the nice-value.
 **
 **/

	msg.command := EXAPI_CMD_SET_NICE;
	msg.task    := FindTask(NIL);
	msg.value1  := -10;                                             /* new nice-value */

	IF (sendmessage(msg))=0
		WriteF('Can''t set this task''s nice-value.\n')
		Raise(FAIL)
	ENDIF

	oldnice := msg.value1

	WriteF('Old nice-value: \d\n',oldnice)

/**
 ** Get current nice-value.
 **
 **/

	msg.command := EXAPI_CMD_GET_NICE
	msg.task    := FindTask(NIL)

	IF (sendmessage(msg))=0
		WriteF('Can''t obtain this task''s nice-value.\n')
		Raise(FAIL)
	ENDIF

	WriteF('Current nice-value: \d\n',msg.value1)

/**
 ** Restore old nice-value.
 **
 **/

	msg.command := EXAPI_CMD_SET_NICE
	msg.task    := FindTask(NIL)
	msg.value1  := oldnice

	IF (sendmessage(msg))=0
		WriteF('Can''t set this task''s nice-value.\n')
		Raise(FAIL)
	ENDIF


/**
 ** Two EXAPI_CMD_WATCH examples.
 **
 **/
	storea4()

	watchme()
	Delay(2*50)
	watchrelative()

/**
 ** Client is removed in exception handler. Don't forget TO DO it.
 **
 **/


Raise(NO_ERROR)


EXCEPT

/**
 ** Remove the client. This can't fail.
 **
 **/
	IF (msg AND (msg.message.replyport))
		msg.command := EXAPI_CMD_REM_CLIENT
		sendmessage(msg)
	ENDIF

/**
 ** Delete the message.
 **
 **/

	IF msg
	   IF msg.message.replyport
	       DeleteMsgPort(msg.message.replyport)
	       FreeVec(msg)
	   ENDIF
       ENDIF

ENDPROC exception -> return exception-number to shell (0 or 1)



/**
 ** Send message to Executive's public message port.
 ** Return TRUE if success, FALSE if error occurred.
 ** See msg->error for the specific error code.
 **
 **/
PROC sendmessage(message:PTR TO executivemessage)

DEF port

/**
 ** Find Executive public message port and send the message.
 ** Wait for reply.
 **
 **/

	Forbid()

	IF (port:=FindPort(EXECUTIVEAPI_PORTNAME))
		PutMsg(port, message)
		Permit()
		WaitPort(message.message.replyport)
		WHILE GetMsg(message.message.replyport) DO NOP

		IF message.error=0 THEN RETURN TRUE
	ELSE
		/** Executive is not running **/
		Permit();
	ENDIF

	RETURN FALSE
ENDPROC



/**
 ** Create a new task. The new task will send a message to Executive and ask
 ** that its priority is kept below all scheduled tasks. This is like having
 ** the following entry in Executive.prefs:
 **
 **   TASK  Example_childtask NOSCHEDULE  BELOW
 **
 ** Start the Top client and you'll se what happens to the childtask's
 ** priority.
 **
 **/

PROC watchme()

	IF (parent_signal:=AllocSignal(-1)) <> -1
	   parent_task := FindTask(NIL)

	   IF CreateNewProc( [NP_ENTRY, {watchme_entry},
			       NP_NAME,  'Example_childtask',
			       NP_PRIORITY,    0,
			       NP_STACKSIZE,   STACK_SIZE,
			       0
			      ]
			   )

	      WriteF('Childtask started. Wait...\n')
	      Wait(Shl(1,parent_signal))
	      WriteF('Childtask finished.\n')
	   ELSE
		   FreeSignal(parent_signal)
		   WriteF('Can''t create new process.\n')
		   Raise(FAIL)
	   ENDIF

	   FreeSignal(parent_signal)
	ELSE
	   WriteF('Can''t allocate signal.\n')
	   Raise(FAIL)
	ENDIF
ENDPROC

PROC watchme_entry()

DEF message:executivemessage
DEF t,i

	/** This routine needs DosBase, parent_task and parent_signal **/
	geta4()

	IF (message:=AllocVec(SIZEOF executivemessage, MEMF_PUBLIC OR MEMF_CLEAR))
		message.message.replyport:=CreateMsgPort()
		IF message.message.replyport
			message.message.ln.type := NT_MESSAGE
			message.message.length  := SIZEOF executivemessage

			/** Make sure this is always initialized to zero! **/
			message.ident := 0

			message.command := EXAPI_CMD_WATCH
			message.task    := FindTask(NIL)
			message.value1  := EXAPI_WHICH_TASK
			message.value2  := EXAPI_TYPE_NOSCHEDULE
			message.value3  := EXAPI_PRI_BELOW

			/** Ignore error **/
			sendmessage(message)
		ENDIF
	ENDIF

	/** Use some CPU time **/
	FOR t:=0 TO 20
		FOR i:=0 TO 1000000 DO NOP
		Delay(30)
	    INC t
	ENDFOR

	IF message
		IF message.message.replyport THEN DeleteMsgPort(message.message.replyport)
		FreeVec(message);
	ENDIF

	/** Forbid so we can finish completely, before the parent cleans up. **/
	Forbid()

	Signal(parent_task, Shl(1, parent_signal))
ENDPROC


/**
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
 **/


PROC watchrelative()

DEF proc1,proc2,proc3

	msg.command := EXAPI_CMD_WATCH
	msg.task    := FindTask(NIL)
	msg.value1  := EXAPI_WHICH_CHILDTASKS
	msg.value2  := EXAPI_TYPE_RELATIVE

	IF (sendmessage(msg))=FALSE
		WriteF('EXAPI_CMD_WATCH command failed.\n')
		IF (msg.error = EXAPI_ERROR_ALREADY_WATCHED)
			WriteF('You can only issue an EXAPI_CMD_WATCH command once for each task.\n')
			WriteF('Executive remembers the task name, and if that task is started again,\n')
			WriteF('it knows what to do with it.\n')
			WriteF('If EXAPI_CMD_WATCH fails, check for EXAPI_ERROR_ALREADY_WATCHED\n')
			WriteF('in msg.error. You can safely ignore this error. It''s also possible\n')
			WriteF('that user has put the task to Executive.prefs.\n')
		ELSE
			Raise(FAIL)
		ENDIF
	ENDIF

	IF (parent_signal:=AllocSignal(-1)) <> -1

		parent_task := FindTask(NIL)

		/** Forbid so all tasks start to run at the same time **/
		Forbid()



		proc1 := CreateNewProc( [NP_ENTRY, {watchrelative_entry},
					 NP_NAME,  'Example_childtask1',
					 NP_PRIORITY,    -1,
					 NP_STACKSIZE,   STACK_SIZE,
					 0
					]
				      )

		proc2 := CreateNewProc( [NP_ENTRY, {watchrelative_entry},
					 NP_NAME,  'Example_childtask2',
					 NP_PRIORITY,    0,
					 NP_STACKSIZE,   STACK_SIZE,
					 0
					]
				      )

		proc3 := CreateNewProc( [NP_ENTRY, {watchrelative_entry},
					 NP_NAME,  'Example_childtask3',
					 NP_PRIORITY,    1,
					 NP_STACKSIZE,   STACK_SIZE,
					 0
					]
				      )

		Permit()

		IF proc1 THEN active_tasks++
		IF proc2 THEN active_tasks++
		IF proc3 THEN active_tasks++

		IF active_tasks
			WriteF('Childtasks started. Wait...\n')
			REPEAT
			    Wait(Shl(1,parent_signal))
			UNTIL active_tasks=0

			WriteF('Childtasks finished.\n')
		ELSE
			FreeSignal(parent_signal)
			WriteF('Can''t create new process.\n')
			Raise(FAIL)
		ENDIF

		FreeSignal(parent_signal)
	ELSE
		WriteF('Can''t allocate signal.')
		Raise(FAIL)
	ENDIF
ENDPROC

PROC watchrelative_entry()
DEF t,i

	/** We need DosBase, parent_task, parent_signal and active_tasks **/
	geta4()

	/** Use some CPU time **/
	FOR t:=0 TO 20
		FOR i:=0 TO 350000 DO NOP
		Delay(40)
		INC t
	ENDFOR

	/** Forbid so we can finish completely, before the parent cleans up. **/
	Forbid()

	active_tasks--

	Signal(parent_task, Shl(1,parent_signal))
ENDPROC

PROC signed_char(c) IS IF c<128 THEN c ELSE c-256

