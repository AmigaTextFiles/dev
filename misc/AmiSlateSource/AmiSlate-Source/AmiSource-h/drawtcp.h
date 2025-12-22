/* drawtcp.h */

#define IDCMP_READY 0x01
#define READ_READY  0x02
#define WRITE_READY 0x04
#define AREXX_READY 0x08

UBYTE DrawWait(void);

int ConnectDrawSocket(BOOL BShowRequester);
int CloseDrawSocket(void);
int Receive(char *sBuffer, LONG lLen);

void GetDrawPeerName(char *sBuffer, int nBufLen);
void FlushQueue(void);
void RexxTimeOut(void);

BOOL AcceptDrawSocket(struct DaemonMessage *dm); 	/* Grabs given socket from inetd */
BOOL SendChar(char cChar);
BOOL SendString(char *sString, int nLen);
BOOL AllocQueue(LONG lQMaxLen);
BOOL FreeQueue(void);
BOOL AddToQueue(char *sString, LONG lLen);
BOOL ReduceQueue(void);
BOOL GetRemoteScreenInfo(UWORD *height, UWORD *width, UBYTE *depth, UWORD *winheight, UWORD *windepth);
BOOL SendScreenInfo(UWORD height, UWORD width, UBYTE depth, UWORD winheight, UWORD windepth);
BOOL SetAsyncMode(BOOL BAsynch);

