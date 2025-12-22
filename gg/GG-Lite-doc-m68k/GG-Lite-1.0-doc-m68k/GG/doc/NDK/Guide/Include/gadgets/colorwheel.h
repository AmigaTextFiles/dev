@DATABASE "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h"
@MASTER   "gg:os-include/gadgets/colorwheel.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:24
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/colorwheel.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/colorwheel.h" LINK File}


@{b}Structures@{ub}

@{"ColorWheelHSB" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 23}  @{"ColorWheelRGB" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 31}


@{b}#defines@{ub}

@{"WHEEL_Abbrv" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 50}     @{"WHEEL_BevelBox" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 52}    @{"WHEEL_Blue" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 47}            @{"WHEEL_Brightness" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 43}
@{"WHEEL_Donation" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 51}  @{"WHEEL_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 40}       @{"WHEEL_GradientSlider" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 53}  @{"WHEEL_Green" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 46}
@{"WHEEL_HSB" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 44}       @{"WHEEL_Hue" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 41}         @{"WHEEL_MaxPens" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 54}         @{"WHEEL_Red" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 45}
@{"WHEEL_RGB" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 48}       @{"WHEEL_Saturation" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 42}  @{"WHEEL_Screen" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 49}          

@ENDNODE
@NODE File "gadgets/colorwheel.h"
#ifndef GADGETS_COLORWHEEL_H
#define GADGETS_COLORWHEEL_H
/*
**      $VER: colorwheel.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the colorwheel BOOPSI class
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

/*****************************************************************************/


/* For use with the @{"WHEEL_HSB" LINK File 44} tag */
struct ColorWheelHSB
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} cw_Hue;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} cw_Saturation;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} cw_Brightness;
};

/* For use with the @{"WHEEL_RGB" LINK File 48} tag */
struct ColorWheelRGB
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} cw_Red;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} cw_Green;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} cw_Blue;
};

/*****************************************************************************/

#define WHEEL_Dummy          (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0x04000000)
#define WHEEL_Hue            (@{"WHEEL_Dummy" LINK File 40}+1)   /* set/get Hue              */
#define WHEEL_Saturation     (@{"WHEEL_Dummy" LINK File 40}+2)   /* set/get Saturation        */
#define WHEEL_Brightness     (@{"WHEEL_Dummy" LINK File 40}+3)   /* set/get Brightness        */
#define WHEEL_HSB            (@{"WHEEL_Dummy" LINK File 40}+4)   /* set/get ColorWheelHSB     */
#define WHEEL_Red            (@{"WHEEL_Dummy" LINK File 40}+5)   /* set/get Red               */
#define WHEEL_Green          (@{"WHEEL_Dummy" LINK File 40}+6)   /* set/get Green     */
#define WHEEL_Blue           (@{"WHEEL_Dummy" LINK File 40}+7)   /* set/get Blue              */
#define WHEEL_RGB            (@{"WHEEL_Dummy" LINK File 40}+8)   /* set/get ColorWheelRGB     */
#define WHEEL_Screen         (@{"WHEEL_Dummy" LINK File 40}+9)   /* init screen/enviroment    */
#define WHEEL_Abbrv          (@{"WHEEL_Dummy" LINK File 40}+10)  /* "GCBMRY" if English       */
#define WHEEL_Donation       (@{"WHEEL_Dummy" LINK File 40}+11)  /* colors donated by app     */
#define WHEEL_BevelBox       (@{"WHEEL_Dummy" LINK File 40}+12)  /* inside a bevel box        */
#define WHEEL_GradientSlider (@{"WHEEL_Dummy" LINK File 40}+13)  /* attached gradient slider  */
#define WHEEL_MaxPens        (@{"WHEEL_Dummy" LINK File 40}+14)  /* max # of pens to allocate */

/*****************************************************************************/

#endif /* GADGETS_COLORWHEEL_H */
@ENDNODE
