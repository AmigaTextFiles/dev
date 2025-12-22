/* $Id: cghooks.h,v 1.11 2005/11/10 15:39:40 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS, POINTER
MODULE 'target/exec/types', 'target/intuition/intuition'
MODULE 'target/graphics/rastport', 'target/intuition/screens', 'target/utility/hooks'
{#include <intuition/cghooks.h>}
NATIVE {INTUITION_CGHOOKS_H} CONST

/*
 * Package of information passed to custom and 'boopsi'
 * gadget "hook" functions.  This structure is READ ONLY.
 */
NATIVE {GadgetInfo} OBJECT gadgetinfo

    {gi_Screen}	screen	:PTR TO screen
    {gi_Window}	window	:PTR TO window    /* null for screen gadgets */
    {gi_Requester}	requester	:PTR TO requester /* null if not GTYP_REQGADGET */

    /* rendering information:
     * don't use these without cloning/locking.
     * Official way is to call ObtainRPort()
     */
    {gi_RastPort}	rastport	:PTR TO rastport
    {gi_Layer}	layer	:PTR TO layer

    /* copy of dimensions of screen/window/g00/req(/group)
     * that gadget resides in.    Left/Top of this box is
     * offset from window mouse coordinates to gadget coordinates
     *    screen gadgets:                0,0 (from screen coords)
     *    window gadgets (no g00):       0,0
     *    GTYP_GZZGADGETs (borderlayer): 0,0
     *    GZZ innerlayer gadget:         borderleft, bordertop
     *    Requester gadgets:             reqleft, reqtop
     */
    {gi_Domain}	domain	:ibox

    /* these are the pens for the window or screen    */
    {gi_Pens.DetailPen}	detailpen	:UBYTE
    {gi_Pens.BlockPen}	blockpen	:UBYTE

    /* the Detail and Block pens in gi_DrInfo->dri_Pens[] are
     * for the screen.    Use the above for window-sensitive
     * colors.
     */
    {gi_DrInfo}	drinfo	:PTR TO drawinfo

    /* gadget backpointer. New for V50. */
    {gi_Gadget}	gadget	:PTR TO gadget

    /* reserved space: this structure is extensible
     * anyway, but using these saves some recompilation
     */
    {gi_Reserved}	reserved[5]	:ARRAY OF ULONG
ENDOBJECT

/*** system private data structure for now ***/
/* prop gadget extra info    */
NATIVE {PGX} OBJECT pgx
    {pgx_Container}	container	:ibox
    {pgx_NewKnob}	newknob	:ibox
ENDOBJECT

/* this casts MutualExclude for easy assignment of a hook
 * pointer to the unused MutualExclude field of a custom gadget
 */
NATIVE {CUSTOM_HOOK} CONST	->CUSTOM_HOOK( gadget ) ( (struct Hook *) (gadget)->MutualExclude)
#define CUSTOM_HOOK(g) Custom_hook(g)
PROC Custom_hook(g:PTR TO gadget) IS g.mutualexclude !!PTR TO hook
