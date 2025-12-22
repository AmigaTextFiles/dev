OPT NATIVE, PREPROCESS
MODULE 'target/amitcp/sys/netinclude_types', 'target/amitcp/sys/socket'
{#include <net/if_arp.h>}
/*
 * $Id: if_arp.h,v 1.6 2007-08-26 12:30:25 obarthel Exp $
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
 * Copyright (c) 1986, 1993
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
 *	@(#)if_arp.h	8.1 (Berkeley) 6/10/93
 */

NATIVE {_NET_IF_ARP_H} DEF

/*
 * Address Resolution Protocol.
 *
 * See RFC 826 for protocol description.  ARP packets are variable
 * in size; the arphdr structure defines the fixed-length portion.
 * Protocol type values are the same as those for 10 Mb/s Ethernet.
 * It is followed by the variable-sized fields ar_sha, arp_spa,
 * arp_tha and arp_tpa in that order, according to the lengths
 * specified.  Field names used correspond to RFC 826.
 */
NATIVE {arphdr} OBJECT arphdr
	{ar_hrd}	hrd	:__UWORD		/* format of hardware address */
	{ar_pro}	pro	:__UWORD		/* format of protocol address */
	{ar_hln}	hln	:__UBYTE		/* length of hardware address */
	{ar_pln}	pln	:__UBYTE		/* length of protocol address */
	{ar_op}		op	:__UWORD		/* one of: */
/*
 * The remaining fields are variable in size,
 * according to the sizes above.
 */
->#ifdef COMMENT_ONLY
->	{ar_sha}	sha[]	:ARRAY OF __UBYTE	/* sender hardware address */
->	{ar_spa}	spa[]	:ARRAY OF __UBYTE	/* sender protocol address */
->	{ar_tha}	tha[]	:ARRAY OF __UBYTE	/* target hardware address */
->	{ar_tpa}	tpa[]	:ARRAY OF __UBYTE	/* target protocol address */
->#endif
ENDOBJECT
NATIVE {ARPHRD_ETHER} 	CONST ARPHRD_ETHER 	= 1	/* ethernet hardware format */
NATIVE {ARPHRD_FRELAY} 	CONST ARPHRD_FRELAY 	= 15	/* frame relay hardware format */

NATIVE {ARPOP_REQUEST}	CONST ARPOP_REQUEST	= 1	/* request to resolve address */
NATIVE {ARPOP_REPLY}	CONST ARPOP_REPLY	= 2	/* response to previous request */
NATIVE {ARPOP_REVREQUEST} CONST ARPOP_REVREQUEST = 3	/* request protocol address given hardware */
NATIVE {ARPOP_REVREPLY}	CONST ARPOP_REVREPLY	= 4	/* response giving protocol address */
NATIVE {ARPOP_INVREQUEST} CONST ARPOP_INVREQUEST = 8 	/* request to identify peer */
NATIVE {ARPOP_INVREPLY}	CONST ARPOP_INVREPLY	= 9	/* response identifying peer */

/*
 * ARP ioctl request
 */
NATIVE {arpreq} OBJECT arpreq
	{arp_pa}	pa	:sockaddr		/* protocol address */
	{arp_ha}	ha	:sockaddr		/* hardware address */
	{arp_flags}	flags	:__LONG			/* flags */
ENDOBJECT
/*  arp_flags and at_flags field values */
NATIVE {ATF_INUSE}	CONST ATF_INUSE	= $01	/* entry in use */
NATIVE {ATF_COM}		CONST ATF_COM		= $02	/* completed entry (enaddr valid) */
NATIVE {ATF_PERM}	CONST ATF_PERM	= $04	/* permanent entry */
NATIVE {ATF_PUBL}	CONST ATF_PUBL	= $08	/* publish entry (respond for other host) */
NATIVE {ATF_USETRAILERS}	CONST ATF_USETRAILERS	= $10	/* has requested trailers */
