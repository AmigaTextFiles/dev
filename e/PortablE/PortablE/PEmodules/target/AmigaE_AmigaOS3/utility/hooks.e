/* $VER: hooks.h 39.2 (16.6.1993) */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/nodes'
{MODULE 'utility/hooks'}

NATIVE {hook} OBJECT hook
    {mln}		mln			:mln
    {entry}		entry		:PTR /*ULONG	   (*h_Entry)()*/	/* assembler entry point */
    {subentry}	subentry	:PTR /*ULONG	   (*h_SubEntry)()*/	/* often HLL entry point */
    {data}		data		:APTR2		/* owner specific	 */
ENDOBJECT
