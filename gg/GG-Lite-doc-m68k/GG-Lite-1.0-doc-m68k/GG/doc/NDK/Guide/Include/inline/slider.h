@DATABASE "gg:doc/NDK/Guide/Include/inline/slider.h"
@MASTER   "gg:os-include/inline/slider.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:43
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "inline/slider.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"inline/slider.h" LINK File}


@{b}#defines@{ub}

@{"CLIB_SLIDER_PROTOS_H" LINK "gg:doc/NDK/Guide/Include/inline/slider.h/File" 5}  @{"SLIDER_BASE_NAME" LINK "gg:doc/NDK/Guide/Include/inline/slider.h/File" 20}  @{"SLIDER_GetClass()" LINK "gg:doc/NDK/Guide/Include/inline/slider.h/File" 23}

@ENDNODE
@NODE File "inline/slider.h"
#ifndef _INLINE_SLIDER_H
#define _INLINE_SLIDER_H

#ifndef CLIB_SLIDER_PROTOS_H
#define CLIB_SLIDER_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <@{"inline/macros.h" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File"}>
#endif

#ifndef  INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif
#ifndef  INTUITION_CLASSES_H
#include <@{"intuition/classes.h" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File"}>
#endif

#ifndef SLIDER_BASE_NAME
#define SLIDER_BASE_NAME SliderBase
#endif

#define SLIDER_GetClass() \\
        @{"LP0" LINK "gg:doc/NDK/Guide/Include/inline/macros.h/File" 25}(0x1e, @{"Class" LINK "gg:doc/NDK/Guide/Include/intuition/classes.h/File" 36} *, @{"SLIDER_GetClass" LINK File 23}, \\
        , @{"SLIDER_BASE_NAME" LINK File 20})

#endif /*  _INLINE_SLIDER_H  */
@ENDNODE
