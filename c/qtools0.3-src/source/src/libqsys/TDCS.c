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

#include <stdlib.h>
#include <stdio.h>
#include "TDCS.h"

/*
 * =================================================================
 * statistical encoder
 * =================================================================
 */
void cremate(void) {
}

/*
 * =================================================================
 * lz77 preprocessor
 * =================================================================
 */

void ArrayClear(register struct hashroot *Array __asm__("a0")) {
  bzero(Array, LOOKUP_SIZE * sizeof(struct hashroot));
}

int annihilate(register int inSize __asm__ ("d0"),
	       register unsigned char *inMem __asm__ ("a0"),
	       register int outSize __asm__ ("d1"),
	       register unsigned char *outMem __asm__ ("a1"),
	       int Mode) {
  register unsigned char *pasteMem;
#define	parseMem	inMem
  register struct hashroot *Array;
  struct ExecBase *SysBase;
  int indexPos;
  unsigned int index;
  unsigned int *indexMem;
  void *memPool;

  if(!(Array = malloc(LOOKUP_SIZE * sizeof(struct hashroot))))
    return ERROR_LESSMEM;

  ArrayClear(Array);

  pasteMem = outMem;
  outSize = inSize;						/* do not grow size */
  outMem += outSize;						/* last valid output */

  indexMem = ((unsigned int *)pasteMem)++;			/* store the inde before each block */
  index = 0;
  indexPos = INDEX_LENGTH - 1;

  while (inSize > 0) {
    unsigned short int oldMatch = MIN_MATCH - 1;
    int oldOffset;

    /*
     * =================================================================
     * Hashes
     * =================================================================
     */
#define StoreHash() ({										\
      register struct hashroot *root;								\
      register int maxcnt;									\
												\
      root = &Array[LOOKUP_PREFUNCTION(parseMem)];						\
      if((maxcnt = root->maxcount)) {				/* begin with 500k + 500k */	\
        register int count, add;								\
        register struct hashnode *node;								\
												\
        add = 0;										\
        node = root->node;									\
        count = node->count;									\
        node->entries[count++] = parseMem;			/* register actual match */	\
												\
        if(count > MAX_MATCH) {									\
          if((node->entries[count - 1] - node->entries[count - 1 - MAX_MATCH - 1]) == (MAX_MATCH + 1)) {	\
            count--;										\
            bcopy(&node->entries[count - MAX_MATCH], &node->entries[count - MAX_MATCH - 1], MAX_MATCH * sizeof(unsigned char *));	\
          }											\
        }											\
												\
        if(count >= maxcnt) {					/* expand it */			\
          if(maxcnt < NODES_CLUSTER)								\
            add = maxcnt;					/* double size */		\
          else											\
            add = NODES_CLUSTER;								\
        }											\
        else if((count > 1) && (count <= (maxcnt >> 1))) {	/* reduce it */			\
          if(maxcnt > NODES_CLUSTER)								\
            add = -(NODES_CLUSTER);								\
          else if((maxcnt >>= 1) < NODES_MIN)			/* half size */			\
            add = -(maxcnt - NODES_MIN);							\
        }											\
												\
        if(add) {										\
          maxcnt += add;									\
          if(!(node = malloc(NODES_SIZE(maxcnt))))						\								\
	    return ERROR_LESSMEM;								\
	  bcopy(root->node, node, NODES_SIZE(count - NODES_BACKWALL));				\
          free(root->node, NODES_SIZE(root->maxcount));						\
												\
          root->node = node;									\
          root->maxcount = maxcnt;								\
        }											\
        node->count = count;									\
      }												\
      else {											\
        register struct hashnode *node;								\
        											\
        if(!(node = root->node = malloc(NODES_SIZE(NODES_MIN))))				\
	  return ERROR_LESSMEM;									\
        root->maxcount = NODES_MIN;								\
        node->count = 1;									\
        node->entries[0] = parseMem;				/* register actual match */	\
      }												\
    })

    /*
     * =================================================================
     * Matches
     * =================================================================
     */
#define	FindMatch() ({										\
      while (--tries >= 0) {									\
        register unsigned char *beginHist = *--tryhistory;		/* characters after first character */	\
												\
	if (*((unsigned short int *)(beginHist + oldMatch - 1)) ==				\
	    *((unsigned short int *)(parseMem  + oldMatch - 1))) {	/* compare with last character */	\
	  if (*((unsigned short int *)(beginHist + 1)) ==		/* already verified from hash */	\
	      *((unsigned short int *)(parseMem + 1))) {					\
	    /* do not invalidate flowing beginHist and constant beginPars */			\
	    register unsigned char *newHist = beginHist + MIN_MATCH;				\
	    register unsigned char *newPars = parseMem  + MIN_MATCH;				\
	    register int newMatch = MIN_MATCH + 3;		/* first byte allready parsed */	\
								/* hopefully execute from left to right */	\
	    while (newMatch < (MAX_MATCH + 3)) {		/* do not overflow */		\
	      if (*((unsigned int *)newHist)++ !=						\
		  *((unsigned int *)newPars)++) {		/* compare with characters after first character */	\
	        break;										\
	      }											\
	      newMatch += 4;									\
	    }											\
	    if(newMatch > oldMatch) {								\
	      newHist -= 4;									\
	      newPars -= 4;									\
	      if (*((unsigned short int *)newHist)++ !=						\
	          *((unsigned short int *)newPars)++) {		/* compare with characters after first character */	\
	        newMatch -= 2;									\
	        newHist -= 2;									\
	        newPars -= 2;									\
	      }											\
	      if (*((unsigned char *)(newHist)) !=						\
		  *((unsigned char *)(newPars))) {		/* compare with characters after first character */	\
	        newMatch -= 1;									\
	      }											\
												\
	      if (newMatch > oldMatch) {			/* accept if longer than last match */	\
	        oldOffset = newHist - newPars;			/* calculate negative offset */	\
	        if ((oldMatch = newMatch) >= MAX_MATCH) {	/* correct length if longer than maximal match */	\
		  oldMatch = MAX_MATCH;								\
		  break;					/* do not continue if maximum matchlength reached */	\
	        }										\
	      }											\
	    }											\
	  }											\
	}											\
      }												\
    })

#define GetHash() ({										\
        register struct hashnode *node;								\
        register int remove;									\
												\
        if(!(node = Array[remove = LOOKUP_PREFUNCTION(parseMem)].node)) {			\
          if(!(node = Array[remove].node = malloc(NODES_SIZE(NODES_MIN))))			\
	    return ERROR_LESSMEM;								\
          Array[remove].maxcount = NODES_MIN;							\
          node->count = 0;									\
        }											\
        else {											\
          register int tries;									\
          register unsigned char **tryhistory;							\
												\
          tries = node->count;									\
												\
          for(remove = 0; tries > remove; remove++) {		/* while the history-entries are too big, remove them, thats okay, they are distance-sorted */	\
            if((parseMem - node->entries[remove]) <= (HISTORY_LENGTH))				\
              break;										\
          }											\
												\
          if(remove) {						/* streight move the entries from right to left to prevent sorting order */	\
            tries -= remove;									\
	    bcopy(&node->entries[remove], &node->entries[0], tries * sizeof(unsigned char *));	\
            node->count = tries;								\
          }											\
          tryhistory = &node->entries[tries];							\
          FindMatch();										\
        }											\
      })

#define GetMatch() ({										\
      GetHash();										\
    })

#define	UpdateIndex() ({									\
      if (--indexPos < 0) {					/* flush index if full */	\
	*indexMem = index;									\
	indexMem = ((unsigned int *)pasteMem)++;						\
	index = 0;										\
	indexPos = INDEX_LENGTH - 1;								\
      }												\
												\
      if (pasteMem > outMem)					/* brute break if destination overflow, TODO: clean break, not abort() */	\
	return ERROR_OVERFLOW;									\
    })

#define StoreLiteral() ({									\
      StoreHash();										\
												\
      /* store 8bit literal */									\
      *pasteMem++ = *parseMem++;				/* store plain literal */	\
      inSize -= sizeof(unsigned char);			/* reduce number of left bytes */	\
												\
      UpdateIndex();										\
    })

#define StoreMatch() ({										\
      register int setMatch;									\
    												\
      if (oldMatch > (unsigned short int)inSize)		/* protect against underflow */	\
	oldMatch = (unsigned short int)inSize;							\
      if ((setMatch = oldMatch - MIN_MATCH) >= 0) {						\
	register int orIndex;									\
												\
	if ((setMatch <= 0x3) && (oldOffset >= 0xFFFFC000)) {					\
	  *((unsigned short int *)pasteMem)++ = (unsigned short int)((((unsigned short int)oldOffset) << 2) | (setMatch));	\
	  orIndex = 0x1;									\
	}											\
	else if ((setMatch <= 0xF) && (oldOffset >= 0xFFFFF000)) {				\
	  *((unsigned short int *)pasteMem)++ = (unsigned short int)((((unsigned short int)oldOffset) << 4) | (setMatch));	\
	  orIndex = 0x2;									\
	}											\
	else {											\
	  /* store 16bit history */								\
	  *((unsigned short int *)pasteMem)++ = (unsigned short int)(oldOffset);		\
	  /* store 8bit length */								\
	  *pasteMem++ = (unsigned char)(setMatch);						\
	  orIndex = 0x3;									\
	}											\
												\
	index |= (orIndex << (indexPos * INDEX_BITS));						\
      }												\
      else {											\
	/* store 8bit literal */								\
	*pasteMem++ = *parseMem;				/* store plain literal */	\
	oldMatch = sizeof(unsigned char);							\
      }												\
												\
      inSize -= oldMatch;					/* reduce number of left bytes */	\
      /* goto position after valid match */							\
      for((short int)oldMatch -= 1; (short int)oldMatch >= 0; (short int)oldMatch--) {	/* runs oldMatch - 1 times */	\
	StoreHash();										\
	parseMem++;										\
      }												\
												\
      UpdateIndex();										\
    })

    /*
     * =================================================================
     * Main-Parsing
     * =================================================================
     */
    GetMatch();							/* set initial match */
    if (oldMatch < MAX_MATCH) {					/* try only something better if there could be something longer */
      register unsigned short int k;
      register unsigned short int revMatch = oldMatch;		/* store old state */
      register int revOffset = oldOffset;

      for (k = 1; k < Mode; k++) {				/* we leave this loop only if none of the next two tries matches better */
	parseMem++;						/* try next possible match */
	GetMatch();

	if ((oldMatch - k) > revMatch) {			/* match is better, store everything before */
	  revMatch = oldMatch;					/* store new state */
	  revOffset = oldOffset;
	  parseMem -= k;					/* jump to beginning of best-match-sliding */
	  oldMatch = MIN_MATCH - 1;				/* store them all as literals */

	  for (; k >= 1; k--)					/* store every previous try */
	    StoreLiteral();

	  if (revMatch >= MAX_MATCH) {				/* brute break if match reaches maximum */
	    k = 1;						/* don't rewind parseMem if we break the loop */
	    break;
	  }
	}
      }

      parseMem -= (k - 1);					/* none of the two tries matches better, so rewind both tries (means three bytes) */
      oldOffset = revOffset;					/* restore old state */
      oldMatch = revMatch;
    }
    StoreMatch();						/* save last match */
  }

  index |= (0x3 << (indexPos * INDEX_BITS));			/* flush index */
  *indexMem = index;						/* and store */
  *((unsigned short int *)pasteMem)++ = 0;

  outSize = pasteMem - (outMem - outSize);			/* get size */

  return outSize;
}
