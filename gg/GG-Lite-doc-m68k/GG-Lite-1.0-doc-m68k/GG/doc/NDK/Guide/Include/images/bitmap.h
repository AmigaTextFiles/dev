@DATABASE "gg:doc/NDK/Guide/Include/images/bitmap.h"
@MASTER   "gg:os-include/images/bitmap.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:20
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "images/bitmap.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"images/bitmap.h" LINK File}


@{b}#defines@{ub}

@{"BITMAP_BitMap" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 44}         @{"BITMAP_Dummy" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 25}          @{"BITMAP_Height" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 50}
@{"BITMAP_Masking" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 41}        @{"BITMAP_MaskPlane" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 53}      @{"BITMAP_OffsetX" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 71}
@{"BITMAP_OffsetY" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 74}        @{"BITMAP_Precision" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 38}      @{"BITMAP_Screen" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 35}
@{"BITMAP_SelectBitMap" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 59}   @{"BITMAP_SelectHeight" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 65}   @{"BITMAP_SelectMaskPlane" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 68}
@{"BITMAP_SelectOffsetX" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 77}  @{"BITMAP_SelectOffsetY" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 80}  @{"BITMAP_SelectSourceFile" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 56}
@{"BITMAP_SelectWidth" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 62}    @{"BITMAP_SourceFile" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 32}     @{"BITMAP_Width" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File" 47}

@ENDNODE
@NODE File "images/bitmap.h"
#ifndef IMAGES_BITMAP_H
#define IMAGES_BITMAP_H
/*
**      $VER: bitmap.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the bitmap.image BOOPSI class
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef REACTRION_REACTION_H
#include <@{"reaction/reaction.h" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File"}>
#endif

#ifndef INTUITION_IMAGECLASS_H
#include <@{"intuition/imageclass.h" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File"}>
#endif

/*****************************************************************************/

#define BITMAP_Dummy               (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x19000)

/*****************************************************************************/

/* Additional attributes defined by the bitmap class
 */

#define BITMAP_SourceFile        (@{"BITMAP_Dummy" LINK File 25} + 1)
   /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) Filename of datatype object */

#define BITMAP_Screen            (@{"BITMAP_Dummy" LINK File 25} + 2)
   /* (@{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *) Screen to remap the datatype image to */

#define BITMAP_Precision         (@{"BITMAP_Dummy" LINK File 25} + 3)
   /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) OBP_PRECISION to use in remapping */

#define BITMAP_Masking           (@{"BITMAP_Dummy" LINK File 25} + 4)
   /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Mask image */

#define BITMAP_BitMap            (@{"BITMAP_Dummy" LINK File 25} + 5)
   /* (@{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *) Ready-to-use bitmap */

#define BITMAP_Width             (@{"BITMAP_Dummy" LINK File 25} + 6)
   /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Width of bitmap */

#define BITMAP_Height            (@{"BITMAP_Dummy" LINK File 25} + 7)
   /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Height of bitmap */

#define BITMAP_MaskPlane         (@{"BITMAP_Dummy" LINK File 25} + 8)
   /* (@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}) Masking plane */

#define BITMAP_SelectSourceFile  (@{"BITMAP_Dummy" LINK File 25} + 9)
   /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) */

#define BITMAP_SelectBitMap      (@{"BITMAP_Dummy" LINK File 25} + 10)
   /* (@{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} */

#define BITMAP_SelectWidth       (@{"BITMAP_Dummy" LINK File 25} + 11)
   /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) */

#define BITMAP_SelectHeight      (@{"BITMAP_Dummy" LINK File 25} + 12)
   /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) */

#define BITMAP_SelectMaskPlane   (@{"BITMAP_Dummy" LINK File 25} + 13)
   /* (@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}) */

#define BITMAP_OffsetX           (@{"BITMAP_Dummy" LINK File 25} + 14)
   /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) */

#define BITMAP_OffsetY           (@{"BITMAP_Dummy" LINK File 25} + 15)
   /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) */

#define BITMAP_SelectOffsetX     (@{"BITMAP_Dummy" LINK File 25} + 16)
   /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) */

#define BITMAP_SelectOffsetY     (@{"BITMAP_Dummy" LINK File 25} + 17)
   /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) */

/*****************************************************************************/

#endif /* IMAGES_BITMAP_H */
@ENDNODE
