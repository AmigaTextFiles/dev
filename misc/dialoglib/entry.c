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

static ULONG getEntryStructure( DialogElement *de )
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

static VOID setupEntry( DialogElement *de, ULONG kind )
{
	struct TextExtent te;
	struct RastPort rp;
	struct TextAttr *ta;
	struct TextFont *tf;
	STRPTR text;
	ULONG place;
	LONG minwidth, mintop, minbottom, textwidth, texttop, textbottom;

	if( !de )
		return;

	switch( kind )
	{
	case STRING_KIND:
		de->idcmp_mask |= STRINGIDCMP;
		break;
	case INTEGER_KIND:
		de->idcmp_mask |= INTEGERIDCMP;
		break;
	}
	de->idcmp_mask |= IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY;

	ta = (struct TextAttr *)GetTagData( NGDA_TextAttr, 0, de->taglist );
	if( !ta )
		return;
	tf = OpenDiskFont( ta );
	if( !tf )
		return;
	InitRastPort( &rp );
	SetFont( &rp, tf );

	minwidth = 8 + 3 * tf->tf_XSize;
	mintop = 3 + tf->tf_Baseline;
	minbottom = 3 + tf->tf_YSize - tf->tf_Baseline;

	text = (STRPTR)GetTagData( NGDA_GadgetText, 0, de->taglist );
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

	place = getTextPlacement( GetTagData( NGDA_Flags, 0, de->taglist ), PLACETEXT_LEFT );
	switch( place )
	{
	case PLACETEXT_ABOVE:
		if( minwidth < textwidth )
			minwidth = textwidth;
		setMinWidth( de, minwidth );
		setMaxWidth( de, MAX_SPACE );
		setMinTopExtent( de, texttop + textbottom + INTERHEIGHT );
		setMaxTopExtent( de, texttop + textbottom + INTERHEIGHT );
		setMinBottomExtent( de, mintop + minbottom );
		setMaxBottomExtent( de, mintop + minbottom );
		break;
	case PLACETEXT_BELOW:
		if( minwidth < textwidth )
			minwidth = textwidth;
		setMinWidth( de, minwidth );
		setMaxWidth( de, MAX_SPACE );
		setMinTopExtent( de, mintop + minbottom );
		setMaxTopExtent( de, mintop + minbottom );
		setMinBottomExtent( de, texttop + textbottom + INTERHEIGHT );
		setMaxBottomExtent( de, texttop + textbottom + INTERHEIGHT );
		break;
	case PLACETEXT_LEFT:
		if( mintop < texttop )
			mintop = texttop;
		if( minbottom < textbottom )
			minbottom = textbottom;
		setMinLeftExtent( de, textwidth + INTERWIDTH  );
		setMaxLeftExtent( de, textwidth + INTERWIDTH  );
		setMinRightExtent( de, minwidth );
		setMaxRightExtent( de, MAX_SPACE );
		setMinTopExtent( de, mintop );
		setMaxTopExtent( de, mintop );
		setMinBottomExtent( de, minbottom );
		setMaxBottomExtent( de, minbottom );
		break;
	case PLACETEXT_RIGHT:
		if( mintop < texttop )
			mintop = texttop;
		if( minbottom < textbottom )
			minbottom = textbottom;
		setMinLeftExtent( de, minwidth );
		setMaxLeftExtent( de, MAX_SPACE );
		setMinRightExtent( de, textwidth + INTERWIDTH );
		setMaxRightExtent( de, textwidth + INTERWIDTH );
		setMinTopExtent( de, mintop );
		setMaxTopExtent( de, mintop );
		setMinBottomExtent( de, minbottom );
		setMaxBottomExtent( de, minbottom );
		break;
	case PLACETEXT_IN:
		if( minwidth < textwidth )
			minwidth = textwidth;
		if( mintop < texttop )
			mintop = texttop;
		if( minbottom < textbottom )
			minbottom = textbottom;
		setMinWidth( de, minwidth );
		setMaxWidth( de, MAX_SPACE );
		setMinTopExtent( de, mintop );
		setMaxTopExtent( de, mintop );
		setMinBottomExtent( de, minbottom );
		setMaxBottomExtent( de, minbottom );
		break;
	}
}

static ULONG layoutEntry( DialogElement *de, LayoutMessage *lm, ULONG kind )
{
	struct NewGadget ng;
	ULONG error = DIALOGERR_OK;

	if( !de )
		return DIALOGERR_BAD_ARGS;
	if( !lm )
		return DIALOGERR_BAD_ARGS;

#ifdef DEBUG1
	printf(
	"layoutEntry : x %d, y %d, width %d, height %d, left %d, right %d, top %d, bottom %d\n",
		lm->lm_X, lm->lm_Y, lm->lm_Width, lm->lm_Height,
		lm->lm_Left, lm->lm_Right, lm->lm_Top, lm->lm_Bottom );
#endif
	ng.ng_GadgetText = (UBYTE *)GetTagData( NGDA_GadgetText, 0, de->taglist );
	ng.ng_TextAttr = (struct TextAttr *)GetTagData( NGDA_TextAttr, 0, de->taglist );
	ng.ng_VisualInfo = (APTR)GetTagData( NGDA_VisualInfo, 0, de->taglist );
	ng.ng_Flags = GetTagData( NGDA_Flags, 0, de->taglist );
	layoutGTSingleLined( &ng, lm, PLACETEXT_LEFT );
	de->object = CreateGadgetA( kind, *lm->lm_PreviousPtr, &ng, de->taglist );
	*lm->lm_PreviousPtr = de->object;	/* advance "previous" pointer to new object */
	if( !de->object )
		error = DIALOGERR_NO_MEMORY;
	return error;
}

static DialogElement *matchString( DialogElement *de, MatchMessage *mm )
{
	struct IntuiMessage *imsg;
	struct TagItem *tag;
	DialogElement *match = NULL;
	struct Gadget *gadget;
	STRPTR buffer;

	if( !de )
		return NULL;
	if( !mm )
		return NULL;

	imsg = mm->mm_IntuiMsg;
	switch( imsg->Class )
	{
	case IDCMP_GADGETUP:
		if( de->object == imsg->IAddress )
		{
			gadget = de->object;
			if( buffer = (STRPTR)GetTagData( DA_Storage, 0, de->taglist ) )
				strcpy( buffer, ( (struct StringInfo *)gadget->SpecialInfo )->Buffer );
			match = de;
		}
		break;
	case IDCMP_VANILLAKEY:
		if( tag = FindTagItem( DA_EquivalentKey, de->taglist ) )
			if( tolower( imsg->Code ) == tolower( tag->ti_Data ) )
				ActivateGadget( de->object, imsg->IDCMPWindow, NULL );
		break;
	}
	return match;
}

ULONG dispatchString( struct Hook *hook, DialogElement *de, DialogMessage *dm )
{
	ULONG result;

	switch( dm->dm_MethodID )
	{
	case DIALOGM_GETSTRUCT:
		result = getEntryStructure( de );
		break;
	case DIALOGM_SETUP:
		setupEntry( de, STRING_KIND );
		break;
	case DIALOGM_LAYOUT:
		result = layoutEntry( de, (LayoutMessage *)dm, STRING_KIND );
		break;
	case DIALOGM_MATCH:
		result = (ULONG)matchString( de, (MatchMessage *)dm );
		break;
	case DIALOGM_CLEAR:
		break;
	case DIALOGM_SETATTRS:
		setGTAttrs( de, (SetAttrsMessage *)dm );
		break;
	}
	return result;
}

static DialogElement *matchInteger( DialogElement *de, MatchMessage *mm )
{
	struct IntuiMessage *imsg = mm->mm_IntuiMsg;
	struct TagItem *tag;
	DialogElement *match = NULL;
	struct Gadget *gadget;
	LONG *buffer;

	switch( imsg->Class )
	{
	case IDCMP_GADGETUP:
		if( de->object == imsg->IAddress )
		{
			gadget = de->object;
			if( buffer = (LONG *)GetTagData( DA_Storage, 0, de->taglist ) )
				*buffer = ( (struct StringInfo *)gadget->SpecialInfo )->LongInt;
			match = de;
		}
		break;
	case IDCMP_VANILLAKEY:
		if( tag = FindTagItem( DA_EquivalentKey, de->taglist ) )
			if( tolower( imsg->Code ) == tolower( tag->ti_Data ) )
				ActivateGadget( de->object, imsg->IDCMPWindow, NULL );
		break;
	}
	return match;
}

ULONG dispatchInteger( struct Hook *hook, DialogElement *de, DialogMessage *dm )
{
	ULONG result;

	switch( dm->dm_MethodID )
	{
	case DIALOGM_GETSTRUCT:
		result = getEntryStructure( de );
		break;
	case DIALOGM_SETUP:
		setupEntry( de, INTEGER_KIND );
		break;
	case DIALOGM_LAYOUT:
		result = layoutEntry( de, (LayoutMessage *)dm, INTEGER_KIND );
		break;
	case DIALOGM_MATCH:
		result = (ULONG)matchInteger( de, (MatchMessage *)dm );
		break;
	case DIALOGM_CLEAR:
		break;
	case DIALOGM_SETATTRS:
		setGTAttrs( de, (SetAttrsMessage *)dm );
		break;
	}
	return result;
}
