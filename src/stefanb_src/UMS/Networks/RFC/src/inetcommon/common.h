/*
 * common.h V1.0.03
 *
 * UMS INET common include file
 *
 * (c) 1994-98 Stefan Becker
 */

#define AMITCP_NEW_NAMES

/* Include global files */
#include "/global.h"
#include "/revision.h"

/* OS include files */
#include <exec/libraries.h>
#include <utility/date.h>

/* TCP/IP include files */
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

/* OS function prototypes */
#include <clib/utility_protos.h>

/* OS function inline calls */
#include <pragmas/socket_pragmas.h>
#include <pragmas/utility_pragmas.h>

/* Global defines */
/* NNTP status codes */
#define NNTP_HELP                    100
#define NNTP_READY_POST_ALLOWED      200
#define NNTP_READY_POST_NOT_ALLOWED  201
#define NNTP_SLAVE_STATUS_NOTED      202
#define NNTP_CLOSING_CONNECTION      205
#define NNTP_GROUP_SELECTED          211
#define NNTP_LIST_OF_GROUPS          215
#define NNTP_LIST_OF_NEW_MSGIDS      230
#define NNTP_LIST_OF_NEW_GROUPS      231
#define NNTP_ARTICLE_RETRIEVED       220
#define NNTP_ARTICLE_RETRIEVED_HEAD  221
#define NNTP_ARTICLE_RETRIEVED_BODY  222
#define NNTP_ARTICLE_RETRIEVED_STAT  223
#define NNTP_OVERVIEW_FOLLOWS        224
#define NNTP_ARTICLE_TRANSFERRED     235 /* -> UMSExportedMsg() */
#define NNTP_ARTICLE_POSTED          240 /* -> UMSExportedMsg() */
#define NNTP_AUTHENTICATION_ACCEPTED 281
#define NNTP_SEND_ARTICLE            335
#define NNTP_POST_ARTICLE            340
#define NNTP_MORE_AUTHINFO_REQUIRED  381
#define NNTP_SERVICE_DISCONTINUED    400
#define NNTP_NO_SUCH_GROUP           411
#define NNTP_NO_GROUP_SELECTED       412
#define NNTP_NO_CURRENT_ARTICLE      420
#define NNTP_NO_NEXT_ARTICLE         421
#define NNTP_NO_PREVIOUS_ARTICLE     422
#define NNTP_NO_ARTICLE_IN_GROUP     423
#define NNTP_NO_SUCH_ARTICLE_FOUND   430
#define NNTP_ARTICLE_NOT_WANTED      435 /* Don't send  -> UMSExportedMsg()  */
#define NNTP_TRANSFER_FAILED         436 /* Retry later -> do nothing        */
#define NNTP_ARTICLE_REJECTED        437 /* Don't retry -> UMSCannotExport() */
#define NNTP_POSTING_NOT_ALLOWED     440 /* Retry later -> do nothing        */
#define NNTP_POSTING_FAILED          441 /* Retry later -> do nothing        */
#define NNTP_TRANSFER_NOT_ALLOWED    480 /* Retry later -> do nothing        */
#define NNTP_AUTHENTICATION_REQUIRED 480
#define NNTP_AUTHENTICATION_REJECTED 482
#define NNTP_ERROR                   500 /* And up...                        */
                                         /* Retry later -> do nothing        */
#define NNTP_SYNTAX_ERROR            501
#define NNTP_PERMISSION_DENIED       502
#define NNTP_PROGRAM_FAULT           503

/* POP3 status codes */
#define POP3_OK    0
#define POP3_ERROR 1
#define POP3_ABORT 2

/* SMTP status codes */
#define SMTP_HELP                  214
#define SMTP_SERVICE_READY         220
#define SMTP_CLOSING_CONNECTION    221
#define SMTP_ACTION_OK             250
#define SMTP_WILL_FORWARD          251
#define SMTP_START_MAIL_INPUT      354
#define SMTP_SERVICE_NOT_AVAILABLE 421
#define SMTP_ACTION_ABORTED        451
#define SMTP_ERROR                 500
#define SMTP_SYNTAX_ERROR          501
#define SMTP_BAD_SEQUENCE          503
#define SMTP_ACTION_NOT_TAKEN      550
#define SMTP_OUT_OF_MEMORY         552
#define SMTP_UNKNOWN_PARAMETER     555

/* ConnectToHost() return codes */
#define CONNECT_OK            0
#define CONNECT_NOT_AVAILABLE 1
#define CONNECT_NOT_POSSIBLE  2

/* Data structures */
struct OutputData {
 struct Library *od_DOSBase; /* Pointer to DOS library */
 BPTR            od_Handle;  /* Handle for output file */
 UWORD           od_Counter; /* Buffer counter         */
 UWORD           od_Length;  /* Buffer length          */
 char           *od_Buffer;  /* Pointer to buffer      */
};

struct InputData {
 struct OutputData *id_OutputData; /* Pointer to Output data     */
 char              *id_FileName;   /* Temporary file name        */
 char              *id_Buffer;     /* Pointer to read buffer     */
 ULONG              id_Length;     /* Read buffer length         */
 struct Library    *id_SocketBase; /* Pointer to socket library  */
 LONG               id_Socket;     /* Socket descriptor          */
 struct Library    *id_SysBase;    /* Pointer to Exec library    */
 ULONG              id_MsgLength;  /* Message buffer length      */
};

struct ConnectData {
 struct Library     *cd_SocketBase; /* Pointer to socket library */
 LONG                cd_Port;       /* Port number               */
 LONG                cd_Socket;     /* Socket descriptor         */
 struct sockaddr_in  cd_Address;    /* Socket address            */
};

/* Function prototypes */
void  OutputFunction(__A0 struct OutputData *, __D0 char);
BOOL  ReadLine(struct Library *, LONG, char *, LONG);
char *ReadMessageFromSocket(struct InputData *id);
BOOL  GetConnectData(struct ConnectData *, const char *);
void  FreeConnectData(struct ConnectData *);
ULONG ConnectToHost(struct ConnectData *, const char *);
void  CloseConnection(struct ConnectData *);
