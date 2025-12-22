/* $VER: colorwheel_protos.h 39.1 (21.7.1992) */
OPT NATIVE
PUBLIC MODULE 'target/gadgets/colorwheel'
MODULE 'target/exec/types' /*, 'target/gadgets/colorwheel'*/
MODULE 'target/exec/libraries'
{MODULE 'colorwheel'}

NATIVE {colorwheelbase} DEF colorwheelbase:NATIVE {LONG} PTR TO lib		->AmigaE does not automatically initialise this

/*--- functions in V39 or higher (Release 3) ---*/

/* Public entries */

NATIVE {ConvertHSBToRGB} PROC
PROC ConvertHSBToRGB( hsb:PTR TO colorwheelhsb, rgb:PTR TO colorwheelrgb ) IS NATIVE {ConvertHSBToRGB(} hsb {,} rgb {)} ENDNATIVE
NATIVE {ConvertRGBToHSB} PROC
PROC ConvertRGBToHSB( rgb:PTR TO colorwheelrgb, hsb:PTR TO colorwheelhsb ) IS NATIVE {ConvertRGBToHSB(} rgb {,} hsb {)} ENDNATIVE
