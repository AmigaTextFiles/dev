OPT NATIVE, PREPROCESS
MODULE 'target/amitcp/sys/netinclude_types', 'target/amitcp/sys/errno', 'target/amitcp/netinet/in'
{#include <netdb.h>}

->#define _PATH_DB            'AmiTCP:db'
->#define _PATH_AMITCP_CONFIG 'AmiTCP:db/AmiTCP.config'
->#define _PATH_HEQUIV        'AmiTCP:db/hosts.equiv'
->#define _PATH_INETDCONF     'AmiTCP:db/inetd.conf'

/*
 * $Id: netdb.h,v 1.7 2007-08-26 12:30:20 obarthel Exp $
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
 * ++Copyright++ 1980, 1983, 1988, 1993
 * -
 * Copyright (c) 1980, 1983, 1988, 1993
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
 * -
 * Portions Copyright (c) 1993 by Digital Equipment Corporation.
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies, and that
 * the name of Digital Equipment Corporation not be used in advertising or
 * publicity pertaining to distribution of the document or software without
 * specific, written prior permission.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND DIGITAL EQUIPMENT CORP. DISCLAIMS ALL
 * WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS.   IN NO EVENT SHALL DIGITAL EQUIPMENT
 * CORPORATION BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
 * DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
 * PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS
 * ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
 * SOFTWARE.
 * -
 * --Copyright--
 */

/*
 *      @(#)netdb.h	8.1 (Berkeley) 6/2/93
 *	$NetBSD: netdb.h,v 1.8 1997/10/13 09:26:06 lukem Exp $
 */

NATIVE {_NETDB_H} DEF

/* This used to be in <sys/param.h> */
NATIVE {MAXHOSTNAMELEN} CONST MAXHOSTNAMELEN = 256 /* max hostname size */

/*
 * Structures returned by network data base library.  All addresses are
 * supplied in host order, and returned in network order (suitable for
 * use in system calls).
 */
NATIVE {hostent} OBJECT hostent
	{h_name}	name	:__STRPTR		/* official name of host */
	{h_aliases}	aliases	:ARRAY OF __STRPTR	/* alias list */
	{h_addrtype}	addrtype	:__LONG	/* host address type */
	{h_length}	length	:__LONG	/* length of address */
	{h_addr_list}	addr_list	:ARRAY OF ARRAY OF __BYTE	/* list of addresses from name server */
ENDOBJECT
NATIVE {h_addr} DEF		/* address, for backward compatiblity */

/*
 * Assumption here is that a network number
 * fits in an unsigned long -- probably a poor one.
 */
NATIVE {netent} OBJECT netent
	{n_name}	name	:__STRPTR		/* official name of net */
	{n_aliases}	aliases	:ARRAY OF __STRPTR	/* alias list */
	{n_addrtype}	addrtype	:__LONG	/* net address type */
	{n_net}	net	:IN_ADDR_T		/* network # */
ENDOBJECT

NATIVE {servent} OBJECT servent
	{s_name}	name	:__STRPTR		/* official service name */
	{s_aliases}	aliases	:ARRAY OF __STRPTR	/* alias list */
	{s_port}	port	:__LONG		/* port # */
	{s_proto}	proto	:__STRPTR	/* protocol to use */
ENDOBJECT

NATIVE {protoent} OBJECT protoent
	{p_name}	name	:__STRPTR		/* official protocol name */
	{p_aliases}	aliases	:ARRAY OF __STRPTR	/* alias list */
	{p_proto}	proto	:__LONG	/* protocol # */
ENDOBJECT

/*
 * Error return codes from gethostbyname() and gethostbyaddr()
 * (left in extern int h_errno).
 */

NATIVE {NETDB_INTERNAL}	CONST NETDB_INTERNAL	= -1		/* see errno */
NATIVE {NETDB_SUCCESS}	CONST NETDB_SUCCESS	= 0		/* no problem */
NATIVE {HOST_NOT_FOUND}	CONST HOST_NOT_FOUND	= 1 		/* Authoritative Answer Host not found */
NATIVE {TRY_AGAIN}		CONST TRY_AGAIN	= 2 		/* Non-Authoritive Host not found, or SERVERFAIL */
NATIVE {NO_RECOVERY}	CONST NO_RECOVERY	= 3 		/* Non recoverable errors, FORMERR, REFUSED, NOTIMP */
NATIVE {NO_DATA}		CONST NO_DATA		= 4 		/* Valid name, no data record of requested type */
NATIVE {NO_ADDRESS}		CONST NO_ADDRESS	= NO_DATA		/* no address, look for MX record */
