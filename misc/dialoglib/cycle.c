#include <libraries/gadtools.h>
#include <graphics/text.h>
#include <proto/diskfont.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/utility.h>
#include <string.h>
#include <ctype.h>
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

	if( label = (STRPTR *)GetTagData( GTCY_Labels, 0, de->taglist ) )
		while( *label++ )
			count++;
	return count;
}

static ULONG getCycleStructure( DialogElement *de )
{
	ULONG place, structure = DESF_HBaseline;

	if( !de )
		return 0;

	if( GetTagData( NGDA_GadgetText, 0, de->taglist ) )
	{
		place = getTextPlacement( GetTagData( NGDA_Flags, 0, de->taglist ), PLACETEXT_LEFT );
		switch( place )
		{
		case PLACETEXT_LEFT:
		case PLACETEXT_RIGHT:
			structure |= DESF_VBaseline;
			break;
		}
	}
	return structure;
}

static VOID setupCycle( DialogElement *de )
{
	struct TextExtent te;
	struct RastPort rp;
	struct TextAttr *ta;
	struct TextFont *tf;
	STRPTR text, *label;
	ULONG place;
	LONG width, top, bottom, textwidth, texttop, textbottom;
	LONG *storage;

	if( !de )
		return;

	de->idcmp_mask |= CYCLEIDCMP | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY;

	storage = (LONG *)GetTagData( DA_Storage, 0, de->taglist );
	if( storage )
		*storage = GetTagData( GTCY_Active, 0, de->taglist );

	ta = (struct TextAttr *)GetTagData( NGDA_TextAttr, 0, de->taglist );
	if( !ta )
		return;
	tf = OpenDiskFont( ta );
	if( !tf )
		return;
	InitRastPort( &rp );
	SetFont( &rp, tf );

	top = 2 + tf->tf_Baseline;
	bottom = 2 + tf->tf_YSize - tf->tf_Baseline;
	width = 0;
	if( label = (STRPTR *)GetTagData( GTCY_Labels, 0, de->taglist ) )
		while( *label )
		{
			LONG labwidth, labtop, labbottom;

			TextExtent( &rp, *label, strlen( *label ), &te );
			labwidth = te.te_Extent.MaxX + 1 - te.te_Extent.MinX;
			labtop = - te.te_Extent.MinY;
			labbottom = te.te_Extent.MaxY + 1;
			if( labwidth > width )
				width = labwidth;
			if( labtop > top )
				top = labtop;
			if( labbottom > bottom )
				bottom = labbottom;
			label++;
		}
	width += 28;	/* add some space for the cycle glyph and border */

	text = (STRPTR)GetTagData( NGDA_GadgetText, 0, de->taglist );
	place = getTextPlacement( GetTagData( NGDA_Flags, 0, de->taglist ), PLACETEXT_LEFT );

	if( text )
		TextExtent( &rp, text, strlen( text ), &te );
	else
	{
		te.te_Extent.MinX = te.te_Extent.MinY = 0;
		te.te_Extent.MaxX = te.te_Extent.MaxY = -1;
	}

	CloseFont( tf );

	textwidth = te.te_Extent.MaxX + 1 - te.te_Extent.MinX;
	texttop = - te.te_Extent.MinY;
	textbottom = te.te_Extent.MaxY + 1;

	switch( place )
	{
	case PLACETEXT_ABOVE:
		if( width < textwidth )
			width = textwidth;
		setMinWidth( de, width );
		setMaxWidth( de, MAX_SPACE );
		setMinTopExtent( de, texttop + textbottom + INTERHEIGHT );
		setMaxTopExtent( de, texttop + textbottom + INTERHEIGHT );
		setMinBottomExtent( de, top + bottom );
		setMaxBottomExtent( de, top + bottom );
		break;
	case PLACETEXT_BELOW:
		if( width < textwidth )
			width = textwidth;
		setMinWidth( de, width );
		setMaxWidth( de, MAX_SPACE );
		setMinTopExtent( de, top + bottom );
		setMaxTopExtent( de, top + bottom );
		setMinBottomExtent( de, texttop + textbottom + INTERHEIGHT );
		setMaxBottomExtent( de, texttop + textbottom + INTERHEIGHT );
		break;
	case PLACETEXT_LEFT:
		if( top < texttop )
			top = texttop;
		if( bottom < textbottom )
			bottom = textbottom;
		setMinLeftExtent( de, textwidth + INTERWIDTH  );
		setMaxLeftExtent( de, textwidth + INTERWIDTH  );
		setMinRightExtent( de, width );
		setMaxRightExtent( de, MAX_SPACE );
		setMinTopExtent( de, top );
		setMaxTopExtent( de, top );
		setMinBottomExtent( de, bottom );
		setMaxBottomExtent( de, bottom );
		break;
	case PLACETEXT_RIGHT:
		if( top < texttop )
			top = texttop;
		if( bottom < textbottom )
			bottom = textbottom;
		setMinLeftExtent( de, width );
		setMaxLeftExtent( de, MAX_SPACE );
		setMinRightExtent( de, textwidth + INTERWIDTH );
		setMaxRightExtent( de, textwidth + INTERWIDTH );
		setMinTopExtent( de, top );
		setMaxTopExtent( de, top );
		setMinBottomExtent( de, bottom );
		setMaxBottomExtent( de, bottom );
		break;
	case PLACETEXT_IN:
		if( width < textwidth )
			width = textwidth;
		if( top < texttop )
			top = texttop;
		if( bottom < textbottom )
			bottom = textbottom;
		setMinWidth( de, width );
		setMaxWidth( de, MAX_SPACE );
		setMinTopExtent( de, top );
		setMaxTopExtent( de, top );
		setMinBottomExtent( de, bottom );
		setMaxBottomExtent( de, bottom );
		break;
	}
}

static ULONG layoutCycle( DialogElement *de, LayoutMessage *lm )
{
	struct NewGadget ng;
	ULONG error = DIALOGERR_OK;

	if( !de )
		return DIALOGERR_BAD_ARGS;
	if( !lm )
		return DIALOGERR_BAD_ARGS;

#ifdef DEBUG1
	printf(
	"layoutCycle : x %d, y %d, width %d, height %d, left %d, right %d, top %d, bottom %d\n",
		lm->lm_X, lm->lm_Y, lm->lm_Width, lm->lm_Height,
		lm->lm_Left, lm->lm_Right, lm->lm_Top, lm->lm_Bottom );
#endif
	ng.ng_GadgetText = (UBYTE *)GetTagData( NGDA_GadgetText, 0, de->taglist );
	ng.ng_TextAttr = (struct TextAttr *)GetTagData( NGDA_TextAttr, 0, de->taglist );
	ng.ng_VisualInfo = (APTR)GetTagData( NGDA_VisualInfo, 0, de->taglist );
	ng.ng_Flags = GetTagData( NGDA_Flags, 0, de->taglist );
	layoutGTSingleLined( &ng, lm, PLACETEXT_LEFT );
	de->object = CreateGadgetA( CYCLE_KIND, *lm->lm_PreviousPtr, &ng, de->taglist );
	*lm->lm_PreviousPtr = de->object;	/* advance "previous" pointer to new object */
	if( !de->object )
		error = DIALOGERR_NO_MEMORY;
	return error;
}

static DialogElement *matchCycle( DialogElement *de, MatchMessage *mm )
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
					if( *storage < countChoices( de ) - 1 )
						(*storage)++;
					else
						*storage = 0;
					GT_SetGadgetAttrs( de->object, imsg->IDCMPWindow, NULL,
						GTCY_Active, *storage,
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
						GTCY_Active, *storage,
						TAG_DONE );
					match = de;
				}
		break;
	}
	return match;
}

ULONG dispatchCycle( struct Hook *hook, DialogElement *de, DialogMessage *dm )
{
	ULONG result;

	switch( dm->dm_MethodID )
	{
	case DIALOGM_GETSTRUCT:
		result = getCycleStructure( de );
		break;
	case DIALOGM_SETUP:
		setupCycle( de );
		break;
	case DIALOGM_LAYOUT:
		result = layoutCycle( de, (LayoutMessage *)dm );
		break;
	case DIALOGM_MATCH:
		result = (ULONG)matchCycle( de, (MatchMessage *)dm );
		break;
	case DIALOGM_CLEAR:
		break;
	case DIALOGM_SETATTRS:
		setGTAttrs( de, (SetAttrsMessage *)dm );
		break;
	}
	return result;
}
