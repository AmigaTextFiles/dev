OPT NATIVE
MODULE 'target/graphics/text', 'target/utility/hooks'
MODULE 'target/exec/types'

NATIVE {StringExtend} OBJECT stringextend
    /* display specifications */
    {Font}	font	:PTR TO textfont          /* must be an open Font (not TextAttr)  */
    {Pens}	pens[2]	:ARRAY OF UBYTE       /* color of text/backgroun              */
    {ActivePens}	activepens[2]	:ARRAY OF UBYTE /* colors when gadget is active         */

    /* edit specifications    */
    {InitialModes}	initialmodes	:ULONG  /* initial mode flags, below            */
    {EditHook}	edithook	:PTR TO hook      /* if non-NULL, must supply WorkBuffer  */
    {WorkBuffer}	workbuffer	:/*STRPTR*/ ARRAY OF CHAR    /* must be as large as StringInfo.Buffer*/

    {Reserved}	reserved[4]	:ARRAY OF ULONG   /* set to 0                             */
ENDOBJECT
