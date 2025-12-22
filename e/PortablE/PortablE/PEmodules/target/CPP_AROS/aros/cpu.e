/* $Id: cpu.h 27820 2008-02-06 10:15:01Z rob $ */
OPT NATIVE
PUBLIC MODULE 'target/aros/i386/cpu'
/*{#include <aros/cpu.h>}*/
NATIVE {AROS_CPU_H} CONST

NATIVE {AROS_CPU_IA32}               CONST ->AROS_CPU_IA32               = 1
NATIVE {AROS_CPU_M68K}               CONST ->AROS_CPU_M68K               = 2
NATIVE {AROS_CPU_PPC32}              CONST ->AROS_CPU_PPC32              = 3
NATIVE {AROS_CPU_PPC64}              CONST ->AROS_CPU_PPC64              = 4
NATIVE {AROS_CPU_AXP}                CONST ->AROS_CPU_AXP                = 5
NATIVE {AROS_CPU_SPARC32}            CONST ->AROS_CPU_SPARC32            = 6
NATIVE {AROS_CPU_SPARC64}            CONST ->AROS_CPU_SPARC64            = 7
NATIVE {AROS_CPU_IA64}               CONST ->AROS_CPU_IA64               = 8
NATIVE {AROS_CPU_X8664}              CONST ->AROS_CPU_X8664              = 9

/*
    Now, for any optional define that hasn't been provided, we must provide
    an implementation of it here. This is somewhat tedious...
*/

NATIVE {AROS_INTPTR_TYPE}    CONST
->NATIVE {AROS_32BIT_TYPE}     CONST
NATIVE {AROS_16BIT_TYPE}     CONST
NATIVE {AROS_8BIT_TYPE}      CONST
NATIVE {AROS_64BIT_TYPE}     CONST
NATIVE {AROS_INTPTR_STACKTYPE}       CONST
NATIVE {AROS_64BIT_STACKTYPE}        CONST
NATIVE {AROS_32BIT_STACKTYPE}        CONST
NATIVE {AROS_16BIT_STACKTYPE}        CONST
NATIVE {AROS_8BIT_STACKTYPE}         CONST
NATIVE {AROS_FLOAT_STACKTYPE}        CONST
NATIVE {AROS_DOUBLE_STACKTYPE}       CONST
NATIVE {AROS_LARGEST_TYPE}           CONST
NATIVE {AROS_ATOMIC_TYPE}            CONST

/*
 * AROS_xBIT_LEAST: A type that holds at least a certain bit width.
 */
   NATIVE {AROS_8BIT_LEASTTYPE}              CONST
   NATIVE {AROS_16BIT_LEASTTYPE}             CONST
   NATIVE {AROS_32BIT_LEASTTYPE}             CONST
       NATIVE {AROS_64BIT_LEASTTYPE}         CONST

   NATIVE {AROS_8BIT_LEASTMIN}              CONST
   NATIVE {AROS_16BIT_LEASTMIN}             CONST
   NATIVE {AROS_32BIT_LEASTMIN}             CONST
       NATIVE {AROS_64BIT_LEASTMIN}         CONST

   NATIVE {AROS_8BIT_LEASTMAX}              CONST
   NATIVE {AROS_16BIT_LEASTMAX}             CONST
   NATIVE {AROS_32BIT_LEASTMAX}             CONST
       NATIVE {AROS_64BIT_LEASTMAX}         CONST


/*
 * AROS_xBIT_FAST: A type that is fast for operating quickly
 */
   NATIVE {AROS_8BIT_FASTTYPE}               CONST
   NATIVE {AROS_16BIT_FASTTYPE}              CONST
   NATIVE {AROS_32BIT_FASTTYPE}              CONST
       NATIVE {AROS_64BIT_FASTTYPE}          CONST

   NATIVE {AROS_8BIT_FASTMIN}               CONST
   NATIVE {AROS_16BIT_FASTMIN}              CONST
   NATIVE {AROS_32BIT_FASTMIN}              CONST
       NATIVE {AROS_64BIT_FASTMIN}          CONST

   NATIVE {AROS_8BIT_FASTMAX}               CONST
   NATIVE {AROS_16BIT_FASTMAX}              CONST
   NATIVE {AROS_32BIT_FASTMAX}              CONST
       NATIVE {AROS_64BIT_FASTMAX}          CONST

/*
    The SP_OFFSET should be defined *ONLY* when not defined before.
    Otherwise it would redefine defaults from cpu-arch.h or machine.h file
*/
->NATIVE {SP_OFFSET}       CONST SP_OFFSET       = 0

NATIVE {AROS_COMPAT_SETD0} CONST	->AROS_COMPAT_SETD0(x) (void)x

/* These macros will produce a value that can be stored in a AROS_64BIT_TYPE */
NATIVE {AROS_MAKE_INT64} CONST	->AROS_MAKE_INT64(i)  i # #LL
NATIVE {AROS_MAKE_UINT64} CONST	->AROS_MAKE_UINT64(i) i # #ULL

NATIVE {STACKED} CONST
