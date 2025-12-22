/* $VER: gadtools.h 39.9 (19.8.1992) */
OPT NATIVE, PREPROCESS, POINTER
MODULE 'target/exec/types', 'target/utility/tagitem', 'target/intuition/intuition', 'target/intuition/gadgetclass'
MODULE 'target/graphics/text', 'target/intuition/screens', 'target/graphics/gfx'
{#include <libraries/gadtools.h>}
NATIVE {LIBRARIES_GADTOOLS_H} CONST

/* The kinds (almost classes) of gadgets that GadTools supports.
 * Use these identifiers when calling CreateGadgetA()
 */

NATIVE {GENERIC_KIND}	CONST GENERIC_KIND	= 0
NATIVE {BUTTON_KIND}	CONST BUTTON_KIND	= 1
NATIVE {CHECKBOX_KIND}	CONST CHECKBOX_KIND	= 2
NATIVE {INTEGER_KIND}	CONST INTEGER_KIND	= 3
NATIVE {LISTVIEW_KIND}	CONST LISTVIEW_KIND	= 4
NATIVE {MX_KIND}		CONST MX_KIND		= 5
NATIVE {NUMBER_KIND}	CONST NUMBER_KIND	= 6
NATIVE {CYCLE_KIND}	CONST CYCLE_KIND	= 7
NATIVE {PALETTE_KIND}	CONST PALETTE_KIND	= 8
NATIVE {SCROLLER_KIND}	CONST SCROLLER_KIND	= 9
/* Kind number 10 is reserved */
NATIVE {SLIDER_KIND}	CONST SLIDER_KIND	= 11
NATIVE {STRING_KIND}	CONST STRING_KIND	= 12
NATIVE {TEXT_KIND}	CONST TEXT_KIND	= 13

NATIVE {NUM_KINDS}	CONST NUM_KINDS	= 14

/*------------------------------------------------------------------------*/

/* 'Or' the appropriate set together for your Window IDCMPFlags: */

NATIVE {ARROWIDCMP}	CONST ARROWIDCMP	= (IDCMP_GADGETUP OR IDCMP_GADGETDOWN OR IDCMP_INTUITICKS OR IDCMP_MOUSEBUTTONS)

NATIVE {BUTTONIDCMP}	CONST BUTTONIDCMP	= (IDCMP_GADGETUP)
NATIVE {CHECKBOXIDCMP}	CONST CHECKBOXIDCMP	= (IDCMP_GADGETUP)
NATIVE {INTEGERIDCMP}	CONST INTEGERIDCMP	= (IDCMP_GADGETUP)
NATIVE {LISTVIEWIDCMP}	CONST LISTVIEWIDCMP	= (IDCMP_GADGETUP OR IDCMP_GADGETDOWN OR IDCMP_MOUSEMOVE OR ARROWIDCMP)

NATIVE {MXIDCMP}		CONST MXIDCMP		= (IDCMP_GADGETDOWN)
NATIVE {NUMBERIDCMP}	CONST NUMBERIDCMP	= (0)
NATIVE {CYCLEIDCMP}	CONST CYCLEIDCMP	= (IDCMP_GADGETUP)
NATIVE {PALETTEIDCMP}	CONST PALETTEIDCMP	= (IDCMP_GADGETUP)

/* Use ARROWIDCMP|SCROLLERIDCMP if your scrollers have arrows: */
NATIVE {SCROLLERIDCMP}	CONST SCROLLERIDCMP	= (IDCMP_GADGETUP OR IDCMP_GADGETDOWN OR IDCMP_MOUSEMOVE)
NATIVE {SLIDERIDCMP}	CONST SLIDERIDCMP	= (IDCMP_GADGETUP OR IDCMP_GADGETDOWN OR IDCMP_MOUSEMOVE)
NATIVE {STRINGIDCMP}	CONST STRINGIDCMP	= (IDCMP_GADGETUP)

NATIVE {TEXTIDCMP}	CONST TEXTIDCMP	= (0)

/*------------------------------------------------------------------------*/

/* Generic NewGadget used by several of the gadget classes: */

NATIVE {NewGadget} OBJECT newgadget
    {ng_LeftEdge}	leftedge	:INT
	{ng_TopEdge}	topedge	:INT	/* gadget position */
    {ng_Width}	width	:INT
	{ng_Height}	height	:INT		/* gadget size */
    {ng_GadgetText}	gadgettext	:ARRAY OF UBYTE		/* gadget label */
    {ng_TextAttr}	textattr	:PTR TO textattr	/* desired font for gadget label */
    {ng_GadgetID}	gadgetid	:UINT			/* gadget ID */
    {ng_Flags}	flags	:ULONG			/* see below */
    {ng_VisualInfo}	visualinfo	:APTR			/* Set to retval of GetVisualInfo() */
    {ng_UserData}	userdata	:APTR			/* gadget UserData */
ENDOBJECT


/* ng_Flags control certain aspects of the gadget.  The first five control
 * the placement of the descriptive text.  Each gadget kind has its default,
 * which is usually PLACETEXT_LEFT.  Consult the autodocs for details.
 */

NATIVE {PLACETEXT_LEFT}	CONST PLACETEXT_LEFT	= $0001	/* Right-align text on left side */
NATIVE {PLACETEXT_RIGHT}	CONST PLACETEXT_RIGHT	= $0002	/* Left-align text on right side */
NATIVE {PLACETEXT_ABOVE}	CONST PLACETEXT_ABOVE	= $0004	/* Center text above */
NATIVE {PLACETEXT_BELOW}	CONST PLACETEXT_BELOW	= $0008	/* Center text below */
NATIVE {PLACETEXT_IN}	CONST PLACETEXT_IN	= $0010	/* Center text on */

NATIVE {NG_HIGHLABEL}	CONST NG_HIGHLABEL	= $0020	/* Highlight the label */


/*------------------------------------------------------------------------*/

/* Fill out an array of these and pass that to CreateMenus(): */

NATIVE {NewMenu} OBJECT newmenu
    {nm_Type}	type	:UBYTE		/* See below */
    /* Compiler inserts a PAD byte here */
    {nm_Label } pad:/*STRPTR*/ NATIVE {STRPTR} VALUE	->hack to fix typed lists
    {nm_Label}	label	:/*STRPTR*/ ARRAY OF CHAR		/* Menu's label */
    {nm_CommKey}	commkey	:/*STRPTR*/ ARRAY OF CHAR		/* MenuItem Command Key Equiv */
    {nm_Flags}	flags	:UINT		/* Menu or MenuItem flags (see note) */
    {nm_MutualExclude}	mutualexclude	:VALUE	/* MenuItem MutualExclude word */
    {nm_UserData}	userdata	:APTR		/* For your own use, see note */
ENDOBJECT

/* Needed only by inside IM_ definitions below */
NATIVE {MENU_IMAGE}	CONST MENU_IMAGE	= 128

/* nm_Type determines what each NewMenu structure corresponds to.
 * for the NM_TITLE, NM_ITEM, and NM_SUB values, nm_Label should
 * be a text string to use for that menu title, item, or sub-item.
 * For IM_ITEM or IM_SUB, set nm_Label to point at the Image structure
 * you wish to use for this item or sub-item.
 * NOTE: At present, you may only use conventional images.
 * Custom images created from Intuition image-classes do not work.
 */
NATIVE {NM_TITLE}	CONST NM_TITLE	= 1	/* Menu header */
NATIVE {NM_ITEM}		CONST NM_ITEM		= 2	/* Textual menu item */
NATIVE {NM_SUB}		CONST NM_SUB		= 3	/* Textual menu sub-item */

NATIVE {IM_ITEM}		CONST IM_ITEM		= (NM_ITEM OR MENU_IMAGE)	/* Graphical menu item */
NATIVE {IM_SUB}		CONST IM_SUB		= (NM_SUB OR MENU_IMAGE)	/* Graphical menu sub-item */

/* The NewMenu array should be terminated with a NewMenu whose
 * nm_Type equals NM_END.
 */
NATIVE {NM_END}		CONST NM_END		= 0	/* End of NewMenu array */

/* Starting with V39, GadTools will skip any NewMenu entries whose
 * nm_Type field has the NM_IGNORE bit set.
 */
NATIVE {NM_IGNORE}	CONST NM_IGNORE	= 64


/* nm_Label should be a text string for textual items, a pointer
 * to an Image structure for graphical menu items, or the special
 * constant NM_BARLABEL, to get a separator bar.
 */
NATIVE {NM_BARLABEL}	CONST NM_BARLABEL	= -1 !!VALUE!!/*STRPTR*/ ARRAY OF CHAR

/* The nm_Flags field is used to fill out either the Menu->Flags or
 * MenuItem->Flags field.  Note that the sense of the MENUENABLED or
 * ITEMENABLED bit is inverted between this use and Intuition's use,
 * in other words, NewMenus are enabled by default.  The following
 * labels are provided to disable them:
 */
NATIVE {NM_MENUDISABLED}	CONST NM_MENUDISABLED	= MENUENABLED
NATIVE {NM_ITEMDISABLED}	CONST NM_ITEMDISABLED	= ITEMENABLED

/* New for V39:  NM_COMMANDSTRING.  For a textual MenuItem or SubItem,
 * point nm_CommKey at an arbitrary string, and set the NM_COMMANDSTRING
 * flag.
 */
NATIVE {NM_COMMANDSTRING} CONST NM_COMMANDSTRING = COMMSEQ

/* The following are pre-cleared (COMMSEQ, ITEMTEXT, and HIGHxxx are set
 * later as appropriate):
 * Under V39, the COMMSEQ flag bit is not cleared, since it now has
 * meaning.
 */
NATIVE {NM_FLAGMASK}	CONST NM_FLAGMASK	= (NOT (COMMSEQ OR ITEMTEXT OR HIGHFLAGS))
NATIVE {NM_FLAGMASK_V39}	CONST NM_FLAGMASK_V39	= (NOT (ITEMTEXT OR HIGHFLAGS))

/* You may choose among CHECKIT, MENUTOGGLE, and CHECKED.
 * Toggle-select menuitems are of type CHECKIT|MENUTOGGLE, along
 * with CHECKED if currently selected.	Mutually exclusive ones
 * are of type CHECKIT, and possibly CHECKED too.  The nm_MutualExclude
 * is a bit-wise representation of the items excluded by this one,
 * so in the simplest case (choose 1 among n), these flags would be
 * ~1, ~2, ~4, ~8, ~16, etc.  See the Intuition Menus chapter.
 */

/* A UserData pointer can be associated with each Menu and MenuItem structure.
 * The CreateMenus() call allocates space for a UserData after each
 * Menu or MenuItem (header, item or sub-item).  You should use the
 * GTMENU_USERDATA() or GTMENUITEM_USERDATA() macro to extract it.
 */

NATIVE {GTMENU_USERDATA} CONST	->GTMENU_USERDATA(menu) (* ( (APTR *)(((struct Menu *)menu)+1) ) )
->#define GTMENU_USERDATA(m)      (GetLong((m)+SIZEOF menu !!PTR!!PTR TO LONG))
#define GTMENU_USERDATA(m) Gtmenu_userdata(m)
PROC Gtmenu_userdata(m) IS GetLong(m+SIZEOF menu !!PTR TO LONG)

NATIVE {GTMENUITEM_USERDATA} CONST	->GTMENUITEM_USERDATA(menuitem) (* ( (APTR *)(((struct MenuItem *)menuitem)+1) ) )
->#define GTMENUITEM_USERDATA(mi) (GetLong((mi)+SIZEOF menuitem !!PTR!!PTR!!PTR TO LONG))
#define GTMENUITEM_USERDATA(mi) Gtmenuitem_userdata(mi)
PROC Gtmenuitem_userdata(mi) IS GetLong((mi)+SIZEOF menuitem !!PTR TO LONG)

/* Here is an old one for compatibility.  Do not use in new code! */
NATIVE {MENU_USERDATA} CONST	->MENU_USERDATA(menuitem) (* ( (APTR *)(menuitem+1) ) )
#define MENU_USERDATA(mi)       (GTMENUITEM_USERDATA(mi))

/* These return codes can be obtained through the GTMN_SecondaryError tag */
NATIVE {GTMENU_TRIMMED}	CONST GTMENU_TRIMMED	= $00000001	/* Too many menus, items, or subitems,
					 * menu has been trimmed down
					 */
NATIVE {GTMENU_INVALID}	CONST GTMENU_INVALID	= $00000002	/* Invalid NewMenu array */
NATIVE {GTMENU_NOMEM}	CONST GTMENU_NOMEM	= $00000003	/* Out of memory */

/*------------------------------------------------------------------------*/

/* Starting with V39, checkboxes and mx gadgets can be scaled to your
 * specified gadget width/height.  Use the new GTCB_Scaled or GTMX_Scaled
 * tags, respectively.	Under V37, and by default in V39, the imagery
 * is of the following fixed size:
 */

/* MX gadget default dimensions: */
NATIVE {MX_WIDTH}	CONST MX_WIDTH	= 17
NATIVE {MX_HEIGHT}	CONST MX_HEIGHT	= 9

/* Checkbox default dimensions: */
NATIVE {CHECKBOX_WIDTH}	CONST CHECKBOX_WIDTH	= 26
NATIVE {CHECKBOX_HEIGHT}	CONST CHECKBOX_HEIGHT	= 11

/*------------------------------------------------------------------------*/

/* Tags for GadTools functions: */

NATIVE {GT_TagBase}	     CONST GT_TAGBASE	     = TAG_USER + $80000

NATIVE {GTVI_NewWindow}	     CONST GTVI_NEWWINDOW	     = GT_TAGBASE+1  /* Unused */
NATIVE {GTVI_NWTags}	     CONST GTVI_NWTAGS	     = GT_TAGBASE+2  /* Unused */

NATIVE {GT_Private0}	     CONST GT_PRIVATE0	     = GT_TAGBASE+3  /* (private) */

NATIVE {GTCB_Checked}	     CONST GTCB_CHECKED	     = GT_TAGBASE+4  /* State of checkbox */

NATIVE {GTLV_Top}	     CONST GTLV_TOP	     = GT_TAGBASE+5  /* Top visible one in listview */
NATIVE {GTLV_Labels}	     CONST GTLV_LABELS	     = GT_TAGBASE+6  /* List to display in listview */
NATIVE {GTLV_ReadOnly}	     CONST GTLV_READONLY	     = GT_TAGBASE+7  /* TRUE if listview is to be
					    * read-only
					    */
NATIVE {GTLV_ScrollWidth}     CONST GTLV_SCROLLWIDTH     = GT_TAGBASE+8  /* Width of scrollbar */

NATIVE {GTMX_Labels}	     CONST GTMX_LABELS	     = GT_TAGBASE+9  /* NULL-terminated array of labels */
NATIVE {GTMX_Active}	     CONST GTMX_ACTIVE	     = GT_TAGBASE+10 /* Active one in mx gadget */

NATIVE {GTTX_Text}	     CONST GTTX_TEXT	     = GT_TAGBASE+11 /* Text to display */
NATIVE {GTTX_CopyText}	     CONST GTTX_COPYTEXT	     = GT_TAGBASE+12 /* Copy text label instead of
					    * referencing it
					    */

NATIVE {GTNM_Number}	     CONST GTNM_NUMBER	     = GT_TAGBASE+13 /* Number to display */

NATIVE {GTCY_Labels}	     CONST GTCY_LABELS	     = GT_TAGBASE+14 /* NULL-terminated array of labels */
NATIVE {GTCY_Active}	     CONST GTCY_ACTIVE	     = GT_TAGBASE+15 /* The active one in the cycle gad */

NATIVE {GTPA_Depth}	     CONST GTPA_DEPTH	     = GT_TAGBASE+16 /* Number of bitplanes in palette */
NATIVE {GTPA_Color}	     CONST GTPA_COLOR	     = GT_TAGBASE+17 /* Palette color */
NATIVE {GTPA_ColorOffset}     CONST GTPA_COLOROFFSET     = GT_TAGBASE+18 /* First color to use in palette */
NATIVE {GTPA_IndicatorWidth}  CONST GTPA_INDICATORWIDTH  = GT_TAGBASE+19 /* Width of current-color indicator */
NATIVE {GTPA_IndicatorHeight} CONST GTPA_INDICATORHEIGHT = GT_TAGBASE+20 /* Height of current-color indicator */

NATIVE {GTSC_Top}	     CONST GTSC_TOP	     = GT_TAGBASE+21 /* Top visible in scroller */
NATIVE {GTSC_Total}	     CONST GTSC_TOTAL	     = GT_TAGBASE+22 /* Total in scroller area */
NATIVE {GTSC_Visible}	     CONST GTSC_VISIBLE	     = GT_TAGBASE+23 /* Number visible in scroller */
NATIVE {GTSC_Overlap}	     CONST GTSC_OVERLAP	     = GT_TAGBASE+24 /* Unused */

/*  GT_TAGBASE+25 through GT_TAGBASE+37 are reserved */

NATIVE {GTSL_Min}	     CONST GTSL_MIN	     = GT_TAGBASE+38 /* Slider min value */
NATIVE {GTSL_Max}	     CONST GTSL_MAX	     = GT_TAGBASE+39 /* Slider max value */
NATIVE {GTSL_Level}	     CONST GTSL_LEVEL	     = GT_TAGBASE+40 /* Slider level */
NATIVE {GTSL_MaxLevelLen}     CONST GTSL_MAXLEVELLEN     = GT_TAGBASE+41 /* Max length of printed level */
NATIVE {GTSL_LevelFormat}     CONST GTSL_LEVELFORMAT     = GT_TAGBASE+42 /* Format string for level */
NATIVE {GTSL_LevelPlace}      CONST GTSL_LEVELPLACE      = GT_TAGBASE+43 /* Where level should be placed */
NATIVE {GTSL_DispFunc}	     CONST GTSL_DISPFUNC	     = GT_TAGBASE+44 /* Callback for number calculation
					    * before display
					    */

NATIVE {GTST_String}	     CONST GTST_STRING	     = GT_TAGBASE+45 /* String gadget's displayed string */
NATIVE {GTST_MaxChars}	     CONST GTST_MAXCHARS	     = GT_TAGBASE+46 /* Max length of string */

NATIVE {GTIN_Number}	     CONST GTIN_NUMBER	     = GT_TAGBASE+47 /* Number in integer gadget */
NATIVE {GTIN_MaxChars}	     CONST GTIN_MAXCHARS	     = GT_TAGBASE+48 /* Max number of digits */

NATIVE {GTMN_TextAttr}	     CONST GTMN_TEXTATTR	     = GT_TAGBASE+49 /* MenuItem font TextAttr */
NATIVE {GTMN_FrontPen}	     CONST GTMN_FRONTPEN	     = GT_TAGBASE+50 /* MenuItem text pen color */

NATIVE {GTBB_Recessed}	     CONST GTBB_RECESSED	     = GT_TAGBASE+51 /* Make BevelBox recessed */

NATIVE {GT_VisualInfo}	     CONST GT_VISUALINFO	     = GT_TAGBASE+52 /* result of VisualInfo call */

NATIVE {GTLV_ShowSelected}    CONST GTLV_SHOWSELECTED    = GT_TAGBASE+53 /* show selected entry beneath
		* listview, set tag data = NULL for display-only, or pointer
		* to a string gadget you've created
		*/
NATIVE {GTLV_Selected}	     CONST GTLV_SELECTED	     = GT_TAGBASE+54 /* Set ordinal number of selected
					    * entry in the list
					    */
NATIVE {GT_Reserved1}	     CONST GT_RESERVED1	     = GT_TAGBASE+56 /* Reserved for future use */

NATIVE {GTTX_Border}	     CONST GTTX_BORDER	     = GT_TAGBASE+57 /* Put a border around
					    * Text-display gadgets
					    */
NATIVE {GTNM_Border}	     CONST GTNM_BORDER	     = GT_TAGBASE+58 /* Put a border around
					    * Number-display gadgets
					    */

NATIVE {GTSC_Arrows}	     CONST GTSC_ARROWS	     = GT_TAGBASE+59 /* Specify size of arrows for
					    * scroller
					    */

NATIVE {GTMN_Menu}	     CONST GTMN_MENU	     = GT_TAGBASE+60 /* Pointer to Menu for use by
					    * LayoutMenuItems()
					    */
NATIVE {GTMX_Spacing}	     CONST GTMX_SPACING	     = GT_TAGBASE+61 /* Added to font height to
		* figure spacing between mx choices.  Use this instead
		* of LAYOUTA_SPACING for mx gadgets.
		*/

/* New to V37 GadTools.  Ignored by GadTools V36 */
NATIVE {GTMN_FullMenu}	     CONST GTMN_FULLMENU	     = GT_TAGBASE+62 /* Asks CreateMenus() to
		* validate that this is a complete menu structure
		*/
NATIVE {GTMN_SecondaryError}  CONST GTMN_SECONDARYERROR  = GT_TAGBASE+63 /* ti_Data is a pointer
		* to a ULONG to receive error reports from CreateMenus()
		*/
NATIVE {GT_Underscore}	     CONST GT_UNDERSCORE	     = GT_TAGBASE+64 /* ti_Data points to the symbol
		* that preceeds the character you'd like to underline in a
		* gadget label
		*/
NATIVE {GTST_EditHook}	     CONST GTST_EDITHOOK	     = GT_TAGBASE+55 /* String EditHook */
NATIVE {GTIN_EditHook}	     CONST GTIN_EDITHOOK	     = GTST_EDITHOOK /* Same thing, different name,
		* just to round out INTEGER_KIND gadgets
		*/

/* New to V39 GadTools.  Ignored by GadTools V36 and V37 */
NATIVE {GTMN_Checkmark}	     CONST GTMN_CHECKMARK	     = GT_TAGBASE+65 /* ti_Data is checkmark img to use */
NATIVE {GTMN_AmigaKey}	     CONST GTMN_AMIGAKEY	     = GT_TAGBASE+66 /* ti_Data is Amiga-key img to use */
NATIVE {GTMN_NewLookMenus}    CONST GTMN_NEWLOOKMENUS    = GT_TAGBASE+67 /* ti_Data is boolean */

/* New to V39 GadTools.  Ignored by GadTools V36 and V37.
 * Set to TRUE if you want the checkbox or mx image scaled to
 * the gadget width/height you specify.  Defaults to FALSE,
 * for compatibility.
 */
NATIVE {GTCB_Scaled}	     CONST GTCB_SCALED	     = GT_TAGBASE+68 /* ti_Data is boolean */
NATIVE {GTMX_Scaled}	     CONST GTMX_SCALED	     = GT_TAGBASE+69 /* ti_Data is boolean */

NATIVE {GTPA_NumColors}	     CONST GTPA_NUMCOLORS	     = GT_TAGBASE+70 /* Number of colors in palette */

NATIVE {GTMX_TitlePlace}      CONST GTMX_TITLEPLACE      = GT_TAGBASE+71 /* Where to put the title */

NATIVE {GTTX_FrontPen}	     CONST GTTX_FRONTPEN	     = GT_TAGBASE+72 /* Text color in TEXT_KIND gad */
NATIVE {GTTX_BackPen}	     CONST GTTX_BACKPEN	     = GT_TAGBASE+73 /* Bgrnd color in TEXT_KIND gad */
NATIVE {GTTX_Justification}   CONST GTTX_JUSTIFICATION   = GT_TAGBASE+74 /* See GTJ_#? constants */

NATIVE {GTNM_FrontPen}	     CONST GTNM_FRONTPEN	     = GT_TAGBASE+72 /* Text color in NUMBER_KIND gad */
NATIVE {GTNM_BackPen}	     CONST GTNM_BACKPEN	     = GT_TAGBASE+73 /* Bgrnd color in NUMBER_KIND gad */
NATIVE {GTNM_Justification}   CONST GTNM_JUSTIFICATION   = GT_TAGBASE+74 /* See GTJ_#? constants */
NATIVE {GTNM_Format}	     CONST GTNM_FORMAT	     = GT_TAGBASE+75 /* Formatting string for number */
NATIVE {GTNM_MaxNumberLen}    CONST GTNM_MAXNUMBERLEN    = GT_TAGBASE+76 /* Maximum length of number */

NATIVE {GTBB_FrameType}	     CONST GTBB_FRAMETYPE	     = GT_TAGBASE+77 /* defines what kind of boxes
					    * DrawBevelBox() renders. See
					    * the BBFT_#? constants for
					    * possible values
					    */

NATIVE {GTLV_MakeVisible}     CONST GTLV_MAKEVISIBLE     = GT_TAGBASE+78 /* Make this item visible */
NATIVE {GTLV_ItemHeight}      CONST GTLV_ITEMHEIGHT      = GT_TAGBASE+79 /* Height of an individual item */

NATIVE {GTSL_MaxPixelLen}     CONST GTSL_MAXPIXELLEN     = GT_TAGBASE+80 /* Max pixel size of level display */
NATIVE {GTSL_Justification}   CONST GTSL_JUSTIFICATION   = GT_TAGBASE+81 /* how should the level be displayed */

NATIVE {GTPA_ColorTable}      CONST GTPA_COLORTABLE      = GT_TAGBASE+82 /* colors to use in palette */

NATIVE {GTLV_CallBack}	     CONST GTLV_CALLBACK	     = GT_TAGBASE+83 /* general-purpose listview call back */
NATIVE {GTLV_MaxPen}	     CONST GTLV_MAXPEN	     = GT_TAGBASE+84 /* maximum pen number used by call back */

NATIVE {GTTX_Clipped}	     CONST GTTX_CLIPPED	     = GT_TAGBASE+85 /* make a TEXT_KIND clip text */
NATIVE {GTNM_Clipped}	     CONST GTNM_CLIPPED	     = GT_TAGBASE+85 /* make a NUMBER_KIND clip text */

/* Old definition, now obsolete: */
NATIVE {GT_Reserved0}	     CONST GT_RESERVED0	     = GTST_EDITHOOK

/*------------------------------------------------------------------------*/

/* Justification types for GTTX_Justification and GTNM_Justification tags */
NATIVE {GTJ_LEFT}   CONST GTJ_LEFT   = 0
NATIVE {GTJ_RIGHT}  CONST GTJ_RIGHT  = 1
NATIVE {GTJ_CENTER} CONST GTJ_CENTER = 2

/*------------------------------------------------------------------------*/

/* Bevel box frame types for GTBB_FrameType tag */
NATIVE {BBFT_BUTTON}	 CONST BBFT_BUTTON	 = 1  /* Standard button gadget box */
NATIVE {BBFT_RIDGE}	 CONST BBFT_RIDGE	 = 2  /* Standard string gadget box */
NATIVE {BBFT_ICONDROPBOX} CONST BBFT_ICONDROPBOX = 3  /* Standard icon drop box	  */

/*------------------------------------------------------------------------*/

/* Typical suggested spacing between "elements": */
NATIVE {INTERWIDTH}	CONST INTERWIDTH	= 8
NATIVE {INTERHEIGHT}	CONST INTERHEIGHT	= 4

/*------------------------------------------------------------------------*/

/* "NWay" is an old synonym for cycle gadgets */
NATIVE {NWAY_KIND}	CONST NWAY_KIND	= CYCLE_KIND
NATIVE {NWAYIDCMP}	CONST NWAYIDCMP	= CYCLEIDCMP
NATIVE {GTNW_Labels}	CONST GTNW_LABELS	= GTCY_LABELS
NATIVE {GTNW_Active}	CONST GTNW_ACTIVE	= GTCY_ACTIVE

/*------------------------------------------------------------------------*/

/* These two definitions are obsolete, but are here for backwards
 * compatibility.  You never need to worry about these:
 */
NATIVE {GADTOOLBIT}	CONST GADTOOLBIT	= ($8000)
/* Use this mask to isolate the user part: */
NATIVE {GADTOOLMASK}	CONST GADTOOLMASK	= (NOT GADTOOLBIT)

/*------------------------------------------------------------------------*/

/* These definitions are for the GTLV_CallBack tag */

/* The different types of messages that a listview callback hook can see */
NATIVE {LV_DRAW}       CONST LV_DRAW       = $202	/* draw yourself, with state */

/* Possible return values from a callback hook */
NATIVE {LVCB_OK}       CONST LVCB_OK       = 0		/* callback understands this message type    */
NATIVE {LVCB_UNKNOWN}  CONST LVCB_UNKNOWN  = 1		/* callback does not understand this message */

/* states for LVDrawMsg.lvdm_State */
NATIVE {LVR_NORMAL}	      CONST LVR_NORMAL	      = 0	/* the usual		     */
NATIVE {LVR_SELECTED}	      CONST LVR_SELECTED	      = 1	/* for selected gadgets	     */
NATIVE {LVR_NORMALDISABLED}    CONST LVR_NORMALDISABLED    = 2		/* for disabled gadgets	     */
NATIVE {LVR_SELECTEDDISABLED}  CONST LVR_SELECTEDDISABLED  = 8		/* disabled and selected     */

/* structure of LV_DRAW messages, object is a (struct Node *) */
NATIVE {LVDrawMsg} OBJECT lvdrawmsg
    {lvdm_MethodID}	methodid	:ULONG   /* LV_DRAW		    */
    {lvdm_RastPort}	rastport	:PTR TO rastport   /* where to render to	    */
    {lvdm_DrawInfo}	drawinfo	:PTR TO drawinfo   /* useful to have around     */
    {lvdm_Bounds}	bounds	:rectangle     /* limits of where to render */
    {lvdm_State}	state	:ULONG      /* how to render	    */
ENDOBJECT
