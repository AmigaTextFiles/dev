/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents:

	ctimer.o V1.00 (simple timer routine)
	TABLEN = 3 !

	This is a really simple method of beeing able to
	wait() for a time being flown.

	Descriptions follow below. Note that all times won't
	be very exact.
	This object had been designed to have some _simple_
	and _easy_ to use routines, not powerful high end
	timers !

	(c)April 1996 by Hans Bühler / codex@studi.mathematik.hu-berlin.de
											 Kirchstr.22 * 10557 Berlin 21 * Ger
*/

#ifndef	_CTIMER_H

#define	_CTIMER_H	1

#include	<exec/types.h>
#include	<exec/memory.h>
#include	<exec/ports.h>
#include	<exec/lists.h>
#include	<exec/nodes.h>
#include	<dos/dos.h>

// --------------------------
// defines
// --------------------------

/*
	general constants
	-----------------
*/

#define	CTIM_MAX_TIME			0x7FFFFFFF			// no longer waiting
#define	CTIM_MAX_DELAY			0xFF					// maximum 1/50s time units
#define	CIIM_DEFDELAY			0x0A					// recommended 'timeDelay' for ctimerInit()

/*
	return codes
	------------
*/

// general
#define	TRET_OKAY				0x00					// everything went well
#define	TRET_OUTOFMEMORY		0x01					// :-(
#define	TRET_BADINPUT			0x02					// you did something wronh
#define	TRET_BADTIMER			0x03					// "timername" timer doesn't exist

// ctimerInit()
#define	TRET_BADNAME			0x10					// timer with that name already found !
#define	TRET_NOSIGNAL			0x11					// can't allocate new (temp) signal for calling process
#define	TRET_NOPROCESS			0x12					// can't launch child process
#define	TRET_NOCHILDCONFIG	0x13					// failed to initialize new process

// ctimerRem()
#define	TRET_BADTASK			0x22					// ctimerRem() _must_ be called by the same task
																// which called ctimerInit()

// very bad errors
#define	TRET_BADCASE_1			0xF0					// illegal job ID

// ----------------------------------
// YOU have to make these available
// ----------------------------------

/*
	extern struct DOSBase			*DOSBase;
	extern struct ExecBase			*SysBase;
*/

// ----------------------------------
// functions1: setup & remove a timer
// ----------------------------------

/*
	Before you can use some of the lower timed functions,
	you have to initialize a timer using ctimerInit().
	A timer which has been initialized must be removed
	by ctimerRem() later called by the _same_ task
	which had called ctimerInit(). This is because
	allowing another task would neccessarily force you
	to check whether ctimerRem() failed (I need a signal
	to be free) and that could cause trouble, anyhow.
	However, timer functions can be used from every task.

	In all routines, a timer will be identified by a
	string (like "my_prog_timer").
*/

extern __asm UBYTE ctimerInit(	register __a0 char *timername,
											register __d0 BYTE pri,
											register __d1 UBYTE delaySteps);

/*
	ctimerInit()
	------------

	J:	Setup a new timer process.

	I:	timername	-	ID name of timer. If left zero, TRET_BADINPUT will be
							returned.
		pri			-	Priority of timer process. I guess, 1 is a good choice.
		delaySteps	-	Every "timed" function expects a ULONG value indicating
							how many of "delaySteps" 1/50s it shall wait.
							Note that the timer process will do the following
							(if a job is sent to it; otherwise it will Wait(), of
							course):

								while(!quit)
								{
									if(job_to_check)
									{
										Delay(delaySteps);			// dos/Delay()

										checkJobs();
									}
									else
										Wait(until_Job_comes_or_Quit);
								}

							I recommend a value of CTIM_DEFDELAY (10) or something.
							TRET_BADINPUT will be returned if 0 is found.

	O:	TRET_OKAY				everything went all right ;-)
		TRET_BADINPUT			(see above)
		TRET_BADNAME			there's already a timer with the name "timername"
		TRET_OUTOFMEMORY		just guess
		TRET_NOSIGNAL			AllocSignal(-1) call failed
		TRET_NOPROCESS			CreateNewProc() failed
		TRET_NOCHILDCONFIG	failed to initialize child (AllocSignal(-1) failed)

	See also:	exec/InitSemaphore(), exec/AddSemaphore(), exec/AllocSignal(),
					exec/AllocVec(),  dos/CreateNewProc(), ctimer/ctimerRem()
*/

extern __asm UBYTE ctimerRem(register __a0 char *timername);

/*
	ctimerRem()
	-----------

	J:	Removes a previously ctimerInit()ialized timer.
		Note that only the _same_ task that called ctimerInit() is allowed
		to call that function (returns TRET_BADTASK otherwise).

	I:	timername	-	name of timer.

	O:	TRET_OKAY		allright.
		TRET_BADTIMER	can't find timer "timername"
		TRET_BADTASK	(see above)

	See also:	ctimer/ctimerInit()
*/

extern __asm UBYTE ctimerCancelAll(register __a2 char *timername,
											  register __d2 BOOL execute);

/*
	ctimerCancelAll()
	-----------------

	J:	Cancels all jobs currently set to the timer.

	I:	timername	-	name of timer
		execute		-	execute jobs when removing or not
							(see ctimerCancelSignal() and ctimerCancelPutMsg())

	O:	TRET_OKAY		allright
		TRET_BADTIMER	can't find timer "timername"

	See also:	ctimer/ctimerCancelSignal()
					ctimer/ctimerCancelPutMsg()
*/

// ----------------------------------
// functions2: timed events
// ----------------------------------

extern __asm UBYTE ctimerSignal(	register __a0 struct Task *task,
											register __d0 ULONG signals,
											register __a2 char *timername,
											register __d2 ULONG time);

extern __asm LONG ctimerCancelSignal(register __a0 struct Task *task,
											register __d0 ULONG signals,
											register __a2 char *timername,
											register __d2 BOOL set);

/*
	ctimerSignal()
	--------------

	J:	exec/Signal() with a timer delay.
		When the "time" passed by Signal(task,signals) will be executed.
		You can invoke/break this operation by using ctimerCancelSignal().

	I:	task			-	Task to signal. If left zero, the task having called
							ctimerSignal() will be signalled.
		signals		-	Signalmask to set. 0 will end in TRET_BADINPUT.
		timername	-	Name of timer.
		time			-	Time to wait in "delaySteps" (see ctimerInit()) units.
							0 will return TRET_BADINPUT.

	O:	TRET_OKAY			okay, job started.
		TRET_BADINPUT		(see above)
		TRET_BADTIMER		timer "timername" unknown.
		TRET_OUTOFMEMORY	;-)

	See also: exec/Signal(), exec/Wait(), ctimer/ctimerCancelSignal()



	ctimerCancelSignal()
	--------------------

	J:	Break a ctimerSignal() job.
		If the reasons why you wanted to delayed execute Signal() had
		changed,  you can remove the job from the timer using this operation.

	I:	task,signals,timername	-	MUST BE same as used when calling
											ctimerSignal()
		set							-	TRUE if you want to execute
											exec/Signal(task,signals), however
											(will only be done if the job is been
											found in the timer's job list.
											that means that if the job has been
											done while you were doing other things
											the signal is set for sure (-1 returned
											in that case)).

	O:	>=0:	job removed; time that already passed by.
		-1:	job not found (see notes above).
		-2:	"timername" time not found.

	See also:	ctimer/ctimerSignal()
*/

extern __asm UBYTE ctimerPutMsg(	register __a0 struct MsgPort *port,
											register __a1 struct Message *msg,
											register __a2 char *timername,
											register __d2 ULONG time);

extern __asm LONG ctimerCancelPutMsg(register __a0 struct MsgPort *port,
											register __a1 struct Message *msg,
											register __a2 char *timername,
											register __d2 BOOL send);

/*
	ctimerPutMsg()
	--------------

	J:	exec/PutMsg() with a timer delay.
		When the "time" passed by PutMsg(port,msg) will be executed.
		You can invoke/break this operation by using ctimerCancelPutMsg().

		Do not make assumptions about further services from ctimerPutMsg().
		The port and msg parameter are taken as pointers and nothing
		else than PutMsg() will be done with them.
		You have to free the memory for the msg by yourself etc !

	I:	port			-	port to put msg to (0 => TRET_BADINPUT).
		msg			-	msg to put to port. 0 will end in TRET_BADINPUT.
		timername	-	Name of timer.
		time			-	Time to wait in "delaySteps" (see ctimerInit()) units.
							0 will return TRET_BADINPUT.

	O:	TRET_OKAY			okay, job started.
		TRET_BADINPUT		(see above)
		TRET_BADTIMER		timer "timername" unknown.
		TRET_OUTOFMEMORY	;-)

	See also: exec/PutMsg(), exec/GetMsg(), exec/WaitPort(), ctimer/ctimerCancelPutMsg()



	ctimerCancelPutMsg()
	-------------------

	J:	Break a ctimerPutMsg() job.
		If the reasons why you wanted to delayed execute PutMsg() had
		changed,  you can remove the job from the timer using this operation.

	I:	port,msg,timername	-	MUST BE same as used when calling
										ctimerPutMsg()
		send						-	TRUE if you want to execute
										exec/PutMsg(port,msg), however
										(will only be done if the job is been
										found in the timer's job list.
										that means that if the job has been
										done while you were doing other things
										the msg is send for sure (-1 returned
										in that case)).

	O:	>=0:	job removed; time that already passed by.
		-1:	job not found (see notes above).
		-2:	"timername" time not found.

	See also:	ctimer/ctimerPutMsg()
*/

extern __asm LONG ctimerWait(	register __d0 ULONG *breakMask,
										register __a2 char *timername,
										register __d2 ULONG time);

/*
	ctimerWait()
	------------

	J:	This is a very simple routine which allows you to wait until
		the "time" passed by or any of the signals in "*breakMask"
		are received.
		This is a very nice function to implement abortable jobs.

	I:	breakMask	-	Ptr to ULONG.
							ctimerWait() will read the "breakMask" from
							that LONG. If one of these signals will be received,
							ctimerWait() aborts waiting.
							When returning (without error), the *breakMask
							will represent the signals that have been
							received by Wait().
							Only signals you requested will be shown.
		timername	-	Name of timer.
		time			-	Time to wait in "delaySteps" (see ctimerInit()) units.
							0 will return -1.

	O:	>0	:	Time that passed by. If >0 (and 0, possibly), check
				the contence of *breakMask where the signals that have
				been received are stored in.
		0	:	Time passed by completely (_no_ breakMask signal received).
		-1	:	Error (bad timer, bad time (=0), no free signal, etc).

	Example:

		You want to wait "time" time units but want to abort if CTRl-C or
		CTRL-D is been pressed (assuming there's a timer called
		"my_timer"):

		returns	0	:	time passed by
					1	:	ctrl-c
					2	:	ctrl-d
					-1	:	failure

		UBYTE WaitCtrlC(ULONG time)
		{
			LONG		sigs,i;

			sigs	=	SIGBREAKF_CTRL_C | SIGBREAKF_CTRL_D;	// dos/dos.h

			i = ctimerWait(&sigs,"my_timer",time);

			if(i < 0)
				return -1;

			if(sigs & SIGBREAKF_CTRL_C)
				return 1;
			if(sigs & SIGBREAKF_CTRL_D)
				return 2;

			return 0;
		}

	See also:	ctimer/ctimerSignal(), ctimer/ctimerCancelSignal(),
					exec/Wait(), exec/AllocSignal()
*/

#endif
