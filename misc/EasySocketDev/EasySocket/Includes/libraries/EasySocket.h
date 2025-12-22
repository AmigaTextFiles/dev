#ifndef  LIBRARIES_EASYSOCKET_H
#define LIBRARIES_EASYSOCKET_H TRUE

/*	EasySocket.library
 *
 *	13-jan-2002
 *
 *	Ilkka Lehtoranta ilkleht@isoveli.org
 *
 *
 * Class Structure
 *
 * Rootclass
 * 	|
 * 	*----Application
 * 	*----Socket
 * 		  	|
 * 		  	\----Server
 */

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#define SocketClass  	"Socket.class"
#define ServerClass  	"SocketServer.class"
#define SocketAppClass  "SocketApplication.class"

#define EasySocketVersion  1
#define EasySocketRevision 0

struct EasySocketBase {
	struct	Library LibNode;
	UWORD 	pad;
	APTR  	SegList;
	struct	IClass *ES_SocketClass;
	struct	IClass *ES_SocketAppClass;
	struct	IClass *ES_ServerClass;
};

#define ES_USER_TAGS 0xf0000000  /* Use this for your _private_ classes */
											/* if you need to create a public class
												mail ilkleht@isoveli.org				*/

/* Definitions for ES_MakeClass() */

#define ESV_MakeClass_Socket  	0
#define ESV_MakeClass_App  		1
#define ESV_MakeClass_Server  	2

/****************************************
** Macros		 		 **
****************************************/

#define SocketObject 	NewObject(NULL,SocketClass
#define ServerObject 	NewObject(NULL,ServerClass
#define SocketAppObject NewObject(NULL,SocketAppClass

#ifndef End
#define End 			TAG_DONE)
#endif

/*
 * SocketApp.class
 */

#define ES_Application_Dummy  TAG_USER+0x10000

#define ESM_Application_GetSocketEvent 		ES_Application_Dummy+0
#define ESM_Application_AddEventHandler		ES_Application_Dummy+2
#define ESM_Application_RemoveEventHandler	ES_Application_Dummy+3
#define ESM_Application_AllocMem 				ES_Application_Dummy+4
#define ESM_Application_FreeMem  				ES_Application_Dummy+5

#define ESA_Application_Child 			ES_Application_Dummy+0  /* is.	Object * 	*/
#define ESA_Application_ErrorString 	ES_Application_Dummy+2  /* ..g	LONG  		*/
#define ESA_Application_MaxSockets  	ES_Application_Dummy+3  /* i..	LONG  		*/
#define ESA_Application_UserName 		ES_Application_Dummy+4  /* ..g	char *		*/
#define ESA_Application_LocalAddress	ES_Application_Dummy+6  /* ..g	LONG  		*/
#define ESA_Application_LocalHostName  ES_Application_Dummy+7  /* ..g	char *		*/


struct ESP_GetSocketEvents 	{ ULONG MethodID; ULONG sigs; };
struct ESP_AddEventHandler 	{ ULONG MethodID; struct ES_EventHandler *ehnode; };
struct ESP_RemoveEventHandler { ULONG MethodID; struct ES_EventHandler *ehnode; };
struct ESP_AllocMem  			{ ULONG MethodID; LONG byteSize };
struct ESP_FreeMem				{ ULONG MethodID; void *memoryBlock };

struct ES_EventHandler
{
	struct	MinNode Node;
	ULONG 	signals;
	Object	obj;
	ULONG 	method;
	ULONG 	flags;
};

/*
 * Socket.class
 */

#define ES_SocketBase	TAG_USER+0x20000

#define ESM_Socket_EventAccept		ES_SocketBase+1
#define ESM_Socket_EventConnected	ES_SocketBase+2
#define ESM_Socket_EventOOB			ES_SocketBase+3
#define ESM_Socket_EventRead  		ES_SocketBase+4
#define ESM_Socket_EventWrite 		ES_SocketBase+5
#define ESM_Socket_Error		 		ES_SocketBase+6
#define ESM_Socket_EventClosed		ES_SocketBase+7
#define ESM_Socket_Open 		 		ES_SocketBase+9
#define ESM_Socket_Close		 		ES_SocketBase+10
#define ESM_Socket_ReadRaw 			ES_SocketBase+12
#define ESM_Socket_Read					ES_SocketBase+13
#define ESM_Socket_Write		 		ES_SocketBase+14
#define ESM_Socket_WriteAll			ES_SocketBase+17
#define ESM_Socket_Shutdown			ES_SocketBase+19
#define ESM_Socket_SetURI  			ES_SocketBase+21

#define ESA_Socket_Child	 		ES_SocketBase+0   /* i..   Object *			 */
#define ESA_Socket_MsgBufSize 	ES_SocketBase+1	/* i..	ULONG Defaults to 8192  */
#define ESA_Socket_UserData		ES_SocketBase+4	/* is.	*/
#define ESA_Socket_Flags	 		ES_SocketBase+5   /* is.   ULONG */
#define ESA_Socket_RequestEvents ES_SocketBase+6	/* is.	ULONG Defaults to ESV_Socket_RequestEvents_Client  	*/
#define ESA_Socket_HostName		ES_SocketBase+7	/* isg	APTR  Defaults to NULL (ESV_Socket_HostName_Server)	*/
#define ESA_Socket_HostPort		ES_SocketBase+8	/* is.	UWORD 				*/
#define ESA_Socket_Type 	 		ES_SocketBase+10  /* is.   ULONG Defaults to #SOCK_STREAM   */
#define ESA_Socket_RemoteIP		ES_SocketBase+15  /* ..g	char  *  			*/
#define ESA_Socket_RemoteAddr 	ES_SocketBase+16  /* ..g	ULONG 				*/
#define ESA_Socket_ObjList 		ES_SocketBase+17  /* ..g		 		  */
#define ESA_Socket_AllowUDP		ES_SocketBase+18  /* is.	BOOL  Defaults to FALSE 			*/
#define ESA_Socket_FellowPort 	ES_SocketBase+19  /* isg	UWORD 	*/
#define ESA_Socket_NBIO 	 		ES_SocketBase+20  /* is.   BOOL 	 */
#define ESA_Socket_AsyncIO 		ES_SocketBase+21  /* is.	BOOL  	*/
#define ESA_Socket_NoDelay 		ES_SocketBase+22  /* is.	BOOL  	*/
#define ESA_Socket_OOBInline  	ES_SocketBase+23  /* is.	BOOL  	*/
#define ESA_Socket_KeepAlive  	ES_SocketBase+24  /* is.	BOOL  	*/
#define ESA_Socket_UserAgent  	ES_SocketBase+25  /* is.	char *	Default depends on subclass	*/


/* Flag definitions for ESA_Socket_Flags  */

#define ESV_Socket_Flags_Set  	0x80000000
#define ESV_Socket_Flags_Clear	0x00000000

#define ESV_Socket_Flags_NBIO 		0x40000000  /* Non-blocking I/O  				 */
#define ESV_Socket_Flags_ASyncIO 	0x20000000  /* Asynchronous I/O  				 */
#define ESV_Socket_Flags_NoDelay 	0x10000000  /* Disable Nagle buffering algorithm	*/
#define ESV_Socket_Flags_OOBInline  0x08000000  /* Inline out-of-band data 				*/
#define ESV_Socket_Flags_KeepAlive  0x04000000  /* Keep alive   				 */
#define ESV_Socket_Flags_Default 	0xe0000000  /* Default setting					 */

/* Flags for ESM_Socket_Write */

#define ESV_Socket_Write_UseUDP  0x80000000
#define ESV_Socket_Write_NoAck	0x40000000  /* UDP specific flag */
#define ESV_Socket_Write_OOB  	0x00000001

/* Special values for ESA_Socket_RequestEvents */

#define ESV_Socket_RequestEvents_Client	0x6E  /* Socket.class	*/
#define ESV_Socket_RequestEvents_Server	0x61  /* SocketServer.class	*/

/* Values for ESM_Socket_Shutdown	*/

#define ESV_Socket_Shutdown_Receive 0
#define ESV_Socket_Shutdown_Send 	1
#define ESV_Socket_Shutdown_Both 	2


struct ESP_EventAccept  	{ ULONG MethodID; };
struct ESP_EventClosed  	{ ULONG MethodID; };
struct ESP_EventConnected  { ULONG MethodID; };
struct ESP_EventRead 		{ ULONG MethodID; };
struct ESP_EventOOB  		{ ULONG MethodID; };
struct ESP_EventWrite		{ ULONG MethodID; };
struct ESP_Error				{ ULONG MethodID; LONG primaryError; ULONG classError};
struct ESP_Closed 			{ ULONG MethodID; };
struct ESP_ReadRaw			{ ULONG MethodID; APTR buf; ULONG len; };
struct ESP_Read 				{ ULONG MethodID; APTR buf; ULONG len; };
struct ESP_Write				{ ULONG MethodID; APTR buf; ULONG len; ULONG flags; };
struct ESP_WriteAll  		{ ULONG MethodID; APTR buf; ULONG len; ULONG flags; Object *IgnoreObj; };
struct ESP_Shutdown  		{ ULONG MethodID; LONG how; };
struct ESP_SetURI 			{ ULONG MethodID; APTR uri; LONG port; ULONG flags; };

/*
 * SocketServer.class
 */

#define ES_ServerBase			TAG_USER+0x40000

#define ESA_Server_Backlog 			ES_ServerBase+0	/* is.	ULONG Defaults to 3  */
#define ESA_Server_SocketClassPtr	ES_ServerBase+1	/* is.	APTR  *REQUIRED*  */
#define ESA_Server_MaxConnections	ES_ServerBase+2	/* is.	ULONG Defaults to -1 (unlimited) */
#define ESA_Server_SocketTags 		ES_ServerBase+3	/* is.	APTR  taglist  */


struct EasySocketApp {  		/* SocketApplication.class */
	char  private[20];
	APTR  ESA_BSDSocketBase;	/* may be NULL */
	/* private data follows... */
};


struct EasySocket {
	char  private[20];
	APTR  ESD_BSDSocketBase;	/* may be NULL */
	APTR  ESD_UserData;
	APTR  ESD_ParentObject; 	/* parent object or NULL */
	APTR  ESD_AppObject; 		/* pointer to app object or NULL */
	LONG  ESD_Socket; 			/* socket descriptor, -1 if no socket */
	/* private data follows... */
};

/* Error codes for ESP_Error->classError	*/

#define ESV_ERROR_NO_SOCKETLIB  		1	/* Couldn't open bsdsocket.library	*/
#define ESV_ERROR_PACKET_LOST   		2	/* Fatal UDP packet loss				*/
#define ESV_ERROR_UDP_INIT_FAILED	3	/* Couldn't init UDP						*/
#define ESV_ERROR_NO_MEMORY			4	/* Out of memory							*/

#endif	/* LIBRARIES_EASYSOCKET_H */