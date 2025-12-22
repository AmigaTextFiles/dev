/* $VER: colorwheel_protos.h 39.1 (21.7.1992) */
OPT NATIVE
PUBLIC MODULE 'target/gadgets/colorwheel'
MODULE 'target/exec/types' /*, 'target/gadgets/colorwheel'*/
MODULE 'target/exec/libraries'
{
#include <proto/colorwheel.h>
}
{
struct Library* ColorWheelBase = NULL;
}
NATIVE {CLIB_COLORWHEEL_PROTOS_H} CONST
NATIVE {_PROTO_COLORWHEEL_H} CONST
NATIVE {_INLINE_COLORWHEEL_H} CONST
NATIVE {COLORWHEEL_BASE_NAME} CONST
NATIVE {PRAGMA_COLORWHEEL_H} CONST
NATIVE {PRAGMAS_COLORWHEEL_PRAGMAS_H} CONST

NATIVE {ColorWheelBase} DEF colorwheelbase:PTR TO lib		->AmigaE does not automatically initialise this

/*--- functions in V39 or higher (Release 3) ---*/

/* Public entries */

NATIVE {ConvertHSBToRGB} PROC
PROC ConvertHSBToRGB( hsb:PTR TO colorwheelhsb, rgb:PTR TO colorwheelrgb ) IS NATIVE {ConvertHSBToRGB(} hsb {,} rgb {)} ENDNATIVE
NATIVE {ConvertRGBToHSB} PROC
PROC ConvertRGBToHSB( rgb:PTR TO colorwheelrgb, hsb:PTR TO colorwheelhsb ) IS NATIVE {ConvertRGBToHSB(} rgb {,} hsb {)} ENDNATIVE
