@DATABASE "gg:doc/NDK/Guide/Include/gadgets/getfile.h"
@MASTER   "gg:os-include/gadgets/getfile.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:27
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/getfile.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/getfile.h" LINK File}


@{b}Structures@{ub}

@{"gfileFreelist" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 132}  @{"gfileRequest" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 120}


@{b}#defines@{ub}

@{"GETFILE_AcceptPattern" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 80}  @{"GETFILE_DoMultiSelect" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 62}   @{"GETFILE_DoPatterns" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 65}
@{"GETFILE_DoSaveMode" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 59}     @{"GETFILE_Drawer" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 43}          @{"GETFILE_DrawersOnly" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 68}
@{"GETFILE_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 27}          @{"GETFILE_File" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 40}            @{"GETFILE_Filelist" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 86}
@{"GETFILE_FilePartOnly" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 104}   @{"GETFILE_FilterDrawers" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 83}   @{"GETFILE_FilterFunc" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 71}
@{"GETFILE_FullFile" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 46}       @{"GETFILE_FullFileExpand" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 51}  @{"GETFILE_Height" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 37}
@{"GETFILE_LBNodeStructs" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 95}  @{"GETFILE_LeftEdge" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 32}        @{"GETFILE_Pattern" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 56}
@{"GETFILE_ReadOnly" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 99}       @{"GETFILE_RejectIcons" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 74}     @{"GETFILE_RejectPattern" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 77}
@{"GETFILE_TitleText" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 29}      @{"GETFILE_TopEdge" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 33}         @{"GETFILE_Width" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 36}
@{"gfFreeFilelist()" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 143}       @{"GFILE_FREELIST" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 114}          @{"GFILE_REQUEST" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 113}
@{"gfRequestDir()" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 142}         @{"gfRequestFile()" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File" 141}         

@ENDNODE
@NODE File "gadgets/getfile.h"
#ifndef GADGETS_GETFILE_H
#define GADGETS_GETFILE_H
/*
**      $VER: getfile.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the @{"getfile.gadget" LINK "gg:doc/NDK/Guide/getfile_gc/MAIN"} BOOPSI class
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef REACTION_REACTION_H
#include <@{"reaction/reaction.h" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File"}>
#endif

#ifndef INTUITION_GADGETCLASS_H
#include <@{"intuition/gadgetclass.h" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File"}>
#endif

/*****************************************************************************/

/* Attributes defined by the @{"getfile.gadget" LINK "gg:doc/NDK/Guide/getfile_gc/MAIN"} class
 */
#define GETFILE_Dummy                   (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x60000)

#define GETFILE_TitleText               (@{"GETFILE_Dummy" LINK File 27}+1)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) Requester title text (default: None) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFILE_LeftEdge                (@{"GETFILE_Dummy" LINK File 27}+2)
#define GETFILE_TopEdge                 (@{"GETFILE_Dummy" LINK File 27}+3)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Requester coordinates  (default leftedge: 30, topedge: 20) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) */

#define GETFILE_Width                   (@{"GETFILE_Dummy" LINK File 27}+4)
#define GETFILE_Height                  (@{"GETFILE_Dummy" LINK File 27}+5)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Requester dimensions (default height: 200, width: 300) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) */

#define GETFILE_File                    (@{"GETFILE_Dummy" LINK File 27}+6)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) Contents of File gadget (default: None) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}, @{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}) */

#define GETFILE_Drawer                  (@{"GETFILE_Dummy" LINK File 27}+7)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) Contents of Drawer gadget (default: None) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}, @{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}) */

#define GETFILE_FullFile                (@{"GETFILE_Dummy" LINK File 27}+8)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) Complete file name. Replaces @{"GETFILE_Drawer" LINK File 43} and @{"GETFILE_File" LINK File 40} (default: None)
                        (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}, @{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69})
        */

#define GETFILE_FullFileExpand  (@{"GETFILE_Dummy" LINK File 27}+9)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) @{"GETFILE_FullFile" LINK File 46} will give complete file name(s) expanded with @{"NameFromLock()" LINK "gg:doc/NDK/Guide/dos/NameFromLock"} to
                        remove relative paths. (default: @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65})
        */

#define GETFILE_Pattern                 (@{"GETFILE_Dummy" LINK File 27}+10)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) Contents of Pattern gadget (default: "#?") (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}, @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}) */

#define GETFILE_DoSaveMode              (@{"GETFILE_Dummy" LINK File 27}+11)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Being used for saving? (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFILE_DoMultiSelect   (@{"GETFILE_Dummy" LINK File 27}+12)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Do multi-select? (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFILE_DoPatterns              (@{"GETFILE_Dummy" LINK File 27}+13)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Display a Pattern gadget? (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFILE_DrawersOnly             (@{"GETFILE_Dummy" LINK File 27}+14)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Don't display files? (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFILE_FilterFunc              (@{"GETFILE_Dummy" LINK File 27}+15)
        /* (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *) Function to filter files (default: None) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65})  */

#define GETFILE_RejectIcons             (@{"GETFILE_Dummy" LINK File 27}+16)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Display .info files? (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65})  */

#define GETFILE_RejectPattern   (@{"GETFILE_Dummy" LINK File 27}+17)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *) Don't display files matching pattern (default: None) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFILE_AcceptPattern   (@{"GETFILE_Dummy" LINK File 27}+18)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *) Accept only files matching pattern (default: None) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFILE_FilterDrawers   (@{"GETFILE_Dummy" LINK File 27}+19)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Also filter drawers with pattern (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}, @{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

#define GETFILE_Filelist                (@{"GETFILE_Dummy" LINK File 27}+20)
        /* (@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *) If the @{"GETFILE_DoMultiSelect" LINK File 62} tags was used, you can get a pointer
                        to the list of selected files/drawers using this tag. The ln_Name part of
                        each node will contain the filename/drawername for each selected file with
                        a fully qualified path, even if you didn't use the @{"GETFILE_FullFileExpand" LINK File 51}.
                        In single-selected mode, the list will contain the single selected file for
                        notification purposes. Don't forget to free the list using the @{"GFILE_FREELIST" LINK File 114}
                        method! (@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}, @{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}) */

#define GETFILE_LBNodeStructs   (@{"GETFILE_Dummy" LINK File 27}+21)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) @{"GETFILE_Filelist" LINK File 86} will give a list with ListBrowserNodes instead of normal
                        @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} node structures (default: @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}) */

#define GETFILE_ReadOnly                (@{"GETFILE_Dummy" LINK File 27}+22)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) If @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}, a read-only recessed button gadget is used to present the
                        file/drawer information. If @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}, an editable string gadget is used.
                        (default: @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}) (@{"OM_NEW" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 63}) */

#define GETFILE_FilePartOnly    (@{"GETFILE_Dummy" LINK File 27}+23)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) display file part only - valid ONLY in readonly mode!
         */

/*****************************************************************************/

/*
 * @{"getfile.gadget" LINK "gg:doc/NDK/Guide/getfile_gc/MAIN"} methods
 */
#define GFILE_REQUEST   (0x620001L)
#define GFILE_FREELIST  (0x620002L)

/* The @{"GFILE_REQUEST" LINK File 113} method should be called whenever you want to open
 * a file/dir requester.
 */

struct gfileRequest
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID;                                 /* @{"GFILE_REQUEST" LINK File 113} */
        @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *gfile_Window;    /* The window that will be locked when the requester is active. MUST be provided! */
};

/* The @{"GFILE_FREELIST" LINK File 114} method SHOULD be called when you are done doing a multiselect
 * a file/dir select using the tag @{"GETFILE_DoMultiSelect" LINK File 62} and have processed the result.
 * This method will free the list of @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} structures.  If you do not free this
 * list using this method, the list will not be freed until you dispose the class.
 */

struct gfileFreelist
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID;                                 /* @{"GFILE_FREELIST" LINK File 114} */
        @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *gfile_Filelist;    /* The list of @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} obtained using the @{"GETFILE_Filelist" LINK File 86} tag in @{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}.
                                                                                Can be @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}, in which case this method will do nothing. */
};

/* macros for calling the methods easily */

#define gfRequestFile(obj, win)         DoMethod(obj, @{"GFILE_REQUEST" LINK File 113}, win)
#define gfRequestDir(obj, win)          DoMethod(obj, @{"GFILE_REQUEST" LINK File 113}, win)
#define gfFreeFilelist(obj, list)       DoMethod(obj, @{"GFILE_FREELIST" LINK File 114}, list)

#endif /* GADGETS_GETFILE_H */
@ENDNODE
