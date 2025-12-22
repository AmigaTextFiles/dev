/* $VER: gadtools.h 39.9 (19.8.1992) */
OPT NATIVE, PREPROCESS, POINTER
MODULE 'target/exec/types', 'target/utility/tagitem', 'target/intuition/intuition', 'target/intuition/gadgetclass'
MODULE 'target/graphics/text', 'target/intuition/screens', 'target/graphics/gfx'
{MODULE 'libraries/gadtools'}

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

NATIVE {newgadget} OBJECT newgadget
    {leftedge}	leftedge	:INT
	{topedge}	topedge	:INT	/* gadget position */
    {width}	width	:INT
	{height}	height	:INT		/* gadget size */
    {gadgettext}	gadgettext	:ARRAY OF UBYTE		/* gadget label */
    {textattr}	textattr	:PTR TO textattr	/* desired font for gadget label */
    {gadgetid}	gadgetid	:UINT			/* gadget ID */
    {flags}	flags	:ULONG			/* see below */
    {visualinfo}	visualinfo	:APTR			/* Set to retval of GetVisualInfo() */
    {userdata}	userdata	:APTR			/* gadget UserData */
ENDOBJECT


NATIVE {PLACETEXT_LEFT}	CONST PLACETEXT_LEFT	= $0001	/* Right-align text on left side */
NATIVE {PLACETEXT_RIGHT}	CONST PLACETEXT_RIGHT	= $0002	/* Left-align text on right side */
NATIVE {PLACETEXT_ABOVE}	CONST PLACETEXT_ABOVE	= $0004	/* Center text above */
NATIVE {PLACETEXT_BELOW}	CONST PLACETEXT_BELOW	= $0008	/* Center text below */
NATIVE {PLACETEXT_IN}	CONST PLACETEXT_IN	= $0010	/* Center text on */

NATIVE {NG_HIGHLABEL}	CONST NG_HIGHLABEL	= $0020	/* Highlight the label */


/*------------------------------------------------------------------------*/

/* Fill out an array of these and pass that to CreateMenus(): */

NATIVE {newmenu} OBJECT newmenu
    {type}	type	:UBYTE		/* See below */
    /* Compiler inserts a PAD byte here */
    {pad} pad:/*STRPTR*/ ARRAY OF CHAR
    {label}	label	:/*STRPTR*/ ARRAY OF CHAR		/* Menu's label */
    {commkey}	commkey	:/*STRPTR*/ ARRAY OF CHAR		/* MenuItem Command Key Equiv */
    {flags}	flags	:UINT		/* Menu or MenuItem flags (see note) */
    {mutualexclude}	mutualexclude	:VALUE	/* MenuItem MutualExclude word */
    {userdata}	userdata	:APTR		/* For your own use, see note */
ENDOBJECT

/* Needed only by inside IM_ definitions below */
NATIVE {MENU_IMAGE}	CONST MENU_IMAGE	= 128

NATIVE {NM_TITLE}	CONST NM_TITLE	= 1	/* Menu header */
NATIVE {NM_ITEM}		CONST NM_ITEM		= 2	/* Textual menu item */
NATIVE {NM_SUB}		CONST NM_SUB		= 3	/* Textual menu sub-item */

NATIVE {IM_ITEM}		CONST IM_ITEM		= (NM_ITEM OR MENU_IMAGE)	/* Graphical menu item */
NATIVE {IM_SUB}		CONST IM_SUB		= (NM_SUB OR MENU_IMAGE)	/* Graphical menu sub-item */

NATIVE {NM_END}		CONST NM_END		= 0	/* End of NewMenu array */

NATIVE {NM_IGNORE}	CONST NM_IGNORE	= 64


NATIVE {NM_BARLABEL}	CONST NM_BARLABEL	= -1 !!VALUE!!/*STRPTR*/ ARRAY OF CHAR

NATIVE {NM_MENUDISABLED}	CONST NM_MENUDISABLED	= MENUENABLED
NATIVE {NM_ITEMDISABLED}	CONST NM_ITEMDISABLED	= ITEMENABLED

NATIVE {NM_COMMANDSTRING} CONST NM_COMMANDSTRING = COMMSEQ

NATIVE {NM_FLAGMASK}	CONST NM_FLAGMASK	= (NOT (COMMSEQ OR ITEMTEXT OR HIGHFLAGS))
NATIVE {NM_FLAGMASK_V39}	CONST NM_FLAGMASK_V39	= (NOT (ITEMTEXT OR HIGHFLAGS))

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

/* MX gadget default dimensions: */
NATIVE {MX_WIDTH}	CONST MX_WIDTH	= 17
NATIVE {MX_HEIGHT}	CONST MX_HEIGHT	= 9

/* Checkbox default dimensions: */
NATIVE {CHECKBOX_WIDTH}	CONST CHECKBOX_WIDTH	= 26
NATIVE {CHECKBOX_HEIGHT}	CONST CHECKBOX_HEIGHT	= 11

/*------------------------------------------------------------------------*/

/* Tags for GadTools functions: */

NATIVE {GT_TAGBASE}	     CONST GT_TAGBASE	     = TAG_USER + $80000

NATIVE {GTVI_NEWWINDOW}	     CONST GTVI_NEWWINDOW	     = GT_TAGBASE+1  /* Unused */
NATIVE {GTVI_NWTAGS}	     CONST GTVI_NWTAGS	     = GT_TAGBASE+2  /* Unused */

NATIVE {GT_PRIVATE0}	     CONST GT_PRIVATE0	     = GT_TAGBASE+3  /* (private) */

NATIVE {GTCB_CHECKED}	     CONST GTCB_CHECKED	     = GT_TAGBASE+4  /* State of checkbox */

NATIVE {GTLV_TOP}	     CONST GTLV_TOP	     = GT_TAGBASE+5  /* Top visible one in listview */
NATIVE {GTLV_LABELS}	     CONST GTLV_LABELS	     = GT_TAGBASE+6  /* List to display in listview */
NATIVE {GTLV_READONLY}	     CONST GTLV_READONLY	     = GT_TAGBASE+7  /* TRUE if listview is to be
					    * read-only
					    */
NATIVE {GTLV_SCROLLWIDTH}     CONST GTLV_SCROLLWIDTH     = GT_TAGBASE+8  /* Width of scrollbar */

NATIVE {GTMX_LABELS}	     CONST GTMX_LABELS	     = GT_TAGBASE+9  /* NULL-terminated array of labels */
NATIVE {GTMX_ACTIVE}	     CONST GTMX_ACTIVE	     = GT_TAGBASE+10 /* Active one in mx gadget */

NATIVE {GTTX_TEXT}	     CONST GTTX_TEXT	     = GT_TAGBASE+11 /* Text to display */
NATIVE {GTTX_COPYTEXT}	     CONST GTTX_COPYTEXT	     = GT_TAGBASE+12 /* Copy text label instead of
					    * referencing it
					    */

NATIVE {GTNM_NUMBER}	     CONST GTNM_NUMBER	     = GT_TAGBASE+13 /* Number to display */

NATIVE {GTCY_LABELS}	     CONST GTCY_LABELS	     = GT_TAGBASE+14 /* NULL-terminated array of labels */
NATIVE {GTCY_ACTIVE}	     CONST GTCY_ACTIVE	     = GT_TAGBASE+15 /* The active one in the cycle gad */

NATIVE {GTPA_DEPTH}	     CONST GTPA_DEPTH	     = GT_TAGBASE+16 /* Number of bitplanes in palette */
NATIVE {GTPA_COLOR}	     CONST GTPA_COLOR	     = GT_TAGBASE+17 /* Palette color */
NATIVE {GTPA_COLOROFFSET}     CONST GTPA_COLOROFFSET     = GT_TAGBASE+18 /* First color to use in palette */
NATIVE {GTPA_INDICATORWIDTH}  CONST GTPA_INDICATORWIDTH  = GT_TAGBASE+19 /* Width of current-color indicator */
NATIVE {GTPA_INDICATORHEIGHT} CONST GTPA_INDICATORHEIGHT = GT_TAGBASE+20 /* Height of current-color indicator */

NATIVE {GTSC_TOP}	     CONST GTSC_TOP	     = GT_TAGBASE+21 /* Top visible in scroller */
NATIVE {GTSC_TOTAL}	     CONST GTSC_TOTAL	     = GT_TAGBASE+22 /* Total in scroller area */
NATIVE {GTSC_VISIBLE}	     CONST GTSC_VISIBLE	     = GT_TAGBASE+23 /* Number visible in scroller */
NATIVE {GTSC_OVERLAP}	     CONST GTSC_OVERLAP	     = GT_TAGBASE+24 /* Unused */

/*  GT_TAGBASE+25 through GT_TAGBASE+37 are reserved */

NATIVE {GTSL_MIN}	     CONST GTSL_MIN	     = GT_TAGBASE+38 /* Slider min value */
NATIVE {GTSL_MAX}	     CONST GTSL_MAX	     = GT_TAGBASE+39 /* Slider max value */
NATIVE {GTSL_LEVEL}	     CONST GTSL_LEVEL	     = GT_TAGBASE+40 /* Slider level */
NATIVE {GTSL_MAXLEVELLEN}     CONST GTSL_MAXLEVELLEN     = GT_TAGBASE+41 /* Max length of printed level */
NATIVE {GTSL_LEVELFORMAT}     CONST GTSL_LEVELFORMAT     = GT_TAGBASE+42 /* Format string for level */
NATIVE {GTSL_LEVELPLACE}      CONST GTSL_LEVELPLACE      = GT_TAGBASE+43 /* Where level should be placed */
NATIVE {GTSL_DISPFUNC}	     CONST GTSL_DISPFUNC	     = GT_TAGBASE+44 /* Callback for number calculation
					    * before display
					    */

NATIVE {GTST_STRING}	     CONST GTST_STRING	     = GT_TAGBASE+45 /* String gadget's displayed string */
NATIVE {GTST_MAXCHARS}	     CONST GTST_MAXCHARS	     = GT_TAGBASE+46 /* Max length of string */

NATIVE {GTIN_NUMBER}	     CONST GTIN_NUMBER	     = GT_TAGBASE+47 /* Number in integer gadget */
NATIVE {GTIN_MAXCHARS}	     CONST GTIN_MAXCHARS	     = GT_TAGBASE+48 /* Max number of digits */

NATIVE {GTMN_TEXTATTR}	     CONST GTMN_TEXTATTR	     = GT_TAGBASE+49 /* MenuItem font TextAttr */
NATIVE {GTMN_FRONTPEN}	     CONST GTMN_FRONTPEN	     = GT_TAGBASE+50 /* MenuItem text pen color */

NATIVE {GTBB_RECESSED}	     CONST GTBB_RECESSED	     = GT_TAGBASE+51 /* Make BevelBox recessed */

NATIVE {GT_VISUALINFO}	     CONST GT_VISUALINFO	     = GT_TAGBASE+52 /* result of VisualInfo call */

NATIVE {GTLV_SHOWSELECTED}    CONST GTLV_SHOWSELECTED    = GT_TAGBASE+53 /* show selected entry beneath
		* listview, set tag data = NULL for display-only, or pointer
		* to a string gadget you've created
		*/
NATIVE {GTLV_SELECTED}	     CONST GTLV_SELECTED	     = GT_TAGBASE+54 /* Set ordinal number of selected
					    * entry in the list
					    */
NATIVE {GT_RESERVED1}	     CONST GT_RESERVED1	     = GT_TAGBASE+56 /* Reserved for future use */

NATIVE {GTTX_BORDER}	     CONST GTTX_BORDER	     = GT_TAGBASE+57 /* Put a border around
					    * Text-display gadgets
					    */
NATIVE {GTNM_BORDER}	     CONST GTNM_BORDER	     = GT_TAGBASE+58 /* Put a border around
					    * Number-display gadgets
					    */

NATIVE {GTSC_ARROWS}	     CONST GTSC_ARROWS	     = GT_TAGBASE+59 /* Specify size of arrows for
					    * scroller
					    */

NATIVE {GTMN_MENU}	     CONST GTMN_MENU	     = GT_TAGBASE+60 /* Pointer to Menu for use by
					    * LayoutMenuItems()
					    */
NATIVE {GTMX_SPACING}	     CONST GTMX_SPACING	     = GT_TAGBASE+61 /* Added to font height to
		* figure spacing between mx choices.  Use this instead
		* of LAYOUTA_SPACING for mx gadgets.
		*/

/* New to V37 GadTools.  Ignored by GadTools V36 */
NATIVE {GTMN_FULLMENU}	     CONST GTMN_FULLMENU	     = GT_TAGBASE+62 /* Asks CreateMenus() to
		* validate that this is a complete menu structure
		*/
NATIVE {GTMN_SECONDARYERROR}  CONST GTMN_SECONDARYERROR  = GT_TAGBASE+63 /* ti_Data is a pointer
		* to a ULONG to receive error reports from CreateMenus()
		*/
NATIVE {GT_UNDERSCORE}	     CONST GT_UNDERSCORE	     = GT_TAGBASE+64 /* ti_Data points to the symbol
		* that preceeds the character you'd like to underline in a
		* gadget label
		*/
NATIVE {GTST_EDITHOOK}	     CONST GTST_EDITHOOK	     = GT_TAGBASE+55 /* String EditHook */
NATIVE {GTIN_EDITHOOK}	     CONST GTIN_EDITHOOK	     = GTST_EDITHOOK /* Same thing, different name,
		* just to round out INTEGER_KIND gadgets
		*/

/* New to V39 GadTools.  Ignored by GadTools V36 and V37 */
NATIVE {GTMN_CHECKMARK}	     CONST GTMN_CHECKMARK	     = GT_TAGBASE+65 /* ti_Data is checkmark img to use */
NATIVE {GTMN_AMIGAKEY}	     CONST GTMN_AMIGAKEY	     = GT_TAGBASE+66 /* ti_Data is Amiga-key img to use */
NATIVE {GTMN_NEWLOOKMENUS}    CONST GTMN_NEWLOOKMENUS    = GT_TAGBASE+67 /* ti_Data is boolean */

/* New to V39 GadTools.  Ignored by GadTools V36 and V37.
 * Set to TRUE if you want the checkbox or mx image scaled to
 * the gadget width/height you specify.  Defaults to FALSE,
 * for compatibility.
 */
NATIVE {GTCB_SCALED}	     CONST GTCB_SCALED	     = GT_TAGBASE+68 /* ti_Data is boolean */
NATIVE {GTMX_SCALED}	     CONST GTMX_SCALED	     = GT_TAGBASE+69 /* ti_Data is boolean */

NATIVE {GTPA_NUMCOLORS}	     CONST GTPA_NUMCOLORS	     = GT_TAGBASE+70 /* Number of colors in palette */

NATIVE {GTMX_TITLEPLACE}      CONST GTMX_TITLEPLACE      = GT_TAGBASE+71 /* Where to put the title */

NATIVE {GTTX_FRONTPEN}	     CONST GTTX_FRONTPEN	     = GT_TAGBASE+72 /* Text color in TEXT_KIND gad */
NATIVE {GTTX_BACKPEN}	     CONST GTTX_BACKPEN	     = GT_TAGBASE+73 /* Bgrnd color in TEXT_KIND gad */
NATIVE {GTTX_JUSTIFICATION}   CONST GTTX_JUSTIFICATION   = GT_TAGBASE+74 /* See GTJ_#? constants */

NATIVE {GTNM_FRONTPEN}	     CONST GTNM_FRONTPEN	     = GT_TAGBASE+72 /* Text color in NUMBER_KIND gad */
NATIVE {GTNM_BACKPEN}	     CONST GTNM_BACKPEN	     = GT_TAGBASE+73 /* Bgrnd color in NUMBER_KIND gad */
NATIVE {GTNM_JUSTIFICATION}   CONST GTNM_JUSTIFICATION   = GT_TAGBASE+74 /* See GTJ_#? constants */
NATIVE {GTNM_FORMAT}	     CONST GTNM_FORMAT	     = GT_TAGBASE+75 /* Formatting string for number */
NATIVE {GTNM_MAXNUMBERLEN}    CONST GTNM_MAXNUMBERLEN    = GT_TAGBASE+76 /* Maximum length of number */

NATIVE {GTBB_FRAMETYPE}	     CONST GTBB_FRAMETYPE	     = GT_TAGBASE+77 /* defines what kind of boxes
					    * DrawBevelBox() renders. See
					    * the BBFT_#? constants for
					    * possible values
					    */

NATIVE {GTLV_MAKEVISIBLE}     CONST GTLV_MAKEVISIBLE     = GT_TAGBASE+78 /* Make this item visible */
NATIVE {GTLV_ITEMHEIGHT}      CONST GTLV_ITEMHEIGHT      = GT_TAGBASE+79 /* Height of an individual item */

NATIVE {GTSL_MAXPIXELLEN}     CONST GTSL_MAXPIXELLEN     = GT_TAGBASE+80 /* Max pixel size of level display */
NATIVE {GTSL_JUSTIFICATION}   CONST GTSL_JUSTIFICATION   = GT_TAGBASE+81 /* how should the level be displayed */

NATIVE {GTPA_COLORTABLE}      CONST GTPA_COLORTABLE      = GT_TAGBASE+82 /* colors to use in palette */

NATIVE {GTLV_CALLBACK}	     CONST GTLV_CALLBACK	     = GT_TAGBASE+83 /* general-purpose listview call back */
NATIVE {GTLV_MAXPEN}	     CONST GTLV_MAXPEN	     = GT_TAGBASE+84 /* maximum pen number used by call back */

NATIVE {GTTX_CLIPPED}	     CONST GTTX_CLIPPED	     = GT_TAGBASE+85 /* make a TEXT_KIND clip text */
NATIVE {GTNM_CLIPPED}	     CONST GTNM_CLIPPED	     = GT_TAGBASE+85 /* make a NUMBER_KIND clip text */

/* Old definition, now obsolete: */
NATIVE {GT_RESERVED0}	     CONST GT_RESERVED0	     = GTST_EDITHOOK

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
NATIVE {GTNW_LABELS}	CONST GTNW_LABELS	= GTCY_LABELS
NATIVE {GTNW_ACTIVE}	CONST GTNW_ACTIVE	= GTCY_ACTIVE

/*------------------------------------------------------------------------*/

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
NATIVE {lvdrawmsg} OBJECT lvdrawmsg
    {methodid}	methodid	:ULONG   /* LV_DRAW		    */
    {rastport}	rastport	:PTR TO rastport   /* where to render to	    */
    {drawinfo}	drawinfo	:PTR TO drawinfo   /* useful to have around     */
    {bounds}	bounds	:rectangle     /* limits of where to render */
    {state}	state	:ULONG      /* how to render	    */
ENDOBJECT
