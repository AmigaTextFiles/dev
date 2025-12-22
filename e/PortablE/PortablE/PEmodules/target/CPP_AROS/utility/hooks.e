/* $Id: hooks.h 18327 2003-07-04 14:37:43Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/nodes', 'target/aros/asmcall'
{#include <utility/hooks.h>}
NATIVE {UTILITY_HOOKS_H} CONST

/* A callback Hook */
NATIVE {Hook} OBJECT hook
    {h_MinNode}	mln	:mln
    {h_Entry}	entry	:APTR2     /* Main entry point */
    {h_SubEntry}	subentry	:APTR2  /* Secondary entry point */
    {h_Data}	data	:APTR2	    /* Whatever you want */
ENDOBJECT

/* You can use this if you want for casting function pointers. */
NATIVE {HOOKFUNC} CONST


NATIVE {CALLHOOKPKT} CONST	->CALLHOOKPKT(hook, object, message)
