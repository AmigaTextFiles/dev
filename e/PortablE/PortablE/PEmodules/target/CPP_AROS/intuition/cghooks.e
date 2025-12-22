/* $Id: cghooks.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE, PREPROCESS, POINTER
PUBLIC MODULE 'target/intuition/intuition_shared1'
MODULE 'target/exec/types', 'target/intuition/intuition'
MODULE 'target/utility/hooks'
{#include <intuition/cghooks.h>}
NATIVE {INTUITION_CGHOOKS_H} CONST

->"OBJECT gadgetinfo" is on-purposely missing from here (it can be found in 'intuition/intuition_shared1')

NATIVE {PGX} OBJECT pgx
    {pgx_Container}	container	:ibox
    {pgx_NewKnob}	newknob	:ibox
ENDOBJECT

NATIVE {CUSTOM_HOOK} CONST	->CUSTOM_HOOK(gadget) ((struct Hook *) (gadget)->MutualExclude)
#define CUSTOM_HOOK(g) Custom_hook(g)
PROC Custom_hook(g:PTR TO gadget) IS g.mutualexclude !!PTR TO hook
