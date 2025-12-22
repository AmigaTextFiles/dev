
/*
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	tek/kn/amiga/sock.c
**	AmigaOS 3.x bsdsocket.library backend
**
**	TODO:
**		amiga WaitSelect() isn't interrupted by timeout ->
**		no timeout handling when no traffic!
**
*/

#include <exec/types.h>
#include <proto/dos.h>
#include <proto/exec.h>

#include <proto/socket.h>
#include <netinet/in.h>
#include <amitcp/socketbasetags.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/errno.h>
#include <sys/ioctl.h>
#include <netdb.h>
#include <string.h>


#include "tek/kn/sock.h"
#include "tek/kn/amiga/exec.h"



#define KNSOCK_MAXLISTEN		16			/* max number of connections to a server socket */
#define KNSOCK_MAXPENDING		32			/* max number of concurrent messages on a client socket pending for delivery */
#define TIMEOUT_USEC			10000		/* select() timeout */
#define KNSOCK_SENDFLAGS		0
#define KNSOCK_RECVFLAGS		0


typedef struct
{
	TAPTR socketbase;
	LONG *sockerrno;

} kn_sockenv_t;


#include "tek/kn/sockcommon.h"



#define SysBase *((struct ExecBase **) 4L)

static TBOOL kn_getsockenv(kn_sockenv_t *sockenv)
{
	struct amithread *self = (FindTask(NULL))->tc_UserData;
	if (self)
	{
		if (!self->socketbase)
		{
			self->socketbase = OpenLibrary("bsdsocket.library", 4);
			if (self->socketbase)
			{
				#define SocketBase self->socketbase
				SetErrnoPtr(&self->sockerrno, sizeof(LONG));
				#undef SocketBase
			}
		}
		
		if (self->socketbase)
		{
			sockenv->socketbase = self->socketbase;
			sockenv->sockerrno = &self->sockerrno;
			return TTRUE;
		}
		else
		{
			dbsprintf(20,"*** TEKLIB getsockenv: could not open bsdsocket.library v4\n");
		}
	}
	else
	{
		dbsprintf(40,"*** TEKLIB getsockenv ALERT: could not find self\n");
	}

	return TFALSE;
}

#undef SysBase


#define SocketBase	((kn_sockenv_t *) sockenv)->socketbase


int kn_waitselect(kn_sockenv_t *sockenv, int n, fd_set *r, fd_set *w, fd_set *e, struct timeval *t, TKNOB *evt, TBOOL *signal)
{ 
	ULONG amisig = 1L << ((struct amievent *) evt)->signal;
	int numready = WaitSelect(n, r, w, e, TNULL, &amisig);
	*signal = amisig;
	return numready;
}

#define kn_getsockerrno(sockenv,desc)	*(((kn_sockenv_t *) sockenv)->sockerrno)
#define kn_locksock(sockenv)
#define kn_unlocksock(sockenv)
#define kn_inet_ntoa(name)				Inet_NtoA(((struct sockaddr_in *) (name))->sin_addr.s_addr)
#define kn_setsockopts(desc)			{ LONG yes = 1; setsockopt(desc, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes)); }
#define kn_closesocket(desc)			CloseSocket(desc)
#define kn_socknonblocking(desc)		{ LONG yes = 1; IoctlSocket(desc, FIONBIO, (char *) &yes); }

#include "tek/kn/sockcommon/initsockname.c"
#include "tek/kn/sockcommon/destroysockname.c"
#include "tek/kn/sockcommon/cmpsockname.c"
#include "tek/kn/sockcommon/dupsockname.c"
#include "tek/kn/sockcommon/getsockname.c"
#include "tek/kn/sockcommon/getsockport.c"

#include "tek/kn/sockcommon/createclientsock.c"
#include "tek/kn/sockcommon/destroyclientsock.c"
#include "tek/kn/sockcommon/getclientsockmsg.c"
#include "tek/kn/sockcommon/putclientsockmsg.c"
#include "tek/kn/sockcommon/waitclientsock.c"

#include "tek/kn/sockcommon/createservsock.c"
#include "tek/kn/sockcommon/destroyservsock.c"
#include "tek/kn/sockcommon/getservsockmsg.c"
#include "tek/kn/sockcommon/returnservsockmsg.c"
#include "tek/kn/sockcommon/waitservsock.c"

#include "tek/kn/sockcommon/itoa.c"


#undef SocketBase
