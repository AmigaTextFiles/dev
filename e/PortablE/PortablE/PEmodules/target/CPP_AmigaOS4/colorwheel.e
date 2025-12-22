/* $Id: colorwheel_protos.h,v 1.7 2005/11/10 15:30:32 hjfrieden Exp $ */
OPT NATIVE
PUBLIC MODULE 'target/gadgets/colorwheel'
MODULE 'target/exec/types' /*, 'target/gadgets/colorwheel'*/
MODULE 'target/PEalias/exec', 'target/exec/libraries'
{
#include <proto/colorwheel.h>
}
{
struct Library* ColorWheelBase = NULL;
struct ColorWheelIFace* IColorWheel = NULL;
}
NATIVE {CLIB_COLORWHEEL_PROTOS_H} CONST
NATIVE {PROTO_COLORWHEEL_H} CONST
NATIVE {PRAGMA_COLORWHEEL_H} CONST
NATIVE {INLINE4_COLORWHEEL_H} CONST
NATIVE {COLORWHEEL_INTERFACE_DEF_H} CONST

NATIVE {ColorWheelBase} DEF colorwheelbase:PTR TO lib		->AmigaE does not automatically initialise this
NATIVE {IColorWheel} DEF

PROC new()
	InitLibrary('gadgets/colorwheel.gadget', NATIVE {(struct Interface **) &IColorWheel} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC

/*--- functions in V39 or higher (Release 3) ---*/

/* Public entries */

->NATIVE {ConvertHSBToRGB} PROC
PROC ConvertHSBToRGB( hsb:PTR TO colorwheelhsb, rgb:PTR TO colorwheelrgb ) IS NATIVE {IColorWheel->ConvertHSBToRGB(} hsb {,} rgb {)} ENDNATIVE
->NATIVE {ConvertRGBToHSB} PROC
PROC ConvertRGBToHSB( rgb:PTR TO colorwheelrgb, hsb:PTR TO colorwheelhsb ) IS NATIVE {IColorWheel->ConvertRGBToHSB(} rgb {,} hsb {)} ENDNATIVE
