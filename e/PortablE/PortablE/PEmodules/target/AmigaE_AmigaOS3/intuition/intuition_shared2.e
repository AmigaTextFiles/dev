OPT NATIVE
MODULE 'target/graphics/text', 'target/utility/hooks'
MODULE 'target/exec/types'

NATIVE {stringextend} OBJECT stringextend
    /* display specifications	*/
    {font}	font	:PTR TO textfont	/* must be an open Font (not TextAttr)	*/
    {pens}	pens[2]	:ARRAY OF UBYTE	/* color of text/backgroun		*/
    {activepens}	activepens[2]	:ARRAY OF UBYTE	/* colors when gadget is active		*/

    /* edit specifications	*/
    {initialmodes}	initialmodes	:ULONG	/* initial mode flags, below		*/
    {edithook}	edithook	:PTR TO hook	/* if non-NULL, must supply WorkBuffer	*/
    {workbuffer}	workbuffer	:ARRAY OF UBYTE	/* must be as large as StringInfo.Buffer*/

    {reserved}	reserved[4]	:ARRAY OF ULONG	/* set to 0				*/
ENDOBJECT
