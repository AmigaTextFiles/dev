OPT NATIVE, PREPROCESS
MODULE 'target/amitcp/sys/netinclude_types'
{#include <net/radix.h>}
/*
 * $Id: radix.h,v 1.6 2007-08-26 12:30:25 obarthel Exp $
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
 * Copyright (c) 1988, 1989, 1993
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
 *	@(#)radix.h	8.2 (Berkeley) 10/31/94
 */

NATIVE {_NET_RADIX_H} DEF

/*
 * Radix search tree node layout.
 */

NATIVE {radix_node} OBJECT radix_node
	{rn_mklist}	mklist	:PTR TO radix_mask	/* list of masks contained in subtree */
	{rn_p}	p	:PTR TO radix_node	/* parent */
	{rn_b}	b	:__WORD			/* bit offset; -1-index(netmask) */
	{rn_bmask}	bmask	:__UBYTE		/* node: mask for bit test*/
	{rn_flags}	flags	:__UBYTE		/* enumerated next */
	/* leaf only data: */
	{rn_u.rn_leaf.rn_Key}	key	:__APTR		/* object of search */
	{rn_u.rn_leaf.rn_Mask}	mask	:__APTR	/* netmask, if present */
	{rn_u.rn_leaf.rn_Dupedkey}	dupedkey	:PTR TO radix_node
	/* node only data: */
	{rn_u.rn_node.rn_Off}	off	:__LONG		/* where to start compare */
	{rn_u.rn_node.rn_L}	l	:PTR TO radix_node/* progeny */
	{rn_u.rn_node.rn_R}	r	:PTR TO radix_node/* progeny */
ENDOBJECT
NATIVE {RNF_NORMAL}	CONST RNF_NORMAL =	1		/* leaf contains normal route */
NATIVE {RNF_ROOT}	CONST RNF_ROOT =	2		/* leaf is root leaf for tree */
NATIVE {RNF_ACTIVE}	CONST RNF_ACTIVE =	4		/* This node is alive (for rtfree) */

NATIVE {rn_dupedkey} DEF
NATIVE {rn_key} DEF
NATIVE {rn_mask} DEF
NATIVE {rn_off} DEF
NATIVE {rn_l} DEF
NATIVE {rn_r} DEF

/*
 * Annotations to tree concerning potential routes applying to subtrees.
 */

NATIVE {radix_mask} OBJECT radix_mask
	{rm_b}	b	:__WORD			/* bit offset; -1-index(netmask) */
	{rm_unused}	unused	:__UBYTE		/* cf. rn_bmask */
	{rm_flags}	flags	:__UBYTE		/* cf. rn_flags */
	{rm_mklist}	mklist	:PTR TO radix_mask	/* more masks to try */
	{rm_rmu.rmu_mask}	mask	:__APTR		/* the mask */
	{rm_rmu.rmu_leaf}	leaf	:PTR TO radix_node	/* for normal routes */
	{rm_refs}	refs	:__LONG		/* # of references to this struct */
ENDOBJECT

NATIVE {rm_mask} DEF
NATIVE {rm_leaf} DEF

NATIVE {radix_node_head} OBJECT radix_node_head
	{rnh_treetop}	treetop	:PTR TO radix_node
	{rnh_addrsize}	addrsize	:__LONG			/* permit, but not require fixed keys */
	{rnh_pktsize}	pktsize	:__LONG			/* permit, but not require fixed keys */
	{rnh_addaddr}	addaddr	:__APTR			/* add based on sockaddr */
	{rnh_addpkt}	addpkt	:__APTR			/* add based on packet hdr */
	{rnh_deladdr}	deladdr	:__APTR			/* remove based on sockaddr */
	{rnh_delpkt}	delpkt	:__APTR			/* remove based on packet hdr */
	{rnh_matchaddr}	matchaddr	:__APTR			/* locate based on sockaddr */
	{rnh_lookup}	lookup	:__APTR			/* locate based on sockaddr */
	{rnh_matchpkt}	matchpkt	:__APTR			/* locate based on packet hdr */
	{rnh_walktree}	walktree	:__APTR			/* traverse tree */
	{rnh_nodes}	nodes[3]	:ARRAY OF radix_node	/* empty tree for common case */
ENDOBJECT
