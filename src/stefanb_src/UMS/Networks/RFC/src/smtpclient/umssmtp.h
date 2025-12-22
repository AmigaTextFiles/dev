/*
 * umssmtp.h V1.0.01
 *
 * UMS SMTP (client) main include file
 *
 * (c) 1994-97 Stefan Becker
 */

/* INET common include file */
#include <common.h>

/* Function prototypes */
ULONG GetReturnCode(void);
ULONG InitConnection(struct UMSRFCData *, struct ConnectData *, const char*);
void  HandleMAILFROMResponse(ULONG);
void  HandleRCPTTOResponse(ULONG, UMSMsgNum);
void  InitSendMessage(void);
ULONG SendMessage(struct UMSRFCData *, struct ConnectData *);
void  EnableQueue(void);
void  DisableQueue(void);
ULONG EmptyQueue(void);
ULONG QueueCommand(const char *, ULONG, ULONG, UMSMsgNum);

/* Global data */
extern struct DOSBase *DOSBase;
extern struct Library *SysBase, *SocketBase, *UMSBase, *UMSRFCBase;
extern struct Library *UtilityBase;
extern UMSAccount Account;
extern LONG ErrNo;
extern LONG SMTPSocket;
extern char LineBuffer[];
extern BOOL ESMTPSize;
extern BOOL MIME8Bit;

/* Global defines */
#define SELBIT1 1
#define SELBIT2 2
#define MARKBIT 4

/* Buffer length */
#define BUFLEN 1024

/* Command queue length */
#define QUEUELEN 32

/* Queue command types */
#define QUEUETYPE_MAILFROM 0
#define QUEUETYPE_RCPTTO   1
#define QUEUETYPE_IGNORE   2
