@DATABASE "gg:doc/NDK/Guide/Include/utility/pack.h"
@MASTER   "gg:os-include/utility/pack.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:33
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "utility/pack.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"utility/pack.h" LINK File}


@{b}#defines@{ub}

@{"PACK_BYTEBIT()" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 165}    @{"PACK_ENDTABLE" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 163}      @{"PACK_ENTRY()" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 164}       @{"PACK_LONGBIT()" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 167}
@{"PACK_NEWOFFSET()" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 162}  @{"PACK_STARTTABLE()" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 161}  @{"PACK_WORDBIT()" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 166}     @{"PK_BITNUM()" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 107}
@{"PK_BITNUM1()" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 105}      @{"PK_BITNUM2()" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 106}       @{"PK_CALCOFFSET()" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 110}    @{"PK_LONGOFFSET()" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 109}
@{"PK_WORDOFFSET()" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 108}   @{"PKCTRL_BIT" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 94}         @{"PKCTRL_BYTE" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 86}        @{"PKCTRL_FLIPBIT" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 95}
@{"PKCTRL_LONG" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 88}       @{"PKCTRL_PACKONLY" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 83}    @{"PKCTRL_PACKUNPACK" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 82}  @{"PKCTRL_UBYTE" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 90}
@{"PKCTRL_ULONG" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 92}      @{"PKCTRL_UNPACKONLY" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 84}  @{"PKCTRL_UWORD" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 91}       @{"PKCTRL_WORD" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 87}
@{"PSTB_EXISTS" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 70}       @{"PSTB_PACK" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 69}          @{"PSTB_SIGNED" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 67}        @{"PSTB_UNPACK" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 68}
@{"PSTF_EXISTS" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 76}       @{"PSTF_PACK" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 74}          @{"PSTF_SIGNED" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 72}        @{"PSTF_UNPACK" LINK "gg:doc/NDK/Guide/Include/utility/pack.h/File" 73}

@ENDNODE
@NODE File "utility/pack.h"
#ifndef UTILITY_PACK_H
#define UTILITY_PACK_H
/*
**      $VER: pack.h 39.3 (10.2.1993)
**      Includes Release 45.1
**
**      Control attributes for Pack/@{"UnpackStructureTags()" LINK "gg:doc/NDK/Guide/utility/UnpackStructureTags"}
**
**      (C) Copyright 1992-2001 Amiga, Inc.
**      All Rights Reserved
*/

/*****************************************************************************/


#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif


/*****************************************************************************/


/* PackTable definition:
 *
 * The PackTable is a simple array of LONGWORDS that are evaluated by
 * @{"PackStructureTags()" LINK "gg:doc/NDK/Guide/utility/PackStructureTags"} and @{"UnpackStructureTags()" LINK "gg:doc/NDK/Guide/utility/UnpackStructureTags"}.
 *
 * The table contains compressed information such as the tag offset from
 * the base tag. The tag offset has a limited range so the base tag is
 * defined in the first longword.
 *
 * After the first longword, the fields look as follows:
 *
 *      +--------- 1 = signed, 0 = unsigned (for bits, 1=inverted boolean)
 *      |
 *      |  +------ 00 = Pack/Unpack, 10 = Pack, 01 = Unpack, 11 = special
 *      | / \\
 *      | | |  +-- 00 = Byte, 01 = Word, 10 = Long, 11 = Bit
 *      | | | / \\
 *      | | | | | /----- For bit operations: 1 = TAG_EXISTS is @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}
 *      | | | | | |
 *      | | | | | | /-------------------- Tag offset from base tag value
 *      | | | | | | |                 \\
 *      m n n o o p q q q q q q q q q q r r r s s s s s s s s s s s s s
 *                                      \\   | |               |
 *      Bit offset (for bit operations) ----/ |               |
 *                                            \\                       |
 *      Offset into data structure -----------------------------------/
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

#define PSTB_SIGNED 31
#define PSTB_UNPACK 30    /* Note that these are active low... */
#define PSTB_PACK   29    /* Note that these are active low... */
#define PSTB_EXISTS 26    /* Tag exists bit true flag hack...  */

#define PSTF_SIGNED (1L << @{"PSTB_SIGNED" LINK File 67})
#define PSTF_UNPACK (1L << @{"PSTB_UNPACK" LINK File 68})
#define PSTF_PACK   (1L << @{"PSTB_PACK" LINK File 69})

#define PSTF_EXISTS (1L << @{"PSTB_EXISTS" LINK File 70})


/*****************************************************************************/


#define PKCTRL_PACKUNPACK 0x00000000
#define PKCTRL_PACKONLY   0x40000000
#define PKCTRL_UNPACKONLY 0x20000000

#define PKCTRL_BYTE       0x80000000
#define PKCTRL_WORD       0x88000000
#define PKCTRL_LONG       0x90000000

#define PKCTRL_UBYTE      0x00000000
#define PKCTRL_UWORD      0x08000000
#define PKCTRL_ULONG      0x10000000

#define PKCTRL_BIT        0x18000000
#define PKCTRL_FLIPBIT    0x98000000


/*****************************************************************************/


/* Macros used by the next batch of macros below. Normally, you don't use
 * this batch directly. Then again, some folks are wierd
 */

#define PK_BITNUM1(flg) ((flg) == 0x01 ? 0 : (flg) == 0x02 ? 1 : (flg) == 0x04 ? 2 : (flg) == 0x08 ? 3 : (flg) == 0x10 ? 4 : (flg) == 0x20 ? 5 : (flg) == 0x40 ? 6 : 7)
#define PK_BITNUM2(flg) ((flg < 0x100 ? @{"PK_BITNUM1" LINK File 105}(flg) : 8+@{"PK_BITNUM1" LINK File 105}(flg >> 8)))
#define PK_BITNUM(flg) ((flg < 0x10000 ? @{"PK_BITNUM2" LINK File 106}(flg) : 16+@{"PK_BITNUM2" LINK File 106}(flg >> 16)))
#define PK_WORDOFFSET(flg) ((flg) < 0x100 ? 1 : 0)
#define PK_LONGOFFSET(flg) ((flg) < 0x100  ? 3 : (flg) < 0x10000 ? 2 : (flg) < 0x1000000 ? 1 : 0)
#define PK_CALCOFFSET(type,field) ((@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52})(&((struct type *)0)->field))


/*****************************************************************************/


/* Some handy dandy macros to easily create pack tables
 *
 * Use @{"PACK_STARTTABLE" LINK File 161}() at the start of a pack table. You pass it the
 * base tag value that will be handled in the following chunk of the pack
 * table.
 *
 * @{"PACK_ENDTABLE" LINK File 163}() is used to mark the end of a pack table.
 *
 * @{"PACK_NEWOFFSET" LINK File 162}() lets you change the base tag value used for subsequent
 * entries in the table
 *
 * @{"PACK_ENTRY" LINK File 164}() lets you define an entry in the pack table. You pass it the
 * base tag value, the tag of interest, the type of the structure to use,
 * the field name in the structure to affect and control bits (combinations of
 * the various PKCTRL_XXX bits)
 *
 * @{"PACK_BYTEBIT" LINK File 165}() lets you define a bit-control entry in the pack table. You
 * pass it the same data as @{"PACK_ENTRY" LINK File 164}, plus the flag bit pattern this tag
 * affects. This macro should be used when the field being affected is byte
 * sized.
 *
 * @{"PACK_WORDBIT" LINK File 166}() lets you define a bit-control entry in the pack table. You
 * pass it the same data as @{"PACK_ENTRY" LINK File 164}, plus the flag bit pattern this tag
 * affects. This macro should be used when the field being affected is word
 * sized.
 *
 * @{"PACK_LONGBIT" LINK File 167}() lets you define a bit-control entry in the pack table. You
 * pass it the same data as @{"PACK_ENTRY" LINK File 164}, plus the flag bit pattern this tag
 * affects. This macro should be used when the field being affected is longword
 * sized.
 *
 * EXAMPLE:
 *
 *    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} packTable[] =
 *    {
 *         @{"PACK_STARTTABLE" LINK File 161}(@{"GA_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 30}),
 *         @{"PACK_ENTRY" LINK File 164}(@{"GA_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 30},@{"GA_Left" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 32},Gadget,LeftEdge,@{"PKCTRL_WORD" LINK File 87}|@{"PKCTRL_PACKUNPACK" LINK File 82}),
 *         @{"PACK_ENTRY" LINK File 164}(@{"GA_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 30},@{"GA_Top" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 40},Gadget,TopEdge,@{"PKCTRL_WORD" LINK File 87}|@{"PKCTRL_PACKUNPACK" LINK File 82}),
 *         @{"PACK_ENTRY" LINK File 164}(@{"GA_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 30},@{"GA_Width" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 48},Gadget,Width,@{"PKCTRL_UWORD" LINK File 91}|@{"PKCTRL_PACKUNPACK" LINK File 82}),
 *         @{"PACK_ENTRY" LINK File 164}(@{"GA_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 30},@{"GA_Height" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 55},Gadget,Height,@{"PKCTRL_UWORD" LINK File 91}|@{"PKCTRL_PACKUNPACK" LINK File 82}),
 *         @{"PACK_WORDBIT" LINK File 166}(@{"GA_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 30},@{"GA_RelVerify" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 110},Gadget,Activation,@{"PKCTRL_BIT" LINK File 94}|@{"PKCTRL_PACKUNPACK" LINK File 82},@{"GACT_RELVERIFY" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 383})
 *         @{"PACK_ENDTABLE" LINK File 163}
 *    };
 */

#define PACK_STARTTABLE(tagbase)                           (tagbase)
#define PACK_NEWOFFSET(tagbase)                    (-1L),(tagbase)
#define PACK_ENDTABLE                                      0
#define PACK_ENTRY(tagbase,tag,type,field,control)         (control | ((tag-tagbase) << 16L) | @{"PK_CALCOFFSET" LINK File 110}(type,field))
#define PACK_BYTEBIT(tagbase,tag,type,field,control,flags) (control | ((tag-tagbase) << 16L) | @{"PK_CALCOFFSET" LINK File 110}(type,field) | (@{"PK_BITNUM" LINK File 107}(flags) << 13L))
#define PACK_WORDBIT(tagbase,tag,type,field,control,flags) (control | ((tag-tagbase) << 16L) | (@{"PK_CALCOFFSET" LINK File 110}(type,field)+@{"PK_WORDOFFSET" LINK File 108}(flags)) | ((@{"PK_BITNUM" LINK File 107}(flags)&7) << 13L))
#define PACK_LONGBIT(tagbase,tag,type,field,control,flags) (control | ((tag-tagbase) << 16L) | (@{"PK_CALCOFFSET" LINK File 110}(type,field)+@{"PK_LONGOFFSET" LINK File 109}(flags)) | ((@{"PK_BITNUM" LINK File 107}(flags)&7) << 13L))


/*****************************************************************************/


#endif /* UTILITY_PACK_H */
@ENDNODE
