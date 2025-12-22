@DATABASE "gg:doc/NDK/Guide/Include/render/renderhooks.h"
@MASTER   "gg:os-include/render/renderhooks.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:19
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "render/renderhooks.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"render/renderhooks.h" LINK File}


@{b}Structures@{ub}

@{"RND_LineMessage" LINK "gg:doc/NDK/Guide/Include/render/renderhooks.h/File" 114}  @{"RND_ProgressMessage" LINK "gg:doc/NDK/Guide/Include/render/renderhooks.h/File" 38}


@{b}#defines@{ub}

@{"LMSGTYPE_LINE_FETCH" LINK "gg:doc/NDK/Guide/Include/render/renderhooks.h/File" 131}      @{"LMSGTYPE_LINE_RENDERED" LINK "gg:doc/NDK/Guide/Include/render/renderhooks.h/File" 125}  @{"PMSGTYPE_COLORS_ADAPTED" LINK "gg:doc/NDK/Guide/Include/render/renderhooks.h/File" 74}
@{"PMSGTYPE_COLORS_CHOSEN" LINK "gg:doc/NDK/Guide/Include/render/renderhooks.h/File" 68}   @{"PMSGTYPE_LINES_ADDED" LINK "gg:doc/NDK/Guide/Include/render/renderhooks.h/File" 62}    @{"PMSGTYPE_LINES_CONVERTED" LINK "gg:doc/NDK/Guide/Include/render/renderhooks.h/File" 86}
@{"PMSGTYPE_LINES_RENDERED" LINK "gg:doc/NDK/Guide/Include/render/renderhooks.h/File" 80}  

@ENDNODE
@NODE File "render/renderhooks.h"
#ifndef RENDERHOOKS_H
#define RENDERHOOKS_H
/*
**    $VER: renderhooks.h 18.2 (5.3.97)
**
**    render.library definitions for callback hooks
*/



#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef UTILITY_HOOKS_H
#include <@{"utility/hooks.h" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File"}>
#endif

/******************************************************************************

        Progress Hook Message

        Whenever your progress hook is called, your function
        receives a pointer to this structure in a1. Check the
        message type and proceed accordingly.

        Also, you get a pointer to the object of concern in a2.
        Warning: This is intended for identification only. You
        are @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} allowed to perform operations inside your hook
        function that could modify this object. If you try to
        do so, your code will run into a deadlock.

        Your progress hook has to return @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95} or @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}
        for continuation respective abortion.

******************************************************************************/

struct  RND_ProgressMessage
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   RND_PMsg_type;          /* type of message, see below      */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   RND_PMsg_count;         /* number to be displayed...       */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   RND_PMsg_total;         /* ...inside this range of numbers */
};

/******************************************************************************

        Types of progress messages

        Neither depend on a certain number of calls nor on
        calls in a specific order. It's up to the library
        to decide
        - how often to call your progress hook
        - in what order to submit different types of messages
        - in what step rate to call your progress hook
        - whether to call your progress hook at all

******************************************************************************/

        /* number of lines added to a histogram.
           a2 is a pointer to the histogram. */

#define PMSGTYPE_LINES_ADDED            1


        /* number of colors chosen during quantization.
           a2 is a pointer to the histogram. */

#define PMSGTYPE_COLORS_CHOSEN          2


        /* number of histogram entries adapted to the palette.
           a2 is a pointer to the histogram. */

#define PMSGTYPE_COLORS_ADAPTED         3


        /* number of lines rendered to a palette.
           a2 is a pointer to the palette. */

#define PMSGTYPE_LINES_RENDERED         4


        /* number of lines converted.
           a2 is @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}. */

#define PMSGTYPE_LINES_CONVERTED        5




/******************************************************************************

        Line Hook Message

        This hook is executed by functions such as Render() once
        before and once after converting a line.

        When your line hook is called, your function receives a
        pointer to this structure in a1. Check the message type and
        proceed accordingly. Also, you get a pointer to the object
        of concern in a2. This is either the source or destination
        buffer.

        This allows you to draw, save, convert etc. while rendering,
        and to save memory. Specify @{"RND_DestWidth" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 162} = 0 to render into
        a single-line buffer, and @{"RND_SourceWidth" LINK "gg:doc/NDK/Guide/Include/render/render.h/File" 161} = 0 to fetch from a
        single-line buffer.

        Your line hook has to return @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95} or @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}
        for continuation respective abortion.

******************************************************************************/

struct  RND_LineMessage
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   RND_LMsg_type;          /* type of message, see below */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   RND_LMsg_row;           /* the row number being processed */
};



/* just completed a line. a2 is a pointer to the rendered data.
   You may read from this buffer. */

#define LMSGTYPE_LINE_RENDERED          6


/* now converting a new line. a2 is a pointer to the source buffer
   where the input is expected. You may write to this buffer. */

#define LMSGTYPE_LINE_FETCH             7



/*****************************************************************************/

#endif
@ENDNODE
