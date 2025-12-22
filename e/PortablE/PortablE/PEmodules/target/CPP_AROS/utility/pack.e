/* $Id: pack.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/utility/tagitem'
{#include <utility/pack.h>}
NATIVE {UTILITY_PACK_H} CONST

NATIVE {PSTB_EXISTS}      CONST PSTB_EXISTS      = 26
NATIVE {PSTF_EXISTS} CONST PSTF_EXISTS = $4000000
NATIVE {PSTB_PACK}        CONST PSTB_PACK        = 29
NATIVE {PSTF_PACK}   CONST PSTF_PACK   = $20000000
NATIVE {PSTB_UNPACK}      CONST PSTB_UNPACK      = 30
NATIVE {PSTF_UNPACK} CONST PSTF_UNPACK = $40000000
NATIVE {PSTB_SIGNED}      CONST PSTB_SIGNED      = 31
NATIVE {PSTF_SIGNED} CONST PSTF_SIGNED = $80000000

NATIVE {PKCTRL_UBYTE}      CONST PKCTRL_UBYTE      = $00000000
NATIVE {PKCTRL_BYTE}       CONST PKCTRL_BYTE       = $80000000
NATIVE {PKCTRL_UWORD}      CONST PKCTRL_UWORD      = $08000000
NATIVE {PKCTRL_WORD}       CONST PKCTRL_WORD       = $88000000
NATIVE {PKCTRL_ULONG}      CONST PKCTRL_ULONG      = $10000000
NATIVE {PKCTRL_LONG}       CONST PKCTRL_LONG       = $90000000
NATIVE {PKCTRL_PACKUNPACK} CONST PKCTRL_PACKUNPACK = $00000000
NATIVE {PKCTRL_UNPACKONLY} CONST PKCTRL_UNPACKONLY = $20000000
NATIVE {PKCTRL_PACKONLY}   CONST PKCTRL_PACKONLY   = $40000000
NATIVE {PKCTRL_BIT}        CONST PKCTRL_BIT        = $18000000
NATIVE {PKCTRL_FLIPBIT}    CONST PKCTRL_FLIPBIT    = $98000000

/* Macros (don't use!) */

 NATIVE {PK_WORDOFFSET} CONST	->PK_WORDOFFSET(flag)
 NATIVE {PK_LONGOFFSET} CONST	->PK_LONGOFFSET(flag)

NATIVE {PK_CALCOFFSET} CONST	->PK_CALCOFFSET(type,field) ((IPTR)(&((struct type *)0)->field))
NATIVE {PK_BITNUM1} CONST	->PK_BITNUM1(flag) ((flag) == 0x01 ? 0 : (flag) == 0x02 ? 1 : (flag) == 0x04 ? 2 : (flag) == 0x08 ? 3 : (flag) == 0x10 ? 4 : (flag) == 0x20 ? 5 : (flag) == 0x40 ? 6 : 7)
NATIVE {PK_BITNUM2} CONST	->PK_BITNUM2(flag) ((flag) < 0x0100 ? PK_BITNUM1(flag) : 8 + PK_BITNUM1((flag)>>8))
NATIVE {PK_BITNUM} CONST	->PK_BITNUM(flag) ((flag) < 0x010000 ? PK_BITNUM2(flag) : 16 + PK_BITNUM2((flag)>>16))

PROC Pk_BitNum1(flg) IS NATIVE {PK_BITNUM1(} flg {)} ENDNATIVE !!VALUE
PROC Pk_BitNum2(flg) IS NATIVE {PK_BITNUM2(} flg {)} ENDNATIVE !!VALUE
PROC Pk_BitNum (flg) IS NATIVE {PK_BITNUM(} flg {)} ENDNATIVE !!VALUE
PROC Pk_WordOffset(flg) IS NATIVE {PK_WORDOFFSET(} flg {)} ENDNATIVE !!VALUE
PROC Pk_LongOffset(flg) IS NATIVE {PK_LONGOFFSET(} flg {)} ENDNATIVE !!VALUE
->PROC Pk_CalcOffset(type,field)	->impossible to convert, although it's so hack-ish that I'm not sure I would even if I could...

/* Macros to create pack tables */
NATIVE {PACK_STARTTABLE} CONST	->PACK_STARTTABLE(tagbase) (tagbase)
NATIVE {PACK_NEWOFFSET} CONST	->PACK_NEWOFFSET(tagbase)  (-1L),(tagbase)
NATIVE {PACK_ENDTABLE}            CONST PACK_ENDTABLE            = 0
NATIVE {PACK_ENTRY} CONST	->PACK_ENTRY(tagbase,tag,type,field,control) (control | ((tag - tagbase)<<16L) | PK_CALCOFFSET(type,field))
NATIVE {PACK_BYTEBIT} CONST	->PACK_BYTEBIT(tagbase,tag,type,field,control,flags) (control | ((tag - tagbase)<<16L) | PK_CALCOFFSET(type,field) | (PK_BITNUM(flags) <<13L))
NATIVE {PACK_WORDBIT} CONST	->PACK_WORDBIT(tagbase,tag,type,field,control,flags) (control | ((tag - tagbase)<<16L) | (PK_CALCOFFSET(type,field) + PK_WORDOFFSET(flags)) | ((PK_BITNUM(flags) & 7)<<13L))
NATIVE {PACK_LONGBIT} CONST	->PACK_LONGBIT(tagbase,tag,type,field,control,flags) (control | ((tag - tagbase)<<16L) | (PK_CALCOFFSET(type,field) + PK_LONGOFFSET(flags)) | ((PK_BITNUM(flags) & 7)<<13L))
