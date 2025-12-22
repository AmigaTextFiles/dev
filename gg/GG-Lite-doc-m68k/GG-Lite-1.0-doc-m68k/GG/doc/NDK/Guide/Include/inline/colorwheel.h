@DATABASE "gg:doc/NDK/Guide/Include/inline/colorwheel.h"
@MASTER   "gg:os-include/inline/colorwheel.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:34
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/colorwheel.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/colorwheel.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_COLORWHEEL_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/colorwheel.h/File" 5}  @{"COLORWHEEL_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/colorwheel.h/File" 20}  @{"ConvertHSBToRGB()" LINK "gg:doc/NDK/Guide/Include/inline/colorwheel.h/File" 23}
@{"ConvertRGBToHSB()" LINK "gg:doc/NDK/Guide/Include/inline/colorwheel.h/File" 27}         

@ENDNODE
@NODE File "inline/colorwheel.h"
#ifndef _INLINE_COLORWHEEL_H
#define _INLINE_COLORWHEEL_H

#ifndef CLIB_COLORWHEEL_PROTOS_H
#define CLIB_COLORWHEEL_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  GADGETS_COLORWHEEL_H
#include <@{"gadgets/colorwheel.h" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File"}>
#endif

#ifndef COLORWHEEL_BASE_NAME
#define COLORWHEEL_BASE_NAME ColorWheelBase
#endif

#define @{"ConvertHSBToRGB" LINK "gg:doc/NDK/Guide/colorwheel_gc/ConvertHSBToRGB"}(hsb, rgb) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x1e, @{"ConvertHSBToRGB" LINK File 23}, @{"struct ColorWheelHSB" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 23} *, hsb, a0, struct ColorWheelRGB *, rgb, a1, \\
        , COLORWHEEL_BASE_NAME)

#define @{"ConvertRGBToHSB" LINK "gg:doc/NDK/Guide/colorwheel_gc/ConvertRGBToHSB"}(rgb, hsb) \\
        @{"LP2NR" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 168}(0x24, @{"ConvertRGBToHSB" LINK File 27}, @{"struct ColorWheelRGB" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 31} *, rgb, a0, struct ColorWheelHSB *, hsb, a1, \\
        , COLORWHEEL_BASE_NAME)

#endif /*  _INLINE_COLORWHEEL_H  */
@ENDNODE
