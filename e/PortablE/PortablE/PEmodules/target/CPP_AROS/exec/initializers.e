/* $Id: initializers.h 18668 2003-07-19 02:59:06Z iaint $ */
OPT NATIVE, PREPROCESS
MODULE 'target/aros/system'
{#include <exec/initializers.h>}
NATIVE {EXEC_INITIALIZERS_H} CONST

NATIVE {OFFSET} CONST	->OFFSET(structName, structEntry) (&(((struct structName *) 0)->structEntry))

#ifdef AROS_BIG_ENDIAN
NATIVE {INITBYTE} CONST	->INITBYTE(offset,value)  0xe000,(UWORD) (offset),(UWORD) ((value)<<8)
NATIVE {INITWORD} CONST	->INITWORD(offset,value)  0xd000,(UWORD) (offset),(UWORD) (value)
NATIVE {INITLONG} CONST	->INITLONG(offset,value)  0xc000,(UWORD) (offset), (UWORD) ((value)>>16), (UWORD) ((value) & 0xffff)
NATIVE {INITSTRUCT} CONST	->INITSTRUCT(size,offset,value,count) (UWORD) (0xc000|(size<<12)|(count<<8)| ((UWORD) ((offset)>>16)), ((UWORD) (offset)) & 0xffff)
#else
NATIVE {INITBYTE} CONST	->INITBYTE(offset,value)  (0x00e0 | ((((ULONG)offset) & 0xff) << 8)),(UWORD) (((ULONG)offset) >> 8),(UWORD) ((value) & 0xff)
NATIVE {INITWORD} CONST	->INITWORD(offset,value)  (0x00d0 | ((((ULONG)offset) & 0xff) << 8)),(UWORD) (((ULONG)offset) >> 8),(UWORD) (value)
NATIVE {INITLONG} CONST	->INITLONG(offset,value)  (0x00c0 | ((((ULONG)offset) & 0xff) << 8)),(UWORD) (((ULONG)offset) >> 8),(UWORD) ((value) & 0xffff), (UWORD) ((value) >> 16)
NATIVE {INITSTRUCT} CONST	->INITSTRUCT(size,offset,value,count) (UWORD) (0x00c0|((size)<<4)|((count)<<0)| ((UWORD) ((((ULONG)offset) & 0xff) << 8))), ((UWORD) (((ULONG)offset) >> 8))
#endif
