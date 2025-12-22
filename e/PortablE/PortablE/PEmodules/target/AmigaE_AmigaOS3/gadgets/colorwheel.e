/* $VER: colorwheel.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/utility/tagitem'
MODULE 'target/exec/types'
{MODULE 'gadgets/colorwheel'}

/* For use with the WHEEL_HSB tag */
NATIVE {colorwheelhsb} OBJECT colorwheelhsb
    {hue}	hue	:ULONG
    {saturation}	saturation	:ULONG
    {brightness}	brightness	:ULONG
ENDOBJECT

/* For use with the WHEEL_RGB tag */
NATIVE {colorwheelrgb} OBJECT colorwheelrgb
    {red}	red	:ULONG
    {green}	green	:ULONG
    {blue}	blue	:ULONG
ENDOBJECT

/*****************************************************************************/

NATIVE {WHEEL_DUMMY}	     CONST WHEEL_DUMMY	     = (TAG_USER+$04000000)
NATIVE {WHEEL_HUE}	     CONST WHEEL_HUE	     = (WHEEL_DUMMY+1)   /* set/get Hue		   */
NATIVE {WHEEL_SATURATION}     CONST WHEEL_SATURATION     = (WHEEL_DUMMY+2)   /* set/get Saturation	    */
NATIVE {WHEEL_BRIGHTNESS}     CONST WHEEL_BRIGHTNESS     = (WHEEL_DUMMY+3)   /* set/get Brightness	    */
NATIVE {WHEEL_HSB}	     CONST WHEEL_HSB	     = (WHEEL_DUMMY+4)   /* set/get ColorWheelHSB     */
NATIVE {WHEEL_RED}	     CONST WHEEL_RED	     = (WHEEL_DUMMY+5)   /* set/get Red		    */
NATIVE {WHEEL_GREEN}	     CONST WHEEL_GREEN	     = (WHEEL_DUMMY+6)   /* set/get Green	    */
NATIVE {WHEEL_BLUE}	     CONST WHEEL_BLUE	     = (WHEEL_DUMMY+7)   /* set/get Blue		    */
NATIVE {WHEEL_RGB}	     CONST WHEEL_RGB	     = (WHEEL_DUMMY+8)   /* set/get ColorWheelRGB     */
NATIVE {WHEEL_SCREEN}	     CONST WHEEL_SCREEN	     = (WHEEL_DUMMY+9)   /* init screen/enviroment    */
NATIVE {WHEEL_ABBRV}	     CONST WHEEL_ABBRV	     = (WHEEL_DUMMY+10)  /* "GCBMRY" if English	    */
NATIVE {WHEEL_DONATION}	     CONST WHEEL_DONATION	     = (WHEEL_DUMMY+11)  /* colors donated by app     */
NATIVE {WHEEL_BEVELBOX}	     CONST WHEEL_BEVELBOX	     = (WHEEL_DUMMY+12)  /* inside a bevel box	    */
NATIVE {WHEEL_GRADIENTSLIDER} CONST WHEEL_GRADIENTSLIDER = (WHEEL_DUMMY+13)  /* attached gradient slider  */
NATIVE {WHEEL_MAXPENS}	     CONST WHEEL_MAXPENS	     = (WHEEL_DUMMY+14)  /* max # of pens to allocate */
