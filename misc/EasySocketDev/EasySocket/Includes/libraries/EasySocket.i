*-----------------------------------------------*
*       Class Structure 			*
*       					*
*       Rootclass       			*
*       	|       			*
*       	*----Application		*
*       	*----Socket     		*
*       	|       |       		*
*       	|       \----Server     	*
*       	|       			*
*       	\----UDPSocket  		*
*       		|       		*
*       		\----UDPServer  	*
*-----------------------------------------------*

	IFND    EXEC_TYPES_I
	INCLUDE "exec/types.i"
	ENDC    ; EXEC_TYPES_I

	IFND    EXEC_LISTS_I
	INCLUDE "exec/lists.i"
	ENDC    ; EXEC_LISTS_I

	IFND    DEVICES_TIMER_I
	iNCLUDE "devices/timer.i"
	ENDC    ; DEVICES_TIMER_I

	IFND    NETINET_IN_I
	INCLUDE "MiamiSDK/netinet/in.i"
	ENDC    ; NETINET_IN_I

	IFND    SYS_SOCKET_I
	INCLUDE "MiamiSDK/sys/socket.i"
	ENDC    ; SYS_SOCKET_I


ESOCKETAPPNAME  MACRO
	dc.b    'SocketApplication.class',0
	ENDM

ESOCKETNAME     MACRO
	dc.b    'Socket.class',0
	ENDM

ESERVERNAME     MACRO
	dc.b    'SocketServer.class',0
	ENDM

EASYSOCKETCLASSNAME     MACRO
	dc.b    'EasySocket.class',0
	ENDM

EASYSERVERCLASSNAME     MACRO
	dc.b    'EasyServer.class',0
	ENDM

EUDPSOCKETNAME  MACRO
	dc.b    UDPSocket.class',0
	ENDM

EUDPSERVERNAME  MACRO
	dc.b    'UDPServer.class',0
	ENDM

DEF_PUDDLE_SIZE 	EQU     16384
DEF_TRESH_SIZE  	EQU     16000

EasySocketVersion       EQU     1
EasySocketRevision      EQU     0

	STRUCTURE EasySocketBase,LIB_SIZE
	WORD    ES_Pad
	APTR    ES_SegList
	APTR    ES_SocketClass  	; Base class
	APTR    ES_SocketAppClass
	APTR    ES_ServerClass
	LABEL   EasySocketLib_SIZEOF

**      Library Functions

_LVOES_MakeClass	EQU     -30
_LVOES_MakeClientObject EQU     -36
_LVOES_MakeServerObject EQU     -42


**      Definitions for ES_MakeClass()

ESV_MakeClass_Socket    	EQU     0
ESV_MakeClass_App       	EQU     1
ESV_MakeClass_Server    	EQU     2
ESV_MakeClass_UDP       	EQU     3
ESV_MakeClass_UDPServer 	EQU     4
ESV_MakeClass_EasySocket	EQU     5
ESV_MakeClass_EasyServer	EQU     6


ES_USER_TAGS	EQU	$F0000000       ; Use this for your _private_ classes


ESV_Socket_EventClose_RC_NoDispose      EQU     -1
ESV_Socket_EventClose_RC_Dispose	EQU     0

*-------------------------------*
*       SocketApp.class 	*
*-------------------------------*

ES_Application_Dummy    	EQU     TAG_USER+$10000
wES_Application_Dummy   	EQU     $8001

ESM_Application_GetSocketEvent  	EQU     ES_Application_Dummy+0
ESM_Application_AllocPollKey    	EQU     ES_Application_Dummy+1
ESM_Application_AddEventHandler 	EQU     ES_Application_Dummy+2
ESM_Application_RemoveEventHandler      EQU     ES_Application_Dummy+3
ESM_Application_AllocMem		EQU     ES_Application_Dummy+4
ESM_Application_FreeMem 		EQU     ES_Application_Dummy+5

ESA_Application_Child   	EQU     ES_Application_Dummy+0  ; is.   Object  *
ESA_Application_ErrorString     EQU     ES_Application_Dummy+2  ; ..g   LONG
ESA_Application_MaxSockets      EQU     ES_Application_Dummy+3  ; i..   LONG    Defaults to 64
ESA_Application_UserName	EQU     ES_Application_Dummy+4  ; ..g   char    *
ESA_Application_UNUSED_TAG      EQU     ES_Application_Dummy+5  ;
ESA_Application_LocalAddress    EQU     ES_Application_Dummy+6  ; ..g   LONG
ESA_Application_LocalHostName   EQU     ES_Application_Dummy+7  ; ..g   char    *

*-------------------------------*
*       Socket.class    	*
*-------------------------------*

ES_SocketBase   		EQU     TAG_USER+$20000

ESM_Socket_EventAccept  	EQU     ES_SocketBase+1 	; MethodID, NewObj (ULONG, APTR)
ESM_Socket_EventConnected       EQU     ES_SocketBase+2
ESM_Socket_EventOOB     	EQU     ES_SocketBase+3
ESM_Socket_EventRead    	EQU     ES_SocketBase+4
ESM_Socket_EventWrite   	EQU     ES_SocketBase+5
ESM_Socket_Error		EQU     ES_SocketBase+6 	; MethodID, ErrorCode (ULONG, ULONG)
ESM_Socket_EventClosed  	EQU     ES_SocketBase+7
ESM_Socket_Open 		EQU     ES_SocketBase+9
ESM_Socket_Close		EQU     ES_SocketBase+10
ESM_Socket_ReadRaw      	EQU     ES_SocketBase+12
ESM_Socket_Read 		EQU     ES_SocketBase+13
ESM_Socket_Write		EQU     ES_SocketBase+14	; MethodID, buf, len, flags
ESM_Socket_WriteAll     	EQU     ES_SocketBase+17	; MethodID, buf, len, flags, IgnoreObj
ESM_Socket_Shutdown     	EQU     ES_SocketBase+19
ESM_Socket_SetURI       	EQU     ES_SocketBase+21	; MethodID, URI, defaultPort, flags

ESA_Socket_Child		EQU     ES_SocketBase+0 	; i..   Object *
ESA_Socket_MsgBufSize   	EQU     ES_SocketBase+1 	; i..   LONG    Defaults to 8192
ESA_Socket_Socket       	EQU     ES_SocketBase+3 	; ..g   LONG    *PRIVATE*
ESA_Socket_UserData     	EQU     ES_SocketBase+4 	; is.
ESA_Socket_Flags		EQU     ES_SocketBase+5 	; is.   ULONG
ESA_Socket_RequestEvents	EQU     ES_SocketBase+6 	; is.   ULONG   Defaults to ESV_Socket_RequestEvents_Client
ESA_Socket_HostName     	EQU     ES_SocketBase+7 	; isg   APTR    Defaults to NULL (ESV_Client_HostName_Server)
ESA_Socket_HostPort     	EQU     ES_SocketBase+8 	; is.   LONG    (UWORD)
ESA_Socket_Type 		EQU     ES_SocketBase+10	; is.   LONG    Defaults to #SOCK_STREAM
ESA_Socket_Resource     	EQU     ES_SocketBase+13	; is.   APTR    No default
ESA_Socket_RemoteIP     	EQU     ES_SocketBase+15	; ..g   char *
ESA_Socket_RemoteAddr   	EQU     ES_SocketBase+16	; ..g   ULONG
ESA_Socket_ObjList      	EQU     ES_SocketBase+17	; ..g
ESA_Socket_AllowUDP     	EQU     ES_SocketBase+18	; is.   BOOL
ESA_Socket_FellowPort   	EQU     ES_SocketBase+19	; isg   LONG    (UWORD)
ESA_Socket_NBIO 		EQU     ES_SocketBase+20	; is.   BOOL
ESA_Socket_AsyncIO      	EQU     ES_SocketBase+21	; is.   BOOL
ESA_Socket_NoDelay      	EQU     ES_SocketBase+22	; is.   BOOL
ESA_Socket_OOBInline    	EQU     ES_SocketBase+23	; is.   BOOL
ESA_Socket_KeepAlive    	EQU     ES_SocketBase+24	; is.   BOOL
ESA_Socket_UserAgent    	EQU     ES_SocketBase+25	; is.   char *  Default depends on subclass

ESV_Socket_Flags_Set    	EQU     $80000000
ESV_Socket_Flags_Clear  	EQU     $00000000

ESV_Socket_Flags_NBIO   	EQU     $40000000       ; Non-blocking I/O
ESV_Socket_Flags_AsyncIO	EQU     $20000000       ; Asynchronous I/O
ESV_Socket_Flags_NoDelay	EQU     $10000000       ; Disable Nagle buffering algorithm
ESV_Socket_Flags_OOBInline      EQU     $08000000       ; OOB Inline
ESV_Socket_Flags_KeepAlive      EQU     $04000000       ; Keep alive
ESV_Socket_Flags_Default	EQU     $e0000000


** Flags for ESM_Socket_Write   **

ESV_Socket_Write_UseUDP EQU     $80000000
ESV_Socket_Write_NoAck  EQU     $40000000       ; UDP specific flag
ESV_Socket_Write_OOB    EQU     $00000001

	BITDEF  ESV,Socket_Write_OOB,0
	BITDEF  ESV,Socket_Write_NoAck,30
	BITDEF  ESV,Socket_Write_UseUDP,31


** Special values for ESA_Socket_RequestEvents

ESV_Socket_RequestEvents_Client EQU     $6E
ESV_Socket_RequestEvents_Server EQU     $61
ESV_Socket_RequestEvents_UDP    EQU     $6E

** Values for ESM_Socket_Shutdown

ESV_Socket_Shutdown_Receive     EQU     0
ESV_Socket_Shutdown_Send	EQU     1
ESV_Socket_Shutdown_Both	EQU     2

** Flags for ESM_Socket_SetURI **

	BITDEF  ESV,Socket_SetURI_IgnoreProtocol,0

*---------------------------------------*
*       UDPSocket.class 		*
*---------------------------------------*

ES_UDPSocketBase		EQU     TAG_USER+$30000


*---------------------------------------*
*       SocketServer.class      	*
*---------------------------------------*

ES_ServerBase   		EQU     TAG_USER+$40000
wES_ServerBase  		EQU     $8004

ESA_Server_Backlog      	EQU     ES_ServerBase+0 ; is.   ULONG   Defaults to 3
ESA_Server_SocketClassPtr       EQU     ES_ServerBase+1 ; is.   APTR    *REQUIRED*
ESA_Server_MaxConnections       EQU     ES_ServerBase+2 ; is.   ULONG   Defaults to -1 (unlimited)
ESA_Server_SocketTags   	EQU     ES_ServerBase+3 ; is.   APTR


*---------------------------------------*
*       UDPServer.class 		*
*---------------------------------------*

ES_UDPServerBase		EQU     TAG_USER+$50000

ESM_UDPServer_FuzzyMsg  	EQU     ES_UDPServerBase+0
ESM_UDPServer_WriteTo   	EQU     ES_UDPServerBase+1


	STRUCTURE SocketEventHandler,MLN_SIZE
	ULONG   seh_Signals
	APTR	seh_Object
	ULONG	seh_Method
	ULONG   seh_Flags       			; Init to ZERO
	LABEL	SocketEventHandler_SIZEOF

	; Socket Application

	STRUCTURE EasySocketApp,20       		; SocketApplication.class
	APTR    ESA_BSDSocketBase       		; Static


	STRUCTURE Socket,20     			; Socket.class (base class for all kind of sockets)
	APTR    ESD_BSDSocketBase       		; OM_ADDMEMBER
	APTR    ESD_UserData
	APTR    ESD_ParentObject			; OM_ADDMEMBER
	APTR    ESD_AppObject   			; OM_ADDMEMBER
	LONG    ESD_Socket

ESV_ERROR_NO_SOCKETLIB  	EQU     1       ; Couldn't open bsdsocket.library
ESV_ERROR_PACKET_LOST   	EQU     2       ; Fatal UDP packet loss
ESV_ERROR_UDP_INIT_FAILED       EQU     3       ; Couldn't init UDP
ESV_ERROR_NO_MEMORY     	EQU     4       ; Out of memory
