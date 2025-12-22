@DATABASE "gg:doc/NDK/Guide/Include/datatypes/textclass.h"
@MASTER   "gg:os-include/datatypes/textclass.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:15
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "datatypes/textclass.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"datatypes/textclass.h" LINK File}


@{b}Structures@{ub}

@{"Line" LINK "gg:doc/NDK/Guide/Include/datatypes/textclass.h/File" 43}


@{b}#defines@{ub}

@{"ID_CHRS" LINK "gg:doc/NDK/Guide/Include/datatypes/textclass.h/File" 79}        @{"ID_FTXT" LINK "gg:doc/NDK/Guide/Include/datatypes/textclass.h/File" 78}         @{"LNF_LF" LINK "gg:doc/NDK/Guide/Include/datatypes/textclass.h/File" 64}           @{"LNF_LINK" LINK "gg:doc/NDK/Guide/Include/datatypes/textclass.h/File" 67}
@{"LNF_OBJECT" LINK "gg:doc/NDK/Guide/Include/datatypes/textclass.h/File" 70}     @{"LNF_SELECTED" LINK "gg:doc/NDK/Guide/Include/datatypes/textclass.h/File" 73}    @{"TDTA_Buffer" LINK "gg:doc/NDK/Guide/Include/datatypes/textclass.h/File" 32}      @{"TDTA_BufferLen" LINK "gg:doc/NDK/Guide/Include/datatypes/textclass.h/File" 33}
@{"TDTA_LineList" LINK "gg:doc/NDK/Guide/Include/datatypes/textclass.h/File" 34}  @{"TDTA_WordDelim" LINK "gg:doc/NDK/Guide/Include/datatypes/textclass.h/File" 36}  @{"TDTA_WordSelect" LINK "gg:doc/NDK/Guide/Include/datatypes/textclass.h/File" 35}  @{"TDTA_WordWrap" LINK "gg:doc/NDK/Guide/Include/datatypes/textclass.h/File" 37}
@{"TEXTDTCLASS" LINK "gg:doc/NDK/Guide/Include/datatypes/textclass.h/File" 27}    

@ENDNODE
@NODE File "datatypes/textclass.h"
#ifndef DATATYPES_TEXTCLASS_H
#define DATATYPES_TEXTCLASS_H
/*
**  $VER: textclass.h 39.3 (3.8.1992)
**  Includes Release 45.1
**
**  Interface definitions for DataType text objects.
**
**  (C) Copyright 1992-2001 Amiga, Inc.
**      All Rights Reserved
*/

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

#ifndef DATATYPES_DATATYPESCLASS_H
#include <@{"datatypes/datatypesclass.h" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File"}>
#endif

#ifndef LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif

/*****************************************************************************/

#define TEXTDTCLASS             "text.datatype"

/*****************************************************************************/

/* Text attributes */
#define TDTA_Buffer             (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 300)
#define TDTA_BufferLen          (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 301)
#define TDTA_LineList           (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 302)
#define TDTA_WordSelect         (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 303)
#define TDTA_WordDelim          (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 304)
#define TDTA_WordWrap           (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 305)
     /* Boolean. Should the text be word wrapped.  Defaults to false. */

/*****************************************************************************/

/* There is one Line structure for every line of text in our document.  */
struct Line
{
    @{"struct MinNode" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 31}       ln_Link;               /* to link the lines together */
    @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}               ln_Text;               /* pointer to the text for this line */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                ln_TextLen;            /* the character length of the text for this line */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                ln_XOffset;            /* where in the line the text starts */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                ln_YOffset;            /* line the text is on */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                ln_Width;              /* Width of line in pixels */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                ln_Height;             /* Height of line in pixels */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                ln_Flags;              /* info on the line */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}                 ln_FgPen;              /* foreground pen */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}                 ln_BgPen;              /* background pen */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                ln_Style;              /* Font style */
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}                 ln_Data;               /* Link data... */
};

/*****************************************************************************/

/* Line.ln_Flags */

/* Line Feed */
#define LNF_LF          (1L << 0)

/* Segment is a link */
#define LNF_LINK        (1L << 1)

/* ln_Data is a pointer to an DataTypes object */
#define LNF_OBJECT      (1L << 2)

/* Object is selected */
#define LNF_SELECTED    (1L << 3)

/*****************************************************************************/

/* IFF types that may be text */
#define ID_FTXT         @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('F','T','X','T')
#define ID_CHRS         @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('C','H','R','S')

/*****************************************************************************/

#endif  /* DATATYPES_TEXTCLASS_H */
@ENDNODE
