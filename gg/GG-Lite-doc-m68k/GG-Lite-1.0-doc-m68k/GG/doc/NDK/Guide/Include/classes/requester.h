@DATABASE "gg:doc/NDK/Guide/Include/classes/requester.h"
@MASTER   "gg:os-include/classes/requester.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:21
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "classes/requester.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"classes/requester.h" LINK File}


@{b}Structures@{ub}

@{"orRequest" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 167}


@{b}#defines@{ub}

@{"OpenRequester()" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 186}     @{"REQ_BodyText" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 36}       @{"REQ_Dummy" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 23}
@{"REQ_GadgetText" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 40}      @{"REQ_ReturnCode" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 44}     @{"REQ_TabSize" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 48}
@{"REQ_TitleText" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 32}       @{"REQ_Type" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 28}           @{"REQI_Arrows" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 70}
@{"REQI_Dummy" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 25}          @{"REQI_Invisible" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 62}     @{"REQI_MaxChars" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 74}
@{"REQI_Maximum" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 59}        @{"REQI_Minimum" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 56}       @{"REQI_Number" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 66}
@{"REQP_AbortText" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 123}      @{"REQP_CenterWindow" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 140}  @{"REQP_Current" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 120}
@{"REQP_Dummy" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 26}          @{"REQP_Dynamic" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 136}       @{"REQP_LastPosition" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 143}
@{"REQP_NoText" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 133}         @{"REQP_OpenInactive" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 130}  @{"REQP_Percent" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 146}
@{"REQP_ProgressText" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 127}   @{"REQP_ShortTicks" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 152}    @{"REQP_Ticks" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 149}
@{"REQP_Total" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 117}          @{"REQS_AllowEmpty" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 82}    @{"REQS_Buffer" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 90}
@{"REQS_ChooserActive" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 108}  @{"REQS_ChooserArray" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 103}  @{"REQS_Dummy" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 24}
@{"REQS_Invisible" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 86}      @{"REQS_MaxChars" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 98}      @{"REQS_ShowDefault" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 94}
@{"REQTYPE_INFO" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 179}        @{"REQTYPE_INTEGER" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 180}    @{"REQTYPE_PROGRESS" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 182}
@{"REQTYPE_STRING" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 181}      @{"RequesterObject" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 187}    @{"RM_OPENREQ" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File" 161}

@ENDNODE
@NODE File "classes/requester.h"
#ifndef CLASSES_REQUESTER_H
#define CLASSES_REQUESTER_H
/*
**      $VER: requester.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      requester.class definitions
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef REACTION_REACTION_H
#include <@{"reaction/reaction.h" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File"}>
#endif

/*****************************************************************************/

/* Attributes defined by the requester.gadget class
 */
#define REQ_Dummy                               (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x45000)
#define REQS_Dummy                              (@{"REQ_Dummy" LINK File 23} + 0x100)
#define REQI_Dummy                              (@{"REQ_Dummy" LINK File 23} + 0x200)
#define REQP_Dummy                              (@{"REQ_Dummy" LINK File 23} + 0x300)

#define REQ_Type                                (@{"REQ_Dummy" LINK File 23}+1)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Type of requester. See definitions below.
                        (default: @{"REQTYPE_INFO" LINK File 179}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */

#define REQ_TitleText                   (@{"REQ_Dummy" LINK File 23}+2)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *) Title text of the requester (default: None)
                                (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */

#define REQ_BodyText                    (@{"REQ_Dummy" LINK File 23}+3)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *) Body text of the requester (default: None)
                                (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */

#define REQ_GadgetText                  (@{"REQ_Dummy" LINK File 23}+4)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *) Gadget text(s) for the requester
                        (default: " _Ok | _Cancel ") (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */

#define REQ_ReturnCode                  (@{"REQ_Dummy" LINK File 23}+5)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Last return code of the requester (default: 0)
                                (@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) */

#define REQ_TabSize                             (@{"REQ_Dummy" LINK File 23}+6) /* @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} IMPLEMENTED YET */
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Tab size to use when formatting the bodytext (default: 8)
                                (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */

/**********************************
* integer request type attributes *
**********************************/

#define REQI_Minimum                    (@{"REQI_Dummy" LINK File 25}+1)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Minimum allowed value (default: @{"MININT" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 44}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */

#define REQI_Maximum                    (@{"REQI_Dummy" LINK File 25}+2)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Maximum allowed value (default: @{"MAXINT" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 43}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */

#define REQI_Invisible                  (@{"REQI_Dummy" LINK File 25}+3) /* @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} IMPLEMENTED YET */
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Integer input will be echoed with '.' and not what the user
                        actually types (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */

#define REQI_Number                             (@{"REQI_Dummy" LINK File 25}+4)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Number to show in gadget (default: 0)
                        (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}, @{"RM_OPENREQ" LINK File 161}) */

#define REQI_Arrows                             (@{"REQI_Dummy" LINK File 25}+5)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Show arrows to the right of the integer gadget (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98})
                        (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */

#define REQI_MaxChars                   (@{"REQI_Dummy" LINK File 25}+6)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Maximum number of characters for the number (including negative
                        sign). (default: 10) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */

/*********************************
* string request type attributes *
*********************************/

#define REQS_AllowEmpty                 (@{"REQS_Dummy" LINK File 24}+1)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Allow empty string to be accepted. (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98})
                        (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */

#define REQS_Invisible                  (@{"REQI_Invisible" LINK File 62}) /* @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} IMPLEMENTED YET */
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) String input will be echoed with '.' and not what the user
                        actually types (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */

#define REQS_Buffer                             (@{"REQS_Dummy" LINK File 24}+2)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *) Buffer used in the string gadget. MUST be provided.
                        (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */

#define REQS_ShowDefault                (@{"REQS_Dummy" LINK File 24}+3)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Show content of @{"REQS_Buffer" LINK File 90} in string gadget. (default: @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95})
                        (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */

#define REQS_MaxChars                   (@{"REQS_Dummy" LINK File 24}+4)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Maximum number of characters in string gadget. Must not be
                        larger than size of @{"REQS_Buffer" LINK File 90} - 1. (default: 127)
                        (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */

#define REQS_ChooserArray               (@{"REQS_Dummy" LINK File 24}+5)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} **) An array of strings that will be added to a chooser gadget
                        to the right of the string gadget.
                        (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */

#define REQS_ChooserActive      (@{"REQS_Dummy" LINK File 24}+6)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) The current active entry among the strings passed in
                        using REQS_ChooserOptions.  (default: 0)
                        (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}, @{"RM_OPENREQ" LINK File 161}) */

/**********************************
* progress window type attributes *
**********************************/

#define REQP_Total                              (@{"REQP_Dummy" LINK File 26}+1)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Total number of levels for the progressbar. (default: 100)
                        (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */
#define REQP_Current                    (@{"REQP_Dummy" LINK File 26}+2)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) The current level of the progressbar. (default: 0)
                        (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */
#define REQP_AbortText                  @{"REQ_GadgetText" LINK File 40}
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *) Text to be put into the gadget that will abort the progressbar.
                        If not present, no gadget will be created.
                        (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */
#define REQP_ProgressText               @{"REQ_BodyText" LINK File 36}
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *) Text to be shown over the progressbar.
                        (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */
#define REQP_OpenInactive               (@{"REQP_Dummy" LINK File 26}+3)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Open window inactive if ta_Data is @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}.
                        (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"RM_OPENREQ" LINK File 161}) */
#define REQP_NoText                             (@{"REQP_Dummy" LINK File 26}+4)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91})  No text-gadget in progressbar if ti_Data is @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}
                        (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"RM_OPENREQ" LINK File 161}) */
#define REQP_Dynamic                    (@{"REQP_Dummy" LINK File 26}+5)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91})  @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95} if the pb should size automatically when
                a too long progresstext is set. Default is @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}.
                (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */
#define REQP_CenterWindow               (@{"REQP_Dummy" LINK File 26}+6)
        /* (@{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *) The progressbar is centered over this window.
                (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */
#define REQP_LastPosition               (@{"REQP_Dummy" LINK File 26}+7)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Open progressbar on the same place the last was. Default is @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}.
                (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"RM_OPENREQ" LINK File 161}) */
#define REQP_Percent                    (@{"REQP_Dummy" LINK File 26}+8)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Render numeric percentage display.
                (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"RM_OPENREQ" LINK File 161}) */
#define REQP_Ticks                              (@{"REQP_Dummy" LINK File 26}+9)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) If present, how many tick marks
                (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"RM_OPENREQ" LINK File 161}) */
#define REQP_ShortTicks                 (@{"REQP_Dummy" LINK File 26}+10)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Enable small intermediate tick marks.
                (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"RM_OPENREQ" LINK File 161}) */

/*****************************************************************************/

/*
 * requester.class methods
 */
#define RM_OPENREQ              (0x650001L)

/* The @{"RM_OPENREQ" LINK File 161} method should be called whenever you want to open
 * a requester.
 */

struct orRequest
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID;                         /* @{"RM_OPENREQ" LINK File 161} */
        @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *or_Attrs;       /* List of tag attributes */
        @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *or_Window;       /* Reference window for requester. */
        @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *or_Screen;       /* Reference screen for requester. REQUIRED if or_Window is */
                                                                /* not supplied */
};

/* The @{"REQ_Type" LINK File 28} must be used to set what type of requester you
 * want to use. Here are the definitions:
 */
#define REQTYPE_INFO            0               /* Normal information/query requester like @{"EasyRequest()" LINK "gg:doc/NDK/Guide/intuition/EasyRequestArgs"} */
#define REQTYPE_INTEGER         1               /* Get an integer from the user */
#define REQTYPE_STRING          2               /* Get a string from the user */
#define REQTYPE_PROGRESS        3               /* Progressbar window (@{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} IMPLEMENTED YET) */

/* Useful macros */
#ifndef RequesterObject
#define OpenRequester(obj, win) DoMethod(obj, @{"RM_OPENREQ" LINK File 161}, @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}, win, @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}, @{"TAG_DONE" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 39})
#define RequesterObject                 NewObject(@{"REQUESTER_GetClass" LINK "gg:doc/NDK/Guide/Include/inline/requester.h/File" 23}(), @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}
#endif

#endif /* CLASSES_REQUESTER_H */
@ENDNODE
