/* cAmiga_ReliableTimerSignal.e 18-09-2012
	An OOP class which provides a simple way to be informed of a precisely repeating timer event.


Copyright (c) 2010,2011,2012 Christopher Steven Handley ( http://cshandley.co.uk/email )
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* The source code must not be modified after it has been translated or converted
away from the PortablE programming language.  For clarification, the intention
is that all development of the source code must be done using the PortablE
programming language (as defined by Christopher Steven Handley).

* Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/*
This was loosly based upon AmigaOS4-only C code published by kas1e@yandex.ru in the following Vague2 disk mag article:
http://x25zine.org/aos41peg2/05-perfect_animation.txt

This was AmigaOS4-only, due to calling conventions for the isr_cReliableTimerSignal() procedure (interrupt handler).
Adaption for AmigaOS3 based upon code provided by Trev (www.spookysoftware.com) on UtilityBase.com.
Adaption for MorphOS based upon code provided by Itix on UtilityBase.com.
Adaption for AROS based upon code provided by Salass00 (a500.org) on UtilityBase.com.
Adaption for AmigaE was only gotten working thanks to help from Damien Stewart & Daniel Westerberg via the AmigaE mailing list.

Subsequently improved using "timersoftint.c" from the RKM's & the AmigaOS(4) Wiki:
http://wiki.amigaos.net/index.php/Exec_Interrupts#Software_Interrupts

22-05-2012
Fixed a missing WaitIO() bug, which was present in Kas1e's article.  Also moved example usage into a separate _test module.

18-09-2012
Replaced WaitIO() with GetMsg(), and Cause() with SendIO(), as shown in the RKM & AmigaOS(4) Wiki.

(Possibly temporarily) Removed the init() & event() methods, since the "self"
object cannot legally be accessed from an interrupt on AmigaOS4.  This might be
solved when multi-core support is added to OS4, otherwise need to have a
high-priority "watcher" process that handles this.
*/

OPT NATIVE, POINTER, PREPROCESS
MODULE 'exec', 'timer'
MODULE 'amigalib/lists'

PRIVATE

#ifdef pe_TargetOS_MorphOS
{
	ULONG isr_cReliableTimerSignal(long context, long sysbase, void** is_Data /*APTR*/) ;
	
	static ULONG isr_proxy_cReliableTimerSignal(void) {
		APTR is_Data = (APTR) REG_A1;
		return isr_cReliableTimerSignal(0, 0, (void**) is_Data);
	}
	
	//static struct EmulLibEntry gate_cReliableTimerSignal = { //}
	const struct {
		UWORD Trap;
		UWORD pad;
		APTR  Func;
	} gate_cReliableTimerSignal = {
		TRAP_LIB,	//0xFF00
		0,
		(APTR) &isr_proxy_cReliableTimerSignal
	};
}
NATIVE {isr_proxy_cReliableTimerSignal} PROC
NATIVE {gate_cReliableTimerSignal} DEF
#endif

#ifdef pe_TargetOS_AROS
{
	ULONG isr_cReliableTimerSignal(long context, long sys  IF NIL=(code:=eCodeSoftInt({tsoftcode})) THEN Raise(ERR_ECODE)
  softint.code:=code  -> The software interrupt routine
S_UFHA(APTR, code, A5),
		AROS_UFHA(struct ExecBase*, sysbase, A6)
	) {
		AROS_USERFUNC_INIT
		isr_cReliableTimerSignal(0, (long) sysbase, (void**) is_Data);
		AROS_USERFUNC_EXIT
	}
}
NATIVE {isr_proxy_cReliableTimerSignal} PROC
#endif

->this may require compiling with the -fomit-frame-pointer GCC parameter.
#ifdef pe_TargetOS_AmigaOS3
#ifdef pe_TargetLang_CPP
{
	ULONG isr_cReliableTimerSignal(long context, long sysbase, void** is_Data /*APTR*/) ;
	
	int __saveds __interrupt isr_proxy_cReliableTimerSignal(void) {
		register void** is_Data __asm("a1");
		isr_cReliableTimerSignal(0, 0, is_Data);
		return 0;
	}
}
NATIVE {isr_proxy_cReliableTimerSignal} DEF

/* ->an incomplete adaptation based on code provided by Itix.
/*
	isr_proxy_cReliableTimerSignal:
	movem.l d0-d7/a0-a6, -(sp)
	move.l (a1)+,a0
	jsr (a0)
	movem.l (sp)+,d0-d7/a0-a6
	moveq #0,d0
	rts
*/
{
	static const UWORD isr_proxy_cReliableTimerSignal[] = { 0x48e7, 0xfffe, 0x2059, 0x4e90, 0x4cdf, 0x7fff, 0x7000, 0x4e75 };
}
NATIVE {isr_proxy_cReliableTimerSignal} DEF
*/
#endif
#endif

#ifdef pe_TargetOS_AmigaOS3
#ifdef pe_TargetLanguage_AmigaE
	{MODULE 'other/ecode'}
	
	PROC isr_proxy_cReliableTimerSignal(data:ARRAY OF PTR /*APTR*/)
		isr_cReliableTimerSignal(/*context*/ 0, /*sysbase*/ 0, data)
	ENDPROC
	
/* ->an alternative to the eCode module, provided by Damien Stewart
	PROC isr_proxy_cReliableTimerSignal(data:ARRAY OF PTR /*APTR*/)
		isr_cReliableTimerSignal(/*context*/ 0, /*sysbase*/ 0, data)
	ENDPROC
	
PROC storeA4()
	LEA     a4storage(PC),A0
	MOVE.L  A4,(A0)
	RETURN
a4storage:
	LONG  0
	
gate_cReliableTimerSignal:
	MOVEM.L D2-D7/A2-A4/A6,-(A7)
	
	->LEA     a4storage(PC),A0
	->MOVE.L  (A0),A4
	MOVE.L  a4storage(PC),A4
	
	MOVE.L  A1,-(A7)
	->LEA     isr_proxy_cReliableTimerSignal(PC),A0
	->JSR     (A0)
	BSR     isr_proxy_cReliableTimerSignal
	ADDQ.W  #4,A7
	MOVEM.L (A7)+,D2-D7/A2-A4/A6
	RTS
ENDPROC
NATIVE {a4storage} DEF
NATIVE {gate_cReliableTimerSignal} DEF
*/
#endif
#endif

PUBLIC

CLASS cReliableTimerSignal PRIVATE
	obj:PTR TO oReliableTimerSignal		->this is allocated using MEMF_PUBLIC, to ensure that it can be accessed by an interrupt (esp under AmigaOS4.1)
ENDCLASS

PRIVATE
OBJECT oReliableTimerSignal PRIVATE
	repeatPeriod
	task   :PTR TO tc	->our task
	signal :BYTE		->allocated signal for our task (not the interrupt!)
	
	softInt:PTR TO is	->allocated software interrupt
	port   :PTR TO mp	->allocated port for timerequest
	tr     :PTR TO timerequest	->allocated timerequest
	shutdown:BOOL		->tell interrupt when to quit (and also that it has quit)
	
#ifdef pe_TargetOS_AmigaOS3
#ifdef pe_TargetLang_CPP
	container[2]:ARRAY OF PTR
#endif
#endif
ENDOBJECT
PUBLIC

PROC new(periodInMicroSeconds=0) OF cReliableTimerSignal
	DEF obj:PTR TO oReliableTimerSignal
	
	->use check
	IF periodInMicroSeconds < 0 THEN Throw("EMU", 'cReliableTimerSignal.new(); periodInMicroSeconds<=0')
	
	->initialise object so end() does nothing
	self.obj := AllocVec(SIZEOF oReliableTimerSignal, MEMF_PUBLIC OR MEMF_CLEAR)
	IF self.obj = NIL THEN Throw("MEM", 'cReliableTimerSignal.new(); failed to allocate memory for object')
	
	obj := self.obj
	obj.repeatPeriod := 0
	obj.task    := NIL
	obj.signal  := -1
	obj.softInt := NIL
	obj.port    := NIL
	obj.tr      := NIL
	obj.shutdown := TRUE
	
	->prepare to receive an event signal
	obj.task := FindTask(NILA)
	obj.signal := AllocSignal(-1)
	IF obj.signal = -1 THEN Throw("RES", 'cReliableTimerSignal.new(); failed to allocate signal')
	
	->add our interrupt server to system server chain
	->OS4: obj.softInt := AllocSysObject(ASOT_INTERRUPT, [ASOINTR_Code,CALLBACK isr_cReliableTimerSignal(), ASOINTR_Data,self, TAG_END]:tagitem)	->and no need to fill-in it's members
	obj.softInt := AllocVec(SIZEOF is, MEMF_PUBLIC OR MEMF_CLEAR)
	IF obj.softInt = NIL THEN Throw("MEM", 'cReliableTimerSignal.new(); failed to allocate memory for interrupt')
	obj.softInt.ln.pri  := 0
	obj.softInt.ln.name := 'EPReliableTimerSignal'
	#ifdef pe_TargetOS_AmigaOS4
		obj.softInt.ln.type := NT_EXTINTERRUPT
		obj.softInt.code    := CALLBACK isr_cReliableTimerSignal()
		obj.softInt.data    := obj
	#endif
	#ifdef pe_TargetOS_MorphOS
		obj.softInt.ln.type := NT_INTERRUPT
		obj.softInt.code    := NATIVE {(void*) &gate_cReliableTimerSignal} ENDNATIVE !!PTR
		obj.softInt.data    := obj
	#endif
	#ifdef pe_TargetOS_AROS
		obj.softInt.ln.type := NT_INTERRUPT
		obj.softInt.code    := NATIVE {(void*) &isr_proxy_cReliableTimerSignal} ENDNATIVE !!PTR
		obj.softInt.data    := obj
	#endif
	#ifdef pe_TargetOS_AmigaOS3
	#ifdef pe_TargetLang_CPP
		obj.softInt.ln.type := NT_INTERRUPT
		obj.softInt.code    := NATIVE {(void*) &isr_proxy_cReliableTimerSignal} ENDNATIVE !!PTR
		obj.softInt.data    := obj.container
		
		obj.container[0] := CALLBACK isr_cReliableTimerSignal()
		obj.container[1] := obj
	#endif
	#ifdef pe_TargetLanguage_AmigaE
		obj.softInt.ln.type := NT_INTERRUPT
		obj.softInt.code    := {eCodeSoftInt({isr_proxy_cReliableTimerSignal})} !!PTR ; IF obj.softInt.code = NIL THEN Throw("RES", 'cReliableTimerSignal.new(); eCodeSoftInt() failed')
		obj.softInt.data    := obj
		
		/* ->an alternative to the eCode module, provided by Damien Stewart
		obj.softInt.ln.type := NT_INTERRUPT
		obj.softInt.code    := {({gate_cReliableTimerSignal})} !!PTR
		obj.softInt.data    := obj
		storeA4()
		*/
	#endif
	#endif
	
	->OS4: obj.port := AllocSysObject(ASOT_PORT, [ASOPORT_AllocSig,FALSE, ASOPORT_Action,PA_SOFTINT, ASOPORT_Target,obj.softInt, TAG_END]:tagitem)
	obj.port := AllocMem(SIZEOF mp, MEMF_PUBLIC OR MEMF_CLEAR)
	IF obj.port = NIL THEN Throw("MEM", 'cReliableTimerSignal.new(); failed to allocate port')
	
	obj.port.ln.type := NT_MSGPORT		->Set up the PA_SOFTINT message port
	obj.port.flags   := PA_SOFTINT		->(no need to make this port public)
	obj.port.sigtask := obj.softInt !!PTR		->pointer to interrupt structure
	newList(obj.port.msglist)
	
	->create the timer
	->OS4: obj.tr := AllocSysObject(ASOT_PORT, [ASOPORT_AllocSig,FALSE, ASOPORT_Action,PA_SOFTINT, ASOPORT_Target,obj.softInt, TAG_END]:tagitem)
	obj.tr := CreateIORequest(obj.port, SIZEOF timerequest) !!VALUE!!PTR
	IF obj.tr = NIL THEN Throw("MEM", 'cReliableTimerSignal.new(); failed to allocate IO request')
	
	IF OpenDevice('timer.device', UNIT_MICROHZ, obj.tr.io, 0) <> 0 THEN Throw("RES", 'cReliableTimerSignal.new(); failed to open timer.device')
	
	->optional user initialisation
	/*
	self.init()
	*/
	
	->start the timer, if requested
	IF periodInMicroSeconds <> 0 THEN self.start(periodInMicroSeconds)
ENDPROC

/*
PROC init() OF cReliableTimerSignal IS EMPTY
*/

PROC end() OF cReliableTimerSignal
	DEF obj:PTR TO oReliableTimerSignal
	obj := self.obj
	
	IF obj = NIL THEN RETURN
	
	->stop the timer (before the TimeRequest message & associated port are destroyed)
	IF obj.repeatPeriod <> 0 THEN self.halt()
	
	IF obj.signal <> -1 THEN FreeSignal(obj.signal) ; obj.signal := -1
	
	IF obj.tr
		CloseDevice(    obj.tr.io)
		DeleteIORequest(obj.tr.io) ; obj.tr := NIL		->OS4: FreeSysObject(ASOT_IOREQUEST, obj.tr.tr)
	ENDIF
	IF obj.softInt THEN FreeVec(obj.softInt) ; obj.softInt := NIL		->OS4: FreeSysObject(ASOT_INTERRUPT, obj.softInt)
	IF obj.port    THEN FreeMem(obj.port, SIZEOF mp) ; obj.port := NIL		->OS4: FreeSysObject(ASOT_PORT, obj.port)
	
	FreeVec(self.obj) ; self.obj := NIL ; obj := NIL
FINALLY
	SUPER self.end()
ENDPROC

PROC start(periodInMicroSeconds) OF cReliableTimerSignal
	DEF obj:PTR TO oReliableTimerSignal
	obj := self.obj
	
	->use check
	IF periodInMicroSeconds <= 0 THEN Throw("EMU", 'cReliableTimerSignal.start(); periodInMicroSeconds<=0')
	IF obj.repeatPeriod <> 0 THEN Throw("EMU", 'cReliableTimerSignal.start(); the timer was already started')
	
	->initialise object
	obj.repeatPeriod := periodInMicroSeconds
	
	->initialise the timer
	obj.tr.io.command := TR_ADDREQUEST						->Initial iorequest to start
	obj.tr.time.secs  := 0
	obj.tr.time.micro := obj.repeatPeriod !!LONG ->MICRO_DELAY	->software interrupt
	
	->initiate first interrupt
	obj.shutdown := FALSE
	SendIO(obj.tr.io)		->was: Cause(obj.softInt) wirh obj.first := TRUE
ENDPROC

PROC halt() OF cReliableTimerSignal
	DEF obj:PTR TO oReliableTimerSignal
	obj := self.obj
	
	IF obj.repeatPeriod = 0 THEN Throw("EMU", 'cReliableTimerSignal.halt(); the timer was not running')
	
	IF obj.shutdown = FALSE
		->(timer interrupt was started) so tell it to shutdown & wait for it to do so
		obj.shutdown := TRUE
		AbortIO(obj.tr.io)
		REPEAT
			Wait(1 SHL obj.signal)
		UNTIL obj.shutdown = FALSE
	ENDIF
	
	->mark the timer as no-longer running
	obj.repeatPeriod := 0
ENDPROC

PROC infoSignal() OF cReliableTimerSignal RETURNS signal IS 1 SHL self.obj.signal

->PROC infoSignalNum() OF cReliableTimerSignal RETURNS signal IS self.obj.signal

PROC infoRepeatPeriod() OF cReliableTimerSignal RETURNS microSeconds IS self.obj.repeatPeriod

PROC infoIsRunning() OF cReliableTimerSignal RETURNS isRunning:BOOL IS self.obj.repeatPeriod <> 0

/*
->this method is called every timer event, so sub-classes can easily do things on an event
->NOTE: This is called INSIDE an Interrupt Service Routine, and so has limitations upon what OS functions can be called, and also should finish in a short time.
->NOTE: And on AmigaOS4 it must not access memory allocated using E functions, only memory allocated using AllocVec() that is MEMF_PUBLIC or locked MEMF_SHARED.
PROC event() OF cReliableTimerSignal IS EMPTY
*/

PRIVATE
->the soft Interrupt Service Routine
PROC isr_cReliableTimerSignal(context/*:PTR TO exceptioncontext*/, sysbase/*:PTR TO execbase*/, is_Data:ARRAY OF PTR /*APTR*/) RETURNS ret:ULONG
	DEF obj:PTR TO oReliableTimerSignal, tr:PTR TO timerequest
	
	#ifdef pe_TargetOS_AmigaOS3
		#ifdef pe_TargetLang_CPP
			obj := is_Data[1]
		#endif
		#ifdef pe_TargetLanguage_AmigaE
			obj := is_Data !!ARRAY
		#endif
	#else
		obj := is_Data !!ARRAY
	#endif
	
	tr := GetMsg(obj.port) !!PTR	->remove timer message from our port
	/* was:
		IF CheckIO(obj.tr.io) THEN WaitIO(obj.tr.io)
		tr := obj.tr
	*/
	
	tr.io.command := TR_ADDREQUEST								->Initial iorequest to start
	tr.time.secs  := 0
	tr.time.micro := obj.repeatPeriod !!LONG	->MICRO_DELAY	->software interrupt
	
	
	IF obj.shutdown = FALSE
		->restart timer for next event
		SendIO(tr.io)
	ELSE
		->notify task that we have not generated another timer event (so it is safe to deallocate resources & quit)
		obj.shutdown := FALSE
	ENDIF
	
	->notify task of the timer event
	/*
	obj.self.event()
	*/
	Signal(obj.task, 1 SHL obj.signal)
	
	RETURN
	->dummy
	context := NIL ; sysbase := NIL
FINALLY
	->prevent trying to pass any exceptions out of the ISR
	exception := 0
	ret := 0
ENDPROC
PUBLIC
