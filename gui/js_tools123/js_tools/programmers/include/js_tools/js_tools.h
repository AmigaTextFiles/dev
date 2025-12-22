#ifndef JS_TOOLS_JS_TOOLS_H
#define JS_TOOLS_JS_TOOLS_H

#include <exec/types.h>
#include <libraries/gadtools.h>
#include <intuition/gadgetclass.h>
#include <utility/tagitem.h>

/*
 *  JS_TOOLS.library   -   (c) 1994, 1995 by J.Schmitz - free to copy & use
 *
 *  written in C with SAS/C
 *
 *  new and better listview gadget and some helping tools
 *  (may be more in future!)
 *
 */


#define JSTOOLSNAME "js_tools.library"


/*
 *  JS_Info constants
 */

#define JSINFO_BOX 		    1	/* returns STRPTR */
#define JSINFO_VERSION   	2	/*         STRPTR */
#define JSINFO_LIBVERSION   3	/*         ULONG */
#define JSINFO_LIBREVISION  4	/*         ULONG */
#define JSINFO_DATE         5	/*         STRPTR */


/*
 *  ListView:
 */

#define LISTVIEW1_KIND	LISTVIEW_KIND	/* like old LISTVIEW_KIND of gadtools */
        								/* mark colours (dri_Pens, Text, Hgr): 2,8 aktiv mark: 8,5 */
#define LISTVIEW2_KIND	101	    		/* mark colours                      : 8,0 aktiv mark: 8,5 */
#define LISTVIEW3_KIND	102		    	/* mark colours: set by tags (lv_xFrontColor), (lv_xBackColor)  aktiv mark: 8,5 */

/*
 *  ListView tagitems:
 *  (old) at [C]=Create,
 *           [S]=Set,
 *           [X]=Set,if tags lv_Redraw or lv_Labels in current tagitem list!
 *           [G]=Get allowed, put in ti_Data a pointer to a LONG variable (LONG *)
 *
 *  Tags that have the same name as in gadtools have the same meaning. For
 *  additional infomation look in RKM.
 *
 */

#define lv_Dummy		(TAG_USER+0x56000)

#define lv_Labels		GTLV_Labels	    	/* [CSG] struct List* or MinList*  */

#define lv_Disabled		GA_Disabled		    /* [CSG] disables listview - scrolling is still possible */
											/*       so the hook could be started! */

#define lv_ScrollWidth	GTLV_ScrollWidth	/* [C..] width of scroller, default: 16 */
#define lv_ShowSelected  GTLV_ShowSelected	/* [C..] like gadtools: 0 show selected  */
						        			/*                      a pointer to a stringgadget to show it there */
											/*       if you use multi columns the struct Node->ln_Name field is still used! */

#define lv_ReadOnly		GTLV_ReadOnly		/* [C..] ListView is readonly - wow  */
#define lv_Spacing		LAYOUTA_Spacing 	/* [C..] additional free pixel lines between each text line (default 0) */
#define lv_Top			GTLV_Top			/* [CSG] sets first show line - the real top line is returned in ti_Data */
#define lv_Selected		GTLV_Selected		/* [CSG] sets selected line - the real selected line is returned in ti_Data */
#define lv_NewSelected	(lv_Dummy+1)		/* [CSG] much better select function - selected line is automatically shown */
											/*       by as less as possible scrolling the listview */

#define lv_Obsolete1	(lv_Dummy+2)		/*       do not use */

#define lv_SetMark		(lv_Dummy+3)		/* [CS.] mark line (0-...) */
#define lv_ClearMark	(lv_Dummy+4)		/* [CS.] unmark line (0-...) - use "ask tags" to get current state of a line*/

#define lv_BlockStart	(lv_Dummy+5)		/* [CS.] mark lines in a block - first line here */
#define lv_BlockStop	(lv_Dummy+6)		/* [CS.] mark lines in a block - last line here */
#define lv_MarkBlock	(lv_Dummy+7)		/* [CS.] BOOL - if TRUE block is marked, if FALSE block is unmarked */
#define lv_MarkIsIn		(lv_Dummy+8)		/* [CS.] mark offset (to struct Node start), BYTE field */
									        /*       the hole list will be marked/unmarked as set in this offset - ==1==TRUE means set mark */

#define lv_OnlyRead		(lv_Dummy+9)		/* [CS.] number of lines at the end of the list that are read only */

#define lv_Colour		(lv_Dummy+10)		/* [CSG] colour of text in listview */
#define lv_Color		lv_Colour
#define lv_NewSelectMode	(lv_Dummy+11)	/* [CSG] set NSM mode (NSM_...) */
#define lv_NewSelectLines	(lv_Dummy+12)	/* [CSG] lines in NSM_FreeLines mode */
#define lv_SetFont		(lv_Dummy+13)		/* [.X.] (struct TextAttr*) change font of listview */
											/*       ATTENTION! ta_YSize must be the same! lv_Redraw (or lv_Labels) must be in tag list! */
#define lv_Redraw		(lv_Dummy+14)		/* [.S.] redraw text of listview */
											/*       it is allowed to change ln_Name field, so use this tag to update the output */

#define lv_OffIsIn		(lv_Dummy+15)		/* [CSG] offset to lock byte (see lv_MarkIsIn) */
                                            /*       if byte is ==1 the current node is locked and can't be selected */
											/*       field must exist as long as you use the list */
		    	    						/*       if you change it use lv_Redraw to update output */
			    	    					/*       tag must be used every time lv_Lables is used or locking is turned of */

#define lv_ElseSelected	(lv_Dummy+16)		/* [CS.] >=0 -> "+", <0 -> "-" */
											/*       if (New)Selected points to a locked line this tag specifies what to do: */
											/*       >=0 -> select next line, <= -> select prev line (Default: 0)*/
											/*       usefull if you program a keyboard interface for a listview */

#define lv_OffColour    (lv_Dummy+17)   	/* [CSG] colour of locked text */
#define lv_OffColor		lv_OffColour

#define lv_NewKind		(lv_Dummy+18)		/* [.SG] change listview kind (for different mark colours) */

#define lv_xFrontColour	(lv_Dummy+19)		/* [CSG] text colour of marked text if LISTVIEW2_KIND is used */
#define lv_xFrontColor	lv_xFrontColour

#define lv_xBackColour	(lv_Dummy+20)		/* [CSG] background colour of marked text if LISTVIEW2_KIND is used */
#define lv_xBackColor	lv_xBackColour

#define lv_Hook 		(lv_Dummy+22)	    /* [CX.] (struct Hook*) pointer to Hook (see below for additionals) */
#define lv_Notick		(lv_Dummy+23)		/* [C..] BOOL - do not send IDCMP_INTUITICKS if they are already used by listview (Default: TRUE) */
#define lv_AlwaysMark	(lv_Dummy+24)		/* [CSG] BOOL - the default way to mark a line is to press SHIFT key while selecting */
											/*       if this tag is TRUE lines are always marked - also if SHIFT isn't pressed */
#define lv_MarkOn		(lv_Dummy+25)		/* [CSG] BOOL -turns on mark mode, so the user can mark lines */
											/*       if not turned on only the program may mark a line (so SHIFT is ignored) */

#define lv_SuperListView    (lv_Dummy+26)	/* [C..] BOOL - make Super ListView (TRUE) - i.e. it may scroll horizontal - default: FALSE */
											/*       it has some things in common with intuitions Super Bitmap Windows */
											/*       ATTENTION! This kind of listview isn't that fast - so use it only for small listviews */
											/*       if there is less chip ram it falls back to a normal listview! */
											/*       Currently it is impossible to use a Super Listview in lvExtraWindows! */

#define lv_ScrollHeight	(lv_Dummy+27)		/* [C..] Height of horizontal scroller (see lv_ScrollWidth), Default: lv_ScrollWidth-(lv_ScrollWidth/3) */
#define lv_HorizSelected    (lv_Dummy+28)	/* [CSG] Horizontal position in pixel (first is 0) */

#define lv_HorizScroll	(lv_Dummy+29)		/* [CSG] pixels to scroll if mouse if moved left or right out of the listview (Default: 4). */

#define lv_Private1		(lv_Dummy+30)		/* [C..] private tagitem, do not use */
#define lv_ColumnData	(lv_Dummy+31)		/* [C..] (struct ColumnData*) pointer to a ColumnData array (see below) */
#define lv_FormatText	(lv_Dummy+32)		/* [CS.] Text (+0 byte) that will be fit optimal in the listview. */
#define lv_AfterHook 	(lv_Dummy+33)	    /* [CX.] (struct Hook*) pointer to hook started AFTER a line is shown (see below for additionals) */


/*
 *  Ask Tags
 *
 *  results are returned in ti_Data
 *  some need start parameters in ti_Data
 *  (tags can only be used in [S]et)
 *
 */

#define lv_AskTop		(lv_Dummy+50)	/* [.S.] WORD - returns lv_Top */
#define lv_AskLines		(lv_Dummy+51)	/* [.S.] WORD - number of visible lines */
#define lv_AskNumber	(lv_Dummy+52)	/* [.S.] WORD - number of lines in current list */
#define lv_AskNode		(lv_Dummy+53)	/* [.S.] (struct Node*) - Selected Node */
#define lv_IsShown		(lv_Dummy+54)	/* [.S.] BOOL - is selected item shown ? */
#define lv_IsMarked		(lv_Dummy+55)	/* [.S.] BOOL - is (struct Node*) (in ti_Data) marked ? */
#define lv_IsMarkedNr	(lv_Dummy+56)	/* [.S.] BOOL - is line (in ti_Data) marked ? */
#define lv_MarkedCount  (lv_Dummy+57)	/* [.S.] WORD - number of marked lines */
#define lv_AskHoriz     (lv_Dummy+58)   /* [.S.] LONG - get horizontal position of SuperLV */
                                        /*       this is the only way to get this information (exept [G]ET with lv_HorizSelected) */
#define lv_AskHorizMax  (lv_Dummy+59)   /* [.S.] LONG - maximal position for lv_AskHoriz, is changed by every lv_Lables call */


/*
 *  lv_NewSelectMode modes:
 *
 *  If you use lv_NewSelected lv_Top will be changed automatically to
 *  show the selected element. How this should happen is specified by
 *  the NewselectMode.
 *
 */

#define NSM_ExtraLine	0	/* one line at the listview border is always visible (DEFAULT) */
#define NSM_Center		1	/* selected is centered (exept at start/end of the list) */
#define NSM_NoLine		2	/* like good old gadtools ListView */
#define NSM_FreeLine	3	/* like NSM_ExtraLine, but the number of visible lines is */
							/* set by lv_NewSelectLines tag. */
							/* if you use this tag it is possible that there are less lines visible */
                            /* this is to minimize scrolling and not confuse the user */

#define NSM_max		3


/*
 *  struct lvData
 *
 *  Data filed given to hooks
 *
 *  remark:
 *  you may change "everything" in the given RastPort - but you have to
 *  restore it (exept APen, BPen, DrMd that are restored by ListView)
 *
 *  The hook has to look for width and height itself. If a line is locked
 *  has to be managed by the hook.
 *
 */

struct lvData {
	struct Node 		*lvd_Current;	/* pointer to the current Node */
	struct RastPort	    *lvd_RPort;	    /* our RastPort */
	UWORD			    lvd_x;		    /* X position of the text field */
	UWORD			    lvd_y;		    /* Y position of the text field */
	WORD				lvd_width;	    /* width of the line */
	WORD				lvd_height;	    /* height of the line */
	BYTE				lvd_selected;	/* NO==0, YES!=0 */
	BYTE				lvd_marked;	    /* NO==0, YES!=0 */
	UWORD			    lvd_free;		/* free, do not use! */
/* everything below may be changed and will manipulate the output of the text in this line */
	WORD				lvd_FrontPen;	/* colour of the text */
	WORD				lvd_BackPen;	/* colour of the background */
	WORD				lvd_Style;	    /* style (graphics.library/SetSoftStyle()) */
	WORD				lvd_add_x;	    /* text output will be moved to the right by this number of pixels (DEFAULT: 0) */
	ULONG			    lvd_flags;	    /* additional flags - currently unused, set to 0 ! */
};



/*
 * ColumnData:
 *
 * An array of ColumnData if given to the listview. The last field must
 * be marked by setting all data to 0 (NULL).
 *
 * The hook is only called once per line. The ln_Name field is ignored in
 * output so it has to be added to the array. But it will be given to the
 * string gadget if one is set in lv_ShowSelected.
 *
 * The array has to be sorted by cd_LeftEdge. You may change cd_LeftEdge and
 * cd_Width later - use lv_Refresh to update output.
 *
 */

struct ColumnData {
    APTR	cd_Offset;		/* offset to the text (relativ to struct Node - see lv_MarkIsIn) */
							/* NULL for end of array */
    UWORD	cd_LeftEdge;	/* relativ start of the text */
    UWORD	cd_Width;		/* width of the coloumn */
    ULONG	cd_Flags;		/* flags */
};

/*
 * ColumnData flags:
 *
 */

#define cdf_AdjustRight	1
#define cdf_AdjustMid	2


/*
 *  lvExtraWindow
 *
 *  A ListView will be put in an own window. You may use the return parameter
 *  of LV_CreateExtraListViewA() with all js_tools listview functions.
 *  It is impossible to add a string gadget with lv_ShowSelected.
 *
 *  All results of this listview (selected, etc.) will be send to the messageport
 *  of the window given in the struct lvExtraWindow. The IntuiMessage contains
 *  in IAddress a pointer to the gadget (as always). Attention! This is no intuition gadget structure!
 *  Only the GadgetID and UserData fields have the same offset like intuition gadgets!
 *  Possible IDCMP events:
 *
 *  IDCMP_CLOSEWINDOW - use FreeListView() to close the lvExtraWindow
 *  IDCMP_GADGETUP    - same as normal
 *  IDCMP_RAWKEY      - pressed key in this window, do want you want to do with it
 *  IDCMP_VANILLAKEY  - do the same as RAWKEY
 *
 */

struct lvExtraWindow {
    struct Window   *lvx_win;       /* Window, all results will be send to and on which screen */
                                    /* the lvExtraWindow should be opened */
    APTR            lvx_vi;         /* VisualInfo of the screen */
    struct TextAttr *lvx_TextAttr;	/* Font of text in listview */
    WORD            lvx_LeftEdge;
    WORD            lvx_TopEdge;
    WORD            lvx_Width;		/* min 100 */
    WORD            lvx_Height;		/* min 50 */
    WORD			lvx_MaxWidth;	/* max width of the window - 0 means unlimited */
    WORD			lvx_MaxHeight;  /* max height of the window - 0 means unlimited */
    UWORD           lvx_GadgetID;
    APTR            lvx_UserData;
    STRPTR          lvx_Title;
    ULONG           lvx_Flags;
};

/*
 *  lvExtraWindow Flags:
 *
 */

#define LVXF_DEPTHGADGET     1  /* add Depth Gadget */
#define LVXF_SIZEGADGET      2  /* add Size Gadget */
#define LVXF_CLOSEGADGET     4  /* add Close Gadget */
#define LVXF_DRAGGADGET      8  /* add Dragbar */
#define LVXF_RAWKEY         16  /* RAWKEY IDCMP */
#define LVXF_VANILLAKEY     32  /* VANILLAKEY IDCMP */


/*
 *  Multiselect returncodes
 *  (only if lv_MarkOn is TRUE)
 *
 */

/* in IntuiMessage->Qualifier: */

#define MARK_QUALIFIER_SET	    1	/* mark by user */
#define MARK_QUALIFIER_CLEAR	2	/* unmark by user */

/* You get the start (first line) of the marked block in
 * IntuiMessage->MouseX and the end (last line) in
 * IntuiMessage->MouseY.
 * In IntuiMessage->Code is the selected line, too!!
 */

/**************************************************************************/

#endif
