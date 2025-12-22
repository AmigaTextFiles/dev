@DATABASE "gg:doc/NDK/Guide/Include/gadgets/chooser.h"
@MASTER   "gg:os-include/gadgets/chooser.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:23
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/chooser.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/chooser.h" LINK File}


@{b}#defines@{ub}

@{"CHJ_CENTER" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 120}          @{"CHJ_LEFT" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 119}          @{"CHJ_RIGHT" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 121}
@{"CHOOSER_Active" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 80}      @{"CHOOSER_AutoFit" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 89}   @{"CHOOSER_DropDown" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 71}
@{"CHOOSER_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 66}       @{"CHOOSER_Hidden" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 104}    @{"CHOOSER_Justification" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 114}
@{"CHOOSER_LabelArray" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 110}  @{"CHOOSER_Labels" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 77}    @{"CHOOSER_MaxLabels" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 92}
@{"CHOOSER_MinHeight" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 27}   @{"CHOOSER_MinWidth" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 26}  @{"CHOOSER_Offset" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 96}
@{"CHOOSER_PopUp" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 68}       @{"CHOOSER_Selected" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 82}  @{"CHOOSER_Title" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 74}
@{"CHOOSER_Width" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 85}       @{"CNA_BGPen" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 53}         @{"CNA_Disabled" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 50}
@{"CNA_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 33}           @{"CNA_FGPen" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 56}         @{"CNA_Image" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 38}
@{"CNA_ReadOnly" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 59}        @{"CNA_SelImage" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 41}      @{"CNA_Separator" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 47}
@{"CNA_Text" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 35}            @{"CNA_UserData" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File" 44}      

@ENDNODE
@NODE File "gadgets/chooser.h"
#ifndef GADGETS_CHOOSER_H
#define GADGETS_CHOOSER_H

/*
**      $VER: chooser.h 45.1 (10.03.2001)
**      Includes Release 45.1
**
**      Definitions for the Chooser BOOPSI class
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

/* Predefined Minimum dimensions for safe operation.
 */
#define CHOOSER_MinWidth           36
#define CHOOSER_MinHeight          10

/*****************************************************************************/

/* Chooser node attributes.
 */
#define CNA_Dummy                       (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0x5001500)

#define CNA_Text                        (@{"CNA_Dummy" LINK File 33}+1)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) Text for the node. */

#define CNA_Image                       (@{"CNA_Dummy" LINK File 33}+2)
        /* (strcut Image *) normal image for node. */

#define CNA_SelImage            (@{"CNA_Dummy" LINK File 33}+3)
        /* (strcut Image *) select image for node. */

#define CNA_UserData            (@{"CNA_Dummy" LINK File 33}+4)
        /* (APRR) user data, use as desired. */

#define CNA_Separator           (@{"CNA_Dummy" LINK File 33}+5)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Render a separator bar. */

#define CNA_Disabled            (@{"CNA_Dummy" LINK File 33}+6)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Disabled entry... */

#define CNA_BGPen                       (@{"CNA_Dummy" LINK File 33}+7)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Background Pen. (not implemented) */

#define CNA_FGPen                       (@{"CNA_Dummy" LINK File 33}+8)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Foreground Pen. (not implemented) */

#define CNA_ReadOnly            (@{"CNA_Dummy" LINK File 33}+9)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Non-selectable entry... */

/*****************************************************************************/

/* Additional attributes defined by the Chooser class
 */
#define CHOOSER_Dummy           (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26}+0x0001000)

#define CHOOSER_PopUp           (@{"CHOOSER_Dummy" LINK File 66}+1)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Make it a popup menu.  Default to @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}. */

#define CHOOSER_DropDown        (@{"CHOOSER_Dummy" LINK File 66}+2)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Make it a dropdown menu.  Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define CHOOSER_Title           (@{"CHOOSER_Dummy" LINK File 66}+3)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) Title for the @{"DropDown" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_macros.h/File" 211}.  Defaults to @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}. */

#define CHOOSER_Labels          (@{"CHOOSER_Dummy" LINK File 66}+4)
        /* (@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *) Exec List of labels, required. */

#define CHOOSER_Active          (@{"CHOOSER_Dummy" LINK File 66}+5)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Active label in the list.  Defaults to 0. */
#define CHOOSER_Selected        (@{"CHOOSER_Active" LINK File 80})
        /* A more logical NEW NAME for the above. */

#define CHOOSER_Width           (@{"CHOOSER_Dummy" LINK File 66}+6)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) The width of the popup menu. Defaults to the width of the
         * gadget. */

#define CHOOSER_AutoFit         (@{"CHOOSER_Dummy" LINK File 66}+7)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Make the menu automatically fit its labels. Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define CHOOSER_MaxLabels       (@{"CHOOSER_Dummy" LINK File 66}+9)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Maximum number of labels to be shown in the menu regardless
         * of how many are in the @{"CHOOSER_Labels" LINK File 77} list.   Defaults to 12.*/

#define CHOOSER_Offset          (@{"CHOOSER_Dummy" LINK File 66}+10)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Add a fixed value offset to the CHOOSE_Selected value
         * for notification methods. This is useful in connecting a Chooser
         * with item id's 0 thru 11 to a Calendar's month which is 1 thru 12.
         * In that situation, a @{"CHOOSER_Offset" LINK File 96} of 1 would be used to match
         * the starting offsets of the respective tags.
         * Defaults to 0.  (V41) */

#define CHOOSER_Hidden          (@{"CHOOSER_Dummy" LINK File 66}+11)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) If set, the chooser will not render its main body, and you
         * may call the Show/HideChooser functions to popup the chooser under
         * under the mouse pointer.
         * Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}.  (V42 prelease - V41.101 or later) */

#define CHOOSER_LabelArray      (@{"CHOOSER_Dummy" LINK File 66}+12)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} *) A null terminated array of strings to use as labels. Use
           ~0 as string to add separator bar to the list. New for v45.2 */

#define CHOOSER_Justification   (@{"CHOOSER_Dummy" LINK File 66}+13)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) How to align the labels. New for v45.3 */

/*      Possible values for @{"CHOOSER_Justification" LINK File 114}
 */
#define CHJ_LEFT                0 /* default */
#define CHJ_CENTER              1
#define CHJ_RIGHT               2

#endif /* GADGETS_CHOOSER_H */
@ENDNODE
