OPT NATIVE
PUBLIC MODULE 'target/gadgets/colorwheel'
MODULE 'target/aros/libcall', 'target/intuition/gadgetclass' /*, 'target/gadgets/colorwheel'*/
MODULE 'target/exec/libraries'
{
#include <proto/colorwheel.h>
}
{
struct Library* ColorWheelBase = NULL;
}
NATIVE {CLIB_COLORWHEEL_PROTOS_H} CONST
NATIVE {PROTO_COLORWHEEL_H} CONST

NATIVE {ColorWheelBase} DEF colorwheelbase:PTR TO lib		->AmigaE does not automatically initialise this

NATIVE {ConvertHSBToRGB} PROC
PROC ConvertHSBToRGB(hsb:PTR TO colorwheelhsb, rgb:PTR TO colorwheelrgb) IS NATIVE {ConvertHSBToRGB(} hsb {,} rgb {)} ENDNATIVE
NATIVE {ConvertRGBToHSB} PROC
PROC ConvertRGBToHSB(rgb:PTR TO colorwheelrgb, hsb:PTR TO colorwheelhsb) IS NATIVE {ConvertRGBToHSB(} rgb {,} hsb {)} ENDNATIVE
