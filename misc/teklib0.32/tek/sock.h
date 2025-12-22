
#ifndef _TEK_SOCKTASK_H
#define	_TEK_SOCKTASK_H 1

#include <tek/msg.h>

/* 
**	tek/sock.h
**
**	socket communication
**
*/


/* 
**	host/network endian swapping macros.
**	the underlying macros need to be defined elsewhere,
**	typically they are included with <tek/type.h>
*/


#define THTON32(x)	htonl(x)
#define THTON16(x)	htons(x)
#define TNTOH32(x)	ntohl(x)
#define TNTOH16(x)	ntohs(x)


/* 
**	tags
*/

#define TSOCKTAGS_				(TTAG_USER + 0x500)
#define TSock_ReplyTimeout		(TTAG) (TSOCKTAGS_ + 0)			/* maximum time allowed for a reply */	
#define TSock_IdleTimeout		(TTAG) (TSOCKTAGS_ + 1)			/* maximum idle time on a connection */
#define TSock_MaxMsgSize		(TTAG) (TSOCKTAGS_ + 2)			/* maximum msg size to accept via socket */


TBEGIN_C_API


extern TUINT TAddSockPort(TPORT *msgport, TUINT portnr, TTAGITEM *tags)						__ELATE_QCALL__(("qcall lib/tek/sock/addsockport"));
extern TVOID TRemSockPort(TPORT *msgport)													__ELATE_QCALL__(("qcall lib/tek/sock/remsockport"));
extern TPORT *TFindSockPort(TAPTR task, TSTRPTR ipname, TUINT16 portnr, TTAGITEM *tags)		__ELATE_QCALL__(("qcall lib/tek/sock/findsockport"));


TEND_C_API


#endif
