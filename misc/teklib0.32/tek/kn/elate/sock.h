
#ifndef TEK_KN_ELATE_SOCK_H
#define TEK_KN_ELATE_SOCK_H

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	tek/kn/elate/sock.h
**
*/

#include <sys/socket.h>
#include <sys/types.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <errno.h>

#include "tek/kn/exec.h"
#include "tek/kn/sock.h"

#define KNSOCK_MAXLISTEN		64			/* max number of connections to a server socket */
#define KNSOCK_MAXPENDING		64			/* max number of concurrent messages on a client socket pending for delivery */
#define TIMEOUT_USEC			1000		/* select() timeout */
#define KNSOCK_SENDFLAGS		0
#define KNSOCK_RECVFLAGS		0

typedef int	kn_sockenv_t;				/* dummy */

#include "tek/kn/sockcommon.h"

#define kn_getsockenv(x)				TTRUE

int kn_waitselect(kn_sockenv_t *sockenv, int n, fd_set *r, fd_set *w, fd_set *e, struct timeval *t, TKNOB *evt, TBOOL *signal)
	__ELATE_QCALL__(("qcall lib/tek/kn/sock/waitselect"));

int kn_getsockerrno(kn_sockenv_t *sockenv, int desc)
	__ELATE_QCALL__(("qcall lib/tek/kn/sock/getsockerrno"));

#define kn_locksock(x)
#define kn_unlocksock(x)
#define kn_inet_ntoa(name)				inet_ntoa(((struct sockaddr_in *) name)->sin_addr)
#define kn_setsockopts(desc)			{ int yes = 1; setsockopt(desc, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes)); }
#define kn_closesocket(desc)			close(desc)
#define kn_socknonblocking(desc)		{ int yes = 1; setsockopt(desc, SOL_SOCKET, SO_NOBLOCK, &yes, sizeof(yes)); }

#endif
