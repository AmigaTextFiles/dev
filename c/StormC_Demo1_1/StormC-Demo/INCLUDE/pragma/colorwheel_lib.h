#ifndef _INCLUDE_PRAGMA_COLORWHEEL_LIB_H
#define _INCLUDE_PRAGMA_COLORWHEEL_LIB_H

/*
**  $VER: colorwheel_lib.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_COLORWHEEL_PROTOS_H
#include <clib/colorwheel_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(ColorWheelBase, 0x1e, ConvertHSBToRGB(a0,a1))
#pragma amicall(ColorWheelBase, 0x24, ConvertRGBToHSB(a0,a1))

#ifdef __cplusplus
}
#endif

#endif
