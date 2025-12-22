#ifndef __HOLLYWOOD_TYPES_H
#define __HOLLYWOOD_TYPES_H

#ifndef HW_64BIT
#if defined(_WIN64) || defined(__LP64__)
#define HW_64BIT
#endif
#endif

#if defined(HW_AMIGA)

	#include <exec/types.h>

	#if !defined(HW_AROS) && !defined(HW_MORPHOS)
		typedef unsigned long IPTR;
	#endif

#else

	typedef void *APTR;

	#ifndef _WINDOWS_	
		#if !defined(HW_WIN32) && defined(HW_64BIT)
			typedef unsigned int ULONG;
		#else
			typedef unsigned long ULONG;
		#endif
				
		typedef signed short WORD;		
	#endif
	
	typedef unsigned char UBYTE;
	typedef unsigned short UWORD;
	typedef unsigned char *STRPTR;

	#ifdef HW_64BIT
		#ifdef HW_WIN32
			typedef unsigned __int64 IPTR;
		#else
			typedef unsigned long IPTR;
		#endif
	#else
		typedef unsigned long IPTR;
	#endif
#endif

#endif


