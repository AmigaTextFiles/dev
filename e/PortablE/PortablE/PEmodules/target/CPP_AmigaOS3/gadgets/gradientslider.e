/* $VER: gradientslider.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/utility/tagitem'
{#include <gadgets/gradientslider.h>}
NATIVE {GADGETS_GRADIENTSLIDER_H} CONST

NATIVE {GRAD_Dummy}	 CONST GRAD_DUMMY	 = (TAG_USER+$05000000)
NATIVE {GRAD_MaxVal}	 CONST GRAD_MAXVAL	 = (GRAD_DUMMY+1)     /* max value of slider	   */
NATIVE {GRAD_CurVal}	 CONST GRAD_CURVAL	 = (GRAD_DUMMY+2)     /* current value of slider	   */
NATIVE {GRAD_SkipVal}	 CONST GRAD_SKIPVAL	 = (GRAD_DUMMY+3)     /* "body click" move amount    */
NATIVE {GRAD_KnobPixels}  CONST GRAD_KNOBPIXELS  = (GRAD_DUMMY+4)     /* size of knob in pixels	   */
NATIVE {GRAD_PenArray}	 CONST GRAD_PENARRAY	 = (GRAD_DUMMY+5)     /* pen colors		   */
