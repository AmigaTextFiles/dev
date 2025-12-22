/* $VER: initializers.h 39.0 (15.10.1991) */
OPT NATIVE
{#include <exec/initializers.h>}
NATIVE {EXEC_INITIALIZERS_H} CONST

NATIVE {OFFSET} CONST	/*OFFSET(structName, structEntry) 
						(&(((struct structName *) 0)->structEntry))*/
NATIVE {INITBYTE} CONST	->INITBYTE(offset,value)	0xe000,(UWORD) (offset),(UWORD) ((value)<<8)
NATIVE {INITWORD} CONST	->INITWORD(offset,value)	0xd000,(UWORD) (offset),(UWORD) (value)
NATIVE {INITLONG} CONST	/*INITLONG(offset,value)	0xc000,(UWORD) (offset), 
						(UWORD) ((value)>>16), 
						(UWORD) ((value) & 0xffff)*/
NATIVE {INITSTRUCT} CONST	/*INITSTRUCT(size,offset,value,count) 
							(UWORD) (0xc000|(size<<12)|(count<<8)| 
							((UWORD) ((offset)>>16)), 
							((UWORD) (offset)) & 0xffff)*/
