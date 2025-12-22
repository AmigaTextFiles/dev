OPT NATIVE, PREPROCESS
MODULE 'target/exec/ports', 'target/utility/tagitem', 'target/dos/dos', 'target/amitcp/sys/socket', 'target/amitcp/netinet/in', 'target/amitcp/net/if', 'target/amitcp/sys/mbuf'
MODULE 'target/exec/types', 'target/exec/nodes', 'target/amitcp/netinet/ip', 'target/amitcp/netinet/ip_icmp', 'target/amitcp/netinet/tcp', 'target/amitcp/netinet/udp'
{#include <libraries/bsdsocket.h>}
/*
 * $Id: bsdsocket.h,v 1.13 2007-08-26 12:30:24 obarthel Exp $
 *
 * :ts=8
 *
 * 'Roadshow' -- Amiga TCP/IP stack
 * Copyright © 2001-2007 by Olaf Barthel.
 * All Rights Reserved.
 *
 * Amiga specific TCP/IP 'C' header files;
 * Freely Distributable
 */

NATIVE {_LIBRARIES_BSDSOCKET_H} DEF

/****************************************************************************/

/*
 * Parameter passing macros for use with SocketBaseTagList()
 */

/* Argument passing: either by value or by reference. */
NATIVE {SBTF_VAL} CONST SBTF_VAL = $0000	/* Tag->ti_Data contains the value */
NATIVE {SBTF_REF} CONST SBTF_REF = $8000	/* Tag->ti_Data contains a pointer to the value */

/* Code value: this is one of the SBTC_.. values from the table below */
NATIVE {SBTB_CODE} CONST SBTB_CODE = 1
NATIVE {SBTS_CODE} CONST SBTS_CODE = $3FFF

NATIVE {SBTM_CODE} CONST
->#define SBTM_CODE(td) (((td) SHR SBTB_CODE) AND SBTS_CODE)
PROC sbtm_code(td) IS NATIVE {SBTM_CODE(} td {)} ENDNATIVE !!INT
#define SBTM_CODE(td) sbtm_code(td)

/* Read or write access control. */
NATIVE {SBTF_GET} CONST SBTF_GET = 0	/* Modify either Tag->ti_Data (SBTF_VAL) or the value
			   pointed to by Tag->ti_Data (SBTF_REF) */
NATIVE {SBTF_SET} CONST SBTF_SET = 1	/* Use either Tag->ti_Data (SBTF_VAL) or the value
			   pointed to by Tag->ti_Data (SBTF_REF) */

/* Macros for passing the individual tag item parameters. */
NATIVE {SBTM_GETREF} CONST
NATIVE {SBTM_GETVAL} CONST
NATIVE {SBTM_SETREF} CONST
NATIVE {SBTM_SETVAL} CONST

->#define SBTM_GETREF(code) (TAG_USER OR SBTF_REF OR (((code) AND SBTS_CODE) SHL SBTB_CODE) OR SBTF_GET)
->#define SBTM_GETVAL(code) (TAG_USER OR SBTF_VAL OR (((code) AND SBTS_CODE) SHL SBTB_CODE) OR SBTF_GET)
->#define SBTM_SETREF(code) (TAG_USER OR SBTF_REF OR (((code) AND SBTS_CODE) SHL SBTB_CODE) OR SBTF_SET)
->#define SBTM_SETVAL(code) (TAG_USER OR SBTF_VAL OR (((code) AND SBTS_CODE) SHL SBTB_CODE) OR SBTF_SET)
PROC sbtm_getref(code) IS NATIVE {SBTM_GETREF(} code {)} ENDNATIVE !!VALUE
PROC sbtm_getval(code) IS NATIVE {SBTM_GETVAL(} code {)} ENDNATIVE !!VALUE
PROC sbtm_setref(code) IS NATIVE {SBTM_SETREF(} code {)} ENDNATIVE !!VALUE
PROC sbtm_setval(code) IS NATIVE {SBTM_SETVAL(} code {)} ENDNATIVE !!VALUE
#define SBTM_GETREF(code) sbtm_getref(code)
#define SBTM_GETVAL(code) sbtm_getval(code)
#define SBTM_SETREF(code) sbtm_setref(code)
#define SBTM_SETVAL(code) sbtm_setval(code)

/****************************************************************************/

/*
 * Parameters for SocketBaseTagList(); these must be wrapped into the
 * SBTM_GETREF/SBTM_GETVAL/SBTM_SETREF/SBTM_SETVAL macros defined
 * above.
 */

/* Masks defining the signals for Task notification */
NATIVE {SBTC_BREAKMASK}		CONST SBTC_BREAKMASK		= 1
NATIVE {SBTC_SIGIOMASK}		CONST SBTC_SIGIOMASK		= 2
NATIVE {SBTC_SIGURGMASK}	CONST SBTC_SIGURGMASK		= 3
NATIVE {SBTC_SIGEVENTMASK}	CONST SBTC_SIGEVENTMASK	= 4

/* Current value of the errno and h_errno variables */
NATIVE {SBTC_ERRNO}		CONST SBTC_ERRNO		= 6
NATIVE {SBTC_HERRNO}		CONST SBTC_HERRNO		= 7

/* Current size of the socket descriptor table */
NATIVE {SBTC_DTABLESIZE}		CONST SBTC_DTABLESIZE		= 8

/* Link library fd allocation callback; don't use this in
   new code! */
NATIVE {SBTC_FDCALLBACK}		CONST SBTC_FDCALLBACK		= 9

/* Callback actions; don't use these in new code! */
NATIVE {FDCB_FREE}  CONST FDCB_FREE  = 0
NATIVE {FDCB_ALLOC} CONST FDCB_ALLOC = 1
NATIVE {FDCB_CHECK} CONST FDCB_CHECK = 2

/* syslog variables */
NATIVE {SBTC_LOGSTAT}		CONST SBTC_LOGSTAT		= 10
NATIVE {SBTC_LOGTAGPTR}		CONST SBTC_LOGTAGPTR		= 11
NATIVE {SBTC_LOGFACILITY}	CONST SBTC_LOGFACILITY	= 12
NATIVE {SBTC_LOGMASK}		CONST SBTC_LOGMASK		= 13

/* Error strings */
NATIVE {SBTC_ERRNOSTRPTR}	CONST SBTC_ERRNOSTRPTR	= 14
NATIVE {SBTC_HERRNOSTRPTR}	CONST SBTC_HERRNOSTRPTR	= 15
NATIVE {SBTC_IOERRNOSTRPTR}	CONST SBTC_IOERRNOSTRPTR	= 16
NATIVE {SBTC_S2ERRNOSTRPTR}	CONST SBTC_S2ERRNOSTRPTR	= 17
NATIVE {SBTC_S2WERRNOSTRPTR}	CONST SBTC_S2WERRNOSTRPTR	= 18

/* 'errno' pointer & size */
NATIVE {SBTC_ERRNOBYTEPTR}	CONST SBTC_ERRNOBYTEPTR	= 21
NATIVE {SBTC_ERRNOWORDPTR}	CONST SBTC_ERRNOWORDPTR	= 22
NATIVE {SBTC_ERRNOLONGPTR}	CONST SBTC_ERRNOLONGPTR	= 24
NATIVE {SBTC_ERRNOPTR} CONST
->#define SBTC_ERRNOPTR(size) (IF (size) = SIZEOF LONG THEN SBTC_ERRNOLONGPTR ELSE IF (size) = SIZEOF INT THEN SBTC_ERRNOWORDPTR ELSE IF (size) = SIZEOF CHAR THEN SBTC_ERRNOBYTEPTR ELSE 0)
PROC sbtc_errnoptr(size) IS NATIVE {SBTC_ERRNOPTR(} size {)} ENDNATIVE !!BYTE
#define SBTC_ERRNOPTR(size) sbtc_errnoptr(size)

/* 'h_errno' pointer (with sizeof(h_errno) == sizeof(long)) */
NATIVE {SBTC_HERRNOLONGPTR}	CONST SBTC_HERRNOLONGPTR	= 25

/* Release string pointer */
NATIVE {SBTC_RELEASESTRPTR}	CONST SBTC_RELEASESTRPTR	= 29

/*
 * Extensions to the original AmiTCP API
 */

/* Number of Berkeley packet filter channels available. */
NATIVE {SBTC_NUM_PACKET_FILTER_CHANNELS} CONST SBTC_NUM_PACKET_FILTER_CHANNELS = 40

/* Whether or not the routing API is supported. */
NATIVE {SBTC_HAVE_ROUTING_API} CONST SBTC_HAVE_ROUTING_API = 41

/* Enable/Disable UDP checksums? */
NATIVE {SBTC_UDP_CHECKSUM} CONST SBTC_UDP_CHECKSUM = 42

/* Enable/Disable IP packet forwarding? */
NATIVE {SBTC_IP_FORWARDING} CONST SBTC_IP_FORWARDING = 43

/* Get/set the default IP packet TTL value. */
NATIVE {SBTC_IP_DEFAULT_TTL} CONST SBTC_IP_DEFAULT_TTL = 44

/* Respond to ICMP mask requests? */
NATIVE {SBTC_ICMP_MASK_REPLY} CONST SBTC_ICMP_MASK_REPLY = 45

/* Enable/Disable sending of redirection messages? */
NATIVE {SBTC_ICMP_SEND_REDIRECTS} CONST SBTC_ICMP_SEND_REDIRECTS = 46

/* Whether or not the interface API is supported. */
NATIVE {SBTC_HAVE_INTERFACE_API} CONST SBTC_HAVE_INTERFACE_API = 47

/* How ICMP echo messages should be processed. */
NATIVE {SBTC_ICMP_PROCESS_ECHO} CONST SBTC_ICMP_PROCESS_ECHO = 48

/* How ICMP time stamp messages should be processed. */
NATIVE {SBTC_ICMP_PROCESS_TSTAMP} CONST SBTC_ICMP_PROCESS_TSTAMP = 49

/* Whether or not the monitoring API is supported. */
NATIVE {SBTC_HAVE_MONITORING_API} CONST SBTC_HAVE_MONITORING_API = 50

/* Whether or not library bases can be shared by different
   callers. */
NATIVE {SBTC_CAN_SHARE_LIBRARY_BASES} CONST SBTC_CAN_SHARE_LIBRARY_BASES = 51

/* Set the name of the log output file or get a pointer
   to the current file name. */
NATIVE {SBTC_LOG_FILE_NAME} CONST SBTC_LOG_FILE_NAME = 52

/* Whether or not the status API is supported. */
NATIVE {SBTC_HAVE_STATUS_API} CONST SBTC_HAVE_STATUS_API = 53

/* Whether or not the DNS API is supported. */
NATIVE {SBTC_HAVE_DNS_API} CONST SBTC_HAVE_DNS_API = 54

/* Set or get a pointer to the currently installed log hook. */
NATIVE {SBTC_LOG_HOOK} CONST SBTC_LOG_HOOK = 55

/* Get the system status, with regard to whether the TCP/IP stack
   has access to network interfaces and name resolution servers. */
NATIVE {SBTC_SYSTEM_STATUS} CONST SBTC_SYSTEM_STATUS = 56

/* Get or set the signal mask used to send a notification when
   the address of an interface has changed. */
NATIVE {SBTC_SIG_ADDRESS_CHANGE_MASK} CONST SBTC_SIG_ADDRESS_CHANGE_MASK = 57

/* If the IP filter API is supported, which version of that API
   would it be? */
NATIVE {SBTC_IPF_API_VERSION} CONST SBTC_IPF_API_VERSION = 58

/* Whether or not the local database access API is supported. */
NATIVE {SBTC_HAVE_LOCAL_DATABASE_API} CONST SBTC_HAVE_LOCAL_DATABASE_API = 59

/* Whether or not the address conversion API is supported. */
NATIVE {SBTC_HAVE_ADDRESS_CONVERSION_API} CONST SBTC_HAVE_ADDRESS_CONVERSION_API = 60

/* Whether or not the kernel memory API is supported. */
NATIVE {SBTC_HAVE_KERNEL_MEMORY_API} CONST SBTC_HAVE_KERNEL_MEMORY_API = 61

/* Get or set the IP filter hook which is invoked whenever a
   datagram has arrived or is about to be sent. */
NATIVE {SBTC_IP_FILTER_HOOK} CONST SBTC_IP_FILTER_HOOK = 62

/* Whether or not the server API is supported. */
NATIVE {SBTC_HAVE_SERVER_API} CONST SBTC_HAVE_SERVER_API = 63

/* Query the number of bytes received so far. */
NATIVE {SBTC_GET_BYTES_RECEIVED} CONST SBTC_GET_BYTES_RECEIVED = 64

/* Query the number of bytes sent so far. */
NATIVE {SBTC_GET_BYTES_SENT} CONST SBTC_GET_BYTES_SENT = 65

/* International Domain Name support: which character set should be assumed
   when performing translations between the name provided to the resolver
   and the encoded form sent to the Domain Name System server? See below
   for a list of choices. */
NATIVE {SBTC_IDN_DEFAULT_CHARACTER_SET} CONST SBTC_IDN_DEFAULT_CHARACTER_SET = 66

/* Whether or not the RoadshowData API is supported. */
NATIVE {SBTC_HAVE_ROADSHOWDATA_API} CONST SBTC_HAVE_ROADSHOWDATA_API = 67

/* Install or remove the error code hook. */
NATIVE {SBTC_ERROR_HOOK} CONST SBTC_ERROR_HOOK = 68

/****************************************************************************/

/*
 * International Domain Name support: character sets that can be used
 * with SocketBaseTagList() and the SBTC_IDN_DEFAULT_CHARACTER_SET
 * feature.
 */

NATIVE {IDNCS_ASCII}		CONST IDNCS_ASCII		= 0	/* Plain ASCII encoding; this will
					   disable the transparent domain
					   name translation feature. */
NATIVE {IDNCS_ISO_8859_LATIN_1}	CONST IDNCS_ISO_8859_LATIN_1	= 1	/* The native Amiga character set. */

/****************************************************************************/

/*
 * Flags returned by a SocketBaseTagList() 'SBTC_SYSTEM_STATUS' query.
 */

NATIVE {SBSYSSTAT_Interfaces}		CONST SBSYSSTAT_INTERFACES		= 1 SHL 0	/* Interfaces are available,
						   configured and
						   operational. */
NATIVE {SBSYSSTAT_PTP_Interfaces}	CONST SBSYSSTAT_PTP_INTERFACES	= 1 SHL 1	/* Point-to-point interfaces
						   are available, configured
						   and operational. */
NATIVE {SBSYSSTAT_BCast_Interfaces}	CONST SBSYSSTAT_BCAST_INTERFACES	= 1 SHL 2	/* Broadcast interfaces are
						   available, configured and
						   operational. */
NATIVE {SBSYSSTAT_Resolver}		CONST SBSYSSTAT_RESOLVER		= 1 SHL 3	/* Domain name servers are
						   known and available */
NATIVE {SBSYSSTAT_Routes}		CONST SBSYSSTAT_ROUTES		= 1 SHL 4	/* Routing information is
						   configured */
NATIVE {SBSYSSTAT_DefaultRoute}		CONST SBSYSSTAT_DEFAULTROUTE		= 1 SHL 5	/* A default route is
						   configured */

/****************************************************************************/

/*
 * Data structures for use with the log hook.
 */

NATIVE {LogHookMessage} OBJECT loghookmessage
	{lhm_Size}	size	:VALUE	/* Size of this data structure in bytes. */
	{lhm_Priority}	priority	:VALUE	/* Log entry priority (LOG_EMERG..LOG_DEBUG) */
	{lhm_Date}	date	:datestamp	/* Time and date when this log entry was
				   added. */
	{lhm_Tag}	tag	:/*STRPTR*/ ARRAY OF CHAR	/* Name of the facility which added this entry;
				   this can be NULL. */
	{lhm_ID}	id	:ULONG		/* ID of the facility which added this entry;
				   this can be zero. */
	{lhm_Message}	message	:/*STRPTR*/ ARRAY OF CHAR	/* NUL-terminated string which contains the
				   log message to be displayed. */
ENDOBJECT

/****************************************************************************/

/*
 * Options for configuring how ICMP echo and time stamp
 * requests should be processed.
 */
NATIVE {IR_Process}	CONST IR_PROCESS	= 0	/* Process the request and respond to it */
NATIVE {IR_Ignore}	CONST IR_IGNORE	= 1	/* Ignore the request, but feed it into the
				   raw IP packet processing framework */
NATIVE {IR_Drop}	CONST IR_DROP		= 2	/* Ignore the request and treat it as if
				   it had a checksum error */

/****************************************************************************/

/*
 * For use with ReleaseSocket() and ReleaseCopyOfSocket().
 */

NATIVE {UNIQUE_ID} CONST UNIQUE_ID = (-1)

/****************************************************************************/

/*
 * Event masks returned by GetSocketEvents().
 */

NATIVE {FD_ACCEPT}	CONST FD_ACCEPT	= $01	/* there is a connection to accept() */
NATIVE {FD_CONNECT}	CONST FD_CONNECT	= $02	/* connect() completed */
NATIVE {FD_OOB}		CONST FD_OOB		= $04	/* socket has out-of-band data */
NATIVE {FD_READ}	CONST FD_READ		= $08	/* socket is readable */
NATIVE {FD_WRITE}	CONST FD_WRITE	= $10	/* socket is writeable */
NATIVE {FD_ERROR}	CONST FD_ERROR	= $20	/* asynchronous error on socket */
NATIVE {FD_CLOSE}	CONST FD_CLOSE	= $40	/* connection closed (graceful or not) */

/****************************************************************************/

/*
 * Tags for use with the routing API.
 */

NATIVE {RTA_BASE} CONST RTA_BASE = (TAG_USER+1600)

NATIVE {RTA_Destination}	CONST RTA_DESTINATION		= (RTA_BASE+1)	/* Route destination
						   address */
NATIVE {RTA_Gateway}		CONST RTA_GATEWAY		= (RTA_BASE+2)	/* Gateway address */
NATIVE {RTA_DefaultGateway}	CONST RTA_DEFAULTGATEWAY	= (RTA_BASE+3)	/* Default gateway address */
NATIVE {RTA_DestinationHost}	CONST RTA_DESTINATIONHOST	= (RTA_BASE+4)	/* Route destination
						   address; destination is
						   assumed to be a host and
						   not a network */
NATIVE {RTA_DestinationNet}	CONST RTA_DESTINATIONNET	= (RTA_BASE+5)	/* Route destination
						   address; destination is
						   assumed to be a network
						   and not a host */

/****************************************************************************/

/*
 * Tags for use with the interface management API,
 * specifically the AddInterfaceTagList() call.
 */
NATIVE {IFA_BASE} CONST IFA_BASE = (TAG_USER+1700)

NATIVE {IFA_IPType}		CONST IFA_IPTYPE		= (IFA_BASE+1)	/* IP packet type */
NATIVE {IFA_ARPType}		CONST IFA_ARPTYPE		= (IFA_BASE+2)	/* ARP packet type */
NATIVE {IFA_NumReadRequests}	CONST IFA_NUMREADREQUESTS	= (IFA_BASE+3)	/* Number of read requests
						   to queue */
NATIVE {IFA_NumWriteRequests}	CONST IFA_NUMWRITEREQUESTS	= (IFA_BASE+4)	/* Number of write requests
						   to queue */
NATIVE {IFA_NumARPRequests}	CONST IFA_NUMARPREQUESTS	= (IFA_BASE+5)	/* Number of ARP requests
						   to queue */
NATIVE {IFA_PacketFilterMode}	CONST IFA_PACKETFILTERMODE	= (IFA_BASE+6)	/* Operating mode of the
						   Berkeley packet filter */
NATIVE {IFA_PointToPoint}	CONST IFA_POINTTOPOINT	= (IFA_BASE+7)	/* Whether or not this
						   interface is of the
						   point-to-point type */
NATIVE {IFA_Reserved0}		CONST IFA_RESERVED0		= (IFA_BASE+8)	/* This tag is reserved for
						   future use */
NATIVE {IFA_Multicast}		CONST IFA_MULTICAST		= (IFA_BASE+9)	/* Whether or not this
						   interface is allowed to
						   send multicast packets */
NATIVE {IFA_DownGoesOffline}	CONST IFA_DOWNGOESOFFLINE	= (IFA_BASE+10)	/* Whether or not this
						   interface will go offline
						   when it is taken down */
NATIVE {IFA_ReportOffline}	CONST IFA_REPORTOFFLINE	= (IFA_BASE+11)	/* Whether or not this
						   interface will cause a
						   notification message to
						   be logged when it goes
						   offline */
NATIVE {IFA_RequiresInitDelay}	CONST IFA_REQUIRESINITDELAY	= (IFA_BASE+12)	/* Whether or not this
						   interface requires a short
						   delay to precede the
						   device initialization */
NATIVE {IFA_CopyMode}		CONST IFA_COPYMODE		= (IFA_BASE+13)	/* Special data copy options
						   for this interface */
NATIVE {IFA_HardwareAddress}	CONST IFA_HARDWAREADDRESS	= (IFA_BASE+14)	/* Set the interface hardware
						   address to a certain
						   value. */
NATIVE {IFA_SetDebugMode}	CONST IFA_SETDEBUGMODE	= (IFA_BASE+15)	/* Enable or disable debugging
						   mode for this interface. */
NATIVE {IFA_LimitMTU}		CONST IFA_LIMITMTU		= (IFA_BASE+16)	/* Set the maximum hardware
						   transmission unit. */

/****************************************************************************/

/* This is used with the 'IFA_HardwareAddress' tag above. */
NATIVE {InterfaceHardwareAddress} OBJECT interfacehardwareaddress
	{iha_Length}	length	:VALUE	/* Number of bits in address */
	{iha_Address}	address	:PTR TO UBYTE	/* Points to first address byte */
ENDOBJECT

/****************************************************************************/

/*
 * Options available for use with the IFA_PacketFilterMode tag.
 */
NATIVE {PFM_Nothing}	CONST PFM_NOTHING	= 0	/* Filter is disabled for this interface. */
NATIVE {PFM_Local}	CONST PFM_LOCAL	= 1	/* Filter is enabled; only packets intended
				   for this interface are filtered */
NATIVE {PFM_IPandARP}	CONST PFM_IPANDARP	= 2	/* Filter is enabled; all IP and ARP packets
				   are filtered, even if they are not intended
				   for this interface */
NATIVE {PFM_Everything}	CONST PFM_EVERYTHING	= 3	/* Filter is enabled; all packets are filtered
				   that pass by, regardless of their type and
				   contents */

/****************************************************************************/

/*
 * Options available for use with the IFA_CopyMode tag.
 */
NATIVE {CM_SlowWordCopy}	CONST CM_SLOWWORDCOPY	= 0	/* Disables the S2_CopyFromBuff16 SANA-II
				   buffer management option (default). */
NATIVE {CM_FastWordCopy}	CONST CM_FASTWORDCOPY	= 1	/* Enables the S2_CopyFromBuff16 SANA-II
				   buffer management option. */

/****************************************************************************/

/*
 * Tags for use with the interface management API,
 * specifically the ConfigureInterfaceTagList() call.
 */
NATIVE {IFC_BASE} CONST IFC_BASE = (TAG_USER+1800)

NATIVE {IFC_Address}		CONST IFC_ADDRESS		= (IFC_BASE+1)	/* The address to assign to
						   the interface itself */
NATIVE {IFC_NetMask}		CONST IFC_NETMASK		= (IFC_BASE+2)	/* The interface's address
						   net mask */
NATIVE {IFC_DestinationAddress}	CONST IFC_DESTINATIONADDRESS	= (IFC_BASE+3)	/* The address of the other
						   end of a point-to-point
						   link */
NATIVE {IFC_BroadcastAddress}	CONST IFC_BROADCASTADDRESS	= (IFC_BASE+4)	/* The broadcast address to
						   be used by the interface */
NATIVE {IFC_Metric}		CONST IFC_METRIC		= (IFC_BASE+5)	/* The routing metric value */

NATIVE {IFC_AddAliasAddress}	CONST IFC_ADDALIASADDRESS	= (IFC_BASE+6)	/* Add another alias address
						   for this interface */
NATIVE {IFC_DeleteAliasAddress}	CONST IFC_DELETEALIASADDRESS	= (IFC_BASE+7)	/* Remove an alias address
						   for this interface */
NATIVE {IFC_State}		CONST IFC_STATE		= (IFC_BASE+8)	/* Mark an interface up, down,
						   online or offline */
NATIVE {IFC_GetPeerAddress}	CONST IFC_GETPEERADDRESS	= (IFC_BASE+9)	/* If available, obtain the
						   interface's local address
						   and the address of its
						   point to point partner */
NATIVE {IFC_GetDNS}		CONST IFC_GETDNS		= (IFC_BASE+10)	/* If available, obtain the
						   domain name servers known
						   to this interface */
NATIVE {IFC_AssociatedRoute}	CONST IFC_ASSOCIATEDROUTE	= (IFC_BASE+12)	/* That interface is associated
						   with a route. */
NATIVE {IFC_AssociatedDNS}	CONST IFC_ASSOCIATEDDNS	= (IFC_BASE+13)	/* That interface is associated
						   with a DNS. */
NATIVE {IFC_ReleaseAddress}	CONST IFC_RELEASEADDRESS	= (IFC_BASE+14)	/* Release the address allocated
						   for this interface (via the
						   DHCP protocol). */
NATIVE {IFC_SetDebugMode}	CONST IFC_SETDEBUGMODE	= (IFC_BASE+15)	/* Enable or disable debugging
						   mode for this interface. */
NATIVE {IFC_Complete}		CONST IFC_COMPLETE		= (IFC_BASE+16)	/* Indicate that the configuration
						   for this interface is complete */
NATIVE {IFC_LimitMTU}		CONST IFC_LIMITMTU		= (IFC_BASE+17)	/* Set the maximum hardware
						   transmission unit */

/****************************************************************************/

/*
 * Tags for use with the interface management API,
 * specifically the QueryInterfaceTagList() call.
 */
NATIVE {IFQ_BASE} CONST IFQ_BASE = (TAG_USER+1900)

NATIVE {IFQ_DeviceName}		CONST IFQ_DEVICENAME		= (IFQ_BASE+1)	/* Query the associated
						   SANA-II device name */
NATIVE {IFQ_DeviceUnit}		CONST IFQ_DEVICEUNIT		= (IFQ_BASE+2)	/* Query the associated
						   SANA-II unit number */
NATIVE {IFQ_HardwareAddressSize}	CONST IFQ_HARDWAREADDRESSSIZE	= (IFQ_BASE+3)	/* Query the hardware address
						   size (in bytes) */
NATIVE {IFQ_HardwareAddress}	CONST IFQ_HARDWAREADDRESS	= (IFQ_BASE+4)	/* Query the hardware
						   address */
NATIVE {IFQ_MTU}		CONST IFQ_MTU			= (IFQ_BASE+5)	/* Query the maximum
						   transmission unit currently
						   in use */
NATIVE {IFQ_BPS}		CONST IFQ_BPS			= (IFQ_BASE+6)	/* Query the transmission
						   speed */
NATIVE {IFQ_HardwareType}	CONST IFQ_HARDWARETYPE	= (IFQ_BASE+7)	/* Query the SANA-II hardware
						   type */
NATIVE {IFQ_PacketsReceived}	CONST IFQ_PACKETSRECEIVED	= (IFQ_BASE+8)	/* Query the number of
						   packets received by this
						   interface */
NATIVE {IFQ_PacketsSent}	CONST IFQ_PACKETSSENT		= (IFQ_BASE+9)	/* Query the number of
						   packets sent by this
						   interface */
NATIVE {IFQ_BadData}		CONST IFQ_BADDATA		= (IFQ_BASE+10)	/* Query the number of bad
						   packets dropped by this
						   interface */
NATIVE {IFQ_Overruns}		CONST IFQ_OVERRUNS		= (IFQ_BASE+11)	/* Query the number of buffer
						   overruns */
NATIVE {IFQ_UnknownTypes}	CONST IFQ_UNKNOWNTYPES	= (IFQ_BASE+12)	/* Query the number of unknown
						   packet types dropped by this
						   interface */
NATIVE {IFQ_LastStart}		CONST IFQ_LASTSTART		= (IFQ_BASE+13)	/* Query the last time the
						   interface went online */
NATIVE {IFQ_Address}		CONST IFQ_ADDRESS		= (IFQ_BASE+14)	/* Query the IP address
						   associated with this
						   interface */
NATIVE {IFQ_DestinationAddress}	CONST IFQ_DESTINATIONADDRESS	= (IFQ_BASE+15)	/* Query the interface's
						   destination address */
NATIVE {IFQ_BroadcastAddress}	CONST IFQ_BROADCASTADDRESS	= (IFQ_BASE+16)	/* Query the interface's
						   broadcast address */
NATIVE {IFQ_NetMask}		CONST IFQ_NETMASK		= (IFQ_BASE+17)	/* Query the interface's
						   subnet mask */
NATIVE {IFQ_Metric}		CONST IFQ_METRIC		= (IFQ_BASE+18)	/* Query the interface's
						   metric value */
NATIVE {IFQ_State}		CONST IFQ_STATE		= (IFQ_BASE+19)	/* Query the interface's
						   status */
NATIVE {IFQ_AddressBindType}	CONST IFQ_ADDRESSBINDTYPE	= (IFQ_BASE+20)	/* Query whether the address
						   bound to this interface
						   is statically, manually
						   or dynamically bound. */
NATIVE {IFQ_AddressLeaseExpires}	CONST IFQ_ADDRESSLEASEEXPIRES	= (IFQ_BASE+21)	/* Find out whether and when
						   the address bound to this
						   interface expires. */
NATIVE {IFQ_PrimaryDNSAddress}	CONST IFQ_PRIMARYDNSADDRESS	= (IFQ_BASE+22)	/* Query the primary domain
						   name server address known
						   to this interface */
NATIVE {IFQ_SecondaryDNSAddress}	CONST IFQ_SECONDARYDNSADDRESS	= (IFQ_BASE+23)	/* Query the secondary domain
						   name server address known
						   to this interface */
NATIVE {IFQ_NumReadRequests}	CONST IFQ_NUMREADREQUESTS	= (IFQ_BASE+24)	/* Number of read I/O requests
						   allocated for this
						   interface */
NATIVE {IFQ_MaxReadRequests}	CONST IFQ_MAXREADREQUESTS	= (IFQ_BASE+25)	/* Maximum number of read I/O
						   requests in use at a time
						   on this interface */
NATIVE {IFQ_NumWriteRequests}	CONST IFQ_NUMWRITEREQUESTS	= (IFQ_BASE+26)	/* Number of write I/O requests
						   allocated for this
						   interface */
NATIVE {IFQ_MaxWriteRequests}	CONST IFQ_MAXWRITEREQUESTS	= (IFQ_BASE+27)	/* Maximum number of write I/O
						   requests in use at a time
						   on this interface */
NATIVE {IFQ_GetBytesIn}		CONST IFQ_GETBYTESIN		= (IFQ_BASE+28)	/* Query the number of bytes
						   received */
NATIVE {IFQ_GetBytesOut}		CONST IFQ_GETBYTESOUT		= (IFQ_BASE+29)	/* Query the number of bytes
						   sent */
NATIVE {IFQ_GetDebugMode}	CONST IFQ_GETDEBUGMODE	= (IFQ_BASE+30)	/* Check if this interface has
						   the debug mode enabled */
NATIVE {IFQ_GetSANA2CopyStats}	CONST IFQ_GETSANA2COPYSTATS	= (IFQ_BASE+31)	/* Obtain the SANA-II data
						   copy statistics */
NATIVE {IFQ_NumReadRequestsPending} CONST IFQ_NUMREADREQUESTSPENDING = (IFQ_BASE+32)
						/* Number of read I/O requests
						   still pending to be
						   satisfied on this
						   interface */
NATIVE {IFQ_NumWriteRequestsPending} CONST IFQ_NUMWRITEREQUESTSPENDING = (IFQ_BASE+33)
						/* Number of write I/O requests
						   still pending to be
						   satisfied on this
						   interface */
NATIVE {IFQ_HardwareMTU}	CONST IFQ_HARDWAREMTU		= (IFQ_BASE+34)	/* Query the maximum hardware
						   transmission unit */

NATIVE {IFQ_OutputDrops}	CONST IFQ_OUTPUTDROPS		= (IFQ_BASE+35)	/* Query the number of packets
						   dropped during transmission */

NATIVE {IFQ_InputDrops}		CONST IFQ_INPUTDROPS		= (IFQ_BASE+36)	/* Query the number of packets
						   dropped during reception */

NATIVE {IFQ_OutputErrors}	CONST IFQ_OUTPUTERRORS	= (IFQ_BASE+37)	/* Query the number errors
						   encountered during data
						   transmission */

NATIVE {IFQ_InputErrors}	CONST IFQ_INPUTERRORS		= (IFQ_BASE+38)	/* Query the number errors
						   encountered during data
						   reception */

NATIVE {IFQ_OutputMulticasts}	CONST IFQ_OUTPUTMULTICASTS	= (IFQ_BASE+39)	/* Query the number of
						   multicast packets sent */

NATIVE {IFQ_InputMulticasts}	CONST IFQ_INPUTMULTICASTS	= (IFQ_BASE+40)	/* Query the number of
						   multicast packets
						   received */

NATIVE {IFQ_IPDrops}		CONST IFQ_IPDROPS		= (IFQ_BASE+41)	/* Query the total number
						   of all IP packets dropped */

NATIVE {IFQ_ARPDrops}		CONST IFQ_ARPDROPS		= (IFQ_BASE+42)	/* Query the total number
						   of all ARP packets dropped */

/****************************************************************************/

/* This is used with the 'IFQ_GetSANA2CopyStats' tag above. */
NATIVE {SANA2CopyStats} OBJECT sana2copystats
	{s2cs_DMAIn}	dmain	:ULONG	/* How many times data was received via the
				   DMA transfer function */
	{s2cs_DMAOut}	dmaout	:ULONG	/* How many times data was sent via the
				   DMA transfer function */

	{s2cs_ByteIn}	bytein	:ULONG	/* How many times data was received via the
				   byte wide copy function */
	{s2cs_ByteOut}	byteout	:ULONG	/* How many times data was sent via the
				   byte wide copy function */

	{s2cs_WordOut}	wordout	:ULONG	/* How many times data was sent via the
				   word wide copy function */
ENDOBJECT

/****************************************************************************/

/* The different types of interface address binding. */
NATIVE {IFABT_Unknown}	CONST IFABT_UNKNOWN	= 0	/* The interface address has not been bound
				   or is in transitional state; check later
				   for more information. */
NATIVE {IFABT_Static}	CONST IFABT_STATIC	= 1	/* The address was assigned manually, or
				   by an automated configuration process
				   and is not expected to change. */
NATIVE {IFABT_Dynamic}	CONST IFABT_DYNAMIC	= 2	/* The address was assigned by an automated
				   configuration process and may change in the
				   future. */

/****************************************************************************/

/*
 * The 64 bit integer value used by the IFQ_GetBytesIn..IFQ_GetResetBytesOut
 * query tags.
 */
/*typedef*/ NATIVE {SBQUAD_T} OBJECT sbquad_t
	{sbq_High}	high	:ULONG
	{sbq_Low}	low	:ULONG
ENDOBJECT

/****************************************************************************/

/*
 * Options available for use with the IFC_State and IFQ_State tags.
 */
NATIVE {SM_Offline}	CONST SM_OFFLINE	= 0	/* Interface is offline and not ready to
				   receive and transmit data */
NATIVE {SM_Online}	CONST SM_ONLINE	= 1	/* Interface is online and ready to receive
				   and transmit data */
NATIVE {SM_Down}	CONST SM_DOWN		= 2	/* Interface is not ready to receive and
				   transmit data, but might still be
				   online. */
NATIVE {SM_Up}		CONST SM_UP		= 3	/* Interface is ready to receive and transmit
				   data, but not necessarily online. */

/****************************************************************************/

/*
 * Types of monitoring hooks that can be installed.
 */
NATIVE {MHT_ICMP}	CONST MHT_ICMP	= 0	/* ICMP message monitoring */
NATIVE {MHT_UDP}		CONST MHT_UDP		= 1	/* UDP datagram monitoring */
NATIVE {MHT_TCP_Connect}	CONST MHT_TCP_CONNECT	= 2	/* TCP connection monitoring */
NATIVE {MHT_Connect}	CONST MHT_CONNECT	= 3	/* connect() call monitoring */
NATIVE {MHT_Send}	CONST MHT_SEND	= 4	/* sendto() and sendmsg() monitoring */
NATIVE {MHT_Packet}	CONST MHT_PACKET	= 5	/* Low level packet monitoring */
NATIVE {MHT_Bind}	CONST MHT_BIND	= 6	/* bind() call monitoring */

/****************************************************************************/

/*
 * Parameters passed to the different monitoring hooks.
 */

/* This type of message parameter is passed to 'MHT_Connect'
   type monitoring hooks. */
NATIVE {ConnectMonitorMsg} OBJECT connectmonitormsg
	{cmm_Size}	size	:VALUE	/* Size of this data
					   structure */
	{cmm_Caller}	caller	:/*STRPTR*/ ARRAY OF CHAR	/* The name of the calling
					   program, if it chose to be
					   identified */
	{cmm_Socket}	socket	:VALUE	/* The socket to connect to
					   the address */
	{cmm_Name}	name	:PTR TO sockaddr	/* The address to connect
					   to */
	{cmm_NameLen}	namelen	:VALUE	/* The size of the address */
ENDOBJECT

/* This type of message parameter is passed to 'MHT_Bind'
   type monitoring hooks. */
NATIVE {BindMonitorMsg} OBJECT bindmonitormsg
	{bmm_Size}	size	:VALUE	/* Size of this data
					   structure */
	{bmm_Caller}	caller	:/*STRPTR*/ ARRAY OF CHAR	/* The name of the calling
					   program, if it chose to be
					   identified */
	{bmm_Socket}	socket	:VALUE	/* The socket to bind to the
					   address */
	{bmm_Name}	name	:PTR TO sockaddr	/* The address to bind */
	{bmm_NameLen}	namelen	:VALUE	/* The size of the address */
ENDOBJECT

/* This type of message is passed to 'MHT_Send' type monitoring hooks. */
NATIVE {SendMonitorMessage} OBJECT sendmonitormessage
	{smm_Size}	size	:VALUE	/* Size of this data structure */
	{smm_Caller}	caller	:/*STRPTR*/ ARRAY OF CHAR	/* The name of the calling
					   program, if it chose to be
					   identified */
	{smm_Socket}	socket	:VALUE	/* The socket to connect to the
					   address */
	{smm_Buffer}	buffer	:APTR	/* Data to be sent */
	{smm_Len}	len	:VALUE	/* Amount of data to be sent */
	{smm_Flags}	flags	:VALUE	/* Control flags, including
					   MSG_OOB or MSG_DONTROUTE */
	{smm_To}	to	:PTR TO sockaddr		/* The address to send the
					   data to; this may be NULL */
	{smm_ToLen}	tolen	:VALUE	/* The size of the address to send
					   this data to; this may be
					   NULL */
	{smm_Msg}	msg	:PTR TO msghdr	/* The message to send; this may
					   be NULL. */
ENDOBJECT

/* This type of message is passed to 'MHT_TCP_Connect' type
   monitoring hooks. */
NATIVE {TCPConnectMonitorMessage} OBJECT tcpconnectmonitormessage
	{tcmm_Size}	size	:VALUE	/* Size of this data structure */
	{tcmm_Src}	src	:PTR TO in_addr	/* Source internet address */
	{tcmm_Dst}	dst	:PTR TO in_addr	/* Destination internet address */
	{tcmm_TCP}	tcp	:PTR TO tcphdr	/* TCP header */
ENDOBJECT

/* This type of message is passed to 'MHT_UDP' type monitoring hooks. */
NATIVE {UDPMonitorMessage} OBJECT udpmonitormessage
	{umm_Size}	size	:VALUE	/* Size of this data structure */
	{umm_Src}	src	:PTR TO in_addr	/* Source internet address */
	{umm_Dst}	dst	:PTR TO in_addr	/* Destination internet address */
	{umm_UDP}	udp	:PTR TO udphdr	/* UDP header */
ENDOBJECT

/* This type of message is passed to 'MHT_ICMP' type monitoring hooks. */
NATIVE {ICMPMonitorMessage} OBJECT icmpmonitormessage
	{imm_Size}	size	:VALUE	/* Size of this data structure */
	{imm_Src}	src	:PTR TO in_addr	/* Source internet address */
	{imm_Dst}	dst	:PTR TO in_addr	/* Destination internet address */
	{imm_ICMP}	icmp	:PTR TO icmp	/* ICMP header */
ENDOBJECT

/* This type of message is passed to 'MHT_Packet' type monitoring hooks. */
NATIVE {PacketMonitorMessage} OBJECT packetmonitormessage
	{pmm_Size}	size	:VALUE	/* Size of this data structure */
	{pmm_Direction}	direction	:VALUE	/* Whether the packet was received
					   or is about to be sent */
	{pmm_LinkLayerData}	linklayerdata	:APTR
					/* Points to the link layer part
					   of the packet, typically an
					   Ethernet header per RFC 894.
					   This may be NULL. */
	{pmm_LinkLayerSize}	linklayersize	:VALUE
					/* Size of the link layer data part
					   of the packet; this may be 0. */
	{pmm_PacketData}	packetdata	:APTR	/* Points to the packet 'payload'. */
	{pmm_PacketSize}	packetsize	:VALUE	/* Size of the packet 'payload'. */
ENDOBJECT

/* Possible values for 'pmm_Direction'. */
NATIVE {PMMD_Receive}	CONST PMMD_RECEIVE	= 0	/* Packet was received and is waiting to be
				   processed */
NATIVE {PMMD_Send}	CONST PMMD_SEND	= 1	/* Packet is about to be sent */

/****************************************************************************/

/*
 * Possible actions to be taken after a monitoring hook has
 * examined the data it was passed. Any positive return value
 * will cause the data to be dropped and the corresponding
 * errno value to be set to the result.
 */
NATIVE {MA_Continue}		CONST MA_CONTINUE		= 0	/* Proceed as if no filtering had
					   taken place */
NATIVE {MA_Ignore}		CONST MA_IGNORE		= -1	/* Ignore the data and skip the
					   normal route processing would
					   take */
NATIVE {MA_Drop}		CONST MA_DROP			= -2	/* Drop the data */
NATIVE {MA_DropWithReset}	CONST MA_DROPWITHRESET	= -3	/* Drop the data and also reset the
					   connection */

/****************************************************************************/

/*
 * Parameters for use with the GetNetworkStatus() function.
 */

/* What version of the statistics data should be returned; so far
   there is only version #1. */
NATIVE {NETWORKSTATUS_VERSION} CONST NETWORKSTATUS_VERSION = 1

/* What statistics should be provided */

NATIVE {NETSTATUS_icmp}		CONST NETSTATUS_ICMP		= 0	/* Internet control message
					   protocol statistics */
NATIVE {NETSTATUS_igmp}		CONST NETSTATUS_IGMP		= 1	/* Internet group management
					   protocol statistics */
NATIVE {NETSTATUS_ip}		CONST NETSTATUS_IP		= 2	/* Internet protocol statistics */
NATIVE {NETSTATUS_mb}		CONST NETSTATUS_MB		= 3	/* Memory buffer statistics */
NATIVE {NETSTATUS_mrt}		CONST NETSTATUS_MRT		= 4	/* Multicast routing statistics */
NATIVE {NETSTATUS_rt}		CONST NETSTATUS_RT		= 5	/* Routing statistics */
NATIVE {NETSTATUS_tcp}		CONST NETSTATUS_TCP		= 6	/* Transmission control protocol
					   statistics */
NATIVE {NETSTATUS_udp}		CONST NETSTATUS_UDP		= 7	/* User datagram protocol
					   statistics */
NATIVE {NETSTATUS_tcp_sockets}	CONST NETSTATUS_TCP_SOCKETS	= 9	/* TCP socket statistics */
NATIVE {NETSTATUS_udp_sockets}	CONST NETSTATUS_UDP_SOCKETS	= 10	/* UDP socket statistics */

/* Protocol connection data returned for each TCP/UDP socket. */
NATIVE {protocol_connection_data} OBJECT protocol_connection_data
	{pcd_foreign_address}	foreign_address	:in_addr	/* Foreign host address */
	{pcd_foreign_port}	foreign_port	:UINT	/* Foreign port number */
	{pcd_local_address}	local_address	:in_addr	/* Local host address */
	{pcd_local_port}	local_port	:UINT		/* Local port number */
	{pcd_receive_queue_size}	receive_queue_size	:ULONG	/* Socket receive queue size */
	{pcd_send_queue_size}	send_queue_size	:ULONG	/* Socket send queue size */
	{pcd_tcp_state}	tcp_state	:VALUE		/* Socket TCP state */
ENDOBJECT

/****************************************************************************/

/*
 * Interface address allocation (BOOTP and DHCP).
 */

/* The message to send to the interface configuration process
   to start looking for an IP address. */
NATIVE {AddressAllocationMessage} OBJECT addressallocationmessage
	{aam_Message}	message	:mn
	{aam_Reserved}	reserved	:VALUE
	{aam_Result}	result	:VALUE		/* What kind of result this
					   request produced. */
	{aam_Version}	version	:VALUE		/* Version number associated with
					   this data structure. */
	{aam_Protocol}	protocol	:VALUE		/* What kind of configuration
					   protocol should be used. */
	{aam_InterfaceName}	interfacename[16]	:ARRAY OF CHAR	/* Name of interface an
					   address is to be
					   assigned to. */
	{aam_Timeout}	timeout	:VALUE		/* Number of seconds to
					   wait before a result
					   materializes. */
	{aam_LeaseTime}	leasetime	:ULONG		/* Requested lease time in
					   seconds; 0 to accept the
					   default. */
	{aam_RequestedAddress}	requestedaddress	:ULONG	/* Interface address that should
					   be assigned, if possible; 0
					   to accept the server's choice. */
	{aam_ClientIdentifier}	clientidentifier	:/*STRPTR*/ ARRAY OF CHAR	/* Unique identifier for this
					   host */
	{aam_Address}	address	:ULONG		/* Interface address
					   returned upon
					   success. */
	{aam_ServerAddress}	serveraddress	:ULONG	/* Address of BOOTP server. */
	{aam_SubnetMask}	subnetmask	:ULONG		/* Interface subnet
					   mask; ignore if zero. */

	{aam_NAKMessage}	nakmessage	:/*STRPTR*/ ARRAY OF CHAR		/* In case of failure,
					   put the explanation
					   text here. */
	{aam_NAKMessageSize}	nakmessagesize	:VALUE	/* Maximum length of the
					   negative ack message. */

	{aam_RouterTable}	routertable	:PTR TO ULONG	/* A list of router addresses
					   will be put here. */
	{aam_RouterTableSize}	routertablesize	:VALUE	/* Maximum number of valid
					   router addresses. */
	
	{aam_DNSTable}	dnstable	:PTR TO ULONG		/* A list of domain name servers
					   will be put here. */
	{aam_DNSTableSize}	dnstablesize	:VALUE	/* Maximum number of valid
					   domain name server
					   addresses. */

	{aam_StaticRouteTable}	staticroutetable	:PTR TO ULONG	/* A list of static routes
					   will be put here. */
	{aam_StaticRouteTableSize}	staticroutetablesize	:VALUE
					/* Maximum number of valid
					   static routes. */

	{aam_HostName}	hostname	:/*STRPTR*/ ARRAY OF CHAR		/* If available, the name
					   assigned to this host will
					   be put here. */
	{aam_HostNameSize}	hostnamesize	:VALUE	/* Maximum size of the host
					   name. */

	{aam_DomainName}	domainname	:/*STRPTR*/ ARRAY OF CHAR		/* If available, the name
					   of the domain assigned to
					   this host will be put here. */
	{aam_DomainNameSize}	domainnamesize	:VALUE	/* Maximum size of the domain
					   name. */
	{aam_BOOTPMessage}	bootpmessage	:PTR TO UBYTE	/* Points to buffer to place
					   the BOOTP message in. */
	{aam_BOOTPMessageSize}	bootpmessagesize	:VALUE	/* Size of the buffer to place
					   the BOOTP message in. */
	{aam_LeaseExpires}	leaseexpires	:PTR TO datestamp	/* Points to buffer to place the
					   lease expire date and time in.
					   in. This will be 0 if no data
					   is provided or if the lease
					   never expires. */
ENDOBJECT

/* This data structure version. */
NATIVE {AAM_VERSION} CONST AAM_VERSION = 1

/* Available result codes. */
NATIVE {AAMR_Success}		CONST AAMR_SUCCESS		= 0	/* Allocation has succeeded */
NATIVE {AAMR_Aborted}		CONST AAMR_ABORTED		= 1	/* The allocation was aborted */
NATIVE {AAMR_InterfaceNotKnown}	CONST AAMR_INTERFACENOTKNOWN	= 2	/* The interface name is not
					   known */
NATIVE {AAMR_InterfaceWrongType}	CONST AAMR_INTERFACEWRONGTYPE	= 3	/* The interface must support
					   broadcast access. */
NATIVE {AAMR_AddressKnown}	CONST AAMR_ADDRESSKNOWN	= 4	/* The interface address is already
					   known. */
NATIVE {AAMR_VersionUnknown}	CONST AAMR_VERSIONUNKNOWN	= 5	/* The data structure version is
					   not supported. */
NATIVE {AAMR_NoMemory}		CONST AAMR_NOMEMORY		= 6	/* Not enough memory to process
					   the request. */
NATIVE {AAMR_Timeout}		CONST AAMR_TIMEOUT		= 7	/* The allocation request did not
					   succeed in the requested time
					   span. */
NATIVE {AAMR_AddressInUse}	CONST AAMR_ADDRESSINUSE	= 8	/* The address to be allocated is
					   already in use. */
NATIVE {AAMR_AddrChangeFailed}	CONST AAMR_ADDRCHANGEFAILED	= 9	/* The interface address could
					   not be changed. */
NATIVE {AAMR_MaskChangeFailed}	CONST AAMR_MASKCHANGEFAILED	= 10	/* The interface subnet mask could
					   not be changed. */
NATIVE {AAMR_Busy}		CONST AAMR_BUSY		= 11	/* Address allocation is already in
					   progress for this interface. */
NATIVE {AAMR_Ignored}		CONST AAMR_IGNORED		= -1	/* The message type was not
					   understood */

/* The minimum timeout value supported for an allocation to succeed. */
NATIVE {AAM_TIMEOUT_MIN} CONST AAM_TIMEOUT_MIN = 10

/* The special DHCP lease times. */
NATIVE {DHCP_DEFAULT_LEASE_TIME}		CONST DHCP_DEFAULT_LEASE_TIME		= 0
NATIVE {DHCP_INFINITE_LEASE_TIME}	CONST DHCP_INFINITE_LEASE_TIME	= $FFFFFFFF

/* The configuration protocols to use. */
NATIVE {AAMP_BOOTP}	CONST AAMP_BOOTP	= 0	/* Bootstrap Protocol (RFC 951) */
NATIVE {AAMP_DHCP}	CONST AAMP_DHCP	= 1	/* Dynamic Host Configuration Protocol
				   (RFC 2131) */
NATIVE {AAMP_SLOWAUTO}	CONST AAMP_SLOWAUTO	= 2	/* Automatic address allocation; slower
				   version for Ethernet networks with
				   switches which use the IEEE Spanning
				   Tree Protocol (802.1d) */
NATIVE {AAMP_FASTAUTO}	CONST AAMP_FASTAUTO	= 3	/* Automatic address allocation; faster
				   version for wireless devices */

/* Tags for use with CreateAddressAllocationMessage(). */
NATIVE {CAAMTA_BASE} CONST CAAMTA_BASE = (TAG_USER+2000)

/* This corresponds to the 'aam_Timeout' member of the
   AddressAllocationMessage. */
NATIVE {CAAMTA_Timeout}			CONST CAAMTA_TIMEOUT			= (CAAMTA_BASE+1)

/* This corresponds to the 'aam_LeaseTime' member of the
   AddressAllocationMessage. */
NATIVE {CAAMTA_LeaseTime}		CONST CAAMTA_LEASETIME		= (CAAMTA_BASE+2)

/* This corresponds to the 'aam_RequestedAddress' member of the
   AddressAllocationMessage. */
NATIVE {CAAMTA_RequestedAddress}		CONST CAAMTA_REQUESTEDADDRESS		= (CAAMTA_BASE+3)

/* Pointer to the client identifier string to be used; this
   string must be at least 2 characters long. The string will
   be duplicated and stored in the 'aam_ClientIdentifier' member
   of the AddressAllocationMessage. */
NATIVE {CAAMTA_ClientIdentifier}		CONST CAAMTA_CLIENTIDENTIFIER		= (CAAMTA_BASE+4)

/* Size of the buffer to allocate for the NAK message, as
   stored in the 'aam_NAKMessage' member of the AddressAllocationMessage. */
NATIVE {CAAMTA_NAKMessageSize}		CONST CAAMTA_NAKMESSAGESIZE		= (CAAMTA_BASE+5)

/* Size of the buffer to allocate for the router address table, as
   stored in the 'aam_RouterTable' member of the AddressAllocationMessage. */
NATIVE {CAAMTA_RouterTableSize}		CONST CAAMTA_ROUTERTABLESIZE		= (CAAMTA_BASE+6)

/* Size of the buffer to allocate for the DNS address table, as
   stored in the 'aam_DNSTable' member of the AddressAllocationMessage. */
NATIVE {CAAMTA_DNSTableSize}		CONST CAAMTA_DNSTABLESIZE		= (CAAMTA_BASE+7)

/* Size of the buffer to allocate for the static route address table, as
   stored in the 'aam_StaticRouteTable' member of the
   AddressAllocationMessage. */
NATIVE {CAAMTA_StaticRouteTableSize}	CONST CAAMTA_STATICROUTETABLESIZE	= (CAAMTA_BASE+8)

/* Size of the buffer to allocate for the host name, as stored in
   the 'aam_HostName' member of the AddressAllocationMessage. */
NATIVE {CAAMTA_HostNameSize}		CONST CAAMTA_HOSTNAMESIZE		= (CAAMTA_BASE+9)

/* Size of the buffer to allocate for the domain name, as stored in
   the 'aam_DomainName' member of the AddressAllocationMessage. */
NATIVE {CAAMTA_DomainNameSize}		CONST CAAMTA_DOMAINNAMESIZE		= (CAAMTA_BASE+10)

/* Size of the buffer to allocate for the BOOTP message, as stored in
   the 'aam_BOOTPMessage' member of the AddressAllocationMessage. */
NATIVE {CAAMTA_BOOTPMessageSize}		CONST CAAMTA_BOOTPMESSAGESIZE		= (CAAMTA_BASE+11)

/* Either FALSE or TRUE; if TRUE, will allocate a buffer for a
   DateStamp and put its address into the 'aam_LeaseExpires'
   member of the AddressAllocationMessage. */
NATIVE {CAAMTA_RecordLeaseExpiration}	CONST CAAMTA_RECORDLEASEEXPIRATION	= (CAAMTA_BASE+12)

/* The MsgPort to send the AddressAllocationMessage to after
   the configuration has finished. */
NATIVE {CAAMTA_ReplyPort}		CONST CAAMTA_REPLYPORT		= (CAAMTA_BASE+13)

/* Codes returned by CreateAddressAllocationMessage(). */
NATIVE {CAAME_Success}			CONST CAAME_SUCCESS			= 0	/* It worked */
NATIVE {CAAME_Invalid_result_ptr}	CONST CAAME_INVALID_RESULT_PTR	= 1	/* No proper result pointer
						   provided */
NATIVE {CAAME_Not_enough_memory}	CONST CAAME_NOT_ENOUGH_MEMORY		= 2	/* No enough memory available */
NATIVE {CAAME_Invalid_version}		CONST CAAME_INVALID_VERSION		= 3	/* The version number is not
						   in order */
NATIVE {CAAME_Invalid_protocol}		CONST CAAME_INVALID_PROTOCOL		= 4	/* The protocol is neither BOOTP
						   nor DHCP */
NATIVE {CAAME_Invalid_interface_name}	CONST CAAME_INVALID_INTERFACE_NAME	= 5	/* The interface name is
						   not OK */
NATIVE {CAAME_Interface_not_found}	CONST CAAME_INTERFACE_NOT_FOUND	= 6	/* The name of the interface
						   is not known */
NATIVE {CAAME_Invalid_client_identifier}	CONST CAAME_INVALID_CLIENT_IDENTIFIER	= 7	/* The client identifier is not
						   OK */
NATIVE {CAAME_Client_identifier_too_short} CONST CAAME_CLIENT_IDENTIFIER_TOO_SHORT = 8	/* The client identifier is too
						   short */
NATIVE {CAAME_Client_identifier_too_long} CONST CAAME_CLIENT_IDENTIFIER_TOO_LONG = 9	/* The client identifier is too
						   long */

/****************************************************************************/

/*
 * The DNS management data structures.
 */

/* These nodes are returned by the DNS API. */
NATIVE {DomainNameServerNode} OBJECT domainnameservernode
	{dnsn_MinNode}	minnode	:mln
	{dnsn_Size}	size	:VALUE	/* Size of this data structure */
	{dnsn_Address}	address	:/*STRPTR*/ ARRAY OF CHAR	/* Points to NUL-terminated string
				   which holds the IP address in
				   dotted-decimal notation */
	{dnsn_UseCount}	usecount	:VALUE	/* Usage count of this address;
				   negative values indicate
				   statically-configured servers. */
ENDOBJECT

/****************************************************************************/

/*
 * Filtering for incoming and outgoing IP packets.
 */

/* This identifies whether a packet was received or is about
   to be sent. Check the IPFilterMsg->ifm_Direction field to
   find out. */
NATIVE {IFMD_Incoming} CONST IFMD_INCOMING = 0	/* Packet was received */
NATIVE {IFMD_Outgoing} CONST IFMD_OUTGOING = 1	/* Packet is about to be sent */

/* The packet filter hook is invoked with a message of
   this type: */
NATIVE {IPFilterMsg} OBJECT ipfiltermsg
	{ifm_Size}	size	:VALUE	/* Size of this data structure */
	{ifm_IP}	ip	:PTR TO ip		/* Points to IP packet header */
	{ifm_IPLength}	iplength	:VALUE	/* Size of the IP packet header */
	{ifm_Interface}	interface	:PTR TO ifnet	/* Interface this packet either
					   came in from or is to be
					   sent to */
	{ifm_Direction}	direction	:VALUE	/* Whether this packet came in
					   or is about to go out */
	{ifm_Packet}	packet	:PTR TO mbuf	/* The entire packet, as stored
					   in a memory buffer */
ENDOBJECT

/****************************************************************************/

/*
 * Network shutdown
 */

/* To shut down the network, send a message of the following form to the
   network controller message port. */
NATIVE {NetShutdownMessage} OBJECT netshutdownmessage
	{nsm_Message}	message	:mn	/* Standard Message header */

	{nsm_Command}	command	:ULONG	/* The action to be performed */

	{nsm_Data}	data	:APTR	/* Payload */
	{nsm_Length}	length	:ULONG	/* Payload size */

	{nsm_Error}	error	:VALUE	/* Whether or not the command
					   suceeded */
	{nsm_Actual}	actual	:ULONG	/* How much data was transferred */
ENDOBJECT

/* The command to be sent to the network controller message port must
   be one of the following: */

NATIVE {NSMC_Shutdown}	CONST NSMC_SHUTDOWN	= 1	/* Shut down the network; a pointer to an
				   ULONG may be placed in nsm_Data (if the
				   shutdown does not succeed, this is where
				   the number of active clients will be
				   placed). */

NATIVE {NSMC_Cancel}	CONST NSMC_CANCEL	= 2	/* Cancel a shutdown request; this recalls
				   a shutdown message, to which a pointer must
				   be placed in nsm_Data. */

/* Error codes that may be set when a message returns: */

NATIVE {NSME_Success}	CONST NSME_SUCCESS	= 0	/* Command was processed successfully */

NATIVE {NSME_Aborted}	CONST NSME_ABORTED	= 1	/* Command was aborted */

NATIVE {NSME_InUse}	CONST NSME_INUSE	= 2	/* Network is still running, since clients are
				   still using it */

NATIVE {NSME_Ignored}	CONST NSME_IGNORED	= 3	/* Command was ignored (network may be shutting
				   down right now) */

NATIVE {NSME_NotFound}	CONST NSME_NOTFOUND	= 4	/* Shutdown command to be cancelled could not
				   be recalled */

/* The name of the public network controller message port: */
NATIVE {NETWORK_CONTROLLER_PORT_NAME} CONST
STATIC network_controller_port_name = 'TCP/IP Control'

/* The network controller message port data structure; you must check the
   magic cookie before you post a message to it. If the cookie value is
   missing, don't send your message: the controller may not be listening
   to it. To be on the safe side, look for the port under Forbid(),
   check the cookie, then post the message. */
NATIVE {NetControlPort} OBJECT netcontrolport
	{ncp_Port}	port	:mp
	{ncp_Magic}	magic	:ULONG
ENDOBJECT

/* The magic cookie stored in ncp_Magic: */
NATIVE {NCPM_Cookie}	CONST NCPM_COOKIE	= $20040306

/****************************************************************************/

/*
 * System data access
 */

/* ObtainRoadshowData() returns a pointer to a list of data items which
   may be viewed or modified. Here is how the list items look like. */
NATIVE {RoadshowDataNode} OBJECT roadshowdatanode
	{rdn_MinNode}	minnode	:mln

	{rdn_Name}	name	:/*STRPTR*/ ARRAY OF CHAR	/* Name assigned to this item */
	{rdn_Flags}	flags	:UINT	/* Properties of this data (see
					   below) */
	{rdn_Type}	type	:INT	/* What kind of data this
					   is (see below) */
	{rdn_Length}	length	:ULONG	/* Size of this data */
	{rdn_Data}	data	:APTR	/* Points to the data */
ENDOBJECT

/* What kind of data is represented by a RoadshowDataNode. */
NATIVE {RDNT_Integer}	CONST RDNT_INTEGER	= 0	/* Signed 32 bit integer */

/* What properties the data associated with a RoadshowDataNode has */
NATIVE {RDNF_ReadOnly}	CONST RDNF_READONLY	= 1 SHL 0	/* This option cannot be modified */

/* Parameter to pass to ObtainRoadshowData(); you can either request read
   or write access. */
NATIVE {ORD_ReadAccess}	CONST ORD_READACCESS	= 0
NATIVE {ORD_WriteAccess}	CONST ORD_WRITEACCESS	= 1

/****************************************************************************/

/*
 * Call-back hook for use with SBTC_ERROR_HOOK
 */
NATIVE {ErrorHookMsg} OBJECT errorhookmsg
	{ehm_Size}	size	:ULONG	/* Size of this data structure; this
				   must be >= 12 */
	{ehm_Action}	action	:ULONG	/* See below for a list of definitions */

	{ehm_Code}	code	:VALUE	/* The error code to use */
ENDOBJECT

/* Which action the hook is to perform */
NATIVE {EHMA_Set_errno}		CONST EHMA_SET_ERRNO		= 1	/* Set the local 'errno' to what is
					   found in ehm_Code */
NATIVE {EHMA_Set_h_errno}	CONST EHMA_SET_H_ERRNO	= 2	/* Set the local 'h_errno' to what is
					   found in ehm_Code */

/****************************************************************************/

/*
 * A pointer to the following data structure can be found in a Process
 * pr_ExitData field if the associated program was launched as a server
 * by the Internet super-server (inetd). You should check it only if your
 * program is known to act as a server because otherwise the contents of
 * the pr_ExitData field are unreliable.
 *
 * The purpose of this data structure is to let your application access the
 * socket allocated for it by the Internet super-server, which can be
 * accomplished as follows:
 * 
 *     extern struct Library * DOSBase;
 *
 *     struct Process * this_process = (struct Process *)FindTask(NULL);
 *     LONG have_server_api = FALSE;
 *     struct DaemonMessage * dm;
 *     LONG socket = -1;
 *
 *     if(SocketBaseTags(
 *         SBTM_GETREF(SBTC_HAVE_SERVER_API),&have_server_api,
 *     TAG_END) == 0)
 *     {
 *         if(have_server_api && ProcessIsServer(this_process))
 *         {
 *             if(DOSBase->lib_Version < 50)
 *                 dm = (struct DaemonMessage *)this_process->pr_ExitData;
 *             else
 *                 dm = (struct DaemonMessage *)GetExitData();
 *
 *             socket = ObtainSocket(dm->dm_ID,dm->dm_Family,dm->dm_Type,0);
 *         }
 *     }
 */

NATIVE {DaemonMessage} OBJECT daemonmessage
	{dm_Message}	message	:mn	/* Used by super-server; don't touch! */
	{dm_Pad1}	pad1	:ULONG	/* Used by super-server; don't touch! */
	{dm_Pad2}	pad2	:ULONG	/* Used by super-server; don't touch! */
	{dm_ID}		id	:VALUE		/* Public socket identifier; this must
					   be passed to ObtainSocket() to
					   access the socket allocated for you */
	{dm_Pad3}	pad3	:ULONG	/* Used by super-server; don't touch! */
	{dm_Family}	family	:UBYTE	/* Socket family type */
	{dm_Type}	type	:UBYTE	/* Socket type */
ENDOBJECT
