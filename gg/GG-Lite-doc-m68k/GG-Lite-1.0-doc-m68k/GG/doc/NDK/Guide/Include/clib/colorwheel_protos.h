@DATABASE "gg:doc/NDK/Guide/Include/clib/colorwheel_protos.h"
@MASTER   "gg:os-include/clib/colorwheel_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:33
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/colorwheel_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/colorwheel_protos.h" LINK File}

@ENDNODE
@NODE File "clib/colorwheel_protos.h"
#ifndef  CLIB_COLORWHEEL_PROTOS_H
#define  CLIB_COLORWHEEL_PROTOS_H

/*
**      $VER: colorwheel_protos.h 39.1 (21.7.1992)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif
#ifndef  GADGETS_COLORWHEEL_H
#include <@{"gadgets/colorwheel.h" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File"}>
#endif
/*--- functions in V39 or higher (Release 3) ---*/

/* Public entries */

@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ConvertHSBToRGB" LINK "gg:doc/NDK/Guide/Include/inline/colorwheel.h/File" 23}( @{"struct ColorWheelHSB" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 23} *hsb, struct ColorWheelRGB *rgb );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ConvertRGBToHSB" LINK "gg:doc/NDK/Guide/Include/inline/colorwheel.h/File" 27}( @{"struct ColorWheelRGB" LINK "gg:doc/NDK/Guide/Include/gadgets/colorwheel.h/File" 31} *rgb, struct ColorWheelHSB *hsb );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_COLORWHEEL_PROTOS_H */
@ENDNODE
