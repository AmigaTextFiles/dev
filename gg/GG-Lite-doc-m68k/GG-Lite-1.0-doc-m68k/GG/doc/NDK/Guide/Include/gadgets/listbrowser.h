@DATABASE "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h"
@MASTER   "gg:os-include/gadgets/listbrowser.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:36
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/listbrowser.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/listbrowser.h" LINK File}


@{b}Structures@{ub}

@{"ColumnInfo" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 285}  @{"lbAddNode" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 32}       @{"LBDrawMsg" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 248}  @{"lbEditNode" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 60}  @{"lbHideChildren" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 100}
@{"lbRemNode" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 47}   @{"lbShowChildren" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 87}  @{"lbSort" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 73}     @{"LBSortMsg" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 260}   


@{b}#defines@{ub}

@{"CIF_DRAGGABLE" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 296}               @{"CIF_FIXED" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 295}
@{"CIF_NOSEPARATORS" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 297}            @{"CIF_SORTABLE" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 298}
@{"CIF_WEIGHTED" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 294}                @{"LB_DRAW" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 234}
@{"LBCB_OK" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 238}                     @{"LBCB_UNKNOWN" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 239}
@{"LBCIA_Column" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 307}                @{"LBCIA_Flags" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 315}
@{"LBCIA_MemPool" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 304}               @{"LBCIA_Title" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 309}
@{"LBCIA_Weight" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 311}                @{"LBCIA_Width" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 313}
@{"LBFLG_CUSTOMPENS" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 205}            @{"LBFLG_HASCHILDREN" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 206}
@{"LBFLG_HIDDEN" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 208}                @{"LBFLG_READONLY" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 204}
@{"LBFLG_SHOWCHILDREN" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 207}          @{"LBM_ADDNODE" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 30}
@{"LBM_EDITNODE" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 58}                @{"LBM_HIDECHILDREN" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 98}
@{"LBM_REMNODE" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 45}                 @{"LBM_SHOWCHILDREN" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 85}
@{"LBM_SORT" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 71}                    @{"LBNA_CheckBox" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 165}
@{"LBNA_Checked" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 168}                @{"LBNA_Column" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 124}
@{"LBNA_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 113}                  @{"LBNA_Flags" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 118}
@{"LBNA_Generation" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 151}             @{"LBNA_MemPool" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 183}
@{"LBNA_NodeSize" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 171}               @{"LBNA_NumColumns" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 186}
@{"LBNA_Priority" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 189}               @{"LBNA_Selected" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 115}
@{"LBNA_UserData" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 121}               @{"LBNCA_BGPen" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 137}
@{"LBNCA_CopyInteger" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 192}           @{"LBNCA_CopyText" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 162}
@{"LBNCA_Editable" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 154}              @{"LBNCA_EditTags" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 174}
@{"LBNCA_FGPen" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 134}                 @{"LBNCA_HookHeight" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 180}
@{"LBNCA_HorizJustify" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 147}          @{"LBNCA_Image" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 140}
@{"LBNCA_Integer" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 131}               @{"LBNCA_Justification" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 148}
@{"LBNCA_MaxChars" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 158}              @{"LBNCA_RenderHook" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 177}
@{"LBNCA_SelImage" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 143}              @{"LBNCA_Text" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 128}
@{"LBNCA_VertJustify" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 198}           @{"LBNCA_WordWrap" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 195}
@{"LBP_BOTTOM" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 496}                  @{"LBP_LEFTEDGE" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 499}
@{"LBP_LINEDOWN" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 492}                @{"LBP_LINEUP" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 491}
@{"LBP_PAGEDOWN" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 494}                @{"LBP_PAGEUP" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 493}
@{"LBP_RIGHTEDGE" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 500}               @{"LBP_SHIFTLEFT" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 497}
@{"LBP_SHIFTRIGHT" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 498}              @{"LBP_TOP" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 495}
@{"LBR_NORMAL" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 243}                  @{"LBR_SELECTED" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 244}
@{"LBRE_CHECKED" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 509}                @{"LBRE_COLUMNADJUST" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 512}
@{"LBRE_DOUBLECLICK" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 508}            @{"LBRE_EDIT" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 507}
@{"LBRE_HIDECHILDREN" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 505}           @{"LBRE_NORMAL" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 504}
@{"LBRE_SHOWCHILDREN" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 506}           @{"LBRE_TITLECLICK" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 511}
@{"LBRE_UNCHECKED" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 510}              @{"LCJ_CENTER" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 214}
@{"LCJ_CENTRE" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 217}                  @{"LCJ_LEFT" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 213}
@{"LCJ_RIGHT" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 215}                   @{"LISTBROWSER_AutoFit" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 369}
@{"LISTBROWSER_Borderless" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 354}      @{"LISTBROWSER_CheckImage" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 438}
@{"LISTBROWSER_ColumnInfo" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 345}      @{"LISTBROWSER_ColumnTitles" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 372}
@{"LISTBROWSER_CursorNode" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 475}      @{"LISTBROWSER_CursorSelect" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 472}
@{"LISTBROWSER_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 321}           @{"LISTBROWSER_Editable" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 410}
@{"LISTBROWSER_EditColumn" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 416}      @{"LISTBROWSER_EditNode" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 413}
@{"LISTBROWSER_EditTags" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 419}        @{"LISTBROWSER_FastRender" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 478}
@{"LISTBROWSER_HideImage" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 398}       @{"LISTBROWSER_Hierarchical" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 392}
@{"LISTBROWSER_HorizontalProp" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 360}  @{"LISTBROWSER_HorizSeparators" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 435}
@{"LISTBROWSER_HPropTop" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 384}        @{"LISTBROWSER_HPropTotal" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 383}
@{"LISTBROWSER_HPropVisible" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 385}    @{"LISTBROWSER_Labels" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 329}
@{"LISTBROWSER_LeafImage" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 401}       @{"LISTBROWSER_Left" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 363}
@{"LISTBROWSER_MakeVisible" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 348}     @{"LISTBROWSER_MinNodeSize" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 447}
@{"LISTBROWSER_MinVisible" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 453}      @{"LISTBROWSER_MouseX" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 388}
@{"LISTBROWSER_MouseY" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 389}          @{"LISTBROWSER_MultiSelect" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 338}
@{"LISTBROWSER_NumSelected" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 429}     @{"LISTBROWSER_PersistSelect" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 469}
@{"LISTBROWSER_Position" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 423}        @{"LISTBROWSER_RelColumn" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 432}
@{"LISTBROWSER_RelEvent" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 426}        @{"LISTBROWSER_Reserved1" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 326}
@{"LISTBROWSER_Reserved2" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 366}       @{"LISTBROWSER_Reserved6" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 463}
@{"LISTBROWSER_Reserved7" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 466}       @{"LISTBROWSER_ScrollRaster" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 404}
@{"LISTBROWSER_Selected" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 332}        @{"LISTBROWSER_SelectedNode" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 335}
@{"LISTBROWSER_Separators" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 342}      @{"LISTBROWSER_ShowImage" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 395}
@{"LISTBROWSER_ShowSelected" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 375}    @{"LISTBROWSER_Spacing" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 407}
@{"LISTBROWSER_TitleClickable" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 450}  @{"LISTBROWSER_Top" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 323}
@{"LISTBROWSER_TotalNodes" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 444}      @{"LISTBROWSER_TotalVisibleNodes" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 482}
@{"LISTBROWSER_UncheckedImage" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 441}  @{"LISTBROWSER_VerticalProp" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 357}
@{"LISTBROWSER_VertSeparators" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 341}  @{"LISTBROWSER_VirtualWidth" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 351}
@{"LISTBROWSER_VPropTop" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 379}        @{"LISTBROWSER_VPropTotal" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 378}
@{"LISTBROWSER_VPropVisible" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 380}    @{"LISTBROWSER_WrapText" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 485}
@{"LRJ_BOTTOM" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 222}                  @{"LRJ_CENTER" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 223}
@{"LRJ_CENTRE" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 226}                  @{"LRJ_TOP" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 224}

@ENDNODE
@NODE File "gadgets/listbrowser.h"
#ifndef GADGETS_LISTBROWSER_H
#define GADGETS_LISTBROWSER_H
/*
**      $VER: listbrowser.h 45.1 (07.03.2001)
**      Includes Release 45.1
**
**      Definitions for the ListBrowser BOOPSI class
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

/* @{"LBM_ADDNODE" LINK "gg:doc/NDK/Guide/listbrowser_gc/LBM_ADDNODE"} creates a listbrowser node and inserts it to the currently
 * attached list. The number of columns is automatically set according to the
 * object's column number. If the node would become visible, it is automatically
 * rendered. This method returns the address of the new node. (V41)
 */
#define @{"LBM_ADDNODE" LINK "gg:doc/NDK/Guide/listbrowser_gc/LBM_ADDNODE"} (0x580001L)

struct lbAddNode
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID;                                     /* @{"LBM_ADDNODE" LINK "gg:doc/NDK/Guide/listbrowser_gc/LBM_ADDNODE"} */
    @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25} *lba_GInfo;       /* to provide rendering info */
    @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *lba_Node;              /* @{"Insert()" LINK "gg:doc/NDK/Guide/exec/Insert"} after this node */
    @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *lba_NodeAttrs;      /* LBNA taglist */
};


/* @{"LBM_REMNODE" LINK "gg:doc/NDK/Guide/listbrowser_gc/LBM_REMNODE"} removes and frees the chosen node. If the node was visible, the
 * display is updated. The method returns 1 if the operation was successful.
 * (V41)
 */
#define @{"LBM_REMNODE" LINK "gg:doc/NDK/Guide/listbrowser_gc/LBM_REMNODE"} (0x580002L)

struct lbRemNode
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID;                                     /* @{"LBM_REMNODE" LINK "gg:doc/NDK/Guide/listbrowser_gc/LBM_REMNODE"} */
    @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25} *lbr_GInfo;       /* to provide rendering info */
    @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *lbr_Node;                      /* @{"Remove()" LINK "gg:doc/NDK/Guide/exec/Remove"} this node */
};


/* @{"LBM_EDITNODE" LINK "gg:doc/NDK/Guide/listbrowser_gc/LBM_EDITNODE"} changes the chosen node's attributes and renders the
 * changes. The method returns 1 if the operation was successful. (V41)
 */
#define @{"LBM_EDITNODE" LINK "gg:doc/NDK/Guide/listbrowser_gc/LBM_EDITNODE"} (0x580003L)

struct lbEditNode
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID;                                     /* @{"LBM_EDITNODE" LINK "gg:doc/NDK/Guide/listbrowser_gc/LBM_EDITNODE"} */
    @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25} *lbe_GInfo;       /* to provide rendering info */
    @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *lbe_Node;                      /* modify this node */
    @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *lbe_NodeAttrs;      /* according to this taglist */
};


/* @{"LBM_SORT" LINK File 71}
 */
#define LBM_SORT (0x580004L)

struct lbSort
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID;                                 /* @{"LBM_SORT" LINK File 71} */
        @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25} *lbs_GInfo;   /* to provide rendering info */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} lbs_Column;                               /* Column to sort by */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} lbs_Reverse;                              /* Reverse sort */
        @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *lbs_CompareHook;   /* Optional hook to compare items */
};


/* @{"LBM_SHOWCHILDREN" LINK File 85}
 */
#define LBM_SHOWCHILDREN (0x580005L)

struct lbShowChildren
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID;                                 /* @{"LBM_SHOWCHILDREN" LINK File 85} */
        @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25} *lbsc_GInfo;  /* to provide rendering info */
        @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *lbsc_Node;                 /* Starting ParentNode, @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} means start at root. */
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} lbsc_Depth;                                /* Depth to Show */
};


/* @{"LBM_HIDECHILDREN" LINK File 98}
 */
#define LBM_HIDECHILDREN (0x580006L)

struct lbHideChildren
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID;                                 /* @{"LBM_HIDECHILDREN" LINK File 98} */
        @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25} *lbhc_GInfo;  /* to provide rendering info */
        @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *lbhc_Node;                 /* Starting ParentNode, @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} means start at root. */
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} lbhc_Depth;                                /* Depth to Hide */
};


/*****************************************************************************/

/* ListBrowser Node attributes.
 */
#define LBNA_Dummy                      (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0x5003500)

#define LBNA_Selected           (@{"LBNA_Dummy" LINK File 113}+1)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) If the node is to be selected.  Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define LBNA_Flags                      (@{"LBNA_Dummy" LINK File 113}+2)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Flags for the node.  Defaults to 0. */

#define LBNA_UserData           (@{"LBNA_Dummy" LINK File 113}+3)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) User data.  Defaults to @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}. */

#define LBNA_Column                     (@{"LBNA_Dummy" LINK File 113}+4)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Column in the node that the attributes below effect.   Defaults
         * to 0.*/

#define LBNCA_Text                      (@{"LBNA_Dummy" LINK File 113}+5)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) Text to display in the column.  Defaults to @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}. */

#define LBNCA_Integer           (@{"LBNA_Dummy" LINK File 113}+6)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} *) Pointer to an integer to display in the column.  Defaults to @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}. */

#define LBNCA_FGPen                     (@{"LBNA_Dummy" LINK File 113}+7)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Column foreground pen. */

#define LBNCA_BGPen                     (@{"LBNA_Dummy" LINK File 113}+8)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Column background pen. */

#define LBNCA_Image                     (@{"LBNA_Dummy" LINK File 113}+9)
        /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) Image to display in the column.  Defaults to @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}. */

#define LBNCA_SelImage          (@{"LBNA_Dummy" LINK File 113}+10)
        /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) Image to display in column when selected.  Defaults
         * to @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}. */

#define LBNCA_HorizJustify      (@{"LBNA_Dummy" LINK File 113}+11)
#define LBNCA_Justification     @{"LBNCA_HorizJustify" LINK File 147}
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Column justification.  Defaults to @{"LCJ_LEFT" LINK File 213}. */

#define LBNA_Generation         (@{"LBNA_Dummy" LINK File 113}+12)
        /* Node generation.  Defaults to 0. */

#define LBNCA_Editable          (@{"LBNA_Dummy" LINK File 113}+13)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) If this column is editable.  Requires @{"LBNCA_CopyText" LINK File 162}. Defaults
         * to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define LBNCA_MaxChars          (@{"LBNA_Dummy" LINK File 113}+14)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Maximum characters in an editable entry.  Required when using
         * @{"LBNCA_Editable" LINK File 154}. */

#define LBNCA_CopyText          (@{"LBNA_Dummy" LINK File 113}+15)
        /* Copy the @{"LBNCA_Text" LINK File 128} contents to an internal buffer. */

#define LBNA_CheckBox           (@{"LBNA_Dummy" LINK File 113}+16)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) this is a checkbox node */

#define LBNA_Checked            (@{"LBNA_Dummy" LINK File 113}+17)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) is checked if true */

#define LBNA_NodeSize           (@{"LBNA_Dummy" LINK File 113}+18)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) size of custom node and optimzie mempool puddles */

#define LBNCA_EditTags          (@{"LBNA_Dummy" LINK File 113}+19)
        /* (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) taglist sent to editable string */

#define LBNCA_RenderHook        (@{"LBNA_Dummy" LINK File 113}+20)
        /* (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *) effectivly the same as gadtools listview hook */

#define LBNCA_HookHeight        (@{"LBNA_Dummy" LINK File 113}+22)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) height in pixels of the hook function rendering */

#define LBNA_MemPool    (@{"LBNA_Dummy" LINK File 113}+23)
        /* (@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}) exec memory pool to use */

#define LBNA_NumColumns (@{"LBNA_Dummy" LINK File 113}+24)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) for @{"GetListBrowserNodeAttrs()" LINK "gg:doc/NDK/Guide/listbrowser_gc/GetListBrowserNodeAttrsA"} only! */

#define LBNA_Priority   (@{"LBNA_Dummy" LINK File 113}+25)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}) Sets the exec node->ln_Pri */

#define LBNCA_CopyInteger       (@{"LBNA_Dummy" LINK File 113}+26)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) AllocListBrowserNodeAttrs() or @{"SetListBrowserNodeAttrs()" LINK "gg:doc/NDK/Guide/listbrowser_gc/SetListBrowserNodeAttrsA"} only! */

#define LBNCA_WordWrap          (@{"LBNA_Dummy" LINK File 113}+27)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) WordWrap this node's @{"LBNCA_Text" LINK File 128} data */

#define LBNCA_VertJustify       (@{"LBNA_Dummy" LINK File 113}+28)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Row justification.  Defaults to @{"LRJ_BOTTOM" LINK File 222}. */


/* Flags for the @{"LBNA_Flags" LINK File 118} node attribute.
 */
#define LBFLG_READONLY 1
#define LBFLG_CUSTOMPENS 2
#define LBFLG_HASCHILDREN 4
#define LBFLG_SHOWCHILDREN 8
#define LBFLG_HIDDEN 16


/* Justification modes for the LBNA_HorizJustify node column attribute.
 */
#define LCJ_LEFT 0
#define LCJ_CENTER 1
#define LCJ_RIGHT 2

#define LCJ_CENTRE @{"LCJ_CENTER" LINK File 214}


/* Justification modes for the LBNA_VertJustify node column attribute.
 */
#define LRJ_BOTTOM 0
#define LRJ_CENTER 1
#define LRJ_TOP 2

#define LRJ_CENTRE @{"LRJ_CENTER" LINK File 223}


/* These definitions are for the @{"LBNCA_RenderHook" LINK File 177} tag.
 */

/* The different types of messages that a listview callback hook can see.
 */
#define LB_DRAW 0x202L                                  /* Draw yourself, with state */

/* Possible return values from a render hook.
 */
#define LBCB_OK 0                                               /* callback understands this message type */
#define LBCB_UNKNOWN 1                                  /* callback does not understand this message */

/* States for LBDrawMsg.lbdm_State.
 */
#define LBR_NORMAL 0                                    /* The usual */
#define LBR_SELECTED 1                                  /* For selected gadgets */

/* Structure of @{"LB_DRAW" LINK File 234} messages, object is a (@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *).
 */
struct LBDrawMsg
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} lbdm_MethodID;                                /* @{"LV_DRAW" LINK "gg:doc/NDK/Guide/Include/libraries/gadtools.h/File" 432} */
    @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *lbdm_RastPort;             /* Where to render to */
    @{"struct DrawInfo" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 66} *lbdm_DrawInfo;             /* Useful to have around */
    @{"struct Rectangle" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 27} lbdm_Bounds;               /* Limits of where to render */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} lbdm_State;                                   /* How to render */
};


/* Sort Hook Data Structure.
 */
struct LBSortMsg
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} lbsm_TypeA;
        union
                @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} Integer;
                @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"Text" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 73};
        } lbsm_DataA;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} lbsm_UserDataA;

        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} lbsm_TypeB;
        union
                @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} Integer;
                @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"Text" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 73};
        } lbsm_DataB;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} lbsm_UserDataB;
};



/*****************************************************************************/

/* Information for columns of the list browser.
 */
struct ColumnInfo
{
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} ci_Width;
        @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} ci_Title;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ci_Flags;
};

/* Possible ColumnInfo Flags
 */
#define CIF_WEIGHTED 0  /* weighted width column */
#define CIF_FIXED 1             /* fixed pixel width column */
#define CIF_DRAGGABLE 2
#define CIF_NOSEPARATORS 4
#define CIF_SORTABLE 8

/* v45 @{"AllocLBColumnInfo" LINK "gg:doc/NDK/Guide/Include/inline/listbrowser.h/File" 90}(), SetLBColumnInfo(), GetLBColumnInfo()
 * attributes.
 */

#define LBCIA_MemPool   (@{"LBNA_Dummy" LINK File 113}+50)
        /* (@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}) (V45) MemPool for ColumnInfo */

#define LBCIA_Column    (@{"LBNA_Dummy" LINK File 113}+51)

#define LBCIA_Title             (@{"LBNA_Dummy" LINK File 113}+52)

#define LBCIA_Weight    (@{"LBNA_Dummy" LINK File 113}+53)

#define LBCIA_Width             (@{"LBNA_Dummy" LINK File 113}+54)

#define LBCIA_Flags             (@{"LBNA_Dummy" LINK File 113}+55)

/*****************************************************************************/

/* Additional attributes defined by the List Browser class
 */
#define LISTBROWSER_Dummy                       (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26}+0x0003000)

#define LISTBROWSER_Top                         (@{"LISTBROWSER_Dummy" LINK File 321}+1)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Top position node. Defauts to 0. */

#define LISTBROWSER_Reserved1           (@{"LISTBROWSER_Dummy" LINK File 321}+2)
        /* RESERVED */

#define LISTBROWSER_Labels                      (@{"LISTBROWSER_Dummy" LINK File 321}+3)
        /* (@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *) Defaults to ~0. */

#define LISTBROWSER_Selected            (@{"LISTBROWSER_Dummy" LINK File 321}+4)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) numeric index of node currently selected; Defaults to -1. */

#define LISTBROWSER_SelectedNode        (@{"LISTBROWSER_Dummy" LINK File 321}+5)
        /* (@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *) node currently seleted */

#define LISTBROWSER_MultiSelect         (@{"LISTBROWSER_Dummy" LINK File 321}+6)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define LISTBROWSER_VertSeparators      (@{"LISTBROWSER_Dummy" LINK File 321}+7)
#define LISTBROWSER_Separators          @{"LISTBROWSER_VertSeparators" LINK File 341}
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Render column separators. Defaults to @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}. */

#define LISTBROWSER_ColumnInfo          (@{"LISTBROWSER_Dummy" LINK File 321}+8)
        /* (@{"struct ColumnInfo" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File" 285} *) Defaults to @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}. */

#define LISTBROWSER_MakeVisible         (@{"LISTBROWSER_Dummy" LINK File 321}+9)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Defaults to 0. */

#define LISTBROWSER_VirtualWidth        (@{"LISTBROWSER_Dummy" LINK File 321}+10)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Defaults to 0. */

#define LISTBROWSER_Borderless          (@{"LISTBROWSER_Dummy" LINK File 321}+11)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define LISTBROWSER_VerticalProp        (@{"LISTBROWSER_Dummy" LINK File 321}+12)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Defaults to @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}. */

#define LISTBROWSER_HorizontalProp      (@{"LISTBROWSER_Dummy" LINK File 321}+13)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define LISTBROWSER_Left                        (@{"LISTBROWSER_Dummy" LINK File 321}+14)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Defaults to 0. */

#define LISTBROWSER_Reserved2           (@{"LISTBROWSER_Dummy" LINK File 321}+15)
        /* RESERVED */

#define LISTBROWSER_AutoFit                     (@{"LISTBROWSER_Dummy" LINK File 321}+16)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define LISTBROWSER_ColumnTitles        (@{"LISTBROWSER_Dummy" LINK File 321}+17)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define LISTBROWSER_ShowSelected        (@{"LISTBROWSER_Dummy" LINK File 321}+18)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define LISTBROWSER_VPropTotal          (@{"LISTBROWSER_Dummy" LINK File 321}+19)
#define LISTBROWSER_VPropTop            (@{"LISTBROWSER_Dummy" LINK File 321}+20)
#define LISTBROWSER_VPropVisible        (@{"LISTBROWSER_Dummy" LINK File 321}+21)
        /* State of the vertical prop gadget (if any). */

#define LISTBROWSER_HPropTotal          (@{"LISTBROWSER_Dummy" LINK File 321}+22)
#define LISTBROWSER_HPropTop            (@{"LISTBROWSER_Dummy" LINK File 321}+23)
#define LISTBROWSER_HPropVisible        (@{"LISTBROWSER_Dummy" LINK File 321}+24)
        /* State of the horizontal prop gadget (if any). */

#define LISTBROWSER_MouseX                      (@{"LISTBROWSER_Dummy" LINK File 321}+25)
#define LISTBROWSER_MouseY                      (@{"LISTBROWSER_Dummy" LINK File 321}+26)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Returns position of mouse release. */

#define LISTBROWSER_Hierarchical        (@{"LISTBROWSER_Dummy" LINK File 321}+27)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Enables ListTree mode. Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define LISTBROWSER_ShowImage           (@{"LISTBROWSER_Dummy" LINK File 321}+28)
        /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) ListTree expanded branchh custom image. Defaults to @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}. */

#define LISTBROWSER_HideImage           (@{"LISTBROWSER_Dummy" LINK File 321}+29)
        /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) ListTree colapsed branch custom image. Defaults to @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}. */

#define LISTBROWSER_LeafImage           (@{"LISTBROWSER_Dummy" LINK File 321}+30)
        /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) ListTree branch item custom image. Defaults to @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}. */

#define LISTBROWSER_ScrollRaster        (@{"LISTBROWSER_Dummy" LINK File 321}+31)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) See autodocs for Intuition V37 bug.  Defaults to @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}. */

#define LISTBROWSER_Spacing                     (@{"LISTBROWSER_Dummy" LINK File 321}+32)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Defaults to 0. */

#define LISTBROWSER_Editable            (@{"LISTBROWSER_Dummy" LINK File 321}+33)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define LISTBROWSER_EditNode            (@{"LISTBROWSER_Dummy" LINK File 321}+35)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Specify a node to edit. */

#define LISTBROWSER_EditColumn          (@{"LISTBROWSER_Dummy" LINK File 321}+36)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Specify a column to edit */

#define LISTBROWSER_EditTags            (@{"LISTBROWSER_Dummy" LINK File 321}+39)
        /* (@{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *) Taglist passed to editible node string gadget.
           Defaults to @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}. */

#define LISTBROWSER_Position            (@{"LISTBROWSER_Dummy" LINK File 321}+34)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) See possible values below. */

#define LISTBROWSER_RelEvent            (@{"LISTBROWSER_Dummy" LINK File 321}+37)
        /* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) See possible values below. */

#define LISTBROWSER_NumSelected         (@{"LISTBROWSER_Dummy" LINK File 321}+38)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Number of selected nodes. */

#define LISTBROWSER_RelColumn           (@{"LISTBROWSER_Dummy" LINK File 321}+40)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Column number clicked on. */

#define LISTBROWSER_HorizSeparators     (@{"LISTBROWSER_Dummy" LINK File 321}+41)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Show horizontal node separators */

#define LISTBROWSER_CheckImage          (@{"LISTBROWSER_Dummy" LINK File 321}+42)
        /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) Custom checkbox image, Checked state. */

#define LISTBROWSER_UncheckedImage      (@{"LISTBROWSER_Dummy" LINK File 321}+43)
        /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) Custom checkbox image, UnChecked state. */

#define LISTBROWSER_TotalNodes          (@{"LISTBROWSER_Dummy" LINK File 321}+44)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Total node count. */

#define LISTBROWSER_MinNodeSize         (@{"LISTBROWSER_Dummy" LINK File 321}+45)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Minimum Node size for custom MemPool custom node optimization */

#define LISTBROWSER_TitleClickable      (@{"LISTBROWSER_Dummy" LINK File 321}+46)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Allow column-title bar clicking. */

#define LISTBROWSER_MinVisible          (@{"LISTBROWSER_Dummy" LINK File 321}+47)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Minimum visible node count. This is a causes the
         * minimum domain to be large enough to hold the specified number of
         * nodes using the the estimated average node height. Note, ESTIMATED,
         * this is not garanteed results. The result may be slightly more or
         * less than specified, and potentially alot greater if other objects
         * within the layout group cause the listbrowser to layout larger
         * than its minimum domain.
         */

#define LISTBROWSER_Reserved6           (@{"LISTBROWSER_Dummy" LINK File 321}+48)
        /* RESERVED */

#define LISTBROWSER_Reserved7           (@{"LISTBROWSER_Dummy" LINK File 321}+49)
        /* RESERVED */

#define LISTBROWSER_PersistSelect       (@{"LISTBROWSER_Dummy" LINK File 321}+50)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) When set @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}, SHIFT key is @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} required for multi-select. */

#define LISTBROWSER_CursorSelect        (@{"LISTBROWSER_Dummy" LINK File 321}+51)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Keyboard Cursor Selected Node Number */

#define LISTBROWSER_CursorNode          (@{"LISTBROWSER_Dummy" LINK File 321}+52)
        /* (@{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} *) Keyboard Cursor Selected Node */

#define LISTBROWSER_FastRender          (@{"LISTBROWSER_Dummy" LINK File 321}+53)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Causes use of mask planes, and turns off custom pen support */
        /* The improvement with deep ECS or AGA display is *HUGE*. */

#define LISTBROWSER_TotalVisibleNodes   (@{"LISTBROWSER_Dummy" LINK File 321}+54)
        /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Total visible node count. */

#define LISTBROWSER_WrapText    (@{"LISTBROWSER_Dummy" LINK File 321}+55)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Enable word wrap of text nodes */


/* Possible values for @{"LISTBROWSER_Position" LINK File 423}.
 */
#define LBP_LINEUP 1
#define LBP_LINEDOWN 2
#define LBP_PAGEUP 3
#define LBP_PAGEDOWN 4
#define LBP_TOP 5
#define LBP_BOTTOM 6
#define LBP_SHIFTLEFT 10
#define LBP_SHIFTRIGHT 11
#define LBP_LEFTEDGE 12
#define LBP_RIGHTEDGE 13

/* Possible values for @{"LISTBROWSER_RelEvent" LINK File 426}.
 */
#define LBRE_NORMAL 1
#define LBRE_HIDECHILDREN 2
#define LBRE_SHOWCHILDREN 4
#define LBRE_EDIT 8
#define LBRE_DOUBLECLICK 16
#define LBRE_CHECKED 32
#define LBRE_UNCHECKED 64
#define LBRE_TITLECLICK 128
#define LBRE_COLUMNADJUST 256

/*****************************************************************************/

#endif /* GADGETS_LISTBROWSER_H */
@ENDNODE
