OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/utility/tagitem'
{#include <gadgets/colorwheel.h>}
NATIVE {GADGETS_COLORWHEEL_H} CONST

NATIVE {COLORWHEELCLASS} CONST
#define COLORWHEELCLASS colorwheelclass
STATIC colorwheelclass = 'colorwheel.gadget'

NATIVE {COLORWHEELNAME} CONST
#define COLORWHEELNAME colorwheelname
STATIC colorwheelname = 'Gadgets/colorwheel.gadget'


NATIVE {ColorWheelHSB} OBJECT colorwheelhsb
    {cw_Hue}	hue	:ULONG
    {cw_Saturation}	saturation	:ULONG
    {cw_Brightness}	brightness	:ULONG
ENDOBJECT

NATIVE {ColorWheelRGB} OBJECT colorwheelrgb
    {cw_Red}	red	:ULONG
    {cw_Green}	green	:ULONG
    {cw_Blue}	blue	:ULONG
ENDOBJECT


NATIVE {WHEEL_Dummy}          CONST WHEEL_DUMMY          = (TAG_USER + $04000000)
NATIVE {WHEEL_Hue}            CONST WHEEL_HUE            = (WHEEL_DUMMY + 1)
NATIVE {WHEEL_Saturation}     CONST WHEEL_SATURATION     = (WHEEL_DUMMY + 2)
NATIVE {WHEEL_Brightness}     CONST WHEEL_BRIGHTNESS     = (WHEEL_DUMMY + 3)
NATIVE {WHEEL_HSB}            CONST WHEEL_HSB            = (WHEEL_DUMMY + 4)
NATIVE {WHEEL_Red}            CONST WHEEL_RED            = (WHEEL_DUMMY + 5)
NATIVE {WHEEL_Green}          CONST WHEEL_GREEN          = (WHEEL_DUMMY + 6)
NATIVE {WHEEL_Blue}           CONST WHEEL_BLUE           = (WHEEL_DUMMY + 7)
NATIVE {WHEEL_RGB}            CONST WHEEL_RGB            = (WHEEL_DUMMY + 8)
NATIVE {WHEEL_Screen}         CONST WHEEL_SCREEN         = (WHEEL_DUMMY + 9)
NATIVE {WHEEL_Abbrv}          CONST WHEEL_ABBRV          = (WHEEL_DUMMY + 10)
NATIVE {WHEEL_Donation}       CONST WHEEL_DONATION       = (WHEEL_DUMMY + 11)
NATIVE {WHEEL_BevelBox}       CONST WHEEL_BEVELBOX       = (WHEEL_DUMMY + 12)
NATIVE {WHEEL_GradientSlider} CONST WHEEL_GRADIENTSLIDER = (WHEEL_DUMMY + 13)
NATIVE {WHEEL_MaxPens}        CONST WHEEL_MAXPENS        = (WHEEL_DUMMY + 14)
