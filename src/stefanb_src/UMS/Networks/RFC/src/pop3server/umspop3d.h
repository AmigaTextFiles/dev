/*
 * umspop3d.h V1.0.00
 *
 * UMS POP3 (server) main include file
 *
 * (c) 1994-97 Stefan Becker
 */

/* INET common include file */
#include <common.h>

/* OS include files */
#include <dos/dostags.h>

/* TCP/IP include files */
#include <inetd.h>

/* OS function prototypes */
#include <clib/alib_protos.h>

/* Compiler specific include files */
#include <lists.h>

/* Global defines */
/* Buffer lengths */
#define BUFLEN      1024

/* Function prototypes */
LONG AuthorizationState(struct UMSRFCData *, char *);
LONG TransactionState(struct UMSRFCData *);
BOOL LockMailDrop(struct UMSRFCData *);
void ReleaseMailDrop(struct UMSRFCData *, LONG);
void InitSendMessage(void);
void SendMessage(struct UMSRFCData *);


/* Global data */
extern struct Library     *DOSBase, *SocketBase, *SysBase;
extern struct Library     *UMSBase, *UMSRFCBase, *UtilityBase;
extern struct UMSRFCBases urb;
extern LONG               POP3DSocket;
extern LONG               ErrNo;
extern char               LineBuffer[];
extern char               TempBuffer[];
