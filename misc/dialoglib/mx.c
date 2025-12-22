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

static LONG countChoices( DialogElement *de )
{
	LONG count = 0;
	STRPTR *label;

	if( !de )
		return 0;

	if( label = (STRPTR *)GetTagData( GTMX_Labels, 0, de->taglist ) )
		while( *label++ )
			count++;
	return count;
}

static VOID setupMX( DialogElement *de )
{
	struct TextAttr *ta;
	struct TextFont *tf;
	struct RastPort rp;
	struct TextExtent te;
	STRPTR *label;
	LONG side1, side2, left, right, height, spacing;
	ULONG place;
	LONG *storage;

	if( !de )
		return;

	de->idcmp_mask |= MXIDCMP | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY;

	storage = (LONG *)GetTagData( DA_Storage, 0, de->taglist );
	if( storage )
		*storage = GetTagData( GTMX_Active, 0, de->taglist );

	ta = (struct TextAttr *)GetTagData( NGDA_TextAttr, 0, de->taglist );
	if( !ta )
		return;
	tf = OpenDiskFont( ta );
	if( !tf )
		return;
	InitRastPort( &rp );
	SetFont( &rp, tf );

	spacing = GetTagData( GTMX_Spacing, 1, de->taglist );
	side1 = height = 0;
	if( label = (STRPTR *)GetTagData( GTMX_Labels, 0, de->taglist ) )
		while( *label )
		{
			LONG width;

			TextExtent( &rp, *label, strlen( *label ), &te );
			width = te.te_Extent.MaxX + 1 - te.te_Extent.MinX;
			if( width > side1 )
				side1 = width;
			height += te.te_Extent.MaxY + 1 - te.te_Extent.MinY + spacing;
			label++;
		}
	side1 += INTERWIDTH;	/* INTERWIDTH is the distance between text and radio button */
	side2 = 17;				/* 17 is the width of the radio button */

	CloseFont( tf );

	place = getTextPlacement( GetTagData( NGDA_Flags, 0, de->taglist ), PLACETEXT_LEFT );
	switch( place )
	{
	case PLACETEXT_LEFT:
		left = side1;
		right = side2;
		break;
	case PLACETEXT_RIGHT:
		left = side2;
		right = side1;
		break;
	}
	setMinLeftExtent( de, left );
	setMaxLeftExtent( de, left );
	setMinRightExtent( de, right );
	setMaxRightExtent( de, right );
	setMinHeight( de, height );
	setMaxHeight( de, height );
}

static ULONG layoutMX( DialogElement *de, LayoutMessage *lm )
{
	struct NewGadget ng;
	ULONG error = DIALOGERR_OK;

	if( !de )
		return DIALOGERR_BAD_ARGS;
	if( !lm )
		return DIALOGERR_BAD_ARGS;

#ifdef DEBUG1
	printf(
	"layoutMX : x %d, y %d, width %d, height %d, left %d, right %d, top %d, bottom %d\n",
		lm->lm_X, lm->lm_Y, lm->lm_Width, lm->lm_Height,
		lm->lm_Left, lm->lm_Right, lm->lm_Top, lm->lm_Bottom );
#endif
	ng.ng_GadgetText = (UBYTE *)GetTagData( NGDA_GadgetText, 0, de->taglist );
	ng.ng_TextAttr = (struct TextAttr *)GetTagData( NGDA_TextAttr, 0, de->taglist );
	ng.ng_VisualInfo = (APTR)GetTagData( NGDA_VisualInfo, 0, de->taglist );
	ng.ng_Flags = GetTagData( NGDA_Flags, 0, de->taglist );
	ng.ng_LeftEdge = lm->lm_X;
	ng.ng_TopEdge = lm->lm_Y;
	switch( getTextPlacement( ng.ng_Flags, PLACETEXT_LEFT ) )
	{
	case PLACETEXT_RIGHT:
		ng.ng_LeftEdge -= lm->lm_Left;
		break;
	}
	de->object = CreateGadgetA( MX_KIND, *lm->lm_PreviousPtr, &ng, de->taglist );
	*lm->lm_PreviousPtr = de->object;	/* advance "previous" pointer to new object */
	if( !de->object )
		error = DIALOGERR_NO_MEMORY;
	return error;
}

static DialogElement *matchMX( DialogElement *de, MatchMessage *mm )
{
	struct IntuiMessage *imsg;
	struct TagItem *tag;
	DialogElement *match = NULL;
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
				*storage = (ULONG)imsg->Code;
			match = de;
		}
		break;
	case IDCMP_VANILLAKEY:
		if( storage )
			if( tag = FindTagItem( DA_EquivalentKey, de->taglist ) )
				if( imsg->Code == tolower( tag->ti_Data ) )
				{
					if( *storage < countChoices( de ) - 1 )
						(*storage)++;
					else
						*storage = 0;
					GT_SetGadgetAttrs( de->object, imsg->IDCMPWindow, NULL,
						GTMX_Active, *storage,
						TAG_DONE );
					match = de;
				}
				else if( imsg->Code == toupper( tag->ti_Data ) )
				{
					if( *storage > 0 )
						(*storage)--;
					else
						*storage = countChoices( de ) - 1;
					GT_SetGadgetAttrs( de->object, imsg->IDCMPWindow, NULL,
						GTMX_Active, *storage,
						TAG_DONE );
					match = de;
				}
		break;
	}
	return match;
}

ULONG dispatchMX( struct Hook *hook, DialogElement *de, DialogMessage *dm )
{
	ULONG result;

	switch( dm->dm_MethodID )
	{
	case DIALOGM_GETSTRUCT:
		result = DESF_VBaseline;
		break;
	case DIALOGM_SETUP:
		setupMX( de );
		break;
	case DIALOGM_LAYOUT:
		result = layoutMX( de, (LayoutMessage *)dm );
		break;
	case DIALOGM_MATCH:
		result = (ULONG)matchMX( de, (MatchMessage *)dm );
		break;
	case DIALOGM_CLEAR:
		break;
	case DIALOGM_SETATTRS:
		setGTAttrs( de, (SetAttrsMessage *)dm );
		break;
	}
	return result;
}
