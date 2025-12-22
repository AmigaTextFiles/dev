#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/utility.h>
#include <proto/feelin.h>

#include <libraries/feelin.h>

struct FeelinBase                  *FeelinBase;

#ifdef __amigaos4__
struct FeelinIFace                 *IFeelin;
#endif

struct in_Timeout
{
	struct Node						node;
	struct Hook					   *callback;
	uint32                          seconds;
	uint32                          micros;
	struct timerequest              request;
};

#define NEWLIST(_l)                                     \
{                                                       \
	struct List *__aros_list_tmp = (struct List *)(_l), \
				*l = __aros_list_tmp;                   \
														\
	l->lh_TailPred = (struct Node *)l;                  \
	l->lh_Tail     = 0;                                 \
	l->lh_Head     = (struct Node *)&l->lh_Tail;        \
}

struct SignalSemaphore _timer_arbiter;
struct MsgPort *_timer_port;
struct timerequest *_timer_request;
struct MinList _timer_list;

///f_create_timer
bool32 f_create_timer()
{
	_timer_request = NULL;

	NEWLIST((struct List *) &(_timer_list));

	_timer_port = IEXEC CreateMsgPort();

	if (!_timer_port)
	{
		IFEELIN F_Log(FV_LOG_USER,"Unable to create Timers' message port");

		return FALSE;
	}

	_timer_request = IEXEC CreateIORequest(_timer_port, sizeof (struct timerequest));

	if (!_timer_request)
	{
		IFEELIN F_Log(FV_LOG_USER,"Unable to create IORequest for timer.device");

		return FALSE;
	}

	if (IEXEC OpenDevice("timer.device",UNIT_VBLANK,(struct IORequest *) _timer_request,NULL))
	{
		IFEELIN F_Log(FV_LOG_USER, "Unable to open timer.device");

		return FALSE;
	}

	return TRUE;
}
//+
///f_delete_timer
void f_delete_timer()
{
	Forbid();

	if (_timer_request)
	{
		IEXEC CloseDevice((struct IORequest *) _timer_request);

		IEXEC DeleteIORequest(_timer_request);

		_timer_request = NULL;
	}

	if (_timer_port)
	{
		struct Message *msg;

		while ((msg = IEXEC GetMsg(_timer_port)) != NULL)
		{
			IDOS_ Printf("trim message 0x%08lx\n", (int32) msg);

			IEXEC ReplyMsg(msg);
		}

		IEXEC DeleteMsgPort(_timer_port);

		_timer_port = NULL;
	}

	Permit();
}
//+

///f_timeout_set
struct in_Timeout * f_timeout_set(struct Hook *Callback, uint32 Millis)
{
	struct in_Timeout *h = IFEELIN F_New(sizeof (struct in_Timeout));

	if (h)
	{
		h->callback = Callback;
		h->seconds = Millis / 1000;
		h->micros = (Millis % 1000) * 1000;

		IEXEC CopyMem(_timer_request, &h->request, sizeof (struct timerequest));

		h->request.tr_node.io_Command = TR_ADDREQUEST;
		h->request.tr_time.tv_secs  = h->seconds;
		h->request.tr_time.tv_micro = h->micros;

		IEXEC ObtainSemaphore(&_timer_arbiter);
		IEXEC AddTail((struct List *) &_timer_list, &h->node);
		IEXEC ReleaseSemaphore(&_timer_arbiter);

		IEXEC SendIO((struct IORequest *) &h->request);

		return h;
	}
	else
	{
		IFEELIN F_Log(FV_LOG_USER, "unable to allocate timer handler");
	}

	return NULL;
}
//+
///f_timeout_clear
void f_timeout_clear(struct in_Timeout *Handle)
{
	struct IORequest *req = (struct IORequest *) &Handle->request;

	IEXEC ObtainSemaphore(&_timer_arbiter);

	if (IEXEC CheckIO(req) == NULL)
	{
	   IEXEC AbortIO(req);
	}

	IEXEC WaitIO(req);

	IEXEC Remove(&Handle->node);

	IFEELIN F_Dispose(Handle);

	IEXEC ReleaseSemaphore(&_timer_arbiter);
}
//+

///f_timer_thread
uint32 f_timer_thread()
{
	bool32 again = TRUE;

	for (;;)
	{
		bits32 sig = 0;

		if (!again)
		{
			IDOS_ Printf("Wait 0x%08lx\n", SIGBREAKF_CTRL_C | (1 << _timer_port->mp_SigBit));

			sig = IEXEC Wait(SIGBREAKF_CTRL_C | (1 << _timer_port->mp_SigBit));

			IDOS_ Printf("Signal 0x%08lx\n", sig);
		}

		again = FALSE;

		if (sig & SIGBREAKF_CTRL_C)
		{
			break;
		}
		else if (sig & (1 << _timer_port->mp_SigBit))
		{
			struct timerequest *req = (struct timerequest *) IEXEC GetMsg(_timer_port);

			if (req)
			{
				struct in_Timeout *h = (struct in_Timeout *) (((uint32)(req)) - sizeof (struct in_Timeout) + sizeof (struct timerequest));

				IDOS_ Printf("Message 0x%08lx - Handle 0x%08lx\n", (int32) req, (int32) h);
				
				req->tr_node.io_Command = TR_ADDREQUEST;
				req->tr_time.tv_secs    = h->seconds;
				req->tr_time.tv_micro   = h->micros;

				IUTILITY CallHookPkt(h->callback, NULL, NULL);
				
				IEXEC SendIO((struct IORequest *) req);
			
				again = TRUE;
			}
		}
	}

	return 0;
}
//+

F_HOOK(uint32, myhook)
{
	IDOS_ Printf("Hello !!\n");

	return 0;
}

///Main
int main()
{
	if (F_FEELIN_OPEN)
	{
		IEXEC InitSemaphore(&_timer_arbiter);

		if (f_create_timer())
		{
			struct in_Timeout *to;
			struct Hook callback;

			callback.h_Entry = (HOOKFUNC) myhook;
			callback.h_Data = NULL;

			IDOS_ Printf("timer created\n");

			to = f_timeout_set(&callback, 1000);

			if (to)
			{
				IDOS_ Printf("timeout set 0x%08lx, quit with Ctrl-C\n", (int32) to);

				f_timer_thread();

				f_timeout_clear(to);
				
				IDOS_ Printf("timeout cleared\n");
			}

			f_delete_timer();

			IDOS_ Printf("timer deleted\n");
		}

		F_FEELIN_CLOSE;
	}
	else
	{
		IDOS_ Printf("Unable to open feelin.library v%ld.\n", FV_FEELIN_VERSION);
	}
	
	return 0;
}
//+
