/***********************************************************************
 *
 *	generic inclusions.
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
 * sbb	     14 Sep 91	  Added edit version support.
 *
 * sbyrne    23 Sep 89	  Modifications to support operation on a DECstation 3100.
 *
 * sbyrne    13 Sep 89	  Sigh!!! modified pushOOP and setStackTop to move the
 *			  objects that they refer to to toSpace...good bye
 *			  performance!
 *
 * sbyrne    29 Dec 88	  Created.
 *
 */

#ifndef __MST__
#define __MST__

#include "mstconfig.h"

/* The system version flags */
#define sysVersMajor		1 
#define sysVersMinor		2 
#define sysVersEdit		0

/* Enable this definition to count different types of byte code executions */
/* #define countingByteCodes */


#define baseInt			(((unsigned long)3)<<30)
#define highBitMask		(((unsigned long)1)<<31) /* just hi bit */

#ifndef USE_BCOPY
#include <memory.h>
#define bcopy(s2, s1, n)  memcpy(s1, s2, n)
#define bzero(s,l) memset(s,'\0',l)
#endif /* USE_BCOPY */

/*#if !defined(__STDC__) && (defined(AIX) | defined(mips) | defined(ibm032) || (defined(sun) && !defined(SUNOS40))) */
#if !defined(__STDC__) && defined(OLDCC)
/* for older compilers that don't understand void * and enums are ints */
#define nil			0
typedef char *voidPtr;
#define ENUM_INT(x)   		((int)(x))
typedef int Boolean;
#define false			0
#define true			1

#else 
typedef void *voidPtr;
/* old code #define nil			(voidPtr)0 */
#define nil			0
/*old code#define ENUM_INT(x)		(x)*/
#define ENUM_INT(x)		((int)(x))

typedef enum booleanType {
  false,
  true
} Boolean;

#endif


/* Would someone (this means you!) please test this out on this machine and 
 * see if this can be merged with the code above a little more cleanly?
 */
#if defined(hp9000s300)
#undef ENUM_INT
#define ENUM_INT(x)			((int)(x))
#endif

/* The set of checks here should either be expanded, or in the m-*.h files
   there should be a definition that talks about the required alignment
   for doubles, whether they must be on a 4 or 8 byte boundary. */
#if defined(sparc) || defined(hppa)
#define DOUBLE_ALIGNMENT	sizeof(double)
#else
#define DOUBLE_ALIGNMENT	sizeof(long)
#endif



typedef struct StreamStruct	*Stream;

typedef struct OOPStruct	*OOP;
typedef struct ObjectStruct	*Object;

struct OOPStruct {
  Object	object;
#ifndef NO_FIELDS
  unsigned long flags;
};

#define F_FREE		((unsigned long) 0x80000000)
#define F_SPACE		((unsigned long) 0x40000000)
#define F_EVEN		((unsigned long) 0x20000000)
#define F_ODD		((unsigned long) 0x10000000)
#define F_FAKE		((unsigned long) 0x08000000)
#define EMPTY_BYTES	((unsigned long) 0x00000003)

/* This macro should only be used right after an allocOOP, when the
 * emptyBytes field is guaranteed to be zero
 */
#define initEmptyBytes(oop, value) \
    ((oop)->flags |= (4 - (value)) & 3)

/* Use this one to assign a particular value */
#define setEmptyBytes(oop, value) \
  ( (oop)->flags = ((oop)->flags & ~EMPTY_BYTES) | ((4 - len) & 3) )


#else
  union {
    struct {
#ifdef BIG_ENDIAN
      unsigned	i_isFree : 1;	/* pack these tighter as needed to make long */
      unsigned  i_evenMark : 1;	/* for OOP table garbage collector */
      unsigned  i_oddMark : 1;	/* for OOP table garbage collector */
      char	i_emptyBytes;   /* 3 number of unused bytes at end; subtract
				   from computed byte length to get the real
				   length of data */
      char	i_inSpace;	/* 0 => space 0, 1 => space 1 */
#else
      char	i_emptyBytes;   /* number of unused bytes at end; subtract
				   from computed byte length to get the real
				   length of data */
      char	i_inSpace;	/* 0 => space 0, 1 => space 1 */
      unsigned	: 13;
      unsigned  i_oddMark : 1;	/* for OOP table garbage collector */
      unsigned  i_evenMark : 1;	/* for OOP table garbage collector */
      unsigned	i_isFree : 1;	/* pack these tighter as needed to make long */
#endif
    } w2_i;
/*    long	w2_prevFree; */
  } w2;
};

#define isFree		w2.w2_i.i_isFree
#define emptyBytes	w2.w2_i.i_emptyBytes
#define inSpace		w2.w2_i.i_inSpace
#define evenMark	w2.w2_i.i_evenMark
#define oddMark		w2.w2_i.i_oddMark
/* #define prevFree	w2.w2_prevFree */
#endif

/* ### REmoved 31-Dec-91 14:07:11 redundant
   extern struct OOPStruct  oopTable[];
 */

/* The header of all objects in the system */
#define OBJ_HEADER \
  long		objSize; /* for now, this is object size in 32bit words*/ \
  OOP		objClass

/* just for symbolic use in sizeof's */
typedef struct ObjectHeaderStruct {
  OBJ_HEADER;
} ObjectHeader;

#define OBJ_HEADER_SIZE_WORDS	(sizeof(ObjectHeader) / sizeof(long))

struct ObjectStruct {
  OBJ_HEADER;
  OOP		data[1];	/* variable length, may not be objects, but
				   will always be at least this big. */
};

extern	OOP		*sp;
extern	char		*nilName;
extern	OOP		nilOOP, trueOOP, falseOOP, thisClass;
extern	Boolean		regressionTesting;


typedef unsigned char Byte;

#define TreeNode		void * /* dummy decl */


/*
 * Macros for common things...can be functions for debugging or can be 
 * macros for speed.
 */

#ifndef NO_INLINE_MACROS

#ifdef old_code /* Sun Nov 24 16:44:35 1991 */
/**/#define uncheckedPushOOP(oop) \
/**/  *++sp = (oop)
/**/
/**/#define uncheckedSetTop(oop) \
/**/  *sp = (oop)
#endif /* old_code Sun Nov 24 16:44:35 1991 */

#define uncheckedPushOOP(oop) \
{ \
  *++sp = (oop); \
  }

#define uncheckedSetTop(oop) \
{ \
  *sp = (oop); \
  }

#define pushOOP(oop) \
  uncheckedPushOOP(oop)

#ifdef old_code /* Fri Oct 18 20:44:42 1991 */
/**//* YUCK!!!! I HATE TO DO THIS!!!! DAMN GARBAGE COLLECTOR!!!! */
/**/#define pushOOP(oop) \
/**/{ \
/**/  OOP __tempOOP = (oop); \
/**/  maybeMoveOOP(__tempOOP); \
/**/  uncheckedPushOOP(__tempOOP); \
/**/} 
#endif /* old_code Fri Oct 18 20:44:42 1991 */

#define popOOP() \
  (*sp--)

#define popNOOPs(n) \
  sp -= (n)

#define unPop(n) \
  sp += (n)

#define stackTop() \
  (*sp)

#ifdef old_code /* Fri Oct 18 20:43:36 1991 */
/**//* UGH!!! DAMN GC!!!  I wish we could run without it! */
/**/#define setStackTop(oop) \
/**/{ \
/**/  OOP __tempOOP = (OOP)(oop); \
/**/  maybeMoveOOP(__tempOOP); \
/**/  *sp = __tempOOP; \
/**/}
#endif /* old_code Fri Oct 18 20:43:36 1991 */

#define setStackTop(oop) \
  uncheckedSetTop(oop)

#define setStackTopInt(i) \
  uncheckedSetTop(fromInt(i))

#define setStackTopBoolean(exp) \
  uncheckedSetTop((exp) ? trueOOP : falseOOP)

#define stackAt(i) \
  (sp[-(i)])

#define pushInt(i) \
  uncheckedPushOOP(fromInt(i))

#define popInt() \
  toInt(popOOP())

#define pushBoolean(exp) \
  uncheckedPushOOP((exp) ? trueOOP : falseOOP)

#define oopToObj(oop) \
  (oop->object)

#define oopClass(oop) \
  (oopToObj(oop)->objClass)

#define isClass(oop, class) \
  (isOOP(oop) && oopClass(oop) == class)

/* integer conversions */

#define toInt(oop) \
  ( (long) ((unsigned long)(oop) - baseInt) )

#define fromInt(i) \
  (OOP)(((unsigned long)(i) + baseInt) | highBitMask)

/*
 * for these, we could probably get away with just hacking the number and
 * setting the high bit.
 */
#define incrInt(i) \
  fromInt(toInt(i) + 1)

#define decrInt(i) \
  fromInt(toInt(i) - 1)



#define isInt(oop) \
  ((long)(oop) < 0)

#define isOOP(oop) \
  ((long)(oop) >= 0)

/* general functions */

#define isNil(oop) \
  ((OOP)(oop) == nilOOP)

#define isFake(oop) \
  ((oop)->flags & F_FAKE)

/* return the number of availble longwords in object, excluding the header */
#define numOOPs(obj) \
  ( 1 + (obj)->objSize - (sizeof(struct ObjectStruct) / sizeof(Object)) )
#endif /* NO_INLINE_MACROS */

#endif /* __MST__ */
