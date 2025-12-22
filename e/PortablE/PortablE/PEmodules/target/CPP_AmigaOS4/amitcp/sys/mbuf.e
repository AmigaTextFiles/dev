OPT NATIVE, PREPROCESS
MODULE 'target/amitcp/sys/netinclude_types', 'target/amitcp/net/if'
{#include <sys/mbuf.h>}
/*
 * $Id: mbuf.h,v 1.6 2007-08-26 12:30:26 obarthel Exp $
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
 * Copyright (c) 1982, 1986, 1988, 1993
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
 *	@(#)mbuf.h	8.5 (Berkeley) 2/19/95
 */

NATIVE {_SYS_MBUF_H} DEF

/*
 * Constants related to network buffer management.
 * MCLBYTES must be no larger than CLBYTES (the software page size), and,
 * on machines that exchange pages of input or output buffers with mbuf
 * clusters (MAPPED_MBUFS), MCLBYTES must also be an integral multiple
 * of the hardware page size.
 */
NATIVE {MSIZE}		CONST MSIZE	= 128		/* size of an mbuf */
NATIVE {MCLBYTES}	CONST MCLBYTES	= 2048		/* large enough for ether MTU */
NATIVE {MCLSHIFT}	CONST MCLSHIFT	= 11
NATIVE {MCLOFSET}	CONST MCLOFSET	= (MCLBYTES - 1)

/*
 * Mbufs are of a single size, MSIZE (machine/machparam.h), which
 * includes overhead.  An mbuf may add a single "mbuf cluster" of size
 * MCLBYTES (also in machine/machparam.h), which has no additional overhead
 * and is used instead of the internal data area; this is done when
 * at least MINCLSIZE of data must be stored.
 */

NATIVE {MLEN} CONST
#define MLEN		(MSIZE - SIZEOF m_hdr)	/* normal data len */
NATIVE {MHLEN} CONST
#define MHLEN		(MLEN - SIZEOF pkthdr)	/* data len w/pkthdr */

NATIVE {MINCLSIZE} CONST
#define MINCLSIZE	(MHLEN + 1)	/* smallest amount to put in cluster */
NATIVE {M_MAXCOMPRESS} CONST
#define M_MAXCOMPRESS	(MHLEN / 2)	/* max amount to copy for compression */

/*
 * Macros for type conversion
 * mtod(m,t) -	convert mbuf pointer to data pointer of correct type
 * dtom(x) -	convert data pointer within mbuf to mbuf pointer (XXX)
 */
NATIVE {mtod} PROC
#define	mtod(m,t)	(((m)->data) !!t)

NATIVE {dtom} PROC
->#define	dtom(x)		((((x)!!__ULONG) AND NOT (MSIZE-1)) !!PTR TO mbuf)
PROC dtom(x) IS NATIVE {dtom(} x {)} ENDNATIVE !!PTR TO mbuf

/* header at beginning of each mbuf: */
NATIVE {m_hdr} OBJECT m_hdr
	{mh_next}	next	:PTR TO mbuf		/* next buffer in chain */
	{mh_nextpkt}	nextpkt	:PTR TO mbuf	/* next chain in queue/record */
	{mh_data}	data	:__APTR		/* location of data */
	{mh_len}	len	:__LONG			/* amount of data in this mbuf */
	{mh_type}	type	:__WORD		/* type of data in this mbuf */
	{mh_flags}	flags	:__WORD		/* flags; see below */
ENDOBJECT

/* record/packet header in first mbuf of chain; valid if M_PKTHDR set */
NATIVE {pkthdr} OBJECT pkthdr
	{rcvif}	rcvif	:PTR TO ifnet		/* rcv interface */
	{len}	len	:__LONG			/* total packet length */
ENDOBJECT

/* description of external storage mapped into mbuf, valid if M_EXT set */
NATIVE {m_ext} OBJECT m_ext
	{ext_buf}	buf	:__APTR		/* start of buffer */
	{ext_free}	free	:__APTR		/* free routine if not the usual */
	{ext_size}	size	:__ULONG		/* size of buffer, for ext_free */
ENDOBJECT

NATIVE {mbuf} OBJECT mbuf
	{m_hdr}	hdr	:m_hdr
	{M_dat.MH.MH_pkthdr}	pkthdr	:pkthdr	/* M_PKTHDR set */
	{M_dat.MH.MH_dat.MH_ext}	ext	:m_ext	/* M_EXT set */
	{M_dat.MH.MH_dat.MH_databuf}	pktdat/*[MHLEN]*/	:ARRAY OF __UBYTE
	{M_dat.M_databuf}	dat/*[MLEN]*/	:ARRAY OF __UBYTE		/* !M_PKTHDR, !M_EXT */
ENDOBJECT
NATIVE {m_next}		DEF
NATIVE {m_len}		DEF
NATIVE {m_data}		DEF
NATIVE {m_type}		DEF
NATIVE {m_flags}	DEF
NATIVE {m_nextpkt}	DEF
NATIVE {m_act}		DEF
NATIVE {m_pkthdr}	DEF
->NATIVE {m_ext}		DEF
NATIVE {m_pktdat}	DEF
NATIVE {m_dat}		DEF

/* mbuf flags */
NATIVE {M_EXT}		CONST M_EXT		= $0001	/* has associated external storage */
NATIVE {M_PKTHDR}	CONST M_PKTHDR	= $0002	/* start of record */
NATIVE {M_EOR}		CONST M_EOR		= $0004	/* end of record */

/* mbuf pkthdr flags, also in m_flags */
NATIVE {M_BCAST}		CONST M_BCAST		= $0100	/* send/received as link-level broadcast */
NATIVE {M_MCAST}		CONST M_MCAST		= $0200	/* send/received as link-level multicast */

/* flags copied when copying m_pkthdr */
NATIVE {M_COPYFLAGS}	CONST M_COPYFLAGS	= (M_PKTHDR OR M_EOR OR M_BCAST OR M_MCAST)

/* length to m_copy to copy all */
NATIVE {M_COPYALL}	CONST M_COPYALL	= 1000000000

/*
 * Mbuf statistics.
 */
NATIVE {mbstat} OBJECT mbstat
	{m_mbufs}	mbufs	:__ULONG	/* mbufs obtained from page pool */
	{m_clusters}	clusters	:__ULONG	/* clusters obtained from page pool */
	{m_spare}	spare	:__ULONG	/* spare field */
	{m_clfree}	clfree	:__ULONG	/* free clusters */
	{m_drops}	drops	:__ULONG	/* times failed to find space */
	{m_wait}	wait	:__ULONG		/* times waited for space */
	{m_drain}	drain	:__ULONG	/* times drained protocols for space */
ENDOBJECT
