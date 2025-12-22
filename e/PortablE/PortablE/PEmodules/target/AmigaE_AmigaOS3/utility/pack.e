/* $VER: pack.h 39.3 (10.2.1993) */
OPT NATIVE,INLINE
MODULE 'target/exec/types', 'target/utility/tagitem'
{MODULE 'utility/pack'}

NATIVE {PSTB_SIGNED} CONST PSTB_SIGNED = 31
NATIVE {PSTB_UNPACK} CONST PSTB_UNPACK = 30	  /* Note that these are active low... */
NATIVE {PSTB_PACK}   CONST PSTB_PACK   = 29	  /* Note that these are active low... */
NATIVE {PSTB_EXISTS} CONST PSTB_EXISTS = 26	  /* Tag exists bit true flag hack...  */

NATIVE {PSTF_SIGNED} CONST PSTF_SIGNED = $80000000
NATIVE {PSTF_UNPACK} CONST PSTF_UNPACK = $40000000
NATIVE {PSTF_PACK}   CONST PSTF_PACK   = $20000000

NATIVE {PSTF_EXISTS} CONST PSTF_EXISTS = $04000000


/*****************************************************************************/


NATIVE {PKCTRL_PACKUNPACK} CONST PKCTRL_PACKUNPACK = $00000000
NATIVE {PKCTRL_PACKONLY}   CONST PKCTRL_PACKONLY   = $40000000
NATIVE {PKCTRL_UNPACKONLY} CONST PKCTRL_UNPACKONLY = $20000000

NATIVE {PKCTRL_BYTE}	  CONST PKCTRL_BYTE	  = $80000000
NATIVE {PKCTRL_WORD}	  CONST PKCTRL_WORD	  = $88000000
NATIVE {PKCTRL_LONG}	  CONST PKCTRL_LONG	  = $90000000

NATIVE {PKCTRL_UBYTE}	  CONST PKCTRL_UBYTE	  = $00000000
NATIVE {PKCTRL_UWORD}	  CONST PKCTRL_UWORD	  = $08000000
NATIVE {PKCTRL_ULONG}	  CONST PKCTRL_ULONG	  = $10000000

NATIVE {PKCTRL_BIT}	  CONST PKCTRL_BIT	  = $18000000
NATIVE {PKCTRL_FLIPBIT}	  CONST PKCTRL_FLIPBIT	  = $98000000


/*****************************************************************************/


/* Macros used by the next batch of macros below. Normally, you don't use
 * this batch directly. Then again, some folks are wierd
 */

PROC Pk_BitNum1(flg) IS IF flg=$01 THEN 0 ELSE IF flg=$02 THEN 1 ELSE IF flg=$04 THEN 2 ELSE IF flg=$08 THEN 3 ELSE IF flg=$10 THEN 4 ELSE IF flg=$20 THEN 5 ELSE IF flg=$40 THEN 6 ELSE 7
PROC Pk_BitNum2(flg) IS IF flg<$100 THEN Pk_BitNum1(flg) ELSE 8+Pk_BitNum1(Shr(flg,8))
PROC Pk_BitNum (flg) IS IF flg<$10000 THEN Pk_BitNum2(flg) ELSE 16+Pk_BitNum2(Shr(flg,16))
PROC Pk_WordOffset(flg) IS IF flg<$100 THEN 1 ELSE 0
PROC Pk_LongOffset(flg) IS IF flg<$100 THEN 3 ELSE IF flg<$10000 THEN 2 ELSE IF flg<$1000000 THEN 1 ELSE 0
->PROC Pk_CalcOffset(type,field)	->impossible to convert, although it's so hack-ish that I'm not sure I would even if I could...
