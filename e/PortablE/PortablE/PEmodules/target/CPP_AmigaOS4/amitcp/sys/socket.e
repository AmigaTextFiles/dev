OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/amitcp/sys/timeval', 'target/amitcp/sys/uio'
MODULE 'target/amitcp/sys/netinclude_types' /*, 'target/amitcp/sys/uio'*/
{#include <sys/socket.h>}

->Declared inside 'libraries/bsdsocket':
->SET FD_ACCEPT, FD_CONNECT, FD_OOB, FD_READ, FD_WRITE, FD_ERROR, FD_CLOSE
->CONST UNIQUE_ID=-1

/*
 * $Id: socket.h,v 1.11 2007-08-26 12:30:26 obarthel Exp $
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
 * Copyright (c) 1982, 1985, 1986, 1988, 1993, 1994
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
 *	@(#)socket.h	8.6 (Berkeley) 5/3/95
 */

NATIVE {_SYS_SOCKET_H} DEF

/****************************************************************************/

/*
 * Definitions related to sockets: types, address families, options.
 */

/*
 * Data types.
 */
NATIVE {sa_family_t} OBJECT
TYPE SA_FAMILY_T IS NATIVE {sa_family_t} CHAR
NATIVE {socklen_t} OBJECT
TYPE SOCKLEN_T IS NATIVE {socklen_t} VALUE

/*
 * Types
 */
NATIVE {SOCK_STREAM}	CONST SOCK_STREAM	= 1		/* stream socket */
NATIVE {SOCK_DGRAM}	CONST SOCK_DGRAM	= 2		/* datagram socket */
NATIVE {SOCK_RAW}	CONST SOCK_RAW	= 3		/* raw-protocol interface */
NATIVE {SOCK_RDM}	CONST SOCK_RDM	= 4		/* reliably-delivered message */
NATIVE {SOCK_SEQPACKET}	CONST SOCK_SEQPACKET	= 5		/* sequenced packet stream */

/*
 * Option flags per-socket.
 */
NATIVE {SO_DEBUG}	CONST SO_DEBUG	= $0001		/* turn on debugging info recording */
NATIVE {SO_ACCEPTCONN}	CONST SO_ACCEPTCONN	= $0002		/* socket has had listen() */
NATIVE {SO_REUSEADDR}	CONST SO_REUSEADDR	= $0004		/* allow local address reuse */
NATIVE {SO_KEEPALIVE}	CONST SO_KEEPALIVE	= $0008		/* keep connections alive */
NATIVE {SO_DONTROUTE}	CONST SO_DONTROUTE	= $0010		/* just use interface addresses */
NATIVE {SO_BROADCAST}	CONST SO_BROADCAST	= $0020		/* permit sending of broadcast msgs */
NATIVE {SO_USELOOPBACK}	CONST SO_USELOOPBACK	= $0040		/* bypass hardware when possible */
NATIVE {SO_LINGER}	CONST SO_LINGER	= $0080		/* linger on close if data present */
NATIVE {SO_OOBINLINE}	CONST SO_OOBINLINE	= $0100		/* leave received OOB data in line */
NATIVE {SO_REUSEPORT}	CONST SO_REUSEPORT	= $0200		/* allow local address & port reuse */

/*
 * Additional options, not kept in so_options.
 */
NATIVE {SO_SNDBUF}	CONST SO_SNDBUF	= $1001		/* send buffer size */
NATIVE {SO_RCVBUF}	CONST SO_RCVBUF	= $1002		/* receive buffer size */
NATIVE {SO_SNDLOWAT}	CONST SO_SNDLOWAT	= $1003		/* send low-water mark */
NATIVE {SO_RCVLOWAT}	CONST SO_RCVLOWAT	= $1004		/* receive low-water mark */
NATIVE {SO_SNDTIMEO}	CONST SO_SNDTIMEO	= $1005		/* send timeout */
NATIVE {SO_RCVTIMEO}	CONST SO_RCVTIMEO	= $1006		/* receive timeout */
NATIVE {SO_ERROR}	CONST SO_ERROR	= $1007		/* get error status and clear */
NATIVE {SO_TYPE}		CONST SO_TYPE		= $1008		/* get socket type */

/* This is a private option which is used exclusively
 * by this Amiga TCP/IP stack implementation and should not
 * be used by user code.
 */
NATIVE {SO_EVENTMASK}	CONST SO_EVENTMASK	= $2001

/*
 * Structure used for manipulating linger option.
 */
NATIVE {linger} OBJECT linger
	{l_onoff}	onoff	:__LONG		/* option on/off */
	{l_linger}	linger	:__LONG		/* linger time in seconds */
ENDOBJECT

/*
 * Level number for (get/set)sockopt() to apply to socket itself.
 */
NATIVE {SOL_SOCKET}	CONST SOL_SOCKET	= $ffff		/* options for socket level */

/*
 * Address families.
 */
NATIVE {AF_UNSPEC}	CONST AF_UNSPEC	= 0		/* unspecified */
NATIVE {AF_LOCAL}	CONST AF_LOCAL	= 1		/* local to host (pipes, portals) */
NATIVE {AF_UNIX}		CONST AF_UNIX		= AF_LOCAL	/* backward compatibility */
NATIVE {AF_INET}		CONST AF_INET		= 2		/* internetwork: UDP, TCP, etc. */
NATIVE {AF_IMPLINK}	CONST AF_IMPLINK	= 3		/* arpanet imp addresses */
NATIVE {AF_PUP}		CONST AF_PUP		= 4		/* pup protocols: e.g. BSP */
NATIVE {AF_CHAOS}	CONST AF_CHAOS	= 5		/* mit CHAOS protocols */
NATIVE {AF_NS}		CONST AF_NS		= 6		/* XEROX NS protocols */
NATIVE {AF_ISO}		CONST AF_ISO		= 7		/* ISO protocols */
NATIVE {AF_OSI}		CONST AF_OSI		= AF_ISO
NATIVE {AF_ECMA}		CONST AF_ECMA		= 8		/* european computer manufacturers */
NATIVE {AF_DATAKIT}	CONST AF_DATAKIT	= 9		/* datakit protocols */
NATIVE {AF_CCITT}	CONST AF_CCITT	= 10		/* CCITT protocols, X.25 etc */
NATIVE {AF_SNA}		CONST AF_SNA		= 11		/* IBM SNA */
NATIVE {AF_DECnet}	CONST AF_DECNET	= 12		/* DECnet */
NATIVE {AF_DLI}		CONST AF_DLI		= 13		/* DEC Direct data link interface */
NATIVE {AF_LAT}		CONST AF_LAT		= 14		/* LAT */
NATIVE {AF_HYLINK}	CONST AF_HYLINK	= 15		/* NSC Hyperchannel */
NATIVE {AF_APPLETALK}	CONST AF_APPLETALK	= 16		/* Apple Talk */
NATIVE {AF_ROUTE}	CONST AF_ROUTE	= 17		/* Internal Routing Protocol */
NATIVE {AF_LINK}		CONST AF_LINK		= 18		/* Link layer interface */
NATIVE {pseudo_AF_XTP}	CONST PSEUDO_AF_XTP	= 19		/* eXpress Transfer Protocol (no AF) */
NATIVE {AF_COIP}		CONST AF_COIP		= 20		/* connection-oriented IP, aka ST II */
NATIVE {AF_CNT}		CONST AF_CNT		= 21		/* Computer Network Technology */
NATIVE {pseudo_AF_RTIP}	CONST PSEUDO_AF_RTIP	= 22		/* Help Identify RTIP packets */
NATIVE {AF_IPX}		CONST AF_IPX		= 23		/* Novell Internet Protocol */
NATIVE {AF_SIP}		CONST AF_SIP		= 24		/* Simple Internet Protocol */
NATIVE {pseudo_AF_PIP}	CONST PSEUDO_AF_PIP	= 25		/* Help Identify PIP packets */

NATIVE {AF_MAX}		CONST AF_MAX		= 26

/*
 * Structure used by kernel to store most
 * addresses.
 */
NATIVE {sockaddr} OBJECT sockaddr
	{sa_len}	len	:__UBYTE			/* total length */
	{sa_family}	family	:SA_FAMILY_T		/* address family */
	{sa_data}	data[14]	:ARRAY OF __UBYTE		/* actually longer; address value */
ENDOBJECT

/*
 * Structure used by kernel to pass protocol
 * information in raw sockets.
 */
NATIVE {sockproto} OBJECT sockproto
	{sp_family}	family	:__UWORD		/* address family */
	{sp_protocol}	protocol	:__UWORD		/* protocol */
ENDOBJECT

/*
 * Protocol families, same as address families for now.
 */
NATIVE {PF_UNSPEC}	CONST PF_UNSPEC	= AF_UNSPEC
NATIVE {PF_LOCAL}	CONST PF_LOCAL	= AF_LOCAL
NATIVE {PF_UNIX}		CONST PF_UNIX		= PF_LOCAL	/* backward compatibility */
NATIVE {PF_INET}		CONST PF_INET		= AF_INET
NATIVE {PF_IMPLINK}	CONST PF_IMPLINK	= AF_IMPLINK
NATIVE {PF_PUP}		CONST PF_PUP		= AF_PUP
NATIVE {PF_CHAOS}	CONST PF_CHAOS	= AF_CHAOS
NATIVE {PF_NS}		CONST PF_NS		= AF_NS
NATIVE {PF_ISO}		CONST PF_ISO		= AF_ISO
NATIVE {PF_OSI}		CONST PF_OSI		= AF_ISO
NATIVE {PF_ECMA}		CONST PF_ECMA		= AF_ECMA
NATIVE {PF_DATAKIT}	CONST PF_DATAKIT	= AF_DATAKIT
NATIVE {PF_CCITT}	CONST PF_CCITT	= AF_CCITT
NATIVE {PF_SNA}		CONST PF_SNA		= AF_SNA
NATIVE {PF_DECnet}	CONST PF_DECNET	= AF_DECNET
NATIVE {PF_DLI}		CONST PF_DLI		= AF_DLI
NATIVE {PF_LAT}		CONST PF_LAT		= AF_LAT
NATIVE {PF_HYLINK}	CONST PF_HYLINK	= AF_HYLINK
NATIVE {PF_APPLETALK}	CONST PF_APPLETALK	= AF_APPLETALK
NATIVE {PF_ROUTE}	CONST PF_ROUTE	= AF_ROUTE
NATIVE {PF_LINK}		CONST PF_LINK		= AF_LINK
NATIVE {PF_XTP}		CONST PSEUDO_PF_XTP		= PSEUDO_AF_XTP	/* really just proto family, no AF */
NATIVE {PF_COIP}		CONST PF_COIP		= AF_COIP
NATIVE {PF_CNT}		CONST PF_CNT		= AF_CNT
NATIVE {PF_SIP}		CONST PF_SIP		= AF_SIP
NATIVE {PF_IPX}		CONST PF_IPX		= AF_IPX		/* same format as AF_NS */
NATIVE {PF_RTIP}		CONST PF_RTIP		= PSEUDO_AF_RTIP	/* same format as AF_INET */	-># "pseudo_AF_FTIP" did not exist, so guessed it should have been "pseudo_AF_RTIP"
NATIVE {PF_PIP}		CONST PF_PIP		= PSEUDO_AF_PIP

NATIVE {PF_MAX}		CONST PF_MAX		= AF_MAX

/*
 * Definitions for network related sysctl, CTL_NET.
 *
 * Second level is protocol family.
 * Third level is protocol number.
 *
 * Further levels are defined by the individual families below.
 */
NATIVE {NET_MAXID}	CONST NET_MAXID	= AF_MAX

/*
 * PF_ROUTE - Routing table
 *
 * Three additional levels are defined:
 *	Fourth: address family, 0 is wildcard
 *	Fifth: type of info, defined below
 *	Sixth: flag(s) to mask with for NET_RT_FLAGS
 */
NATIVE {NET_RT_DUMP}	CONST NET_RT_DUMP	= 1		/* dump; may limit to a.f. */
NATIVE {NET_RT_FLAGS}	CONST NET_RT_FLAGS	= 2		/* by flags, e.g. RESOLVING */
NATIVE {NET_RT_IFLIST}	CONST NET_RT_IFLIST	= 3		/* survey interface list */
NATIVE {NET_RT_MAXID}	CONST NET_RT_MAXID	= 4

/*
 * Maximum queue length specifiable by listen.
 */
NATIVE {SOMAXCONN}	CONST SOMAXCONN	= 5

/*
 * Message header for recvmsg and sendmsg calls.
 * Used value-result for recvmsg, value only for sendmsg.
 */
NATIVE {msghdr} OBJECT msghdr
	{msg_name}	name	:__APTR		/* optional address */
	{msg_namelen}	namelen	:SOCKLEN_T		/* size of address */
	{msg_iov}	iov	:ARRAY OF iovec		/* scatter/gather array */
	{msg_iovlen}	iovlen	:__ULONG		/* # elements in msg_iov */
	{msg_control}	control	:__APTR		/* ancillary data, see below */
	{msg_controllen}	controllen	:SOCKLEN_T		/* ancillary data buffer len */
	{msg_flags}	flags	:__LONG		/* flags on received message */
ENDOBJECT

NATIVE {MSG_OOB}		CONST MSG_OOB		= $1		/* process out-of-band data */
NATIVE {MSG_PEEK}	CONST MSG_PEEK	= $2		/* peek at incoming message */
NATIVE {MSG_DONTROUTE}	CONST MSG_DONTROUTE	= $4		/* send without using routing tables */
NATIVE {MSG_EOR}		CONST MSG_EOR		= $8		/* data completes record */
NATIVE {MSG_TRUNC}	CONST MSG_TRUNC	= $10		/* data discarded before delivery */
NATIVE {MSG_CTRUNC}	CONST MSG_CTRUNC	= $20		/* control data lost before delivery */
NATIVE {MSG_WAITALL}	CONST MSG_WAITALL	= $40		/* wait for full request or error */
NATIVE {MSG_DONTWAIT}	CONST MSG_DONTWAIT	= $80		/* this message should be nonblocking */

/*
 * Header for ancillary data objects in msg_control buffer.
 * Used for additional information with/about a datagram
 * not expressible by flags.  The format is a sequence
 * of message elements headed by cmsghdr structures.
 */
NATIVE {cmsghdr} OBJECT cmsghdr
	{cmsg_len}	len	:SOCKLEN_T		/* data byte count, including hdr */
	{cmsg_level}	level	:__LONG		/* originating protocol */
	{cmsg_type}	type	:__LONG		/* protocol-specific type */
/* followed by	__UBYTE  cmsg_data[]; */
ENDOBJECT

/* given pointer to struct cmsghdr, return pointer to data */
NATIVE {CMSG_DATA} CONST
PROC cmsg_data(cmsg:PTR TO cmsghdr) IS NATIVE {CMSG_DATA(} cmsg {)} ENDNATIVE !!ARRAY
#define CMSG_DATA(cmsg) cmsg_data(cmsg)

/* given pointer to struct cmsghdr, return pointer to next cmsghdr */
NATIVE {CMSG_NXTHDR} CONST
->this uses a buggy C macro declaration: PROC cmsg_nxthdr(mhdr:PTR TO msghdr, cmsg:PTR TO cmsghdr) IS NATIVE {CMSG_NXTHDR(} mhdr {,} cmsg {)} ENDNATIVE !!PTR TO cmsghdr
->#define CMSG_NXTHDR(mhdr,cmsg) cmsg_nxthdr(mhdr,cmsg)

NATIVE {CMSG_FIRSTHDR} CONST
PROC cmsg_firsthdr(mhdr:PTR TO msghdr) IS NATIVE {CMSG_FIRSTHDR(} mhdr {)} ENDNATIVE !!PTR TO cmsghdr
#define CMSG_FIRSTHDR(mhdr) cmsg_firsthdr(mhdr)

/* "Socket"-level control message types: */
NATIVE {SCM_RIGHTS}	CONST SCM_RIGHTS	= $01		/* access rights (array of __LONG) */

/*
 * The following comes from the original <sys/types.h> header file,
 * which has been retired in favour of the <sys/netinclude_types.h>
 * type definitions. What remains are the macros in support of the
 * "select()" call and those for endian-neutral operations.
 */

/****************************************************************************/

->AmigaE declared this in 'amitcp/sys/types'

/*
 * In case the select() data structures and macros are already
 * defined by somebody else...
 */

->#ifndef FD_SET

NATIVE {NBBY} CONST NBBY = 8	/* number of bits in a byte */

/*
 * Select uses bit masks of file descriptors in longs.  These macros
 * manipulate such bit fields (the filesystem macros use chars).
 * FD_SETSIZE may be defined by the user, but the default here should
 * be enough for most uses.
 */
NATIVE {FD_SETSIZE} CONST FD_SETSIZE = 256

NATIVE {fd_mask} OBJECT
TYPE FD_MASK IS NATIVE {fd_mask} VALUE
NATIVE {NFDBITS}	CONST NFDBITS	= (SIZEOF FD_MASK * NBBY) /* bits per mask */

NATIVE {howmany} PROC
#private
#define howmany(x, y)	(((x) + ((y) - 1)) / (y))
#public

NATIVE {fd_set} OBJECT fd_set
	{fds_bits} bits[howmany(FD_SETSIZE, NFDBITS)]:ARRAY OF FD_MASK
ENDOBJECT

NATIVE {FD_SET} CONST
NATIVE {FD_CLR} CONST
NATIVE {FD_ISSET} CONST
NATIVE {FD_COPY} CONST
NATIVE {FD_ZERO} CONST

PROC fd_set(n, p:PTR TO fd_set) IS NATIVE {FD_SET(} n {,} p {)} ENDNATIVE
PROC fd_clr(n, p:PTR TO fd_set) IS NATIVE {FD_CLR(} n {,} p {)} ENDNATIVE
PROC fd_isset(n, p:PTR TO fd_set) IS NATIVE {FD_ISSET(} n {,} p {)} ENDNATIVE !!VALUE
->PROC fd_copy(f:PTR, t:PTR) IS NATIVE {FD_COPY(} f {,} t {)} ENDNATIVE
PROC fd_zero(p:PTR TO fd_set) IS NATIVE {FD_ZERO(} p {)} ENDNATIVE

#define FD_SET(n,p) fd_set(n,p)
#define FD_CLR(n,p) fd_clr(n,p)
#define FD_ISSET(n,p) fd_isset(n,p)
->#define FD_COPY(f,t) fd_copy(f,t)
#define FD_ZERO(p) fd_zero(p)

->#endif /* FD_SET */

/****************************************************************************/

NATIVE {tv_sec}  DEF
NATIVE {tv_usec} DEF
