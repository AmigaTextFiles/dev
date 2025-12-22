IFND JS_TOOLS_I
JS_TOOLS_I SET 1

	IFND EXEC_TYPES_I
	INCLUDE 'exec/types.i'
	ENDC

    IFND LIBRARIES_GADTOOLS_H
	INCLUDE 'libraries/gadtools.i'
	ENDC

	IFND UTILITY_TAGITEM_I
	INCLUDE 'utility/tagitem.i'
	ENDC

**
**  JS_TOOLS.library   -   (c) 1994, 1995 by J.Schmitz - free to copy & use
**
**  written in C with SAS/C - assembler includes
**
**  new and better listview gadget and some helping tools
**  (may be more in future!)
**
**


JSTOOLSNAME 	EQU		"js_tools.library"


**
**  JS_Info constants
**

JSINFO_BOX 		    EQU	1
JSINFO_VERSION   	EQU	2
JSINFO_LIBVERSION   EQU	3
JSINFO_LIBREVISION  EQU	4
JSINFO_DATE         EQU	5


**
**  ListView:
**

LISTVIEW1_KIND	EQU	LISTVIEW_KIND
LISTVIEW2_KIND	EQU	101
LISTVIEW3_KIND	EQU	102

**
**  ListView tagitems:
**
**  Tags that have the same name as in gadtools have the same meaning. For
**  additional infomation look in RKM. For other tags refer to the C includes.
**

lv_Dummy		EQU		TAG_USER+$56000

lv_Labels		EQU		GTLV_Labels
lv_Disabled		EQU		GA_Disabled

lv_ScrollWidth	EQU		GTLV_ScrollWidth
lv_ShowSelected EQU		GTLV_ShowSelected

lv_ReadOnly		EQU		GTLV_ReadOnly
lv_Spacing		EQU		LAYOUTA_Spacing
lv_Top			EQU		GTLV_Top
lv_Selected		EQU		GTLV_Selected
lv_NewSelected	EQU		lv_Dummy+1

lv_Obsolete1	EQU		lv_Dummy+2

lv_SetMark		EQU		lv_Dummy+3
lv_ClearMark	EQU		lv_Dummy+4

lv_BlockStart	EQU		lv_Dummy+5
lv_BlockStop	EQU		lv_Dummy+6
lv_MarkBlock	EQU		lv_Dummy+7
lv_MarkIsIn		EQU		lv_Dummy+8

lv_OnlyRead		EQU		lv_Dummy+9

lv_Colour		EQU		lv_Dummy+10
lv_Color		EQU		lv_Colour
lv_NewSelectMode	EQU		lv_Dummy+11
lv_NewSelectLines	EQU		lv_Dummy+12
lv_SetFont		EQU		lv_Dummy+13

lv_Redraw		EQU		lv_Dummy+14

lv_OffIsIn		EQU		lv_Dummy+15

lv_ElseSelected	EQU		lv_Dummy+16

lv_OffColour    EQU		lv_Dummy+17
lv_OffColor		EQU		lv_OffColour

lv_NewKind		EQU		lv_Dummy+18

lv_xFrontColour	EQU		lv_Dummy+19
lv_xFrontColor	EQU		lv_xFrontColour

lv_xBackColour	EQU		lv_Dummy+20
lv_xBackColor	EQU		lv_xBackColour

lv_Hook 		EQU		lv_Dummy+22
lv_Notick		EQU		lv_Dummy+23
lv_AlwaysMark	EQU		lv_Dummy+24

lv_MarkOn		EQU		lv_Dummy+25

lv_SuperListView    EQU		lv_Dummy+26
lv_ScrollHeight		EQU		lv_Dummy+27
lv_HorizSelected    EQU		lv_Dummy+28
lv_HorizScroll		EQU		lv_Dummy+29

lv_Private1		EQU		lv_Dummy+30
lv_ColumnData	EQU		lv_Dummy+31
lv_FormatText	EQU		lv_Dummy+32
lv_AfterHook 	EQU		lv_Dummy+33

**
**  Ask Tags
**
**  results are returned in ti_Data
**  some need start parameters in ti_Data
**

lv_AskTop		EQU		lv_Dummy+50
lv_AskLines		EQU		lv_Dummy+51
lv_AskNumber	EQU		lv_Dummy+52
lv_AskNode		EQU		lv_Dummy+53
lv_IsShown		EQU		lv_Dummy+54
lv_IsMarked		EQU		lv_Dummy+55
lv_IsMarkedNr	EQU		lv_Dummy+56
lv_MarkedCount  EQU		lv_Dummy+57
lv_AskHoriz     EQU		lv_Dummy+58
lv_AskHorizMax  EQU		lv_Dummy+59


**
**  lv_NewSelectMode modes:
**
**  If you use lv_NewSelected lv_Top will be changed automatically to
**  show the selected element. How this should happen is specified by
**  the NewselectMode.
**

NSM_ExtraLine	EQU		0
NSM_Center		EQU		1
NSM_NoLine		EQU		2
NSM_FreeLine	EQU		3

NSM_max			EQU		3


**
**  struct lvData
**
**  Data filed given to hooks
**
**  remark:
**  you may change "everything" in the given RastPort - but you have to
**  restore it (exept APen, BPen, DrMd that are restored by ListView)
**
**  The hook has to look for width and height itself. If a line is locked
**  has to be managed by the hook.
**

  STRUCTURE lvData ,0
	APTR 	lvd_Current
	APTR	lvd_RPort
	UWORD	lvd_x
	UWORD	lvd_y
	WORD	lvd_width
	WORD	lvd_height
	BYTE	lvd_selected
	BYTE	lvd_marked
	UWORD	lvd_free
* everything below may be changed and will manipulate the output of the text in this line
	WORD	lvd_FrontPen
	WORD	lvd_BackPen
	WORD	lvd_Style
	WORD	lvd_add_x
	ULONG	lvd_flags

	LABEL	lvd_SIZEOF


**
** ColumnData:
**
** An array of ColumnData if given to the listview. The last field must
** be marked by setting all data to 0 (NULL).
**
** The hook is only called once per line. The ln_Name field is ignored in
** output so it has to be added to the array. But it will be given to the
** string gadget if one is set in lv_ShowSelected.
**
** The array has to be sorted by cd_LeftEdge. You may change cd_LeftEdge and
** cd_Width later - use lv_Refresh to update output.
**

   STRUCTURE ColumnData,0
    APTR	cd_Offset
    UWORD	cd_LeftEdge
    UWORD	cd_Width
    ULONG	cd_Flags

	LABEL	cd_SIZEOF

**
** ColumnData flags:
**

cdf_AdjustRight	EQU		1
cdf_AdjustMid	EQU		2


**
**  lvExtraWindow
**
**  A ListView will be put in an own window. You may use the return parameter
**  of LV_CreateExtraListViewA() with all js_tools listview functions.
**  It is impossible to add a string gadget with lv_ShowSelected.
**
**  All results of this listview (selected, etc.) will be send to the messageport
**  of the window given in the struct lvExtraWindow. The IntuiMessage contains
**  in IAddress a pointer to the gadget (as always). Attention! This is no intuition gadget structure!
**  Only the GadgetID and UserData fields have the same offset like intuition gadgets!
**  Possible IDCMP events:
**
**  IDCMP_CLOSEWINDOW - use FreeListView() to close the lvExtraWindow
**  IDCMP_GADGETUP    - same as normal
**  IDCMP_RAWKEY      - pressed key in this window, do want you want to do with it
**  IDCMP_VANILLAKEY  - do the same as RAWKEY
**

   STRUCTURE lvExtraWindow,0
    APTR	lvx_win
    APTR	lvx_vi
    APTR	lvx_TextAttr
    WORD	lvx_LeftEdge
    WORD	lvx_TopEdge
    WORD	lvx_Width
    WORD	lvx_Height
    WORD	lvx_MaxWidth
    WORD	lvx_MaxHeight
    UWORD	lvx_GadgetID
    APTR	lvx_UserData
    STRPTR	lvx_Title
    ULONG	lvx_Flags

	LABLE	lvx_SIZEOF

**
**  lvExtraWindow Flags:
**

LVXF_DEPTHGADGET    EQU		 1
LVXF_SIZEGADGET     EQU		 2
LVXF_CLOSEGADGET    EQU		 4
LVXF_DRAGGADGET     EQU		 8
LVXF_RAWKEY         EQU		16
LVXF_VANILLAKEY     EQU		32


**
**  Multiselect returncodes
**  (only if lv_MarkOn is TRUE)
**

* in IntuiMessage->Qualifier:

MARK_QUALIFIER_SET	    EQU		1
MARK_QUALIFIER_CLEAR	EQU		2

* You get the start (first line) of the marked block in
* IntuiMessage->MouseX and the end (last line) in
* IntuiMessage->MouseY.
* In IntuiMessage->Code is the selected line, too!!


	ENDC
