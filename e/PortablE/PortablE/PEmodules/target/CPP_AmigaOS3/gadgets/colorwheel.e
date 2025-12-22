/* $VER: colorwheel.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/utility/tagitem'
MODULE 'target/exec/types'
{#include <gadgets/colorwheel.h>}
NATIVE {GADGETS_COLORWHEEL_H} CONST

/* For use with the WHEEL_HSB tag */
NATIVE {ColorWheelHSB} OBJECT colorwheelhsb
    {cw_Hue}	hue	:ULONG
    {cw_Saturation}	saturation	:ULONG
    {cw_Brightness}	brightness	:ULONG
ENDOBJECT

/* For use with the WHEEL_RGB tag */
NATIVE {ColorWheelRGB} OBJECT colorwheelrgb
    {cw_Red}	red	:ULONG
    {cw_Green}	green	:ULONG
    {cw_Blue}	blue	:ULONG
ENDOBJECT

/*****************************************************************************/

NATIVE {WHEEL_Dummy}	     CONST WHEEL_DUMMY	     = (TAG_USER+$04000000)
NATIVE {WHEEL_Hue}	     CONST WHEEL_HUE	     = (WHEEL_DUMMY+1)   /* set/get Hue		   */
NATIVE {WHEEL_Saturation}     CONST WHEEL_SATURATION     = (WHEEL_DUMMY+2)   /* set/get Saturation	    */
NATIVE {WHEEL_Brightness}     CONST WHEEL_BRIGHTNESS     = (WHEEL_DUMMY+3)   /* set/get Brightness	    */
NATIVE {WHEEL_HSB}	     CONST WHEEL_HSB	     = (WHEEL_DUMMY+4)   /* set/get ColorWheelHSB     */
NATIVE {WHEEL_Red}	     CONST WHEEL_RED	     = (WHEEL_DUMMY+5)   /* set/get Red		    */
NATIVE {WHEEL_Green}	     CONST WHEEL_GREEN	     = (WHEEL_DUMMY+6)   /* set/get Green	    */
NATIVE {WHEEL_Blue}	     CONST WHEEL_BLUE	     = (WHEEL_DUMMY+7)   /* set/get Blue		    */
NATIVE {WHEEL_RGB}	     CONST WHEEL_RGB	     = (WHEEL_DUMMY+8)   /* set/get ColorWheelRGB     */
NATIVE {WHEEL_Screen}	     CONST WHEEL_SCREEN	     = (WHEEL_DUMMY+9)   /* init screen/enviroment    */
NATIVE {WHEEL_Abbrv}	     CONST WHEEL_ABBRV	     = (WHEEL_DUMMY+10)  /* "GCBMRY" if English	    */
NATIVE {WHEEL_Donation}	     CONST WHEEL_DONATION	     = (WHEEL_DUMMY+11)  /* colors donated by app     */
NATIVE {WHEEL_BevelBox}	     CONST WHEEL_BEVELBOX	     = (WHEEL_DUMMY+12)  /* inside a bevel box	    */
NATIVE {WHEEL_GradientSlider} CONST WHEEL_GRADIENTSLIDER = (WHEEL_DUMMY+13)  /* attached gradient slider  */
NATIVE {WHEEL_MaxPens}	     CONST WHEEL_MAXPENS	     = (WHEEL_DUMMY+14)  /* max # of pens to allocate */
