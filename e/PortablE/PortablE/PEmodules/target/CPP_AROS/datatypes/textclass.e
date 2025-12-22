OPT NATIVE, PREPROCESS
MODULE 'target/utility/tagitem', 'target/datatypes/datatypesclass', 'target/libraries/iffparse'
MODULE 'target/exec/nodes', 'target/exec/types'
{#include <datatypes/textclass.h>}
NATIVE {DATATYPES_TEXTCLASS_H} CONST

NATIVE {TEXTDTCLASS}		CONST
#define TEXTDTCLASS textdtclass
STATIC textdtclass		= 'text.datatype'

/* Attributes */

NATIVE {TDTA_Buffer}	CONST TDTA_BUFFER	= (DTA_DUMMY + 300)
NATIVE {TDTA_BufferLen}	CONST TDTA_BUFFERLEN	= (DTA_DUMMY + 301)
NATIVE {TDTA_LineList}	CONST TDTA_LINELIST	= (DTA_DUMMY + 302)
NATIVE {TDTA_WordSelect}	CONST TDTA_WORDSELECT	= (DTA_DUMMY + 303)
NATIVE {TDTA_WordDelim}	CONST TDTA_WORDDELIM	= (DTA_DUMMY + 304)
NATIVE {TDTA_WordWrap}	CONST TDTA_WORDWRAP	= (DTA_DUMMY + 305)

/* There is one line structure for every line of text in the document. */

NATIVE {Line} OBJECT line
    {ln_Link}	link	:mln
    {ln_Text}	text	:/*STRPTR*/ ARRAY OF CHAR
    {ln_TextLen}	textlen	:ULONG
    {ln_XOffset}	xoffset	:UINT
    {ln_YOffset}	yoffset	:UINT
    {ln_Width}	width	:UINT
    {ln_Height}	height	:UINT
    {ln_Flags}	flags	:UINT
    {ln_FgPen}	fgpen	:BYTE
    {ln_BgPen}	bgpen	:BYTE
    {ln_Style}	style	:ULONG
    {ln_Data}	data	:APTR
ENDOBJECT


/* ln_Flags */

NATIVE {LNF_LF}		CONST LNF_LF		= 1 SHL 0
NATIVE {LNF_LINK}	CONST LNF_LINK	= 1 SHL 1
NATIVE {LNF_OBJECT}	CONST LNF_OBJECT	= 1 SHL 2
NATIVE {LNF_SELECTED}	CONST LNF_SELECTED	= 1 SHL 3

NATIVE {ID_FTXT}		CONST ID_FTXT		= "FTXT"
NATIVE {ID_CHRS}		CONST ID_CHRS		= "CHRS"
