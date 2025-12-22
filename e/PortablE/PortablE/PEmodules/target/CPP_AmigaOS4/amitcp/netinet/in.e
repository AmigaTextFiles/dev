OPT NATIVE, PREPROCESS
MODULE 'target/amitcp/sys/netinclude_types', 'target/amitcp/sys/socket'
{#include <netinet/in.h>}
/*
 * $Id: in.h,v 1.7 2007-08-26 12:30:25 obarthel Exp $
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

/*
 * Copyright (c) 1982, 1986, 1990, 1993
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by the University of
 *	California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	@(#)in.h	8.3 (Berkeley) 1/3/94
 */

NATIVE {_NETINET_IN_H} DEF

/*
 * Constants and structures defined by the internet system,
 * Per RFC 790, September 1981, and numerous additions.
 */

/*
 * Data types.
 */
NATIVE {in_addr_t} OBJECT
TYPE IN_ADDR_T IS NATIVE {in_addr_t} VALUE
NATIVE {in_port_t} OBJECT
TYPE IN_PORT_T IS NATIVE {in_port_t} INT

/*
 * Protocols
 */
NATIVE {IPPROTO_IP}		CONST IPPROTO_IP		= 0		/* dummy for IP */
NATIVE {IPPROTO_ICMP}		CONST IPPROTO_ICMP		= 1		/* control message protocol */
NATIVE {IPPROTO_IGMP}		CONST IPPROTO_IGMP		= 2		/* group mgmt protocol */
NATIVE {IPPROTO_GGP}		CONST IPPROTO_GGP		= 3		/* gateway^2 (deprecated) */
NATIVE {IPPROTO_TCP}		CONST IPPROTO_TCP		= 6		/* tcp */
NATIVE {IPPROTO_EGP}		CONST IPPROTO_EGP		= 8		/* exterior gateway protocol */
NATIVE {IPPROTO_PUP}		CONST IPPROTO_PUP		= 12		/* pup */
NATIVE {IPPROTO_UDP}		CONST IPPROTO_UDP		= 17		/* user datagram protocol */
NATIVE {IPPROTO_IDP}		CONST IPPROTO_IDP		= 22		/* xns idp */
NATIVE {IPPROTO_TP}		CONST IPPROTO_TP		= 29 		/* tp-4 w/ class negotiation */
NATIVE {IPPROTO_EON}		CONST IPPROTO_EON		= 80		/* ISO cnlp */
NATIVE {IPPROTO_ENCAP}		CONST IPPROTO_ENCAP		= 98		/* encapsulation header */

NATIVE {IPPROTO_RAW}		CONST IPPROTO_RAW		= 255		/* raw IP packet */
NATIVE {IPPROTO_MAX}		CONST IPPROTO_MAX		= 256


/*
 * Local port number conventions:
 * Ports < IPPORT_RESERVED are reserved for
 * privileged processes (e.g. root).
 * Ports > IPPORT_USERRESERVED are reserved
 * for servers, not necessarily privileged.
 */
NATIVE {IPPORT_RESERVED}		CONST IPPROTO_RESERVED		= 1024
NATIVE {IPPORT_USERRESERVED}	CONST IPPROTO_USERRESERVED	= 5000

/*
 * Internet address (a structure for historical reasons)
 */
NATIVE {in_addr} OBJECT in_addr
	{s_addr}	addr	:IN_ADDR_T
ENDOBJECT

/*
 * Definitions of bits in internet address integers.
 * On subnets, the decomposition of addresses to host and net parts
 * is done according to subnet mask, not the masks here.
 */
NATIVE {IN_CLASSA} CONST
->#define IN_CLASSA(i) (((i) AND $80000000)=0)
PROC in_classa(i) IS NATIVE {IN_CLASSA(} i {)} ENDNATIVE !!BOOL
#define IN_CLASSA(i) in_classa(i)
NATIVE {IN_CLASSA_NET}		CONST IN_CLASSA_NET		= $ff000000
NATIVE {IN_CLASSA_NSHIFT}	CONST IN_CLASSA_NSHIFT	= 24
NATIVE {IN_CLASSA_HOST}		CONST IN_CLASSA_HOST		= $00ffffff
NATIVE {IN_CLASSA_MAX}		CONST IN_CLASSA_MAX		= 128

NATIVE {IN_CLASSB} CONST
->#define IN_CLASSB(i) (((i) AND $C0000000)=$80000000)
PROC in_classb(i) IS NATIVE {IN_CLASSB(} i {)} ENDNATIVE !!BOOL
#define IN_CLASSB(i) in_classb(i)
NATIVE {IN_CLASSB_NET}		CONST IN_CLASSB_NET		= $ffff0000
NATIVE {IN_CLASSB_NSHIFT}	CONST IN_CLASSB_NSHIFT	= 16
NATIVE {IN_CLASSB_HOST}		CONST IN_CLASSB_HOST		= $0000ffff
NATIVE {IN_CLASSB_MAX}		CONST IN_CLASSB_MAX		= 65536

NATIVE {IN_CLASSC} CONST
->#define IN_CLASSC(i) (((i) AND $E0000000)=$C0000000)
PROC in_classc(i) IS NATIVE {IN_CLASSC(} i {)} ENDNATIVE !!BOOL
#define IN_CLASSC(i) in_classc(i)
NATIVE {IN_CLASSC_NET}		CONST IN_CLASSC_NET		= $ffffff00
NATIVE {IN_CLASSC_NSHIFT}	CONST IN_CLASSC_NSHIFT	= 8
NATIVE {IN_CLASSC_HOST}		CONST IN_CLASSC_HOST		= $000000ff

NATIVE {IN_CLASSD} CONST
->#define IN_CLASSD(i) (((i) AND $F0000000)=$E0000000)
PROC in_classd(i) IS NATIVE {IN_CLASSD(} i {)} ENDNATIVE !!BOOL
#define IN_CLASSD(i) in_classd(i)
NATIVE {IN_CLASSD_NET}		CONST IN_CLASSD_NET		= $f0000000	/* These ones aren't really */
NATIVE {IN_CLASSD_NSHIFT}	CONST IN_CLASSD_NSHIFT	= 28		/* net and host fields, but */
NATIVE {IN_CLASSD_HOST}		CONST IN_CLASSD_HOST		= $0fffffff	/* routing needn't know.    */
NATIVE {IN_MULTICAST} CONST
->#define IN_MULTICAST(i) IN_CLASSD(i)
PROC in_multicast(i) IS NATIVE {IN_MULTICAST(} i {)} ENDNATIVE !!BOOL
#define IN_MULTICAST(i) in_multicast(i)

NATIVE {IN_EXPERIMENTAL} CONST
->#define IN_EXPERIMENTAL(i) (((i) AND $F0000000)=$F0000000)
PROC in_experimental(i) IS NATIVE {IN_EXPERIMENTAL(} i {)} ENDNATIVE !!BOOL
#define IN_EXPERIMENTAL(i) in_experimental(i)
NATIVE {IN_BADCLASS} CONST
->#define IN_BADCLASS(i) (((i) AND $F0000000)=$F0000000)
PROC in_badclass(i) IS NATIVE {IN_BADCLASS(} i {)} ENDNATIVE !!BOOL
#define IN_BADCLASS(i) in_badclass(i)

NATIVE {INADDR_ANY}		CONST INADDR_ANY		= $00000000
NATIVE {INADDR_BROADCAST}	CONST INADDR_BROADCAST	= $ffffffff	/* must be masked */
NATIVE {INADDR_NONE}		CONST INADDR_NONE		= $ffffffff	/* -1 return */

NATIVE {INADDR_UNSPEC_GROUP}	CONST INADDR_UNSPEC_GROUP	= $e0000000	/* 224.0.0.0 */
NATIVE {INADDR_ALLHOSTS_GROUP}	CONST INADDR_ALLHOSTS_GROUP	= $e0000001	/* 224.0.0.1 */
NATIVE {INADDR_MAX_LOCAL_GROUP}	CONST INADDR_MAX_LOCAL_GROUP	= $e00000ff	/* 224.0.0.255 */

NATIVE {IN_LOOPBACKNET}		CONST IN_LOOPBRACKNET		= 127			/* official! */

/*
 * Socket address, internet style.
 */
NATIVE {sockaddr_in} OBJECT sockaddr_in
	{sin_len}	len	:__UBYTE
	{sin_family}	family	:SA_FAMILY_T
	{sin_port}	port	:IN_PORT_T
	{sin_addr}	addr	:in_addr
	{sin_zero}	zero[8]	:ARRAY OF __UBYTE
ENDOBJECT

/*
 * Structure used to describe IP options.
 * Used to store options internally, to pass them to a process,
 * or to restore options retrieved earlier.
 * The ip_dst is used for the first-hop gateway when using a source route
 * (this gets put into the header proper).
 */
NATIVE {ip_opts} OBJECT ip_opts
	{ip_dst}	dst	:in_addr		/* first hop, 0 w/o src rt */
	{ip_options}	opts[40]	:ARRAY OF __UBYTE		/* actually variable in size */
ENDOBJECT

/*
 * Options for use with [gs]etsockopt at the IP level.
 * First word of comment is data type; bool is stored in int.
 */
NATIVE {IP_OPTIONS}		CONST IP_OPTIONS		= 1    /* buf/ip_opts; set/get IP options */
NATIVE {IP_HDRINCL}		CONST IP_HDRINCL		= 2    /* __LONG; header is included with data */
NATIVE {IP_TOS}			CONST IP_TOS			= 3    /* __LONG; IP type of service and preced. */
NATIVE {IP_TTL}			CONST IP_TTL			= 4    /* __LONG; IP time to live */
NATIVE {IP_RECVOPTS}		CONST IP_RECVOPTS		= 5    /* bool; receive all IP opts w/dgram */
NATIVE {IP_RECVRETOPTS}		CONST IP_RECVRETOPTS		= 6    /* bool; receive IP opts for response */
NATIVE {IP_RECVDSTADDR}		CONST IP_RECVDSTADDR		= 7    /* bool; receive IP dst addr w/dgram */
NATIVE {IP_RETOPTS}		CONST IP_RETOPTS		= 8    /* ip_opts; set/get IP options */
NATIVE {IP_MULTICAST_IF}	CONST IP_MULTICAST_IF		= 9    /* __UBYTE; set/get IP multicast i/f  */
NATIVE {IP_MULTICAST_TTL}	CONST IP_MULTICAST_TTL	= 10   /* __UBYTE; set/get IP multicast ttl */
NATIVE {IP_MULTICAST_LOOP}	CONST IP_MULTICAST_LOOP	= 11   /* __UBYTE; set/get IP multicast loopback */
NATIVE {IP_ADD_MEMBERSHIP}	CONST IP_ADD_MEMBERSHIP	= 12   /* ip_mreq; add an IP group membership */
NATIVE {IP_DROP_MEMBERSHIP}	CONST IP_DROP_MEMBERSHIP	= 13   /* ip_mreq; drop an IP group membership */

/*
 * Defaults and limits for options
 */
NATIVE {IP_DEFAULT_MULTICAST_TTL}  CONST IP_DEFAULT_MULTICAST_TTL  = 1	/* normally limit m'casts to 1 hop  */
NATIVE {IP_DEFAULT_MULTICAST_LOOP} CONST IP_DEFAULT_MULTICAST_LOOP = 1	/* normally hear sends if a member  */
NATIVE {IP_MAX_MEMBERSHIPS}	CONST IP_MAX_MEMBERSHIPS	= 20	/* per socket; must fit in one mbuf */

/*
 * Argument structure for IP_ADD_MEMBERSHIP and IP_DROP_MEMBERSHIP.
 */
NATIVE {ip_mreq} OBJECT ip_mreq
	{imr_multiaddr}	multiaddr	:in_addr	/* IP multicast address of group */
	{imr_interface}	interface	:in_addr	/* local IP address of interface */
ENDOBJECT

/*
 * Definitions for inet sysctl operations.
 *
 * Third level is protocol number.
 * Fourth level is desired variable within that protocol.
 */
NATIVE {IPPROTO_MAXID}	CONST IPPROTO_MAXID	= (IPPROTO_IDP + 1)	/* don't list to IPPROTO_MAX */

/*
 * Names for IP sysctl objects
 */
NATIVE {IPCTL_FORWARDING}	CONST IPCTL_FORWARDING	= 1	/* act as router */
NATIVE {IPCTL_SENDREDIRECTS}	CONST IPCTL_SENDREDIRECTS	= 2	/* may send redirects when forwarding */
NATIVE {IPCTL_DEFTTL}		CONST IPCTL_DEFTTL		= 3	/* default TTL */
->#ifdef notyet
NATIVE {IPCTL_DEFMTU}		CONST IPCTL_DEFMTU		= 4	/* default MTU */
->#endif
NATIVE {IPCTL_MAXID}		CONST IPCTL_MAXID		= 5

/****************************************************************************/

/*
 * Macros for network/external number representation conversion.
 */
NATIVE {ntohl} PROC
NATIVE {ntohs} PROC
NATIVE {htonl} PROC
NATIVE {htons} PROC
->#define	ntohl(x) (x)
->#define	ntohs(x) (x)
->#define	htonl(x) (x)
->#define	htons(x) (x)
PROC ntohl(x) IS NATIVE {ntohl(} x {)} ENDNATIVE !!VALUE
PROC ntohs(x) IS NATIVE {ntohs(} x {)} ENDNATIVE !!VALUE
PROC htonl(x) IS NATIVE {htonl(} x {)} ENDNATIVE !!VALUE
PROC htons(x) IS NATIVE {htons(} x {)} ENDNATIVE !!VALUE

NATIVE {NTOHL} CONST
NATIVE {NTOHS} CONST
NATIVE {HTONL} CONST
NATIVE {HTONS} CONST
->#define	NTOHL(x) (x)
->#define	NTOHS(x) (x)
->#define	HTONL(x) (x)
->#define	HTONS(x) (x)
#define	NTOHL(x) ntohl(x)
#define	NTOHS(x) ntohs(x)
#define	HTONL(x) htonl(x)
#define	HTONS(x) htons(x)
