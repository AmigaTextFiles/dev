#ifndef UTILITY_PACK_H
#define UTILITY_PACK_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef UTILITY_TAGITEM_H
MODULE  'utility/tagitem'
#endif


#define	PSTB_SIGNED 31
#define PSTB_UNPACK 30	  
#define PSTB_PACK   29	  
#define	PSTB_EXISTS 26	  
#define	PSTF_SIGNED (1 << PSTB_SIGNED)
#define PSTF_UNPACK (1 << PSTB_UNPACK)
#define PSTF_PACK   (1 << PSTB_PACK)
#define	PSTF_EXISTS (1 << PSTB_EXISTS)

#define PKCTRL_PACKUNPACK $00000000
#define PKCTRL_PACKONLY   $40000000
#define PKCTRL_UNPACKONLY $20000000
#define PKCTRL_BYTE	  $80000000
#define PKCTRL_WORD	  $88000000
#define PKCTRL_LONG	  $90000000
#define PKCTRL_UBYTE	  $00000000
#define PKCTRL_UWORD	  $08000000
#define PKCTRL_ULONG	  $10000000
#define PKCTRL_BIT	  $18000000
#define PKCTRL_FLIPBIT	  $98000000


#define PK_BITNUM1(flg) ((flg) := $01 ? 0 : (flg) := $02 ? 1 : (flg) := $04 ? 2 : (flg) := $08 ? 3 : (flg) := $10 ? 4 : (flg) := $20 ? 5 : (flg) := $40 ? 6 : 7)
#define PK_BITNUM2(flg) ((flg < $100 ? PK_BITNUM1(flg) : 8+PK_BITNUM1(flg >> 8)))
#define PK_BITNUM(flg) ((flg < $10000 ? PK_BITNUM2(flg) : 16+PK_BITNUM2(flg >> 16)))
#define PK_WORDOFFSET(flg) ((flg) < $100 ? 1 : 0)
#define PK_LONGOFFSET(flg) ((flg) < $100  ? 3 : (flg) < $10000 ? 2 : (flg) < $1000000 ? 1 : 0)
#define PK_CALCOFFSET(type,field) ((&(  0).field))


#define PACK_STARTTABLE(tagbase)			   (tagbase)
#define PACK_NEWOFFSET(tagbase)			   (-1),(tagbase)
#define PACK_ENDTABLE					   0
#define PACK_ENTRY(tagbase,tag,type,field,control)	   (control OR ((tag-tagbase) << 16) OR PK_CALCOFFSET(type,field))
#define PACK_BYTEBIT(tagbase,tag,type,field,control,flags) (control OR ((tag-tagbase) << 16) OR PK_CALCOFFSET(type,field) OR (PK_BITNUM(flags) << 13))
#define PACK_WORDBIT(tagbase,tag,type,field,control,flags) (control OR ((tag-tagbase) << 16) OR (PK_CALCOFFSET(type,field)+PK_WORDOFFSET(flags)) OR ((PK_BITNUM(flags)&7) << 13))
#define PACK_LONGBIT(tagbase,tag,type,field,control,flags) (control OR ((tag-tagbase) << 16) OR (PK_CALCOFFSET(type,field)+PK_LONGOFFSET(flags)) OR ((PK_BITNUM(flags)&7) << 13))

#endif 
