@DATABASE "gg:doc/NDK/Guide/Include/gadgets/gradientslider.h"
@MASTER   "gg:os-include/gadgets/gradientslider.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:31
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/gradientslider.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/gradientslider.h" LINK File}


@{b}#defines@{ub}

@{"GRAD_CurVal" LINK "gg:doc/NDK/Guide/Include/gadgets/gradientslider.h/File" 23}   @{"GRAD_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/gradientslider.h/File" 21}  @{"GRAD_KnobPixels" LINK "gg:doc/NDK/Guide/Include/gadgets/gradientslider.h/File" 25}  @{"GRAD_MaxVal" LINK "gg:doc/NDK/Guide/Include/gadgets/gradientslider.h/File" 22}  @{"GRAD_PenArray" LINK "gg:doc/NDK/Guide/Include/gadgets/gradientslider.h/File" 26}
@{"GRAD_SkipVal" LINK "gg:doc/NDK/Guide/Include/gadgets/gradientslider.h/File" 24}  

@ENDNODE
@NODE File "gadgets/gradientslider.h"
#ifndef GADGETS_GRADIENTSLIDER_H
#define GADGETS_GRADIENTSLIDER_H
/*
**      $VER: gradientslider.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the gradientslider BOOPSI class
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

/*****************************************************************************/

#define GRAD_Dummy       (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0x05000000)
#define GRAD_MaxVal      (@{"GRAD_Dummy" LINK File 21}+1)     /* max value of slider         */
#define GRAD_CurVal      (@{"GRAD_Dummy" LINK File 21}+2)     /* current value of slider     */
#define GRAD_SkipVal     (@{"GRAD_Dummy" LINK File 21}+3)     /* "body click" move amount    */
#define GRAD_KnobPixels  (@{"GRAD_Dummy" LINK File 21}+4)     /* size of knob in pixels      */
#define GRAD_PenArray    (@{"GRAD_Dummy" LINK File 21}+5)     /* pen colors                  */

/*****************************************************************************/

#endif /* GADGETS_GRADIENTSLIDER_H */
@ENDNODE
