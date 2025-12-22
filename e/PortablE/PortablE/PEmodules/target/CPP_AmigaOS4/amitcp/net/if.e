OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/amitcp/sys/timeval'
MODULE 'target/amitcp/sys/netinclude_types', 'target/amitcp/sys/socket', 'target/amitcp/net/if_arp'
{#include <net/if.h>}
/*
 * $Id: if.h,v 1.7 2007-08-26 12:30:25 obarthel Exp $
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
 * Copyright (c) 1982, 1986, 1989, 1993
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
 *	@(#)if.h	8.3 (Berkeley) 2/9/95
 */

NATIVE {_NET_IF_H} DEF

/****************************************************************************/

/* 'struct if_data' and 'struct ifqueue' used to be defined within
 * 'struct ifnet', which is problematic for use with C++.
 */
NATIVE {if_data} OBJECT if_data
	/* generic interface information */
	{ifi_type}	type	:__UBYTE	/* ethernet, tokenring, etc */
	{ifi_addrlen}	addrlen	:__UBYTE	/* media address length */
	{ifi_hdrlen}	hdrlen	:__UBYTE	/* media header length */
	{ifi_mtu}	mtu	:__ULONG	/* maximum transmission unit */
	{ifi_metric}	metric	:__ULONG	/* routing metric (external only) */
	{ifi_baudrate}	baudrate	:__ULONG	/* linespeed */
	/* volatile statistics */
	{ifi_ipackets}	ipackets	:__ULONG	/* packets received on interface */
	{ifi_ierrors}	ierrors	:__ULONG	/* input errors on interface */
	{ifi_opackets}	opackets	:__ULONG	/* packets sent on interface */
	{ifi_oerrors}	oerrors	:__ULONG	/* output errors on interface */
	{ifi_collisions}	collisions	:__ULONG	/* collisions on csma interfaces */
	{ifi_ibytes}	ibytes	:__ULONG	/* total number of octets received */
	{ifi_obytes}	obytes	:__ULONG	/* total number of octets sent */
	{ifi_imcasts}	imcasts	:__ULONG	/* packets received via multicast */
	{ifi_omcasts}	omcasts	:__ULONG	/* packets sent via multicast */
	{ifi_iqdrops}	iqdrops	:__ULONG	/* dropped on input, this interface */
	{ifi_noproto}	noproto	:__ULONG	/* destined for unsupported protocol */
	{ifi_lastchange}	lastchange	:__timeval/* last updated */
ENDOBJECT

NATIVE {ifqueue} OBJECT ifqueue
	{ifq_head}	head	:__APTR
	{ifq_tail}	tail	:__APTR
	{ifq_len}	len	:__LONG
	{ifq_maxlen}	maxlen	:__LONG
	{ifq_drops}	drops	:__LONG
ENDOBJECT

NATIVE {ifnet} OBJECT ifnet
	{if_name}	name	:__STRPTR	/* name, e.g. ``en'' or ``lo'' */
	{if_next}	next	:PTR TO ifnet	/* all struct ifnets are chained */
	{if_addrlist}	addrlist	:PTR TO ifaddr	/* linked list of addresses per if */
        {if_pcount}	pcount	:__LONG	/* number of promiscuous listeners */
	{if_bpf}	bpf	:__APTR		/* packet filter structure */
	{if_index}	index	:__UWORD	/* numeric abbreviation for this if  */
	{if_unit}	unit	:__WORD	/* sub-unit for lower level driver */
	{if_timer}	timer	:__WORD	/* time 'til if_watchdog called */
	{if_flags}	flags	:__UWORD	/* up/down, broadcast, etc. */
	{if_data}	data	:if_data	/* generic interface information */
/* procedure handles */
	{if_init}	init	:__APTR	/* init routine */
	{if_output}	output	:__APTR	/* output routine (enqueue) */
	{if_start}	start	:__APTR	/* initiate output routine */
	{if_done}	done	:__APTR	/* output complete routine */
	{if_ioctl}	ioctl	:__APTR	/* ioctl routine */
	{if_reset}	reset	:__APTR	
	{if_watchdog}	watchdog	:__APTR	/* timer routine */
	{if_snd}	snd	:ifqueue		/* output queue */
ENDOBJECT
NATIVE {if_mtu}		DEF
NATIVE {if_type}	DEF
NATIVE {if_addrlen}	DEF
NATIVE {if_hdrlen}	DEF
NATIVE {if_metric}	DEF
NATIVE {if_baudrate}	DEF
NATIVE {if_ipackets}	DEF
NATIVE {if_ierrors}	DEF
NATIVE {if_opackets}	DEF
NATIVE {if_oerrors}	DEF
NATIVE {if_collisions}	DEF
NATIVE {if_ibytes}	DEF
NATIVE {if_obytes}	DEF
NATIVE {if_imcasts}	DEF
NATIVE {if_omcasts}	DEF
NATIVE {if_iqdrops}	DEF
NATIVE {if_noproto}	DEF
NATIVE {if_lastchange}	DEF

NATIVE {IFF_UP}		CONST IFF_UP		= $1		/* interface is up */
NATIVE {IFF_BROADCAST}	CONST IFF_BROADCAST	= $2		/* broadcast address valid */
NATIVE {IFF_DEBUG}	CONST IFF_DEBUG	= $4		/* turn on debugging */
NATIVE {IFF_LOOPBACK}	CONST IFF_LOOPBACK	= $8		/* is a loopback net */
NATIVE {IFF_POINTOPOINT}	CONST IFF_POINTTOPOINT	= $10		/* interface is point-to-point link */
NATIVE {IFF_NOTRAILERS}	CONST IFF_NOTRAILERS	= $20		/* avoid use of trailers */
NATIVE {IFF_RUNNING}	CONST IFF_RUNNING	= $40		/* resources allocated */
NATIVE {IFF_NOARP}	CONST IFF_NOARP	= $80		/* no address resolution protocol */
NATIVE {IFF_PROMISC}	CONST IFF_PROMISC	= $100		/* receive all packets */
NATIVE {IFF_ALLMULTI}	CONST IFF_ALLMULTI	= $200		/* receive all multicast packets */
NATIVE {IFF_OACTIVE}	CONST IFF_OACTIVE	= $400		/* transmission in progress */
NATIVE {IFF_SIMPLEX}	CONST IFF_SIMPLEX	= $800		/* can't hear own transmissions */
NATIVE {IFF_LINK0}	CONST IFF_LINK0	= $1000		/* per link layer defined bit */
NATIVE {IFF_LINK1}	CONST IFF_LINK1	= $2000		/* per link layer defined bit */
NATIVE {IFF_LINK2}	CONST IFF_LINK2	= $4000		/* per link layer defined bit */
NATIVE {IFF_MULTICAST}	CONST IFF_MULTICAST	= $8000		/* supports multicast */

/* flags set internally only: */
NATIVE {IFF_CANTCHANGE} CONST IFF_CANTCHANGE = (IFF_BROADCAST OR IFF_POINTTOPOINT OR IFF_RUNNING OR IFF_OACTIVE OR IFF_SIMPLEX OR IFF_MULTICAST OR IFF_ALLMULTI)

/*
 * The ifaddr structure contains information about one address
 * of an interface.  They are maintained by the different address families,
 * are allocated and attached when an address is set, and are linked
 * together so all addresses for an interface can be located.
 */
NATIVE {ifaddr} OBJECT ifaddr
	{ifa_addr}	addr	:PTR TO sockaddr	/* address of interface */
	{ifa_dstaddr}	dstaddr	:PTR TO sockaddr	/* other end of p-to-p link */
	{ifa_netmask}	netmask	:PTR TO sockaddr	/* used to determine subnet */
	{ifa_ifp}	ifp	:PTR TO ifnet		/* back-pointer to interface */
	{ifa_next}	next	:PTR TO ifaddr	/* next address for interface */
	{ifa_rtrequest}	rtrequest	:__APTR		/* check or clean routes (+ or -)'d */
	{ifa_flags}	flags	:__UWORD		/* mostly rt_flags for cloning */
	{ifa_refcnt}	refcnt	:__WORD		/* extra to malloc for link info */
	{ifa_metric}	metric	:__LONG		/* cost of going out this interface */
ENDOBJECT
NATIVE {ifa_broadaddr}	OBJECT	/* broadcast address interface */
NATIVE {IFA_ROUTE}	CONST ->IFA_ROUTE	= RTF_UP		/* route installed */

/*
 * Message format for use in obtaining information about interfaces
 * from getkerninfo and the routing socket
 */
NATIVE {if_msghdr} OBJECT if_msghdr
	{ifm_msglen}	msglen	:__UWORD	/* to skip over non-understood messages */
	{ifm_version}	version	:__UBYTE	/* future binary compatability */
	{ifm_type}	type	:__UBYTE	/* message type */
	{ifm_addrs}	addrs	:__LONG	/* like rtm_addrs */
	{ifm_flags}	flags	:__LONG	/* value of if_flags */
	{ifm_index}	index	:__UWORD	/* index for associated ifp */
	{ifm_data}	data	:if_data/* statistics and other data about if */
ENDOBJECT

/*
 * Message format for use in obtaining information about interface addresses
 * from getkerninfo and the routing socket
 */
NATIVE {ifa_msghdr} OBJECT ifa_msghdr
	{ifam_msglen}	msglen	:__UWORD	/* to skip over non-understood messages */
	{ifam_version}	version	:__UBYTE	/* future binary compatability */
	{ifam_type}	type	:__UBYTE	/* message type */
	{ifam_addrs}	addrs	:__LONG	/* like rtm_addrs */
	{ifam_flags}	flags	:__LONG	/* value of ifa_flags */
	{ifam_index}	index	:__UWORD	/* index for associated ifp */
	{ifam_metric}	metric	:__LONG	/* value of ifa_metric */
ENDOBJECT

/*
 * Interface request structure used for socket
 * ioctl's.  All interface ioctl's must have parameter
 * definitions which begin with ifr_name.  The
 * remainder may be interface specific.
 */
NATIVE {IFNAMSIZ} CONST IFNAMSIZ =	16
NATIVE {ifreq} OBJECT ifreq
	{ifr_name}	name[IFNAMSIZ]	:ARRAY OF __TEXT		/* if name, e.g. "en0" */
	{ifr_ifru.ifru_addr}	addr	:sockaddr	/* address */
	{ifr_ifru.ifru_dstaddr}	dstaddr	:sockaddr	/* other end of p-to-p link */
	{ifr_ifru.ifru_broadaddr}	broadaddr	:sockaddr	/* broadcast address */
	{ifr_ifru.ifru_flags}	flags	:__WORD	/* flags */
	{ifr_ifru.ifru_metric}	metric	:__LONG	/* metric */
	{ifr_ifru.ifru_data}	data	:__APTR	/* for use by interface */
ENDOBJECT

NATIVE {ifaliasreq} OBJECT ifaliasreq
	{ifra_name}	name[IFNAMSIZ]	:ARRAY OF __TEXT		/* if name, e.g. "en0" */
	{ifra_addr}	addr	:sockaddr
	{ifra_broadaddr}	broadaddr	:sockaddr
	{ifra_mask}	mask	:sockaddr
ENDOBJECT

/*
 * Structure used in SIOCGIFCONF request.
 * Used to retrieve interface configuration
 * for machine (useful for programs which
 * must know all networks accessible).
 */
NATIVE {ifconf} OBJECT ifconf
	{ifc_len}	len	:__LONG		/* size of associated buffer */
	{ifc_ifcu.ifcu_buf}	buf	:__APTR
	{ifc_ifcu.ifcu_req}	req	:PTR TO ifreq
ENDOBJECT
