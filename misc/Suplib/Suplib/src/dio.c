
/*
 *  DIO.C
 *
 *  (C)Copyright 1987 by Matthew Dillon, All rights reserved
 *  Freely distributable.  Donations Welcome.  This is NOT shareware,
 *  This is NOT public domain.
 *
 *	Matthew Dillon
 *	891 Regal Rd.
 *	Berkeley, Ca. 94708
 *
 *  EXEC device driver IO support routines... makes everything easy.
 *
 *  dfd = dio_open(name, unit, flags, req/NULL)
 *
 *	open an IO device.  Note: in some cases you might have to provide
 *	a request structure with some fields initialized (example, the
 *	console device requires certain fields to be initialized).  For
 *	instance, if openning the SERIAL.DEVICE, you would want to give
 *	an IOExtSer structure which is completely blank execept for the
 *	io_SerFlags field.
 *
 *	The request structure's message and reply ports need not be
 *	initialized.  The request structure is no longer needed after
 *	the dio_open().
 *
 *	NULL = error, else descriptor (a pointer) returned.
 *
 *
 *  dio_close(dfd)
 *
 *	close an IO device.  Any pending asyncronous requests are
 *	AbortIO()'d and then Wait'ed on for completion.
 *
 *
 *  dio_closegrp(dfd)
 *
 *	close EVERY DIO DESCRIPTOR ASSOCIATED WITH THE dio_open() call
 *	that was the parent for this descriptor.  That is, you can get
 *	a descriptor using dio_open(), dio_dup() it a couple of times,
 *	then use dio_closegrp() on any ONE of the resulting descriptors
 *	to close ALL of them.
 *
 *
 *  dio_ddl(dfd,bool)
 *
 *	Disable BUF and LEN fields in dio_ctl[_to].. dummy parameters
 *	must still be passed, but they are not loaded into the io_Data
 *	and io_Length fields of the io request.  This is for devices
 *	like the AUDIO.DEVICE which has io_Data/io_Length in non-standard
 *	places.
 *
 *  dio_cact(dfd,bool)
 *
 *	If an error occurs (io_Error field), the io_Actual field is usually
 *	not modified by the device driver, and thus contains garbage.  To
 *	provide a cleaner interface, you can have DIO_CTL() and DIO_CTL_TO()
 *	calls automatically pre-clear this field so if an io_Error does
 *	occur, the field is a definate 0 instead of garbage.
 *
 *	In most cases you will want to do this.  An exception is the
 *	TIMER.DEVICE, which uses the io_Actual field for part of the
 *	timeout structure.
 *
 *	This flags the particular dio descriptor to do the pre-clear, and
 *	any new descriptors obtained by DIO_DUP()ing this one will also
 *	have the pre-clear flag set.
 *
 *
 *  dio_dup(dfd)
 *
 *	Returns a new channel descriptor referencing the same device.
 *	The new descriptor has it's own signal and IO request structure.
 *	For instance, if you openned the serial device, you might want
 *	to dup the descriptor so you can use one channel to pend an
 *	asyncronous read, and the other channel to write out to the device
 *	and do other things without disturbing the asyncronous read.
 *
 *
 *  sig = dio_signal(dfd)
 *
 *	get the signal number (0..31) used for a DIO descriptor.
 *	This allows you to Wait() for asyncronous requests.  Note that
 *	if your Wait() returns, you should double check using dio_isdone()
 *
 *	  dio_flags(dfd, or, ~and)
 *
 *	Modify the io_Flags field in the request, ORing it with the OR
 *	mask, and ANDing it with ~AND mask.  E.G., the AUDIO.DEVICE requires
 *	some flags be put in io_Flags.
 *
 *  req = dio_ctl_to(dfd, command, buf, len, to)
 *
 *	Same as DIO_CTL() below, but (A) is always syncronous, and
 *	(B) will attempt to AbortIO()+WaitIO() the request if the
 *	timeout occurs before the IO completes.
 *
 *	the 'to' argument is in microseconds.
 *
 *	If timeout occurs before request completes, and DIO aborts the
 *	request, some devices do not have the io_Actual field set
 *	properly.
 *
 *  req = dio_ctl(dfd, command, buf, len)
 *
 *	DIO_CTL() is the basis for the entire library.  It works as follows:
 *
 *	(1) If the channel isn't clear (there is an asyncronous IO request
 *	    still pending), DIO_CTL() waits for it to complete
 *
 *	(2) If the command is 0, simply return a pointer to the io
 *	    request structure.
 *
 *	(3) If the DIO_CACT() flag is TRUE, the io_Actual field of the
 *	    request is cleared.
 *
 *	(4) Set the io_Data field to 'buf', and io_Length field to 'len'
 *	    If the command is positive, use DoIO().  If the command
 *	    negative, take it's absolute value and then do a SendIO().
 *	    (The command is placed in the io_Command field, of course).
 *
 *	(5) return the IO request structure
 *
 *
 *  bool= dio_isdone(dfd)
 *
 *	return 1 if current channel is clear (done processing), else 0.
 *	e.g. if you did, say, an asyncronous read, and dio_isdone() returns
 *	true, you can now use the data buffer returned and look at the
 *	io_Actual field.
 *
 *	You need not do a dio_wait() after dio_isdone() returns 1.
 *
 *
 *  req = dio_wait(dfd)
 *
 *	Wait on the current channel for the request to complete and
 *	then return the request structure. (nop if channel is clear)
 *
 *
 *  req = dio_abort(dfd)
 *
 *	Abort the request on the current channel (nop if channel is
 *	clear).  Sends an AbortIO() if the channel is active and then
 *	WaitIO()'s the request.
 *
 *
 *  MACROS: SEE DIO.H
 *
 */

#include <local/typedefs.h>
#include <local/xmisc.h>

#define MPC	    (MEMF_CLEAR|MEMF_PUBLIC)
#define CPORT	    ior.ior.io_Message.mn_ReplyPort
#define MAXREQSIZE  128     /* big enough to hold all Amiga iorequests */

typedef struct IORequest IOR;
typedef struct IOStdReq  STD;

typedef struct {
    STD ior;
    char filler[MAXREQSIZE-sizeof(STD)];
} MAXIOR;

typedef struct {
    struct _CHAN *list;
    short refs;
} DIO;

typedef struct _CHAN {
    MAXIOR  ior;
    DIO     *base;
    XLIST   link;	/* doubly linked list */
    STD     timer;
    char    notclear;
    char    cact;	/* automatic io_Actual field clear  */
    char    ddl;
    UBYTE   flagmask;
} CHAN;

void *
dio_open(name, unit, flags, _req)
char *name;
long unit, flags;
void *_req;
{
    MAXIOR *req = _req;
    register CHAN *chan;
    register DIO *dio;

    dio = (DIO *)AllocMem(sizeof(DIO), MPC);    if (!dio)   goto fail3;
    chan= (CHAN *)AllocMem(sizeof(CHAN), MPC);  if (!chan)   goto fail2;
    if (req)
	chan->ior = *req;
    chan->CPORT = CreatePort(NULL,0);           if (!chan->CPORT) goto fail1;
    chan->ior.ior.io_Message.mn_Node.ln_Type = NT_MESSAGE;
    chan->base = dio;
    chan->flagmask = 0xF0;
    dio->refs = 1;
    if (OpenDevice(name, unit, (IOSTD *)&chan->ior, flags)) {
	DeletePort(chan->CPORT);
fail1:	FreeMem(chan, sizeof(CHAN));
fail2:	FreeMem(dio, sizeof(DIO));
fail3:	return(NULL);
    }
    llink((XLIST **)&dio->list, &chan->link);
    chan->ior.ior.io_Flags = 0;
    return((void *)chan);
}

void
dio_dfm(_chan,mask)
void *_chan;
long mask;
{
    CHAN *chan = _chan;
    chan->flagmask = mask;
}

void
dio_ddl(_chan,n)
void *_chan;
long n;
{
    CHAN *chan = _chan;
    chan->ddl = n;
}

void
dio_cact(_chan,n)
void *_chan;
long n;
{
    CHAN *chan = _chan;
    chan->cact = n;
}

void
dio_close(_chan)
void *_chan;
{
    CHAN *chan = _chan;
    dio_abort(chan);
    lunlink(&chan->link);
    if (--chan->base->refs == 0) {
	FreeMem(chan->base, sizeof(DIO));
	CloseDevice((IOSTD *)&chan->ior);
    }
    if (chan->timer.io_Message.mn_ReplyPort)
	CloseDevice((IOSTD *)&chan->timer);
    DeletePort(chan->CPORT);
    FreeMem(chan, sizeof(CHAN));
}

void
dio_closegroup(_chan)
void *_chan;
{
    CHAN *chan = _chan;
    register CHAN *nextc;

    for (chan = chan->base->list; chan; chan = nextc) {
	chan = (CHAN *)((char *)chan - ((char *)&chan->link - (char *)chan));
	nextc = (CHAN *)chan->link.next;
	dio_close(chan);
    }
}

void *
dio_dup(_chan)
void *_chan;
{
    CHAN *chan = _chan;
    CHAN *nc;

    if (chan) {
	nc = (CHAN *)AllocMem(sizeof(CHAN), MPC);   if (!nc) goto fail2;
	nc->ior = chan->ior;
	nc->base = chan->base;
	nc->CPORT = CreatePort(NULL,0);         if (!nc->CPORT) goto fail1;
	nc->ior.ior.io_Flags = NULL;
	nc->cact = chan->cact;
	nc->ddl = chan->ddl;
	nc->flagmask = chan->flagmask;
	++nc->base->refs;
	llink((XLIST **)&nc->base->list, &nc->link);
	return((void *)nc);
fail1:	FreeMem(nc, sizeof(CHAN));
    }
fail2:
    return(NULL);
}

int
dio_signal(_chan)
void *_chan;
{
    CHAN *chan = _chan;
    return((int)chan->CPORT->mp_SigBit);
}

void
dio_flags(_chan,or,and)
void *_chan;
long or;
long and;
{
    CHAN *chan = _chan;
    IOR *ior = (void *)chan;

    ior->io_Flags = (ior->io_Flags | or) & ~and;
}


void *
dio_ctl_to(_chan, com, buf, len, to)
void *_chan;
long com;
char *buf;
long len, to;
{
    CHAN *chan = _chan;
    register long mask;

    if (chan->timer.io_Message.mn_ReplyPort == NULL) {
	chan->timer.io_Message.mn_ReplyPort = chan->CPORT;
	chan->timer.io_Message.mn_Node.ln_Type = NT_MESSAGE;
	if (OpenDevice("timer.device", UNIT_VBLANK, &chan->timer, 0))
	    Alert((long)0x44494F20,(char *)1);
	chan->timer.io_Command = TR_ADDREQUEST;
    }
    mask = 1 << chan->CPORT->mp_SigBit;
    dio_ctl(chan, (com>0)?-com:com, buf, len);  /* SendIO the request */
    chan->timer.io_Actual = to / 1000000;
    chan->timer.io_Length = to % 1000000;	/* setup timer	      */
    chan->timer.io_Flags = 0;
    BeginIO(&chan->timer);          /* start timer running  */
    while (Wait(mask)) {            /* Wait for something   */
	if (CheckIO((IOSTD *)chan))          /* request done         */
	    break;
	if (CheckIO((IOSTD *)&chan->timer)) {    /* timeout?           */
	    dio_abort(chan);
	    break;
	}
    }
    AbortIO((IOSTD *)&chan->timer);          /*  kill the timer  */
    WaitIO((IOSTD *)&chan->timer);           /*  remove from rp  */
    return((void *)chan);           /*  return ior  */
}


void *
dio_ctl(_chan, com, buf, len)
void *_chan;
long com;
char *buf;
long len;
{
    CHAN *chan = _chan;

    if (chan->notclear) {   /* wait previous req to finish */
	WaitIO((IOSTD *)chan);
	chan->notclear = 0;
    }
    if (com) {
	if (chan->cact)
	    chan->ior.ior.io_Actual = 0;    /* initialize io_Actual to 0*/
	chan->ior.ior.io_Error = 0;	    /* initialize error to 0 */
	if (!chan->ddl) {
	    chan->ior.ior.io_Data = (APTR)buf;  /* buffer   */
	    chan->ior.ior.io_Length = len;	/* length   */
	}
	if (com < 0) {                      /* asyncronous IO  */
	    chan->ior.ior.io_Command = -com;
	    chan->notclear = 1;
	    chan->ior.ior.io_Flags &= chan->flagmask;
	    BeginIO((IOSTD *)chan);
	} else {			    /* syncronous IO  */
	    chan->ior.ior.io_Command = com;
	    chan->ior.ior.io_Flags = (chan->ior.ior.io_Flags & chan->flagmask) | IOF_QUICK;
	    BeginIO((IOSTD *)chan);
	    if (!(chan->ior.ior.io_Flags & IOF_QUICK))
		WaitIO((IOSTD *)chan);
	}
    }
    return((void *)chan);
}


void *
dio_isdone(_chan)
void *_chan;
{
    CHAN *chan = _chan;
    if (chan->notclear) {       /* if not clear */
	if (CheckIO((IOSTD *)chan)) {    /* if done      */
	    WaitIO((IOSTD *)chan);       /* clear        */
	    chan->notclear = 0;
	    return((void *)chan);     /* done         */
	}
	return(NULL);           /* notdone      */
    }
    return((void *)chan);               /* done         */
}


void *
dio_wait(_chan)
void *_chan;
{
    CHAN *chan = _chan;
    if (chan->notclear) {
	WaitIO((IOSTD *)chan);           /* wait and remove from rp */
	chan->notclear = 0;
    }
    return((void *)chan);
}


void *
dio_abort(_chan)
void *_chan;
{
    CHAN *chan = _chan;
    if (chan->notclear) {
	AbortIO((IOSTD *)chan);          /* Abort it   */
	WaitIO((IOSTD *)chan);           /* wait and remove from rp */
	chan->notclear = 0;
    }
    return((void *)chan);
}


