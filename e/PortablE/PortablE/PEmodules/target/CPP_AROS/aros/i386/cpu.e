/* $Id: cpu.h 28948 2008-06-30 20:48:16Z verhaegs $ */
OPT NATIVE
->{#include <aros/i386/cpu.h>}
NATIVE {AROS_I386_CPU_H} CONST

PRIVATE
TYPE UBYTE_AROS IS NATIVE {unsigned char} CHAR
PUBLIC


NATIVE {EnableSetFunction}	CONST ENABLESETFUNCTION	= 1

/* Information about size and alignment,
 * the defines have to be numeric constants */
NATIVE {AROS_STACK_GROWS_DOWNWARDS} CONST AROS_STACK_GROWS_DOWNWARDS = 1 /* Stack direction */
NATIVE {AROS_BIG_ENDIAN} 	   CONST AROS_BIG_ENDIAN 	   = 0 /* Big or little endian */
NATIVE {AROS_SIZEOFULONG}	   CONST AROS_SIZEOFULONG	   = 4 /* Size of an ULONG */
NATIVE {AROS_SIZEOFPTR}		   CONST AROS_SIZEOFPTR		   = 4 /* Size of a PTR */
NATIVE {AROS_WORDALIGN}		   CONST AROS_WORDALIGN		   = 2 /* Alignment for WORD */
NATIVE {AROS_LONGALIGN}		   CONST AROS_LONGALIGN		   = 4 /* Alignment for LONG */
NATIVE {AROS_QUADALIGN}		   CONST AROS_QUADALIGN		   = 4 /* Alignment for QUAD */
NATIVE {AROS_PTRALIGN}		   CONST AROS_PTRALIGN		   = 4 /* Alignment for PTR */
NATIVE {AROS_IPTRALIGN}		   CONST AROS_IPTRALIGN		   = 4 /* Alignment for IPTR */
NATIVE {AROS_DOUBLEALIGN}	   CONST AROS_DOUBLEALIGN	   = 4 /* Alignment for double */
NATIVE {AROS_WORSTALIGN} 	   CONST AROS_WORSTALIGN 	   = 4 /* Worst case alignment */

NATIVE {SIZEOF_FPU_STATE}	CONST SIZEOF_FPU_STATE	= 512  /* 108 bytes are needed to store FPU, 512 bytes are needed to store SSE */
NATIVE {SIZEOF_ALL_REGISTERS}	CONST SIZEOF_ALL_REGISTERS	= (15*4 + SIZEOF_FPU_STATE + 16)  /* Size of iet_Context */

NATIVE {AROS_32BIT_TYPE}         CONST

/* Use C pointer and string for the BCPL pointers and strings
 * For a normal ABI these should not be defined for maximum source code
 * compatibility.
 */
NATIVE {AROS_FAST_BPTR} CONST AROS_FAST_BPTR = 1
NATIVE {AROS_FAST_BSTR} CONST AROS_FAST_BSTR = 1

/* types and limits for sig_atomic_t */
NATIVE {AROS_SIG_ATOMIC_T}       CONST
NATIVE {AROS_SIG_ATOMIC_MIN}     CONST ->AROS_SIG_ATOMIC_MIN     = (-$7fffffff-1)
NATIVE {AROS_SIG_ATOMIC_MAX}     CONST ->AROS_SIG_ATOMIC_MAX     = $7fffffff

/* ??? */
NATIVE {SP_OFFSET} CONST SP_OFFSET = 0

/*
    One entry in a libraries' jumptable. For assembler compatibility, the
    field jmp should contain the code for an absolute jmp to a 32bit
    address. There are also a couple of macros which you should use to
    access the vector table from C.
*/
NATIVE {FullJumpVec} OBJECT fulljumpvec
    {jmp}	jmp	:UBYTE_AROS
    {vec}	vec[4]	:ARRAY OF UBYTE_AROS
ENDOBJECT


/*
    Extracts and stores the start address from a loaded
    executable segment. start_address may then be used by gdb.
    It is calculated from _v->vec set in __AROS_SET_FULLJMP.
*/
NATIVE {JumpVec} OBJECT jumpvec
    {vec}	vec[4]	:ARRAY OF UBYTE_AROS
ENDOBJECT

/* Use these to acces a vector table */
NATIVE {LIB_VECTSIZE}			CONST ->LIB_VECTSIZE			= (sizeof (struct JumpVec))

/*
   Code to use to generate stub functions.
   It must be *printed* with a function like printf in a file
   to be compiled with gcc.

   - The first parameter is the function name,
   - The second parameter is the basename,
   - The third parameter is the library vector to be called.
     It's value must be computed by the stub generator with this code:
     &(__AROS_GETJUMPVEC(0, n+1)->vec), where n is the library vector position in
     the library vectors list.

*/

NATIVE {STUBCODE_INIT} CONST
NATIVE {STUBCODE}      CONST
NATIVE {ALIASCODE}     CONST

/*
   We want to activate the execstubs and preserve all registers
   when calling obtainsemaphore, obtainsemaphoreshared, releasesemaphore,
   getcc, permit, forbid, enable, disable
*/
NATIVE {UseExecstubs} CONST USEEXECSTUBS = 1

/* Macros to test/set failure of AllocEntry() */
NATIVE {AROS_ALLOCENTRY_FAILED} CONST	->AROS_ALLOCENTRY_FAILED(memType) ((struct MemList *)((IPTR)(memType) | 0x80ul<<(sizeof(APTR)-1)*8))
NATIVE {AROS_CHECK_ALLOCENTRY} CONST	->AROS_CHECK_ALLOCENTRY(memList) (!((IPTR)(memList) & 0x80ul<<(sizeof(APTR)-1)*8))

/*
    Find the next valid alignment for a structure if the next x bytes must
    be skipped.
*/
NATIVE {AROS_ALIGN} CONST	->AROS_ALIGN(x)        (((x)+AROS_WORSTALIGN-1)&-AROS_WORSTALIGN)

/*
    How much stack do we need ? Lots :-) ?
    Not so much, I think (schulz) ;-))
*/

NATIVE {AROS_STACKSIZE}	CONST AROS_STACKSIZE	= 40960

NATIVE {AROS_UFC3R} CONST	->AROS_UFC3R(t,n,a1,a2,a3,p,ss) __UFC3R(t,n,a1,a2,a3,p)
