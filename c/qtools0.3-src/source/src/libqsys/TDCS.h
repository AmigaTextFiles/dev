/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#define	NOERROR			1
#define	ERROR			0
#define	ERROR_NOTCRUNCHED	XPKERR_WRONGFORM
#define	ERROR_LESSMEM		XPKERR_NOMEM
#define	ERROR_OVERFLOW		XPKERR_EXPANSION

#ifndef	BITSPERBYTE
#define	BITSPERBYTE	8
#endif
#ifndef	BITSPERINT
#define	BITSPERINT	32
#endif

#define	INDEX_BITS	2
#define	INDEX_MASK	((1 << INDEX_BITS) - 1)
#define	INDEX_LENGTH	(BITSPERINT / INDEX_BITS)

#define	HISTORY_BITS	16
#define	HISTORY_MASK	((1 << HISTORY_BITS) - 1)
#define	HISTORY_LENGTH	HISTORY_MASK

#define	MATCHLEN_BITS	8
#define	MATCHLEN_MASK	((1 << MATCHLEN_BITS) - 1)
#define	MATCHLEN_LENGTH	MATCHLEN_MASK

#define	LITERAL_BITS	8
#define	LITERAL_MASK	((1 << LITERAL_BITS) - 1)
#define	LITERAL_LENGTH	LITERAL_MASK

#define	MIN_MATCH	((HISTORY_BITS + MATCHLEN_BITS) / BITSPERBYTE)
#define	MAX_MATCH	(MATCHLEN_LENGTH + MIN_MATCH)

#define	MAX_REVIEW	3					/* sizes grow if more than 3 */

#define	LOOKUP_BITS	16
#define	LOOKUP_SIZE	(1 << LOOKUP_BITS)
#define	LOOKUP_MASK	(LOOKUP_SIZE - 1)
#define	LOOKUP_LENGTH	LOOKUP_MASK
#if 0
#define	LOOKUP_PREFUNCTION(address) \
			((*((unsigned char *)     ((address) + 0)) << 8) ^ \
			 (*((unsigned short int *)((address) + 0 + sizeof(unsigned char)))))
#define	LOOKUP_POSTFUNCTION(address, index) \
			((*((unsigned char *)     ((address) + index)) << 8) ^ \
			 (*((unsigned short int *)((address) + index + sizeof(unsigned char)))))
#else
#define	LOOKUP_PREFUNCTION(address) \
			((*((unsigned short int *)((address) + 0))) ^ \
			 (*((unsigned char *)     ((address) + 0 + sizeof(unsigned short int)))))
#define	LOOKUP_POSTFUNCTION(address, index) \
			((*((unsigned short int *)((address) + index))) ^ \
			 (*((unsigned char *)     ((address) + index + sizeof(unsigned short int)))))
#endif

#define	NODES_CLUSTER	64
#define	NODES_MIN	2
#define	NODES_BACKWALL	1
#define	NODES_SIZE(num)	(((num + NODES_BACKWALL) * sizeof(unsigned char *)) + sizeof(struct hashnode))

//#define	RESIZED_HISTORY					/* does not work, I don't know who to convert my asm to c */

struct hashnode {
  int count;							/* number of valid hashentries */
  unsigned char *entries[0];					/* the entries */
};

struct hashroot {
  int maxcount;							/* maximum number of hashentries */
  struct hashnode *node;					/* the node */
};

int annihilate(register int inSize __asm__ ("d0"),
	       register unsigned char *inMem __asm__ ("a0"),
	       register int outSize __asm__ ("d1"),
	       register unsigned char *outMem __asm__ ("a1"),
	       int Mode);
int reanimate(register int inSize __asm__ ("d1"),
	      register unsigned char *inMem __asm__ ("a0"),
	      register int outSize __asm__ ("d0"),
	      register unsigned char *outMem __asm__ ("a1"));
