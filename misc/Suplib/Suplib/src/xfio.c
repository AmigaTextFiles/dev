
/*
 *  XFIO.C
 *
 *  Simple File IO with asyncronous READ and WRITE capability
 *  Perfect for protocol transfer applications
 *
 *  xfi = xfopen(name, modes, bufsize)  ("r", "w", "w+")
 *   n	= xfread(xfi, buf, bytes)   ASYNCRONOUS READ
 *  err = xfwrite(xfi, buf, bytes)  ASYNCRONOUS WRITE
 *  err = xfclose(xfi)
 *
 *  RESTRICTIONS:   NO seeking.  You can do one of xfread() or xfwrite()
 *  for a given open XFIle handle (not both).
 *
 *  xfwrite() returns a cumulative error (once an error occurs, it will not
 *  do any more writes).  xfclose() returns the cumulative write error
 *  (since the last write may have been asyncronous and thus the error
 *  unknown at the time).
 *
 *  Two buffers are created each bufsize/2 bytes in size.  for writing,
 *  one buffers is sent asyncronously while the other fills.  For reading,
 *  one buffer is filling while the other is being read.
 */

#include <local/typedefs.h>
#ifdef LATTICE
#include <stdlib.h>
#else
extern void *malloc();
#endif

#define XFI	    struct _XFI
#define XFBUF	    struct _XFBUF
#define MSGPORT     struct MsgPort
#define FH	    struct FileHandle
#define STDPKT	    struct StandardPacket


XFBUF {
    long   bufsize;
    long   idx;
    long   max;
    char    buf[4];	/*  actually bufsize bytes long */
};

XFI {
    char    ro; 	/*  read only, else write only	*/
    char    pend;	/*  packet pending		*/
    char    err;	/*  cumulative error		*/
    char    reserved;
    XFBUF   *asbuf;
    XFBUF   *usbuf;
    FH	    *fh;
    STDPKT  sp; 	/*  asyncronous message 	*/
    MSGPORT rp; 	/*  reply port for pending pkts */
};

void __xfstartasync ARGS((XFI *, long));

void *
xfopen(file, mode, bytes)
char *file;
char *mode;
long bytes;
{
    register XFI *xfi = malloc(sizeof(XFI));
    register long nbytes = bytes >> 1;
    int ap = 0;

    if (!xfi)
	return(NULL);

    BZero(xfi, sizeof(XFI));
    if (mode[0] == 'w') {
	if (mode[1] == '+') {
	    ap = 1;
	    if ((xfi->fh = (FH *)Open(file, 1005)) == NULL)
		xfi->fh = (FH *)Open(file, 1006);
	    goto ok;
	}
	xfi->fh = (FH *)Open(file, 1006);
	goto ok;
    }
    xfi->fh = (FH *)Open(file, 1005);
ok:
    if (xfi->fh) {
	if (ap)
	    Seek((BPTR)xfi->fh, 0, 1);
	xfi->fh = (FH *)((long)xfi->fh << 2);
	xfi->asbuf = malloc(sizeof(XFBUF) + nbytes);    /* a little more    */
	xfi->usbuf = malloc(sizeof(XFBUF) + nbytes);    /* then we need     */
	if (xfi->asbuf == NULL || xfi->usbuf == NULL) {
	    if (xfi->asbuf)
		free(xfi->asbuf);
	    if (xfi->usbuf)
		free(xfi->usbuf);
	    Close((long)xfi->fh >> 2);
	    free(xfi);
	    return(NULL);
	}
	BZero(xfi->asbuf, sizeof(XFBUF));
	BZero(xfi->usbuf, sizeof(XFBUF));
	xfi->ro = (mode[0] == 'r');
	xfi->asbuf->bufsize = xfi->usbuf->bufsize = nbytes;
	xfi->rp.mp_Node.ln_Type = NT_MSGPORT;
	xfi->rp.mp_Node.ln_Name = "XFIO-Async";
	xfi->rp.mp_Flags = PA_SIGNAL;
	xfi->rp.mp_SigBit = AllocSignal(-1);
	xfi->rp.mp_SigTask = FindTask(NULL);
	NewList(&xfi->rp.mp_MsgList);
	if (xfi->ro)
	    __xfstartasync(xfi, ACTION_READ);
    } else {
	free(xfi);
	xfi = NULL;
    }
    return(xfi);
}

int
xfclose(_xfi)
void *_xfi;
{
    XFI *xfi = _xfi;
    int err = 1;
    if (xfi) {
	if (xfi->pend) {
	    xfi->pend = 0;
	    WaitPort (&xfi->rp);
	    GetMsg   (&xfi->rp);
	}
	if (!xfi->ro && xfi->usbuf->idx)
	    Write((long)xfi->fh >> 2, xfi->usbuf->buf, xfi->usbuf->idx);
	err = xfi->err;
	Close((long)xfi->fh >> 2);
	free(xfi->asbuf);
	free(xfi->usbuf);
	FreeSignal(xfi->rp.mp_SigBit);
	free(xfi);
    }
    return(err);
}

long
xfseek(_xfi, pos)
void *_xfi;
long pos;
{
    XFI *xfi = _xfi;
    if (xfi) {
	if (xfi->pend) {
	    WaitPort (&xfi->rp);
	    GetMsg   (&xfi->rp);
	    xfi->pend = 0;
	    if (!xfi->ro) {
		if (xfi->sp.sp_Pkt.dp_Res1 != xfi->sp.sp_Pkt.dp_Arg3) {
		    xfi->err = 1;
		    return(1);
		}
	    }
	}
	if (!xfi->ro && xfi->usbuf->idx) {
	    Write((long)xfi->fh >> 2, xfi->usbuf->buf, xfi->usbuf->idx);
	    xfi->usbuf->idx = 0;
	}
	Seek((long)xfi->fh >> 2, pos, -1);
	if (xfi->ro) {
	    XFBUF *asbuf = xfi->asbuf;
	    xfi->asbuf = xfi->usbuf;
	    xfi->usbuf = asbuf;
	    xfi->usbuf->idx = xfi->usbuf->max = 0;
	    __xfstartasync(xfi, ACTION_READ);
	}
    }
}

int
xfgets(_xfi, buf, n)
void *_xfi;
char *buf;
long n;
{
    XFI *xfi = _xfi;
    register XFBUF *usbuf = xfi->usbuf;
    register int i, idx;
    if (!xfi->ro)
	return(-1);
    --n;
    for (i = 0;;) {
	for (idx = usbuf->idx; idx < usbuf->max && i < n; ++idx, ++i) {
	    if ((buf[i] = usbuf->buf[idx]) == '\n') {
		buf[i] = 0;
		usbuf->idx = idx+1;
		return(i);
	    }
	}
	usbuf->idx = idx;
	buf[i] = 0;
	if (i == n)
	    return(i);
	if (xfi->pend == 0)                             /* EOF      */
	    return(-1);
	WaitPort (&xfi->rp);
	GetMsg	 (&xfi->rp);
	xfi->pend = 0;
	if (xfi->sp.sp_Pkt.dp_Res1 <= 0) {              /* EOF      */
	    if (i == 0)
		return(-1);
	    return(i);
	}
	xfi->asbuf->max = xfi->sp.sp_Pkt.dp_Res1;
	xfi->asbuf->idx = 0;
	usbuf = xfi->asbuf;				/* swap bufs*/
	xfi->asbuf = xfi->usbuf;
	xfi->usbuf = usbuf;
	__xfstartasync(xfi, ACTION_READ);                 /* new async*/
    }
}

long
xfread(_xfi, buf, n)
void *_xfi;
char *buf;
long n;
{
    XFI *xfi = _xfi;
    register XFBUF *usbuf = xfi->usbuf;
    register int orig = n;
    register int diff;

    if (!xfi->ro)
	return(0);
    while ((diff = usbuf->max - usbuf->idx) < n) {
	BMov(usbuf->buf + usbuf->idx, buf, diff);     /* copy entire buf */
	buf += diff;
	n -= diff;
	if (xfi->pend == 0) {
	    xfi->usbuf->idx = xfi->usbuf->max;
	    return(orig - n);
	}
	WaitPort (&xfi->rp);
	GetMsg	 (&xfi->rp);
	xfi->pend = 0;
	if (xfi->sp.sp_Pkt.dp_Res1 <= 0) {              /* EOF      */
	    xfi->usbuf->idx = xfi->usbuf->max;
	    return(orig - n);
	}
	xfi->asbuf->max = xfi->sp.sp_Pkt.dp_Res1;
	xfi->asbuf->idx = 0;
	usbuf = xfi->asbuf;				/* swap bufs*/
	xfi->asbuf = xfi->usbuf;
	xfi->usbuf = usbuf;
	__xfstartasync(xfi, ACTION_READ);                 /* new async*/
    }
    BMov(usbuf->buf + usbuf->idx, buf, n);
    usbuf->idx += n;
    return(orig);
}

long
xfwrite(_xfi, buf, n)
void *_xfi;
char *buf;
long n;
{
    XFI *xfi = _xfi;
    register XFBUF *usbuf = xfi->usbuf;
    register int diff;

    if (xfi->ro || xfi->err)
	return(1);
    while ((diff = usbuf->bufsize - usbuf->idx) < n) {
	BMov(buf, usbuf->buf + usbuf->idx, diff);     /*  copy buf    */
	buf += diff;
	n -= diff;
	if (xfi->pend) {
	    WaitPort(&xfi->rp);
	    GetMsg  (&xfi->rp);
	    xfi->pend = 0;
	    if (xfi->sp.sp_Pkt.dp_Res1 != xfi->sp.sp_Pkt.dp_Arg3) {
		xfi->err = 1;
		return(1);
	    }
	}
	usbuf = xfi->asbuf;
	xfi->asbuf = xfi->usbuf;
	xfi->usbuf = usbuf;
	usbuf->idx = 0;
	__xfstartasync(xfi, ACTION_WRITE);
    }
    BMov(buf, usbuf->buf + usbuf->idx, n);
    usbuf->idx += n;
    return((long)xfi->err);
}

void
__xfstartasync(xfi, action)
XFI *xfi;
long action;
{
    xfi->sp.sp_Msg.mn_Node.ln_Name = (char *)&(xfi->sp.sp_Pkt);
    xfi->sp.sp_Pkt.dp_Link = &(xfi->sp.sp_Msg);
    xfi->sp.sp_Pkt.dp_Port = &xfi->rp;
    xfi->sp.sp_Pkt.dp_Type = action;
    xfi->sp.sp_Pkt.dp_Arg1 = xfi->fh->fh_Arg1;
    xfi->sp.sp_Pkt.dp_Arg2 = (long)xfi->asbuf->buf;
    xfi->sp.sp_Pkt.dp_Arg3 = xfi->asbuf->bufsize;
    PutMsg ((PORT *)xfi->fh->fh_Type, (MSG *)&xfi->sp);
    xfi->pend = 1;
}


