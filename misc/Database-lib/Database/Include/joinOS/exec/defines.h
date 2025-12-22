/* defines.h
 *
 * Includefile used to make all necessary defines to run on a specific machine.
 *
 */

#ifndef _DEFINES_H_
#define _DEFINES_H_

/* ------ Defines ----------------------------------------------------------- */

/* Error codes set to LastError */
#define FAULT_NO_ERROR 0
#define FAULT_WRONG_OS_VERSION 1		/* Wrong version of system library */
#define FAULT_SYSTEM_ERROR 2			/* internal system error, the cause isn't known */
#define FAULT_NO_MEMORY 3				/* out of memory (allocation failed) */

#ifdef _AMIGA

#include <exec/types.h>

#else

#ifndef __windows_h__
#include <windows.h>
#endif

#ifndef BOOL
#define BOOL unsigned long
#endif

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

#ifndef UBYTE
#define UBYTE unsigned char
#endif

#ifndef BYTE
#define BYTE signed char
#endif

#ifndef WORD
#define WORD signed short
#endif

#ifndef UWORD
#define UWORD unsigned short
#endif

#ifndef LONG
#define LONG signed long
#endif

#ifndef ULONG
#define ULONG unsigned long
#endif

#ifndef APTR
#define APTR void*
#endif

#ifndef STRPTR
#define STRPTR unsigned char*
#endif

#ifdef NULL		/* redefine NULL, typeless ! */
	#undef NULL
#endif
#define NULL 0L

#endif			/* _AMIGA */

#ifndef SWORD
#define SWORD signed short
#endif

/* Every 64bit math-function expects a pointer to the DOUBLELONG as argument
 * (a DOUBLELONG is an array of two LONG values, the first LONG gets/holds
 * the upper significant 32 bits, the second LONG gets/holds the lower 32
 * bits).
 */
#ifndef DOUBLELONG
typedef struct {ULONG high; ULONG low;} DOUBLELONG;
#endif

#ifndef MAX_DOUBLELONG
#define MAX_DOUBLELONG 9223372036854775807
#endif

#ifndef MIN_DOUBLELONG
#define MIN_DOUBLELONG -9223372036854775808
#endif

#endif			/* _DEFINES_H_ */
