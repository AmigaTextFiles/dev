OPT NATIVE, PREPROCESS
MODULE 'target/amitcp/sys/netinclude_types'
{#include <netinet/tcp.h>}

#define tcp_seq TCP_SEQ

PROC tcphdr_off(t:PTR TO tcphdr) IS t.off
PROC tcphdr_x2( t:PTR TO tcphdr) IS t.x2

PROC set_tcphdr_off(t:PTR TO tcphdr, off:RANGE 0 TO 15)
  t.off := off
ENDPROC

PROC set_tcphdr_x2(t:PTR TO tcphdr, x2:RANGE 0 TO 15)
  t.x2 := x2
ENDPROC

/*
 * $Id: tcp.h,v 1.6 2007-08-26 12:30:25 obarthel Exp $
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
 *	@(#)tcp.h	8.1 (Berkeley) 6/10/93
 */

NATIVE {_NETINET_TCP_H} DEF

NATIVE {tcp_seq} OBJECT
TYPE TCP_SEQ IS NATIVE {tcp_seq} VALUE

/*
 * TCP header.
 * Per RFC 793, September, 1981.
 */
NATIVE {tcphdr} OBJECT tcphdr
	{th_sport}	sport	:__UWORD		/* source port */
	{th_dport}	dport	:__UWORD		/* destination port */
	{th_seq}	seq	:TCP_SEQ			/* sequence number */
	{th_ack}	ack	:TCP_SEQ			/* acknowledgement number */
	{th_off}	off	:RANGE 0 TO 15	/* data offset */
	{th_x2}		x2	:RANGE 0 TO 15		/* (unused) */
	{th_flags}	flags	:__UBYTE
	{th_win}	win	:__UWORD			/* window */
	{th_sum}	sum	:__UWORD			/* checksum */
	{th_urp}	urp	:__UWORD			/* urgent pointer */
ENDOBJECT
NATIVE {TH_FIN}	CONST TH_FIN	= $01
NATIVE {TH_SYN}	CONST TH_SYN	= $02
NATIVE {TH_RST}	CONST TH_RST	= $04
NATIVE {TH_PUSH}	CONST TH_PUSH	= $08
NATIVE {TH_ACK}	CONST TH_ACK	= $10
NATIVE {TH_URG}	CONST TH_URG	= $20

NATIVE {TCPOPT_EOL}		CONST TCPOPT_EOL		= 0
NATIVE {TCPOPT_NOP}		CONST TCPOPT_NOP		= 1
NATIVE {TCPOPT_MAXSEG}		CONST TCPOPT_MAXSEG		= 2
NATIVE {TCPOLEN_MAXSEG}		CONST TCPOLEN_MAXSEG		= 4
NATIVE {TCPOPT_WINDOW}		CONST TCPOPT_WINDOW		= 3
NATIVE {TCPOLEN_WINDOW}		CONST TCPOLEN_WINDOW		= 3
NATIVE {TCPOPT_SACK_PERMITTED}	CONST TCPOPT_SACK_PERMITTED	= 4		/* Experimental */
NATIVE {TCPOLEN_SACK_PERMITTED}	CONST TCPOLEN_SACK_PERMITTED	= 2
NATIVE {TCPOPT_SACK}		CONST TCPOPT_SACK		= 5		/* Experimental */
NATIVE {TCPOPT_TIMESTAMP}	CONST TCPOPT_TIMESTAMP	= 8
NATIVE {TCPOLEN_TIMESTAMP}	CONST TCPOLEN_TIMESTAMP		= 10
NATIVE {TCPOLEN_TSTAMP_APPA}	CONST TCPOLEN_TSTAMP_APPA		= (TCPOLEN_TIMESTAMP+2) /* appendix A */

NATIVE {TCPOPT_TSTAMP_HDR}	CONST TCPOPT_TSTAMP_HDR	= ((TCPOPT_NOP SHL 24) OR (TCPOPT_NOP SHL 16) OR (TCPOPT_TIMESTAMP SHL 8) OR TCPOLEN_TIMESTAMP)

/*
 * Default maximum segment size for TCP.
 * With an IP MSS of 576, this is 536,
 * but 512 is probably more convenient.
 * This should be defined as MIN(512, IP_MSS - sizeof (struct tcpiphdr)).
 */
NATIVE {TCP_MSS}	CONST TCP_MSS	= 512

NATIVE {TCP_MAXWIN}	CONST TCP_MAXWIN	= 65535	/* largest value for (unscaled) window */

NATIVE {TCP_MAX_WINSHIFT}	CONST TCP_MAX_WINSHIFT	= 14	/* maximum window shift */

/*
 * User-settable options (used with setsockopt).
 */
NATIVE {TCP_NODELAY}	CONST TCP_NODELAY	= $01	/* don't delay send to coalesce packets */
NATIVE {TCP_MAXSEG}	CONST TCP_MAXSEG	= $02	/* set maximum segment size */
