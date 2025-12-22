/***********************************************************************
 *
 *	Byte Code Interpreter Module.
 *
 *	Interprets the compiled bytecodes of a method.
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
 * sbb	     28 Nov 91	  Added SystemDictionary byteCodeCounter primitive.
 *
 * sbb	      9 Nov 91	  Fixed new: to indicate failure when failure occurs.
 *
 * sbb	      2 Nov 91	  Fixed instVarAt: to obey real stack conventions (was
 *			  pushing instead of setting the stack top).
 *
 * sbb	      2 Nov 91	  Altered the logic in the primitive replace from code
 *			  -- I don't think it was really wrong, but it wasn't
 *			  as clear as it might have been.
 *
 * sbb	     20 Oct 91	  Added support for user level control of memory space
 *			  growth rate parameters.
 *
 * sbb	     15 Sep 91	  Added quitPrimitive: to allow for non-zero exit
 *			  statuses.
 *
 * sbb	      5 Jul 91	  Added support for primitive 105, which is the basic
 *			  fast support for doing replacement within strings.
 *
 * sbb	      5 Jul 91	  Added primitive 248:
 *			     FileStream fileInLine: lineNum
 *			                fileName: aString
 *			                at: charPosInt
 *			  This helps improve things for the emacs interface by
 *			  making recorded information accurate, and making
 *			  error locations also be accurate.
 *
 * sbb	      2 Jul 91	  Fixed handling of jump true and jump false opcodes:
 *			  they now issue an error if invoked with non trueOOP
 *			  or falseOOP.
 *
 * sbb	     19 Apr 91	  Added primitive to support conditional compilation.
 *
 * sbb	     23 Mar 91	  Improved speed another 50% by "inlining" many of the
 *			  special selectors that the compiler uses.
 *
 * sbb	     23 Mar 91	  Fixed a bug with process switching: you can't depend
 *			  on objects gotten with oopToObj after a
 *			  prepareToStore into the parent object: it may have
 *			  moved, and you're storing into dead storage.
 *
 * sbb	     17 Mar 91	  Added support for C-style interrupts (signals) and
 *			  timed interrupts to help with time slicing.
 *
 * sbb	     27 Jan 91	  Modified the definition of the inline-controlling
 *			  macro so that inlining is always selected when
 *			  compiling for debugging. 
 *
 * sbb	      5 Jan 91	  Converted executePrimitiveOperation to do returns as
 *			  soon as possible, to not use the failed variable, and
 *			  to not do double switching on int and float
 *			  operations.  This simple change increased performance
 *			  from ~130K bytecodes/sec (SS1+ optim) to > 200k
 *			  bytecodes/sec (simple code, builtins and primitives
 *			  only, no real method invocation).
 *
 * sbb	      1 Jan 91	  Switched to not creating MethodContexts always...just
 *			  use a cache of pre-made fake method contexts and only
 *			  create real method contexts when someone will get a
 *			  reference to one of the method contexts.
 *
 * sbb	     21 Aug 90	  Added support for subtypes of CObject to provide
 *			  direct access to C data.
 *
 * sbb	      3 Aug 90	  Added support for primitive C object allocation
 *			  routine.
 *
 * sbyrne    20 May 90	  Improved error handling when error: or
 *			  doesNotUnderstand: occurs.  Also, added ^C handling
 *			  to abort execution.
 *
 * sbyrne    24 Apr 90	  Improved error handling for fopen/popen primitives.
 *
 * sbyrne    20 Apr 90	  Make fileIn not close the stream that it's reading
 *			  from; this is taken care of by the caller, and causes
 *			  very strange behavior if we try to close it twice!
 *
 * sbyrne     7 Apr 90	  Added declaration tracing primitive.
 *
 * sbyrne     7 Apr 90	  Fixed fileIn: to check for existence of the file
 *			  before trying to open it.  Returns failure if the
 *			  file cannot be accessed.
 *
 * sbyrne    25 Mar 90	  Minor change for AtariSt: decrease size of ASYNC
 *			  queue size.
 *
 * sbyrne    19 Dec 89	  Added suport for primitive filein (for use with
 *			  autoload --
 *			                  "12 gauge autoloader"
 *			                  A. Swartzenegger
 *			                  The Terminator)
 *
 * sbyrne     2 Sep 89	  Process primitives in and working...starting to
 *			  switch to compiled methods with descriptor instance
 *			  variable in addition to header.
 *
 * sbyrne     9 Aug 89	  Conversion completed.  Performance now 40k
 *			  bytecodes/sec; was 43k bytecodes/sec.
 *
 * sbyrne    18 Jul 89	  Began conversion from stack based method contexts and
 *			  blocks to more traditional method contexts and
 *			  blocks.  This change was done 1) to make call in from
 *			  C easier, 2) to make processs possible (they could
 *			  have been implemented using stack based contexts, but
 *			  somewhat space-wastefully), and 3) to conform with
 *			  the more traditional definition method contexts and
 *			  block contexts.
 *
 * sbyrne    26 May 89	  added method cache!  Why didn't I spend the 1/2 hour
 *			  sooner?
 *
 * sbyrne     7 Jan 89	  Created.
 *
 */


#include "mst.h"
#include "mstinterp.h"
#include "mstdict.h"
#include "mstsym.h"
#include "mstoop.h"
#include "mstsave.h"
#include "mstcomp.h"
#include "mstcint.h"
#include "mstsysdep.h"
#include "mstlex.h"
#include <math.h>
#include <stdio.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <setjmp.h>

#define	METHOD_CACHE_SIZE		(1 << 11) /* 2048, mostly random choice */
#ifdef atarist
#define ASYNC_QUEUE_SIZE		16 /* still way too much */
#else
#define ASYNC_QUEUE_SIZE		100 /* way too much */
#endif

/* Max number of C-style signals on a machine */
#define NUM_SIGNALS	32

/* Don't enable this...it doesn't really work properly with the new GC, since
   using local register variables defeats the ability to copy the root set
   when a GC flip occurs. */
#define LOCAL_REGS /* Enabled experimentally 29-Dec-91 18:00:04 */

/* Enabling this means that some accessors for method object pieces, such
   as instance variables or literals, are implemented as routines, instead
   of being in-line code via macros */
/* #define ACCESSOR_DEBUGGING */

#if defined(OPTIMIZE) && defined(ACCESSOR_DEBUGGING)
/* Turn this off when we're optimizing. */
#undef ACCESSOR_DEBUGGING
#endif

#ifdef LOCAL_REGS
#define exportSP()	*spAddr = sp
#define exportIP()	*ipAddr = ip
#define exportRegs()	{ exportSP(); exportIP(); }
#define importSP()	sp = *spAddr
#define importIP()	ip = *ipAddr
#define importRegs()	{ importSP(); importIP(); }
#else
#define exportSP()
#define exportIP()
#define exportRegs()
#define importSP()
#define importIP()
#define importRegs()
#endif /* LOCAL_REGS */

#ifndef ACCESSOR_DEBUGGING

#ifdef OPTIMIZE
#define receiverVariableInternal(receiver, index) \
  (oopToObj(receiver)->data[index])
#else
#define receiverVariableInternal(receiver, index) \
  (!inBounds(receiver, index) && errorf("Index out of bounds %d", index), \
    oopToObj(receiver)->data[index])
#endif /* OPTIMIZE */


#define getStackReceiverInternal(numArgs) \
  (stackAt(numArgs))

#define methodTemporaryInternal(index) \
  (temporaries[index])


#define methodLiteralInternal(methodOOP, index) \
  (((Method)oopToObj(methodOOP))->literals[index])

#define methodVariableInternal(methodOOP, index) \
  (associationValue(((Method)oopToObj(methodOOP))->literals[index]))

#define getMethodByteCodesInternal(methodOOP) \
  (isNil(methodOOP) ? (Byte *)nil \
   : ((Byte *)&((Method)oopToObj(methodOOP))->literals[((Method)oopToObj(methodOOP))->header.numLiterals]))


#define getMethodHeaderInternal(methodOOP) \
  (((Method)oopToObj(methodOOP))->header)

#define getMethodClassInternal(methodOOP) \
  (associationValue(((Method)oopToObj(methodOOP))->literals[((Method)oopToObj(methodOOP))->header.numLiterals - 1]))


#ifdef OPTIMIZE
#define storeReceiverVariableInternal(receiver, index, oop) \
{  \
  OOP __storeRecVarOOP = (oop); \
  prepareToStore(receiver, __storeRecVarOOP); \
  oopToObj(receiver)->data[index] = __storeRecVarOOP; \
}
#else
#define storeReceiverVariableInternal(receiver, index, oop) \
{  \
  OOP __storeRecVarOOP = (oop); \
  if (!inBounds(receiver, index)) { \
    errorf("Index out of bounds %d", index); \
  } \
  prepareToStore(receiver, __storeRecVarOOP); \
  oopToObj(receiver)->data[index] = __storeRecVarOOP; \
}
#endif /* OPTIMIZE */


#define storeMethodTemporaryInternal(index, oop) \
{ \
  OOP __storeMethTempOOP = (oop); \
  prepareToStore(thisContextOOP, __storeMethTempOOP); \
  temporaries[index] = __storeMethTempOOP; \
}

#define storeMethodVariableInternal(methodOOP, index, oop) \
  setAssociationValue(((Method)oopToObj(methodOOP))->literals[index], oop)

#define storeMethodLiteralInternal(methodOOP, index, oop) \
{ \
  OOP __storeMethLitOOP = (oop); \
  prepareToStore(methodOOP, __storeMethLitOOP); \
  ((Method)oopToObj(methodOOP))->literals[index] = __storeMethLitOOP; \
}

#ifdef OPTIMIZE
#define inBoundsInternal(oop, index) true
#else /* Not optimize */
#define inBoundsInternal(oop, index) \
  ((index) >= 0 && (index) < numOOPs(oopToObj(oop)))
#endif

#define isBlockContextInternal(contextOOP) \
  (oopClass(contextOOP) == blockContextClass)

#define relativeByteIndexInternal(bp, methodOOP) \
  ((bp) - getMethodByteCodes(methodOOP))

#define getMethodContextInternal(contextOOP) \
  ( (isBlockContext(contextOOP)) \
    ? ((BlockContext)oopToObj(contextOOP))->home \
    : (contextOOP) )

#define receiverVariable		receiverVariableInternal
#define getStackReceiver		getStackReceiverInternal
#define methodTemporary			methodTemporaryInternal
#define methodVariable			methodVariableInternal
#define getMethodByteCodes		getMethodByteCodesInternal
#define getMethodClass			getMethodClassInternal
#define storeReceiverVariable		storeReceiverVariableInternal
#define storeMethodTemporary		storeMethodTemporaryInternal
#define storeMethodVariable		storeMethodVariableInternal
#define inBounds			inBoundsInternal
#define isBlockContext			isBlockContextInternal

#define methodLiteral			methodLiteralInternal
#define getMethodHeader			getMethodHeaderInternal
#define storeMethodLiteral		storeMethodLiteralInternal
/*
   #define relativeByteIndex		relativeByteIndexInternal
*/
#define getMethodContext		getMethodContextInternal
#endif /* !ACCESSOR_DEBUGGING */


/* Ordering of file operations must match that used in FileSegment.st */
typedef enum {
  openFilePrim,
  closeFilePrim,
  getCharPrim,
  putCharPrim,
  seekPrim,
  tellPrim,
  eofPrim,
  popenFilePrim,
  sizePrim,
  putCharsPrim,
  getCharsPrim
} filePrimitiveTypes;

typedef struct FileStreamStruct {
  OBJ_HEADER;
  OOP		collection;
  OOP		ptr;
  OOP		endPtr;
  OOP		access;
  OOP		maxSize;
  OOP		file;
  OOP		name;
} *FileStream;

typedef struct CompiledMethodStruct *Method;

typedef struct MethodContextStruct {
  OBJ_HEADER;
  OOP		sender;
  OOP		ipOffset;	/* an integer byte index into method */
  OOP		spOffset;	/* an integer index into cur context stack */
  OOP		method;		/* the method that we're executing */
  OOP		methodClass;	/* the class of the method that's executing */
  OOP		hasBlock;	/* nil or not nil */
  OOP		selector;	/* the selector that invoked this method */
  OOP		receiver;	/* the Receiver OOP */
  OOP		contextStack[CONTEXT_STACK_SIZE];
} *MethodContext;

typedef struct BlockContextStruct {
  OBJ_HEADER;
  OOP		caller;
  OOP		ipOffset;	/* an integer byte index into method */
  OOP		spOffset;	/* an integer index into cur context stack */
  OOP		numArgs;	/* number of arguments we have */
  OOP		methodClass;	/* placeholder; not used */
  OOP		initialIP;	/* initial value of IP (an offset) */
  OOP		selector;	/* the selector that invoked this block */
  OOP		home;		/* the home context */
  OOP		contextStack[CONTEXT_STACK_SIZE];
} *BlockContext;

typedef struct FakeContextOOP {
  struct MethodContextStruct mc;
  struct OOPStruct oop;
} *FakeOOP;

typedef struct SemaphoreStruct {
  OBJ_HEADER;
  OOP		firstLink;
  OOP		lastLink;
  OOP		signals;
} *Semaphore;

typedef struct ProcessStruct {
  OBJ_HEADER;
  OOP		nextLink;
  OOP		suspendedContext;
  OOP		priority;
  OOP		myList;
} *Process;

typedef struct ProcessorSchedulerStruct {
  OBJ_HEADER;
  OOP		processLists;
  OOP		activeProcess;
} *ProcessorScheduler;

long methodCount = 0, totalMethods = 0;


long			byteCodeCounter;
long			cacheHits = 0;
long			cacheMisses = 0;

/* !!! */
Boolean			gcDebug = false;

/* If this is true, for each byte code that is executed, the byte index
 * within the current CompiledMethod and a decoded interpretation of
 * the byte code is printed on standard output. */
Boolean			executionTracing;

/* When this is true, and an interrupt occurs (such as SIGSEGV), Smalltalk
 * will terminate itself by making a core dump (normally it does not
 * terminate in this manner). */
Boolean			makeCoreFile = false;


Byte			*ip, **ipAddr = &ip;
OOP			*sp, **spAddr = &sp;
OOP			thisMethod;

int			collide[METHOD_CACHE_SIZE];

#ifdef countingByteCodes
static long		byteCodes[256];
static long		primitives[256];
#endif

static OOP		methodCacheSelectors    [METHOD_CACHE_SIZE];
static OOP		primitiveCacheSelectors [METHOD_CACHE_SIZE];
static OOP		methodCacheClasses      [METHOD_CACHE_SIZE];
static OOP		primitiveCacheClasses   [METHOD_CACHE_SIZE];
static OOP		methodCacheMethods      [METHOD_CACHE_SIZE];
static int		primitiveCachePrimitives[METHOD_CACHE_SIZE];
static OOP		methodCacheMethodClasses[METHOD_CACHE_SIZE];

static OOP		queuedAsyncSignals	[ASYNC_QUEUE_SIZE]; 
static int		asyncQueueIndex;
static OOP		switchToProcess; /* non-nil when proc switch wanted */

static OOP		*temporaries;	/* points into method or block context
					 * to start of arguments and
					 * temporaries */
static OOP		self;
static OOP		thisContextOOP;
static Boolean		inInterpreter = false;
static int		exceptFlag;

/* Holds the semaphore to signal when the processor interval timesout */
static OOP		timeoutSem;

static OOP		semIntVec[NUM_SIGNALS];
static Boolean		semIntHappened[NUM_SIGNALS];
static Boolean		semIntFlag = false;


/* When true, this causes the byte code interpeter to immediately act
 * as if it saw a stream af method return bytecodes, until it finally exits.
 */
static Boolean		abortExecution = false;

/* When this is true, it means that the system is executing external C code,
 * which can be used by the ^C handler to know whether it longjmp to the
 * end of the C callout primitive in executePrimitiveOperation. */
static Boolean		inCCode = false;


/* Used to handle the case when the user types a ^C while executing callout
 * code */
static jmp_buf cCalloutJmpBuf;

/* when this flag is on and execution tracing is in effect, the top
 * of the stack is printed as well as the byte code */
static Boolean		verboseExecTracing = false;

/* when true, this tells the iterpreter that the processor timer has gone off,
 * and that it should set the timeout semaphore */
static Boolean		signalTimeoutSemaphore = false;


#ifdef ACCESSOR_DEBUGGING
static OOP		methodTemporary(), receiverVariable(),
  			methodVariable(), getMethodClass(),
			getStackReceiver(), methodLiteral(),
			getMethodContext();
static void		storeMethodTemporary(), storeReceiverVariable(),
  			storeMethodVariable(), storeMethodLiteral();
static Boolean		inBounds(), isBlockContext();
static Byte		*getMethodByteCodes();
static MethodHeader	getMethodHeader();
#endif /* ACCESSOR_DEBUGGING */
static int		relativeByteIndex();
static OOP		findMethod(), createMethodContext(), 
			getActiveProcess(),
			getProcessLists(), highestPriorityProcess(),
			removeFirstLink(), semaphoreNew(),
  			realizeContext();
static void		returnWithValue(), 
			sendBlockValue(),
			showBacktrace(),
			invalidateMethodCache(), methodHasBlockContext(),
			sleepProcess(), resumeProcess(), activateProcess(),
			changeProcessContext(), addLastLink(),
			suspendActiveProcess(), moveSemaphoreOOPs(),
			copyFakeContextObjects();

static Boolean		executePrimitiveOperation(),
			noParentContext(), isEmpty(), isRealOOP(),
			*boolAddrIndex();

static char		*selectorAsString();
static signalType	interruptHandler(), stopExecuting(), timeoutHandler(),
			semIntHandler();

#ifdef old_code /* Sat Jan 19 14:42:06 1991 */
/**/static OOP		*mathSelectors[16] = {
/**/  &plusSymbol,			/* 0  + */
/**/  &minusSymbol,			/* 1  - */
/**/  &lessThanSymbol,		/* 2  < */
/**/  &greaterThanSymbol,		/* 3  > */
/**/  &lessEqualSymbol,		/* 4  <= */
/**/  &greaterEqualSymbol,		/* 5  >= */
/**/  &equalSymbol,			/* 6  = */
/**/  &notEqualSymbol,		/* 7  ~= */
/**/  &timesSymbol,			/* 8  * */
/**/  &divideSymbol,		/* 9  / */
/**/  &remainderSymbol,		/* 10 \\ */
/**/  &plusSymbol,			/* 11 @, not implemented */
/**/  &bitShiftColonSymbol,		/* 12 bitShift: */
/**/  &integerDivideSymbol,		/* 13 // */
/**/  &bitAndColonSymbol,		/* 14 bitAnd: */
/**/  &bitOrColonSymbol		/* 15 bitOr: */
/**/};
#endif /* old_code Sat Jan 19 14:42:06 1991 */

struct SpecialSelectorStruct {
  OOP		*selector;
  int		args;
} specialMessages[16] = {
  &atColonSymbol,		1,
  &atColonPutColonSymbol,	2,
  &sizeSymbol,			0,
  &nextSymbol,			0,
  &nextPutColonSymbol,		1,
  &atEndSymbol,			0,
  &sameObjectSymbol,		1,
  &classSymbol,			0,
  &blockCopyColonSymbol,	1,
  &valueSymbol,			0,
  &valueColonSymbol,		1,
  &doColonSymbol,		1,
  &newSymbol,			0,
  &newColonSymbol,		1,
  &nilSymbol,			0, /* unimplemented selector */
  &nilSymbol,			0  /* unimplemented selector */
};

/*

### This is from the old stack based context days...update it to reflect
reality!

+-----------------------------------+
| receiver (self)		    |
+-----------------------------------+
| args				    |
+-----------------------------------+
| ...				    |
+-----------------------------------+
| temps				    |
+-----------------------------------+
| ...				    |
+-----------------------------------+
| saved ip of caller (relative)	    | FP, SP on interpreter entry
+-----------------------------------+
| saved method of caller            |
+-----------------------------------+
| saved temp pointer of caller	    |
+-----------------------------------+
| saved frame pointer of caller (?) |
+-----------------------------------+
| isBlock (boolean)                 |
+-----------------------------------+
| method context pointer	    |
+-----------------------------------+
|                                   | SP (after saving state)

 */


/*
 Interpretation of the virtual machine byte codes

0-15 push receiver variable 	0000iiii
16-31 push temporary location	0001iiii
32-63 push literal constant	001iiiii
64-95 push literal variable	010iiiii
96-103 pop & store rec var	01100iii
104-111 pop & store temp loc	01101iii
112-119 push indexed		01110iii receiver true false nil -1 0 1 2
120-123 return indexed		011110ii receiver true false nil
124-125 return st top from	0111110i message, block
126-127 unused			0111111i
128	push indir		10000000 jjkkkkkk (receiver var, temp loc,
						   lit const, lit var)
						   [jj] #kkkkkk
129	store indir		10000001 jjkkkkkk (rv, tl, illegal, lv)
130	pop & store indir	10000010 jjkkkkkk (like store indir)
131	send lit selector	10000011 jjjkkkkk sel #kkkkk with jjj args
132	send lit selector	10000100 jjjjjjjj kkkkkkkk (as 131)
133	send lit sel to super	10000101 jjjkkkkk as 131
134	send lit to super	10000110 jjjjjjjj kkkkkkkk like 132
135	pop stack top		10000111
136	duplicate stack top	10001000
137	push active context	10001001
138-143	unused
144-151	jmp iii+1		10010iii
152-159	pop & jmp false iii+1	10011iii
160-167	jmp (iii-4)*256+jjjjjjjj10100iii jjjjjjjj
168-171 pop & jmp on true	101010ii jjjjjjjj ii*256+jjjjjjjj
172-175 pop & jmp on false	101011ii jjjjjjjj like 168
176-191 send arith message	1011iiii
192-207	send special message	1100iiii
208-223 send lit sel #iiii	1101iiii with no arguments
224-239 send lit sel #iiii	1110iiii with 1 argument
240-255 send lit sel #iiii	1111iiii with 2 arguments
*/

/*
 *
 * How the interpreter works:
 *  1) The interpreter expects to be called in an environment where there
 *     already exists a well-defined method context.  The instruction pointer,
 *     stored in the global variable "ip", and the stack pointer, stored in the
 *     global variable "sp", should be set up to point into the current
 *     method and MethodContext.  Other global variables, such as "thisMethod",
 *     "self", "temporaries", etc. should also be setup.  See the routine
 *     prepareExecutionEnvironment for details.
 *  2) The interpreter checks to see if any change in its state is required,
 *     such as switching to a new process, dealing with an asynchronous signal
 *     which is not yet implemented, and printing out the byte codes that are 
 *     being executed, if that was requested by the user.
 *  3) After that, the byte code that ip points to is fetched and decoded.
 *     Some byte codes perform jumps, which are performed by merely adjusting
 *     the value of ip.  Some are message sends, which are described in
 *     more detail below.  Some instructions require more than one byte code
 *     to perform their work; ip is advanced as needed and the extension
 *     byte codes are fetched.
 *  4) After dispatching the byte code, the interpreter loops around to
 *     execute another byte code.  If ip has changed to point to nil, it is
 *     a signal that the execution of the method is over, and the interpreter
 *     returns to its caller.
 *
 * Note that the interpreter is not called recursively to implement message
 * sends.  Rather the state of the interpreter is saved away in the currently
 * executing context, and a new context is created and the global variables
 * such as ip, sp, and temporaries are initialized accordingly.
 *
 * When a message send occurs, the sendMessage routine is invoked.  It 
 * determines the class of the receiver, and checks to see if it already has
 * cached the method definition for the given selector and receiver class.
 * If so, that method is used, and if not, the receiver's method dictionary
 * is searched for a method with the proper selector.  If it's not found in
 * that method dictionary, the method dictionary of the classes parent is
 * examined, and on up the hierarchy, until a matching selector is found.
 *
 * If no selector is found, the receiver is sent a #doesNotUnderstand: message
 * to indicate that a matching method could not be found.
 *
 * If a method is found, it is examined for some special cases.  The special
 * cases are primitive return of self, return of an instance variable, or
 * execution of a primitive method definition.  This latter operation is
 * performed by the executePrimitiveOperation routine.  If the execution
 * of this primitive interpreter fails, the normal message send operation
 * is performed.
 *
 * If the found method is not one of the special cases, or if it is a 
 * primitive that failed to execute, a "normal" message send is performed.
 * This basically entails saving away what state the interpreter has, such
 * as the values of ip, and sp, being careful to save their relative locations
 * and not their physical addresses, because one or more garbage collections
 * could occur before the method context is returned to, and the absolute
 * pointers would be invalid.
 *
 * The sendMessage routine then creates a new MethodContext object, makes
 * its parent be the currently executing MethodContext, and sets up
 * the interpreters global variables to reference the new method and
 * new MethodContext.  Once those variables are set, sendMessage returns
 * to the interpreter, which cheerfully begins executing the new method,
 * totally unaware that the method that it was executing has changed.
 *
 * When a method returns, the method that called it is used to restore the
 * interpreter's global variables to the state that they were in before
 * the called method was called.  The values of ip and sp are restored to
 * their absolute address values, and the other global state variables
 * are restored accordingly.  When after the state has been restored, the
 * interpreter continues execution, again totally oblivious to the fact
 * that it's not running the same method it was on its previous byte code.
 *
 * Global state
 * The following variables constitute the interpreter's state:
 * ip -- the real memory address of the next byte code to be executed.
 * sp -- the real memory address of the stack that's stored in the currently
 *       executing block or method context.
 * thisMethod -- a CompiledMethod that is the currently executing method.
 * thisContextOOP -- a BlockContext or MethodContext that indicates the
 *                   context that the interpreter is currently running in.
 * temporaries -- physical address of the base of the method temporary
 *                variables.  Typically a small number of bytes (multiple of 4
 *                since it points to OOPs) lower than sp.
 * self -- an OOP that is the current receiver of the current message.
 * 
 * Note about the interpreter:
 * As an experiment, I unrolled the case statement somewhat into separate
 * case arms for each byte code.  The intention was to increase performance.
 * I haven't measured to see whether it makes a difference or not.
 *
 * The local regs concept was pre-GC.  By caching the values of IP and SP
 * in local register variables, I hoped to increase performance.  I only
 * needed to export the variables when I was calling out to routines that
 * might change them.  However, the garbage collector may run at any time,
 * and the values of IP and SP point to things in the root set and so will
 * change on a GC flip.  I'm leaving the code to deal with them as local 
 * registers in but conditionally compiled out until I can figure out a
 * clever way to make them be registers again, or give up on the idea totally.
 */

void interpret()
{
  Byte		ival, ival2, ival3, *savedIP;
  OOP		returnedValue, *savedSP, methodContextOOP, tempOOP;
  BlockContext	blockContext;
  int		i;
  IntState	oldSigMask;
#ifdef LOCAL_REGS
  register OOP	*sp;
  register Byte	*ip;
#endif /* LOCAL_REGS */

  importRegs();

  inInterpreter = true;

  exceptFlag = executionTracing;

  for (; ip; ) {		/* when IP is nil, return to caller */
    clearGCFlipFlags();

    if (exceptFlag) {
      exportRegs();
      if (abortExecution) {
	goto abortMethod;	/* ugh! */
      }
      if (signalTimeoutSemaphore) {
	oldSigMask = disableInterrupts();
	if (isClass(timeoutSem, semaphoreClass)) {
	  syncSignal(timeoutSem);
	}
	timeoutSem = nilOOP;
	signalTimeoutSemaphore = false;
	enableInterrupts(oldSigMask);
      }
      if (semIntFlag) {
	oldSigMask = disableInterrupts();
	for (i = 0; i < NUM_SIGNALS; i++) {
	  if (semIntHappened[i]) {
	    if (isClass(semIntVec[i], semaphoreClass)) {
	      syncSignal(semIntVec[i]);
	    } else {
	      errorf("C signal trapped, but no semaphore was waiting");
	    }
	    semIntHappened[i] = false;
	  }
	}
	semIntFlag = false;
	enableInterrupts(oldSigMask);
      }

      if (asyncQueueIndex) {	/* deal with any async signals  */
	oldSigMask = disableInterrupts(); /* block out everything! */
	for (i = 0; i < asyncQueueIndex; i++) {
	  /* ### this is not right...async signals must not allocate storage */
	  errorf("### Fix asyncSignal handling");
	  syncSignal(queuedAsyncSignals[i]);
	}
	asyncQueueIndex = 0;
	enableInterrupts(oldSigMask);
      }
      if (!isNil(switchToProcess)) {
	/*exportRegs(); */
	changeProcessContext(switchToProcess);
	importRegs();
	/* make sure to validate the IP again */
	continue;
      }
      if (executionTracing) {
	printf("%5d:\t", relativeByteIndex(ip, thisMethod));
	printByteCodeName(ip, relativeByteIndex(ip, thisMethod),
			  ((Method)oopToObj(thisMethod))->literals);
	printf("\n");
	if (verboseExecTracing) {
	  printf("\t  --> ");
	  printObject(stackTop());
	  printf("\n");
	}
      }
      exceptFlag = executionTracing;
      importRegs();
    }
      

    byteCodeCounter++;
#ifdef countingByteCodes
    byteCodes[*ip]++;
#endif /* countingByteCodes */

    /* Note: some of the case arms are expanded out to literal cases,
       instead of case0: case1: ... pushOOP(receiverVariable(self, ival&15))
       this is an experiment to try to improve performance of the byte code
       interpreter throughout the system. */
    switch(ival = *ip++) {
    case  0:	pushOOP(receiverVariable(self, 0));	break;
    case  1:	pushOOP(receiverVariable(self, 1));	break;
    case  2:	pushOOP(receiverVariable(self, 2));	break;
    case  3:	pushOOP(receiverVariable(self, 3));	break;
    case  4:	pushOOP(receiverVariable(self, 4));	break;
    case  5:	pushOOP(receiverVariable(self, 5));	break;
    case  6:	pushOOP(receiverVariable(self, 6));	break;
    case  7:	pushOOP(receiverVariable(self, 7));	break;
    case  8:	pushOOP(receiverVariable(self, 8));	break;
    case  9:	pushOOP(receiverVariable(self, 9));	break;
    case 10:	pushOOP(receiverVariable(self, 10));	break;
    case 11:	pushOOP(receiverVariable(self, 11));	break;
    case 12:	pushOOP(receiverVariable(self, 12));	break;
    case 13:	pushOOP(receiverVariable(self, 13));	break;
    case 14:	pushOOP(receiverVariable(self, 14));	break;
    case 15:	pushOOP(receiverVariable(self, 15));	break;

    case 16:	pushOOP(methodTemporary(0));	break;
    case 17:	pushOOP(methodTemporary(1));	break;
    case 18:	pushOOP(methodTemporary(2));	break;
    case 19:	pushOOP(methodTemporary(3));	break;
    case 20:	pushOOP(methodTemporary(4));	break;
    case 21:	pushOOP(methodTemporary(5));	break;
    case 22:	pushOOP(methodTemporary(6));	break;
    case 23:	pushOOP(methodTemporary(7));	break;
    case 24:	pushOOP(methodTemporary(8));	break;
    case 25:	pushOOP(methodTemporary(9));	break;
    case 26:	pushOOP(methodTemporary(10));	break;
    case 27:	pushOOP(methodTemporary(11));	break;
    case 28:	pushOOP(methodTemporary(12));	break;
    case 29:	pushOOP(methodTemporary(13));	break;
    case 30:	pushOOP(methodTemporary(14));	break;
    case 31:	pushOOP(methodTemporary(15));	break;

    case 32:	pushOOP(methodLiteral(thisMethod, 0));	break;
    case 33:	pushOOP(methodLiteral(thisMethod, 1));	break;
    case 34:	pushOOP(methodLiteral(thisMethod, 2));	break;
    case 35:	pushOOP(methodLiteral(thisMethod, 3));	break;
    case 36:	pushOOP(methodLiteral(thisMethod, 4));	break;
    case 37:	pushOOP(methodLiteral(thisMethod, 5));	break;
    case 38:	pushOOP(methodLiteral(thisMethod, 6));	break;
    case 39:	pushOOP(methodLiteral(thisMethod, 7));	break;
    case 40:	pushOOP(methodLiteral(thisMethod, 8));	break;
    case 41:	pushOOP(methodLiteral(thisMethod, 9));	break;
    case 42:	pushOOP(methodLiteral(thisMethod, 10));	break;
    case 43:	pushOOP(methodLiteral(thisMethod, 11));	break;
    case 44:	pushOOP(methodLiteral(thisMethod, 12));	break;
    case 45:	pushOOP(methodLiteral(thisMethod, 13));	break;
    case 46:	pushOOP(methodLiteral(thisMethod, 14));	break;
    case 47:	pushOOP(methodLiteral(thisMethod, 15));	break;
    case 48:	pushOOP(methodLiteral(thisMethod, 16));	break;
    case 49:	pushOOP(methodLiteral(thisMethod, 17));	break;
    case 50:	pushOOP(methodLiteral(thisMethod, 18));	break;
    case 51:	pushOOP(methodLiteral(thisMethod, 19));	break;
    case 52:	pushOOP(methodLiteral(thisMethod, 20));	break;
    case 53:	pushOOP(methodLiteral(thisMethod, 21));	break;
    case 54:	pushOOP(methodLiteral(thisMethod, 22));	break;
    case 55:	pushOOP(methodLiteral(thisMethod, 23));	break;
    case 56:	pushOOP(methodLiteral(thisMethod, 24));	break;
    case 57:	pushOOP(methodLiteral(thisMethod, 25));	break;
    case 58:	pushOOP(methodLiteral(thisMethod, 26));	break;
    case 59:	pushOOP(methodLiteral(thisMethod, 27));	break;
    case 60:	pushOOP(methodLiteral(thisMethod, 28));	break;
    case 61:	pushOOP(methodLiteral(thisMethod, 29));	break;
    case 62:	pushOOP(methodLiteral(thisMethod, 30));	break;
    case 63:	pushOOP(methodLiteral(thisMethod, 31));	break;

    case 64:	pushOOP(methodVariable(thisMethod, 0));	break;
    case 65:	pushOOP(methodVariable(thisMethod, 1));	break;
    case 66:	pushOOP(methodVariable(thisMethod, 2));	break;
    case 67:	pushOOP(methodVariable(thisMethod, 3));	break;
    case 68:	pushOOP(methodVariable(thisMethod, 4));	break;
    case 69:	pushOOP(methodVariable(thisMethod, 5));	break;
    case 70:	pushOOP(methodVariable(thisMethod, 6));	break;
    case 71:	pushOOP(methodVariable(thisMethod, 7));	break;
    case 72:	pushOOP(methodVariable(thisMethod, 8));	break;
    case 73:	pushOOP(methodVariable(thisMethod, 9));	break;
    case 74:	pushOOP(methodVariable(thisMethod, 10));	break;
    case 75:	pushOOP(methodVariable(thisMethod, 11));	break;
    case 76:	pushOOP(methodVariable(thisMethod, 12));	break;
    case 77:	pushOOP(methodVariable(thisMethod, 13));	break;
    case 78:	pushOOP(methodVariable(thisMethod, 14));	break;
    case 79:	pushOOP(methodVariable(thisMethod, 15));	break;
    case 80:	pushOOP(methodVariable(thisMethod, 16));	break;
    case 81:	pushOOP(methodVariable(thisMethod, 17));	break;
    case 82:	pushOOP(methodVariable(thisMethod, 18));	break;
    case 83:	pushOOP(methodVariable(thisMethod, 19));	break;
    case 84:	pushOOP(methodVariable(thisMethod, 20));	break;
    case 85:	pushOOP(methodVariable(thisMethod, 21));	break;
    case 86:	pushOOP(methodVariable(thisMethod, 22));	break;
    case 87:	pushOOP(methodVariable(thisMethod, 23));	break;
    case 88:	pushOOP(methodVariable(thisMethod, 24));	break;
    case 89:	pushOOP(methodVariable(thisMethod, 25));	break;
    case 90:	pushOOP(methodVariable(thisMethod, 26));	break;
    case 91:	pushOOP(methodVariable(thisMethod, 27));	break;
    case 92:	pushOOP(methodVariable(thisMethod, 28));	break;
    case 93:	pushOOP(methodVariable(thisMethod, 29));	break;
    case 94:	pushOOP(methodVariable(thisMethod, 30));	break;
    case 95:	pushOOP(methodVariable(thisMethod, 31));	break;

    case  96:	storeReceiverVariable(self, 0, popOOP());	break;
    case  97:	storeReceiverVariable(self, 1, popOOP());	break;
    case  98:	storeReceiverVariable(self, 2, popOOP());	break;
    case  99:	storeReceiverVariable(self, 3, popOOP());	break;
    case 100:	storeReceiverVariable(self, 4, popOOP());	break;
    case 101:	storeReceiverVariable(self, 5, popOOP());	break;
    case 102:	storeReceiverVariable(self, 6, popOOP());	break;
    case 103:	storeReceiverVariable(self, 7, popOOP());	break;

    case 104:	storeMethodTemporary(0, popOOP());	break;
    case 105:	storeMethodTemporary(1, popOOP());	break;
    case 106:	storeMethodTemporary(2, popOOP());	break;
    case 107:	storeMethodTemporary(3, popOOP());	break;
    case 108:	storeMethodTemporary(4, popOOP());	break;
    case 109:	storeMethodTemporary(5, popOOP());	break;
    case 110:	storeMethodTemporary(6, popOOP());	break;
    case 111:	storeMethodTemporary(7, popOOP());	break;

    case 112: uncheckedPushOOP(self);		break;
    case 113: uncheckedPushOOP(trueOOP);	break;
    case 114: uncheckedPushOOP(falseOOP); 	break;
    case 115: uncheckedPushOOP(nilOOP); 	break;
    case 116: pushInt(-1);			break;
    case 117: pushInt(0);			break;
    case 118: pushInt(1);			break;
    case 119: pushInt(2);			break;

    case 120: case 121: case 122: case 123:
      switch (ival & 3) {
      case 0: uncheckedPushOOP(self);   	break;
      case 1: uncheckedPushOOP(trueOOP);	break;
      case 2: uncheckedPushOOP(falseOOP); 	break;
      case 3: uncheckedPushOOP(nilOOP); 	break;
      }

      /* fall through */

    case 124:			/* return stack top from method */
abortMethod:			/* here if ^C is seen to abort things */
      returnedValue = popOOP();

      if (isBlockContext(thisContextOOP)) {
	/*
	 * We're executing in a block context and an explicit return is
	 * encountered.  This means that we are to return from the caller of
	 * the method that created the block context, no matter how many
	 * levels of message sending are between where we currently are and
	 * our parent method context.
	 */
	blockContext = (BlockContext)oopToObj(thisContextOOP);
	methodContextOOP = blockContext->home;
	if (noParentContext(methodContextOOP)) {
	  /* ### this should send a message to Object of some kind */
	  errorf("Block returning to non-existent method context");
	  return;
	}
      } else {
	methodContextOOP = thisContextOOP;
	if (methodCount) {
	  methodCount--;
	  totalMethods++;
	}
      }

      exportRegs();
      returnWithValue(returnedValue, methodContextOOP);
      importRegs();		/* don't need to export these */
      break;

    case 125:			/* return stack top from block to caller */
      returnedValue = popOOP();
      exportRegs();
      returnWithValue(returnedValue, thisContextOOP);
      importRegs();
      break;

/* 126, 127 unused by blue book, allocating 127 for debugger's
   breakpoint (not yet implemented) */

    case 128:
      ival2 = *ip++;
      switch (ival2 >> 6) {
      case 0:
	pushOOP(receiverVariable(self, ival2 & 63));
	break;
      case 1:
	pushOOP(methodTemporary(ival2 & 63));
	break;
      case 2:
	pushOOP(methodLiteral(thisMethod, ival2 & 63));
	break;
      case 3:
	pushOOP(methodVariable(thisMethod, ival2 & 63));
	break;
      }
      break;

    case 129:
      ival2 = *ip++;
      switch (ival2 >> 6) {
      case 0:
	storeReceiverVariable(self, ival2 & 63, stackTop());
	break;
      case 1:
	storeMethodTemporary(ival2 & 63, stackTop());
	break;
      case 2:
	errorf("Attempt to store into a method constant");
	break;
      case 3:
	storeMethodVariable(thisMethod, ival2 & 63, stackTop());
      }
      break;

    case 130:
      ival2 = *ip++;
      switch (ival2 >> 6) {
      case 0:
	storeReceiverVariable(self, ival2 & 63, popOOP());
	break;
      case 1:
	storeMethodTemporary(ival2 & 63, popOOP());
	break;
      case 2:
	errorf("Attempt to store into a method constant");
	break;
      case 3:
	storeMethodVariable(thisMethod, ival2 & 63, popOOP());
      }
      break;

    case 131:			/* send selector y (xxxyyyyy), x args */
      ival2 = *ip++;
      /* ### Send message knows the number of arguments that are being
	 passed.  We could easily adjust the stack pointer here by doing
	 some kind of popNOOPs.  The only trouble is what happens when
	 the number of args doesn't agree with what the method is expecting,
	 and we have to generate an error.  Also, if we don't export the sp
	 here, we'll have to pass this as a parameter and sendMessage will
	 have to export it anyway.  The cost of an export or import is
	 about 1 or 2 instructions, so it may be cheap enough to just do
	 in the places that we need to to it */
      exportRegs();		/* ### can this be removed? */
      sendMessage(methodLiteral(thisMethod, ival2 & 31), ival2 >> 5, false);
      importRegs();
      break;

    case 132:			/* send selector y (xxxxxxxx,yyyyyyyy) x args*/
      ival2 = *ip++;		/* the number of args */
      ival3 = *ip++;		/* the selector */
      exportRegs();
      sendMessage(methodLiteral(thisMethod, ival3), ival2, false);
      importRegs();
      break;

    case 133:			/* send super selector y (xxxyyyyy), x args*/
      ival2 = *ip++;
      exportRegs();
      sendMessage(methodLiteral(thisMethod, ival2 & 31), ival2 >> 5, true);
      importRegs();
      break;

    case 134:			/* send super y (xxxxxxxx,yyyyyyyy) x args */
      ival2 = *ip++;		/* the number of args */
      ival3 = *ip++;		/* the selector */
      exportRegs();
      sendMessage(methodLiteral(thisMethod, ival3), ival2, true);
      importRegs();
      break;

    case 135:
      popOOP();
      break;

    case 136:
      tempOOP = stackTop();
      pushOOP(tempOOP);
      break;

    case 137: 			/* push active context */
      exportRegs();
      realizeMethodContexts();
      importRegs();
      pushOOP(thisContextOOP);
      break;

    case 144: case 145: case 146: case 147:
    case 148: case 149: case 150: case 151:
      ip += (ival & 7) + 1;	/* jump forward 1 to 8 bytes */
      break;

    case 152: case 153: case 154: case 155:
    case 156: case 157: case 158: case 159:
      if ((tempOOP = popOOP()) == falseOOP) { /* jump forward if false 1 to 8 bytes */
	ip += (ival & 7) + 1;
      } else if (tempOOP != trueOOP) {
	printf("Boolean instance required!\n");
	showBacktrace();
	stopExecuting(0);
      }
      break;

    case 160: case 161: case 162: case 163:
    case 164: case 165: case 166: case 167:
      ival2 = *ip++;		/* jump forward or back */
      ip += (((ival & 7) - 4) << 8) + ival2;
      break;

    case 168: case 169: case 170: case 171:
      ival2 = *ip++;
      if ((tempOOP = popOOP()) == trueOOP) {
	ip += ((ival & 3) << 8) + ival2;
      } else if (tempOOP != falseOOP) {
	printf("Boolean instance required!\n");
	showBacktrace();
	stopExecuting(0);
      }
      break;

    case 172: case 173: case 174: case 175:
      ival2 = *ip++;
      if ((tempOOP = popOOP()) == falseOOP) {
	ip += ((ival & 3) << 8) + ival2;
      } else if (tempOOP != trueOOP) {
	printf("Boolean instance required!\n");
	showBacktrace();
	stopExecuting(0);
      }
      break;

#define RAW_INT_OP(operator)		\
{					\
  OOP	oop2;				\
  int	arg1, arg2;			\
  oop2 = popOOP();			\
  if (isInt(oop2)) {			\
    arg1 = toInt(tempOOP);		\
    arg2 = toInt(oop2);			\
    setStackTopInt(arg1 operator arg2);	\
/* why?    importRegs();*/			\
    break;				\
  }					\
  unPop(1);				\
}

#define RAW_FLOAT_OP(operator)		\
{					\
  OOP	oop2,oopResult;			\
  double farg1, farg2;			\
  oop2 = popOOP();			\
  if (isClass(oop2, floatClass)) {	\
    farg1 = floatOOPValue(tempOOP);	\
    farg2 = floatOOPValue(oop2);	\
    exportRegs();			\
    oopResult = floatNew(farg1 operator farg2); \
    importRegs();			\
    setStackTop(oopResult);		\
/* why?    importRegs();	*/		\
    break;				\
  }					\
  unPop(1);				\
}


#define INTERP_BASIC_OP(operator)	\
  tempOOP = stackAt(1);			\
  if (isInt(tempOOP)) {			\
    RAW_INT_OP(operator);		\
  } else if (oopClass(tempOOP) == floatClass) {	\
    RAW_FLOAT_OP(operator);		\
  }



#define RAW_BOOL_OP(operator)		\
{					\
  OOP oop2;				\
  int arg1, arg2;			\
  oop2 = popOOP();			\
  if (isInt(oop2)) {			\
    arg1 = toInt(tempOOP);		\
    arg2 = toInt(oop2);			\
    setStackTopBoolean(arg1 operator arg2);	\
/* why?    importRegs(); */			\
    break;				\
  }					\
  unPop(1);				\
}

#define RAW_BOOL_FLOAT_OP(operator)	\
{					\
  OOP	oop2;				\
  double farg1, farg2;			\
  oop2 = popOOP();			\
  if (isClass(oop2, floatClass)) {	\
    farg1 = floatOOPValue(tempOOP);	\
    farg2 = floatOOPValue(oop2);	\
    setStackTopBoolean(farg1 operator farg2); \
/* why?    importRegs();*/			\
    break;				\
  }					\
  unPop(1);				\
}

#define INTERP_BASIC_BOOL(operator)	\
  tempOOP = stackAt(1);			\
  if (isInt(tempOOP)) {			\
    RAW_BOOL_OP(operator);		\
  } else if (oopClass(tempOOP) == floatClass) {	\
    RAW_BOOL_FLOAT_OP(operator);	\
  }

    /* By "hard wiring" the definitions of these special operators, we get
     * the performance up to > 325K bytecodes/sec (SS1+,opt).  Yes, it means
     * that we cannot redefine + et al for Integer and Float, but I think
     * the trade is worth it.  Besides, with a little conspiring between the
     * compiler and the code here, it would be possible to have the code
     * test to see if the basic operator has been overridden and if so, do
     * a normal send.
     */

    case 176:
      INTERP_BASIC_OP(+);
      exportRegs();
      sendMessage(plusSymbol, 1, false);
      importRegs();
      break;

    case 177:
      INTERP_BASIC_OP(-);
      exportRegs();
      sendMessage(minusSymbol, 1, false);
      importRegs();
      break;

    case 178:
      INTERP_BASIC_BOOL(<);
      exportRegs();
      sendMessage(lessThanSymbol, 1, false);
      importRegs();
      break;

    case 179:
      INTERP_BASIC_BOOL(>);
      exportRegs();
      sendMessage(greaterThanSymbol, 1, false);
      importRegs();
      break;

    case 180:
      INTERP_BASIC_BOOL(<=);
      exportRegs();
      sendMessage(lessEqualSymbol, 1, false);
      importRegs();
      break;

    case 181:
      INTERP_BASIC_BOOL(>=);
      exportRegs();
      sendMessage(greaterEqualSymbol, 1, false);
      importRegs();
      break;

    case 182:
      INTERP_BASIC_BOOL(==);
      exportRegs();
      sendMessage(equalSymbol, 1, false);
      importRegs();
      break;

    case 183:
      INTERP_BASIC_BOOL(!=);
      exportRegs();
      sendMessage(notEqualSymbol, 1, false);
      importRegs();
      break;

    case 184:
      INTERP_BASIC_OP(*);
      exportRegs();
      sendMessage(timesSymbol, 1, false);
      importRegs();
      break;

    case 185:
      exportRegs();
      sendMessage(divideSymbol, 1, false);
      importRegs();
      break;

    case 186:
      exportRegs();
      sendMessage(remainderSymbol, 1, false);
      importRegs();
      break;

    case 187:
      exportRegs();
      /* The compiler won't even generate this bytecode */
      sendMessage(plusSymbol, 1, false); /* @, not implemented */
      importRegs();
      break;

    case 188:
      tempOOP = stackAt(1);
      if (isInt(tempOOP)) {
	OOP	oop2;
	int	arg1, arg2;
	oop2 = popOOP();
	if (isInt(oop2)) {
	  arg1 = toInt(tempOOP);
	  arg2 = toInt(oop2);
	  if (arg2 >= 0) {
	    setStackTopInt(arg1 << arg2);
	  } else {
	    setStackTopInt(arg1 >> -arg2);
	  }
	  break;
	}
	unPop(1);
      }
      exportRegs();
      sendMessage(bitShiftColonSymbol, 1, false);
      importRegs();
      break;

    case 189:
      tempOOP = stackAt(1);
      if (isInt(tempOOP)) {
	RAW_INT_OP(/);
      }
      exportRegs();
      sendMessage(integerDivideSymbol, 1, false);
      importRegs();
      break;

    case 190:
      tempOOP = stackAt(1);
      if (isInt(tempOOP)) {
	RAW_INT_OP(&);
      }
      exportRegs();
      sendMessage(bitAndColonSymbol, 1, false);
      importRegs();
      break;

    case 191:
      tempOOP = stackAt(1);
      if (isInt(tempOOP)) {
	RAW_INT_OP(|);
      }
      exportRegs();
      sendMessage(bitOrColonSymbol, 1, false);
      importRegs();
      break;

#ifdef bogus /* Sat Jan  5 22:12:45 1991 */
/**/    case 176: case 177: case 178: case 179:
/**/    case 180: case 181: case 182: case 183:
/**/    case 184: case 185: case 186: case 187:
/**/    case 188: case 189: case 190: case 191:
/**/				/* send math message */
/**/      exportRegs();
/**/      sendMessage(*mathSelectors[ival & 15], 1, false);
/**/      importRegs();
/**/      break;
#endif /* bogus Sat Jan  5 22:12:45 1991 */

    case 192:
      exportRegs();
      sendMessage(atColonSymbol, 1, false);
      importRegs();
      break;

    case 193:
      exportRegs();
      sendMessage(atColonPutColonSymbol, 2, false);
      importRegs();
      break;

    case 194:
      exportRegs();
      sendMessage(sizeSymbol, 0, false);
      importRegs();
      break;

    case 195:
      exportRegs();
      sendMessage(nextSymbol, 0, false);
      importRegs();
      break;

    case 196:
      exportRegs();
      sendMessage(nextPutColonSymbol, 1, false);
      importRegs();
      break;

    case 197:
      exportRegs();
      sendMessage(atEndSymbol, 0, false);
      importRegs();
      break;

    case 198:
      exportRegs();
      sendMessage(sameObjectSymbol, 1, false);
      importRegs();
      break;

    case 199:
      exportRegs();
      sendMessage(classSymbol, 0, false);
      importRegs();
      break;

    case 200:
      exportRegs();
      sendMessage(blockCopyColonSymbol, 1, false);
      importRegs();
      break;

    case 201:
      exportRegs();
      sendMessage(valueSymbol, 0, false);
      importRegs();
      break;

    case 202:
      exportRegs();
      sendMessage(valueColonSymbol, 1, false);
      importRegs();
      break;

    case 203:
      exportRegs();
      sendMessage(doColonSymbol, 1, false);
      importRegs();
      break;

    case 204:
      exportRegs();
      sendMessage(newSymbol, 0, false);
      importRegs();
      break;

    case 205:
      exportRegs();
      sendMessage(newColonSymbol, 1, false);
      importRegs();
      break;

    case 206:
      exportRegs();
      sendMessage(nilSymbol, 0, /* unimplemented selector */
		  false);
      importRegs();
      break;

    case 207:
      exportRegs();
      sendMessage(nilSymbol, 0, /* unimplemented selector */
		  false);
      importRegs();
      break;

#ifdef old_code /* Mon Jan  7 21:58:21 1991 */
/**/    case 192: case 193: case 194: case 195:
/**/    case 196: case 197: case 198: case 199:
/**/    case 200: case 201: case 202: case 203:
/**/    case 204: case 205: case 206: case 207:
/**/				/* send special message */
/**/      exportRegs();
/**/      sendMessage(*specialMessages[ival & 15].selector,
/**/		  specialMessages[ival & 15].args, false);
/**/      importRegs();
/**/      break;
#endif /* old_code Mon Jan  7 21:58:21 1991 */

    case 208: case 209: case 210: case 211:
    case 212: case 213: case 214: case 215:
    case 216: case 217: case 218: case 219:
    case 220: case 221: case 222: case 223:
				/* send selector no args */
      exportRegs();
      sendMessage(methodLiteral(thisMethod, ival & 15), 0, false);
      importRegs();
      break;

    case 224: case 225: case 226: case 227:
    case 228: case 229: case 230: case 231:
    case 232: case 233: case 234: case 235:
    case 236: case 237: case 238: case 239:
				/* send selector 1 arg */
      exportRegs();
      sendMessage(methodLiteral(thisMethod, ival & 15), 1, false);
      importRegs();
      break;

    case 240: case 241: case 242: case 243:
    case 244: case 245: case 246: case 247:
    case 248: case 249: case 250: case 251:
    case 252: case 253: case 254: case 255:
				/* send selector 2 args */
      exportRegs();
      sendMessage(methodLiteral(thisMethod, ival & 15), 2, false);
      importRegs();
      break;

    default:
      errorf("Illegal byte code %d executed\n", ival);
      break;
    }
  }
  inInterpreter = false;

  exportRegs();
}

static void changeProcessContext(newProcess)
OOP	newProcess;
{
  MethodContext thisContext, methodContext;
  OOP		processOOP, methodContextOOP;
  Process	process;
  ProcessorScheduler processor;
  
  realizeMethodContexts();	/* clean things up */

  switchToProcess = nilOOP;
  if (!isNil(thisContextOOP)) {
    thisContext = (MethodContext)oopToObj(thisContextOOP);
    /* save old context information */
    thisContext->ipOffset = fromInt(relativeByteIndex(ip, thisMethod));
    /* leave sp pointing to receiver, which is replaced on return with value*/
    thisContext->spOffset = fromInt(sp - thisContext->contextStack);
  }

  processOOP = getActiveProcess();
  process = (Process)oopToObj(processOOP);
  prepareToStore(processOOP, thisContextOOP);
  process->suspendedContext = thisContextOOP;

  processor = (ProcessorScheduler)oopToObj(processorOOP);
  prepareToStore(processorOOP, newProcess);
  processor->activeProcess = newProcess;
  
  process = (Process)oopToObj(newProcess);

  thisContextOOP = process->suspendedContext;
  /* ### should this be block context? */
  thisContext = (MethodContext)oopToObj(thisContextOOP);

  methodContextOOP = getMethodContext(thisContextOOP);

  methodContext = (MethodContext)oopToObj(methodContextOOP);
  thisMethod = methodContext->method;
  ip = toInt(thisContext->ipOffset) + getMethodByteCodes(thisMethod);
  sp = thisContext->contextStack + toInt(thisContext->spOffset);

  /* temporaries and self live in the method, not in the block */
  temporaries = methodContext->contextStack;
  self = methodContext->receiver;
}


/*
 *	static Boolean noParentContext(methodContextOOP)
 *
 * Description
 *
 *	Returns true if there is no parent context for "methodContextOOP".
 *	This occurs when the method context has been returned from, but it had
 *	created a block context during its execution and so it was not
 *	deallocated when it returned.  Now some block context is trying to
 *	return from that method context, but where to return to is undefined.
 *
 * Inputs
 *
 *	methodContextOOP: 
 *		An OOP that is the method context to be examined.
 *
 * Outputs
 *
 *	True if the current method has no parent, false otherwise.
 */
static Boolean noParentContext(methodContextOOP)
OOP methodContextOOP;
{
  MethodContext methodContext;

  methodContext = (MethodContext)oopToObj(methodContextOOP);

  return (isNil(methodContext->sender));
}

#ifdef ACCESSOR_DEBUGGING
/*
 *	static OOP getMethodContext(contextOOP)
 *
 * Description
 *
 *	Returns the method context for either a block context or a method
 *	context. 
 *
 * Inputs
 *
 *	contextOOP: Block or Method context OOP
 *		
 *
 * Outputs
 *
 *	Method context for CONTEXTOOP.
 */
static OOP getMethodContext(contextOOP)
OOP	contextOOP;
{
  return (getMethodContextInternal(contextOOP));
}
#endif /* ACCESSOR_DEBUGGING */

long numMethods, numBlocks;
long totalRealized = 0;
OOP		fakeList = nil;


static OOP allocMethodContext()
{
  FakeOOP	f;
  OOP		fakeOOP;
  MethodContext	methodContext;

  if (fakeList) {
    fakeOOP = fakeList;
    methodContext = (MethodContext)oopToObj(fakeList);
    fakeList = methodContext->sender;
/* dprintf("[[[[ Allocing fake %8x\n", fakeOOP); */
    return (fakeOOP);
  }

  f = (FakeOOP)malloc(sizeof(struct FakeContextOOP));
  f->mc.objSize = sizeof(struct MethodContextStruct) >> 2;
  f->mc.objClass = methodContextClass;
  nilFill(&f->mc.sender, 8/* num oops w/o stack */);
  
  f->oop.object = (Object)f;	/* &f->mc optimized */
  f->oop.flags = F_FAKE;

/* dprintf("[[[[ Allocing new fakes %8x\n", &f->oop); */
  return (&f->oop);
}


#ifdef old_code /* Sat Dec 29 14:53:04 1990 */
/**/static OOP allocMethodContext()
/**/{
/**/  MethodContext methodContext;
/**/
/**/  methodContext = (MethodContext)instantiateWith(methodContextClass,
/**/						 CONTEXT_STACK_SIZE);
/**/methodCount++;
/**/numMethods++;
/**/  return (allocOOP(methodContext));
/**/}
#endif /* old_code Sat Dec 29 14:53:04 1990 */

static OOP allocBlockContext()
{
  BlockContext blockContext;

  blockContext = (BlockContext)instantiateWith(blockContextClass,
					       CONTEXT_STACK_SIZE);
#ifndef OPTIMIZE
totalRealized += methodCount;
methodCount = 0;
numBlocks++;
#endif

  return (allocOOP(blockContext));
}


static void deallocMethodContext(methodContextOOP)
OOP	methodContextOOP;
{
  MethodContext	methodContext;

#ifndef OPTIMIZE
  if (!isFake(methodContextOOP)) {
    printf("!!! Deallocating real method context\n");
    return;
  }
#endif

  methodContext = (MethodContext)oopToObj(methodContextOOP);

  methodContext->sender = fakeList;
  fakeList = methodContextOOP;
}


void realizeMethodContexts()
{
  MethodContext methodContext;
  int		spOffset;

  if (!isFake(thisContextOOP)) {
    /* Should never have a non-fake on top of a fake, so we can short circuit
     * this way.  Also takes care of when thisContextOOP is a block */
    return;
  }

  methodContext = (MethodContext)oopToObj(thisContextOOP);

  spOffset = sp - methodContext->contextStack;
  methodContext->spOffset = fromInt(spOffset);

  thisContextOOP = realizeContext(thisContextOOP);
  methodContext = (MethodContext)oopToObj(thisContextOOP);

  sp = methodContext->contextStack + spOffset;
  temporaries = methodContext->contextStack;
  /* self doesn't change after realization (???gc may change it?) */
}

/* !!! debug */

OOP junkContext;

#ifdef bogus /* Sun Nov 24 19:29:31 1991 */
/**/printContext()
/**/{
/**//*   dprintf("thisContextOOP = %8x\n", thisContextOOP); */
/**/  junkContext = thisContextOOP;
/**/}
#endif /* bogus Sun Nov 24 19:29:31 1991 */


static OOP realizeContext(methodContextOOP) 
OOP	methodContextOOP;
{
  MethodContext methodContext, newContext;
  int		spOffset;
  OOP		sender;

/*  if (!isFake(methodContextOOP)) {
    return (methodContextOOP);
  }
*/

  methodContext = (MethodContext)oopToObj(methodContextOOP);
  if (isFake(methodContext->sender)) {
    sender = realizeContext(methodContext->sender);
    /*
     * doing the realizeContext may have moved method context to the other
     * space, so we can't count on our cached version
     */
    if (methodContext != (MethodContext)oopToObj(methodContextOOP)) {
      printf("in realize got a bug!!!\n");
    }
    methodContext = (MethodContext)oopToObj(methodContextOOP);
    methodContext->sender = sender;
  }

  newContext = (MethodContext)newInstanceWith(methodContextClass,
					      CONTEXT_STACK_SIZE);
#ifdef debug_checking /* Tue Dec 31 15:14:55 1991 */
/**/    if (methodContext != (MethodContext)oopToObj(methodContextOOP)) {
/**/      printf("in realize got a bug also!!!\n");
/**/    }
#endif /* debug_checking Tue Dec 31 15:14:55 1991 */

  methodContext = (MethodContext)oopToObj(methodContextOOP);
  spOffset = toInt(methodContext->spOffset);

  memcpy(newContext, methodContext, sizeof(struct MethodContextStruct)
	 - ((CONTEXT_STACK_SIZE - spOffset - 1) * sizeof(OOP)) );
  nilFill(newContext->contextStack + spOffset + 1,
	  CONTEXT_STACK_SIZE - spOffset - 1);

  /* slower, but allows centralized debugging/modification for the time
   * being */
  deallocMethodContext(methodContextOOP);
  /*methodContext->sender = (OOP)fakeList;
  fakeList = methodContextOOP; */

  return (allocOOP(newContext));
}



#ifdef ACCESSOR_DEBUGGING
/*
 *	static Boolean isBlockContext(contextOOP)
 *
 * Description
 *
 *	Returns true if "contextOOP" is a block context.
 *
 * Inputs
 *
 *	contextOOP: 
 *		an OOP for a context that is to be checked.
 *
 * Outputs
 *
 *	True if it's a block context, false otherwise.
 */
static Boolean isBlockContext(contextOOP)
OOP	contextOOP;
{
  return (oopClass(contextOOP) == blockContextClass);
}
#endif /* ACCESSOR_DEBUGGING */


/*
 * on entry to this routine, the stack should have the receiver and the
 * arguments pushed on the stack.  We need to get a new context,
 * setup things like the IP, SP, and Temporary pointers, and then
 * return.   Note that this routine DOES NOT invoke the interpreter; it merely
 * sets up a new context so that calling (or, more typically, returning to) the
 * interpreter will operate properly.  This kind of sending is for normal
 * messages only.  Things like sending a "value" message to a block context are
 * handled by primitives which do similar things, but they use information from
 * the block and method contexts that we don't have available (or need) here.
 */

void sendMessage(sendSelector, sendArgs, sendToSuper)
OOP	sendSelector;
int	sendArgs;
Boolean	sendToSuper;
{
  OOP		methodOOP, receiver, methodClass, receiverClass,
		argsArray, newContextOOP;
  MethodContext thisContext, newContext;
  MethodHeader	header;
  int		i, numTemps;
  long		hashIndex;

  if (!sendToSuper) {
    receiver = getStackReceiver(sendArgs);
    if (isInt(receiver)) {
      receiverClass = integerClass;
    } else {
      receiverClass = oopClass(receiver);
    }
  } else {
    methodClass = getMethodClass(thisMethod);
    receiverClass = superClass(methodClass);
    receiver = self;
  }

  /* hash the selector and the class of the receiver together using XOR.
   * Since both are pointers to long word aligned quantities, shift over
   * by 2 bits to remove the useless low order zeros.  Also, since
   * they are addresses in the oopTable, and since oopTable entries are
   * 8 bytes long, we can profitably shift over 3 bits */
/*  hashIndex = ((long)sendSelector ^ (long)receiverClass) >> 4; */
  hashIndex = ((long)sendSelector ^ (long)receiverClass) >> 3;
  hashIndex &= (METHOD_CACHE_SIZE - 1);


  if (methodCacheSelectors[hashIndex] == sendSelector
      && methodCacheClasses[hashIndex] == receiverClass) {
    /* :-) CACHE HIT!!! (-: */
    methodOOP = methodCacheMethods[hashIndex];
    methodClass = methodCacheMethodClasses[hashIndex];
    cacheHits++;
  } else {
    /* :-( cache miss )-: */
    methodOOP = findMethod(receiverClass, sendSelector, &methodClass);
    if (isNil(methodOOP)) {
      argsArray = arrayNew(sendArgs);
      for (i = 0; i < sendArgs; i++) {
	arrayAtPut(argsArray, i+1, stackAt(sendArgs-i-1));
      }
      popNOOPs(sendArgs);
      pushOOP(messageNewArgs(sendSelector, argsArray));
      sendMessage(doesNotUnderstandColonSymbol, 1, false);
      return;
    }
    methodCacheSelectors[hashIndex] = sendSelector;
    methodCacheClasses[hashIndex] = receiverClass;
    methodCacheMethods[hashIndex] = methodOOP;
    methodCacheMethodClasses[hashIndex] = methodClass;
    collide[hashIndex]++;
    cacheMisses++;
  }

  header = getMethodHeader(methodOOP);
  if (header.numArgs != sendArgs) {
    errorf("invalid number of arguments %d, expecting %d", sendArgs,
	   header.numArgs);
    return;
  }

  if (header.headerFlag != 0) {
    switch (header.headerFlag) {
    case 1:			/* return self */
      if (sendArgs != 0) {
	errorf("method returns primitive self, but has args!!!");
	return;
      }

      /* self is already on the stack...so we leave it */
      return;

    case 2:			/* return instance variable */
      if (sendArgs != 0) {
	errorf("method returns primitive instance variable, but has args!!!");
	return;
      }
      /* replace receiver with the returned instance variable */
      setStackTop(receiverVariable(receiver, header.numTemps));
      return;

    case 3:			/* send primitive */
      if (!executePrimitiveOperation(header.primitiveIndex, sendArgs,
				     methodOOP)) {
	return;
      }
      /* primitive failed.  Invoke the normal method */
      break;
    }
  }

  if (!isNil(thisContextOOP)) {
    thisContext = (MethodContext)oopToObj(thisContextOOP);
    /* save old context information */
    thisContext->ipOffset = fromInt(relativeByteIndex(ip, thisMethod));
    /* leave sp pointing to receiver, which is replaced on return with value*/
    thisContext->spOffset = fromInt(sp - sendArgs - thisContext->contextStack);
  }

  /* prepare the new state */
  newContextOOP = allocMethodContext();
  newContext = (MethodContext)oopToObj(newContextOOP);
/* dprintf("{{{{ sender for %8x is %8x (send)\n", newContext, thisContextOOP); */
  newContext->sender = thisContextOOP;
  maybeMoveOOP(methodOOP);
  newContext->method = methodOOP;
  maybeMoveOOP(methodClass);
  newContext->methodClass = methodClass;
  newContext->hasBlock = nilOOP;	/* becomes non-nil when a block is created */

  /* copy self and sendArgs arguments into new context */
  maybeMoveOOP(sendSelector);
  newContext->selector = sendSelector;
  maybeMoveOOP(receiver);
  newContext->receiver = receiver;
  memcpy(newContext->contextStack, &sp[-sendArgs+1], (sendArgs) * sizeof(OOP));
  for (i = 0; i < sendArgs; i++) {
    maybeMoveOOP(newContext->contextStack[i]);
  }

  numTemps = header.numTemps;
  nilFill(&newContext->contextStack[sendArgs], numTemps);

  sp = &newContext->contextStack[sendArgs + numTemps - 1];
				/* 1 before the actual start of stack */

  thisMethod = methodOOP;
  thisContextOOP = newContextOOP;
  
  temporaries = newContext->contextStack;
  self = newContext->receiver;
  ip = getMethodByteCodes(thisMethod);
  /* ### fix getmethodbytecodes to check for actual byte codes in method */
}


/*
 *	static void returnWithValue(returnedValue, returnContext)
 *
 * Description
 *
 *	Return from context "returnContext" with value "returnedValue".  Note
 *	that this context may not be the current context.  If returnContext
 *	is not a block context, then we need to carefully unwind the
 *	"method call stack".  Here carefully means that we examine each
 *	context.  If it's a block context then we cannot deallocate it.  If
 *	it's a method context, and if during its execution it did not create a
 *	block context, then we can deallocate it.  Otherwise, we need to mark
 *	it as returned (set the sender to nilOOP) and continue up the call
 *	chain until we reach returnContext.
 *
 * Inputs
 *
 *	returnedValue: 
 *		Value to be put on the stack in the sender's context.
 *	returnContext: 
 *		The context to return from, an OOP.  This may not be the
 *		current context.
 *
 */
static void returnWithValue(returnedValue, returnContext)
OOP	returnedValue, returnContext;
{
  MethodContext	thisContext, methodContext;
  OOP		oldContextOOP, methodContextOOP;

  while (thisContextOOP != returnContext) {
    thisContext = (MethodContext)oopToObj(thisContextOOP);
    if (isBlockContext(thisContextOOP)) {
      thisContextOOP = ((BlockContext)thisContext)->caller;
    } else {
      oldContextOOP = thisContextOOP;
      thisContextOOP = thisContext->sender; /* ### what if sender is nil? */
      if (isFake(oldContextOOP)) {
	deallocMethodContext(oldContextOOP);
      } else if (!isNil(thisContext->hasBlock)) {
	/* This context created a block.  Since we don't know who is holding
	   the block, we must presume that it is global.  Since any blocks
	   created by this method can reference arguments and temporaries
	   of this method, we must keep the method context around, but mark
	   it as non-returnable so that attempts to return from it to an
	   undefined place will lose. */
/* dprintf("{{{{ sender for %8x is nilOOP (returnWValue)\n", thisContext); */
	thisContext->sender = nilOOP;
      }
    }
  }

  /* when we're here, we've deallocated any intervening contexts, and now
     we need to restore the state of the world as it was before we were called.
     Our caller has set the stack pointer to where we should place the
     return value, so all we need do is restore the interpreter's state and
     we're set. */
  /* ??? Geez, this feels clumsy.  We could have merged the "pop context"
     code below with the while loop above, using a do...while, but I wonder
     if, over the long haul, the code for popping the final context will
     be a special case and so will need separate code.  */
  oldContextOOP = thisContextOOP;
  thisContext = (MethodContext)oopToObj(thisContextOOP);
  thisContextOOP = thisContext->sender;

  if (isFake(oldContextOOP)) {
    deallocMethodContext(oldContextOOP);
  } else if (!isBlockContext(oldContextOOP)) {
    if (!isNil(thisContext->hasBlock)) {
      /* mark it so block can't return from method */
/* dprintf("{{{{ sender for %8x is nilOOP (returnWValue)\n", thisContext); */
      thisContext->sender = nilOOP;
    }
  }

  /* ### this can be removed when all the maybeMoveOOPs go -- all it does is
   * slow things down
   */
  if (!isFake(thisContextOOP)) {
    maybeMoveOOP(thisContextOOP);
  }
  
  thisContext = (MethodContext)oopToObj(thisContextOOP);

  methodContextOOP = getMethodContext(thisContextOOP);
  if (methodContextOOP != thisContextOOP) { /* if we're a block */
    maybeMoveOOP(methodContextOOP); /* validate containing method */
  }
  methodContext = (MethodContext)oopToObj(methodContextOOP);
  thisMethod = methodContext->method;
  maybeMoveOOP(thisMethod);
  ip = toInt(thisContext->ipOffset) + getMethodByteCodes(thisMethod);
  sp = thisContext->contextStack + toInt(thisContext->spOffset);

  /* temporaries and self live in the method, not in the block */
  temporaries = methodContext->contextStack;
  self = methodContext->receiver;
  maybeMoveOOP(self);

  maybeMoveOOP(returnedValue);

  setStackTop(returnedValue);
}



/***********************************************************************
 *
 *	Simple Method Object Accessors
 *
 ***********************************************************************/

#ifdef ACCESSOR_DEBUGGING

static OOP receiverVariable(receiver, index)
OOP	receiver;
int	index;
{
  if (!inBounds(receiver, index)) {
    errorf("Index out of bounds %d", index);
  }
  return (oopToObj(receiver)->data[index]);
}

static OOP getStackReceiver(numArgs)
int	numArgs;
{
  /* this is correct: numArgs == 0 means that there's just the receiver
     on the stack, at 0.  numArgs = 1 means that at location 0 is the arg,
     location 1 is the receiver. */
  return (stackAt(numArgs));
}

static OOP methodTemporary(index)
int	index;
{
  return (temporaries[index]);
}

static OOP methodLiteral(methodOOP, index)
OOP	methodOOP;
int	index;
{
  Method	method = (Method)oopToObj(methodOOP);

  /* ### check for in bounds with index */
  return (method->literals[index]);
}

static OOP methodVariable(methodOOP, index)
OOP	methodOOP;
int	index;
{
  Method	method = (Method)oopToObj(methodOOP);

  return (associationValue(method->literals[index]));
}

static Byte *getMethodByteCodes(methodOOP)
OOP	methodOOP;
{
  Method	method;

  if (isNil(methodOOP)) {
    return (nil);
  }

  method = (Method)oopToObj(methodOOP);

  /* skip the header and the number of literals to find the start of the
     byte codes */
  return ((Byte *)&method->literals[method->header.numLiterals]);
}

static MethodHeader getMethodHeader(methodOOP)
OOP	methodOOP;
{
  Method	method;

  method = (Method)oopToObj(methodOOP);
  return (method->header);
}

/*
 *	static OOP getMethodClass(method)
 *
 * Description
 *
 *	This is called when a method contains a send to "super".  The compiler
 *	is supposed to notice a send to "super", and make sure that the last
 *	literal of a method is an association between the symbol for the
 *	class of the method and the class of the method itself.  This routine
 *	returns the class of the method itself using this association.
 *
 * Inputs
 *
 *	method: An OOP that represents a method.
 *
 * Outputs
 *
 *	An OOP for the class of the method.
 */
static OOP getMethodClass(methodOOP)
OOP	methodOOP;
{
  Method	method;
  OOP		associationOOP;

  method = (Method)oopToObj(methodOOP);
  associationOOP = method->literals[method->header.numLiterals - 1];
  return (associationValue(associationOOP));
}

/***********************************************************************
 *
 *	Simple Method Object Storing routines.
 *
 ***********************************************************************/


static void storeReceiverVariable(receiver, index, oop)
OOP	receiver, oop;
int	index;
{
  if (!inBounds(receiver, index)) {
    errorf("Index out of bounds %d", index);
  }
  prepareToStore(receiver, oop);
  oopToObj(receiver)->data[index] = oop;
}

static void storeMethodTemporary(index, oop)
int	index;
OOP	oop;
{
  prepareToStore(thisContextOOP, oop);
  temporaries[index] = oop;
}

static void storeMethodVariable(methodOOP, index, oop)
OOP	methodOOP, oop;
int	index;
{
  Method	method = (Method)oopToObj(methodOOP);

  setAssociationValue(method->literals[index], oop);
}

static void storeMethodLiteral(methodOOP, index, oop)
OOP	methodOOP, oop;
int	index;
{
  Method	method = (Method)oopToObj(methodOOP);

  prepareToStore(methodOOP, oop);
  method->literals[index] = oop;
}

static Boolean inBounds(oop, index)
OOP	oop;
int	index;
{
  Object	obj = oopToObj(oop);

  return (index >= 0 && index < numOOPs(obj));
}
#endif /* ACCESSOR_DEBUGGING */

MethodHeader getMethodHeaderExt(methodOOP)
OOP	methodOOP;
{
  return (getMethodHeader(methodOOP));
}

void storeMethodLiteralExt(methodOOP, index, oop)
OOP	methodOOP, oop;
int	index;
{
  storeMethodLiteral(methodOOP, index, oop);
}

/*
 *	void storeMethodLiteralNoGC(methodOOP, index, oop)
 *
 * Description
 *
 *	This routine exists primarily for the binary save/restore code.  Rather
 *	than adding a test of the garbage collector's state to a very busy
 *	routine, it's better to create a a clone that doesn't do the prepare to
 *	store.  If this routine were more complicated, it would make sense to
 *	do the test in storeMethodLiteral (ala instVarAtPut).
 *
 * Inputs
 *
 *	methodOOP: 
 *		A method OOP to set the literal of.
 *	index : the zero-based index of the literal to set
 *	oop   : the OOP to store into the method's literal table.
 *
 */
void storeMethodLiteralNoGC(methodOOP, index, oop)
OOP	methodOOP, oop;
int	index;
{
  Method	method = (Method)oopToObj(methodOOP);

  method->literals[index] = oop;
}

/*
 *	OOP methodLiteralExt(methodOOP, index)
 *
 * Description
 *
 *	External accessor routine.  Returns a literal from the given method.
 *
 * Inputs
 *
 *	methodOOP: 
 *		A CompiledMethod OOP.
 *	index : An index into the literals of the method.
 *
 * Outputs
 *
 *	The literal at index in the CompiledMethod.
 */
OOP methodLiteralExt(methodOOP, index)
OOP	methodOOP;
int	index;
{
  return (methodLiteral(methodOOP, index));
}

/*
 *	Boolean equal(oop1, oop2)
 *
 * Description
 *
 *	Internal definition of equality.  Returns true if "oop1" and "oop2" are
 *	the same object, false if they are not, and false and an error if they
 *	are not the same and not both Symbols.
 *
 * Inputs
 *
 *	oop1  : An OOP to be compared, typically a Symbol.
 *	oop2  : An OOP to be compared, typically a Symbol.
 *
 * Outputs
 *
 *	True if the two objects are the same object, false if not, and an error
 *	message if they are not the same and not both symbols.
 */
Boolean equal(oop1, oop2)
OOP	oop1, oop2;
{
  if (oop1 == oop2) {
    /* no brain case (ha ha ha) */
    return (true);
  }

  if (isClass(oop1, symbolClass) && isClass(oop2, symbolClass)) {
    return (false);
  }

  errorf("Internal #= called with invalid object types\n");
  return (false);
}

/*
 *	long hash(oop)
 *
 * Description
 *
 *	Internal hash function.  Currently defined only for symbols, but may be
 *	extended as needed for other objects.  The definition of the hash
 *	function used here must be the same as that defined in Smalltalk
 *	methods.
 *
 * Inputs
 *
 *	oop   : An OOP to be hashed.
 *
 * Outputs
 *
 *	Hash value of the OOP, or 0 and an error message if the OOP does not
 *	have a defined has value (that this routine knows how to compute).
 */
long hash(oop)
OOP	oop;
{
  if (!isInt(oop) && oopClass(oop) == symbolClass) {
    return (oopIndex(oop));
  }

  errorf("Internal #hash called with invalid object type\n");
  return (0);
}

#define intBinOp(operator) \
    oop2 = popOOP();				\
    oop1 = popOOP();				\
    if (isInt(oop1) && isInt(oop2)) {		\
      arg1 = toInt(oop1);			\
      arg2 = toInt(oop2);			\
						\
      /* could be faster without converting */	\
      pushInt(arg1 operator arg2);		\
      return (false);				\
    }						\
    unPop(2);					\
    return (true)

#define boolBinOp(operator)			\
    oop2 = popOOP();				\
    oop1 = popOOP();				\
    if (isInt(oop1) && isInt(oop2)) {		\
      arg1 = toInt(oop1);			\
      arg2 = toInt(oop2);			\
						\
      /* could be faster without converting */	\
      pushBoolean(arg1 operator arg2);		\
      return (false);				\
    }						\
    unPop(2);					\
    return (true)

/*
 *	static Boolean executePrimitiveOperation(primitive, numArgs, methodOOP)
 *
 * Description
 *
 *	This routine provides the definitions of all of the primitive methods
 *	in the GNU Smalltalk system.  It normally removes the arguments to the
 *	primitive methods from the stack, but if the primitive fails, the
 *	arguments are put back onto the stack and this routine returns false,
 *	indicating failure to invoke the primitive.
 *
 * Inputs
 *
 *	primitive: 
 *		A C int that indicates the number of the primitive to invoke.
 *		Must be > 0.
 *	numArgs: 
 *		The number of arguments that the primitive has.
 *	methodOOP: 
 *		The OOP for the currently executing method.  This allows
 *		primitives to poke around in the method itself, to get at
 *		pieces that they need.  Normally, this is only used by the C
 *		callout routine to get at the compiled-in descriptor for the
 *		called C function.
 *
 * Outputs
 *
 *	True if the execution of the primitive operation succeeded, false if it
 *	failed for some reason.
 */
static Boolean executePrimitiveOperation(primitive, numArgs, methodOOP)
int	primitive, numArgs;
OOP	methodOOP;
{
  Boolean	failed, atEof, *boolAddr;
  OOP		oop, oop1, oop2, oop3, oop4, oopVec[4], classOOP, fileOOP,
		blockContextOOP, stringOOP;
  long		arg1, arg2, arg3, arg4;
  double	farg1, farg2, fdummy;
  int		i, ch;
  BlockContext	blockContext;
  Byte		*fileName, *fileMode, *realFileName;
  FILE		*file;
  FileStream	fileStream;
  Semaphore	sem;
  CObject	cObject;
  CType		cType;
#ifdef old_code /* Sat Jan 19 14:40:09 1991 */
/**/#if !defined(USG)
/**/  struct timeval tv;
/**/#else
/**/  time_t tv;
/**/#endif
#endif /* old_code Sat Jan 19 14:40:09 1991 */
  struct stat	statBuf;
#ifdef preserved /* Sun Jul 28 14:36:02 1991 */
/**/#ifdef LOCAL_REGS
/**/  register OOP	*sp;
/**/#endif /* LOCAL_REGS */
#endif /* preserved Sun Jul 28 14:36:02 1991 */
#undef importSP
#undef exportSP
#define importSP()
#define exportSP()
  importSP();

#ifdef countingByteCodes
  primitives[primitive]++;
#endif

  failed = true;
  switch (primitive) {
  case 1: intBinOp(+);
  case 2: intBinOp(-);
  case 3: boolBinOp(<);
  case 4: boolBinOp(>);
  case 5: boolBinOp(<=);
  case 6: boolBinOp(>=);
  case 7: boolBinOp(==);
  case 8: boolBinOp(!=);
  case 9: intBinOp(*);
  case 10:
    oop2 = popOOP();
    oop1 = popOOP();
    if (isInt(oop1) && isInt(oop2)) {
      arg1 = toInt(oop1);
      arg2 = toInt(oop2);
      if (arg2 != 0 && (arg1 % arg2) == 0) { /* ### fix this when coercing goes in */
	/* Uncommented test (arg1 % arg2) to handle fractions davidd. */
	pushInt(arg1 / arg2);
	return (false);
      }
    }
    unPop(2);
    return (true);

  case 11:
    oop2 = popOOP();
    oop1 = popOOP();
    if (isInt(oop1) && isInt(oop2)) {
      arg1 = toInt(oop1);
      arg2 = toInt(oop2);
      if (arg2 != 0) {
	if ((arg1 ^ arg2) < 0) {
	  /* ??? help...is there a better way to do this? */
	  pushInt(arg1 - ((arg1 - (arg2-1)) / arg2) * arg2);
	  return (false);
	} else {
	  pushInt(arg1 % arg2);
	  return (false);
	}
      }
    }
    unPop(2);
    return (true);

  case 12:
    oop2 = popOOP();
    oop1 = popOOP();
    if (isInt(oop1) && isInt(oop2)) {
      arg1 = toInt(oop1);
      arg2 = toInt(oop2);
      if (arg2 != 0) {
	if ((arg1 ^ arg2) < 0) { /* differing signs => negative result */
	  pushInt((arg1 - (arg2-1)) / arg2);
	  return (false);
	} else {
	  pushInt(arg1 / arg2);
	  return (false);
	}
      }
    }
    unPop(2);
    return (true);

  case 13:
    oop2 = popOOP();
    oop1 = popOOP();
    if (isInt(oop1) && isInt(oop2)) {
      arg1 = toInt(oop1);
      arg2 = toInt(oop2);
      if (arg2 != 0) {
	pushInt(arg1 / arg2);
	return (false);
      }
    }
    unPop(2);
    return (true);

  case 14: intBinOp(&);
  case 15: intBinOp(|);
  case 16: intBinOp(^);
  case 17:
    oop2 = popOOP();
    oop1 = popOOP();
    if (isInt(oop1) && isInt(oop2)) {
      arg1 = toInt(oop1);
      arg2 = toInt(oop2);
      if (arg2 >= 0) {
	pushInt(arg1 << arg2);
      } else {
	pushInt(arg1 >> -arg2);
      }
      return (false);
    }
    unPop(2);
    return (true);

#ifdef bogus /* Sat Jan  5 13:46:47 1991 */
/**/  /*case 1: case  2: case  3: case  4:
/**/  case  5: case  6: case  7: case  8:
/**/  case  9: case 10: case 11: case 12:
/**/  case 13: case 14: case 15: case 16:
/**/  case 17: */
/**/    oop2 = popOOP();
/**/    oop1 = popOOP();
/**/    if (isInt(oop1) && isInt(oop2)) {
/**/      failed = false;
/**/      arg1 = toInt(oop1);
/**/      arg2 = toInt(oop2);
/**/      /* ??? make this faster by not pushing and popping */
/**/
/**/      switch(primitive) {
/**//*      case 1:	pushInt(arg1 + arg2);		break; */
/**//*      case 2:	pushInt(arg1 - arg2);		break; */
/**//*      case 3:	pushBoolean(arg1 < arg2);	break; */
/**//*      case 4:	pushBoolean(arg1 > arg2);	break; */
/**//*      case 5:	pushBoolean(arg1 <= arg2);	break; */
/**//*      case 6:	pushBoolean(arg1 >= arg2);	break; */
/**//*      case 7:	pushBoolean(arg1 == arg2);	break; */
/**//*      case 8:	pushBoolean(arg1 != arg2);	break; */
/**//*      case 9:	pushInt(arg1 * arg2);		break; /* ### overflow? */
/**/      case 10:
/**/	if (arg2 != 0 && (arg1 % arg2) == 0) { /* ### fix this when coercing goes in */
/**/	  /* Uncommented test (arg1 % arg2) to handle fractions davidd. */
/**/	  pushInt(arg1 / arg2);
/**/	} else {
/**/	  failed = true;
/**/	}
/**/	break;
/**/      case 11:
/**/	if (arg2 != 0) {
/**/	  if ((arg1 ^ arg2) < 0) {
/**/	    /* ??? help...is there a better way to do this? */
/**/	    pushInt(arg1 - ((arg1 - (arg2-1)) / arg2) * arg2);
/**/	  } else {
/**/	    pushInt(arg1 % arg2);
/**/	  }
/**/	} else {
/**/	  failed = true;
/**/	}
/**/	break;
/**/      case 12:
/**/	if (arg2 != 0) {
/**/	  if ((arg1 ^ arg2) < 0) { /* differing signs => negative result */
/**/	    pushInt((arg1 - (arg2-1)) / arg2);
/**/	  } else {
/**/	    pushInt(arg1 / arg2);
/**/	  }
/**/	} else {
/**/	  failed = true;
/**/	}
/**/	break;
/**/      case 13:
/**/	if (arg2 != 0) {
/**/	  pushInt(arg1 / arg2);
/**/	} else {
/**/	  failed = true;
/**/	}
/**/	break;
/**//*      case 14:	pushInt(arg1 & arg2);	  	break; */
/**//*      case 15:	pushInt(arg1 | arg2);		break; */
/**//*      case 16:	pushInt(arg1 ^ arg2);		break; */
/**/      case 17:
/**/	/* ??? check for overflow */
/**/	if (arg2 >= 0) {
/**/	  pushInt(arg1 << arg2);
/**/	} else {
/**/	  pushInt(arg1 >> -arg2);
/**/	}
/**/	break;
/**/      }
/**/    }
/**/
/**/    if (failed) {
/**/      unPop(2);
/**/    }
/**/    break;
#endif /* bogus Sat Jan  5 13:46:47 1991 */

  case 40:
    oop1 = popOOP();
    if (isInt(oop1)) {
      pushOOP(floatNew((double)toInt(oop1)));
      return (false);
    }
    unPop(1);
    return (true);

  case 41: case 42: case 43: case 44:
  case 45: case 46: case 47: case 48:
  case 49: case 50:
    oop2 = popOOP();
    oop1 = popOOP();
    if (isClass(oop1, floatClass) && isClass(oop2, floatClass)) {
      failed = false;
      farg1 = floatOOPValue(oop1);
      farg2 = floatOOPValue(oop2);
      switch (primitive) {
      case 41:	pushOOP(floatNew(farg1 + farg2));	break;
      case 42:	pushOOP(floatNew(farg1 - farg2));	break;
      case 43:	pushBoolean(farg1 < farg2); 		break;
      case 44:	pushBoolean(farg1 > farg2);		break;
      case 45:	pushBoolean(farg1 <= farg2);		break;
      case 46:	pushBoolean(farg1 >= farg2);		break;
      case 47:	pushBoolean(farg1 == farg2);		break;
      case 48:	pushBoolean(farg1 != farg2);		break;
      case 49:	pushOOP(floatNew(farg1 * farg2));	break;
      case 50:
	if (farg2 != 0.0) {
	  pushOOP(floatNew(farg1 / farg2));
	} else {
	  failed = true;
	}
	break;
      }
    }

    if (failed) {
      unPop(2);
    }
    break;

  case 51:			/* Float truncated */
    oop1 = popOOP();
    if (isClass(oop1, floatClass)) {
      pushInt(/* 0 + ?why?*/(long)floatOOPValue(oop1));
      return (false);
    }
    unPop(1);
    return (true);

  case 52:			/* Float fractionPart */
    oop1 = popOOP();
    if (isClass(oop1, floatClass)) {
      farg1 = floatOOPValue(oop1);
      if (farg1 < 0.0) {
	farg1 = -farg1;
      }
      pushOOP(floatNew(modf(farg1, &fdummy)));
      return (false);
    } 
    unPop(1);
    return (true);

  case 53:			/* Float exponent */
    oop1 = popOOP();
    if (isClass(oop1, floatClass)) {
      farg1 = floatOOPValue(oop1);
      if (farg1 == 0.0) {
	arg1 = 1;
      } else {
	frexp(floatOOPValue(oop1), (int *)&arg1);
      }
      pushInt(arg1-1);
      return (false);
    }
    unPop(1);
    return (true);

  case 54:			/* Float timesTwoPower: */
    oop2 = popOOP();
    oop1 = popOOP();
    if (isClass(oop1, floatClass) && isInt(oop2)) {
      farg1 = floatOOPValue(oop1);
      arg2 = toInt(oop2);
#ifdef SUNOS40
      pushOOP(floatNew(scalbn(farg1, arg2)));
#else
      pushOOP(floatNew(ldexp(farg1, arg2)));
#endif
      return (false);
    }
    unPop(2);
    return (true);

  case 60:			/* Object at:, Object basicAt: */
    oop2 = popOOP();
    oop1 = stackTop();
    if (isInt(oop2)) {
      arg2 = toInt(oop2);
      if (checkIndexableBoundsOf(oop1, arg2)) {
	setStackTop(indexOOP(oop1, arg2));
	return (false);
      }
    }
    unPop(1);
    return (true);

  case 61:			/* Object at:put:, Object basicAt:put: */
    oop3 = popOOP();
    oop2 = popOOP();
    oop1 = stackTop();
    if (isInt(oop2)) {
      arg2 = toInt(oop2);
      if (checkIndexableBoundsOf(oop1, arg2)) {
	if (indexOOPPut(oop1, arg2, oop3)) {
	  setStackTop(oop3);
	  return (false);
	}
      }
    }

    unPop(2);
    return (true);

  case 62:			/* Object basicSize; Object size; String size;
				   ArrayedCollection size */
    oop1 = popOOP();
    pushInt(numIndexableFields(oop1));
    return (false);

  case 63:			/* String at:; String basicAt: */
    oop2 = popOOP();
    oop1 = stackTop();
    if (isInt(oop2)) {
      arg2 = toInt(oop2);
      if (checkIndexableBoundsOf(oop1, arg2)) {
	setStackTop(indexStringOOP(oop1, arg2));
	return (false);
      }
    }

    unPop(1);
    return (true);

  case 64:			/* String basicAt:put:; String at:put: */
    oop3 = popOOP();
    oop2 = popOOP();
    oop1 = stackTop();
    if (isInt(oop2) && isClass(oop3, charClass)) {
      arg2 = toInt(oop2);
      if (checkIndexableBoundsOf(oop1, arg2)) {
	indexStringOOPPut(oop1, arg2, oop3);
	setStackTop(oop3);
	return (false);
      }
    }

    unPop(2);
    return (true);

  case 68:			/* CompiledMethod objectAt: */
    oop2 = popOOP();
    oop1 = stackTop();
    if (isClass(oop1, compiledMethodClass) && isInt(oop2)) {
      arg2 = toInt(oop2);
      if (validMethodIndex(oop1, arg2)) {
	setStackTop(compiledMethodAt(oop1, arg2));
	return (false);
      }
    }

    unPop(1);
    return (true);

  case 69:			/* CompiledMethod objectAt:put: */
    oop3 = popOOP();
    oop2 = popOOP();
    oop1 = stackTop();
    if (isClass(oop1, compiledMethodClass) && isInt(oop2)) {
      arg2 = toInt(oop2);
      if (validMethodIndex(oop1, arg2)) {
	compiledMethodAtPut(oop1, arg2, oop3);
	return (false);
      }
    }

    unPop(2);
    return (true);

  case 70:			/* Behavior basicNew; Behavior new;
				   Interval class new */
    oop1 = stackTop();
    if (isOOP(oop1)) {
      if (!isIndexable(oop1)) {
	setStackTop(allocOOP(instantiate(oop1)));
	return (false);
      }
    }
    return (true);

  case 71:			/* Behavior new:; Behavior basicNew: */
    oop2 = popOOP();
    oop1 = stackTop();
    if (isOOP(oop1) && isInt(oop2)) {
      if (isIndexable(oop1)) {
	arg2 = toInt(oop2);
	setStackTop(instantiateOOPWith(oop1, arg2));
	return (false);
      }
    }

    unPop(1);
    return (true);

  case 72:			/* Object become: */
    oop2 = popOOP();
    oop1 = stackTop();
    if (isOOP(oop1) && isOOP(oop2)) {
      swapObjects(oop1, oop2);
      setStackTop(oop1);	/* probably not necessary */
      return (false);
    }
    unPop(1);
    return (true);

  case 73:			/* Object instVarAt: */
    oop2 = popOOP();
    oop1 = stackTop();
    if (isInt(oop2)) {
      arg2 = toInt(oop2);
      if (checkBoundsOf(oop1, arg2)) {
	setStackTop(instVarAt(oop1, arg2));
	return (false);
      }
    }
    unPop(1);
    return (true);

  case 74:			/* Object instVarAt:put: */
    oop3 = popOOP();
    oop2 = popOOP();
    oop1 = stackTop();
    if (isInt(oop2)) {
      arg2 = toInt(oop2);
      if (checkBoundsOf(oop1, arg2)) {
	if (instVarAtPut(oop1, arg2, oop3)) {
	  return (false);
	}
      }
    }
    unPop(2);
    return (true);

  case 75:			/* Object asOop; Object hash; Symbol hash */
    oop1 = popOOP();
    if (isOOP(oop1)) {
      pushInt(oopIndex(oop1));
      return (false);
    }
    unPop(1);
    return (true);

  case 76:			/* SmallInteger asObject;
				   SmallInteger asObjectNoFail */
    oop1 = stackTop();
    if (isInt(oop1)) {		/* redundant? */
      arg1 = toInt(oop1);
      if (oopIndexValid(arg1)) {
	setStackTop(oopAt(arg1-1));
	return (false);
      }
    }

    return (true);

  case 77:			/* Behavior someInstance */
    oop1 = stackTop(); 
    for (oop = oopTable; oop < &oopTable[TOTAL_OOP_TABLE_SLOTS]; oop++) {
      if (oopValid(oop) && oop1 == oopClass(oop)) {
	setStackTop(oop);
	return (false);
      }
    }
    return (true);

  case 78:			/* Object nextInstance */
    oop1 = stackTop();
    if (!isInt(oop1)) {
      classOOP = oopClass(oop1);
      for (oop = oop1 + 1; oop < &oopTable[TOTAL_OOP_TABLE_SLOTS]; oop++) {
	if (oopValid(oop) && classOOP == oopClass(oop)) {
	  setStackTop(oop);
	  return (false);
	}
      }
    }
    return (true);

  case 79:			/* CompiledMethod class newMethod:header: */
    oop3 = popOOP();
    oop2 = popOOP();
    oop1 = stackTop();
    if (isInt(oop3) && isInt(oop2)) {
      arg3 = toInt(oop3);
      arg2 = toInt(oop2);
      setStackTop(methodNewOOP(arg2, arg3));
      return (false);
    }
    unPop(2);
    return (true);

  case 80:			/* ContextPart blockCopy: */
    oop2 = popOOP();
    oop1 = stackTop();
    if (isInt(oop2)) {
      arg2 = toInt(oop2);
      blockContextOOP = allocBlockContext();
      blockContext = (BlockContext)oopToObj(blockContextOOP);
 if (isFake(getMethodContext(oop1))) {
   printf("############## Fake in block copy!\n");
 }
      blockContext->home = getMethodContext(oop1);
      maybeMoveOOP(blockContext->home);
      blockContext->numArgs = oop2;
      methodHasBlockContext(blockContext->home); /* prob. not necessary */
      /* the +2 here is to skip over the jump byte codes that follow the
	 invocation of blockCopy, so that the ipIndex points to the first
	 byte code of the block. */
      blockContext->initialIP = fromInt(relativeByteIndex(ip, thisMethod) + 2);
      if (oopClass(blockContext->home) != methodContextClass) {
	errorf("Block's home is not a MethodContext!!!\n");
      }
      setStackTop(blockContextOOP);
      return (false);
    }
    unPop(1);
    return (true);

  case 81:			/* BlockContext value
				   BlockContext value:
				   BlockContext value:value:
				   BlockContext value:value:value: */
    exportSP();
    sendBlockValue(numArgs);	/* ### check number of args for agreement! */
    importSP();
    return (false);

  case 82:			/* BlockContext valueWithArguments: */
    oop2 = popOOP();
    oop1 = stackTop();
    if (isClass(oop2, arrayClass)) {
      numArgs = numIndexableFields(oop2);
      for (i = 1; i <= numArgs; i++) {
	pushOOP(arrayAt(oop2, i));
      }
      exportSP();
      sendBlockValue(numArgs);
      importSP();
      return (false);
    }
    unPop(1);
    return (true);

  case 83:			/* Object perform:
				   Object perform:with:
				   Object perform:with:with:
				   Object perform:with:with:with: */
    /* pop off the arguments (if any) */
    for (i = 0; i < numArgs - 1; i++) {
      oopVec[i] = popOOP();
    }
    oop1 = popOOP();		/* the selector */
    /* push the args back onto the stack */
    for (; --i >= 0; ) {
      pushOOP(oopVec[i]);
    }
    exportSP();
    sendMessage(oop1, numArgs - 1, false);
    importSP();
    return (false);

  case 84:			/* Object perform:withArguments: */
    oop2 = popOOP();
    oop1 = popOOP();
    if (isClass(oop2, arrayClass)) {
      numArgs = numIndexableFields(oop2);
      for (i = 1; i <= numArgs; i++) {
	pushOOP(arrayAt(oop2, i));
      }
      exportSP();
      sendMessage(oop1, numArgs, false);
      importSP();
      return (false);
    }
    unPop(2);
    return (true);

  case 85:			/* Semaphore signal */
    oop1 = stackTop();
    if (isClass(oop1, semaphoreClass)) {
      syncSignal(oop1);
      return (false);
    }
    return (true);

  case 86:			/* Semaphore wait */
    oop1 = stackTop();
    if (isClass(oop1, semaphoreClass)) { /* necessary? */
      sem = (Semaphore)oopToObj(oop1);
      if (toInt(sem->signals) > 0) {	/* no waiting here */
	sem->signals = decrInt(sem->signals);
      } else {			/* have to suspend */
	addLastLink(oop1, getActiveProcess());
	suspendActiveProcess();
      }
      return (false);
    }
    return (true);

  case 87:			/* Process resume */
    resumeProcess(stackTop());
    return (false);

  case 88:			/* Process suspend */
    oop1 = stackTop();
    if (oop1 == getActiveProcess()) {
      setStackTop(nilOOP);		/* this is our return value */
      suspendActiveProcess();
      return (false);
    }
    return (true);


  case 98:			/* Time class secondClock
				 *  -- note: this primitive has different
				 *     semantics from those defined in the
				 *     book.  This primitive returns the
				 *     seconds since Jan 1, 1970 00:00:00
				 *     instead of Jan 1,1901.
				 */
    popOOP();
    pushInt(getTime());
#ifdef old_code /* Sat Jan 19 10:25:40 1991 */
/**/#if !defined(USG)
/**/    gettimeofday(&tv, nil);
/**/    pushInt(tv.tv_sec);
/**/#else
/**/    (void) time(&tv);
/**/    pushInt(tv);
/**/#endif
#endif /* old_code Sat Jan 19 10:25:40 1991 */
    return (false);

  case 99:			/* Time class millisecondClock
				 * -- Note: the semantics of this primitive
				 *    are different than those described in
				 *    the book.  This primitive returns the
				 *    number of milliseconds since midnight
				 *    today. */
    popOOP();
    pushInt(getMilliTime() % (24*60*60*1000));
#ifdef old_code /* Sat Jan 19 10:26:01 1991 */
/**/#if !defined(USG)
/**/    gettimeofday(&tv, nil);
/**/    pushInt((tv.tv_sec % (24*60*60)) * 1000 + tv.tv_usec / 1000);
/**/#else
/**/    (void) time(&tv);
/**/    pushInt((tv % (24*60*60)) * 1000);
/**/#endif
#endif /* old_code Sat Jan 19 10:26:01 1991 */
    return (false);

  case 100:			/* Processor signal: semaphore
				 *           atMilliseconds: deltaMilliseconds
			         */
    oop2 = popOOP();
    oop1 = popOOP();
    if (isInt(oop2)) {
      arg2 = toInt(oop2);
      timeoutSem = oop1;
      signalAfter(arg2, timeoutHandler);
      return (false);
    }

    unPop(2);
    return (true);

  case 105:			/* ByteArray primReplaceFrom:to:with:startingAt
				 * ByteArray replaceFrom:to:withString:startingAt:
				 * String replaceFrom:to:withByteArray:startingAt:
				 * String primReplaceFrom:to:with:startingAt:*/
    {
      OOP	srcIndexOOP, srcOOP, dstEndIndexOOP, dstStartIndexOOP, dstOOP;
      int	dstEndIndex, dstStartIndex, srcIndex, dstLen, srcLen,
      		dstRangeLen;
      Byte	*dstBase, *srcBase;

      srcIndexOOP = popOOP();
      srcOOP = popOOP();
      dstEndIndexOOP = popOOP();
      dstStartIndexOOP = popOOP();
      if (isInt(srcIndexOOP) && isInt(dstStartIndexOOP)
	  && isInt(dstEndIndexOOP)) {
	if (isAKindOf(oopClass(srcOOP), byteArrayClass)
	    || isAKindOf(oopClass(srcOOP), stringClass)) {
	  /* dstEnd is inclusive: (1 to: 1) has length 1 */
	  dstEndIndex = toInt(dstEndIndexOOP);
	  dstStartIndex = toInt(dstStartIndexOOP);
	  srcIndex = toInt(srcIndexOOP);
	  dstOOP = stackTop();
	  dstLen = numIndexableFields(dstOOP);
	  srcLen = numIndexableFields(srcOOP);
	  dstRangeLen = dstEndIndex - dstStartIndex + 1;
	  if ((dstRangeLen >= 0 && dstEndIndex <= dstLen
	       && dstStartIndex > 0)) {
	    if (dstRangeLen > 0) { /* don't do it unless somethings to copy */
	      if ((srcIndex <= srcLen) && (srcIndex > 0)
		  && (srcIndex + dstRangeLen - 1 <= srcLen)) {
		/* do the copy */
		dstBase = stringOOPChars(dstOOP);
		srcBase = stringOOPChars(srcOOP);
		memcpy(&dstBase[dstStartIndex-1], &srcBase[srcIndex-1],
		       dstRangeLen);
	      }
	    }
	    return (false);
	  }
	}
      }
	
      unPop(4);
      return (true);
    }

  case 110:			/* Object ==, Character = */
    oop2 = popOOP();
    oop1 = popOOP();
    pushBoolean(oop1 == oop2);
    return (false);

  case 111:			/* Object class */
    oop1 = popOOP();
    /* ??? is this called with ints? */
    if (isInt(oop1)) {
      pushOOP(integerClass);
    } else {
      pushOOP(oopClass(oop1));
    }
    return (false);

  case 113:			/* quitPrimitive */
    exit(0);
    break;			/* This does nothing :-) */

  case 117:			/* quitPrimitive: status */
    oop1 = stackTop();
    if (isInt(oop1)) {
      arg1 = toInt(oop1);
      exit(arg1);
    }
    return (true);

/* ------- GNU Smalltalk specific primitives begin here -------------------- */

  case 128:			/* Dictionary at: */
    oop2 = popOOP();
    oop1 = stackTop();
    setStackTop(dictionaryAt(oop1, oop2));
    return (false);

  case 129:			/* Dictionary at: put: */
    oop3 = popOOP();
    oop2 = popOOP();
    oop1 = stackTop();
    dictionaryAtPut(oop1, oop2, oop3);
    setStackTop(oop3);
    return (false);

  case 130:			/* doesNotUnderstand: message */
    oop2 = popOOP();
    oop1 = popOOP();
    printObject(oop1);
    printf(" did not understand selector '");
    printSymbol(messageSelector(oop2));
    printf("'\n\n");
    showBacktrace();
    stopExecuting(0);
    return (false);

  case 131:			/* error: message */
    oop2 = popOOP();		/* error string */
    oop1 = stackTop();		/* the receiver */
    printObject(oop1);
    printf(" error: ");
    printString(oop2);
    printf("\n\n");
    showBacktrace();
    stopExecuting(0);
    return (false);
    
  case 132:			/* Character class value: */
    oop2 = popOOP();
    oop1 = stackTop();
    if (isInt(oop2)) {
      arg2 = toInt(oop2);
      if (arg2 >= 0 && arg2 <= 255) {
	setStackTop(charOOPAt(arg2));
	return (false);
      }
    }
    unPop(1);
    return (true);

  case 133:			/* Character asciiValue */
    oop1 = popOOP();
    pushInt(charOOPValue(oop1));
    return (false);

  case 134:			/* Symbol class intern: aString */
    oop2 = popOOP();
    oop1 = stackTop();
    if (isClass(oop2, stringClass)) {
      setStackTop(internStringOOP(oop2));
      return (false);
    }
    unPop(1);
    return (true);

  case 135:			/* Dictionary new */
    setStackTop(dictionaryNew());
    return (false);

  case 136:			/* ByteMemory at: */
    oop2 = popOOP();
    oop1 = popOOP();
    if (isInt(oop2)) {
      arg2 = toInt(oop2);
      pushInt(*(Byte *)arg2);
      return (false);
    }
    unPop(2);
    return (true);
    
  case 137:			/* ByteMemory at:put: */
    oop3 = popOOP();
    oop2 = popOOP();
    if (isInt(oop2) && isInt(oop3)) {
      arg1 = toInt(oop2);
      arg2 = toInt(oop3);
      if (arg2 >= 0 && arg2 <= 255) {
	*(Byte *)arg1 = arg2;
	return (false);
      }
    }
    unPop(2);
    return (true);
    
  case 138:			/* Memory addressOfOOP: oop */
    oop2 = popOOP();
    oop1 = popOOP();
    if (!isInt(oop2)) {
      pushInt((long)oop2);
      return (false);
    }
    unPop(2);
    return (true);

  case 139:			/* Memory addressOf: oop */
    oop2 = popOOP();
    oop1 = popOOP();
    if (!isInt(oop2)) {
      pushInt((long)oopToObj(oop2));
      return (false);
    }
    unPop(2);
    return (true);

  case 140:			/* SystemDictionary backtrace */
    showBacktrace();
    return (false);

  case 141:			/* SystemDictionary getTraceFlag: anIndex */
    oop2 = popOOP();
    oop1 = popOOP();
    if (isInt(oop2)) {
      arg2 = toInt(oop2);
      boolAddr = boolAddrIndex(arg2);
      if (boolAddr != NULL) {
	oop1 = *boolAddr ? trueOOP : falseOOP;
	pushOOP(oop1);
	return (false);
      }
    }

    unPop(2);
    return (true);

  case 142:			/* SystemDictionary setTraceFlag: anIndex
				                    to: aBoolean */
    oop2 = popOOP();
    oop1 = popOOP();
    if (isInt(oop1)) {
      arg1 = toInt(oop1);
      boolAddr = boolAddrIndex(arg1);
      if (boolAddr != NULL) {
	*boolAddr = (oop2 == trueOOP) ? true : false;
	exceptFlag = true;
	return (false);
      }
    }
    
    unPop(2);
    return (true);

#ifdef old_code /* Thu Jun  6 15:06:41 1991 */
/**/  case 141:			/* SystemDictionary executionTrace: aBoolean */
/**/    oop1 = popOOP();
/**/    if (oop1 == trueOOP) {
/**/      executionTracing = true;
/**/    } else {
/**/      executionTracing = false;
/**/    }
/**/    exceptFlag = true;
/**/    return (false);
/**/
/**/  case 142:			/* SystemDictionary declarationTrace: aBoolean */
/**/    oop1 = popOOP();
/**/    if (oop1 == trueOOP) {
/**/      declareTracing = true;
/**/    } else {
/**/      declareTracing = false;
/**/    }
/**/    return (false);
/**/
#endif /* old_code Thu Jun  6 15:06:41 1991 */

  case 143:			/* ClassDescription comment: aString */
    oop2 = popOOP();
    oop1 = stackTop();
    setComment(oop1, oop2);
    return (false);

  case 144:			/* CObject class alloc: nBytes */
    oop2 = popOOP();
    oop1 = stackTop();
    if (isInt(oop2)) {
      arg2 = toInt(oop2);
      setStackTop(allocCObject(oop1, arg2));
      return (false);
    }
    unPop(1);
    return (true);

  case 145:			/* Memory (?) type: aType at: anAddress */
    oop3 = popOOP();
    oop2 = popOOP();
    oop1 = popOOP();
    if (isInt(oop3) && isInt(oop2)) {
      arg1 = toInt(oop2);
      arg2 = toInt(oop3);
/*      failed = false; */
      switch (arg1) {
      case 0:			/* char */
	/* may want to use Character instead? */
	pushOOP(charOOPAt(*(char *)arg2));
	return (false);
      case 1:			/* unsigned char */
	pushOOP(charOOPAt(*(unsigned char *)arg2));
	return (false);
      case 2:			/* short */
	pushInt(*(short *)arg2);
	return (false);
      case 3:			/* unsigned short */
	pushInt(*(unsigned short *)arg2);
	return (false);
      case 4:			/* int */
	pushInt(*(int *)arg2);
	return (false);
      case 5:			/* unsigned int */
	pushInt(*(unsigned int *)arg2);
	return (false);
      case 6:			/* float */
	pushOOP(floatNew(*(float *)arg2));
	return (false);
      case 7:			/* double */
	pushOOP(floatNew(*(double *)arg2));
	return (false);
      case 8:			/* string */
	if (*(char **)arg2) {
	  pushOOP(stringNew(*(char **)arg2));
	} else {
	  pushOOP(nilOOP);
	}
	return (false);
      }
    }

    unPop(3);
    return (true);


  case 146:			/* Memory (?) type: aType at: anAddress
				   put: aValue */
    oop4 = popOOP();
    oop3 = popOOP();
    oop2 = popOOP();
    /* don't pop the receiver */
    if (isInt(oop3) && isInt(oop2)) {
      arg1 = toInt(oop2);
      arg2 = toInt(oop3);
      switch (arg1) {
      case 0:			/* char */
      case 1:			/* unsigned char */
	/* may want to use Character instead? */
	if (isClass(oop4, charClass)) {
	  *(char *)arg2 = charOOPValue(oop4);
	  return (false);
	}
	break;
      case 2:			/* short */
      case 3:			/* unsigned short */
	if (isInt(oop4)) {
	  *(short *)arg2 = toInt(oop4);
	  return (false);
	}
	break;
      case 4:			/* int */
      case 5:			/* unsigned int */
	if (isInt(oop4)) {
	  *(int *)arg2 = toInt(oop4);
	  return (false);
	}
	break;
      case 6:			/* float */
	if (isClass(oop4, floatClass)) {
	  *(float *)arg2 = floatOOPValue(oop4);
	  return (false);
	}
	break;
      case 7:			/* double */
	if (isClass(oop4, floatClass)) {
	  *(double *)arg2 = floatOOPValue(oop4);
	  return (false);
	}
	break;
      case 8:			/* string */
	if (isClass(oop4, stringClass) || isClass(oop4, symbolClass)) {
	  (char *)arg2 = (char *)toCString(oop4);
	  return (false);
	}
	break;
      }
    }

    unPop(3);
    return (true);


  case 147:			/* <CObject> at: offset type: aType */
    oop3 = popOOP();
    oop2 = popOOP();
    oop1 = popOOP();

    if (isInt(oop2)) {
      arg2 = toInt(oop2);
      cObject = (CObject)oopToObj(oop1);
      arg2 += (unsigned long)cObject->addr;
      if (isInt(oop3)) {
	arg3 = toInt(oop3);
	switch (arg3) {		/* maybe switch to symbolic names sometime */
	case 0:			/* char */
	  pushOOP(charOOPAt(*(unsigned char *)arg2));
/*	  pushOOP(*(char *)(arg2)); */
	  return (false);
	case 1:			/* u_char */
	  pushOOP(charOOPAt(*(unsigned char *)arg2));
/* 	  pushInt(*(unsigned char *)(arg2)); */
	  return (false);
	case 2:			/* short */
	  pushInt(*(short *)(arg2));
	  return (false);
	case 3:			/* u_short */
	  pushInt(*(unsigned short *)(arg2));
	  return (false);
	case 4:			/* long */
	  pushInt(*(long *)(arg2));
	  return (false);
	case 5:			/* u_long */
	  pushInt(*(unsigned long *)(arg2));
	  return (false);
	case 6:			/* float */
	  pushOOP(floatNew(*(float *)(arg2)));
	  return (false);
	case 7:			/* double */
	  pushOOP(floatNew(*(double *)(arg2)));
	  return (false);
	case 8:			/* string */
	  if (*(char **)arg2) {
	    pushOOP(stringNew(*(char **)(arg2)));
	    return (false);
	  } else {
	    pushOOP(nilOOP);
	    return (false);
	  }
	case 9:			/* deref */
	  cType = (CType)oopToObj(cObject->type);
	  pushOOP(
	      cObjectNewTyped((*(unsigned long *)cObject->addr) + toInt(oop2),
			      cType->subType));
	  return (false);
	}
      } else {			/* just a subtype access */
	pushOOP(cObjectNewTyped(arg2, oop3));
	return (false);
      }
    }

    unPop(3);
    return (true);
    
  case 148:			/* <CObject> at: offset put: value
				   	     type: aType */
    oop4 = popOOP();
    oop3 = popOOP();
    oop2 = popOOP();
    oop1 = popOOP();

    if (isInt(oop2)) {
      arg2 = toInt(oop2);
      cObject = (CObject)oopToObj(oop1);
      arg2 += (unsigned long)cObject->addr;
      if (isInt(oop4)) {
	arg4 = toInt(oop4);
	switch (arg4) {		/* maybe switch to symbolic names sometime */
	case 0:			/* char */
	  if (isClass(oop3, charClass)) {
	    *(char *)arg2 = charOOPValue(oop3);
	    return (false);
	  }
	  break;
	case 1:			/* u_char */
	  if (isClass(oop3, charClass)) {
	    *(unsigned char *)arg2 = charOOPValue(oop3);
	    return (false);
	  }
	  break;
	case 2:			/* short */
	  if (isInt(oop3)) {
	    *(short *)arg2 = toInt(oop3);
	    return (false);
	  }
	  break;
	case 3:			/* u_short */
	  if (isInt(oop3)) {
	    *(unsigned short *)arg2 = toInt(oop3);
	    return (false);
	  }
	  break;
	case 4:			/* long */
	  if (isInt(oop3)) {
	    *(long *)arg2 = toInt(oop3);
	    return (false);
	  }
	  break;
	case 5:			/* u_long */
	  if (isInt(oop3)) {
	    *(unsigned long *)arg2 = toInt(oop3);
	    return (false);
	  }
	  break;
	case 6:			/* float */
	  if (isInt(oop3)) {
	    *(float *)arg2 = toInt(oop3);
	    return (false);
	  } else if (isClass(oop3, floatClass)) {
	    *(float *)arg2 = floatOOPValue(oop3);
	    return (false);
	  } 
	  break;
	case 7:			/* double */
	  if (isInt(oop3)) {
	    *(double *)arg2 = toInt(oop3);
	    return (false);
	  } else if (isClass(oop3, floatClass)) {
	    *(double *)arg2 = floatOOPValue(oop3);
	    return (false);
	  } 
	  break;
	case 8:			/* string */
	  if (oop3 == nilOOP) {
	    *(char **)arg2 = (char *)0;
	    return (false);
	  } else {
	    *(char **)arg2 = (char *)toCString(oop3);
	    return (false);
	  }
	case 9:			/* deref */
	  if (isAKindOf(oopClass(oop3), cObjectClass)) {
	    cObject = (CObject)oopToObj(oop3);
	    *(voidPtr *)arg2 = cObject->addr;
	    pushOOP(cObjectNewTyped((*(unsigned long *)cObject->addr)
				    + toInt(oop2), oop3));
	    return (false);
	  }
	  break;
	}
      } else {			/* just a subtype access */
	;			/* don't allow this right now! */
      }
    }

    unPop(4);
    return (true);
    
  case 149:			/* <CObject> type */
    oop1 = stackTop();
    
    if (isAKindOf(oopClass(oop1), cObjectClass)) {
      cObject = (CObject)oopToObj(oop1);
      setStackTop(cObject->type);
      return (false);
    }
    return (true);
    
  case 150:			/* methodsFor: category */
    setCompilationCategory(popOOP());
    setCompilationClass(stackTop());
    return (false);

  case 151:			/* methodsFor: category ifTrue: condition */
    oop2 = popOOP();
    oop1 = popOOP();
    if (oop2 == trueOOP) {
      setCompilationCategory(oop1);
      setCompilationClass(stackTop());
    } else {
      skipCompilation = true;
    }
    return (false);
      

  case 152:			/* ProcessorScheduler signal: aSemaphore
				                      onInterrupt: anInteger */
    oop2 = popOOP();
    oop1 = popOOP();
    if (isInt(oop2)) {
      arg2 = toInt(oop2);
      semIntVec[arg2] = oop1;
      signal(arg2, semIntHandler);
      /* should probably package up the old interrupt state here for return
       * so that it can be undone */
      return(false);
    }

    unPop(2);
    return(true);

  case 153:			/* SystemDictionary spaceGrowRate */
    setStackTop(floatNew(spaceGrowRate));
    return (false);

  case 154:			/* SystemDictionary spaceGrowRate: */
    oop1 = popOOP();
    if (isClass(oop1, floatClass)) {
      farg1 = floatOOPValue(oop1);
      /* ### want to do some bounds checking here */
      spaceGrowRate = farg1;
      return (false);
    }

    unPop(2);
    return (true);
    
  case 155:			/* SystemDictionary growThresholdPercent */
    setStackTop(floatNew(growThresholdPercent));
    return (false);

  case 156:			/* SystemDictionary growThresholdPercent: */
    oop1 = popOOP();
    if (isClass(oop1, floatClass)) {
      farg1 = floatOOPValue(oop1);
      if (farg1 >= 0.0 && farg1 <= 100.0) {
	growThresholdPercent = farg1;
	return (false);
      }
    }

    unPop(2);
    return (true);

  case 160:			/* exp */
  case 161:			/* ln */
    oop1 = stackTop();
    if (isClass(oop1, floatClass)) {
      farg1 = floatOOPValue(oop1);
      switch (primitive) {
      case 160: setStackTop(floatNew(exp(farg1)));	return (false);
      case 161: setStackTop(floatNew(log(farg1)));	return (false);
      }
    }
    return (true);

  /* case 162:			/* log: aNumber -- base aNumber log */
  /* case 163:			/* floorLog: radix -- integer floor operation */

  case 164:			/* raisedTo: aNumber -- receiver ** aNumber */
    oop2 = popOOP();
    oop1 = stackTop();
    if (isClass(oop1, floatClass) && isClass(oop2, floatClass)) {
      farg1 = floatOOPValue(oop1);
      farg2 = floatOOPValue(oop2);
      setStackTop(floatNew(pow(farg1, farg2)));
      return (false);
    }
    unPop(1);
    return (true);


  /* >>>>>> HOLE 165 <<<<<< */

  case 166:			/* sqrt -- floating result */
    oop1 = stackTop();
    if (isClass(oop1, floatClass)) {
      farg1 = floatOOPValue(oop1);
      setStackTop(floatNew(sqrt(farg1)));
      return (false);
    }
    unPop(1);
    return (true);

  /* >>>>>> 167: HOLE <<<<<< */

  case 168:			/* ceiling */
  case 169:			/* floor */
    oop1 = popOOP();
    if (isClass(oop1, floatClass)) {
      farg1 = floatOOPValue(oop1);
      switch (primitive) {
      case 168: pushInt((long)ceil(farg1));	return (false);
      case 169: pushInt((long)floor(farg1));	return (false);
#ifdef why_use_zero
      case 168: pushInt(0 + (long)ceil(farg1));	return (false);
      case 169: pushInt(0 + (long)floor(farg1));return (false);
#endif
      }
    }
    unPop(1);
    return (true);


  case 171:			/* truncateTo: aNumber the next multiple of aNumber nearest the receiver towards zero */
  case 172:			/* rounded -- integer nearest the receiver */
  case 173:			/* roundTo: aNumber -- multiple of aNumber nearest self */
  case 174:			/* degreesToRadians */
  case 175:			/* radiansToDegrees */


  case 176:			/* sin */
  case 177:			/* cos */
  case 178:			/* tan */
  case 179:			/* arcSin */
  case 180:			/* arcCos */
  case 181:			/* arcTan */
    oop1 = stackTop();
    if (isClass(oop1, floatClass)) {
      farg1 = floatOOPValue(oop1);
      switch (primitive) {
      case 176: setStackTop(floatNew(sin(farg1)));	return (false);
      case 177: setStackTop(floatNew(cos(farg1)));	return (false);
      case 178: setStackTop(floatNew(tan(farg1)));	return (false);
      case 179: setStackTop(floatNew(asin(farg1)));	return (false);
      case 180: setStackTop(floatNew(acos(farg1)));	return (false);
      case 181: setStackTop(floatNew(atan(farg1)));	return (false);
      }
    }
    return (true);

  case 230:			/* SystemDictionary monitor: aBoolean */
    oop1 = popOOP();
#ifdef USE_MONCONTROL    
    if (oop1 == trueOOP) {
      moncontrol(1);
    } else {
      moncontrol(0);
    }
#endif /* USE_MONCONTROL */
    return (false);


  case 231:			/* SystemDictionary byteCodeCounter */
    setStackTopInt(byteCodeCounter);
    return (false);

#ifdef old_code /* Thu Jun  6 15:32:40 1991 */
/**/  case 231:			/* SystemDictionary gcMessage: aBoolean */
/**/    oop2 = popOOP();
/**/    oop1 = popOOP();
/**/    pushBoolean(gcMessage);	/* returned value is old value */
/**/    gcMessage = (oop2 == trueOOP);
/**/    return (false);
#endif /* old_code Thu Jun  6 15:32:40 1991 */

  case 232:			/* SystemDictionary debug */
    debug();			/* used to allow dbx to stop based on
				 * Smalltalk execution paths.
				 */
    return (false);

#ifdef old_code /* Thu Jun  6 15:31:54 1991 */
/**/  case 233:			/* SystemDictionary verboseTrace: aBoolean */
/**/    oop1 = popOOP();
/**/    verboseExecTracing = (oop1 == trueOOP);
/**/    return (false);
#endif /* old_code Thu Jun  6 15:31:54 1991 */
    
  case 235:			/* Behavior compileString: aString */
    oop2 = popOOP();
    oop1 = popOOP();
    if (isClass(oop2, stringClass)) {
      exportSP();
      initLexer(true);
      pushSmalltalkString(oop2);
      setCompilationClass(oop1);
      yyparse();
      popStream(false);		/* don't close a String! */
      importSP();
      pushOOP(latestCompiledMethod);
      return (false);
    }
    unPop(2);
    return (true);

  case 236:			/* Behavior compileString: aString
				            ifError: aBlock */
    oop3 = popOOP();
    oop2 = popOOP();
    oop1 = popOOP();
    if (isClass(oop2, stringClass) && isClass(oop3, blockContextClass)) {
      Boolean	oldReportErrors = reportErrors;

      if (oldReportErrors) {
	/* only clear out these guys on first transition */
	firstErrorStr = firstErrorFile = NULL;
      }
      reportErrors = false;
      exportSP();
      initLexer(true);
      pushSmalltalkString(oop2);
      setCompilationClass(oop1);
      yyparse();
      popStream(false);		/* don't close a String! */
      importSP();
      if (firstErrorStr != NULL) {
	pushOOP(oop3);		/* block context */
	if (firstErrorFile != NULL) {
	  pushOOP(stringNew(firstErrorFile));
	  free(firstErrorFile);
	} else {
	  pushOOP(nil);
	}
	pushInt(firstErrorLine);
	pushOOP(stringNew(firstErrorStr));
	free(firstErrorStr);
	firstErrorStr = firstErrorFile = NULL;
	sendBlockValue(3);
      } else {
	pushOOP(latestCompiledMethod);
      }
      reportErrors = oldReportErrors;
      return (false);
    }
    unPop(3);
    return (true);




  case 240:			/* SysFile class openFile: filename for: read-or-write */
    return (true);

  case 241:			/* SysFile close */
    return (true);

  case 242:			/* SysFile next */
    return (true);

  case 243:			/* SysFile nextPut: aCharOrByte */
    return (true);

  case 244:			/* SysFile atEnd */
    return (true);

  case 245:			/* SysFile position: anInteger */
    return (true);

  case 246:			/* SysFile size */
    return (true);

  case 247:			/* FileStream fileIn */
    oop1 = stackTop();
    fileStream = (FileStream)oopToObj(oop1);
    fileOOP = fileStream->file;
    file = (FILE *)cObjectValue(fileOOP);
    fileName = toCString(fileStream->name);
    if (access(fileName, 4) == 0) {
      exportSP();
      initLexer(false);
      pushUNIXFile(file, fileName);
      yyparse();
      popStream(false);		/* we didn't open it, so we don't close it */
      importSP();
      return (false);
    }
    free(fileName);
    return (true);

  case 248:			/* FileStream fileInLine: lineNum
				 *            fileName: aString
				 *	      at: charPosInt
				 */
    
    oop4 = popOOP();
    oop3 = popOOP();
    oop2 = popOOP();
    oop1 = stackTop();
    fileStream = (FileStream)oopToObj(oop1);
    fileOOP = fileStream->file;
    file = (FILE *)cObjectValue(fileOOP);
    fileName = toCString(fileStream->name);
    realFileName = nil;
    if (access(fileName, 4) == 0) {
      if (isInt(oop2)
	  && (isNil(oop3) || (isClass(oop3, stringClass) && isInt(oop4)))) {
	arg2 = toInt(oop2);
	if (!isNil(oop3)) {
	  arg4 = toInt(oop4);
	  realFileName = toCString(oop3);
	} else {
	  arg4 = 0;
	}

	exportSP();
	initLexer(false);
	pushUNIXFile(file, fileName);
	setStreamInfo(arg2, realFileName, arg4);
	yyparse();
	popStream(false);		/* we didn't open it, so we don't close it */
	importSP();
	return (false);
      }
    }
    free(fileName);
    if (realFileName) {
      free(realFileName);
    }
    unPop(3);
    return (true);

  case 249:			/* Behavior makeDescriptorFor: funcNameString
				            returning: returnTypeSymbol
					    withArgs: argsArray */
    oop4 = popOOP();
    oop3 = popOOP();
    oop2 = popOOP();
    oop1 = popOOP();
    if (isClass(oop2, stringClass)
	&& (isClass(oop3, symbolClass) || isClass(oop3, cTypeClass))
	&& (isClass(oop4, arrayClass)
	    || isClass(oop4, undefinedObjectClass))) {
      pushOOP(makeDescriptor(oop2, oop3, oop4));
      return (false);
    }
    unPop(4);
    return (true);

  case 250:			/* Object snapshot */
    saveToFile(defaultImageName);
    return (false);

  case 251:			/* Object snapshot: aString */
    oop2 = popOOP();
    if (isClass(oop2, stringClass)) {
      fileName = toCString(oop2);
      saveToFile(fileName);
      free(fileName);
      return (false);
    }
    unPop(1);
    return (true);
    
  case 252:			/* Object basicPrint */
    printf("Object: ");
    printObject(stackTop());
    printf("\n");
    return (false);

    /* 253 open */


  case 254:			/* FileStream>>IO primitive, variadic */
    for (i = numArgs; --i >= 0; ) {
      oopVec[i] = popOOP();
    }
    oop1 = stackTop();
    if (isInt(oopVec[0])) {
      failed = false;
      arg1 = toInt(oopVec[0]);
      if (arg1 == ENUM_INT(openFilePrim) || arg1 == ENUM_INT(popenFilePrim)) {
	/* open: fileName[1] mode: mode[2] or
	 * popen: command[1] dir: direction[2] */
	fileName = toCString(oopVec[1]);
	fileMode = toCString(oopVec[2]);
	if (arg1 == ENUM_INT(openFilePrim)) {
	  file = fopen((char *)fileName, (char *)fileMode);
	} else {
#ifdef VMS
	  file = NULL;		/* VMS has no popen! */
#else
	  file = popen((char *)fileName, (char *)fileMode);
#endif
	}
	if (file == NULL) {
#ifdef old_code /* Sun Sep 22 09:36:23 1991 */
/**/	  errorf("Failed to open %s named '%s'",
/**/		 (ENUM_INT(openFilePrim) == arg1) ? "file" : "pipe",
/**/		 fileName);
#endif /* old_code Sun Sep 22 09:36:23 1991 */
	  free(fileName);
	  free(fileMode);
	  failed = true;
	  break;
	}
	  
	fileOOP = cObjectNew(file);
	setFileStreamFile(oop1, fileOOP, oopVec[1]);
	free(fileName);
	free(fileMode);
	return (false);
      } else {
	fileStream = (FileStream)oopToObj(oop1);
	fileOOP = fileStream->file;
	file = (FILE *)cObjectValue(fileOOP);
	switch (arg1) {

	case closeFilePrim:	/* FileStream close */
	  fclose(file);
	  return (false);
	
	case getCharPrim:	/* FileStream next */
	  ch = getc(file);
	  if (ch == EOF) {	/* cause nil to be returned */
	    failed = true;
	    break;
	  } else {
	    setStackTop(charOOPAt(ch));
	    return (false);
	  }
	  
	case putCharPrim:	/* FileStream nextPut: aChar */
	  if (isClass(oopVec[1], charClass)) {
	    ch = charOOPValue(oopVec[1]);
	    fputc(ch, file);
	    return (false);
	  } else {
	    failed = true;
	    break;
	  }

	case seekPrim:		/* FileStream position: position */
	  fseek(file, toInt(oopVec[1]), 0);
	  return (false);

	case tellPrim:		/* FileStream position */
	  setStackTop(fromInt(ftell(file)));
	  return (false);

	case eofPrim:		/* FileStream atEnd */ 
	  popOOP();		/* remove self */
	  ch = getc(file);
	  atEof = feof(file);
	  pushBoolean(atEof);
	  ungetc(ch, file);
	  return (false);

	case sizePrim:
	  if (fstat(fileno(file), &statBuf)) {
	    failed = true;
	    break;
	  } else {
	    setStackTop(fromInt(statBuf.st_size));
	    return (false);
	  }

	case putCharsPrim:	/* only works for strings currently */
	  fwrite(stringOOPChars(oopVec[1]), numIndexableFields(oopVec[1]), 1, file);
	  return (false);

	case getCharsPrim:	/* only works for strings */
	  if (isInt(oopVec[1])) {
	    arg2 = toInt(oopVec[1]);
	    stringOOP = newString(arg2);
	    if (fread(stringOOPChars(stringOOP), arg2, 1, file) == 0) {
	      failed = true;
	      break;
	    }
	    setStackTop(stringOOP);
	    return (false);
	  }
	  break;
	}
      }
    }

    if (failed) {
      unPop(numArgs);
    }
    break;

  case 255:			/* C callout primitive */
    inInterpreter = false;
    exportSP();
    inCCode = true;
    if (setjmp(cCalloutJmpBuf) == 0) {
      invokeCRoutine(numArgs, methodOOP);
    }
    inCCode = false;
    importSP();
    inInterpreter = true;
    return (false);

  default:
    errorf("Unhandled primitive operation %d", primitive);
    return (true);
  }

  exportSP();
  return (failed);

}

/*
These are the primitives as defined in the Blue Book.  The ones with numbers
but without stars are those which are not implemented.

* 1 +
* 2 -
* 3 <
* 4 >
* 5 <=
* 6 >=
* 7 =
* 8 ~=
* 9 *
* 10 /
* 11 \\
* 12 //
* 13 quo:
* 14 bitAnd:
* 15 bitOr:
* 16 bitXor:
* 17 bitShift:

* 40 Smallinteger asFloat
* 41 Float +
* 42 Float -
* 43 Float >
* 44 Float <
* 45 Float <=
* 46 Float >=
* 47 Float =
* 48 Float ~=
* 49 Float *
* 50 Float /
* 51 Float truncated
* 52 Float fractionPart
* 53 Float exponent
* 54 Float timesTwoPower:

* 60 Object at:
   Object basicAt:
* 61 Object basicAt:put:
   Object at:put:
* 62 Object basicSize
   Object size
   String size
   ArrayedCollection size
* 63 String at:
   String basicAt:
* 64 String basicAt:put:
   String at:put:

* 70 Behavior basicNew
   Behavior new
   Interval class new
* 71 Behavior new:
   Behavior basicNew:
* 72 Object become:
* 73 Object instVarAt:
* 74 Object instVarAt:put:
* 75 Object asOop
   Object hash
   Symbol hash
* 76 SmallInteger asObject
   SmallInteger asObjectNoFail
* 77 Behavior someInstance
* 78 Object nextInstance
79 CompiledMethod class newMethod:header:
* 80 ContextPart blockCopy:
* 81 BlockContext value:value:value:
   BlockContext value:
   BlockContext value:value:
* 82 BlockContext valueWithArguments:
* 83 Object perform:with:with:with:
   Object perform:with:
   Object perform:with:with:
   Object perform:
* 84 Object perform:withArguments:

105 ByteArray primReplaceFrom:to:with:startingAt:
    ByteArray replaceFrom:to:withString:startingAt:
    String replaceFrom:to:withByteArray:startingAt:
    String primReplaceFrom:to:with:startingAt:

* 110 Character =
    Object ==
* 111 Object class

*/

static OOP getActiveProcess()
{
  ProcessorScheduler processor;

  if (!isNil(switchToProcess)) {
    return (switchToProcess);
  } else {
    processor = (ProcessorScheduler)oopToObj(processorOOP);
    return (processor->activeProcess);
  }
}

static void addLastLink(semaphoreOOP, processOOP)
OOP	semaphoreOOP, processOOP;
{
  Semaphore	sem;
  Process	process, lastProcess;
  OOP		lastProcessOOP;


  prepareToStore(processOOP, semaphoreOOP);
  process = (Process)oopToObj(processOOP);
  process->myList = semaphoreOOP;
  process->nextLink = nilOOP;

  sem = (Semaphore)oopToObj(semaphoreOOP);
  if (isNil(sem->lastLink)) {
    prepareToStore(semaphoreOOP, processOOP);
    sem = (Semaphore)oopToObj(semaphoreOOP);
    sem->firstLink = sem->lastLink = processOOP;
  } else {
    lastProcessOOP = sem->lastLink;
    prepareToStore(lastProcessOOP, processOOP);
    lastProcess = (Process)oopToObj(lastProcessOOP);
    lastProcess->nextLink = processOOP;
    prepareToStore(semaphoreOOP, processOOP);
    sem = (Semaphore)oopToObj(semaphoreOOP);
    sem->lastLink = processOOP;
  }
}

syncSignal(semaphoreOOP)
OOP	semaphoreOOP;
{
  Semaphore sem;

  sem = (Semaphore)oopToObj(semaphoreOOP);
  if (isEmpty(semaphoreOOP)) {	/* nobody waiting */
    sem->signals = incrInt(sem->signals);
  } else {
    resumeProcess(removeFirstLink(semaphoreOOP));
  }
}

static OOP removeFirstLink(semaphoreOOP)
OOP	semaphoreOOP;
{
  Semaphore	sem;
  Process	process;
  OOP		processOOP;

  sem = (Semaphore)oopToObj(semaphoreOOP);
  processOOP = sem->firstLink;
  process = (Process)oopToObj(processOOP);

/*  prepareToStore(semaphoreOOP, processOOP); */
  prepareToStore(semaphoreOOP, process->nextLink);
  sem = (Semaphore)oopToObj(semaphoreOOP);
  sem->firstLink = process->nextLink;
  if (isNil(sem->firstLink)) {
    sem->lastLink = nilOOP;
  }

  process->nextLink = nilOOP;
  process->myList = nilOOP;

  return (processOOP);
}

static void resumeProcess(processOOP)
OOP	processOOP;
{
  OOP		activeOOP;
  Process	process, active;

  activeOOP = getActiveProcess();
  active = (Process)oopToObj(activeOOP);
  process = (Process)oopToObj(processOOP);

  if (toInt(process->priority) > toInt(active->priority)) {
    /*
     * we're resuming a process with a higher priority, so sleep the
     * current one and activate the new one
     */
    sleepProcess(activeOOP);
    activateProcess(processOOP);
  } else {
    /* this process isn't higher than the active one */
    sleepProcess(processOOP);
  }
}

static void activateProcess(processOOP)
OOP	processOOP;
{
  switchToProcess = processOOP;
  exceptFlag = true;
}

static void sleepProcess(processOOP)
OOP	processOOP;
{
  Process	process;
  int		priority;
  OOP		processLists;
  OOP		processList;

  process = (Process)oopToObj(processOOP);
  priority = toInt(process->priority);
  processLists = getProcessLists();
  processList = arrayAt(processLists, priority);

  /* add process to end of priority queue */
  addLastLink(processList, processOOP);
}


static void suspendActiveProcess()
{
  activateProcess(highestPriorityProcess());
}


static OOP highestPriorityProcess()
{
  OOP		processLists, processList;
  int		priority;

  processLists = getProcessLists();
  priority = numOOPs(oopToObj(processLists));
  for (; priority > 0 ; priority--) {
    processList = arrayAt(processLists, priority);
    if (!isEmpty(processList)) {
      return (removeFirstLink(processList));
    }
  }

  errorf("No Runnable process!!!");
  exit(0);			/* maybe return to caller? */
  /*NOTREACHED*/
}

static Boolean isEmpty(processListOOP)
OOP	processListOOP;
{
  Semaphore	processList;

  processList = (Semaphore)oopToObj(processListOOP);
  return (isNil(processList->firstLink));
}

static OOP getProcessLists()
{
  ProcessorScheduler processor;

  processor = (ProcessorScheduler)oopToObj(processorOOP);
  return (processor->processLists);
}

static OOP semaphoreNew()
{
  Semaphore	sem;

  sem = (Semaphore)instantiate(semaphoreClass);
  sem->signals = fromInt(0);

  return (allocOOP(sem));
}

/*
 *	static Boolean *boolAddrIndex(index)
 *
 * Description
 *
 *	Used to help minimize the number of primitives used to control the
 *	various debugging flags, this routine maps an index to the address
 *	of a boolean debug flag, which it returns.
 *
 * Inputs
 *
 *	index : An integer (0 based) index to the set of debug variables
 *
 * Outputs
 *
 *	Address of the C debug variable, or NULL on failure.
 */
static Boolean *boolAddrIndex(index)
int	index;
{
  switch (index) {
  case 0: return (&declareTracing);
  case 1: return (&executionTracing);
  case 2: return (&verboseExecTracing);
  case 3: return (&gcMessage);
  case -1: return (&gcDebug);
  default:
    /* index out of range, signal the error */
    return (NULL);

  }
}


/*
 *	static void methodHasBlockContext(methodOOP)
 *
 * Description
 *
 *	Marks a method context has having created a block context.
 *
 * Inputs
 *
 *	methodOOP: MethodContext OOP to be marked
 *		
 *
 */
static void methodHasBlockContext(methodOOP)
OOP	methodOOP;
{
  MethodContext methodContext;

  methodContext = (MethodContext)oopToObj(methodOOP);
  /* Since trueOOP is in the root set, we don't have to prepare to store it */
  methodContext->hasBlock = trueOOP;
}

void setFileStreamFile(fileStreamOOP, fileOOP, fileNameOOP)
OOP	fileStreamOOP, fileOOP, fileNameOOP;
{
  FileStream	fileStream;

  fileStream = (FileStream)oopToObj(fileStreamOOP);
  prepareToStore(fileStreamOOP, fileOOP);
  fileStream->file = fileOOP;
  prepareToStore(fileStreamOOP, fileNameOOP);
  fileStream->name = fileNameOOP;
}


/*
 *	static void sendBlockValue(numArgs)
 *
 * Description
 *
 *	This is the equivalent of sendMessage, but is for blocks.  The block
 *	context that is to the the receiver of the "value" message should be
 *	"numArgs" into the stack.  Temporaries come from the block's method
 *	context, as does self.  IP is set to the proper
 *	place within the block's method's byte codes, and SP is set to the top
 *	of the arguments in the block context, which have been copied out of
 *	the caller's context.
 *
 * Inputs
 *
 *	numArgs: 
 *		The number of arguments sent to the block.
 *
 */
static void sendBlockValue(numArgs)
int	numArgs;
{
  OOP		blockContextOOP, methodContextOOP;
  BlockContext	blockContext;
  MethodContext thisContext, methodContext;
  int		i;

  /*
   * although we realized the contexts when we pushed the current oop
   * onto the stack, we may be sending the block a value from within an inner 
   * context which has not been realized.  This could hand out a reference to
   * a fake object which is forbidden
   */
  realizeMethodContexts();

  if (!isNil(thisContextOOP)) {
    thisContext = (MethodContext)oopToObj(thisContextOOP);
    /* save old context information */
    thisContext->ipOffset = fromInt(relativeByteIndex(ip, thisMethod));
    /* leave sp pointing to receiver, which is replaced on return with value*/
    thisContext->spOffset = fromInt(sp - numArgs - thisContext->contextStack);
  }

  /* prepare the new state */
  blockContextOOP = stackAt(numArgs);
  maybeMoveOOP(blockContextOOP); /* make sure we're alive */

  blockContext = (BlockContext)oopToObj(blockContextOOP);
  maybeMoveOOP(thisContextOOP);	/* ### not sure if this is needed*/
  blockContext->caller = thisContextOOP;
  switch (numArgs) {
  case 0:	blockContext->selector = valueSymbol; break;
  case 1:	blockContext->selector = valueColonSymbol; break;
  case 2:	blockContext->selector = valueColonValueColonSymbol; break;
  case 3:	blockContext->selector = valueColonValueColonValueColonSymbol; break;
  default:	blockContext->selector = valueWithArgumentsColonSymbol; break;
  }

  /* home is set when the block is created */

  /* copy numArgs arguments into new context */
  memcpy(blockContext->contextStack, &sp[-numArgs+1],
	 (numArgs) * sizeof(OOP));
  for (i = 0; i < numArgs; i++) {
    maybeMoveOOP(blockContext->contextStack[i]);
  }

  sp = &blockContext->contextStack[numArgs-1]; /* start of stack-1 */

  thisContextOOP = blockContextOOP;

  methodContextOOP = blockContext->home;
  methodContext = (MethodContext)oopToObj(methodContextOOP);
  ip = toInt(blockContext->initialIP) + getMethodByteCodes(methodContext->method);
  thisMethod = methodContext->method;
  maybeMoveOOP(thisMethod);
  temporaries = methodContext->contextStack;
  self = methodContext->receiver;
  maybeMoveOOP(self);
}

/*
 *	static char *selectorAsString(selector)
 *
 * Description
 *
 *	Converts a selector to a C string object
 *
 * Inputs
 *
 *	selector: A OOP for the selector, a Symbol.
 *		
 *
 * Outputs
 *
 *	C string that corresponds to the selector's printed name.
 */
static char *selectorAsString(selector)
OOP	selector;
{
  return (symbolAsString(selector));
}

/*
 *	static OOP findMethod(receiverClass, selector)
 *
 * Description
 *
 *	Scans the methods of "receiverClass" and all its super classes for one
 *	with selector "selector".  It returns the method if it found, otherwise
 *	nil is returned.
 *
 * Inputs
 *
 *	receiverClass:
 *		The class to begin the search in.  This is normally called from
 *		the message sending code, so that's why this parameter is
 *		called receiverClass.
 *	selector:
 *		The selector for the method that is being sought.
 *	methodClassPtr:
 *		The class that the method was eventually found in.  Passed
 *		by reference and set when returning.
 *
 * Outputs
 *
 *	Method for "selector", or nilOOP if not found.  "methodClassPtr" is
 *	returned as a by-reference parameter.
 */
static OOP findMethod(receiverClass, selector, methodClassPtr)
OOP	receiverClass, selector, *methodClassPtr;
{
  OOP		classOOP, methodOOP;

  for (classOOP = receiverClass; !isNil(classOOP);
       classOOP = superClass(classOOP)) {
    methodOOP = findClassMethod(classOOP, selector);
    if (!isNil(methodOOP)) {
      *methodClassPtr = classOOP;
      return (methodOOP);
    }
  }

  *methodClassPtr = undefinedObjectClass; /* probably not used */
  return (nilOOP);
}

/* runs before GC turned on */
void initProcessSystem()
{
  OOP		processLists;
  int		i;
  ProcessorScheduler processor;
  Process	initialProcess;
  OOP		initialProcessOOP;
  

  processLists = arrayNew(NUM_PRIORITIES);

  for (i = 1; i <= NUM_PRIORITIES; i++) {
    arrayAtPut(processLists, i, semaphoreNew()); /* ### should be linked list */
  }

  initialProcess = (Process)instantiate(processClass);
  initialProcess->priority = fromInt(4); /* userSchedulingPriority */
  initialProcessOOP = allocOOP(initialProcess);


  processor = (ProcessorScheduler)instantiate(processorSchedulerClass);
  processor->processLists = processLists;
  processor->activeProcess = initialProcessOOP;

  processorOOP = allocOOP(processor);
}


void initInterpreter()
{
  int		i;

  thisContextOOP = nilOOP;
  asyncQueueIndex = 0;
  switchToProcess = nilOOP;

  for (i = 0; i < NUM_SIGNALS; i++) {
    semIntHappened[i] = false;
    semIntVec[i] = nilOOP;
  }
}

void prepareExecutionEnvironment()
{
  MethodContext thisContext, newContext;
  OOP		newContextOOP;

  abortExecution = false;

/* dprintf("     prepareExec thisContext is %d, %x\n", isNil(thisContextOOP), thisContextOOP); */

  if (!isNil(thisContextOOP)) {
/* dprintf(">>>> entering to non nil environment %8x!\n", thisContextOOP); */
    thisContext = (MethodContext)oopToObj(thisContextOOP);
    /* save old context information */
    thisContext->ipOffset = fromInt(relativeByteIndex(ip, thisMethod));
    /* leave sp pointing to receiver, which is replaced on return with value*/
    thisContext->spOffset = fromInt(sp - thisContext->contextStack);
  }

  /* now make a dummy context to run with */
  newContextOOP = allocMethodContext();
  newContext = (MethodContext)oopToObj(newContextOOP);
  ip = nil;
  if (!isFake(thisContextOOP)) {
    maybeMoveOOP(thisContextOOP);
  }
/* dprintf("{{{{ sender for %8x is %8x(prepare)\n", newContext, thisContextOOP); */
  newContext->sender = thisContextOOP;
  thisMethod = newContext->method = nilOOP;
  newContext->methodClass = objectClass; /* no real class */
  newContext->selector = nilOOP; /* no real selector invoked us */
  newContext->receiver = nilOOP; /* make self be real (well, nil) */
  sp = newContext->contextStack - 1;

  temporaries = newContext->contextStack;
  self = nilOOP;

  thisContextOOP = newContextOOP;

  invalidateMethodCache();
#ifdef countingByteCodes 
  initByteCodeCounter();
#endif
}

OOP finishExecutionEnvironment()
{
  MethodContext oldContext, thisContext;
  OOP		oldContextOOP, returnedValue;
  
  returnedValue = stackTop();
  oldContextOOP = thisContextOOP;
  oldContext = (MethodContext)oopToObj(oldContextOOP);
  thisContextOOP = oldContext->sender;

  if (isFake(oldContextOOP)) {
    deallocMethodContext(oldContextOOP);
  }

  if (!isNil(thisContextOOP)) {
/* dprintf("<<<<< returning to non nil environment %8x!\n", thisContextOOP); */
    if (!isFake(thisContextOOP)) {
      maybeMoveOOP(thisContextOOP);
    }
    thisContext = (MethodContext)oopToObj(thisContextOOP);
    /* restore old context information */
    thisMethod = thisContext->method;
    maybeMoveOOP(thisMethod);
    temporaries = thisContext->contextStack;
    self = thisContext->receiver;
    maybeMoveOOP(self);
    ip = toInt(thisContext->ipOffset) + getMethodByteCodes(thisMethod);
    sp = thisContext->contextStack + toInt(thisContext->spOffset);
  }
  return (returnedValue);
}

static void invalidateMethodCache()
{
  register int	i;

  cacheHits = cacheMisses = 0;

  for (i = 0; i < METHOD_CACHE_SIZE; i++) {
    methodCacheSelectors[i] = primitiveCacheSelectors[i] = nilOOP;
    methodCacheClasses[i] = primitiveCacheClasses[i] = nilOOP;
    methodCacheMethods[i] = nilOOP;
    collide[0] = primitiveCachePrimitives[i] = 0;
  }
}

void updateMethodCache(selectorOOP, classOOP, methodOOP)
OOP	selectorOOP, classOOP, methodOOP;
{
  long		hashIndex;

  hashIndex = ((long)selectorOOP ^ (long)classOOP) >> 4;
  hashIndex &= (METHOD_CACHE_SIZE - 1);
  if (methodCacheSelectors[hashIndex] == selectorOOP &&
      methodCacheClasses[hashIndex] == classOOP) {
    methodCacheMethods[hashIndex] = methodOOP;
  }
}

#ifdef countingByteCodes
initByteCodeCounter()
{
  int i;

  for (i = 0; i < 256; i++) {
    primitives[i] = byteCodes[i] = 0;
  }
}

printByteCodeCounts()
{
  int i;

  for (i = 0; i < 256; i++) {
    if (byteCodes[i]) {
      printf("Byte code %d = %d\n", i, byteCodes[i]);
    }
  }

  printf("\n---> primitives:\n");
  for (i = 0; i < 256; i++) {
    if (primitives[i]) {
      printf("Primitive %d = %d\n", i, primitives[i]);
    }
  }

}
#endif


/* #ifdef ACCESSOR_DEBUGGING */
static int relativeByteIndex(bp, methodOOP)
Byte	*bp;
OOP	methodOOP;
{
  return (relativeByteIndexInternal(bp, methodOOP));
}
/* #endif /* ACCESSOR_DEBUGGING */

/*
 *	void moveProcessorRegisters()
 *
 * Description
 *
 *	Part of the GC flip, copy the root set process.  This ensures that the
 *	processor registers are pointing to objects in new space.  The term
 *	"processor registers" refers here to interpreter variables like ip, sp,
 *	temporaries, etc.
 *
 */
void moveProcessorRegisters()
{
  MethodContext thisContext;	/* may be block context, but doesn't matter */
  MethodContext	methodContext;
  int		spOffset, ipOffset;
  OOP		methodContextOOP;

  if (isFake(thisContextOOP)) {
    copyFakeContextObjects();
  } else {
    /* Right off the top of my head, I can't think why I need to invalidate
     * the method cache when I do a GC flip */
    /* invalidateMethodCache(); */

    thisContext = (MethodContext)oopToObj(thisContextOOP);
    spOffset = sp - thisContext->contextStack;
    ipOffset = relativeByteIndex(ip, thisMethod);

    localMaybeMoveOOP(thisContextOOP);
    localMaybeMoveOOP(thisMethod);

    ip = ipOffset + getMethodByteCodes(thisMethod);

    thisContext = (MethodContext)oopToObj(thisContextOOP);
    sp = thisContext->contextStack + spOffset;

    methodContextOOP = getMethodContext(thisContextOOP);
    localMaybeMoveOOP(methodContextOOP);
    methodContext = (MethodContext)oopToObj(methodContextOOP);

    temporaries = methodContext->contextStack;
    /* self remains valid (doesn't have to be refetched from methodcontext) */
    localMaybeMoveOOP(self);

  }
  moveSemaphoreOOPs();

  /* added experimentally */
  localMaybeMoveOOP(processorOOP);
}

static void copyFakeContextObjects()
{
  MethodContext	methodContext;
  int		stackDepth, i;
  OOP		c;
  
  methodContext = (MethodContext)oopToObj(thisContextOOP);
  /* make this regular */
  methodContext->spOffset = fromInt(sp - methodContext->contextStack);

  for (c = thisContextOOP; isFake(c); c = methodContext->sender) {
    methodContext = (MethodContext)oopToObj(c);

    if (!isFake(methodContext->sender)) {
/* dprintf("{{{{ moving sender in copy %8x\n", methodContext); */
      localMaybeMoveOOP(methodContext->sender);
    }

    localMaybeMoveOOP(methodContext->method);
    localMaybeMoveOOP(methodContext->methodClass);
    if (methodContext->hasBlock != nilOOP) {
      printf("fake context has a block!!!\n");
    }
    localMaybeMoveOOP(methodContext->selector); /* seems wasteful...it's a symbol
					    * and symbols won't be gc'd */
    localMaybeMoveOOP(methodContext->receiver);
    stackDepth = toInt(methodContext->spOffset);
    for (i = 0; i <= stackDepth; i++) {
      localMaybeMoveOOP(methodContext->contextStack[i]);
    }
  }

  /* leave things like sp, temporaries alone since we haven't moved our
   * fake context!
   */
}

/*
 *	static void moveSemaphoreOOPs()
 *
 * Description
 *
 *	This routine doesn't really do anything yet.  It's intended purpose is
 *	to be called during the root set copying part of a GC flip to copy any
 *	asynchronous semaphores.  However, the async semaphore representation
 *	is likely not to be in terms of Smalltalk objects for a variety of
 *	reasons, so the need for this routine may never materialize.
 *
 */
static void moveSemaphoreOOPs()
{
  int		i;
  IntState	oldSigMask;

  oldSigMask = disableInterrupts(); /* block out everything! */
  /* ### this needs to be changed; async signals shouldn't be oops! */
  for (i = 0; i < asyncQueueIndex; i++) {
    moveOOP(queuedAsyncSignals[i]);
  }
  enableInterrupts(oldSigMask);
}

/*
 *	void initSignals()
 *
 * Description
 *
 *	Trap the signals that we care about, basically SIGBUS and SIGSEGV.
 *	These are sent to the back trace routine so we can at least have some
 *	idea of where we were when we died.
 *
 */
void initSignals()
{
  signal(SIGBUS, interruptHandler);
  signal(SIGSEGV, interruptHandler);

  signal(SIGINT, stopExecuting);
}


/*
 *	static signalType stopExecuting(sig)
 *
 * Description
 *
 *	Sets flags so that the interpreter starts returning immediately
 *	from whatever byte codes it's executing.  It returns via normal method
 *	returns, so that the world is in a consistent state when it's done.
 *
 * Inputs
 *
 *	sig   : signal that caused the interrupt (typically ^C), or 0, which
 *		comes from a call from within the system.
 *
 */
static signalType stopExecuting(sig)
{
  if (sig) {
    printf("\nInterrupt!\n");
  }

  abortExecution = true;
  exceptFlag = true;
  if (inCCode) {
    longjmp(cCalloutJmpBuf, 1);	/* throw out from C code */
  }
}


static signalType timeoutHandler(sig)
int sig;
{
  signalTimeoutSemaphore = true;
  exceptFlag = true;
}

static signalType semIntHandler(sig)
int sig;
{
  semIntHappened[sig] = true;
  semIntFlag = true;
  exceptFlag = true;
}


/*
 *	static signalType interruptHandler(sig)
 *
 * Description
 *
 *	Called to handle serious problems, such as segmentation violation.
 *	Tries to show a method invocation backtrace if possibly, otherwise
 *	tries to show where the system was in the file it was procesing when
 *	the error occurred.
 *
 * Inputs
 *
 *	sig   : Signal number, an integer
 *
 * Outputs
 *
 *	not used.  Always exits from Smalltalk.
 */
static signalType interruptHandler(sig)
int	sig;
{
  switch (sig) {
  case SIGBUS:
    errorf("Bus Error");
    break;

  case SIGSEGV:
    errorf("Segmentation violation");
    break;
    
  default:
    errorf("Unknown signal caught: %d", sig);
  }

  if (makeCoreFile) {
    kill(getpid(), SIGQUIT);	/* die with a core dump */
  }

  if (inInterpreter) {
    showBacktrace();
  } else {
    errorf("Error occurred while not in byte code interpreter!!");
  }

  exit(1);
}

static void showBacktrace()
{
  OOP		context, receiver, receiverClass;
  MethodContext methodContext, nextContext;
  BlockContext	blockContext;

/* printf("In showbacktrace\n"); */
  for (context = thisContextOOP; !isNil(context);
       context = nextContext->sender) {
    if (!isRealOOP(context)
	&& (context->flags != F_FAKE)) { /* where F_FAKE is set, it's always
					  * exactly that...no other bits
					  * are ever set in a fake oop */
      printf("Context stack corrupted!\n");
      break;
    }
    if (isBlockContext(context)) {
/* printf("In block context\n"); */
      blockContext = (BlockContext)oopToObj(context);
      methodContext = (MethodContext)oopToObj(blockContext->home);
/* printf("after method context\n"); */
      receiver = methodContext->receiver;
      if (isInt(receiver)) {
	receiverClass = integerClass;
      } else {
	if (!isRealOOP(receiver)) {
	  printf("Context stack corrupted!\n");
	  break;
	}
	receiverClass = oopClass(receiver);
      }
      printf("[] in ");
      printObject(methodContext->methodClass);
      /* printObject(receiverClass);*/
      nextContext = (MethodContext)blockContext;
    } else {
/* printf("a method context\n"); */
      methodContext = (MethodContext)oopToObj(context);

      if (!isRealOOP(methodContext->selector)) {
	printf("Context stack corrupted!\n");
	break;
      }
      
      receiver = methodContext->receiver;
      if (isInt(receiver)) {
	receiverClass = integerClass;
      } else {
	if (!isRealOOP(receiver)) {
	  printf("Context stack corrupted!\n");
	  break;
	}
	receiverClass = oopClass(receiver);
      }
      printObject(receiverClass);
      if (receiverClass != methodContext->methodClass) {
	printf("(");
	printObject(methodContext->methodClass);
	printf(")");
      }
      nextContext = methodContext;
    }
    printf(">>");
    printObject(methodContext->selector);
    printf("\n");
  }

}

static Boolean isRealOOP(oop)
OOP oop;
{
  return (oop >= oopTable && oop < &oopTable[TOTAL_OOP_TABLE_SLOTS]);
}


checkStack(oop)
OOP	oop;
{
  MethodContext	methodContext;
  int	depth;
  methodContext = (MethodContext)oopToObj(thisContextOOP);

  if ((depth = sp - methodContext->contextStack) >= CONTEXT_STACK_SIZE - 1) {
    printf("##### stack at %d, oop = %8x\n", depth, oop);
    debug();
  }
}
