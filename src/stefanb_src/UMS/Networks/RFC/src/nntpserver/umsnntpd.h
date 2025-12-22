/*
 * umsnntpd.h V1.0.02
 *
 * UMS NNTP (server) main include file
 *
 * (c) 1994-98 Stefan Becker
 */

/* INET common include file */
#include <common.h>

/* OS include files */
#include <dos/dostags.h>
#include <libraries/locale.h>

/* TCP/IP include files */
#include <inetd.h>

/* OS function prototypes */
#include <clib/locale_protos.h>

/* OS function inline calls */
#include <pragmas/locale_pragmas.h>

/* Global defines */
/* Buffer length */
#define BUFLEN      1024
#define USERNAMELEN   31

/* Flag definitions */
#define NNTPDF_POSTING 0x1 /* Remote client is allowed to post/send     */
#define NNTPDF_SERVER  0x2 /* Remote client is server (may use IHAVE)   */

/* Action codes for RetrieveArticle */
#define ACTION_STAT    0 /* Just retrieve article                      */
#define ACTION_HEAD    1 /* Retrieve article and send header to client */
#define ACTION_BODY    2 /* Retrieve article and send body to client   */
#define ACTION_ARTICLE 3 /* Retrieve article and send it to client     */

/* Local selection bit for groups */
#define SELECTF_GROUP 0x0800

/* Data structures */
struct AccessData {
 ULONG  ad_Flags;                 /* Flags for the NNTP handler       */
 char  *ad_User[USERNAMELEN + 1]; /* UMS user name if pattern matched */
};

/* Function prototypes */
void  NNTPHandler(void);
ULONG CommandLoop(struct UMSRFCData *);
void  FreeMsgBuffer(void);
void  HandleGROUPCommand(struct UMSRFCData *, char *);
void  MoveCurrentPointer(struct UMSRFCData *, LONG);
void  RetrieveArticle(struct UMSRFCData *, UBYTE, char *);
BOOL  ReceiveArticle(struct UMSRFCData *, const char *, ULONG);
BOOL  HandleLISTCommand(struct UMSRFCData *, char *);
BOOL  HandleNEWNEWSCommand(struct UMSRFCData *, char *);
BOOL  HandleNEWGROUPSCommand(struct UMSRFCData *, char *);
BOOL  HandleXHDRCommand(struct UMSRFCData *, char *);
BOOL  HandleXOVERCommand(struct UMSRFCData *, char *);

/* Global data */
extern struct Library    *DOSBase, *SysBase, *UtilityBase, *UMSBase;
extern struct Library    *UMSRFCBase;
extern LONG               NNTPDSocket;
extern LONG               ErrNo;
extern LONG               GMTOffset;
extern ULONG              CurrentArticle;
extern ULONG              MaxArticles;
extern struct AccessData *AccessData;
extern struct OutputData  OutputData;
extern struct InputData   InputData;
extern char               OutBuffer[];
extern char               LineBuffer[];
extern char               TempBuffer[];
extern const char         NoGroupSelected[];
