
/*
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	AmigaOS 3.x kernel backend
*/

#include "tek/type.h"
#include "tek/kn/exec.h"
#include "tek/kn/amiga/exec.h"

#include <string.h>
#include <exec/memory.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/timer.h>
#include <dos/dostags.h>

#ifdef __MORPHOS__
#include <emul/emulinterface.h>
#endif


#define SysBase *((struct ExecBase **) 4L)


/* 
**	MEMORY ALLOCATION
**
*/

TAPTR kn_alloc(TUINT size)
{
	TUINT *mem = AllocVec(size + 4, MEMF_ANY);
	if (mem)
	{
		*mem = size;
		return (TAPTR) (mem + 1);
	}
	return TNULL;
}


TAPTR kn_alloc0(TUINT size)
{
	TUINT *mem = AllocVec(size + 4, MEMF_ANY|MEMF_CLEAR);
	if (mem)
	{
		*mem = size;
		return (TAPTR) (mem + 1);
	}
	return TNULL;
}


TVOID kn_free(TAPTR mem)
{
	FreeVec(((ULONG *) mem) - 1);
}


TAPTR kn_realloc(TAPTR oldmem, TUINT newsize)
{
	TUINT *newmem = TNULL;

	if (newsize)
	{
		newmem = AllocVec((ULONG) (newsize + 4), MEMF_ANY|MEMF_PUBLIC);
	}

	if (oldmem)
	{
		if (newmem)
		{
			ULONG oldsize = *(((ULONG *) oldmem) - 1);
			*newmem = newsize;
			CopyMemQuick(oldmem, newmem+1, TMIN(oldsize, newsize));
		}
		FreeVec(((ULONG *) oldmem) - 1);
	}

	if (newmem)
	{
		return (TAPTR) (newmem + 1);
	}
	return TNULL;
}


TUINT kn_getsize(TAPTR mem)
{
	return (TUINT) *(((ULONG *) mem) - 1);
}



/* 
**	MEMORY MANIPULATION
**
*/

TVOID kn_memcopy(TAPTR from, TAPTR to, TUINT numbytes)
{
	CopyMem(from, to, (ULONG) numbytes);
}


TVOID kn_memcopy32(TAPTR from, TAPTR to, TUINT numbytes)
{
	CopyMemQuick(from, to, (ULONG) numbytes);
}


TVOID kn_memset(TAPTR dest, TUINT numbytes, TUINT8 fillval)
{
	memset(dest, (int) fillval, numbytes);
}


TVOID kn_memset32(TAPTR dest, TUINT numbytes, TUINT fillval)
{
	TUINT i, *m = dest;
	for (i = 0; i < numbytes >> 2; ++i)
	{
		*m++ = fillval;
	}
}



/* 
**	LOCK
**
*/

TBOOL kn_initlock(TKNOB *lock)
{
	if (sizeof(TKNOB) >= sizeof(struct SignalSemaphore))
	{
		kn_memset(lock, sizeof(struct SignalSemaphore), 0);
		InitSemaphore((struct SignalSemaphore *) lock);
		return TTRUE;
	}
	else
	{
		struct SignalSemaphore *sem = kn_alloc0(sizeof(struct SignalSemaphore));
		if (sem)
		{
			InitSemaphore(sem);
			*((struct SignalSemaphore **) lock) = sem;
			return TTRUE;
		}
	}

	dbkprintf(20,"*** TEKLIB kernel: could not create lock\n");
	return TFALSE;
}


TVOID kn_destroylock(TKNOB *lock)
{
	if (sizeof(TKNOB) < sizeof(struct SignalSemaphore))
	{
		kn_free(*((TAPTR *) lock));
	}
}


TVOID kn_lock(TKNOB *lock)
{
	if (sizeof(TKNOB) >= sizeof(struct SignalSemaphore))
	{
		ObtainSemaphore((struct SignalSemaphore *) lock);
	}
	else
	{
		ObtainSemaphore(*((struct SignalSemaphore **) lock));
	}
}


TVOID kn_unlock(TKNOB *lock)
{
	if (sizeof(TKNOB) >= sizeof(struct SignalSemaphore))
	{
		ReleaseSemaphore((struct SignalSemaphore *) lock);
	}
	else
	{
		ReleaseSemaphore(*((struct SignalSemaphore **) lock));
	}
}



/* 
**	TIMER
**
*/

struct amitimer
{
	struct MsgPort *msgport;
	struct timerequest *timereq;
	struct timeval tv;
};

TBOOL kn_inittimer(TKNOB *timer)
{
	if (sizeof(TKNOB) >= sizeof(struct amitimer))
	{
		struct amitimer *t = (struct amitimer *) timer;
		t->msgport = CreateMsgPort();
		if (t->msgport)
		{
			t->timereq = (struct timerequest *) CreateIORequest(t->msgport, sizeof(struct timerequest));
			if (t->timereq)
			{
				if (!OpenDevice("timer.device", UNIT_MICROHZ, (struct IORequest *) t->timereq, 0))
				{
					#define TimerBase (struct Device *) t->timereq->tr_node.io_Device
					ReadEClock((struct EClockVal *) &t->tv);
					#undef TimerBase
					return TTRUE;
				}
				DeleteIORequest(t->timereq);
			}
			DeleteMsgPort(t->msgport);
		}
	}
	else
	{
		struct amitimer *t = kn_alloc(sizeof(struct amitimer));
		if (t)
		{
			t->msgport = CreateMsgPort();
			if (t->msgport)
			{
				t->timereq = (struct timerequest *) CreateIORequest(t->msgport, sizeof(struct timerequest));
				if (t->timereq)
				{
					if (!OpenDevice("timer.device", UNIT_MICROHZ, (struct IORequest *) t->timereq, 0))
					{
						#define TimerBase (struct Device *) t->timereq->tr_node.io_Device
						ReadEClock((struct EClockVal *) &t->tv);
						#undef TimerBase
						*((struct amitimer **) timer) = t;
						return TTRUE;
					}
					DeleteIORequest(t->timereq);
				}
				DeleteMsgPort(t->msgport);
			}
			kn_free(t);
		}
	}

	dbkprintf(20,"*** TEKLIB kernel: could not create timer\n");
	return TFALSE;
}


TVOID kn_destroytimer(TKNOB *timer)
{
	if (sizeof(TKNOB) >= sizeof(struct amitimer))
	{
		struct amitimer *t = (struct amitimer *) timer;
		CloseDevice((struct IORequest *) t->timereq);
		DeleteIORequest(t->timereq);
		DeleteMsgPort(t->msgport);
	}
	else
	{
		struct amitimer *t = *((struct amitimer **) timer);
		CloseDevice((struct IORequest *) t->timereq);
		DeleteIORequest(t->timereq);
		DeleteMsgPort(t->msgport);
		kn_free(t);
	}
}


TVOID kn_querytimer(TKNOB *timer, TTIME *tektime)
{
	struct amitimer *t;
	float freq, sec;

	if (sizeof(TKNOB) >= sizeof(struct amitimer))
	{
		t = (struct amitimer *) timer;
	}
	else
	{
		t = *((struct amitimer **) timer);
	}
	
	#define TimerBase (struct Device *) t->timereq->tr_node.io_Device

	freq = ReadEClock((struct EClockVal *) tektime);

	if (tektime->usec < t->tv.tv_micro)
	{
		sec = (tektime->sec - t->tv.tv_secs - 1) * freq + (tektime->usec - t->tv.tv_micro) / freq;
	}
	else
	{
		sec = (tektime->sec - t->tv.tv_secs) * freq + (tektime->usec - t->tv.tv_micro) / freq;
	}
	
	tektime->sec = (TUINT) sec;
	tektime->usec = (sec - tektime->sec) * 1000000;

	#undef TimerBase
}


TVOID kn_timedelay(TKNOB *timer, TTIME *tektime)
{
	struct amitimer *t;
	if (sizeof(TKNOB) >= sizeof(struct amitimer))
	{
		t = (struct amitimer *) timer;
	}
	else
	{
		t = *((struct amitimer **) timer);
	}

	t->timereq->tr_node.io_Command = TR_ADDREQUEST;
	t->timereq->tr_time.tv_secs = tektime->sec;
	t->timereq->tr_time.tv_micro = tektime->usec;
				
	DoIO((struct IORequest *) t->timereq);
}


TVOID kn_resettimer(TKNOB *timer)
{
	struct amitimer *t;

	if (sizeof(TKNOB) >= sizeof(struct amitimer))
	{
		t = (struct amitimer *) timer;
	}
	else
	{
		t = *((struct amitimer **) timer);
	}
	
	#define TimerBase (struct Device *) t->timereq->tr_node.io_Device

	ReadEClock((struct EClockVal *) &t->tv);

	#undef TimerBase
}



/* 
**	EVENT
**
*/

TBOOL kn_initevent(TKNOB *event)
{
	if (sizeof(TKNOB) >= sizeof(struct amievent))
	{
		struct amievent *evt = (struct amievent *) event;
		evt->signal = AllocSignal(-1);
		if (evt->signal > -1)
		{
			evt->task = FindTask(NULL);
			return TTRUE;
		}
	}
	else
	{
		struct amievent *evt = kn_alloc(sizeof(struct amievent));
		if (evt)
		{
			evt->signal = AllocSignal(-1);
			if (evt->signal > -1)
			{
				evt->task = FindTask(NULL);
				*((struct amievent **) event) = evt;
				return TTRUE;
			}

			kn_free(evt);
		}
	}

	dbkprintf(20,"*** TEKLIB kernel: could not create event\n");
	return TFALSE;
}


TVOID kn_destroyevent(TKNOB *event)
{
	if (sizeof(TKNOB) >= sizeof(struct amievent))
	{
		FreeSignal((long)((struct amievent *) event)->signal);
	}
	else
	{
		FreeSignal((long)(*((struct amievent **) event))->signal);
		kn_free(*((TAPTR *) event));
	}
}


TVOID kn_doevent(TKNOB *event)
{
	struct amievent *evt;

	if (sizeof(TKNOB) >= sizeof(struct amievent))
	{
		evt = (struct amievent *) event;
	}
	else
	{
		evt = *((struct amievent **) event);
	}

	Signal(evt->task, 1L << evt->signal);
}


TVOID kn_waitevent(TKNOB *event)
{
	struct amievent *evt;

	if (sizeof(TKNOB) >= sizeof(struct amievent))
	{
		evt = (struct amievent *) event;
	}
	else
	{
		evt = *((struct amievent **) event);
	}

	Wait(1L << (evt->signal));
}


TBOOL kn_timedwaitevent(TKNOB *event, TKNOB *timer, TTIME *tektime)
{
	struct amievent *evt;
	struct amitimer *tim;
	TBOOL occured;

	if (sizeof(TKNOB) >= sizeof(struct amievent))
	{
		evt = (struct amievent *) event;
	}
	else
	{
		evt = *((struct amievent **) event);
	}

	if (sizeof(TKNOB) >= sizeof(struct amitimer))
	{
		tim = (struct amitimer *) timer;
	}
	else
	{
		tim = *((struct amitimer **) timer);
	}

	if (tektime)
	{
		tim->timereq->tr_node.io_Command = TR_ADDREQUEST;
		tim->timereq->tr_time.tv_secs = tektime->sec;
		tim->timereq->tr_time.tv_micro = tektime->usec;
					
		SendIO((struct IORequest *) tim->timereq);
	
		occured = Wait((1L << (evt->signal)) | (1L << tim->msgport->mp_SigBit)) & (1L << evt->signal);
	
		AbortIO((struct IORequest *) tim->timereq);
		WaitIO((struct IORequest *) tim->timereq);
		SetSignal(0, 1L << tim->msgport->mp_SigBit);
	}
	else
	{
		occured = SetSignal(0, 1 << evt->signal) & (1 << evt->signal);
	}

	return occured;
}



/* 
**	THREAD
**
*/

static void amithread_entry(void)
{
	struct Task *self = FindTask(NULL);
	struct MsgPort *childinitport = &((struct Process *) self)->pr_MsgPort;
	struct amithread *thread;

	dbkprintf(3,"*** TEKLIB kernel: entering child context\n");

	/*
	**	wait for the init data packet
	*/

	WaitPort(childinitport);
	thread = (struct amithread *) GetMsg(childinitport);
	if (!thread)
	{
		dbkprintf(40,"*** TEKLIB amithread_entry: ALERT - NO THREAD\n");
	}

	/* 
	**	self reference
	*/

	self->tc_UserData = thread;

	/*
	**	acknowledge init package
	*/
	
	ReplyMsg((struct Message *) thread);

	/* 
	**	additional initializations in child context
	*/

	thread->dosbase = (struct DosLibrary *) OpenLibrary("dos.library", 0);

	/*
	**	call user function
	*/
	
	(*thread->function)(thread->data);
}

#ifdef __MORPHOS__
struct EmulLibEntry amithread_GATE = { TRAP_LIBNR, 0, (void (*)(void))amithread_entry };
#endif

TBOOL kn_initbasecontext(TKNOB *thread, TAPTR selfdata)
{
	if (sizeof(TKNOB) >= sizeof(struct amithread))
	{
		struct amithread *t = (struct amithread *) thread;
		kn_memset(t, sizeof(struct amithread), 0);
		
		t->dosbase = (struct DosLibrary *) OpenLibrary("dos.library", 0);

		t->data = selfdata;
		(FindTask(NULL))->tc_UserData = t;

		return TTRUE;
	}
	else
	{
		struct amithread *t = kn_alloc0(sizeof(struct amithread));
		if (t)
		{
			t->dosbase = (struct DosLibrary *) OpenLibrary("dos.library", 0);

			t->data = selfdata;
			(FindTask(NULL))->tc_UserData = t;

			*((struct amithread **) thread) = t;

			return TTRUE;
		}	
	}	

	dbkprintf(20,"*** TEKLIB kernel: could not establish basecontext\n");
	return TFALSE;
}


TVOID kn_destroybasecontext(TKNOB *thread)
{
	if (sizeof(TKNOB) >= sizeof(struct amithread))
	{
		CloseLibrary(((struct amithread *) thread)->socketbase);
		CloseLibrary((struct Library *) ((struct amithread *) thread)->dosbase);
	}
	else
	{
		CloseLibrary((*((struct amithread **) thread))->socketbase);
		CloseLibrary((struct Library *) (*((struct amithread **) thread))->dosbase);
		kn_free(*((struct amithread **) thread));
	}
}

TBOOL kn_initthread(TKNOB *thread, TVOID (*function)(TAPTR task), TAPTR selfdata)
{
	TBOOL success = FALSE;

	if (sizeof(TKNOB) >= sizeof(struct amithread))
	{
		struct amithread *t = (struct amithread *) thread;
		kn_memset(t, sizeof(struct amithread), 0);

		t->initreplyport = CreateMsgPort();
		if (t->initreplyport)
		{
			struct amithread *self = (struct amithread *) FindTask(NULL)->tc_UserData;
			#define DOSBase self->dosbase
		
#ifdef __MORPHOS__
			t->childproc = CreateNewProcTags(NP_Entry, (ULONG) &amithread_GATE, TAG_DONE);
#else
			t->childproc = CreateNewProcTags(NP_Entry, (ULONG) amithread_entry, TAG_DONE);
#endif
			if (t->childproc)
			{
				t->message.mn_ReplyPort = t->initreplyport;
				t->message.mn_Length = sizeof(struct amithread);
				t->function = function;
				t->data = selfdata;

				/*
				**	put initial data packet to the thread
				*/
			
				PutMsg(&t->childproc->pr_MsgPort, (struct Message *) t);

				/*
				**	wait for confirmation
				*/
			
				WaitPort(t->initreplyport);
				GetMsg(t->initreplyport);

				success = TTRUE;
			}
			DeleteMsgPort(t->initreplyport);
			
			#undef DOSBase
		}
	}
	else
	{
		struct amithread *t = kn_alloc0(sizeof(struct amithread));
		if (t)
		{
			t->initreplyport = CreateMsgPort();
			if (t->initreplyport)
			{
				struct amithread *self = (struct amithread *) FindTask(NULL)->tc_UserData;
				#define DOSBase self->dosbase

#ifdef __MORPHOS__
				t->childproc = CreateNewProcTags(NP_Entry, (ULONG) &amithread_GATE, TAG_DONE);
#else
				t->childproc = CreateNewProcTags(NP_Entry, (ULONG) amithread_entry, TAG_DONE);
#endif
				if (t->childproc)
				{
					t->message.mn_ReplyPort = t->initreplyport;
					t->message.mn_Length = sizeof(struct amithread);
					t->function = function;
					t->data = selfdata;

					/*
					**	put initial data packet to the thread
					*/
				
					PutMsg(&t->childproc->pr_MsgPort, (struct Message *) t);

					/*
					**	wait for confirmation
					*/
				
					WaitPort(t->initreplyport);
					GetMsg(t->initreplyport);

					*((struct amithread **) thread) = t;

					success = TTRUE;
				}
				DeleteMsgPort(t->initreplyport);

				#undef DOSBase
			}
			
			if (!success)
			{
				kn_free(t);
			}
		}
	}

	if (!success)
	{
		dbkprintf(20,"*** TEKLIB kernel: could not create thread\n");
	}	
	return success;
}


TVOID kn_deinitthread(TKNOB *thread)
{
	if (sizeof(TKNOB) >= sizeof(struct amithread))
	{
		CloseLibrary((struct Library *) ((struct amithread *) thread)->dosbase);
		CloseLibrary(((struct amithread *) thread)->socketbase);
	}
	else
	{
		CloseLibrary((struct Library *) (*((struct amithread **) thread))->dosbase);
		CloseLibrary((*((struct amithread **) thread))->socketbase);
	}
}


TVOID kn_destroythread(TKNOB *thread)
{
	if (sizeof(TKNOB) < sizeof(struct amithread))
	{
		kn_free(*((struct amithread **) thread));
	}
}


TAPTR kn_findself(TVOID)
{
	return (TAPTR) ((struct amithread *) ((FindTask(NULL))->tc_UserData))->data;
}



TINT kn_getrandomseed(TKNOB *timer)
{
	struct amitimer *t;
	struct EClockVal time;

	if (sizeof(TKNOB) >= sizeof(struct amitimer))
	{
		t = (struct amitimer *) timer;
	}
	else
	{
		t = *((struct amitimer **) timer);
	}
	
	#define TimerBase (struct Device *) t->timereq->tr_node.io_Device

	ReadEClock(&time);

	#undef TimerBase
	
	return (TINT) time.ev_lo;
}



#undef SysBase

