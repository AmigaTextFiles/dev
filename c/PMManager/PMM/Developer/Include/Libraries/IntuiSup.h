/* $Revision Header *** Header built automatically - do not edit! ***********
 *
 *	(C) Copyright 1991 by Torsten Jürgeleit
 *
 *	Name .....: intuisup.h
 *	Created ..: Sunday 22-Dec-91 20:34:40
 *	Revision .: 15
 *
 *	Date        Author                 Comment
 *	=========   ====================   ====================
 *	14-Sep-92   Torsten Jürgeleit      open_window(): new flag to prevent
 *					   adding of inner window offsets
 *	08-Aug-92   Torsten Jürgeleit      new flags
 *					   GADGET_DATA_FLAG_INPUT_CENTER/RIGHT
 *	06-Aug-92   Torsten Jürgeleit      new flag
 *					   GADGET_DATA_FLAG_LISTVIEW_ENTRY_COLOR
 *	28-Jul-92   Torsten Jürgeleit      different centering types for
 *					   requesters
 *	28-Jul-92   Torsten Jürgeleit      open window centered over position
 *					   of mouse pointer
 *	11-Jul-92   Torsten Jürgeleit      use RAWKEY instead of VANILLAKEY
 *					   for gadget hotkeys
 *	01-Jul-92   Torsten Jürgeleit      added support for custom slider
 *					   knob image
 *	21-Jun-92   Torsten Jürgeleit      check for compiler and define
 *					   differences
 *	03-Jun-92   Torsten Jürgeleit      alternate color for menu item texts
 *	14-Apr-92   Torsten Jürgeleit      neq flag GADGET_DATA_FLAG_NO_CLEAR
 *	12-May-92   Torsten Jürgeleit      text colors for IClearWindow()
 *	30-Apr-92   Torsten Jürgeleit      rasters for IClearWindow() and
 *					   requesters
 *	01-Apr-92   Torsten Jürgeleit      changed parameter size of
 *					   IModifyGadget() for new value of
 *					   USE_CURRENT_VALUE (1L << 31)
 *	31-Mar-92   Torsten Jürgeleit      changed USE_CURRENT_VALUE from ~0L
 *					   to (1L << 31)
 *	21-Mar-92   Torsten Jürgeleit      flags for converting numbers with
 *					   string gadgets
 *	22-Dec-91   Torsten Jürgeleit      Created this file!
 *
 ****************************************************************************
 *
 *	Includes, defines, structures, prototypes and pragmas for IntuiSup
 *	library
 *
 * $Revision Header ********************************************************/

#ifndef	LIBRARIES_INTUISUP_H
#define	LIBRARIES_INTUISUP_H

	/* Includes */

#ifndef	EXEC_TYPES_H
#include <exec/types.h>
#endif	/* EXEC_TYPES_H */

#ifndef	EXEC_LISTS_H
#include <exec/lists.h>
#endif	/* EXEC_LISTS_H */

#ifndef	LIBRARIES_DISKFONT_H
#include <libraries/diskfont.h>
#endif	/* LIBRARIES_DISKFONT_H */

#ifndef	INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif	/* INTUITION_INTUITION_H */

	/* Check for compiler and define the differences */

#ifdef	AZTEC_C
#ifndef	__VERSION
#define __VERSION 360
#endif	/* __VERSION */
#if	__VERSION < 500
#define __NO_PRAGMAS
#define __NO_PROTOTYPES
#endif	/* __VERSION */
#define C_Args
#endif	/* AZTEC_C */

#ifdef	LATTICE
#define	C_Args	__stdargs
#endif	/* LATTICE */

#ifdef	DICE
#define	__NO_PRAGMAS
#define	C_Args
#endif	/* DICE */

	/* Defines for library */

#define IntuiSupName		"intuisup.library"
#define IntuiSupVersion		4L

	/* Defines for render */

#define RENDER_INFO_FLAG_INNER_WINDOW		(USHORT)(1 << 0)	/* use upper left corner of inner window as location (0,0) */
#define RENDER_INFO_FLAG_BACK_FILL		(USHORT)(1 << 1)	/* fill window back ground with different color */
#define RENDER_INFO_FLAG_AVAIL_FONTS		(USHORT)(1 << 2)	/* scan available fonts and use this list for IAskFont/IOpenFont */

#define INTUISUP_DATA_END	(USHORT)0	   /* mark end of data arry */

#define ISUP_ID		((ULONG)'I' << 24 | (ULONG)'S' << 16 | 'U' << 8 | 'P')

	/* Defines for open window flags */

#define OPEN_WINDOW_FLAG_CENTER_SCREEN		(1 << 0)   /* center window on screen */
#define OPEN_WINDOW_FLAG_RENDER_PENS		(1 << 1)   /* use render pens for detail and backfill pen */
#define OPEN_WINDOW_FLAG_CENTER_MOUSE		(1 << 2)   /* center window over current position of mouse pointer */
#define OPEN_WINDOW_FLAG_NO_INNER_WINDOW	(1 << 3)   /* don't add inner window offsets for RENDER_INFO_FLAG_INNER_WINDOW */

	/* Defines for clear window flags */

#define CLEAR_WINDOW_FLAG_CUSTOM_DRAW_MODE	(1 << 0)   /* don't change draw mode */
#define CLEAR_WINDOW_FLAG_CUSTOM_COLOR		(1 << 1)   /* don't change background color */
#define CLEAR_WINDOW_FLAG_NORMAL_COLOR		(1 << 2)   /* use normal background color */
#define CLEAR_WINDOW_FLAG_USE_RASTER		(1 << 3)   /* use standard raster for window background */
#define CLEAR_WINDOW_FLAG_ABSOLUTE_POS		(1 << 4)   /* don't add window border offset to given upper left position */
#define CLEAR_WINDOW_FLAG_TEXT1_COLOR		(1 << 5)   /* use text color 1 */
#define CLEAR_WINDOW_FLAG_TEXT2_COLOR		(1 << 6)   /* use text color 2 */

	/* Defines for texts */

#define TEXT_DATA_TYPE_TEXT			(USHORT)1
#define TEXT_DATA_TYPE_NUM_UNSIGNED_DEC		(USHORT)2
#define TEXT_DATA_TYPE_NUM_SIGNED_DEC		(USHORT)3
#define TEXT_DATA_TYPE_NUM_HEX			(USHORT)4
#define TEXT_DATA_TYPE_NUM_BIN			(USHORT)5

#define TEXT_DATA_FLAG_BOLD			(USHORT)(1 << 0)
#define TEXT_DATA_FLAG_ITALIC			(USHORT)(1 << 1)
#define TEXT_DATA_FLAG_UNDERLINED		(USHORT)(1 << 2)
#define TEXT_DATA_FLAG_ABSOLUTE_POS		(USHORT)(1 << 3)	/* absolute text pos given - don't add border offsets */
#define TEXT_DATA_FLAG_CENTER			(USHORT)(1 << 4)	/* center text with in window width */
#define TEXT_DATA_FLAG_PLACE_LEFT		(USHORT)(1 << 5)	/* place text left of given left edge */
#define TEXT_DATA_FLAG_COLOR2			(USHORT)(1 << 6)	/* use 2nd text render pen */
#define TEXT_DATA_FLAG_COMPLEMENT		(USHORT)(1 << 7)	/* use complement of front and back pen */
#define TEXT_DATA_FLAG_BACK_FILL		(USHORT)(1 << 8)	/* use draw mode JAM2 to fill text background with ri_BackPen */
#define TEXT_DATA_FLAG_NO_PRINT			(USHORT)(1 << 9)	/* don't print text - only calc width */
#define TEXT_DATA_FLAG_NUM_IDENTIFIER		(USHORT)(1 << 10)	/* convert number with normal (assmebler style) leading identifier `$' or `%' */
#define TEXT_DATA_FLAG_NUM_C_STYLE		(USHORT)(1 << 11)	/* use C style identifier `0x' for hex numbers */
#define TEXT_DATA_FLAG_NUM_LEADING_ZEROES	(USHORT)(1 << 12)	/* convert number includeing leading zeroes */
#define TEXT_DATA_FLAG_NUM_UPPER_CASE		(USHORT)(1 << 13)	/* use upper case characters for hex number */

#define CONVERT_FLAG_IDENTIFIER			(USHORT)(1 << 0)	/* convert number with normal (assmebler style) leading identifier `$' or `%' */
#define CONVERT_FLAG_C_STYLE			(USHORT)(1 << 1)	/* use C style identifier `0x' for hex numbers */
#define CONVERT_FLAG_LEADING_ZEROES		(USHORT)(1 << 2)	/* convert number includeing leading zeroes */
#define CONVERT_FLAG_UPPER_CASE			(USHORT)(1 << 3)	/* use upper case characters for hex number */

	/* Structures for texts */

struct TextData {
	USHORT	td_Type;
	USHORT	td_Flags;
	SHORT	td_LeftEdge;
	SHORT	td_TopEdge;
	BYTE	*td_Text;
	struct TextAttr  *td_TextAttr;
};
	/* Defines for borders */

#define BORDER_DATA_TYPE_BOX1_OUT	(USHORT)1
#define BORDER_DATA_TYPE_BOX1_IN	(USHORT)2
#define BORDER_DATA_TYPE_BOX2_OUT	(USHORT)3
#define BORDER_DATA_TYPE_BOX2_IN	(USHORT)4

	/* Structures for borders */

struct BorderData {
	USHORT	bd_Type;
	SHORT	bd_LeftEdge;
	SHORT	bd_TopEdge;
	USHORT	bd_Width;
	USHORT	bd_Height;
};
	/* Defines for gadgets */

#define GADGET_DATA_TYPE_BUTTON		(USHORT)1	/* button gadget */
#define GADGET_DATA_TYPE_CHECK		(USHORT)2	/* checkbox gadget */
#define GADGET_DATA_TYPE_MX		(USHORT)3	/* mutual exclude gadget */
#define GADGET_DATA_TYPE_STRING		(USHORT)4	/* string input gadget */
#define GADGET_DATA_TYPE_INTEGER	(USHORT)5	/* integer input gadget */
#define GADGET_DATA_TYPE_SLIDER		(USHORT)6	/* slider gadget */
#define GADGET_DATA_TYPE_SCROLLER	(USHORT)7	/* scroller gadget */
#define GADGET_DATA_TYPE_CYCLE		(USHORT)8	/* cycle gadget */
#define GADGET_DATA_TYPE_COUNT		(USHORT)9	/* count gadget */
#define GADGET_DATA_TYPE_LISTVIEW	(USHORT)10	/* list view gadget */
#define GADGET_DATA_TYPE_PALETTE	(USHORT)11	/* palette gadget */

#define GADGET_DATA_FLAG_DISABLED		(1L << 0)	/* gadget disabled (ghosted) - default enabled */
#define GADGET_DATA_FLAG_NO_BORDER		(1L << 1)	/* no gadget border - default with border */
#define GADGET_DATA_FLAG_HIGH_COMP		(1L << 2)	/* highliting by complement - default by select border */
#define GADGET_DATA_FLAG_ORIENTATION_VERT	(1L << 3)	/* vertical orientation - default horizontal */
#define GADGET_DATA_FLAG_HOTKEY			(1L << 4)	/* hotkey given - default none */
#define GADGET_DATA_FLAG_NO_TEXT_OUTPUT		(1L << 5)	/* no text output, but scan gadget text for hotkey */
#define GADGET_DATA_FLAG_TEXT_LEFT		(1L << 6)	/* place text left of gadget */
#define GADGET_DATA_FLAG_TEXT_RIGHT		(1L << 7)	/* place text right of gadget */
#define GADGET_DATA_FLAG_TEXT_ABOVE		(1L << 8)	/* place text above of gadget */
#define GADGET_DATA_FLAG_TEXT_BELOW		(1L << 9)	/* place text below of gadget */
#define GADGET_DATA_FLAG_TEXT_COLOR2		(1L << 10)	/* use 2nd text render pen for gadget text */
#define GADGET_DATA_FLAG_BUTTON_TOGGLE		(1L << 11)	/* button gadgets: toggle button - default no toggle */
#define GADGET_DATA_FLAG_BUTTON_IMAGE		(1L << 12)	/* button gadgets: render image - default no image */
#define GADGET_DATA_FLAG_INPUT_AUTO_ACTIVATE	(1L << 13)	/* input gadgets: acivate after GADGETUP next or previous input gadget */
#define GADGET_DATA_FLAG_STRING_UNSIGNED_DEC    (1L << 14)	/* string gadgets: input default no pointer to string but an unsigned decimal number */
#define GADGET_DATA_FLAG_STRING_SIGNED_DEC	(1L << 15)	/* string gadgets: input default no pointer to string but an signed decimal number */
#define GADGET_DATA_FLAG_STRING_HEX		(1L << 16)	/* string gadgets: input default no pointer to string but an hex number */
#define GADGET_DATA_FLAG_STRING_BIN		(1L << 17)	/* string gadgets: input default no pointer to string but an binary number */
#define GADGET_DATA_FLAG_SCROLLER_NO_ARROWS	(1L << 18)	/* scroller gadget: no arrows - default with arrows */
#define GADGET_DATA_FLAG_COUNT_SIGNED_DEC	(1L << 19)	/* count gadget: signed dec - default unsigned dec */
#define GADGET_DATA_FLAG_LISTVIEW_READ_ONLY	(1L << 20)	/* list view gadget: read only - default selection enabled */
#define GADGET_DATA_FLAG_LISTVIEW_SHOW_SELECTED (1L << 21)	/* list view gadget: show last selected entry - default no */
#define GADGET_DATA_FLAG_PALETTE_NO_INDICATOR	(1L << 22)	/* palette gadget: no current color indicator - default with indicator */
#define GADGET_DATA_FLAG_PALETTE_INDICATOR_TOP	(1L << 23)	/* palette gadget: place indicator at top - default at left */
#define GADGET_DATA_FLAG_MOVE_POINTER		(1L << 24)	/* move mouse pointer to center of this gadget */
#define GADGET_DATA_FLAG_NO_CLEAR		(1L << 25)	/* don't clear area occupied by this gadget before drawing */
#define GADGET_DATA_FLAG_SLIDER_IMAGE		(1L << 26)	/* kludge to define image for knob of proportional gadget in gd_TextAttr (if text then default TextAttr used) */
#define GADGET_DATA_FLAG_LISTVIEW_ENTRY_COLOR	(1L << 27)	/* list view gadget: if first char of an entry text equals <Ctrl A> ($01) then this char will be skipped and the rest of this entry text will be printed in a different color */
#define GADGET_DATA_FLAG_INPUT_CENTER		(1L << 28)	/* input gadgets: center input string within gadget */
#define GADGET_DATA_FLAG_INPUT_RIGHT		(1L << 29)	/* input gadgets: right justify input string within gadget */

#define GADGET_IDCMP_FLAGS_BUTTON	(GADGETUP | RAWKEY)
#define GADGET_IDCMP_FLAGS_CHECK	(GADGETDOWN | RAWKEY)
#define GADGET_IDCMP_FLAGS_MX		(GADGETDOWN | RAWKEY)
#define GADGET_IDCMP_FLAGS_STRING	(GADGETUP | RAWKEY)
#define GADGET_IDCMP_FLAGS_INTEGER	(GADGETUP | RAWKEY)
#define GADGET_IDCMP_FLAGS_SLIDER	(GADGETUP | MOUSEMOVE | RAWKEY)
#define GADGET_IDCMP_FLAGS_SCROLLER	(GADGETDOWN | GADGETUP | MOUSEMOVE | INTUITICKS | RAWKEY)
#define GADGET_IDCMP_FLAGS_CYCLE	(GADGETUP | RAWKEY)
#define GADGET_IDCMP_FLAGS_COUNT	(GADGETDOWN | GADGETUP | MOUSEMOVE | RAWKEY)
#define GADGET_IDCMP_FLAGS_LISTVIEW	(GADGETDOWN | GADGETUP | MOUSEMOVE | INTUITICKS | RAWKEY)
#define GADGET_IDCMP_FLAGS_PALETTE	(GADGETUP | RAWKEY)
#define GADGET_IDCMP_FLAGS_ALL		(GADGETDOWN | GADGETUP | MOUSEMOVE | INTUITICKS | RAWKEY)

#define INPUT_AUTO_ACTIVATE(next,prev)	((((LONG)next) << 16) | prev)	/* macro for (gd_InputActivateNext | gd_InpuActivatePrev) */

#define USE_CURRENT_VALUE	(1L << 31)	/* used for set_gadget_attributes() to indicate data for which to use the current value */

	/* Structures for gadgets */

struct GadgetData {
	ULONG	gd_Type;
	ULONG	gd_Flags;
	USHORT	gd_LeftEdge;
	USHORT	gd_TopEdge;
	USHORT	gd_Width;
	USHORT	gd_Height;
	BYTE	*gd_Text;
	struct TextAttr  *gd_TextAttr;
	union	{
	    struct {	/* standard data struct */
		LONG	gd_Data1;
		LONG	gd_Data2;
		VOID	*gd_Data3;
	    } gd_Data;
	    struct {	/* for button gadgets */
		ULONG	gd_ButtonSelected;		/* selection state for toggle buttons - ZERO = unselected, non ZERO = selected */
		struct Image  *gd_ButtonNormalRender;	/* normal render image */
		struct Image  *gd_ButtonSelectRender;	/* select render image */
	    } gd_ButtonData;
	    struct {	/* for check gadgets */
		ULONG	gd_CheckSelected;	/* selection state - ZERO = unselected, non ZERO = selected */
		ULONG	gd_CheckPad1;
		ULONG	gd_CheckPad2;
	    } gd_CheckData;
	    struct {	/* for mutual exclude gadgets */
		ULONG	gd_MXSpacing;		/* pixel spacing between MX gadgets */
		ULONG	gd_MXActiveEntry;	/* num of active entry from text array */
		BYTE	**gd_MXTextArray;	/* ptr to MX text ptr array */
	    } gd_MXData;
	    struct {	/* for string and integer gadgets */
		ULONG	gd_InputLen;		/* len of input buffer */
		USHORT	gd_InputActivateNext;	/* num of next string/num gadget to activate */
		USHORT	gd_InputActivatePrev;	/* num of previous string/num gadget to activate */
		BYTE	*gd_InputDefault;	/* string: default text [syntax: "text"] */
						/* integer: default number [syntax: (VOID *)num] */
	    } gd_InputData;
	    struct {	/* for slider gadgets */
		LONG	gd_SliderMin;		/* min level */
		LONG	gd_SliderMax;		/* max level */
		LONG	gd_SliderLevel;		/* current slider level */
	    } gd_SliderData;
	    struct {	/* for scroller gadgets */
		ULONG	gd_ScrollerVisible;	/* visible entries */
		ULONG	gd_ScrollerTotal;	/* total entries */
		ULONG	gd_ScrollerTop;		/* current top entry */
	    } gd_ScrollerData;
	    struct {	/* for cycle gadget */
		ULONG	gd_CycleSpacing;	/* pixel spacing between pop up cycle list entries */
		ULONG	gd_CycleActive;		/* num of current cycle text ptr array entry */
		BYTE	**gd_CycleTextArray;	/* ptr to cycle text ptr array */
	    } gd_CycleData;
	    struct {	/* for count gadget */
		ULONG	gd_CountMin;		/* min value */
		ULONG	gd_CountMax;		/* max value */
		ULONG	gd_CountValue;	/* current count value */
	    } gd_CountData;
	    struct {	/* for list view gadget */
		ULONG	gd_ListViewSpacing;	/* pixel spacing between list view entries */
		ULONG	gd_ListViewTop;		/* current top entry */
		struct List  *gd_ListViewList;	/* current list ptr */
	    } gd_ListViewData;
	    struct {	/* for palette gadget */
		ULONG	gd_PaletteDepth;	/* num of bitplanes for palette */
		ULONG	gd_PaletteColorOffset;	/* first color of palette */
		ULONG	gd_PaletteActiveColor;	/* selected color */
	    } gd_PaletteData;
	} gd_SpecialData;
};
	/* Defines for auto request */

#define AUTO_REQ_FLAG_BACK_FILL		(USHORT)(1 << 0)
#define AUTO_REQ_FLAG_RENDER_PENS	(USHORT)(1 << 1)
#define AUTO_REQ_FLAG_TEXT_CENTER	(USHORT)(1 << 2)
#define AUTO_REQ_FLAG_TEXT_COLOR2	(USHORT)(1 << 3)
#define AUTO_REQ_FLAG_HOTKEY		(USHORT)(1 << 4)
#define AUTO_REQ_FLAG_BEEP		(USHORT)(1 << 5)
#define AUTO_REQ_FLAG_MOVE_POINTER_POS	(USHORT)(1 << 6)
#define AUTO_REQ_FLAG_MOVE_POINTER_NEG	(USHORT)(1 << 7)
#define AUTO_REQ_FLAG_DRAW_RASTER	(USHORT)(1 << 8)	/* draw raster around text area */
#define AUTO_REQ_FLAG_CENTER_MOUSE	(USHORT)(1 << 9)	/* center last gadget of auto requester over current position of mouse pointer */

	/* Defines for requester */

#define REQ_DATA_FLAG_BACK_FILL		(1L << 0)
#define REQ_DATA_FLAG_RENDER_PENS	(1L << 1)
#define REQ_DATA_FLAG_INNER_WINDOW	(1L << 2)
#define REQ_DATA_FLAG_AVAIL_FONTS	(1L << 3)
#define REQ_DATA_FLAG_CENTER_SCREEN	(1L << 4)	/* center requester on window's screen */
#define REQ_DATA_FLAG_DRAG_GADGET	(1L << 5)
#define REQ_DATA_FLAG_DEPTH_GADGET	(1L << 6)
#define REQ_DATA_FLAG_DRAW_RASTER	(1L << 7)	/* draw raster between FIRST BORDER and window border - FIRST BORDER will not be used further */
#define REQ_DATA_FLAG_CENTER_WINDOW	(1L << 8)	/* center requester on window */
#define REQ_DATA_FLAG_CENTER_MOUSE	(1L << 9)	/* center requester over current position of mouse pointer */

	/* Structures for requester */

struct RequesterData {
	SHORT	rd_LeftEdge;
	SHORT	rd_TopEdge;
	SHORT	rd_Width;
	SHORT	rd_Height;
	ULONG	rd_Flags;
	BYTE	*rd_Title;
	struct TextData    *rd_Texts;
	struct BorderData  *rd_Borders;
	struct GadgetData  *rd_Gadgets;
};
	/* Defines for menus */

#define MENU_DATA_TYPE_TITLE		(USHORT)1
#define MENU_DATA_TYPE_ITEM		(USHORT)2
#define MENU_DATA_TYPE_SUBITEM		(USHORT)3

#define MENU_DATA_FLAG_DISABLED		(USHORT)(1 << 0)	/* disable menu or menu item */
#define MENU_DATA_FLAG_ATTRIBUTE	(USHORT)(1 << 1)	/* attribute menu item */
#define MENU_DATA_FLAG_SELECTED		(USHORT)(1 << 2)	/* selected attribute menu item */
#define MENU_DATA_FLAG_EMPTY_LINE	(USHORT)(1 << 3)	/* insert empty line before this item */
#define MENU_DATA_FLAG_HIGH_NONE	(USHORT)(1 << 4)	/* no highliting */
#define MENU_DATA_FLAG_HIGH_BOX		(USHORT)(1 << 5)	/* highliting with box, otherwise with complement */
#define MENU_DATA_FLAG_TEXT_COLOR2	(USHORT)(1 << 6)	/* alternate color for item text */

	/* Structures for menus */

struct MenuData {
	USHORT	md_Type;
	USHORT	md_Flags;
	BYTE	*md_Name;
	BYTE	*md_CommandKey;
	ULONG	md_MutualExclude;
};
	/* Defines for text file */

#define TEXT_FILE_FLAG_TRIM_LINE		(USHORT)(1 << 0)	/* strip leading and trailing white space */
#define TEXT_FILE_FLAG_SKIP_COMMENTS		(USHORT)(1 << 1)	/* skip C style comments */
#define TEXT_FILE_FLAG_SKIP_EMPTY_LINES		(USHORT)(1 << 2)	/* skip empty lines */
#define TEXT_FILE_FLAG_LINE_CONTINUATION	(USHORT)(1 << 3)	/* continue line with last character '\' in next line */

#define TEXT_FILE_STATUS_NORMAL			(SHORT)0
#define TEXT_FILE_STATUS_EOF			(SHORT)1

#define TEXT_FILE_ERROR_NO_FILE_DATA		(SHORT)-1
#define TEXT_FILE_ERROR_LINE_TOO_LONG		(SHORT)-2
#define TEXT_FILE_ERROR_NO_COMMENT_END		(SHORT)-3
#define TEXT_FILE_ERROR_READ_FAILED		(SHORT)-4

	/* Structures for text file */

struct FileData {
	BYTE	*fd_Line;
	USHORT	fd_LineLen;
	USHORT	fd_LineNum;
};
	/* Structures for mouse pointer */

struct PointerData {
	UBYTE	pd_Width;
	UBYTE	pd_Height;
	BYTE	pd_XOffset;
	BYTE	pd_YOffset;
	UWORD	*pd_Data;
};

	/* Turn off prototypes if compiler does not handle them */

#ifdef	__NO_PROTOTYPES
#define	__PARMS(x)	()
#else
#define	__PARMS(x)	x
#endif	/* __NO_PROTOTYPES */

	/* Prototypes */

APTR			IGetRenderInfo		__PARMS( (struct Screen  *screen, USHORT flags) );
VOID			IFreeRenderInfo		__PARMS( (APTR ri) );
struct Window		*IOpenWindow		__PARMS( (APTR ri, struct NewWindow  *nw, USHORT flags) );
VOID			IClearWindow		__PARMS( (APTR ri, struct Window  *win, USHORT left_edge, USHORT top_edge, USHORT width, USHORT height, USHORT flags) );
VOID			ICloseWindow		__PARMS( (struct Window  *win, BOOL more_windows) );
struct AvailFontsHeader	*IAvailFonts		__PARMS( (APTR ri) );
struct TextAttr		*IAskFont		__PARMS( (APTR ri, struct TextAttr  *ta) );
struct TextFont		*IOpenFont		__PARMS( (APTR ri, struct TextAttr  *ta) );

VOID			IDisplayTexts		__PARMS( (APTR ri, struct Window  *win, struct TextData  *td, SHORT hoffset, SHORT voffset, BYTE **language_text_array) );
USHORT			IPrintText		__PARMS( (APTR ri, struct Window  *win, BYTE *text, USHORT left_edge, USHORT top_edge, USHORT type, USHORT flags, struct TextAttr  *text_attr) );
USHORT			IConvertUnsignedDec	__PARMS( (ULONG num, BYTE *buffer, USHORT flags) );
USHORT			IConvertSignedDec	__PARMS( (LONG num, BYTE *buffer, USHORT flags) );
USHORT			IConvertHex		__PARMS( (ULONG num, BYTE *buffer, USHORT flags) );
USHORT			IConvertBin		__PARMS( (ULONG num, BYTE *buffer, USHORT flags) );

VOID			IDisplayBorders		__PARMS( (APTR ri, struct Window  *win, struct BorderData  *bd, SHORT hoffset, SHORT voffset) );
VOID			IDrawBorder		__PARMS( (APTR ri, struct Window  *win, USHORT left_edge, USHORT top_edge, USHORT width, USHORT height, USHORT type) );

APTR			ICreateGadgets		__PARMS( (APTR ri, struct GadgetData  *gd, SHORT hoffset, SHORT voffset, BYTE **language_text_array) );
VOID			IFreeGadgets		__PARMS( (APTR gl) );
VOID			IDisplayGadgets		__PARMS( (struct Window  *win, APTR gl) );
VOID			IRefreshGadgets		__PARMS( (APTR gl) );
VOID			IModifyGadget		__PARMS( (APTR gl, USHORT data_entry, LONG left_edge, LONG top_edge, ULONG width, ULONG height) );
ULONG			ISetGadgetAttributes	__PARMS( (APTR gl, USHORT data_entry, ULONG flag_mask, ULONG flag_bits, ULONG data1, ULONG data2, VOID *data3) );
VOID			IActivateInputGadget	__PARMS( (APTR gl, USHORT data_entry) );
struct Gadget		*IGadgetAddress		__PARMS( (APTR gl, USHORT data_entry) );
struct Window		*IRemoveGadgets		__PARMS( (APTR gl) );
struct IntuiMessage	*IGetMsg		__PARMS( (struct MsgPort  *uport) );
VOID			IReplyMsg		__PARMS( (struct IntuiMessage  *imsg) );
UBYTE			IConvertRawKeyToASCII	__PARMS( (struct IntuiMessage  *imsg) );

BOOL			IAutoRequest		__PARMS( (struct Window  *req_win, BYTE *title, BYTE *body_text, BYTE *pos_text, BYTE *neg_text, LONG pos_idcmp_flags, LONG neg_idcmp_flags, USHORT req_flags, BYTE **language_text_array) );
APTR			IDisplayRequester	__PARMS( (struct Window  *req_win, struct RequesterData  *rd, BYTE **language_text_array) );
VOID			IRemoveRequester	__PARMS( (APTR rl) );

APTR			ICreateMenu		__PARMS( (APTR ri, struct Window  *win, struct MenuData  *md, struct TextAttr  *ta, BYTE **language_text_array) );
VOID			IAttachMenu		__PARMS( (struct Window  *win, APTR ml) );
struct MenuItem 	*IMenuItemAddress	__PARMS( (APTR ml, USHORT menu_num) );
struct Window   	*IRemoveMenu		__PARMS( (APTR ml) );
VOID			IFreeMenu		__PARMS( (APTR ml) );

struct FileData  	*IOpenTextFile		__PARMS( (BYTE *name, USHORT read_buffer_size, USHORT line_buffer_size, USHORT flags) );
SHORT			IReadTextLine		__PARMS( (struct FileData  *fd) );
VOID			ICloseTextFile		__PARMS( (struct FileData  *fd) );

BYTE			**IBuildLanguageTextArray	__PARMS( (BYTE *name, USHORT entries) );
BYTE			*IGetLanguageText	__PARMS( (BYTE *text, BYTE **text_array) );
VOID			IFreeLanguageTextArray	__PARMS( (BYTE **text_array) );

VOID			IChangeMousePointer	__PARMS( (struct Window  *win, struct PointerData  *pd, BOOL remove_gadgets) );
VOID			IRestoreMousePointer	__PARMS( (struct Window  *win) );
VOID			IMoveMousePointer	__PARMS( (struct Window  *win, SHORT x, SHORT y, BOOL button) );

	/* Pragmas */

#ifndef	__NO_PRAGMAS
#ifdef	AZTEC_C
#pragma amicall(IntuiSupBase, 0x1e, IGetRenderInfo(a0,d0))
#pragma amicall(IntuiSupBase, 0x24, IFreeRenderInfo(a0))
#pragma amicall(IntuiSupBase, 0x2a, IOpenWindow(a0,a1,d0))
#pragma amicall(IntuiSupBase, 0x30, IClearWindow(a0,a1,d0,d1,d2,d3,d4))
#pragma amicall(IntuiSupBase, 0x36, ICloseWindow(a0,d0))
#pragma amicall(IntuiSupBase, 0x3c, IAvailFonts(a0))
#pragma amicall(IntuiSupBase, 0x42, IAskFont(a0,a1))
#pragma amicall(IntuiSupBase, 0x48, IOpenFont(a0,a1))
#pragma amicall(IntuiSupBase, 0x4e, IDisplayTexts(a0,a1,a2,d0,d1,a3))
#pragma amicall(IntuiSupBase, 0x54, IPrintText(a0,a1,a2,d0,d1,d2,d3,a3))
#pragma amicall(IntuiSupBase, 0x5a, IConvertUnsignedDec(d0,a0,d1))
#pragma amicall(IntuiSupBase, 0x60, IConvertSignedDec(d0,a0,d1))
#pragma amicall(IntuiSupBase, 0x66, IConvertHex(d0,a0,d1))
#pragma amicall(IntuiSupBase, 0x6c, IConvertBin(d0,a0,d1))
#pragma amicall(IntuiSupBase, 0x72, IDisplayBorders(a0,a1,a2,d0,d1))
#pragma amicall(IntuiSupBase, 0x78, IDrawBorder(a0,a1,d0,d1,d2,d3,d4))
#pragma amicall(IntuiSupBase, 0x7e, ICreateGadgets(a0,a1,d0,d1,a2))
#pragma amicall(IntuiSupBase, 0x84, IFreeGadgets(a0))
#pragma amicall(IntuiSupBase, 0x8a, IDisplayGadgets(a0,a1))
#pragma amicall(IntuiSupBase, 0x90, IRefreshGadgets(a0))
#pragma amicall(IntuiSupBase, 0x96, IModifyGadget(a0,d0,d1,d2,d3,d4))
#pragma amicall(IntuiSupBase, 0x9c, ISetGadgetAttributes(a0,d0,d1,d2,d3,d4,a1))
#pragma amicall(IntuiSupBase, 0xa2, IActivateInputGadget(a0,d0))
#pragma amicall(IntuiSupBase, 0xa8, IGadgetAddress(a0,d0))
#pragma amicall(IntuiSupBase, 0xae, IRemoveGadgets(a0))
#pragma amicall(IntuiSupBase, 0xb4, IGetMsg(a0))
#pragma amicall(IntuiSupBase, 0xba, IReplyMsg(a0))
#pragma amicall(IntuiSupBase, 0xc0, IAutoRequest(a0,a1,a2,a3,d0,d1,d2,d3,d4))
#pragma amicall(IntuiSupBase, 0xc6, IDisplayRequester(a0,a1,a2))
#pragma amicall(IntuiSupBase, 0xcc, IRemoveRequester(a0))
#pragma amicall(IntuiSupBase, 0xd2, ICreateMenu(a0,a1,a2,a3,d0))
#pragma amicall(IntuiSupBase, 0xd8, IAttachMenu(a0,a1))
#pragma amicall(IntuiSupBase, 0xde, IMenuItemAddress(a0,d0))
#pragma amicall(IntuiSupBase, 0xe4, IRemoveMenu(a0))
#pragma amicall(IntuiSupBase, 0xea, IFreeMenu(a0))
#pragma amicall(IntuiSupBase, 0xf0, IOpenTextFile(a0,d0,d1,d2))
#pragma amicall(IntuiSupBase, 0xf6, IReadTextLine(a0))
#pragma amicall(IntuiSupBase, 0xfc, ICloseTextFile(a0))
#pragma amicall(IntuiSupBase, 0x102, IBuildLanguageTextArray(a0,d0))
#pragma amicall(IntuiSupBase, 0x108, IGetLanguageText(a0,a1))
#pragma amicall(IntuiSupBase, 0x10e, IFreeLanguageTextArray(a0))
#pragma amicall(IntuiSupBase, 0x114, IChangeMousePointer(a0,a1,d0))
#pragma amicall(IntuiSupBase, 0x11a, IRestoreMousePointer(a0))
#pragma amicall(IntuiSupBase, 0x120, IMoveMousePointer(a0,d0,d1,d2))
#pragma amicall(IntuiSupBase, 0x126, IConvertRawKeyToASCII(a0))
#else	/* AZTEC_C */
#ifdef	LATTICE
#pragma libcall IntuiSupBase IGetRenderInfo 1e 802
#pragma libcall IntuiSupBase IFreeRenderInfo 24 801
#pragma libcall IntuiSupBase IOpenWindow 2a 9803
#pragma libcall IntuiSupBase IClearWindow 30 432109807
#pragma libcall IntuiSupBase ICloseWindow 36 802
#pragma libcall IntuiSupBase IAvailFonts 3c 801
#pragma libcall IntuiSupBase IAskFont 42 9802
#pragma libcall IntuiSupBase IOpenFont 48 9802
#pragma libcall IntuiSupBase IDisplayTexts 4e b10a9806
#pragma libcall IntuiSupBase IPrintText 54 b3210a9808
#pragma libcall IntuiSupBase IConvertUnsignedDec 5a 18003
#pragma libcall IntuiSupBase IConvertSignedDec 60 18003
#pragma libcall IntuiSupBase IConvertHex 66 18003
#pragma libcall IntuiSupBase IConvertBin 6c 18003
#pragma libcall IntuiSupBase IDisplayBorders 72 10a9805
#pragma libcall IntuiSupBase IDrawBorder 78 432109807
#pragma libcall IntuiSupBase ICreateGadgets 7e a109805
#pragma libcall IntuiSupBase IFreeGadgets 84 801
#pragma libcall IntuiSupBase IDisplayGadgets 8a 9802
#pragma libcall IntuiSupBase IRefreshGadgets 90 801
#pragma libcall IntuiSupBase IModifyGadget 96 43210806
#pragma libcall IntuiSupBase ISetGadgetAttributes 9c 943210807
#pragma libcall IntuiSupBase IActivateInputGadget a2 802
#pragma libcall IntuiSupBase IGadgetAddress a8 802
#pragma libcall IntuiSupBase IRemoveGadgets ae 801
#pragma libcall IntuiSupBase IGetMsg b4 801
#pragma libcall IntuiSupBase IReplyMsg ba 801
#pragma libcall IntuiSupBase IAutoRequest c0 43210ba9809
#pragma libcall IntuiSupBase IDisplayRequester c6 a9803
#pragma libcall IntuiSupBase IRemoveRequester cc 801
#pragma libcall IntuiSupBase ICreateMenu d2 ba9805
#pragma libcall IntuiSupBase IAttachMenu d8 9802
#pragma libcall IntuiSupBase IMenuItemAddress de 802
#pragma libcall IntuiSupBase IRemoveMenu e4 801
#pragma libcall IntuiSupBase IFreeMenu ea 801
#pragma libcall IntuiSupBase IOpenTextFile f0 210804
#pragma libcall IntuiSupBase IReadTextLine f6 801
#pragma libcall IntuiSupBase ICloseTextFile fc 801
#pragma libcall IntuiSupBase IBuildLanguageTextArray 102 802
#pragma libcall IntuiSupBase IGetLanguageText 108 9802
#pragma libcall IntuiSupBase IFreeLanguageTextArray 10e 801
#pragma libcall IntuiSupBase IChangeMousePointer 114 9803
#pragma libcall IntuiSupBase IRestoreMousePointer 11a 801
#pragma libcall IntuiSupBase IMoveMousePointer 120 210804
#pragma libcall IntuiSupBase IConvertRawKeyToASCII 126 801
#endif	/* LATTICE */
#endif	/* AZTEC_C */
#endif	/* __NO_PRAGMAS */

#endif	/* LIBRARIES_INTUISUP_H */
