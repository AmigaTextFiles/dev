
/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	tek/kn/linux/sock.c
**
**	socket backend
**
*/

#include <sys/socket.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

#include "tek/kn/exec.h"
#include "tek/kn/sock.h"
#include "tek/kn/linux/exec.h"


#define KNSOCK_MAXLISTEN		64				/* max number of connections to a server socket */
#define KNSOCK_MAXPENDING		64				/* max number of concurrent messages on a client socket pending for delivery */
#define TIMEOUT_USEC			1000			/* select() timeout */
#define KNSOCK_SENDFLAGS		MSG_NOSIGNAL
#define KNSOCK_RECVFLAGS		MSG_NOSIGNAL



typedef int kn_sockenv_t;


#include "tek/kn/sockcommon.h"


int kn_waitselect(kn_sockenv_t *sockenv, int n, fd_set *r, fd_set *w, fd_set *e, struct timeval *t, TKNOB *evt, TBOOL *signal)
{ 
	int numready = select(n, r, w, e, t);
	*signal = kn_timedwaitevent(evt, TNULL, TNULL);
	return numready;
}

#define kn_getsockenv(sockenv)			TTRUE
#define kn_locksock(sockenv)			
#define kn_unlocksock(sockenv)			
#define kn_getsockerrno(sockenv,desc)	errno

#define kn_inet_ntoa(name)				inet_ntoa(((struct sockaddr_in *) name)->sin_addr)
#define kn_closesocket(desc)			close(desc)
#define kn_socknonblocking(desc)		{ int mode; mode = fcntl(desc, F_GETFL, 0); fcntl(desc, F_SETFL, mode | O_NONBLOCK); }


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
