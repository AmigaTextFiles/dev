/* $VER: gradientslider.h 44.1 (19.10.1999) */
OPT NATIVE
MODULE 'target/utility/tagitem'
{MODULE 'gadgets/gradientslider'}

NATIVE {GRAD_DUMMY}	 CONST GRAD_DUMMY	 = (TAG_USER+$05000000)
NATIVE {GRAD_MAXVAL}	 CONST GRAD_MAXVAL	 = (GRAD_DUMMY+1)     /* max value of slider	   */
NATIVE {GRAD_CURVAL}	 CONST GRAD_CURVAL	 = (GRAD_DUMMY+2)     /* current value of slider	   */
NATIVE {GRAD_SKIPVAL}	 CONST GRAD_SKIPVAL	 = (GRAD_DUMMY+3)     /* "body click" move amount    */
NATIVE {GRAD_KNOBPIXELS}  CONST GRAD_KNOBPIXELS  = (GRAD_DUMMY+4)     /* size of knob in pixels	   */
NATIVE {GRAD_PENARRAY}	 CONST GRAD_PENARRAY	 = (GRAD_DUMMY+5)     /* pen colors		   */
