 /* Copyright © 1995-1999 Dipl.-Inform. Kai Hofmann. All rights reserved. */


 #ifndef SYSTEM_H
   #define SYSTEM_H


   #include "debug.h"


   #define _ISO8859_Latin1
   #include <exec/types.h>


   #define bool				BOOL
   #define true				TRUE
   #define false			FALSE


   #ifdef __cplusplus
     #undef __MakeLib
     #define VAR(n)			&n
     #define VAL(n)			n
     #define ARG(n)			n
     /* SAS-C workaround */
     #define SNAME(n)			n ## ENUM
     #define INLINE			inline
   #else
     #define VAR(n)			*const n
     #define VAL(n)			(*n)
     #define ARG(n)			&n
     /* SAS-C workaround */
     #define SNAME(n)
     #define INLINE			__inline
   #endif


   #ifdef __MakeLib
     #define ALIGNED			__aligned
     #define FAR			__far
     #define STACKARGS			__stdargs
     #define REGISTERARGS		__regargs
     #define ASM			__asm
     #define SAVEDS			__saveds
     #define SAVEDS_ASM			__saveds __asm
     #define DLL_EXPORT
     #define DLL_IMPORT
     #define D0				__d0
     #define D1				__d1
     #define D2				__d2
     #define D3				__d3
     #define D4				__d4
     #define D5				__d5
     #define D6				__d6
     #define D7				__d7
     #define A0				__a0
     #define A1				__a1
     #define A2				__a2
     #define A3				__a3
     #define A4				__a4
     #define A5				__a5
     #define A6				__a6
     #define REG(r)			register r
     #define GCCREG(r)
     #define INIT(modul,libbase)	long SAVEDS_ASM __UserLibInit(REG(A6) struct Library *base)
     #define CLEAN(modul,libbase)	void SAVEDS_ASM __UserLibCleanup(REG(A6) struct Library *base)
     #define INITPROTO(modul,libbase)
     #define CLEANPROTO(modul,libbase)
     #define INITCALL(modul,libbase)
     #define CLEANCALL(modul,libbase)
   #else
     #define ALIGNED			__aligned
     #define FAR			__far
     #define STACKARGS			__stdargs
     #define REGISTERARGS		__regargs
     #define ASM
     #define SAVEDS
     #define SAVEDS_ASM
     #define DLL_EXPORT
     #define DLL_IMPORT
     #define REG(r)
     #define GCCREG(r)
     #define INIT(modul,libbase)	void _STI_600__ ## modul ## Init(void)
     #define CLEAN(modul,libbase)	void _STD_600__ ## modul ## Cleanup(void)
     #define INITPROTO(modul,libbase)
     #define CLEANPROTO(modul,libbase)
     #define INITCALL(modul,libbase)
     #define CLEANCALL(modul,libbase)
   #endif
 #endif
