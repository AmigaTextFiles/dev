/* ********* */
/* threads.e */
/* ********* */



/*
    WBBump - Bumpmapping on the Workbench!

    Copyright (C) 1999  Thomas Jensen - dm98411@edb.tietgen.dk

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software Foundation,
    Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/


/*
	Needs utility.library to be opened
*/


OPT MODULE


MODULE	'dos/dos',
		'dos/dostags',
		'dos/dosextens',

		'exec/ports',
		'exec/nodes',
		'exec/memory',
		'exec/tasks',

		'amigalib/ports',

		'utility',
		'utility/tagitem',

		'other/a4',

		'*errors'


EXPORT ENUM	TSTAT_RUNNING,
			TSTAT_DEAD

EXPORT OBJECT thread
	process		:	PTR TO process
	status		:	LONG
	myport		:	PTR TO mp
	threadport	:	PTR TO mp
	startjob	:	PTR TO job
ENDOBJECT


EXPORT ENUM	TCMD_STARTUPMSG

EXPORT CONST	TCMD_USER=$80000000

ENUM	JSTAT_SEND,
		JSTAT_WORKING,
		JSTAT_ABORTED,
		JSTAT_DONE


EXPORT ENUM	TTAG_CREATE_APENDNAME = TAG_USER,
			TTAG_CREATE_PRIORITY,
			TTAG_CREATE_RELATIVEPRI

EXPORT OBJECT job OF mn
	command	:	LONG		-> TCMD_xxx
	input	:	PTR TO LONG
	result	:	LONG
	status	:	LONG
ENDOBJECT




PROC create(codeptr, name, tags=NIL:PTR TO tagitem) OF thread HANDLE
	DEF	me=NIL:PTR TO process,
		apendname=FALSE,
		priority,
		threadname=NIL

	seta4()

	self.status := TSTAT_DEAD

	me := FindTask(NIL)

	self.myport := createPort(NIL, 0)
	IF self.myport = NIL THEN Raise(ERR_CREATEPORT)


	IF tags
		apendname := GetTagData(TTAG_CREATE_APENDNAME, FALSE, tags)
		priority := GetTagData(TTAG_CREATE_PRIORITY, me.task.ln.pri, tags)
		priority := priority + GetTagData(TTAG_CREATE_RELATIVEPRI, 0, tags)
	ENDIF


	IF apendname
		threadname := String(StrLen(me.task.ln.name) + StrLen(name) + 10)
		StringF(threadname, '\s - \s', me.task.ln.name, name)
	ELSE
		threadname := name
	ENDIF

	self.process := CreateNewProc([
		NP_ENTRY,		{thread_main},
		NP_NAME,		threadname,
		NP_PRIORITY,	priority,
		NIL])
	IF self.process = NIL THEN eThrow(ERR_THREAD, 'Unable to create thread: "%s"', [threadname])

	self.status := TSTAT_RUNNING

	self.threadport := self.process.msgport

	self.startjob := self.sendjob(TCMD_STARTUPMSG, [self.myport, codeptr, self])

	self.threadport := self.waitjob(self.startjob)

EXCEPT DO
	IF exception THEN self.end()
	ReThrow()
ENDPROC



PROC end() OF thread
	self.break()
	WHILE self.status = TSTAT_RUNNING
		self.break()
		Delay(10)
	ENDWHILE
ENDPROC



PROC sendjob(cmd, input) OF thread HANDLE
	DEF	job=NIL:PTR TO job

	NEW job  -> := NewM(SIZEOF job, MEMF_CLEAR)
	job.replyport := self.myport
	job.length := SIZEOF job

	job.status := JSTAT_SEND

	job.command := cmd
	job.input := input
	PutMsg(self.threadport, job)

->	WriteF('Send job: adr = $\z\h[8]\n', job)

EXCEPT DO
	ReThrow()
ENDPROC job



PROC waitjob(job:PTR TO job) OF thread HANDLE
	DEF	injob=NIL:PTR TO job,
		status=0,
		res=0

->	WriteF('Waiting for job $\z\h[8] to finish\n', job)

	WHILE (job.status <> JSTAT_DONE) AND (job.status <> JSTAT_ABORTED)

		Wait(Shl(1, self.myport.sigbit))

		WHILE (injob := GetMsg(self.myport))
			injob.status := JSTAT_DONE
->			WriteF('Got job reply, adr = $\z\h[8]\n', injob)
		ENDWHILE
	ENDWHILE

	res := job.result
	status := job.status

	END job

EXCEPT DO
	ReThrow()
ENDPROC res, status



PROC break() OF thread
	IF self.status = TSTAT_RUNNING
		Signal(self.process, SIGBREAKF_CTRL_C)
	ENDIF
ENDPROC



PROC thread_main()
	DEF	me=NIL:PTR TO process,
		myport=NIL:PTR TO mp,
		masterport=NIL:PTR TO mp,
		startmsg=NIL:PTR TO job,
		job=NIL:PTR TO job,
		thread=NIL:PTR TO thread,
		codeptr=NIL,
		quit=FALSE,
		sigs=0

	geta4()

	me := FindTask(NIL)



	/* get startup msg */
	WaitPort(me.msgport)
	startmsg := GetMsg(me.msgport)
	startmsg.status := JSTAT_WORKING
	masterport := startmsg.input[0]
	codeptr := startmsg.input[1]
	thread := startmsg.input[2]

	myport := createPort(NIL, 0)

	startmsg.result := myport

	ReplyMsg(startmsg)


	WHILE quit=FALSE
		sigs := Wait(SIGBREAKF_CTRL_C OR Shl(1, myport.sigbit))
		IF (sigs AND SIGBREAKF_CTRL_C) THEN quit := TRUE

		WHILE (job := GetMsg(myport))
			job.status := JSTAT_WORKING
			job.result := codeptr(thread, job)
			ReplyMsg(job)
		ENDWHILE
	ENDWHILE

	WHILE (job := GetMsg(myport))
		job.status := JSTAT_ABORTED
		ReplyMsg(job)
	ENDWHILE

	thread.status := TSTAT_DEAD
ENDPROC


