@DATABASE "gg:doc/NDK/Guide/Include/images/penmap.h"
@MASTER   "gg:os-include/images/penmap.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:23
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "images/penmap.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"images/penmap.h" LINK File}


@{b}#defines@{ub}

@{"IMAGE_CHUNKY" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 71}       @{"IMAGE_DRAWLIST" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 73}      @{"IMAGE_HEIGHT()" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 81}
@{"IMAGE_IMAGE" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 72}        @{"IMAGE_WIDTH()" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 78}       @{"PENMAP_ColorMap" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 57}
@{"PENMAP_Dummy" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 27}       @{"PENMAP_ImageType" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 47}    @{"PENMAP_MaskBlit" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 60}
@{"PENMAP_Palette" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 41}     @{"PENMAP_Precision" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 54}    @{"PENMAP_RenderBGPen" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 35}
@{"PENMAP_RenderData" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 38}  @{"PENMAP_Screen" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 44}       @{"PENMAP_SelectBGPen" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 29}
@{"PENMAP_SelectData" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 32}  @{"PENMAP_Transparent" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File" 50}  

@ENDNODE
@NODE File "images/penmap.h"
#ifndef IMAGES_PENMAP_H
#define IMAGES_PENMAP_H
/*
**      $VER: penmap.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the penmap.image BOOPSI class
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

/* Additional attributes defined by penmap.image
 */
#define PENMAP_Dummy                    (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x18000)

#define PENMAP_SelectBGPen              (@{"PENMAP_Dummy" LINK File 27} + 1)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Selected render background pen. */

#define PENMAP_SelectData               (@{"PENMAP_Dummy" LINK File 27} + 2)
        /* () Optional renderng data for mode @{"IDS_SELECTED" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 198}. */

#define PENMAP_RenderBGPen              @{"IA_BGPen" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 40}
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Background pen. */

#define PENMAP_RenderData               @{"IA_Data" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 42}
        /* () rendering data for mode @{"IDS_NORMAL" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 197}. */

#define PENMAP_Palette                  (@{"PENMAP_Dummy" LINK File 27} + 3)
        /* () @{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}/@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}/@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66} palette data. */

#define PENMAP_Screen                   (@{"PENMAP_Dummy" LINK File 27} + 4)
        /* (@{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *) Screen this penmap will be displayed in. */

#define PENMAP_ImageType                (@{"PENMAP_Dummy" LINK File 27} + 5)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Currently Unsupported. */

#define PENMAP_Transparent              (@{"PENMAP_Dummy" LINK File 27} + 6)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) @{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}/@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65} - If set, color entry 0 will map
         * to screen/window background pen. */

#define PENMAP_Precision                (@{"PENMAP_Dummy" LINK File 27} + 8)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) @{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}/@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65} -@{"ObtainBestPen" LINK "gg:doc/NDK/Guide/graphics/ObtainBestPenA"} precision, defaults to @{"PRECISION_IMAGE" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 239} */

#define PENMAP_ColorMap                 (@{"PENMAP_Dummy" LINK File 27} + 9)
        /* (@{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *) @{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}/@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65} - ColorMap to use when remapping pens */

#define PENMAP_MaskBlit                 (@{"PENMAP_Dummy" LINK File 27} + 10)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Blit image using blitmask for true transparancy, recommended
         * when a penmap is used in a layout group for a logo, allowing the backfill
         * to show thru/around the image. Penmap will automatically create the
         * required mask plane for you.
         */

/*****************************************************************************/

/* Definitions for @{"PENMAP_ImageType" LINK File 47}
 */
#define IMAGE_CHUNKY    0       /* Supported Default */
#define IMAGE_IMAGE             1       /* Currently unsupported. */
#define IMAGE_DRAWLIST  2       /* Currently unsupported. */

/* Macros to extract the source width and height data.
 */
#ifndef IMAGE_WIDTH
#define IMAGE_WIDTH(i)   (((@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} *)(i))[0])
#endif
#ifndef IMAGE_HEIGHT
#define IMAGE_HEIGHT(i) (((@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} *)(i))[1])
#endif

#endif /* IMAGES_PENMAP_H */
@ENDNODE
