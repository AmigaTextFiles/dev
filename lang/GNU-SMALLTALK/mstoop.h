/***********************************************************************
 *
 *	Object Table declarations.
 *
 ***********************************************************************/

/***********************************************************************
 *
 * Copyright (C) 1990, 1991, 1992 Free Software Foundation, Inc.
 * Written by Steve Byrne.
 *
 * This file is part of GNU Smalltalk.
 *
 * GNU Smalltalk is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 1, or (at your option) any later 
 * version.
 * 
 * GNU Smalltalk is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 * 
 * You should have received a copy of the GNU General Public License along with
 * GNU Smalltalk; see the file COPYING.  If not, write to the Free Software
 * Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  
 *
 ***********************************************************************/


/*
 *    Change Log
 * ============================================================================
 * Author      Date       Change 
 * sbb	     27 Jan 91	  Force INLINE_MACROS on when optimizing.
 *
 * sbyrne     8 Apr 90	  Changed oopFree to oopValid to better reflect the
 *			  semantics.
 *
 * sbyrne    13 Jan 89	  Created.
 *
 */


#ifndef __MSTOOP__
#define __MSTOOP__

/* Comment this out for debugging */
#define INLINE_MACROS

#if defined(OPTIMIZE) && !defined(INLINE_MACROS)
/* Force this on when we're optimizing */
#define INLINE_MACROS
#endif

/* The number of OOPs in the system.  This is exclusive of Character, True,
   False, and UndefinedObject (nil) oops, which are built-ins. */
#define OOP_TABLE_SIZE		(10240 * 16) /* for the nonce, then back to 4 */

#define NUM_CHAR_OBJECTS	256
#define CHAR_OBJECT_BASE	OOP_TABLE_SIZE
#define NUM_BUILTIN_OBJECTS	3
#define BUILTIN_OBJECT_BASE	(CHAR_OBJECT_BASE + NUM_CHAR_OBJECTS)

#define nilOOPIndex		(BUILTIN_OBJECT_BASE + 0)
#define trueOOPIndex		(BUILTIN_OBJECT_BASE + 1)
#define falseOOPIndex		(BUILTIN_OBJECT_BASE + 2)

#define TOTAL_OOP_TABLE_SLOTS \
  ( OOP_TABLE_SIZE + NUM_CHAR_OBJECTS + NUM_BUILTIN_OBJECTS )

/*
 * Given a number of bytes "x", return the number of 32 bit words
 * needed to represent that object, rounded up to the nearest 32 bit
 * word boundary.
 */
#define ROUNDED_WORDS(x) \
  (((x) + sizeof(long) - 1) / sizeof(long))

#define GCIsOn() \
  (gcState)

#define inToSpace(oop) \
  ((((oop)->flags & F_SPACE) == toSpace) || isFake(oop))

/* ### Could use "!= toSpace" instead? (not now, I think) */
#define inFromSpace(oop) \
  (((oop)->flags & F_SPACE) == fromSpace)

#ifdef old_code /* Sat Oct 13 15:40:02 1990 */
/**/#define inToSpace(oop) \
/**/  ((oop)->inSpace == toSpace)
/**/
/**/#define inFromSpace(oop) \
/**/  ((oop)->inSpace == fromSpace)
#endif /* old_code Sat Oct 13 15:40:02 1990 */

#define prepareToStoreMac(destOOP, srcOOP) 

#define maybeMoveOOPMac(oop) 

#define localMaybeMoveOOP(oop) \
{ \
  if (!isInt(oop) && inFromSpace(oop)) { \
    moveOOP(oop); \
  } \
}


#ifdef OPTIMIZE
#define clearGCFlipFlagsMac() 
#else 
#define clearGCFlipFlagsMac() \
  gcFlipCounter = 0
#endif /* OPTIMIZE */

#define oopAtMac(index) \
  ( &oopTable[index] )

#define oopAvailableMac(index) \
  ( oopTable[index].flags & F_FREE )

#define oopIndexMac(oop) \
  ( (OOP)(oop) - oopTable )

#ifdef INLINE_MACROS

#define maybeMoveOOP	maybeMoveOOPMac
#define clearGCFlipFlags clearGCFlipFlagsMac
#define oopAt		oopAtMac
#define oopAvailable	oopAvailableMac
#define oopIndex	oopIndexMac
#define prepareToStore	prepareToStoreMac

#else

extern void		maybeMoveOOP(), clearGCFlipFlags(), prepareToStore();
extern OOP		oopAt();
extern Boolean		oopAvailable();
extern long		oopIndex();

#endif /* INLINE_MACROS */

typedef struct CharObjectStruct {
  OBJ_HEADER;
#ifdef BIG_ENDIAN
  Byte		charVal;
  Byte		dummy[3];	/* filler */
#else
  Byte		dummy[3];	/* filler */
  Byte		charVal;	/* probably not necessary to care about
				   ordering here */
#endif
} CharObject;

struct NilObjectStruct {
  OBJ_HEADER;
};

struct BooleanObjectStruct {
  OBJ_HEADER;
  OOP		booleanValue;
};

extern CharObject		charObjectTable[];
extern struct NilObjectStruct 	nilObject;
extern struct BooleanObjectStruct booleanObjects[];
#ifdef pre_sc_gc /* Sat Jul 27 22:31:18 1991 */
/**/extern OOP			freeOOPs;
#endif /* pre_sc_gc Sat Jul 27 22:31:18 1991 */
extern int			numFreeOOPs;
extern unsigned long		toSpace, fromSpace, maxSpaceSize;
extern Boolean			gcFlipped, gcState, gcMessage;
extern int			gcFlipCounter;

extern double			growThresholdPercent, spaceGrowRate;

extern OOP			allocOOP(), charOOPAt(), findAnInstance();
extern void			initOOP(), setOOPAt(), swapObjects(), 
				fixupMetaclassObjects(), moveOOP(), gcOn(),
				setGCState(), gcFlip(), 
				setSpaceInfo(), growBothSpaces(),
  				allocOOPTable();
extern Byte			charOOPValue();
extern Object			allocObj(), curSpaceAddr();
extern Boolean			oopIndexValid(), oopValid(), gcOff();

extern struct OOPStruct		*oopTable;

#endif /* __MSTOOP__ */
