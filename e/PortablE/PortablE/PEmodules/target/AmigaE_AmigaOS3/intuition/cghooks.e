/* $VER: cghooks.h 38.1 (11.11.1991) */
OPT NATIVE, PREPROCESS, POINTER
MODULE 'target/exec/types', 'target/intuition/intuition'
MODULE 'target/graphics/rastport', 'target/intuition/screens', 'target/utility/hooks'
{MODULE 'intuition/cghooks'}

NATIVE {gadgetinfo} OBJECT gadgetinfo

    {screen}	screen	:PTR TO screen
    {window}	window	:PTR TO window	/* null for screen gadgets */
    {requester}	requester	:PTR TO requester	/* null if not GTYP_REQGADGET */

    {rastport}	rastport	:PTR TO rastport
    {layer}	layer	:PTR TO layer

    {domain}	domain	:ibox

	{detailpen}	detailpen	:UBYTE
	{blockpen}	blockpen	:UBYTE

    {drinfo}	drinfo	:PTR TO drawinfo

->    {reserved}	reserved[6]	:ARRAY OF ULONG
ENDOBJECT

/*** system private data structure for now ***/
/* prop gadget extra info	*/
NATIVE {pgx} OBJECT pgx
    {container}	container	:ibox
    {newknob}	newknob	:ibox
ENDOBJECT

NATIVE {CUSTOM_HOOK} CONST	->CUSTOM_HOOK( gadget ) ( (struct Hook *) (gadget)->MutualExclude)
#define CUSTOM_HOOK(g) Custom_hook(g)
PROC Custom_hook(g:PTR TO gadget) IS g.mutualexclude !!PTR TO hook
