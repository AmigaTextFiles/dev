/*
 * umspop3.h V1.0.00
 *
 * UMS POP3 (client) main include file
 *
 * (c) 1994-97 Stefan Becker
 */

/* INET common include file */
#include <common.h>

/* Function prototypes */
ULONG GetReturnCode(void);
ULONG GetMessages(struct UMSRFCData *, ULONG, const char *, BOOL);

/* Global data */
extern struct DOSBase   *DOSBase;
extern struct Library   *SysBase, *SocketBase, *UMSBase, *UMSRFCBase;
extern struct Library   *UtilityBase;
extern struct InputData  InputData;
extern LONG ErrNo;
extern LONG POP3Socket;
extern char Buffer[];

/* Global defines */
#define BUFLEN 1024
