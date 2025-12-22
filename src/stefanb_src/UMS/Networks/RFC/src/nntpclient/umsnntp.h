/*
 * umsnntp.h V1.0.04
 *
 * UMS NNTP (client) main include file
 *
 * (c) 1994-98 Stefan Becker
 */

/* INET common include file */
#include <common.h>

/* OS include files */
#include <dos/dostags.h>

/* Function prototypes */
#include <clib/alib_protos.h>

/* Function prototypes */
void  InitSendArticle(void);
ULONG SendArticle(struct UMSRFCData *, BOOL);
void  NNTPHandler(void);
void  GetArticle(struct HandlerData *, const char *, ULONG);
ULONG GetReturnCode(struct NNTPCommandData *);
ULONG SendNNTPCommand(struct NNTPCommandData *, const char *, ULONG);

/* Global defines */
#define SELBIT 1

/* Buffer length */
#define BUFLEN 1024

/* Maximum number of processes */
#define MAXHANDLERS 20

/* Handler commands */
#define COMM_INIT       0
#define COMM_QUIT       1
#define COMM_GETARTICLE 2
#define COMM_GETGROUP   3

/* Data structures */
struct NNTPCommandData {
 struct ConnectData  ncd_ConnectData;
 const char         *ncd_User;
 const char         *ncd_Password;
 char                ncd_Buffer[BUFLEN];
};

struct InitData {
 char  *id_NNTPHostName;    /* Host name of NNTP server */
 char  *id_NNTPServiceName; /* NNTP service name        */
 char  *id_UMSUser;         /* UMS user for NNTP        */
 char  *id_UMSPassword;     /* UMS password for NNTP    */
 char  *id_UMSServer;       /* UMS server for NNTP      */
 char  *id_AuthUser;        /* Authentication user name */
 char  *id_AuthPassword;    /* Authentication password  */
};

struct HandlerMessage {
 struct Message   hm_Message;
 struct MsgPort  *hm_Port;
 ULONG            hm_Command;
 void            *hm_Parameter;
 char             hm_ParBuf[BUFLEN];
};

struct HandlerData {
 struct UMSRFCBases      hd_Bases;
 struct Library         *hd_SysBase;
 struct Library         *hd_UMSRFCBase;
 struct UMSRFCData      *hd_URData;
 struct NNTPCommandData  hd_CommandData;
 struct OutputData       hd_OutputData;
 struct InputData        hd_InputData;
 char                    hd_FileName[BUFLEN];
 char                    hd_Buffer[BUFLEN];
 char                    hd_OutBuf[BUFLEN];
};

/* Global data */
extern struct DOSBase         *DOSBase;
extern struct Library         *SysBase, *SocketBase, *UMSBase, *UMSRFCBase;
extern struct Library         *UtilityBase;
extern struct NNTPCommandData  CmdData;
extern LONG                    ErrNo;
