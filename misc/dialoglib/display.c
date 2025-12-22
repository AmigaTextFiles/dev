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

static ULONG getDisplayStructure( DialogElement *de )
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

static VOID setupDisplay( DialogElement *de, ULONG kind )
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
	case TEXT_KIND:
		de->idcmp_mask |= TEXTIDCMP;
		break;
	case NUMBER_KIND:
		de->idcmp_mask |= NUMBERIDCMP;
		break;
	}
	de->idcmp_mask |= IDCMP_REFRESHWINDOW;

	ta = (struct TextAttr *)GetTagData( NGDA_TextAttr, 0, de->taglist );
	if( !ta )
		return;
	tf = OpenDiskFont( ta );
	if( !tf )
		return;

	minwidth = 8 + 3 * tf->tf_XSize;
	mintop = 2 + tf->tf_Baseline;
	minbottom = 2 + tf->tf_YSize - tf->tf_Baseline;

	text = (STRPTR)GetTagData( NGDA_GadgetText, 0, de->taglist );
	place = getTextPlacement( GetTagData( NGDA_Flags, 0, de->taglist ), PLACETEXT_LEFT );

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

#ifdef DEBUG1
	printf( "setupDisplay : min x %d, max x %d, min y %d, max y %d\n",
		te.te_Extent.MinX, te.te_Extent.MaxX, te.te_Extent.MinY, te.te_Extent.MaxY );
#endif

	textwidth = te.te_Extent.MaxX + 1 - te.te_Extent.MinX;
	texttop = - te.te_Extent.MinY;
	textbottom = te.te_Extent.MaxY + 1;

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

static ULONG layoutDisplay( DialogElement *de, LayoutMessage *lm, ULONG kind )
{
	struct NewGadget ng;
	ULONG error = DIALOGERR_OK;

	if( !de )
		return DIALOGERR_BAD_ARGS;
	if( !lm )
		return DIALOGERR_BAD_ARGS;

#ifdef DEBUG1
	printf(
	"layoutDisplay : x %d, y %d, width %d, height %d, left %d, right %d, top %d, bottom %d\n",
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

ULONG dispatchText( struct Hook *hook, DialogElement *de, DialogMessage *dm )
{
	ULONG result;

	switch( dm->dm_MethodID )
	{
	case DIALOGM_GETSTRUCT:
		result = getDisplayStructure( de );
		break;
	case DIALOGM_SETUP:
		setupDisplay( de, TEXT_KIND );
		break;
	case DIALOGM_LAYOUT:
		result = layoutDisplay( de, (LayoutMessage *)dm, TEXT_KIND );
		break;
	case DIALOGM_MATCH:
		result = 0;
		break;
	case DIALOGM_CLEAR:
		break;
	case DIALOGM_SETATTRS:
		setGTAttrs( de, (SetAttrsMessage *)dm );
		break;
	}
	return result;
}

ULONG dispatchNumber( struct Hook *hook, DialogElement *de, DialogMessage *dm )
{
	ULONG result;

	switch( dm->dm_MethodID )
	{
	case DIALOGM_GETSTRUCT:
		result = getDisplayStructure( de );
		break;
	case DIALOGM_SETUP:
		setupDisplay( de, NUMBER_KIND );
		break;
	case DIALOGM_LAYOUT:
		result = layoutDisplay( de, (LayoutMessage *)dm, NUMBER_KIND );
		break;
	case DIALOGM_MATCH:
		result = 0;
		break;
	case DIALOGM_CLEAR:
		break;
	case DIALOGM_SETATTRS:
		setGTAttrs( de, (SetAttrsMessage *)dm );
		break;
	}
	return result;
}
