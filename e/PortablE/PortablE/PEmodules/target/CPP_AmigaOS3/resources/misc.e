/* $VER: misc.h 36.13 (6.5.1990) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/libraries'
{#include <resources/misc.h>}
NATIVE {RESOURCES_MISC_H} CONST

/*
 * Unit number definitions.  Ownership of a resource grants low-level
 * bit access to the hardware registers.  You are still obligated to follow
 * the rules for shared access of the interrupt system (see
 * exec.library/SetIntVector or cia.resource as appropriate).
 */
NATIVE {MR_SERIALPORT}	CONST MR_SERIALPORT	= 0 /* Amiga custom chip serial port registers
			     (SERDAT,SERDATR,SERPER,ADKCON, and interrupts) */
NATIVE {MR_SERIALBITS}	CONST MR_SERIALBITS	= 1 /* Serial control bits (DTR,CTS, etc.) */
NATIVE {MR_PARALLELPORT}	CONST MR_PARALLELPORT	= 2 /* The 8 bit parallel data port
			     (CIAAPRA & CIAADDRA only!) */
NATIVE {MR_PARALLELBITS}	CONST MR_PARALLELBITS	= 3 /* All other parallel bits & interrupts
			     (BUSY,ACK,etc.) */

/*
 * Library vector offset definitions
 */
NATIVE {MR_ALLOCMISCRESOURCE}	CONST MR_ALLOCMISCRESOURCE	= (LIB_BASE)		/* -6 */
NATIVE {MR_FREEMISCRESOURCE}	CONST MR_FREEMISCRESOURCE	= (LIB_BASE-LIB_VECTSIZE)	/* -12 */

NATIVE {MISCNAME} CONST
#define MISCNAME miscname
STATIC miscname = 'misc.resource'
