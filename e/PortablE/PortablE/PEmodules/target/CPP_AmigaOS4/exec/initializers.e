/* $Id: initializers.h,v 1.14 2005/11/10 15:33:07 hjfrieden Exp $ */
OPT NATIVE
{#include <exec/initializers.h>}
NATIVE {EXEC_INITIALIZERS_H} CONST

NATIVE {OFFSET} CONST	->OFFSET(structName, structEntry) (&(((struct structName *) 0)->structEntry))

NATIVE {INITBYTE} CONST	->INITBYTE(offset,value) 0xe000, (UWORD)(offset), (UWORD)((value)<<8)
NATIVE {INITWORD} CONST	->INITWORD(offset,value) 0xd000, (UWORD)(offset), (UWORD)(value)
NATIVE {INITLONG} CONST	->INITLONG(offset,value) 0xc000, (UWORD)(offset), (UWORD)((value)>>16), (UWORD)((value) & 0xffff)
NATIVE {INITSTRUCT} CONST	->INITSTRUCT(size,offset,value,count) (UWORD) (0xc000|(size<<12)|(count<<8)| ((UWORD) ((offset)>>16)), ((UWORD) (offset)) & 0xffff)

/****************************************************************************/

/* These macros are used for the new InitData function */
NATIVE {IDATA_QUIT}        CONST IDATA_QUIT        = $ff000000
NATIVE {IDATA_CMOVE} CONST	->IDATA_CMOVE(n)    ((ULONG)(0x01000000|(ULONG)n))
NATIVE {IDATA_CSET} CONST	->IDATA_CSET(n)     ((ULONG)(0x02000000|(ULONG)n))
NATIVE {IDATA_COPY} CONST	->IDATA_COPY(n)     ((ULONG)(0x03000000|(ULONG)n))
NATIVE {IDATA_RPL} CONST	->IDATA_RPL(n)      ((ULONG)(0x04000000|(ULONG)n))
NATIVE {IDATA_RPW} CONST	->IDATA_RPW(n)      ((ULONG)(0x05000000|(ULONG)n))
NATIVE {IDATA_RPB} CONST	->IDATA_RPB(n)      ((ULONG)(0x06000000|(ULONG)n))
NATIVE {IDATA_OFFS} CONST	->IDATA_OFFS(n)     ((ULONG)(0x07000000|(ULONG)n))

NATIVE {IDATA_B1} CONST	->IDATA_B1(a)       ((ULONG)((ULONG)(a)<<24) )
NATIVE {IDATA_B2} CONST	->IDATA_B2(a,b)     ((ULONG)(((ULONG)(a)<<24) | ((ULONG)(b)<<16) ) )
NATIVE {IDATA_B3} CONST	->IDATA_B3(a,b,c)   ((ULONG)(((ULONG)(a)<<24) | ((ULONG)(b)<<16) | ((ULONG)(c)<<8) ) )
NATIVE {IDATA_B4} CONST	->IDATA_B4(a,b,c,d) ((ULONG)(((ULONG)(a)<<24) | ((ULONG)(b)<<16) | ((ULONG)(c)<<8) | (ULONG)(d) ) )

NATIVE {IDATA_W1} CONST	->IDATA_W1(a)       ((ULONG)((ULONG)(a)<<16))
NATIVE {IDATA_W2} CONST	->IDATA_W2(a,b)     ((ULONG)(((ULONG)(a)<<16) | ((ULONG)(b))))
