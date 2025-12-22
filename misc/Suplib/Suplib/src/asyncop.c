
/*
 *  ASYNCOP.C
 */

#include <local/typedefs.h>

#define ASYMSG	struct _ASYMSG
#define ASYHAN	struct _ASYHAN

ASYMSG {
    MSG msg;
    void (*func)();
    long arg1;
    long arg2;
    long arg3;
};

ASYHAN {
    PORT *rport;    /*	Reply Port	*/
    PORT *port;     /*	Send Port	*/
    long acount;    /*	Messages Sent	*/
    long ccount;    /*	Messages Replied*/
    long a4,a5;     /*	A4 and A5	*/
};

void asyhandler();

void *
NewAsyncOp()
{
    register TASK *task;
    register TASK *mytask = FindTask(NULL);
    register ASYHAN *as = AllocMem(sizeof(ASYHAN), MEMF_CLEAR|MEMF_PUBLIC);

    as->rport = CreatePort(NULL, 0);
    PutA4A5(&as->a4);
    task = CreateTask("async.task", (ubyte)(mytask->tc_Node.ln_Pri + 1), (APTR)asyhandler, 4096);
    task->tc_UserData = (APTR)as;

    Signal(task, SIGBREAKF_CTRL_F);
    Wait(1 << as->rport->mp_SigBit);

    return((void *)as);
}

void
StartAsyncOp(_as, func, arg1, arg2, arg3)
void *_as;
void (*func)();
int arg1, arg2, arg3;
{
    ASYHAN *as = (ASYHAN *)_as;
    ASYMSG *am = (ASYMSG *)GetMsg(as->rport);    /*  Free Msg List   */

    if (!am) {
	am = AllocMem(sizeof(ASYMSG), MEMF_PUBLIC|MEMF_CLEAR);
	am->msg.mn_ReplyPort = as->rport;
    }
    am->func = func;
    am->arg1 = arg1;
    am->arg2 = arg2;
    am->arg3 = arg3;
    ++as->acount;
    PutMsg(as->port, (MSG *)am);
}

int
CheckAsyncOp(_as, n)
void *_as;
long n;
{
    ASYHAN *as = (ASYHAN *)_as;
    if (n > as->acount)
	n = as->acount;
    return(n <= as->ccount);
}

/*
 *  acount = #messages sent
 *  ccount = #messages replied
 */

void
WaitAsyncOp(_as, n)
void *_as;
long n;
{
    ASYHAN *as = (ASYHAN *)_as;
    if (n > as->acount)
	n = as->acount;
    while (n > as->ccount)
	Wait(1 << as->rport->mp_SigBit);
    Forbid();
    as->ccount -= n;
    Permit();
    as->acount -= n;
}

void
CloseAsyncOp(_as)
void *_as;
{
    ASYHAN *as = (ASYHAN *)_as;
    ASYMSG EndMsg;
    ASYMSG *am;

    WaitAsyncOp(as, -1);                /*  Wait for all operations to complete */
    while (am = (ASYMSG *)GetMsg(as->rport))      /*  Free any messages   */
	FreeMem(am, sizeof(ASYMSG));
    EndMsg.func = NULL;
    EndMsg.msg.mn_ReplyPort = as->rport;
    PutMsg(as->port, (MSG *)&EndMsg);
    WaitPort(as->rport);
    (void)GetMsg(as->rport);
    DeletePort(as->rport);
    FreeMem(as, sizeof(*as));
}

static
void
asyhandler()
{
    register ASYHAN *as;
    register ASYMSG *am;

    Wait(SIGBREAKF_CTRL_F);
    as = (ASYHAN *)FindTask(NULL)->tc_UserData;
    as->port = CreatePort(NULL, 0);
    Signal(as->rport->mp_SigTask, 1 << as->rport->mp_SigBit);
    for (;;) {
	WaitPort(as->port);
	am = (ASYMSG *)GetMsg(as->port);
	if (!am->func)
	    break;
	CallAMFunc(&as->a4, &am->func);
	++as->ccount;
	ReplyMsg((MSG *)am);
    }
    DeletePort(as->port);
    as->port = NULL;
    Forbid();
    ReplyMsg((MSG *)am);
}


