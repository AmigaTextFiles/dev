/* $Id: sana2.h,v 1.12 2005/11/10 15:31:33 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/ports', 'target/exec/io', 'target/exec/tasks', 'target/exec/errors', 'target/devices/timer', 'target/utility/tagitem', 'target/utility/hooks'
MODULE 'target/exec/lists', 'target/exec/nodes'
{#include <devices/sana2.h>}
NATIVE {DEVICES_SANA2_H} CONST

NATIVE {SANA2_MAX_ADDR_BITS}  CONST SANA2_MAX_ADDR_BITS  = (128)
NATIVE {SANA2_MAX_ADDR_BYTES} CONST SANA2_MAX_ADDR_BYTES = ((SANA2_MAX_ADDR_BITS+7)/8)

NATIVE {IOSana2Req} OBJECT iosana2req
    {ios2_Req}	io	:io

    {ios2_WireError}	wireerror	:ULONG                     /* wire type specific error */
    {ios2_PacketType}	packettype	:ULONG                    /* packet type */
    {ios2_SrcAddr}	srcaddr[SANA2_MAX_ADDR_BYTES]	:ARRAY OF UBYTE /* source address */
    {ios2_DstAddr}	dstaddr[SANA2_MAX_ADDR_BYTES]	:ARRAY OF UBYTE /* dest address */
    {ios2_DataLength}	datalength	:ULONG                    /* length of packet data */
    {ios2_Data}	data	:APTR                          /* packet data */
    {ios2_StatData}	statdata	:APTR                      /* statistics data pointer */
    {ios2_BufferManagement}	buffermanagement	:APTR              /* see SANA-II OpenDevice adoc */
ENDOBJECT

/*
** Defines for the io_Flags field
*/
NATIVE {SANA2IOB_RAW}   CONST SANA2IOB_RAW   = (7)         /* raw packet IO requested */
NATIVE {SANA2IOB_BCAST} CONST SANA2IOB_BCAST = (6)         /* broadcast packet (received) */
NATIVE {SANA2IOB_MCAST} CONST SANA2IOB_MCAST = (5)         /* multicast packet (received) */
NATIVE {SANA2IOB_QUICK} CONST SANA2IOB_QUICK = (IOB_QUICK) /* quick IO requested (0) */

NATIVE {SANA2IOF_RAW}   CONST SANA2IOF_RAW   = 128
NATIVE {SANA2IOF_BCAST} CONST SANA2IOF_BCAST = 64
NATIVE {SANA2IOF_MCAST} CONST SANA2IOF_MCAST = 32
NATIVE {SANA2IOF_QUICK} CONST SANA2IOF_QUICK = (IOF_QUICK)

/*
** Defines for OpenDevice() flags
*/
NATIVE {SANA2OPB_MINE} CONST SANA2OPB_MINE = (0) /* exclusive access requested */
NATIVE {SANA2OPB_PROM} CONST SANA2OPB_PROM = (1) /* promiscuous mode requested */

NATIVE {SANA2OPF_MINE} CONST SANA2OPF_MINE = $1
NATIVE {SANA2OPF_PROM} CONST SANA2OPF_PROM = $2

/*
** Defines for OpenDevice() tags
*/
NATIVE {S2_Dummy}             CONST S2_DUMMY             = (TAG_USER + $B0000)

NATIVE {S2_CopyToBuff}        CONST S2_COPYTOBUFF        = (S2_DUMMY +  1)
NATIVE {S2_CopyFromBuff}      CONST S2_COPYFROMBUFF      = (S2_DUMMY +  2)
NATIVE {S2_PacketFilter}      CONST S2_PACKETFILTER      = (S2_DUMMY +  3)
NATIVE {S2_CopyToBuff16}      CONST S2_COPYTOBUFF16      = (S2_DUMMY +  4)
NATIVE {S2_CopyFromBuff16}    CONST S2_COPYFROMBUFF16    = (S2_DUMMY +  5)
NATIVE {S2_CopyToBuff32}      CONST S2_COPYTOBUFF32      = (S2_DUMMY +  6)
NATIVE {S2_CopyFromBuff32}    CONST S2_COPYFROMBUFF32    = (S2_DUMMY +  7)
NATIVE {S2_DMACopyToBuff32}   CONST S2_DMACOPYTOBUFF32   = (S2_DUMMY +  8)
NATIVE {S2_DMACopyFromBuff32} CONST S2_DMACOPYFROMBUFF32 = (S2_DUMMY +  9)
NATIVE {S2_DMACopyToBuff64}   CONST S2_DMACOPYTOBUFF64   = (S2_DUMMY + 10)
NATIVE {S2_DMACopyFromBuff64} CONST S2_DMACOPYFROMBUFF64 = (S2_DUMMY + 11)
NATIVE {S2_Log}               CONST S2_LOG               = (S2_DUMMY + 12)

/*
** Filled in by 'S2_DEVICEQUERY'
*/
NATIVE {Sana2DeviceQuery} OBJECT sana2devicequery
    /*
    ** Standard information
    */
    {SizeAvailable}	sizeavailable	:ULONG  /* bytes available */
    {SizeSupplied}	sizesupplied	:ULONG   /* bytes supplied */
    {DevQueryFormat}	devqueryformat	:ULONG /* this is type 0 */
    {DeviceLevel}	devicelevel	:ULONG    /* this document is level 0 */
    /*
    ** Common information
    */
    {AddrFieldSize}	addrfieldsize	:UINT  /* address size in bits */
    {MTU}	mtu	:ULONG            /* maximum packet data size */
    {BPS}	bps	:ULONG            /* line rate (bits/sec) */
    {HardwareType}	hardwaretype	:ULONG   /* what the wire is (see below) */
    {RawMTU}	rawmtu	:ULONG         /* maximum raw packet data size */
    /*
    ** Format specific information
    */
ENDOBJECT

/*
** Defined Hardware types
**
**  If your hardware type is not listed below contact Amiga to get
**  a new type number added for your hardware.
*/
NATIVE {S2WireType_Ethernet}    CONST S2WIRETYPE_ETHERNET    = 1
NATIVE {S2WireType_IEEE802}     CONST S2WIRETYPE_IEEE802     = 6
NATIVE {S2WireType_Arcnet}      CONST S2WIRETYPE_ARCNET      = 7
NATIVE {S2WireType_LocalTalk}  CONST S2WIRETYPE_LOCALTALK  = 11
NATIVE {S2WireType_DyLAN}      CONST S2WIRETYPE_DYLAN      = 12

NATIVE {S2WireType_AmokNet}   CONST S2WIRETYPE_AMOKNET   = 200 /* Amiga Floppy Port hardware */

NATIVE {S2WireType_Liana}     CONST S2WIRETYPE_LIANA     = 202 /* Village Tronic parallel port hw */

NATIVE {S2WireType_PPP}       CONST S2WIRETYPE_PPP       = 253
NATIVE {S2WireType_SLIP}      CONST S2WIRETYPE_SLIP      = 254
NATIVE {S2WireType_CSLIP}     CONST S2WIRETYPE_CSLIP     = 255 /* Compressed SLIP */

NATIVE {S2WireType_PLIP}      CONST S2WIRETYPE_PLIP      = 420 /* SLIP over a parallel port */

/*
** Filled in by 'S2_GETTYPESTATS'
*/
NATIVE {Sana2PacketTypeStats} OBJECT sana2packettypestats
    {PacketsSent}	packetssent	:ULONG     /* transmitted count */
    {PacketsReceived}	packetsreceived	:ULONG /* received count */
    {BytesSent}	bytessent	:ULONG       /* bytes transmitted count */
    {BytesReceived}	bytesreceived	:ULONG   /* bytes received count */
    {PacketsDropped}	packetsdropped	:ULONG  /* packets dropped count */
ENDOBJECT

/*
** Filled in by 'S2_GETSPECIALSTATS'
*/
NATIVE {Sana2SpecialStatRecord} OBJECT sana2specialstatrecord
    {Type}	type	:ULONG   /* statistic identifier */
    {Count}	count	:ULONG  /* the statistic */
    {String}	string	:ARRAY OF CHAR /*STRPTR*/ /* statistic name */
ENDOBJECT

NATIVE {Sana2SpecialStatHeader} OBJECT sana2specialstatheader
    {RecordCountMax}	recordcountmax	:ULONG      /* room available */
    {RecordCountSupplied}	recordcountsupplied	:ULONG /* number supplied */
    /* struct Sana2SpecialStatRecord[RecordCountMax]; */
ENDOBJECT

/*
** Filled in by 'S2_GETGLOBALSTATS'
*/
NATIVE {Sana2DeviceStats} OBJECT sana2devicestats
    {PacketsReceived}	packetsreceived	:ULONG      /* received count */
    {PacketsSent}	packetssent	:ULONG          /* transmitted count */
    {BadData}	baddata	:ULONG              /* bad packets received */
    {Overruns}	overruns	:ULONG             /* hardware miss count */
    {Unused}	unused	:ULONG               /* Unused field */
    {UnknownTypesReceived}	unknowntypesreceived	:ULONG /* orphan count */
    {Reconfigurations}	reconfigurations	:ULONG     /* network reconfigurations */
    {LastStart}	laststart	:timeval            /* time of last online */
ENDOBJECT

/*
** A 64 bit big endian integer in ISO 'C' terms. You can
** override this if you plan to provide your own 64 bit
** integer type.
*/
->#ifndef __S2QUAD_DEFINED
NATIVE {S2QUAD} OBJECT s2quad
    {s2q_High}	high	:ULONG
    {s2q_Low}	low	:ULONG
ENDOBJECT
->#endif /* __S2QUAD_DEFINED */

/*
** Revised version, filled in by 'S2_GETEXTENDEDGLOBALSTATS'
*/
NATIVE {Sana2ExtDeviceStats} OBJECT sana2extdevicestats
    {s2xds_Length}	length	:ULONG
    {s2xds_Actual}	actual	:ULONG

    {s2xds_PacketsReceived}	packetsreceived	:s2quad
    {s2xds_PacketsSent}	packetssent	:s2quad
    {s2xds_BadData}	baddata	:s2quad
    {s2xds_Overruns}	overruns	:s2quad
    {s2xds_UnknownTypesReceived}	unknowntypesreceived	:s2quad
    {s2xds_Reconfigurations}	reconfigurations	:s2quad
    {s2xds_LastStart}	laststart	:timeval

    {s2xds_LastConnected}	lastconnected	:timeval
    {s2xds_LastDisconnected}	lastdisconnected	:timeval
    {s2xds_TimeConnected}	timeconnected	:timeval
ENDOBJECT

/*
** Used by 'S2_CONNECT' and 'S2_DISCONNECT'
*/
NATIVE {Sana2Connection} OBJECT sana2connection
   {s2c_Size}	size	:ULONG
   {s2c_Options}	options	:mlh
   {s2c_ErrorHook}	errorhook	:hook
   {s2c_ConnectHook}	connecthook	:hook
   {s2c_DisconnectHook}	disconnecthook	:hook
   {s2c_Login}	login	:ARRAY OF CHAR /*STRPTR*/
   {s2c_Password}	password	:ARRAY OF CHAR /*STRPTR*/
ENDOBJECT

NATIVE {Sana2ConnectionOption} OBJECT sana2connectionoption
   {s2co_MinNode}	minnode	:mln
   {s2co_Name}	name	:ARRAY OF CHAR /*STRPTR*/
   {s2co_Value}	value	:ARRAY OF CHAR /*STRPTR*/
ENDOBJECT

NATIVE {Sana2ConnectionMessage} OBJECT sana2connectionmessage
   {s2cm_Size}	size	:ULONG
   {s2cm_Connection}	connection	:PTR TO sana2connection
   {s2cm_Request}	request[2]	:ARRAY OF PTR TO io
   {s2cm_RequestType}	requesttype	:VALUE
ENDOBJECT

/*
** Used by 'S2_SAMPLE_THROUGHPUT'
*/
NATIVE {Sana2ThroughputStats} OBJECT sana2throughputstats
   {s2ts_Length}	length	:ULONG
   {s2ts_Actual}	actual	:ULONG

   {s2ts_NotifyTask}	notifytask	:PTR TO tc
   {s2ts_NotifyMask}	notifymask	:ULONG

   {s2ts_StartTime}	starttime	:timeval
   {s2ts_EndTime}	endtime	:timeval
   {s2ts_BytesSent}	bytessent	:s2quad
   {s2ts_BytesReceived}	bytesreceived	:s2quad
   {s2ts_Updates}	updates	:s2quad
ENDOBJECT

/*
** Used by the 'S2_Log' callback hook
*/
NATIVE {S2LogMessage} OBJECT s2logmessage
   {s2lm_Size}	size	:VALUE
   {s2lm_Priority}	priority	:ULONG
   {s2lm_Name}	name	:ARRAY OF CHAR /*STRPTR*/
   {s2lm_Message}	message	:ARRAY OF CHAR /*STRPTR*/
ENDOBJECT

/*
** Installed by the 'S2_SANA2HOOK' command.
*/
NATIVE {Sana2Hook} OBJECT sana2hook
   {s2h_Hook}	hook	:hook    /* The hook to invoke */
   {s2h_Methods}	methods	:PTR TO TAG /* Which methods the hook supports */
ENDOBJECT

/*
** Generic hook message the SANA2Hook is invoked with. Check the
** shm_Method field to find out which specific message is used.
*/
NATIVE {SANA2HookMsg} OBJECT sana2hookmsg
   {shm_Method}	method	:ULONG  /* S2_CopyToBuff, S2_CopyFromBuff, etc. */
   {shm_MsgSize}	msgsize	:ULONG /* Size of message (in bytes) */
ENDOBJECT

/*
** Special hook message invoked for the S2_CopyTo../S2_CopyFrom..
** and S2_DMACopyTo../S2_DMACopyFrom.. functions.
*/
NATIVE {SANA2CopyHookMsg} OBJECT sana2copyhookmsg
    {schm_Method}	method	:ULONG  /* S2_CopyToBuff, S2_CopyFromBuff, etc. */
    {schm_MsgSize}	msgsize	:ULONG /* Size of message (in bytes) */

    {schm_To}	to	:APTR      /* Data destination */
    {schm_From}	from	:APTR    /* Data source */
    {schm_Size}	size	:ULONG    /* Number of bytes involved */
ENDOBJECT

/*
** Special hook message invoked for the S2_Log function.
*/
NATIVE {SANA2LogHookMsg} OBJECT sana2loghookmsg
    {slhm_Method}	method	:ULONG   /* S2_Log */
    {slhm_MsgSize}	msgsize	:ULONG  /* Size of message (in bytes) */

    {slhm_Priority}	priority	:ULONG /* Severity (S2LOG_Emergency, etc.) */
    {slhm_Name}	name	:ARRAY OF CHAR /*STRPTR*/     /* Identifies the source of the message */
    {slhm_Message}	message	:ARRAY OF CHAR /*STRPTR*/  /* The log message itself */
ENDOBJECT

/*
** Log priority levels used by the 'S2_Log' callback hook
*/
NATIVE {S2LOG_Emergency}   CONST S2LOG_EMERGENCY   = 0 /* A panic condition */
NATIVE {S2LOG_Alert}       CONST S2LOG_ALERT       = 1 /* A condition that should be corrected
                               immediately */
NATIVE {S2LOG_Critical}    CONST S2LOG_CRITICAL    = 2 /* Critical conditions */
NATIVE {S2LOG_Error}       CONST S2LOG_ERROR       = 3 /* A plain error */
NATIVE {S2LOG_Warning}     CONST S2LOG_WARNING     = 4 /* A warning message */
NATIVE {S2LOG_Notice}      CONST S2LOG_NOTICE      = 5 /* Conditions that are not error conditions,
                               but should possibly be handled specially */
NATIVE {S2LOG_Information} CONST S2LOG_INFORMATION = 6 /* An informational message */
NATIVE {S2LOG_Debug}       CONST S2LOG_DEBUG       = 7 /* Generated only in debugging mode */

/*
** Device Commands
*/
NATIVE {S2_START}               CONST S2_START               = (CMD_NONSTD)  /* First old style command */

NATIVE {S2_DEVICEQUERY}         CONST S2_DEVICEQUERY         = (S2_START+ 0)
NATIVE {S2_GETSTATIONADDRESS}   CONST S2_GETSTATIONADDRESS   = (S2_START+ 1)
NATIVE {S2_CONFIGINTERFACE}     CONST S2_CONFIGINTERFACE     = (S2_START+ 2)
NATIVE {S2_ADDMULTICASTADDRESS} CONST S2_ADDMULTICASTADDRESS = (S2_START+ 5)
NATIVE {S2_DELMULTICASTADDRESS} CONST S2_DELMULTICASTADDRESS = (S2_START+ 6)
NATIVE {S2_MULTICAST}           CONST S2_MULTICAST           = (S2_START+ 7)
NATIVE {S2_BROADCAST}           CONST S2_BROADCAST           = (S2_START+ 8)
NATIVE {S2_TRACKTYPE}           CONST S2_TRACKTYPE           = (S2_START+ 9)
NATIVE {S2_UNTRACKTYPE}         CONST S2_UNTRACKTYPE         = (S2_START+10)
NATIVE {S2_GETTYPESTATS}        CONST S2_GETTYPESTATS        = (S2_START+11)
NATIVE {S2_GETSPECIALSTATS}     CONST S2_GETSPECIALSTATS     = (S2_START+12)
NATIVE {S2_GETGLOBALSTATS}      CONST S2_GETGLOBALSTATS      = (S2_START+13)
NATIVE {S2_ONEVENT}             CONST S2_ONEVENT             = (S2_START+14)
NATIVE {S2_READORPHAN}          CONST S2_READORPHAN          = (S2_START+15)
NATIVE {S2_ONLINE}              CONST S2_ONLINE              = (S2_START+16)
NATIVE {S2_OFFLINE}             CONST S2_OFFLINE             = (S2_START+17)

NATIVE {S2_END}                 CONST S2_END                 = (S2_START+18) /* Last old style command */

/*
** New style commands introduced in 1997 and beyond
*/
NATIVE {S2_ADDMULTICASTADDRESSES}  CONST S2_ADDMULTICASTADDRESSES  = $C000
NATIVE {S2_DELMULTICASTADDRESSES}  CONST S2_DELMULTICASTADDRESSES  = $C001
NATIVE {S2_GETPEERADDRESS}         CONST S2_GETPEERADDRESS         = $C002
NATIVE {S2_GETDNSADDRESS}          CONST S2_GETDNSADDRESS          = $C003
NATIVE {S2_GETEXTENDEDGLOBALSTATS} CONST S2_GETEXTENDEDGLOBALSTATS = $C004
NATIVE {S2_CONNECT}                CONST S2_CONNECT                = $C005
NATIVE {S2_DISCONNECT}             CONST S2_DISCONNECT             = $C006
NATIVE {S2_SAMPLE_THROUGHPUT}      CONST S2_SAMPLE_THROUGHPUT      = $C007
NATIVE {S2_SANA2HOOK}              CONST S2_SANA2HOOK              = $C008

/*
** Defined errors for io_Error (see also <exec/errors.h>)
*/
NATIVE {S2ERR_NO_ERROR}       CONST S2ERR_NO_ERROR       = 0 /* peachy-keen */
NATIVE {S2ERR_NO_RESOURCES}   CONST S2ERR_NO_RESOURCES   = 1 /* resource allocation failure  */
NATIVE {S2ERR_BAD_ARGUMENT}   CONST S2ERR_BAD_ARGUMENT   = 3 /* garbage somewhere */
NATIVE {S2ERR_BAD_STATE}      CONST S2ERR_BAD_STATE      = 4 /* inappropriate state */
NATIVE {S2ERR_BAD_ADDRESS}    CONST S2ERR_BAD_ADDRESS    = 5 /* who? */
NATIVE {S2ERR_MTU_EXCEEDED}   CONST S2ERR_MTU_EXCEEDED   = 6 /* too much to chew */
NATIVE {S2ERR_NOT_SUPPORTED}  CONST S2ERR_NOT_SUPPORTED  = 8 /* hardware can't support cmd */
NATIVE {S2ERR_SOFTWARE}       CONST S2ERR_SOFTWARE       = 9 /* software error detected */
NATIVE {S2ERR_OUTOFSERVICE}  CONST S2ERR_OUTOFSERVICE  = 10 /* driver is OFFLINE */
NATIVE {S2ERR_TX_FAILURE}    CONST S2ERR_TX_FAILURE    = 11 /* Transmission attempt failed */

/*
** From <exec/errors.h>
**
**  IOERR_OPENFAIL   (-1) * device/unit failed to open *
**  IOERR_ABORTED    (-2) * request terminated early [after AbortIO()] *
**  IOERR_NOCMD      (-3) * command not supported by device *
**  IOERR_BADLENGTH  (-4) * not a valid length (usually IO_LENGTH) *
**  IOERR_BADADDRESS (-5) * invalid address (misaligned or bad range) *
**  IOERR_UNITBUSY   (-6) * device opens ok, but requested unit is busy *
**  IOERR_SELFTEST   (-7) * hardware failed self-test *
*/

/*
** Defined errors for ios2_WireError
*/
NATIVE {S2WERR_GENERIC_ERROR}          CONST S2WERR_GENERIC_ERROR          = 0 /* no specific info available */
NATIVE {S2WERR_NOT_CONFIGURED}         CONST S2WERR_NOT_CONFIGURED         = 1 /* unit not configured */
NATIVE {S2WERR_UNIT_ONLINE}            CONST S2WERR_UNIT_ONLINE            = 2 /* unit is currently online */
NATIVE {S2WERR_UNIT_OFFLINE}           CONST S2WERR_UNIT_OFFLINE           = 3 /* unit is currently offline */
NATIVE {S2WERR_ALREADY_TRACKED}        CONST S2WERR_ALREADY_TRACKED        = 4 /* protocol already tracked */
NATIVE {S2WERR_NOT_TRACKED}            CONST S2WERR_NOT_TRACKED            = 5 /* protocol not tracked */
NATIVE {S2WERR_BUFF_ERROR}             CONST S2WERR_BUFF_ERROR             = 6 /* buff mgt func returned error */
NATIVE {S2WERR_SRC_ADDRESS}            CONST S2WERR_SRC_ADDRESS            = 7 /* source address problem */
NATIVE {S2WERR_DST_ADDRESS}            CONST S2WERR_DST_ADDRESS            = 8 /* destination address problem */
NATIVE {S2WERR_BAD_BROADCAST}          CONST S2WERR_BAD_BROADCAST          = 9 /* broadcast address problem */
NATIVE {S2WERR_BAD_MULTICAST}         CONST S2WERR_BAD_MULTICAST         = 10 /* multicast address problem */
NATIVE {S2WERR_MULTICAST_FULL}        CONST S2WERR_MULTICAST_FULL        = 11 /* multicast address list full */
NATIVE {S2WERR_BAD_EVENT}             CONST S2WERR_BAD_EVENT             = 12 /* unsupported event class */
NATIVE {S2WERR_BAD_STATDATA}          CONST S2WERR_BAD_STATDATA          = 13 /* statdata failed sanity check */
/*** THERE IS NO WIRE ERROR CODE 14 ***/
NATIVE {S2WERR_IS_CONFIGURED}         CONST S2WERR_IS_CONFIGURED         = 15 /* attempt to config twice */
NATIVE {S2WERR_NULL_POINTER}          CONST S2WERR_NULL_POINTER          = 16 /* null pointer detected */
NATIVE {S2WERR_TOO_MANY_RETRIES}      CONST S2WERR_TOO_MANY_RETRIES      = 17 /* tx failed - too many retries */
NATIVE {S2WERR_RCVREL_HDW_ERR}        CONST S2WERR_RCVREL_HDW_ERR        = 18 /* Driver fixable HW error */
NATIVE {S2WERR_UNIT_DISCONNECTED}     CONST S2WERR_UNIT_DISCONNECTED     = 19 /* unit is currently not connected */
NATIVE {S2WERR_UNIT_CONNECTED}        CONST S2WERR_UNIT_CONNECTED        = 20 /* unit is currently connected */
NATIVE {S2WERR_INVALID_OPTION}        CONST S2WERR_INVALID_OPTION        = 21 /* invalid option rejected */
NATIVE {S2WERR_MISSING_OPTION}        CONST S2WERR_MISSING_OPTION        = 22 /* a mandatory option is missing */
NATIVE {S2WERR_AUTHENTICATION_FAILED} CONST S2WERR_AUTHENTICATION_FAILED = 23 /* could not log in */
NATIVE {S2WERR_FUNCTIONS_MISSING}     CONST S2WERR_FUNCTIONS_MISSING     = 24 /* mandatory copy functions are missing */
/*
** For our dsylexic friends
*/
NATIVE {S2WERR_TOO_MANY_RETIRES} CONST S2WERR_TOO_MANY_RETIRES = S2WERR_TOO_MANY_RETRIES

/*
** Defined events
*/
NATIVE {S2EVENT_ERROR}         CONST S2EVENT_ERROR         = $1 /* error catch all */
NATIVE {S2EVENT_TX}            CONST S2EVENT_TX            = $2 /* transmitter error catch all  */
NATIVE {S2EVENT_RX}            CONST S2EVENT_RX            = $4 /* receiver error catch all */
NATIVE {S2EVENT_ONLINE}        CONST S2EVENT_ONLINE        = $8 /* unit is in service */
NATIVE {S2EVENT_OFFLINE}       CONST S2EVENT_OFFLINE       = $10 /* unit is not in service */
NATIVE {S2EVENT_BUFF}          CONST S2EVENT_BUFF          = $20 /* buff mgt function error */
NATIVE {S2EVENT_HARDWARE}      CONST S2EVENT_HARDWARE      = $40 /* hardware error catch all */
NATIVE {S2EVENT_SOFTWARE}      CONST S2EVENT_SOFTWARE      = $80 /* software error catch all */
NATIVE {S2EVENT_CONFIGCHANGED} CONST S2EVENT_CONFIGCHANGED = $100 /* driver configuration changed */
NATIVE {S2EVENT_CONNECT}       CONST S2EVENT_CONNECT       = $200 /* driver has opened session */
NATIVE {S2EVENT_DISCONNECT}    CONST S2EVENT_DISCONNECT    = $400 /* driver has closed session */
