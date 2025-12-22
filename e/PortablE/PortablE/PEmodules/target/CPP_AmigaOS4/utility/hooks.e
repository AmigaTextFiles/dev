/* $Id: hooks.h,v 1.12 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/nodes'
{#include <utility/hooks.h>}
NATIVE {UTILITY_HOOKS_H} CONST

NATIVE {Hook} OBJECT hook
    {h_MinNode}	mln	:mln
    {h_Entry}	entry	:HOOKFUNC    /* assembler entry point */
    {h_SubEntry}	subentry	:HOOKFUNC /* often HLL entry point */
    {h_Data}	data	:APTR2        /* owner specific        */
ENDOBJECT

/* Useful definition for casting function pointers:
 * hook.h_SubEntry = (HOOKFUNC)AFunction
 */
NATIVE {HOOKFUNC} CONST
TYPE HOOKFUNC IS NATIVE {HOOKFUNC} PTR	->uint32 (*HOOKFUNC)(struct Hook *, APTR, APTR)
