OPT NATIVE, PREPROCESS
MODULE 'target/amitcp/sys/netinclude_types', 'target/amitcp/netinet/ip'
MODULE 'target/amitcp/netinet/in'
{#include <netinet/ip_icmp.h>}
/*
 * $Id: ip_icmp.h,v 1.6 2007-08-26 12:30:25 obarthel Exp $
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
 * Copyright (c) 1982, 1986, 1993
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
 *	@(#)ip_icmp.h	8.1 (Berkeley) 6/10/93
 */

NATIVE {_NETINET_IP_ICMP_H} DEF

/*
 * Interface Control Message Protocol Definitions.
 * Per RFC 792, September 1981.
 */

/*
 * Structure of an icmp header.
 */
NATIVE {icmp} OBJECT icmp
	{icmp_type}	type	:__UBYTE		/* type of message, see below */
	{icmp_code}	code	:__UBYTE		/* type sub code */
	{icmp_cksum}	cksum	:__UWORD		/* ones complement cksum of struct */
	{icmp_hun.ih_pptr}	pptr	:__UBYTE		/* ICMP_PARAMPROB */
	{icmp_hun.ih_gwaddr}	gwaddr	:in_addr	/* ICMP_REDIRECT */
	{icmp_hun.ih_idseq.icd_id}	id	:__UWORD
	{icmp_hun.ih_idseq.icd_seq}	seq	:__UWORD
	{icmp_hun.ih_void}	void	:__LONG

	/* ICMP_UNREACH_NEEDFRAG -- Path MTU Discovery (RFC1191) */
	{icmp_hun.ih_pmtu.ipm_void}	pmvoid	:__UWORD    
	{icmp_hun.ih_pmtu.ipm_nextmtu}	nextmtu	:__UWORD
	{icmp_dun.id_ts.its_otime}	otime	:__ULONG
	{icmp_dun.id_ts.its_rtime}	rtime	:__ULONG
	{icmp_dun.id_ts.its_ttime}	ttime	:__ULONG
	{icmp_dun.id_ip.idi_ip}	ip	:ip
	/* options and then 64 bits of data */
	{icmp_dun.id_mask}	mask	:__ULONG
	{icmp_dun.id_data}	data	:ARRAY OF __UBYTE
ENDOBJECT
NATIVE {icmp_pptr}	CONST
NATIVE {icmp_gwaddr}	CONST
NATIVE {icmp_id}	CONST
NATIVE {icmp_seq}	CONST
NATIVE {icmp_void}	CONST
NATIVE {icmp_pmvoid}	CONST
NATIVE {icmp_nextmtu}	CONST
NATIVE {icmp_otime}	CONST
NATIVE {icmp_rtime}	CONST
NATIVE {icmp_ttime}	CONST
NATIVE {icmp_ip}	CONST
NATIVE {icmp_mask}	CONST
NATIVE {icmp_data}	CONST

/*
 * Lower bounds on packet lengths for various types.
 * For the error advice packets must first insure that the
 * packet is large enought to contain the returned ip header.
 * Only then can we do the check to see if 64 bits of packet
 * data have been returned, since we need to check the returned
 * ip header length.
 */
NATIVE {ICMP_MINLEN}	CONST ICMP_MINLEN	= 8				/* abs minimum */
NATIVE {ICMP_TSLEN}	CONST ICMP_TSLEN	= (8 + 3 * SIZEOF __ULONG)	/* timestamp */
NATIVE {ICMP_MASKLEN}	CONST ICMP_MASKLEN	= 12				/* address mask */
NATIVE {ICMP_ADVLENMIN}	CONST ->ICMP_ADVLENMIN	= (8 + SIZEOF ip + 8)	/* min */
PROC icmp_advlenmin() IS NATIVE {ICMP_ADVLENMIN} ENDNATIVE !!BYTE
#define ICMP_ADVLENMIN icmp_advlenmin()
NATIVE {ICMP_ADVLEN} CONST
->#define ICMP_ADVLEN(p)	(8 + ((p).ip.hl SHL 2) + 8)
PROC icmp_advlen(p:PTR TO icmp) IS NATIVE {ICMP_ADVLEN(} p {)} ENDNATIVE !!BYTE
#define ICMP_ADVLEN(p) icmp_advlen(p)
	/* N.B.: must separately check that ip_hl >= 5 */

/*
 * Definition of type and code field values.
 */
NATIVE {ICMP_ECHOREPLY}		CONST ICMP_ECHOREPLY		= 0		/* echo reply */
NATIVE {ICMP_UNREACH}		CONST ICMP_UNREACH		= 3		/* dest unreachable, codes: */
NATIVE {ICMP_UNREACH_NET}	CONST ICMP_UNREACH_NET	= 0		/* bad net */
NATIVE {ICMP_UNREACH_HOST}	CONST ICMP_UNREACH_HOST	= 1		/* bad host */
NATIVE {ICMP_UNREACH_PROTOCOL}	CONST ICMP_UNREACH_PROTOCOL	= 2		/* bad protocol */
NATIVE {ICMP_UNREACH_PORT}	CONST ICMP_UNREACH_PORT	= 3		/* bad port */
NATIVE {ICMP_UNREACH_NEEDFRAG}	CONST ICMP_UNREACH_NEEDFRAG	= 4		/* IP_DF caused drop */
NATIVE {ICMP_UNREACH_SRCFAIL}	CONST ICMP_UNREACH_SRCFAIL	= 5		/* src route failed */
NATIVE {ICMP_UNREACH_NET_UNKNOWN} CONST ICMP_UNREACH_NET_UNKNOWN = 6		/* unknown net */
NATIVE {ICMP_UNREACH_HOST_UNKNOWN} CONST ICMP_UNREACH_HOST_UNKNOWN = 7		/* unknown host */
NATIVE {ICMP_UNREACH_ISOLATED}	CONST ICMP_UNREACH_ISOLATED	= 8		/* src host isolated */
NATIVE {ICMP_UNREACH_NET_PROHIB}	CONST ICMP_UNREACH_NET_PROHIB	= 9		/* prohibited access */
NATIVE {ICMP_UNREACH_HOST_PROHIB} CONST ICMP_UNREACH_HOST_PROHIB = 10		/* ditto */
NATIVE {ICMP_UNREACH_TOSNET}	CONST ICMP_UNREACH_TOSNET	= 11		/* bad tos for net */
NATIVE {ICMP_UNREACH_TOSHOST}	CONST ICMP_UNREACH_TOSHOST	= 12		/* bad tos for host */
NATIVE {ICMP_SOURCEQUENCH}	CONST ICMP_SOURCEQUENCH	= 4		/* packet lost, slow down */
NATIVE {ICMP_REDIRECT}		CONST ICMP_REDIRECT		= 5		/* shorter route, codes: */
NATIVE {ICMP_REDIRECT_NET}	CONST ICMP_REDIRECT_NET	= 0		/* for network */
NATIVE {ICMP_REDIRECT_HOST}	CONST ICMP_REDIRECT_HOST	= 1		/* for host */
NATIVE {ICMP_REDIRECT_TOSNET}	CONST ICMP_REDIRECT_TOSNET	= 2		/* for tos and net */
NATIVE {ICMP_REDIRECT_TOSHOST}	CONST ICMP_REDIRECT_TOSHOST	= 3		/* for tos and host */
NATIVE {ICMP_ECHO}		CONST ICMP_ECHO		= 8		/* echo service */
NATIVE {ICMP_ROUTERADVERT}	CONST ICMP_ROUTERADVERT	= 9		/* router advertisement */
NATIVE {ICMP_ROUTERSOLICIT}	CONST ICMP_ROUTERSOLICIT	= 10		/* router solicitation */
NATIVE {ICMP_TIMXCEED}		CONST ICMP_TIMXCEED		= 11		/* time exceeded, code: */
NATIVE {ICMP_TIMXCEED_INTRANS}	CONST ICMP_TIMXCEED_INTRANS	= 0		/* ttl==0 in transit */
NATIVE {ICMP_TIMXCEED_REASS}	CONST ICMP_TIMXCEED_REASS	= 1		/* ttl==0 in reass */
NATIVE {ICMP_PARAMPROB}		CONST ICMP_PARAMPROB		= 12		/* ip header bad */
NATIVE {ICMP_PARAMPROB_OPTABSENT} CONST ICMP_PARAMPROB_OPTABSENT = 1		/* req. opt. absent */
NATIVE {ICMP_TSTAMP}		CONST ICMP_TSTAMP		= 13		/* timestamp request */
NATIVE {ICMP_TSTAMPREPLY}	CONST ICMP_TSTAMPREPLY	= 14		/* timestamp reply */
NATIVE {ICMP_IREQ}		CONST ICMP_IREQ		= 15		/* information request */
NATIVE {ICMP_IREQREPLY}		CONST ICMP_IREQREPLY		= 16		/* information reply */
NATIVE {ICMP_MASKREQ}		CONST ICMP_MASKREQ		= 17		/* address mask request */
NATIVE {ICMP_MASKREPLY}		CONST ICMP_MASKREPLY		= 18		/* address mask reply */

NATIVE {ICMP_MAXTYPE}		CONST ICMP_MAXTYPE		= 18

NATIVE {ICMP_INFOTYPE} CONST
->#define ICMP_INFOTYPE(type) (((type)=ICMP_ECHOREPLY) OR ((type)=ICMP_ECHO) OR ((type)=ICMP_ROUTERADVERT) OR ((type)=ICMP_ROUTERSOLICIT) OR ((type)=ICMP_TSTAMP) OR ((type)=ICMP_TSTAMPREPLY) OR ((type)=ICMP_IREQ) OR ((type)=ICMP_IREQREPLY) OR ((type)=ICMP_MASKREQ) OR ((type)=ICMP_MASKREPLY))
PROC icmp_infotype(type) IS NATIVE {ICMP_INFOTYPE(} type {)} ENDNATIVE !!BOOL
#define ICMP_INFOTYPE(type) icmp_infotype(type)
