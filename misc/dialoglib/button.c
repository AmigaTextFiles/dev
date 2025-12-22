#include <libraries/gadtools.h>
#include <graphics/text.h>
#include <proto/diskfont.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <string.h>
#include <ctype.h>
#include "dialog.h"

static VOID setupButton( DialogElement *de )
{
	struct TextExtent te;
	struct RastPort rp;
	struct TextAttr *ta;
	struct TextFont *tf;
	STRPTR text;
	LONG textwidth, texttop, textbottom;

	if( !de )
		return;

	de->idcmp_mask |= BUTTONIDCMP | IDCMP_REFRESHWINDOW | IDCMP_VANILLAKEY;

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

	CloseFont( tf );

	textwidth = te.te_Extent.MaxX + 1 - te.te_Extent.MinX;
	texttop = - te.te_Extent.MinY;
	textbottom = te.te_Extent.MaxY + 1;

	setMinWidth( de, textwidth + 8 );
	setMaxWidth( de, MAX_SPACE );
	setMinTopExtent( de, texttop + 2 );
	setMaxTopExtent( de, texttop + 2 );
	setMinBottomExtent( de, textbottom + 2 );
	setMaxBottomExtent( de, textbottom + 2 );
}

static ULONG layoutButton( DialogElement *de, LayoutMessage *lm )
{
	struct NewGadget ng;
	ULONG error = DIALOGERR_OK;

	if( !de )
		return DIALOGERR_BAD_ARGS;
	if( !lm )
		return DIALOGERR_BAD_ARGS;

	ng.ng_GadgetText = (UBYTE *)GetTagData( NGDA_GadgetText, 0, de->taglist );
	ng.ng_TextAttr = (struct TextAttr *)GetTagData( NGDA_TextAttr, 0, de->taglist );
	ng.ng_VisualInfo = (APTR)GetTagData( NGDA_VisualInfo, 0, de->taglist );
	ng.ng_Flags = GetTagData( NGDA_Flags, 0, de->taglist );
	ng.ng_LeftEdge = lm->lm_X;
	ng.ng_TopEdge = lm->lm_Y - lm->lm_Top;
	ng.ng_Width = lm->lm_Width;
	ng.ng_Height = lm->lm_Top + lm->lm_Bottom;
	de->object = CreateGadgetA( BUTTON_KIND, *lm->lm_PreviousPtr, &ng, de->taglist );
	*lm->lm_PreviousPtr = de->object;	/* advance "previous" pointer to new object */
	if( !de->object )
		error = DIALOGERR_NO_MEMORY;
	return error;
}

static DialogElement *matchButton( DialogElement *de, MatchMessage *mm )
{
	struct IntuiMessage *imsg;
	struct TagItem *tag;
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
				match = de;
		break;
	}
	return match;
}

ULONG dispatchButton( struct Hook *hook, DialogElement *de, DialogMessage *dm )
{
	ULONG result;

	switch( dm->dm_MethodID )
	{
	case DIALOGM_GETSTRUCT:
		result = DESF_HBaseline;
		break;
	case DIALOGM_SETUP:
		setupButton( de );
		break;
	case DIALOGM_LAYOUT:
		result = layoutButton( de, (LayoutMessage *)dm );
		break;
	case DIALOGM_MATCH:
		result = (ULONG)matchButton( de, (MatchMessage *)dm );
		break;
	case DIALOGM_CLEAR:
		break;
	case DIALOGM_SETATTRS:
		setGTAttrs( de, (SetAttrsMessage *)dm );
		break;
	}
	return result;
}
