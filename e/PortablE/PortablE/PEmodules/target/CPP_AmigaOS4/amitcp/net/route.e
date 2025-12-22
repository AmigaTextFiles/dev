OPT NATIVE, PREPROCESS
MODULE 'target/amitcp/sys/netinclude_types', 'target/amitcp/sys/socket', 'target/amitcp/netinet/tcp_timer', 'target/amitcp/net/if', 'target/amitcp/net/radix'
{#include <net/route.h>}
/*
 * $Id: route.h,v 1.6 2007-08-26 12:30:25 obarthel Exp $
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
 * Copyright (c) 1980, 1986, 1993
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
 *	@(#)route.h	8.5 (Berkeley) 2/8/95
 */

NATIVE {_NET_ROUTE_H} DEF

NATIVE {route} OBJECT route
	{ro_rt}	rt	:PTR TO rtentry
	{ro_dst}	dst	:sockaddr
ENDOBJECT

/*
 * These numbers are used by reliable protocols for determining
 * retransmission behavior and are included in the routing structure.
 */
NATIVE {rt_metrics} OBJECT rt_metrics
	{rmx_locks}	locks	:__ULONG	/* Kernel must leave these values alone */
	{rmx_mtu}	mtu	:__ULONG	/* MTU for this path */
	{rmx_hopcount}	hopcount	:__ULONG	/* max hops expected */
	{rmx_expire}	expire	:__ULONG	/* lifetime for route, e.g. redirect */
	{rmx_recvpipe}	recvpipe	:__ULONG	/* inbound delay-bandwith product */
	{rmx_sendpipe}	sendpipe	:__ULONG	/* outbound delay-bandwith product */
	{rmx_ssthresh}	ssthresh	:__ULONG	/* outbound gateway buffer limit */
	{rmx_rtt}	rtt	:__ULONG	/* estimated round trip time */
	{rmx_rttvar}	rttvar	:__ULONG	/* estimated rtt variance */
	{rmx_pksent}	pksent	:__ULONG	/* packets sent using this route */
ENDOBJECT

/*
 * rmx_rtt and rmx_rttvar are stored as microseconds;
 * RTTTOPRHZ(rtt) converts to a value suitable for use
 * by a protocol slowtimo counter.
 */
NATIVE {RTM_RTTUNIT}	CONST RTM_RTTUNIT	= 1000000	/* units for rtt, rttvar, as units per sec */
NATIVE {RTTTOPRHZ} CONST
->#define RTTTOPRHZ(r)	((r) / (RTM_RTTUNIT / PR_SLOWHZ))
#define RTTTOPRHZ(r) rtttoprhz(r)
PROC rtttoprhz(r) IS NATIVE {RTTTOPRHZ(} r {)} ENDNATIVE !!INT


NATIVE {rtentry} OBJECT rtentry
	{rt_nodes}	nodes[2]	:ARRAY OF radix_node	/* tree glue, and other values */
	{rt_gateway}	gateway	:PTR TO sockaddr	/* value */
	{rt_flags}	flags	:__WORD		/* up/down?, host/net */
	{rt_refcnt}	refcnt	:__WORD		/* # held references */
	{rt_use}	use	:__ULONG			/* raw # packets forwarded */
	{rt_ifp}	ifp	:PTR TO ifnet		/* the answer: interface to use */
	{rt_ifa}	ifa	:PTR TO ifaddr		/* the answer: interface to use */
	{rt_genmask}	genmask	:PTR TO sockaddr	/* for generation of cloned routes */
	{rt_llinfo}	llinfo	:__APTR		/* pointer to link level info cache */
	{rt_rmx}	rmx	:rt_metrics	/* metrics used by rx'ing protocols */
	{rt_gwroute}	gwroute	:PTR TO rtentry	/* implied entry for gatewayed routes */
ENDOBJECT
->PROC rt_key( r:PTR TO rtentry) IS r.nodes[0].key !!VALUE!!PTR TO sockaddr
->PROC rt_mask(r:PTR TO rtentry) IS r.nodes[0].mask!!VALUE!!PTR TO sockaddr
PROC rt_key( r:PTR TO rtentry) IS NATIVE {rt_key(} r {)} ENDNATIVE !!PTR TO sockaddr
PROC rt_mask(r:PTR TO rtentry) IS NATIVE {rt_mask(} r {)} ENDNATIVE !!PTR TO sockaddr
NATIVE {rt_key}  PROC
NATIVE {rt_mask} PROC

/*
 * Following structure necessary for 4.3 compatibility;
 * We should eventually move it to a compat file.
 */
NATIVE {ortentry} OBJECT ortentry
	{rt_hash}	hash	:__ULONG		/* to speed lookups */
	{rt_dst}	dst	:sockaddr	/* key */
	{rt_gateway}	gateway	:sockaddr	/* value */
	{rt_flags}	flags	:__WORD		/* up/down?, host/net */
	{rt_refcnt}	refcnt	:__WORD		/* # held references */
	{rt_use}	use	:__ULONG			/* raw # packets forwarded */
	{rt_ifp}	ifp	:PTR TO ifnet		/* the answer: interface to use */
ENDOBJECT

NATIVE {RTF_UP}		CONST RTF_UP		= $1		/* route usable */
NATIVE {RTF_GATEWAY}	CONST RTF_GATEWAY	= $2		/* destination is a gateway */
NATIVE {RTF_HOST}	CONST RTF_HOST	= $4		/* host entry (net otherwise) */
NATIVE {RTF_REJECT}	CONST RTF_REJECT	= $8		/* host or net unreachable */
NATIVE {RTF_DYNAMIC}	CONST RTF_DYNAMIC	= $10		/* created dynamically (by redirect) */
NATIVE {RTF_MODIFIED}	CONST RTF_MODIFIED	= $20		/* modified dynamically (by redirect) */
NATIVE {RTF_DONE}	CONST RTF_DONE	= $40		/* message confirmed */
NATIVE {RTF_MASK}	CONST RTF_MASK	= $80		/* subnet mask present */
NATIVE {RTF_CLONING}	CONST RTF_CLONING	= $100		/* generate new routes on use */
NATIVE {RTF_XRESOLVE}	CONST RTF_XRESOLVE	= $200		/* external daemon resolves name */
NATIVE {RTF_LLINFO}	CONST RTF_LLINFO	= $400		/* generated by ARP or ESIS */
NATIVE {RTF_STATIC}	CONST RTF_STATIC	= $800		/* manually added */
NATIVE {RTF_BLACKHOLE}	CONST RTF_BLACKHOLE	= $1000		/* just discard pkts (during updates) */
NATIVE {RTF_PROTO2}	CONST RTF_PROTO2	= $4000		/* protocol specific routing flag */
NATIVE {RTF_PROTO1}	CONST RTF_PROTO1	= $8000		/* protocol specific routing flag */


/*
 * Routing statistics.
 */
NATIVE {rtstat} OBJECT rtstat
	{rts_badredirect}	badredirect	:__WORD	/* bogus redirect calls */
	{rts_dynamic}	dynamic	:__WORD		/* routes created by redirects */
	{rts_newgateway}	newgateway	:__WORD		/* routes modified by redirects */
	{rts_unreach}	unreach	:__WORD		/* lookups which failed */
	{rts_wildcard}	wildcard	:__WORD		/* lookups satisfied by a wildcard */
ENDOBJECT
/*
 * Structures for routing messages.
 */
NATIVE {rt_msghdr} OBJECT rt_msghdr
	{rtm_msglen}	msglen	:__UWORD	/* to skip over non-understood messages */
	{rtm_version}	version	:__UBYTE	/* future binary compatibility */
	{rtm_type}	type	:__UBYTE	/* message type */
	{rtm_index}	index	:__UWORD	/* index for associated ifp */
	{rtm_flags}	flags	:__LONG	/* flags, incl. kern & message, e.g. DONE */
	{rtm_addrs}	addrs	:__LONG	/* bitmask identifying sockaddrs in msg */
	{rtm_pid}	pid	:__LONG	/* identify sender */
	{rtm_seq}	seq	:__LONG	/* for sender to identify action */
	{rtm_errno}	errno	:__LONG	/* why failed */
	{rtm_use}	use	:__LONG	/* from rtentry */
	{rtm_inits}	inits	:__ULONG	/* which metrics we are initializing */
	{rtm_rmx}	rmx	:rt_metrics /* metrics themselves */
ENDOBJECT

NATIVE {RTM_VERSION}	CONST RTM_VERSION	= 3	/* Up the ante and ignore older versions */

NATIVE {RTM_ADD}		CONST RTM_ADD		= $1	/* Add Route */
NATIVE {RTM_DELETE}	CONST RTM_DELETE	= $2	/* Delete Route */
NATIVE {RTM_CHANGE}	CONST RTM_CHANGE	= $3	/* Change Metrics or flags */
NATIVE {RTM_GET}		CONST RTM_GET		= $4	/* Report Metrics */
NATIVE {RTM_LOSING}	CONST RTM_LOSING	= $5	/* Kernel Suspects Partitioning */
NATIVE {RTM_REDIRECT}	CONST RTM_REDIRECT	= $6	/* Told to use different route */
NATIVE {RTM_MISS}	CONST RTM_MISS	= $7	/* Lookup failed on this address */
NATIVE {RTM_LOCK}	CONST RTM_LOCK	= $8	/* fix specified metrics */
NATIVE {RTM_OLDADD}	CONST RTM_OLDADD	= $9	/* caused by SIOCADDRT */
NATIVE {RTM_OLDDEL}	CONST RTM_OLDDEL	= $a	/* caused by SIOCDELRT */
NATIVE {RTM_RESOLVE}	CONST RTM_RESOLVE	= $b	/* req to resolve dst to LL addr */
NATIVE {RTM_NEWADDR}	CONST RTM_NEWADDR	= $c	/* address being added to iface */
NATIVE {RTM_DELADDR}	CONST RTM_DELADDR	= $d	/* address being removed from iface */
NATIVE {RTM_IFINFO}	CONST RTM_IFINFO	= $e	/* iface going up/down etc. */

NATIVE {RTV_MTU}		CONST RTV_MTU		= $1	/* init or lock _mtu */
NATIVE {RTV_HOPCOUNT}	CONST RTV_HOPCOUNT	= $2	/* init or lock _hopcount */
NATIVE {RTV_EXPIRE}	CONST RTV_EXPIRE	= $4	/* init or lock _hopcount */
NATIVE {RTV_RPIPE}	CONST RTV_RPIPE	= $8	/* init or lock _recvpipe */
NATIVE {RTV_SPIPE}	CONST RTV_SPIPE	= $10	/* init or lock _sendpipe */
NATIVE {RTV_SSTHRESH}	CONST RTV_SSTHRESH	= $20	/* init or lock _ssthresh */
NATIVE {RTV_RTT}		CONST RTV_RTT		= $40	/* init or lock _rtt */
NATIVE {RTV_RTTVAR}	CONST RTV_RTTVAR	= $80	/* init or lock _rttvar */

/*
 * Bitmask values for rtm_addr.
 */
NATIVE {RTA_DST}		CONST RTA_DST		= $1	/* destination sockaddr present */
NATIVE {RTA_GATEWAY}	CONST RTA_GATEWAY	= $2	/* gateway sockaddr present */
NATIVE {RTA_NETMASK}	CONST RTA_NETMASK	= $4	/* netmask sockaddr present */
NATIVE {RTA_GENMASK}	CONST RTA_GENMASK	= $8	/* cloning mask sockaddr present */
NATIVE {RTA_IFP}		CONST RTA_IFP		= $10	/* interface name sockaddr present */
NATIVE {RTA_IFA}		CONST RTA_IFA		= $20	/* interface addr sockaddr present */
NATIVE {RTA_AUTHOR}	CONST RTA_AUTHOR	= $40	/* sockaddr for author of redirect */
NATIVE {RTA_BRD}		CONST RTA_BRD		= $80	/* for NEWADDR, broadcast or p-p dest addr */

/*
 * Index offsets for sockaddr array for alternate internal encoding.
 */
NATIVE {RTAX_DST}	CONST RTAX_DST	= 0	/* destination sockaddr present */
NATIVE {RTAX_GATEWAY}	CONST RTAX_GATEWAY	= 1	/* gateway sockaddr present */
NATIVE {RTAX_NETMASK}	CONST RTAX_NETMASK	= 2	/* netmask sockaddr present */
NATIVE {RTAX_GENMASK}	CONST RTAX_GENMASK	= 3	/* cloning mask sockaddr present */
NATIVE {RTAX_IFP}	CONST RTAX_IFP	= 4	/* interface name sockaddr present */
NATIVE {RTAX_IFA}	CONST RTAX_IFA	= 5	/* interface addr sockaddr present */
NATIVE {RTAX_AUTHOR}	CONST RTAX_AUTHOR	= 6	/* sockaddr for author of redirect */
NATIVE {RTAX_BRD}	CONST RTAX_BRD	= 7	/* for NEWADDR, broadcast or p-p dest addr */
NATIVE {RTAX_MAX}	CONST RTAX_MAX	= 8	/* size of array to allocate */

NATIVE {rt_addrinfo} OBJECT rt_addrinfo
	{rti_addrs}	addrs	:__LONG
	{rti_info}	info[RTAX_MAX]	:ARRAY OF PTR TO sockaddr
ENDOBJECT

NATIVE {route_cb} OBJECT route_cb
	{ip_count}	ip_count	:__LONG
	{ns_count}	ns_count	:__LONG
	{iso_count}	iso_count	:__LONG
	{any_count}	any_count	:__LONG
ENDOBJECT
