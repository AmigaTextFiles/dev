#ifndef GADGETS_LISTVIEW_H
#define GADGETS_LISTVIEW_H
/*
**	$VER: listview.h 37.0 (13.2.96)
**
**	Definitions for the listview BOOPSI class
**
**	(C) Copyright 1997 Tomasz Muszynski.
**	All Rights Reserved
*/

/*****************************************************************************/


#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif


/*****************************************************************************/

#define LISTVIEWNAME "gadgets/listview.gadget"
#define LISTVIEWVERSION 37

/* ListView structures - compatible with system lists & nodes */
struct LVList
{
	struct LVNode *lh_Head;
	struct LVNode *lh_Tail;
	struct LVNode *lh_TailPred;
};

struct LVNode
{
	struct LVNode *ln_Succ;		// Link list (left leaf)
	struct LVNode *ln_Pred;		// Link list (prev node/parent)
	UWORD ln_Flags;						// See below
	STRPTR ln_Name;						// PTR node name
	struct LVNode *ln_Sub;		// Sub list (right leaf) - for tree list view
	struct LVNode *ln_Parent;	// Parent Node
	UBYTE ln_Indent;					// Sub Node Indent
}; /* Note: Word aligned */

/* defines for tree compatibility */
#define ln_Left ln_Succ
#define ln_Right ln_Sub

#define Tree_IsListEmpty(x) \
	( ((x)->lh_TailPred) == (struct LVNode *)(x) )

/* ln_Flags */
#define LV_SELECT (1<<0)	// Node is selected
#define LV_OPEN	(1<<1)		// Node is opened

/* tags */
#define LIST_Dummy		(TAG_USER+0x00001000)
#define LIST_Top	(LIST_Dummy+1)
#define LIST_MakeVisible (LIST_Dummy+2)
#define LIST_Labels (LIST_Dummy+3)
#define LIST_ReadOnly (LIST_Dummy+4)
#define LIST_Border (LIST_Dummy+5)
#define LIST_Selected (LIST_Dummy+6)
#define LIST_Columns (LIST_Dummy+7)
#define LIST_MultiSelect (LIST_Dummy+8)
#define LIST_TextFont (LIST_Dummy+9)
#define LIST_ShowTreeLines (LIST_Dummy+10)
#define LIST_TabChar (LIST_Dummy+11)
#define LIST_Format (LIST_Dummy+12)
#define LIST_ShowSelected (LIST_Dummy+13)
#define LIST_Visible (LIST_Dummy+14)
#define LIST_Total (LIST_Dummy+15)
#define LIST_IsTree (LIST_Dummy+16)

/*****************************************************************************/

#endif /* GADGETS_LISTVIEW_H */
