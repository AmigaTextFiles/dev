#ifndef _MACHINE_H_
#define _MACHINE_H_
/*
 * Machine dependencies
 */

#include <hardware/intbits.h>
#include <exec/libraries.h>
#include <dos/dos.h>

/* The size of a jumptable entry is very machine dependant */

#ifdef	LIB_VECTSIZE
#undef	LIB_VECTSIZE
#endif
#define	LIB_VECTSIZE	6

/*
 * These 5 macros enable us to get rid of BPTRs and BSTRs
 * on the new machine
 */

/* To convert a typical C pointer into a BPTR */

#ifdef	MKBADDR
#undef	MKBADDR
#endif
#define	MKBADDR(a)	((ULONG)(a)>>2)

/* To convert it back */

#ifdef	BADDR
#undef	BADDR
#endif
#define	BADDR(a)	((APTR)((ULONG)(a)<<2))

/*
 * Use this to allocate/deallocate buffers:
 *
 * BSTROFFSET=1 BSTR	: malloc(strlen(s)+1+1)+1
 * BSTROFFSET=0 C string: malloc(strlen(s)+1+0)+0
 *
 * By using these macros it's possible to get completely rid of BPTRs on
 * the new machine without losing source compatibility to the old one.
 */

#define	BSTROFFSET	(1)

/*
 * To convert a C string into a BSTR
 * s[-BSTROFFSET] must be longword aligned, l is the result of strlen(s)
 */

#define C2BSTR(s,l)	((s)[-BSTROFFSET]=(l),MKBADDR((s)-BSTROFFSET))

/* And back */

#define BSTR2C(s)	((UBYTE *)BADDR(s)+BSTROFFSET)

/*
 * Basic SetFunction().
 * MINGETFUNCTION()  returns the function entry of (library+offset) as an lvalue.
 * MINPREPFUNCTION() prepares the vector for use.
 */
#define MINGETFUNCTION(v)	(*(APTR *)((UWORD *)(v)+1))
#define MINPREPFUNCTION(v)	(*(UWORD *)(v)=0x4ef9)
 
/*
 * Not on the machines I use.
 */
/* #define STACK_GROWS_UPWARDS */

/*
 * This effectively hides all stack nastiness.
 */
#define STACKPOINTEROFFSET (0)

/*
 * Sparc and m68k are big endian, x86 are little endian
 */
#define BIG_ENDIAN
/* #define LITTLE_ENDIAN */

/*
 * When running Amigem on AmigaOS itself this would collide with the usual execbase.
 * Every new task/process/shared library is called with SysBase in a6 anyway,
 * but for compatibility you should use this on (at least) m68k machines.
 * If there's no way to implement it it is not defined.
 */
/* #define ABSEXECBASE 4 */

/*
 * For functions returning 2 values.
 * This _MUST_!! be returned in registers or your function won't be reentrant.
 * If you cannot guarantee this (on gcc -freg-struct-return should work always
 * if it is not broken in that certain version you use) drop the secondary result.
 */
typedef struct __DLONG
{
  LONG _p; /* Primary result */
  LONG _s; /* Secondary result */
} DLONG;

#define RETURN_DLONG(p,s) \
{ DLONG _ret; _ret._p=(p); _ret._s=(s); return _ret; }

/*
 * Minimum Stackspace for new processes/tasks
 */
#define MINSTACKSIZE 4096
#endif
