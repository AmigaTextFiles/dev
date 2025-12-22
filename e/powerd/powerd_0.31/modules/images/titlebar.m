/* This macro can be used to compute the correct position for a gadget   */
/* to be placed into the titlebar. "tbi" is a pointer to a "tbiclass"    */
/* instance and "num" is the number of gadgets (zoom, depth...) that     */
/* will be at the right side of the new gadget. For instance, if your    */
/* window has both a zoom gadget and a depth gadget, you can compute     */
/* the position of a new titlebar gadget with TBI_RELPOS(tbi,2).         */
/* If there's instead only a depth gadget, you'll use TBI_RELPOS(tbi,1). */
/* Note: the new gadget MUST have the GFLG_RELRIGHT flag set.            */

#define TBI_RELPOS(tbi,num ) (1 - ((1 + (num)) * ((tbi).Width - 1)))
#define TBIA_Dummy        (TAG_USER + $0B0000)
#define TBIA_ContentsBox  (TBIA_Dummy + $0001)  	/* Get inner size (V40.12) */

CONST POPUPIMAGE=101,
 MUIIMAGE=102,
 SNAPSHOTIMAGE=103,
 ICONIFYIMAGE=104,
 PADLOCKIMAGE=105,
 TBFRAMEIMAGE=106
