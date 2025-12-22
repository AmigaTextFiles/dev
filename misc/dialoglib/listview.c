#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>
#include <graphics/text.h>
#include <proto/diskfont.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <ctype.h>
#include <string.h>
#include "dialog.h"
#ifdef DEBUG1
	#include <stdio.h>
#endif

static LONG countItems( DialogElement *de )
{
	struct List *list;
	struct Node *node;
	ULONG labels;
	LONG count = 0;

	if( !de )
		return 0;

	labels = GetTagData( GTLV_Labels, 0, de->taglist );
	if( labels == 0 || labels == ~0 )
		goto termination;

	list = (struct List *)labels;
	for( node = list->lh_Head; node->ln_Succ; node = node->ln_Succ )
		count++;
termination:
	return count;
}

static ULONG getListViewStructure( DialogElement *de )
{
	ULONG place, structure = 0;

	if( !de )
		return 0;

	if( GetTagData( NGDA_GadgetText, 0, de->taglist ) )
	{
		place = getTextPlacement( GetTagData( NGDA_Flags, 0, de->taglist ), PLACETEXT_ABOVE );
		switch( place )
		{
		case PLACETEXT_ABOVE:
		case PLACETEXT_BELOW:
			structure = DESF_HBaseline;
			break;
		case PLACETEXT_LEFT:
		case PLACETEXT_RIGHT:
			structure = DESF_VBaseline;
			break;
		}
	}
	return structure;
}

static VOID setupListView( DialogElement *de )
{
	struct TextAttr *ta;
	struct TextFont *tf;
	struct RastPort rp;
	struct TextExtent te;
	STRPTR text;
	LONG scrollwidth, minwidth, minheight, textwidth, textheight;
	ULONG place;
	LONG *storage;

	if( !de )
		return;

	de->idcmp_mask |= LISTVIEWIDCMP | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY;

	storage = (LONG *)GetTagData( DA_Storage, 0, de->taglist );
	if( storage )
		*storage = GetTagData( GTLV_Selected, ~0, de->taglist );

	scrollwidth = GetTagData( GTLV_ScrollWidth, 16, de->taglist );

	ta = (struct TextAttr *)GetTagData( NGDA_TextAttr, 0, de->taglist );
	if( !ta )
		return;
	tf = OpenDiskFont( ta );
	if( !tf )
		return;

	/* minimal dimensions: 3 visible items, 3 visible label characters */
	/* note: the constants "4" and "2" are the thicknesses of the frame */
	minwidth = 4 + 3 * tf->tf_XSize + 4 + scrollwidth;
	minheight = 2 + 3 * tf->tf_YSize + GetTagData( LAYOUTA_Spacing, 0, de->taglist ) + 2;
	if( (struct Gadget *)GetTagData( GTLV_ShowSelected, ~0, de->taglist ) == NULL )
		minheight += 2 + tf->tf_YSize + 2;

	text = (STRPTR)GetTagData( NGDA_GadgetText, 0, de->taglist );
	place = getTextPlacement( GetTagData( NGDA_Flags, 0, de->taglist ), PLACETEXT_ABOVE );

	if( text )
	{
		InitRastPort( &rp );
		SetFont( &rp, tf );
		TextExtent( &rp, text, strlen( text ), &te );
	}
	else
	{
		te.te_Extent.MinX = te.te_Extent.MinY = 0;
		te.te_Extent.MaxX = te.te_Extent.MaxY = -1;
	}

	CloseFont( tf );

	textwidth = te.te_Extent.MaxX + 1 - te.te_Extent.MinX;
	textheight = te.te_Extent.MaxY + 1 - te.te_Extent.MinY;

	switch( place )
	{
	case PLACETEXT_ABOVE:
		if( minwidth < textwidth )
			minwidth = textwidth;
		setMinWidth( de, minwidth );
		setMaxWidth( de, MAX_SPACE );
		setMinTopExtent( de, textheight + INTERHEIGHT );
		setMaxTopExtent( de, textheight + INTERHEIGHT );
		setMinBottomExtent( de, minheight );
		setMaxBottomExtent( de, MAX_SPACE );
		break;
	case PLACETEXT_BELOW:
		if( minwidth < textwidth )
			minwidth = textwidth;
		setMinWidth( de, minwidth );
		setMaxWidth( de, MAX_SPACE );
		setMinTopExtent( de, minheight );
		setMaxTopExtent( de, MAX_SPACE );
		setMinBottomExtent( de, textheight + INTERHEIGHT );
		setMaxBottomExtent( de, textheight + INTERHEIGHT );
		break;
	case PLACETEXT_LEFT:
		if( minheight < textheight )
			minheight = textheight;
		setMinLeftExtent( de, textwidth + INTERWIDTH  );
		setMaxLeftExtent( de, textwidth + INTERWIDTH  );
		setMinRightExtent( de, minwidth );
		setMaxRightExtent( de, MAX_SPACE );
		setMinHeight( de, minheight );
		setMaxHeight( de, MAX_SPACE );
		break;
	case PLACETEXT_RIGHT:
		if( minheight < textheight )
			minheight = textheight;
		setMinLeftExtent( de, minwidth );
		setMaxLeftExtent( de, MAX_SPACE );
		setMinRightExtent( de, textwidth + INTERWIDTH );
		setMaxRightExtent( de, textwidth + INTERWIDTH );
		setMinHeight( de, minheight );
		setMaxHeight( de, MAX_SPACE );
		break;
	case PLACETEXT_IN:
		setMinWidth( de, minwidth );
		setMaxWidth( de, MAX_SPACE );
		setMinHeight( de, minheight );
		setMaxHeight( de, MAX_SPACE );
	}
}

static ULONG layoutListView( DialogElement *de, LayoutMessage *lm )
{
	struct NewGadget ng;
	ULONG place, error = DIALOGERR_OK;

	if( !de )
		return DIALOGERR_BAD_ARGS;
	if( !lm )
		return DIALOGERR_BAD_ARGS;

#ifdef DEBUG1
	printf(
	"layoutListView : x %d, y %d, width %d, height %d, left %d, right %d, top %d, bottom %d\n",
		lm->lm_X, lm->lm_Y, lm->lm_Width, lm->lm_Height,
		lm->lm_Left, lm->lm_Right, lm->lm_Top, lm->lm_Bottom );
#endif
	ng.ng_GadgetText = (UBYTE *)GetTagData( NGDA_GadgetText, 0, de->taglist );
	ng.ng_TextAttr = (struct TextAttr *)GetTagData( NGDA_TextAttr, 0, de->taglist );
	ng.ng_VisualInfo = (APTR)GetTagData( NGDA_VisualInfo, 0, de->taglist );
	ng.ng_Flags = GetTagData( NGDA_Flags, 0, de->taglist );
	ng.ng_LeftEdge = lm->lm_X;
	ng.ng_TopEdge = lm->lm_Y;
	place = getTextPlacement( ng.ng_Flags, PLACETEXT_ABOVE );
	switch( place )
	{
	case PLACETEXT_LEFT:
		ng.ng_Width = lm->lm_Right;
		ng.ng_Height = lm->lm_Height;
		break;
	case PLACETEXT_RIGHT:
		ng.ng_LeftEdge -= lm->lm_Left;
		ng.ng_Width = lm->lm_Left;
		ng.ng_Height = lm->lm_Height;
		break;
	case PLACETEXT_ABOVE:
		ng.ng_Width = lm->lm_Width;
		ng.ng_Height = lm->lm_Bottom;
		break;
	case PLACETEXT_BELOW:
		ng.ng_TopEdge -= lm->lm_Top;
		ng.ng_Width = lm->lm_Width;
		ng.ng_Height = lm->lm_Top;
		break;
	case PLACETEXT_IN:
		ng.ng_Width = lm->lm_Width;
		ng.ng_Height = lm->lm_Height;
		break;
	}
	de->object = CreateGadgetA( LISTVIEW_KIND, *lm->lm_PreviousPtr, &ng, de->taglist );
	*lm->lm_PreviousPtr = de->object;	/* advance "previous" pointer to new object */
	if( !de->object )
		error = DIALOGERR_NO_MEMORY;
	return error;
}

static DialogElement *matchListView( DialogElement *de, MatchMessage *mm )
{
	struct IntuiMessage *imsg;
	DialogElement *match = NULL;
	struct TagItem *tag;
	LONG *storage;

	if( !de )
		return NULL;
	if( !mm )
		return NULL;

	storage = (LONG *)GetTagData( DA_Storage, 0, de->taglist );

	imsg = mm->mm_IntuiMsg;
	switch( imsg->Class )
	{
	case IDCMP_GADGETUP:
		if( de->object == imsg->IAddress )
		{
			if( storage )
				*storage = (ULONG)imsg->Code;		/* store current level */
			match = de;
		}
		break;
	case IDCMP_VANILLAKEY:
		if( storage )
			if( tag = FindTagItem( DA_EquivalentKey, de->taglist ) )
				if( imsg->Code == tolower( tag->ti_Data ) )
				{
					if( *storage != ~0 )
						if( *storage < countItems( de ) - 1 )
							GT_SetGadgetAttrs( de->object, imsg->IDCMPWindow, NULL,
								GTLV_Selected, ++(*storage),
								TAG_DONE );
					match = de;
				}
				else if( imsg->Code == toupper( tag->ti_Data ) )
				{
					if( *storage != ~0 )
						if( *storage > 0 )
							GT_SetGadgetAttrs( de->object, imsg->IDCMPWindow, NULL,
								GTLV_Selected, --(*storage),
								TAG_DONE );
					match = de;
				}
		break;
	}
	return match;
}

ULONG dispatchListView( struct Hook *hook, DialogElement *de, DialogMessage *dm )
{
	ULONG result;

	switch( dm->dm_MethodID )
	{
	case DIALOGM_GETSTRUCT:
		result = getListViewStructure( de );
		break;
	case DIALOGM_SETUP:
		setupListView( de );
		break;
	case DIALOGM_LAYOUT:
		result = layoutListView( de, (LayoutMessage *)dm );
		break;
	case DIALOGM_MATCH:
		result = (ULONG)matchListView( de, (MatchMessage *)dm );
		break;
	case DIALOGM_CLEAR:
		break;
	case DIALOGM_SETATTRS:
		setGTAttrs( de, (SetAttrsMessage *)dm );
		break;
	}
	return result;
}
