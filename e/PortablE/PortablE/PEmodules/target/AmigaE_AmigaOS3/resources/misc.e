/* $VER: misc.h 36.13 (6.5.1990) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/libraries'
{MODULE 'resources/misc'}

NATIVE {MR_SERIALPORT}	CONST MR_SERIALPORT	= 0 /* Amiga custom chip serial port registers
			     (SERDAT,SERDATR,SERPER,ADKCON, and interrupts) */
NATIVE {MR_SERIALBITS}	CONST MR_SERIALBITS	= 1 /* Serial control bits (DTR,CTS, etc.) */
NATIVE {MR_PARALLELPORT}	CONST MR_PARALLELPORT	= 2 /* The 8 bit parallel data port
			     (CIAAPRA & CIAADDRA only!) */
NATIVE {MR_PARALLELBITS}	CONST MR_PARALLELBITS	= 3 /* All other parallel bits & interrupts
			     (BUSY,ACK,etc.) */

NATIVE {MR_ALLOCMISCRESOURCE}	CONST MR_ALLOCMISCRESOURCE	= (LIB_BASE)		/* -6 */
NATIVE {MR_FREEMISCRESOURCE}	CONST MR_FREEMISCRESOURCE	= (LIB_BASE-LIB_VECTSIZE)	/* -12 */

NATIVE {MISCNAME} CONST
#define MISCNAME miscname
STATIC miscname = 'misc.resource'
