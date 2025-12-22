OPT NATIVE, PREPROCESS
MODULE 'target/amitcp/sys/netinclude_types', 'target/amitcp/netinet/in'
{#include <netinet/ip.h>}

PROC ip_v( i:PTR TO ip) IS i.v
PROC ip_hl(i:PTR TO ip) IS i.hl

PROC set_ip_v(i:PTR TO ip, v:RANGE 0 TO 15)
  i.v := v
ENDPROC

PROC set_ip_hl(i:PTR TO ip, hl:RANGE 0 TO 15)
  i.hl := hl
ENDPROC


PROC ip_timestamp_oflw(i:PTR TO ip_timestamp) IS i.oflw
PROC ip_timestamp_flg( i:PTR TO ip_timestamp) IS i.flg

PROC set_ip_timestamp_oflw(i:PTR TO ip_timestamp, oflw:RANGE 0 TO 15)
  i.oflw := oflw
ENDPROC

PROC set_ip_timestamp_flg(i:PTR TO ip_timestamp, flg:RANGE 0 TO 15)
  i.flg := flg
ENDPROC


NATIVE {ipt_ta} OBJECT ipt_ta
	{ipt_addr}	addr	:in_addr
	{ipt_time}	time	:__ULONG
ENDOBJECT

/*
 * $Id: ip.h,v 1.6 2007-08-26 12:30:25 obarthel Exp $
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
 *	@(#)ip.h	8.2 (Berkeley) 6/1/94
 */

NATIVE {_NETINET_IP_H} DEF

/*
 * Definitions for internet protocol version 4.
 * Per RFC 791, September 1981.
 */
NATIVE {IPVERSION} CONST IPVERSION = 4

/*
 * Structure of an internet header, naked of options.
 *
 * We declare ip_len and ip_off to be __WORD, rather than __UWORD
 * pragmatically since otherwise unsigned comparisons can result
 * against negative integers quite easily, and fail in subtle ways.
 */
NATIVE {ip} OBJECT ip
	{ip_v}		v	:RANGE 0 TO 15			/* version */
	{ip_hl}		hl	:RANGE 0 TO 15		/* header length */
	{ip_tos}	tos	:__UBYTE			/* type of service */
	{ip_len}	len	:__WORD			/* total length */
	{ip_id}		id	:__UWORD			/* identification */
	{ip_off}	off	:__WORD			/* fragment offset field */
	{ip_ttl}	ttl	:__UBYTE			/* time to live */
	{ip_p}		p	:__UBYTE			/* protocol */
	{ip_sum}	sum	:__UWORD			/* checksum */
	{ip_src}	src	:in_addr
	{ip_dst}	dst	:in_addr	/* source and dest address */
ENDOBJECT
NATIVE {IP_DF} CONST IP_DF = $4000			/* dont fragment flag */
NATIVE {IP_MF} CONST IP_MF = $2000			/* more fragments flag */
NATIVE {IP_OFFMASK} CONST IP_OFFMASK = $1fff		/* mask for fragmenting bits */

NATIVE {IP_MAXPACKET}	CONST IP_MAXPACKET	= 65535		/* maximum packet size */

/*
 * Definitions for IP type of service (ip_tos)
 */
NATIVE {IPTOS_LOWDELAY}		CONST IPTOS_LOWDELAY		= $10
NATIVE {IPTOS_THROUGHPUT}	CONST IPTOS_THROUGHPUT	= $08
NATIVE {IPTOS_RELIABILITY}	CONST IPTOS_RELIABILITY	= $04

/*
 * Definitions for IP precedence (also in ip_tos) (hopefully unused)
 */
NATIVE {IPTOS_PREC_NETCONTROL}		CONST IPTOS_PREC_NETCONTROL		= $e0
NATIVE {IPTOS_PREC_INTERNETCONTROL}	CONST IPTOS_PREC_INTERNETCONTROL	= $c0
NATIVE {IPTOS_PREC_CRITIC_ECP}		CONST IPTOS_PREC_CRITIC_ECP		= $a0
NATIVE {IPTOS_PREC_FLASHOVERRIDE}	CONST IPTOS_PREC_FLASHOVERRIDE	= $80
NATIVE {IPTOS_PREC_FLASH}		CONST IPTOS_PREC_FLASH		= $60
NATIVE {IPTOS_PREC_IMMEDIATE}		CONST IPTOS_PREC_IMMEDIATE		= $40
NATIVE {IPTOS_PREC_PRIORITY}		CONST IPTOS_PREC_PRIORITY		= $20
NATIVE {IPTOS_PREC_ROUTINE}		CONST IPTOS_PREC_ROUTINE		= $00

/*
 * Definitions for options.
 */
NATIVE {IPOPT_COPIED} CONST	->IPOPT_COPIED(o)		((o)&0x80)
NATIVE {IPOPT_CLASS} CONST	->IPOPT_CLASS(o)		((o)&0x60)
NATIVE {IPOPT_NUMBER} CONST	->IPOPT_NUMBER(o)		((o)&0x1f)
->#define IPOPT_COPIED(o) ((o) AND $80)
->#define IPOPT_CLASS(o) ((o) AND $60)
->#define IPOPT_NUMBER(o) ((o) AND $1F)
PROC ipopt_copied(o) IS NATIVE {IPOPT_COPIED(} o {)} ENDNATIVE !!BYTE
PROC ipopt_class(o)  IS NATIVE {IPOPT_CLASS(}  o {)} ENDNATIVE !!BYTE
PROC ipopt_number(o) IS NATIVE {IPOPT_NUMBER(} o {)} ENDNATIVE !!BYTE
#define IPOPT_COPIED(o) ipopt_copied(o)
#define IPOPT_CLASS(o)  ipopt_class(o)
#define IPOPT_NUMBER(o) ipopt_number(o)

NATIVE {IPOPT_CONTROL}		CONST IPOPT_CONTROL		= $00
NATIVE {IPOPT_RESERVED1}		CONST IPOPT_RESERVED1		= $20
NATIVE {IPOPT_DEBMEAS}		CONST IPOPT_DEBMEAS		= $40
NATIVE {IPOPT_RESERVED2}		CONST IPOPT_RESERVED2		= $60

NATIVE {IPOPT_EOL}		CONST IPOPT_EOL		= 0		/* end of option list */
NATIVE {IPOPT_NOP}		CONST IPOPT_NOP		= 1		/* no operation */

NATIVE {IPOPT_RR}		CONST IPOPT_RR		= 7		/* record packet route */
NATIVE {IPOPT_TS}		CONST IPOPT_TS		= 68		/* timestamp */
NATIVE {IPOPT_SECURITY}		CONST IPOPT_SECURITY		= 130		/* provide s,c,h,tcc */
NATIVE {IPOPT_LSRR}		CONST IPOPT_LSRR		= 131		/* loose source route */
NATIVE {IPOPT_SATID}		CONST IPOPT_SATID		= 136		/* satnet id */
NATIVE {IPOPT_SSRR}		CONST IPOPT_SSRR		= 137		/* strict source route */

/*
 * Offsets to fields in options other than EOL and NOP.
 */
NATIVE {IPOPT_OPTVAL}		CONST IPOPT_OPTVAL		= 0		/* option ID */
NATIVE {IPOPT_OLEN}		CONST IPOPT_OLEN		= 1		/* option length */
NATIVE {IPOPT_OFFSET}		CONST IPOPT_OFFSET		= 2		/* offset within option */
NATIVE {IPOPT_MINOFF}		CONST IPOPT_MINOFF		= 4		/* min value of above */

/*
 * Time stamp option structure.
 */
NATIVE {ip_timestamp} OBJECT ip_timestamp
	{ipt_code}	code	:__UBYTE		/* IPOPT_TS */
	{ipt_len}	len	:__UBYTE		/* size of structure (variable) */
	{ipt_ptr}	ptr	:__UBYTE		/* index of current entry */
	{ipt_oflw}	oflw	:RANGE 0 TO 15		/* overflow counter */
	{ipt_flg}	flg	:RANGE 0 TO 15		/* flags, see below */
	{ipt_timestamp.ipt_time}	time	:ARRAY OF __ULONG
	{ipt_timestamp.ipt_ta}		ta[1]	:ARRAY OF ipt_ta	->this hacky way of accessing the C member provides backwards-compatibility with AmigaE
	{ipt_timestamp.ipt_ta[0].ipt_addr}	ta_addr	:in_addr	->where-as this is the 'proper' way to do it
	{ipt_timestamp.ipt_ta[0].ipt_time}	ta_time	:__ULONG	->ditto
ENDOBJECT

/* flag bits for ipt_flg */
NATIVE {IPOPT_TS_TSONLY}		CONST IPOPT_TS_TSONLY		= 0		/* timestamps only */
NATIVE {IPOPT_TS_TSANDADDR}	CONST IPOPT_TS_TSANDADDR	= 1		/* timestamps and addresses */
NATIVE {IPOPT_TS_PRESPEC}	CONST IPOPT_TS_PRESPEC	= 3		/* specified modules only */

/* bits for security (not byte swapped) */
NATIVE {IPOPT_SECUR_UNCLASS}	CONST IPOPT_SECUR_UNCLASS	= $0000
NATIVE {IPOPT_SECUR_CONFID}	CONST IPOPT_SECUR_CONFID	= $f135
NATIVE {IPOPT_SECUR_EFTO}	CONST IPOPT_SECUR_EFTO	= $789a
NATIVE {IPOPT_SECUR_MMMM}	CONST IPOPT_SECUR_MMMM	= $bc4d
NATIVE {IPOPT_SECUR_RESTR}	CONST IPOPT_SECUR_RESTR	= $af13
NATIVE {IPOPT_SECUR_SECRET}	CONST IPOPT_SECUR_SECRET	= $d788
NATIVE {IPOPT_SECUR_TOPSECRET}	CONST IPOPT_SECUR_TOPSECRET	= $6bc5

/*
 * Internet implementation parameters.
 */
NATIVE {MAXTTL}		CONST MAXTTL		= 255		/* maximum time to live (seconds) */
NATIVE {IPDEFTTL}	CONST IPDEFTTL	= 64		/* default ttl, from RFC 1340 */
NATIVE {IPFRAGTTL}	CONST IPFRAGTTL	= 60		/* time to live for frags, slowhz */
NATIVE {IPTTLDEC}	CONST IPTTLDEC	= 1		/* subtracted when forwarding */

NATIVE {IP_MSS}		CONST IP_MSS		= 576		/* default maximum segment size */
