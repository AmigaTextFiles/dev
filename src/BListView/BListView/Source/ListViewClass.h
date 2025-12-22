#ifndef LISTVIEWCLASS_H
#define LISTVIEWCLASS_H
/*
**	ListViewClass.h
**
**	Copyright (C) 1996,97 by Bernardo Innocenti
**
**	ListView class built on top of the "gadgetclass".
**
*/

#define LISTVIEWCLASS	"listviewclass"
#define LISTVIEWVERS	1


Class	*MakeListViewClass (void);
void	 FreeListViewClass (Class *ListViewClass);



/*****************/
/* Class Methods */
/*****************/

/* This class does not define any new methods */



/********************/
/* Class Attributes */
/********************/

#define LVA_Dummy			(TAG_USER | ('L'<<16) | ('V'<<8))

#define LVA_Selected		(LVA_Dummy+1)
	/* (IGSNU) LONG - Selected item number. ~0 (-1) indicates that no
	 * item is selected. 
	 */

#define LVA_Top				(LVA_Dummy+2)
	/* (IGSNU) LONG - Number of top displayed item. Default is 0.
	 */

#define LVA_Total			(LVA_Dummy+3)
	/* (IGSN) LONG - Total number of items in list.
	 * This attribute can be set when LVA_StringArray, LVA_ImageArray
	 * or LVA_CustomList is used. If you pass -1 or omit this tag,
	 * the ListView class will count the items in the array until it
	 * finds a NULL entry. If you know the number of nodes in your list,
	 * you will save some internal overhead by telling it to the
	 * ListView with the LVA_Total tag, expecially when using the
	 * LVA_StringList and LVA_ImageList modes. You must set LVA_Total
	 * each time you provide a new list or array, and in the same
	 * OM_SET call. 
	 * Be careful: no checks are made on the values you are passing!
	 */

#define LVA_SelectItem		(LVA_Dummy+4)
	/* (SN) LONG - Add item specified by ti_Data to the
	 * selection list.
	 */

#define LVA_DeselectItem	(LVA_Dummy+5)
	/* (SN) LONG - Remove item specified by ti_Data from the
	 * selection list.
	 */

#define LVA_ToggleItem		(LVA_Dummy+6)
	/* (SN) LONG - Toggle item selection.
	 */

#define LVA_ClearSelected	(LVA_Dummy+7)
	/* (SN) LONG - Remove the selected state to AALL items.
	 */


#define LVA_MakeVisible		(LVA_Dummy+8)
	/* (ISU) Make this item visible by doing the minimum required scrolling.
	 */

#define LVA_MoveUp			(LVA_Dummy+9)
#define LVA_MoveDown		(LVA_Dummy+10)
#define LVA_MoveLeft		(LVA_Dummy+11)
#define LVA_MoveRight		(LVA_Dummy+12)
	/* (SU) Scroll the display up/down. left/right movement is not
	 * yet supported.
	 */

#define LVA_StringList		(LVA_Dummy+13)
#define LVA_StringArray		(LVA_Dummy+14)
#define LVA_ImageList		(LVA_Dummy+15)
#define LVA_ImageArray		(LVA_Dummy+16)
#define LVA_CustomList		(LVA_Dummy+17)
#define LVA_Labels			LVA_StringList
	/* (ISG) List of items to display. All structures and strings
	 * are referenced, not copied, so they must stay in memory
	 * while the ListView gadget displays them.
	 *
	 * LVA_StringList (AKA LVA_Labels) passes a pointer to a
	 * List (or MinList) of Node structures. The strings
	 * pointed by ln_Name will be displayed as item labels.
	 *
	 * LVA_StringArray specifies a pointer to an array of STRPTR which
	 * will be used as item labels.  The array must be NULL terminated
	 * unless the LVA_Count is set.
	 *
	 * LVA_ImageList passes a pointer to a List (or MinList)
	 * of Node structures. The ln_Name field of each Node structure
	 * must point to a normal Image structure or to an instance of
	 * the imageclass (or a subclass of it).
	 *
	 * LVA_ImageArray specifies a pointer to an array of pointers to
	 * Image structures or imageclass objects.  The array must be NULL
	 * terminated unless the LVA_Count attribute is used.
	 *
	 * LVA_CustomList can be used to provide a data structure which
	 * is neither a list nor an array.  Custom user functions will
	 * be called to retrieve the items. The data passed with this
	 * tag will be passed to the user functions.
	 *
	 * Setting one of these attributes to NULL causes the contents
	 * of the ListView gadget to be cleared.
	 *
	 * Setting one of these attributes to ~0 (-1) detaches the
	 * items from the ListView.  You must detach your list before
	 * adding or removing items.  This isn't required when using
	 * array oriented item lists.
	 */

#define LVA_Visible			(LVA_Dummy+18)
	/* (IGN) ULONG - Number of visible items. When this attribute is
	 * passed on intialization, the ListView gadget will resize
	 * itself to make the desired number of lines visible. this
	 * feature is incompatible with GA_RelHeight. LVA_Visible at
	 * creation time requires a valid DrawInfo passed with the
	 * GA_DrawInfo tag.
	 */

#define LVA_SelectedPtr		(LVA_Dummy+19)
	/* (GN) Selected item pointer. Will be NULL when no items are selected.
	 */

#define LVA_SelectArray		(LVA_Dummy+20)
	/* (ISGNU) ULONG * - This array of ULONGs is only used in
	 * LVA_#?Array modes, when multiple selection is active. It will
	 * hold the selection status of all items in the list. Each
	 * element will be 0 if the related item is unselected, and
	 * it will indicate the selection order when the item is
	 * selected.
	 */

#define LVA_CallBack		(LVA_Dummy+21)
	/* (I) struct Hook * - Callback hook for various listview operations.
	 * The call back hook is called with:
     *		A0 - struct Hook *
     *		A1 - struct LVDrawMsg *
     *		A2 - struct Node *
     * The callback hook *must* check the lvdm_MethodID field of the
     * message and only do processing if it is known. If any other
     * value is passed, the callback hook must return LVCB_UNKNOWN.
	 */

#define LVA_ShowSelected	(LVA_Dummy+23)
	/* (I) BOOL - Enable highlighting selected items (default is TRUE).
	 * Note that this is different from the GadTools ListView default,
	 * which is not displaying the selected item.
	 */

#define LVA_Clipped			(LVA_Dummy+24)
	/* (I) BOOL - When this attribute is set, the ListView gadget Installs
	 * a ClipRegion in its Layer whenever it redraws its items.
	 * (defaults is FALSE).
	 */

#define LVA_DoMultiSelect	(LVA_Dummy+25)
	/* (I) BOOL - Allows picking multiple items from the list
	 * (default is FALSE).
	 * When MultiSelect mode is active and a List structure is used,
	 * the ListView gadget keeps track of which items are selected
	 * by setting/clearing the ln_Type field of the Node structure.
	 * When items are passed with an array, you must also provide
	 * a second array for storing selection information (LVA_SelectArray).
	 * When item number n is selected, then the n-th BOOL of this array
	 * is set with its selection order.
	 */

#define LVA_ItemHeight		(LVA_Dummy+27)
	/* (I) ULONG - Exact height of an item. Defaults to be the Y size
	 * of the font used to draw the text labels. The listview will ask
	 * the height to its Image items if not explicitly given.
	 */

#define LVA_MaxPen			(LVA_Dummy+28)
	/* (I) LONG - The maximum pen number used by rendering in a custom
	 * rendering callback hook. This is used to optimize the
	 * rendering and scrolling of the listview display (default is
	 * the maximum pen number used by all of TEXTPEN, BACKGROUNDPEN,
	 * FILLPEN, TEXTFILLPEN and BLOCKPEN).
	 */

#define LVA_TextFont		(LVA_Dummy+29)
	/* (I) struct TextFont * - Font to be used for rendering texts.
	 * Defaults to the default screen font.
	 */

#define LVA_DoubleClick		(LVA_Dummy+30)
	/* (N) ULONG - The item specified by ti_Data has been double clicked.
	 */

#define LVA_MaxSelect		(LVA_Dummy+31)
	/* (IS) ULONG - Maximum number of selected items to allow in multiselect
	 * mode. If you later set this tag with a more restrictive condition, the
	 * listview will NOT deselect any of the currently selected items to
	 * satisfy your request. Default is unlimited (~0).
	 */

#define LVA_PixelTop		(LVA_Dummy+32)
	/* (ISGNU) ULONG - Offset from top of list in pixel units. Useful for
	 * scrollers.
	 */

#define LVA_PixelHeight		(LVA_Dummy+33)
	/* (N) LONG - Total height of list in pixel units. Useful for scrollers.
	 */

#define LVA_PixelVVisible	(LVA_Dummy+34)
	/* (N) LONG - Number of vertical visible pixels. Useful for scrollers.
	 */

#define LVA_PixelLeft		(LVA_Dummy+35)
	/* (ISNU) LONG - Offset from left of list in pixel units. Useful for scrollers.
	 */

#define LVA_PixelWidth		(LVA_Dummy+36)
	/* (ISNG) LONG - Total width of list in pixel units. Useful for scrollers.
	 */

#define LVA_PixelHVisible	(LVA_Dummy+37)
	/* (N) Number of horizontal visible pixels. Useful for scrollers.
	 */

#define LVA_Title			(LVA_Dummy+38)
	/* (IS) Listview title item.  This item will be drawn on the top line of
	 * the list and will not scroll.  ti_Data points to an item in the same
	 * format of the items list (e.g.: If it is LVA_StringArray, then it will
	 * be a Node * with ln_Name pointing to a text string. The item will be
	 * passed to the custom item drawing hook. (TODO)
	 */

#define LVA_Columns			(LVA_Dummy+39)
	/* (I) (LONG) Number of columns to be displayed. Default is 1. If set
	 * to ~0, the listview will precheck all items to calculate this number
	 * automatically. (TODO)
	 */

#define LVA_ColumnSpacing	(LVA_Dummy+40)
	/* (I) ULONG - Spacing between columns in pixel units.
	 * Default is 4 pixels. (TODO)
	 */

#define LVA_ColumnWidths	(LVA_Dummy+41)
	/* (IGS) ULONG * - Points to an array of ULONGs containing the width of
	 * each column expressed in pixel units.  A value of -1 causes the
	 * ListView to automatically calculate the width of the column, by
	 * asking the width to all items. (TODO)
	 */

#define LVA_ColumnSeparator	(LVA_Dummy+42)
	/* (I) UBYTE - When the listview is in multicolumn mode, the
	 * internal text label routines will scan the string for this
	 * character, as a separator for the column labels. This defaults
	 * to '\t', so a label for a three column list view would look
	 * like this: "One\tTwo\tThree". (TODO)
	 */

#define LVA_ResizeColumns	(LVA_Dummy+43)
	/* (IS) BOOL - Allows the user to resize the columns by dragging
	 * on the listview title line. (TODO)
	 */

#define LVA_SelectTick		(LVA_Dummy+44)
	/* (I) When user selects an item, show a checkmark on the left
	 * instead of rendering the item in selected state. (TODO)
	 */

#define LVA_ScrollInertia	(LVA_Dummy+45)
	/* (IS) ULONG - Sets the scrolling inertia of the listview.
	 * Defaults to 4 for LVA_Clipped mode, 0 for a non-clipped listview.
	 * (TODO)
	 */

#define LVA_ScrollRatio		(LVA_Dummy+46)
	/* (IS) ULONG - If you ask the listview to scroll more than
	 * LVA_Visible / LVA_ScrollRatio lines, all the listview contents
	 * will be redrawn instead.  The minimum value of 1 will trigger a
	 * full redraw only when ALL the listview visible part is scrolled away.
	 * The default value is 2, which is a good compromise for items which
	 * can redraw themselves relatively quickly, such as simple text
	 * labels or bitmap images.
	 */

/* Public flags */
#define LVB_READONLY		0	/* Do not allow item selection				*/
#define LVB_CLIPPED			1	/* Clip item drawing inside their boxes		*/
#define LVB_SHOWSELECTED	2	/* Hilights the selected item				*/
#define LVB_DOMULTISELECT	3	/* Allows user to pick more than one item	*/
#define LVB_SMOOTHSCROLLING	4	/* Scoll pixel by pixel						*/
#define LVB_RESIZECOLUMNS	5	/* Allow user to resize the columns			*/

/* Internal flags - DO NOT USE */
#define LVB_CLOSEFONT		27	/* Close the font when disposing the object	*/
#define LVB_LIST			28	/* Using an exec List						*/
#define LVB_DONTDRAW		29	/* Do not perform any drawing operations	*/
#define LVB_SCROLLING		30	/* User scrolling with middle mouse button	*/
#define LVB_DRAGGING		31	/* User dragging selection with LMB			*/


#define LVF_READONLY		(1<<LVB_READONLY)
#define LVF_CLIPPED			(1<<LVB_CLIPPED)
#define LVF_SHOWSELECTED	(1<<LVB_SHOWSELECTED)
#define LVF_DOMULTISELECT	(1<<LVB_DOMULTISELECT)
#define LVF_SMOOTHSCROLLING	(1<<LVB_SMOOTHSCROLLING)
#define LVF_RESIZECOLUMNS	(1<<LVB_RESIZECOLUMNS)

#define LVF_CLOSEFONT		(1<<LVB_CLOSEFONT)
#define LVF_LIST			(1<<LVB_LIST)
#define LVF_DONTDRAW		(1<<LVB_DONTDRAW)
#define LVF_SCROLLING		(1<<LVB_SCROLLING)
#define LVF_DRAGGING		(1<<LVB_DRAGGING)



/* Changed attributes:
 *
 * GA_ToggleSelect
 *	(I) BOOL - When TRUE, the listview gadget will allow deselecting items
 *	by clicking on them.
 *
 * GA_SelectRender
 *	(I) struct Image * - Specifies an imageclass object to be used as
 *	cursor/selection.  The image will be drawn in IDS_SELECTED state
 *	for the selected item and IDS_NORMAL for all all other highlighted
 *	items.
 *
 * GA_Immediate
 *	(I) BOOL - Sends interim notifications when the selected item changes.
 *
 * GA_TextAttr
 *	(I) struct TextAttr * - Font to be used for rendering texts.
 *	Defaults to the default screen font. See also LVA_TextFont.
 *
 * GA_ReadOnly
 *	(I) BOOL - Prevent selection of items (default is FALSE).
 *
 * LAYOUTA_Spacing
 *	(I) UWORD - Extra space to place between lines of listview
 *	(defaults to 0).
 *
 */



/* Do not define these if <libraries/gadtools.h> will be included too */

#ifdef LV_GADTOOLS_STUFF

/* The different types of messages that a listview callback hook can see */
#define LV_DRAW		0x202L		/* draw yourself, with state	*/

/* Possible return values from a callback hook */
#define LVCB_OK			0		/* callback understands this message type		*/
#define LVCB_UNKNOWN	1		/* callback does not understand this message	*/

/* states for LVDrawMsg.lvdm_State */
#define LVR_NORMAL				0	/* the usual				*/
#define LVR_SELECTED			1	/* for selected gadgets		*/
#define LVR_NORMALDISABLED		2	/* for disabled gadgets		*/
#define LVR_SELECTEDDISABLED	8	/* disabled and selected	*/

#endif /* LV_GADTOOLS_STUFF */

#define LVR_TITLE				16	/* ListView title item		*/


/* More callback hook methods */

#define LV_GETNEXT		0x203L	/* gimme next item in list		*/
#define LV_GETPREV		0x204L	/* gimme previous item in list	*/
#define LV_GETITEM		0x205L	/* gimme item handle by number	*/

/* These two methods can be used to optimize listview rendering
 * operations.  You can safely assume that the rastport attributes
 * you set inside LV_DRAWBEGIN will remain unchanged for all
 * subsequent calls to LV_DRAW, until an LV_DRAWEND is issued.
 * They do also provide a way to lock/unlock the list of items
 * if the access to its item needs to be arbitrated by a semaphore.
 */
#define LV_DRAWBEGIN	0x206L	/* prepare to draw items		*/
#define LV_DRAWEND		0x207L	/* items drawing completed		*/



/* More messages */

struct lvDrawItem
{
	ULONG				lvdi_MethodID;	/* LV_DRAW						*/
	ULONG				lvdi_Current;	/* Current item number			*/
	APTR				lvdi_Items;		/* Pointer to List, array, etc.	*/
	struct RastPort		*lvdi_RastPort;	/* where to render to			*/
	struct DrawInfo		*lvdi_DrawInfo;	/* useful to have around		*/
	struct Rectangle	lvdi_Bounds;	/* limits of where to render	*/
	ULONG				lvdi_State;		/* how to render				*/
	ULONG				lvdi_Flags;		/* Current LVF_#? flags			*/
};

struct lvGetItem
{
	ULONG	lvgi_MethodID;	/* LV_GETITEM					*/
	ULONG	lvgi_Number;	/* Number of item to get		*/
	APTR	lvgi_Items;		/* Pointer to List, array, etc.	*/
};

#define lvGetNext	lvGetItem
#define lvGetPrev	lvGetItem
#define lvDrawBegin	lvGetItem	/* lvgi_Number has no useful meaning	*/
#define lvDrawEnd	lvGetItem	/* lvgi_Number has no useful meaning	*/

#endif /* !LISTVIEWCLASS_H */
