/*
 * umssmtpd.h V1.0.00
 *
 * UMS SMTP (server) main include file
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

/* Data structures */
struct RecipientNode {
 struct MinNode  rn_Node;         /* Node for MinList  */
 ULONG           rn_Size;         /* Size of this node */
 char            rn_Recipient[1]; /* Recipient address */
 /* variable size */
};

/* Function prototypes */
LONG HandleGreeting(struct UMSRFCData *);
LONG CommandLoop(struct UMSRFCData *);
void FreeRecipients(void);
BOOL HandleMAILCommand(struct UMSRFCData *, char *);
BOOL HandleRCPTCommand(struct UMSRFCData *, char *);
void InitMessageReceiving(void);
void HandleDATACommand(struct UMSRFCData *);
void InitResponseBuffer(void);
void FlushResponseBuffer(void);
void QueueResponse(const char *, ULONG len);

/* Global data */
extern struct Library *DOSBase, *SocketBase, *SysBase;
extern struct Library *UMSBase, *UMSRFCBase, *UtilityBase;
extern LONG            SMTPDSocket;
extern LONG            ErrNo;
extern ULONG           MaxMsgSize;
extern struct List     RecipientList;
extern char            LineBuffer[];
extern char            TempBuffer[];
extern char            ClientName[];
extern char            FromName[];
extern char            FromAddr[];
extern char            ToName[];
extern char            ToAddr[];
extern const char      SyntaxError[];
