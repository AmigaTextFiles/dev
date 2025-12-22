-> NOREV
OPT MODULE
OPT PREPROCESS
OPT EXPORT

/*
 *  Class Structure
 *
 *  Rootclass
 *    |
 *    *----Application
 *    *----Socket
 *         |
 *         \----Server
 */

MODULE  'exec/types',
  'exec/libraries',
  'intuition/classes',
  'utility/tagitem'

#define SocketClass    'Socket.class'
#define ServerClass    'SocketServer.class'
#define SocketAppClass  'SocketApplication.class'
#define EasySocketClass    'EasySocket.class'
#define EasyServerClass    'EasySocketServer.class'


#define EasySocketVersion  1
#define EasySocketRevision  0

OBJECT easySocketBase
  libNode:lib
  pad:INT
  segList:PTR TO LONG
  es_SocketClass:PTR TO iclass
  es_SocketAppClass:PTR TO iclass
  es_ServerClass:PTR TO iclass
  es_UDPClass:PTR TO iclass         /* private for now, but will be made   */
  es_UDPServerClass:PTR TO iclass   /* public in the future          */
  es_EasySocketClass:PTR TO iclass
  es_EasyServerClass:PTR TO iclass
ENDOBJECT


/*  Definitions for ES_MakeClass() */

CONST ESV_MakeClass_Socket=0
CONST ESV_MakeClass_App=1
CONST ESV_MakeClass_Server=2
CONST ESV_MakeClass_UDP=3
CONST ESV_MakeClass_UDPServer=4
CONST ESV_MakeClass_EasySocket=5
CONST ESV_MakeClass_EasyServer=6

/****************************************
**  Macros        **
****************************************/

#define SocketObject NewObjectA(NIL,SocketClass,[TAG_IGNORE,0
#define ServerObject NewObjectA(NIL,ServerClass,[TAG_IGNORE,0
#define SocketAppObject NewObjectA(NIL,SocketAppClass,[TAG_IGNORE,0
#define EasySocketObject NewObjectA(NIL,EasySocketClass,[TAG_IGNORE,0
#define EasyServerObject NewObjectA(NIL,EasyServerClass,[TAG_IGNORE,0
#define End TAG_DONE])

/*
 *  SocketApp.class
 */

CONST ES_Application_Dummy=TAG_USER+$10000

CONST ESM_Application_GetSocketEvent=ES_Application_Dummy+0
CONST ESM_Application_AddEventHandler=ES_Application_Dummy+2
CONST ESM_Application_RemoveEventHandler=ES_Application_Dummy+3
CONST ESM_Application_AllocMem=ES_Application_Dummy+4
CONST ESM_Application_FreeMem=ES_Application_Dummy+5

CONST ESA_Application_Child=ES_Application_Dummy+0   /* PTR TO obj  */
CONST ESA_Application_ErrorString=ES_Application_Dummy+2 /* ..g   LONG        */
CONST ESA_Application_MaxSockets=ES_Application_Dummy+3  /* i..   LONG        */
CONST ESA_Application_UserName=ES_Application_Dummy+4 /* ..g   char     *  */
CONST ESA_Application_LocalAddress=ES_Application_Dummy+6  /* ..g   LONG        */
CONST ESA_Application_LocalHostName=ES_Application_Dummy+7  /* ..g   char  *     */


/*
 *  SocketData.class
 */

CONST ES_SocketBase=TAG_USER+$20000

CONST ESM_Socket_EventAccept=ES_SocketBase+1
CONST ESM_Socket_EventConnected=ES_SocketBase+2
CONST ESM_Socket_EventOOB=ES_SocketBase+3
CONST ESM_Socket_EventRead=ES_SocketBase+4
CONST ESM_Socket_EventWrite=ES_SocketBase+5
CONST ESM_Socket_Error=ES_SocketBase+6
CONST ESM_Socket_EventClosed=ES_SocketBase+7
CONST ESM_Socket_Open=ES_SocketBase+9
CONST ESM_Socket_Close=ES_SocketBase+10
CONST ESM_Socket_GetNextObject=ES_SocketBase+11 /* MethodID, flags */
CONST ESM_Socket_ReadRaw=ES_SocketBase+12 /* MethodID, buffer, len */
CONST ESM_Socket_Read=ES_SocketBase+13 /* MethodID, buffer, len */
CONST ESM_Socket_Write=ES_SocketBase+14 /* MethodID, buf, len */
CONST ESM_Socket_WriteAll=ES_SocketBase+17
CONST ESM_Socket_Shutdown=ES_SocketBase+19
CONST ESM_Socket_SetURI=ES_SocketBase+21

CONST ESA_Socket_Child=ES_SocketBase+0     /* i..  Object *  */
CONST ESA_Socket_MsgBufSize=ES_SocketBase+1 /* i..  ULONG   Defaults to 8192 */
CONST ESA_Socket_UserData=ES_SocketBase+4   /* is.   */
CONST ESA_Socket_Flags=ES_SocketBase+5    /* is.  ULONG  */
CONST ESA_Socket_RequestEvents=ES_SocketBase+6  /* i..  ULONG  See below for default values  */
CONST ESA_Socket_HostName=ES_SocketBase+7  /* isg  APTR  Defaults to NULL (ESV_Socket_HostName_Server)  */
CONST ESA_Socket_HostPort=ES_SocketBase+8  /* is.  UWORD       */
CONST ESA_Socket_Type=ES_SocketBase+10   /* is.  ULONG  Defaults to #SOCK_STREAM  */
CONST ESA_Socket_Resource=ES_SocketBase+13 /* isg APTR No default */
CONST ESA_Socket_RemoteIP=ES_SocketBase+15    /* ..g char *  */
CONST ESA_Socket_RemoteAddr=ES_SocketBase+16 /* ..g  ULONG */
CONST ESA_Socket_ObjList=ES_SocketBase+17 /* ..g PTR TO lh */
CONST ESA_Socket_AllowUDP=ES_SocketBase+18   /* is.   BOOL  Defaults to FALSE          */              */
CONST ESA_Socket_FellowPort=ES_SocketBase+19 /* isg   UWORD    */
CONST ESA_Socket_NBIO=ES_SocketBase+20 /* is.   BOOL     */
CONST ESA_Socket_AsyncIO=ES_SocketBase+21 /* is.   BOOL     */
CONST ESA_Socket_NoDelay=ES_SocketBase+22 /* is.   BOOL     */
CONST ESA_Socket_OOBInline=ES_SocketBase+23  /* is.   BOOL     */
CONST ESA_Socket_KeepAlive=ES_SocketBase+24  /* is.   BOOL     */
CONST ESA_Socket_UserAgent=ES_SocketBase+25  /* is.   char *   Default depends on subclass   */

/* Flags for ESM_Socket_Write */

CONST ESV_Socket_Write_UseUDP=$80000000
CONST ESV_Socket_Write_NoAck=$40000000 /* UDP specific flag */
CONST ESV_Socket_Write_OOB=$00000001

/* Special values for ESA_Client_RequestEvents */

CONST ESV_Socket_RequestEvents_Client=$6E  /* Socket.class, SocketClient.class  */
CONST ESV_Socket_RequestEvents_Server=$61  /* SocketServer.class    */


CONST ESV_Socket_Flags_Set=$80000000
CONST ESV_Socket_Flags_Clear=$00000000

CONST ESV_Socket_Flags_RawMessages=$8000000 /* set socket to receive and send raw messages */
CONST ESV_Socket_Flags_NBIO=$40000000    /* Non-blocking I/O   */
CONST ESV_Socket_Flags_ASyncIO=$20000000  /* Asynchronous I/O    */
CONST ESV_Socket_Flags_NoDelay=$10000000  /* Disable Nagle buffering algorithm  */
CONST ESV_Socket_Flags_Default=$E0000000  /* Default setting   */

OBJECT esp_Accept
  methodID:LONG
  obj:PTR TO object_
ENDOBJECT

OBJECT esp_Connected
  methodID:LONG
ENDOBJECT

OBJECT esp_OOB
  methodID:LONG
ENDOBJECT

OBJECT esp_EventRead
  methodID:LONG
ENDOBJECT

OBJECT esp_EventWrite
  methodID:LONG
ENDOBJECT

OBJECT esp_Error
  methodID:LONG
  primaryError:LONG      /* if NULL then classError contains an secondary error */
  classError:LONG
ENDOBJECT

OBJECT esp_Closed
  methodID:LONG
ENDOBJECT

OBJECT esp_Read
  methodID:LONG
  buffer:PTR TO CHAR
  len:LONG
ENDOBJECT

OBJECT esp_ReadRaw
  methodID:LONG
  buffer:PTR TO CHAR
  len:LONG
ENDOBJECT

OBJECT esp_Write
  methodID:LONG
  buffer:PTR TO CHAR
  len:LONG
  flags:LONG
ENDOBJECT

OBJECT esp_WriteAll
  methodID:LONG
  buffer:PTR TO CHAR
  len:LONG
  flags:LONG
  ignoreObj:PTR TO object_
ENDOBJECT

OBJECT esp_Shutdown
   methodOID:LONG
   how:LONG
ENDOBJECT

/*
 * UDPSocket.class
 */

CONST ES_UDPSocketBase=TAG_USER+$30000

/*
 *  SocketServer.class
 */

CONST ES_ServerBase=TAG_USER+$40000

CONST ESA_Server_Backlog=ES_ServerBase+0  /* is.  ULONG  Defaults to 3  */
CONST ESA_Server_SocketClassPtr=ES_ServerBase+1  /* is.  APTR  *REQUIRED*  */
CONST ESA_Server_MaxConnections=ES_ServerBase+2  /* is.  ULONG  Defaults to -1 (unlimited) */
CONST ESA_Server_SocketTags=ES_ServerBase+3     /* is.  taglist */

/*
 * UDPServer.class
 */

CONST ES_UDPServerBase=TAG_USER+$50000

CONST ESM_UDPServer_FuzzyMsg=ES_UDPServerBase+0

OBJECT esp_FuzzyMsg
  methodID:LONG
  buf:PTR TO LONG
  len:LONG
  sockaddr_in:PTR TO LONG
ENDOBJECT

OBJECT easySocketApp   /* SocketApplication.class */
  private0:LONG
  private1:LONG
  private2:LONG
  private3:LONG
  private4:LONG
  esa_BSDSocketBase:PTR TO LONG  /* may be NIL */
  /* private data follows... */
ENDOBJECT

OBJECT easySocket
   private5[20]:ARRAY
   esd_BSDSocketBase:PTR TO LONG /* may be NULL */
   esd_UserData:PTR TO LONG
   esd_ParentObject:PTR TO LONG     /* parent object or NULL */
   esd_AppObject:PTR TO LONG        /* pointer to app object or NULL */
   esd_Socket:LONG            /* socket descriptor, -1 if no socket */
   /* private data follows... */
ENDOBJECT


/* Error codes for ESP_Error->classError  */

CONST ESV_ERROR_NO_SOCKETLIB=1  /* Couldn't open bsdsocket.library  */
CONST ESV_ERROR_PACKET_LOST=2  /* Fatal UDP packet loss            */
CONST ESV_ERROR_UDP_INIT_FAILED=3  /* Couldn't init UDP                */
CONST ESV_ERROR_NO_MEMORY=4  /* Out of memory                    */
