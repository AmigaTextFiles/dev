/* $Id: gradientslider.h,v 1.12 2005/11/10 15:34:21 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/utility/tagitem'
{#include <gadgets/gradientslider.h>}
NATIVE {GADGETS_GRADIENTSLIDER_H} CONST

NATIVE {GRAD_Dummy}      CONST GRAD_DUMMY      = (TAG_USER+$05000000)
NATIVE {GRAD_MaxVal}     CONST GRAD_MAXVAL     = (GRAD_DUMMY+1)        /* max value of slider */
NATIVE {GRAD_CurVal}     CONST GRAD_CURVAL     = (GRAD_DUMMY+2)        /* current value of slider */
NATIVE {GRAD_SkipVal}    CONST GRAD_SKIPVAL    = (GRAD_DUMMY+3)        /* "body click" move amount */
NATIVE {GRAD_KnobPixels} CONST GRAD_KNOBPIXELS = (GRAD_DUMMY+4)        /* size of knob in pixels */
NATIVE {GRAD_PenArray}   CONST GRAD_PENARRAY   = (GRAD_DUMMY+5)        /* pen colors */
