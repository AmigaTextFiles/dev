
#ifndef _TEK_KERNEL_SOCK_H
#define	_TEK_KERNEL_SOCK_H 1

/* 
**	tek/kn/sock.h
**	TEKlib kernel socket interface
*/

#include "tek/type.h"
#include "tek/msg.h"
#include "tek/kn/exec.h"

#ifdef KNSOCKDEBUG
	#define	dbsprintf(l,x)		{if (l > 0 && l >= KNSOCKDEBUG) platform_dbprintf(x);}
	#define	dbsprintf1(l,x,a)	{if (l > 0 && l >= KNSOCKDEBUG) platform_dbprintf1(x,a);}
	#define	dbsprintf2(l,x,a,b)	{if (l > 0 && l >= KNSOCKDEBUG) platform_dbprintf2(x,a,b);}
#else
	#define	dbsprintf(l,x)
	#define	dbsprintf1(l,x,a)
	#define	dbsprintf2(l,x,a,b)
#endif


#define KNSOCK_VERSION			0			/* TEKlib kernel socket protocol version */

#define KNSOCK_PROTO_PUT		0			/* one-way msg */
#define KNSOCK_PROTO_PUTREPLY	1			/* msg with ack/reply expected */
#define KNSOCK_PROTO_ACK		2			/* ack message */
#define KNSOCK_PROTO_REPLY		3			/* reply message */

#define KNSOCK_NAME_DIFFER		0			/* name objects refer to entirely different addresses */
#define KNSOCK_NAME_SAMEHOST	1			/* name objects refer to different addresses on the same host */
#define KNSOCK_NAME_EQUAL		2			/* name objects refer to the same address and port number */


typedef struct
{ TBYTE name[64]; } knsockobj;				/* socket name object */


typedef struct
{
	TUINT msgsize;							/* size of msg including sizeof(knnethead) */
	TUINT8 protocol;						/* message protocol */
	TUINT8 version;							/* teklib protocol version */
	TUINT16 reserved;
	TUINT msgID;							/* message ID from client */

} knnethead;


typedef struct
{
	knsockobj *sendername;				 	/* kernel sender name object */
	TBYTE symbolicname[32];					/* currently defined to be sender name (IP:port) string */
	TAPTR backptr;							/* backptr to platform-specific socket data */
	knnethead nethead;						/* net header (only used in server sockets) */

} knnetmsg;


extern TBOOL kn_initsockname(knsockobj *sockname, TSTRPTR ipname, TUINT16 port)		__ELATE_QCALL__(("qcall lib/tek/kn/sock/initsockname"));
extern TVOID kn_destroysockname(knsockobj *sockname)								__ELATE_QCALL__(("qcall lib/tek/kn/sock/destroysockname"));
extern TUINT kn_cmpsockname(knsockobj *name1, knsockobj *name2)						__ELATE_QCALL__(("qcall lib/tek/kn/sock/cmpsockname"));
extern TBOOL kn_dupsockname(knsockobj *oldname, knsockobj *newname)					__ELATE_QCALL__(("qcall lib/tek/kn/sock/dupsockname"));
extern TSTRPTR kn_getsockname(knsockobj *name)										__ELATE_QCALL__(("qcall lib/tek/kn/sock/getsockname"));
extern TUINT16 kn_getsockport(knsockobj *name)										__ELATE_QCALL__(("qcall lib/tek/kn/sock/getsockport"));

extern TAPTR kn_createservsock(TAPTR mmu, TAPTR msgmmu, knsockobj *knsockname, TUINT maxmsgsize, TKNOB *timer, TTIME *timeout, TUINT *portnr)	__ELATE_QCALL__(("qcall lib/tek/kn/sock/createservsock"));
extern TVOID kn_destroyservsock(TAPTR knsock)										__ELATE_QCALL__(("qcall lib/tek/kn/sock/destroyservsock"));
extern TUINT kn_waitservsock(TAPTR knsock, TKNOB *event)							__ELATE_QCALL__(("qcall lib/tek/kn/sock/waitservsock"));
extern TMSG *kn_getservsockmsg(TAPTR knsock)										__ELATE_QCALL__(("qcall lib/tek/kn/sock/getservsockmsg"));
extern TVOID kn_returnservsockmsg(TAPTR knsock, TMSG *msg)							__ELATE_QCALL__(("qcall lib/tek/kn/sock/returnservsockmsg"));

extern TAPTR kn_createclientsock(TAPTR mmu, knsockobj *knsockname, TKNOB *timer, TTIME *timeout)	__ELATE_QCALL__(("qcall lib/tek/kn/sock/createclientsock"));
extern TVOID kn_destroyclientsock(TAPTR knsock)										__ELATE_QCALL__(("qcall lib/tek/kn/sock/destroyclientsock"));
extern TUINT kn_waitclientsock(TAPTR knsock, TKNOB *event)							__ELATE_QCALL__(("qcall lib/tek/kn/sock/waitclientsock"));
extern TBOOL kn_putclientsockmsg(TAPTR knsock, TMSG *msg)							__ELATE_QCALL__(("qcall lib/tek/kn/sock/putclientsockmsg"));
extern TMSG *kn_getclientsockmsg(TAPTR knsock)										__ELATE_QCALL__(("qcall lib/tek/kn/sock/getclientsockmsg"));

extern char *kn_itoa(int i, char *d)												__ELATE_QCALL__(("qcall lib/tek/kn/sock/itoa"));

#endif
