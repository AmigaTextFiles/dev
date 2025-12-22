/* $VER: textclass.h 39.3 (3.8.1992) */
OPT NATIVE, PREPROCESS
MODULE 'target/utility/tagitem', 'target/datatypes/datatypesclass', 'target/libraries/iffparse'
MODULE 'target/exec/nodes', 'target/exec/types'
{MODULE 'datatypes/textclass'}
NATIVE {DATATYPES_TEXTCLASS_H} CONST

NATIVE {TEXTDTCLASS}		CONST
#define TEXTDTCLASS textdtclass
STATIC textdtclass		= 'text.datatype'

/*****************************************************************************/

/* Text attributes */
NATIVE {TDTA_BUFFER}		CONST TDTA_BUFFER		= (DTA_DUMMY + 300)
NATIVE {TDTA_BUFFERLEN}		CONST TDTA_BUFFERLEN		= (DTA_DUMMY + 301)
NATIVE {TDTA_LINELIST}		CONST TDTA_LINELIST		= (DTA_DUMMY + 302)
NATIVE {TDTA_WORDSELECT}		CONST TDTA_WORDSELECT		= (DTA_DUMMY + 303)
NATIVE {TDTA_WORDDELIM}		CONST TDTA_WORDDELIM		= (DTA_DUMMY + 304)
NATIVE {TDTA_WORDWRAP}		CONST TDTA_WORDWRAP		= (DTA_DUMMY + 305)
     /* Boolean. Should the text be word wrapped.  Defaults to false. */

/*****************************************************************************/

/* There is one Line structure for every line of text in our document.	*/
NATIVE {line} OBJECT line
    {link}	link	:mln		/* to link the lines together */
    {text}	text	:/*STRPTR*/ ARRAY OF CHAR		/* pointer to the text for this	line */
    {textlen}	textlen	:ULONG		/* the character length of the text for this line */
    {xoffset}	xoffset	:UINT		/* where in the	line the text starts */
    {yoffset}	yoffset	:UINT		/* line the text is on */
    {width}	width	:UINT		/* Width of line in pixels */
    {height}	height	:UINT		/* Height of line in pixels */
    {flags}	flags	:UINT		/* info	on the line */
    {fgpen}	fgpen	:BYTE		/* foreground pen */
    {bgpen}	bgpen	:BYTE		/* background pen */
    {style}	style	:ULONG		/* Font style */
    {data}	data	:APTR		/* Link data... */
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
