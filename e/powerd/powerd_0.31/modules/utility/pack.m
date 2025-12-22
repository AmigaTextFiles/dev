/*
**	$VER: pack.m 39.3 (10.2.1993)
**	Includes Release 44.1
**
**	Control attributes for Pack/UnpackStructureTags()
**
**	(C) Copyright 1992-1999 Amiga, Inc.
**	All Rights Reserved
*/

MODULE	'utility/tagitem'

/* PackTable definition:
 *
 * The PackTable is a simple array of LONGWORDS that are evaluated by
 * PackStructureTags() and UnpackStructureTags().
 *
 * The table contains compressed information such as the tag offset from
 * the base tag. The tag offset has a limited range so the base tag is
 * defined in the first longword.
 *
 * After the first longword, the fields look as follows:
 *
 *	+--------- 1 = signed, 0 = unsigned (for bits, 1=inverted boolean)
 *	|
 *	|  +------ 00 = Pack/Unpack, 10 = Pack, 01 = Unpack, 11 = special
 *	| / \
 *	| | |  +-- 00 = Byte, 01 = Word, 10 = Long, 11 = Bit
 *	| | | / \
 *	| | | | | /----- For bit operations: 1 = TAG_EXISTS is TRUE
 *	| | | | | |
 *	| | | | | | /-------------------- Tag offset from base tag value
 *	| | | | | | |		      \
 *	m n n o o p q q q q q q q q q q r r r s s s s s s s s s s s s s
 *					\   | |		      |
 *	Bit offset (for bit operations) ----/ |		      |
 *					      \ 		      |
 *	Offset into data structure -----------------------------------/
 *
 * A -1 longword signifies that the next longword will be a new base tag
 *
 * A 0 longword signifies that it is the end of the pack table.
 *
 * What this implies is that there are only 13-bits of address offset
 * and 10 bits for tag offsets from the base tag.  For most uses this
 * should be enough, but when this is not, either multiple pack tables
 * or a pack table with extra base tags would be able to do the trick.
 * The goal here was to make the tables small and yet flexible enough to
 * handle most cases.
 */
FLAG	PST_SIGNED=31,
		PST_UNPACK=30,		/* Note that these are active low... */
		PST_PACK=29,		/* Note that these are active low... */
		PST_EXISTS=26		/* Tag exists bit true flag hack...  */

CONST	PKCTRL_PACKUNPACK=0,
		PKCTRL_PACKONLY=$40000000,
		PKCTRL_UNPACKONLY=$20000000,
		PKCTRL_BYTE=$80000000,
		PKCTRL_WORD=$88000000,
		PKCTRL_LONG=$90000000,
		PKCTRL_UBYTE=0,
		PKCTRL_UWORD=$8000000,
		PKCTRL_ULONG=$10000000,
		PKCTRL_BIT=$18000000,
		PKCTRL_FLIPBIT=$98000000

/* Macros used by the next batch of macros below. Normally, you don't use
 * this batch directly. Then again, some folks are wierd
 */
#define PK_BITNUM1(flg)					(IF (flg)=$01 THEN 0 ELSE IF (flg)=$02 THEN 1 ELSE IF (flg)=$04 THEN 2 ELSE IF (flg)=$08 THEN 3 ELSE IF (flg)=$10 THEN 4 ELSE IF (flg)=$20 THEN 5 ELSE IF (flg)=$40 THEN 6 ELSE 7)
#define PK_BITNUM2(flg)					(IF (flg)<$100 THEN PK_BITNUM1(flg) ELSE 8+PK_BITNUM1(flg>>8))
#define PK_BITNUM(flg)					(IF (flg)<$10000 THEN PK_BITNUM2(flg) ELSE 16+PK_BITNUM2(flg>>16))
#define PK_WORDOFFSET(flg)				(IF (flg)<$100 THEN 1 ELSE 0)
#define PK_LONGOFFSET(flg)				(IF (flg)<$100 THEN 3 ELSE IF (flg)<$10000 THEN 2 ELSE IF (flg)<$1000000 THEN 1 ELSE 0)
#define PK_CALCOFFSET(type,field)	(&0::type.field)

/* Some handy dandy macros to easily create pack tables
 *
 * Use PACK_STARTTABLE() at the start of a pack table. You pass it the
 * base tag value that will be handled in the following chunk of the pack
 * table.
 *
 * PACK_ENDTABLE() is used to mark the end of a pack table.
 *
 * PACK_NEWOFFSET() lets you change the base tag value used for subsequent
 * entries in the table
 *
 * PACK_ENTRY() lets you define an entry in the pack table. You pass it the
 * base tag value, the tag of interest, the type of the structure to use,
 * the field name in the structure to affect and control bits (combinations of
 * the various PKCTRL_XXX bits)
 *
 * PACK_BYTEBIT() lets you define a bit-control entry in the pack table. You
 * pass it the same data as PACK_ENTRY, plus the flag bit pattern this tag
 * affects. This macro should be used when the field being affected is byte
 * sized.
 *
 * PACK_WORDBIT() lets you define a bit-control entry in the pack table. You
 * pass it the same data as PACK_ENTRY, plus the flag bit pattern this tag
 * affects. This macro should be used when the field being affected is word
 * sized.
 *
 * PACK_LONGBIT() lets you define a bit-control entry in the pack table. You
 * pass it the same data as PACK_ENTRY, plus the flag bit pattern this tag
 * affects. This macro should be used when the field being affected is longword
 * sized.
 *
 * EXAMPLE:
 *
 *    ULONG packTable[] =
 *    {
 *	   PACK_STARTTABLE(GA_Dummy),
 *	   PACK_ENTRY(GA_Dummy,GA_Left,Gadget,LeftEdge,PKCTRL_WORD|PKCTRL_PACKUNPACK),
 *	   PACK_ENTRY(GA_Dummy,GA_Top,Gadget,TopEdge,PKCTRL_WORD|PKCTRL_PACKUNPACK),
 *	   PACK_ENTRY(GA_Dummy,GA_Width,Gadget,Width,PKCTRL_UWORD|PKCTRL_PACKUNPACK),
 *	   PACK_ENTRY(GA_Dummy,GA_Height,Gadget,Height,PKCTRL_UWORD|PKCTRL_PACKUNPACK),
 *	   PACK_WORDBIT(GA_Dummy,GA_RelVerify,Gadget,Activation,PKCTRL_BIT|PKCTRL_PACKUNPACK,GACT_RELVERIFY)
 *	   PACK_ENDTABLE
 *    };
 */
#define	PACK_STARTTABLE(tagbase)			(tagbase)
#define	PACK_NEWOFFSET(tagbase)			(-1),(tagbase)
CONST		PACK_ENDTABLE=0
#define	PACK_ENTRY(tagbase,tag,type,field,control)	   (control | ((tag-tagbase) << 16) | PK_CACOFFSET(type,field))
#define	PACK_BYTEBIT(tagbase,tag,type,field,control,flags) (control | ((tag-tagbase) << 16) | PK_CACOFFSET(type,field) | (PK_BITNUM(flags) << 13))
#define	PACK_WORDBIT(tagbase,tag,type,field,control,flags) (control | ((tag-tagbase) << 16) | (PK_CACOFFSET(type,field)+PK_WORDOFFSET(flags)) | ((PK_BITNUM(flags)&7) << 13))
#define	PACK_LONGBIT(tagbase,tag,type,field,control,flags) (control | ((tag-tagbase) << 16) | (PK_CACOFFSET(type,field)+PK_LONGOFFSET(flags)) | ((PK_BITNUM(flags)&7) << 13))
