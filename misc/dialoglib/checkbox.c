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

static ULONG getCheckBoxStructure( DialogElement *de )
{
	ULONG place, structure;

	if( !de )
		return 0;

	if( GetTagData( NGDA_GadgetText, 0, de->taglist ) )
	{
		place = getTextPlacement( GetTagData( NGDA_Flags, 0, de->taglist ), PLACETEXT_LEFT );
		switch( place )
		{
		case PLACETEXT_LEFT:
		case PLACETEXT_RIGHT:
			structure = DESF_VBaseline;
			break;
		case PLACETEXT_ABOVE:
		case PLACETEXT_BELOW:
			structure = DESF_HBaseline;
			break;
		}
	}
	return structure;
}

static VOID setupCheckBox( DialogElement *de )
{
	struct TextAttr *ta;
	struct TextFont *tf;
	struct RastPort rp;
	struct TextExtent te;
	STRPTR text;
	LONG width, height, textwidth, textheight;
	ULONG place;

	if( !de )
		return;

	de->idcmp_mask |= CHECKBOXIDCMP | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY;

	ta = (struct TextAttr *)GetTagData( NGDA_TextAttr, 0, de->taglist );
	if( !ta )
		return;
	tf = OpenDiskFont( ta );
	if( !tf )
		return;
	InitRastPort( &rp );
	SetFont( &rp, tf );

	text = (STRPTR)GetTagData( NGDA_GadgetText, 0, de->taglist );
	if( text )
		TextExtent( &rp, text, strlen( text ), &te );
	else
	{
		te.te_Extent.MinX = te.te_Extent.MinY = 0;
		te.te_Extent.MaxX = te.te_Extent.MaxY = -1;
	}
	textwidth = te.te_Extent.MaxX + 1 - te.te_Extent.MinX;
	textheight = te.te_Extent.MaxY + 1 - te.te_Extent.MinY;

	CloseFont( tf );

	width = 26;
	height = 11;

	place = getTextPlacement( GetTagData( NGDA_Flags, 0, de->taglist ), PLACETEXT_LEFT );
	switch( place )
	{
	case PLACETEXT_ABOVE:
		if( width < textwidth )
			width = textwidth;
		setMinWidth( de, width );
		setMaxWidth( de, width );
		setMinTopExtent( de, textheight + INTERHEIGHT );
		setMaxTopExtent( de, textheight + INTERHEIGHT );
		setMinBottomExtent( de, height );
		setMaxBottomExtent( de, height );
		break;
	case PLACETEXT_BELOW:
		if( width < textwidth )
			width = textwidth;
		setMinWidth( de, width );
		setMaxWidth( de, width );
		setMinBottomExtent( de, textheight + INTERHEIGHT );
		setMaxBottomExtent( de, textheight + INTERHEIGHT );
		setMinTopExtent( de, height );
		setMaxTopExtent( de, height );
		break;
	case PLACETEXT_LEFT:
		if( height < textheight )
			height = textheight;
		setMinLeftExtent( de, textwidth + INTERWIDTH  );
		setMaxLeftExtent( de, textwidth + INTERWIDTH  );
		setMinRightExtent( de, width );
		setMaxRightExtent( de, width );
		setMinHeight( de, height );
		setMaxHeight( de, height );
		break;
	case PLACETEXT_RIGHT:
		if( height < textheight )
			height = textheight;
		setMinLeftExtent( de, width );
		setMaxLeftExtent( de, width );
		setMinRightExtent( de, textwidth + INTERWIDTH  );
		setMaxRightExtent( de, textwidth + INTERWIDTH  );
		setMinHeight( de, height );
		setMaxHeight( de, height );
		break;
	case PLACETEXT_IN:
		if( width < textwidth )
			width = textwidth;
		if( height < textheight )
			height = textheight;
		setMinWidth( de, width );
		setMaxWidth( de, width );
		setMinHeight( de, height );
		setMaxHeight( de, height );
		break;
	}
}

static ULONG layoutCheckBox( DialogElement *de, LayoutMessage *lm )
{
	struct NewGadget ng;
	ULONG error = DIALOGERR_OK;

	if( !de )
		return DIALOGERR_BAD_ARGS;
	if( !lm )
		return DIALOGERR_BAD_ARGS;

#ifdef DEBUG1
	printf(
	"layoutCheckBox : x %d, y %d, width %d, height %d, left %d, right %d, top %d, bottom %d\n",
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
	case PLACETEXT_ABOVE:
		ng.ng_LeftEdge += ( lm->lm_Width - 26 ) / 2;
		break;
	case PLACETEXT_BELOW:
		ng.ng_LeftEdge += ( lm->lm_Width - 26 ) / 2;
		ng.ng_TopEdge -= lm->lm_Top;
		break;
	}
	de->object = CreateGadgetA( CHECKBOX_KIND, *lm->lm_PreviousPtr, &ng, de->taglist );
	*lm->lm_PreviousPtr = de->object;	/* advance "previous" pointer to new object */
	if( !de->object )
		error = DIALOGERR_NO_MEMORY;
	return error;
}

static DialogElement *matchCheckBox( DialogElement *de, MatchMessage *mm )
{
	struct IntuiMessage *imsg;
	struct TagItem *tag;
	struct Gadget *gadget;
	DialogElement *match = NULL;

	if( !de )
		return NULL;
	if( !mm )
		return NULL;

	imsg = mm->mm_IntuiMsg;
	switch( imsg->Class )
	{
	case IDCMP_GADGETUP:
		if( de->object == imsg->IAddress )
			match = de;
		break;
	case IDCMP_VANILLAKEY:
		if( tag = FindTagItem( DA_EquivalentKey, de->taglist ) )
			if( tolower( imsg->Code ) == tolower( tag->ti_Data ) )
			{
				gadget = de->object;
				GT_SetGadgetAttrs( de->object, imsg->IDCMPWindow, NULL,
					GTCB_Checked, !( gadget->Flags & GFLG_SELECTED ),
					TAG_DONE );
				match = de;
			}
		break;
	}
	return match;
}

ULONG dispatchCheckBox( struct Hook *hook, DialogElement *de, DialogMessage *dm )
{
	ULONG result;

	switch( dm->dm_MethodID )
	{
	case DIALOGM_GETSTRUCT:
		result = getCheckBoxStructure( de );
		break;
	case DIALOGM_SETUP:
		setupCheckBox( de );
		break;
	case DIALOGM_LAYOUT:
		result = layoutCheckBox( de, (LayoutMessage *)dm );
		break;
	case DIALOGM_MATCH:
		result = (ULONG)matchCheckBox( de, (MatchMessage *)dm );
		break;
	case DIALOGM_CLEAR:
		break;
	case DIALOGM_SETATTRS:
		setGTAttrs( de, (SetAttrsMessage *)dm );
		break;
	}
	return result;
}
