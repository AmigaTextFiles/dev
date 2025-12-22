OPT NATIVE
MODULE 'target/utility/tagitem'
{#include <gadgets/gradientslider.h>}
NATIVE {GADGETS_GRADIENTSLIDER_H} CONST

NATIVE {GRAD_Dummy}	CONST GRAD_DUMMY	= (TAG_USER + $05000000)
NATIVE {GRAD_MaxVal}	CONST GRAD_MAXVAL	= (GRAD_DUMMY + 1)     /* slider's max value	   		*/
NATIVE {GRAD_CurVal}	CONST GRAD_CURVAL	= (GRAD_DUMMY + 2)     /* slider's current value	  		*/
NATIVE {GRAD_SkipVal}	CONST GRAD_SKIPVAL	= (GRAD_DUMMY + 3)     /* move amount of "body click" move amount */
NATIVE {GRAD_KnobPixels} CONST GRAD_KNOBPIXELS = (GRAD_DUMMY + 4)     /* knob size	   			*/
NATIVE {GRAD_PenArray}	CONST GRAD_PENARRAY	= (GRAD_DUMMY + 5)     /* pen colors		   		*/
