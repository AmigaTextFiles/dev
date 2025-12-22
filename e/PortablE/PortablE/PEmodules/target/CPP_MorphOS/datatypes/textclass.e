/* $VER: textclass.h 39.3 (3.8.1992) */
OPT NATIVE, PREPROCESS
MODULE 'target/utility/tagitem', 'target/datatypes/datatypesclass', 'target/libraries/iffparse'
MODULE 'target/exec/nodes', 'target/exec/types'
{#include <datatypes/textclass.h>}
NATIVE {DATATYPES_TEXTCLASS_H} CONST

NATIVE {TEXTDTCLASS}		CONST
#define TEXTDTCLASS textdtclass
STATIC textdtclass		= 'text.datatype'

/*****************************************************************************/

/* Text attributes */
NATIVE {TDTA_Buffer}		CONST TDTA_BUFFER		= (DTA_DUMMY + 300)
NATIVE {TDTA_BufferLen}		CONST TDTA_BUFFERLEN		= (DTA_DUMMY + 301)
NATIVE {TDTA_LineList}		CONST TDTA_LINELIST		= (DTA_DUMMY + 302)
NATIVE {TDTA_WordSelect}		CONST TDTA_WORDSELECT		= (DTA_DUMMY + 303)
NATIVE {TDTA_WordDelim}		CONST TDTA_WORDDELIM		= (DTA_DUMMY + 304)
NATIVE {TDTA_WordWrap}		CONST TDTA_WORDWRAP		= (DTA_DUMMY + 305)
     /* Boolean. Should the text be word wrapped.  Defaults to false. */

/*****************************************************************************/

/* There is one Line structure for every line of text in our document.	*/
NATIVE {Line} OBJECT line
    {ln_Link}	link	:mln		/* to link the lines together */
    {ln_Text}	text	:/*STRPTR*/ ARRAY OF CHAR		/* pointer to the text for this	line */
    {ln_TextLen}	textlen	:ULONG		/* the character length of the text for this line */
    {ln_XOffset}	xoffset	:UINT		/* where in the	line the text starts */
    {ln_YOffset}	yoffset	:UINT		/* line the text is on */
    {ln_Width}	width	:UINT		/* Width of line in pixels */
    {ln_Height}	height	:UINT		/* Height of line in pixels */
    {ln_Flags}	flags	:UINT		/* info	on the line */
    {ln_FgPen}	fgpen	:BYTE		/* foreground pen */
    {ln_BgPen}	bgpen	:BYTE		/* background pen */
    {ln_Style}	style	:ULONG		/* Font style */
    {ln_Data}	data	:APTR		/* Link data... */
ENDOBJECT

/*****************************************************************************/

/* Line.ln_Flags */

/* Line Feed */
NATIVE {LNF_LF}		CONST LNF_LF		= 1 SHL 0

/* Segment is a link */
NATIVE {LNF_LINK}	CONST LNF_LINK	= 1 SHL 1

/* ln_Data is a pointer to an DataTypes object */
NATIVE {LNF_OBJECT}	CONST LNF_OBJECT	= 1 SHL 2

/* Object is selected */
NATIVE {LNF_SELECTED}	CONST LNF_SELECTED	= 1 SHL 3

/*****************************************************************************/

/* IFF types that may be text */
NATIVE {ID_FTXT}		CONST ID_FTXT		= "FTXT"
NATIVE {ID_CHRS}		CONST ID_CHRS		= "CHRS"
