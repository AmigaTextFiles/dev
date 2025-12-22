#include <libraries/gadtools.h>
#include <proto/gadtools.h>
#include <proto/utility.h>
#include "dialog.h"
#ifdef DEBUG1
	#include <stdio.h>
#endif

static VOID setupRoot( DialogElement *de )
{
	DialogElement *member;
	LONG xspace, yspace, minwidth = 0, minheight = 0, maxwidth = 0, maxheight = 0;

	if( !de )
		return;

	if( member = (DialogElement *)GetTagData( DA_Member, 0, de->taglist ) )
	{
		de->structure = getDialogElementStructure( member );
		xspace = GetTagData( DA_XSpacing, INTERWIDTH, de->taglist );
		yspace = GetTagData( DA_YSpacing, INTERHEIGHT, de->taglist );
		setupDialogElement( member );
		de->idcmp_mask |= member->idcmp_mask;
		if( de->structure & DESF_HBaseline )
		{
			minheight = getMinTopExtent( member ) + getMinBottomExtent( member ) + 2 * yspace;
			maxheight = getMaxTopExtent( member ) + getMaxBottomExtent( member ) + 2 * yspace;
		}
		else
		{
			minheight = getMinHeight( member ) + 2 * yspace;
			maxheight = getMaxHeight( member ) + 2 * yspace;
		}
		if( de->structure & DESF_VBaseline )
		{
			minwidth = getMinLeftExtent( member ) + getMinRightExtent( member ) + 2 * xspace;
			maxwidth = getMaxLeftExtent( member ) + getMaxRightExtent( member ) + 2 * xspace;
		}
		else
		{
			minwidth = getMinWidth( member ) + 2 * xspace;
			maxwidth = getMaxWidth( member ) + 2 * xspace;
		}
	}
	setMinWidth( de, minwidth );
	setMaxWidth( de, maxwidth );
	setMinHeight( de, minheight );
	setMaxHeight( de, maxheight );
}

static ULONG layoutRoot( DialogElement *de, LayoutMessage *lm )
{
	DialogElement *member;
	LayoutMessage message;
	ULONG error = DIALOGERR_OK;
	LONG x, y, xspace, yspace;

	if( !de )
		return DIALOGERR_BAD_ARGS;
	if( !lm )
		return DIALOGERR_BAD_ARGS;

#ifdef DEBUG1
	printf( "layoutRoot : "
		"x %d, y %d, width %d, height %d, left %d, right %d, top %d, bottom %d\n",
		lm->lm_X, lm->lm_Y, lm->lm_Width, lm->lm_Height,
		lm->lm_Left, lm->lm_Right, lm->lm_Top, lm->lm_Bottom );
#endif
	if( member = (DialogElement *)GetTagData( DA_Member, 0, de->taglist ) )
	{
		xspace = GetTagData( DA_XSpacing, INTERWIDTH, de->taglist );
		yspace = GetTagData( DA_YSpacing, INTERHEIGHT, de->taglist );
		x = lm->lm_X + xspace;
		y = lm->lm_Y + yspace;
		if( de->structure & DESF_HBaseline )
		{
			LONG mintop, minbottom, top, bottom, white, spare;

			mintop = getMinTopExtent( member );
			minbottom = getMinBottomExtent( member );
			white = lm->lm_Height - 2 * yspace - mintop - minbottom;
			top = getMaxTopExtent( member ) - mintop;
			bottom = getMaxBottomExtent( member ) - minbottom;
			spare = top + bottom;
			top = mintop + ( ( spare ) ? ( top * white ) / spare : 0 );
			bottom = minbottom + ( ( spare ) ? ( bottom * white ) / spare : 0 );
			prepareLayoutHBaseline( &message, top, bottom );
			y += top;
		}
		else
			prepareLayoutNoHBaseline( &message, lm->lm_Height - 2 * yspace );
		if( de->structure & DESF_VBaseline )
		{
			LONG minleft, minright, left, right, white, spare;

			minleft = getMinLeftExtent( member );
			minright = getMinRightExtent( member );
			white = lm->lm_Width - 2 * xspace - minleft - minright;
			left = getMaxLeftExtent( member ) - minleft;
			right = getMaxRightExtent( member ) - minright;
			spare = left + right;
			left = minleft + ( ( spare ) ? ( left * white ) / spare : 0 );
			right = minright + ( ( spare ) ? ( right * white ) / spare : 0 );
			prepareLayoutVBaseline( &message, left, right );
			x += left;
		}
		else
			prepareLayoutNoVBaseline( &message, lm->lm_Width - 2 * xspace );
		prepareLayoutX( &message, x );
		prepareLayoutY( &message, y );
		error = layoutDialogElement( member, &message, lm->lm_PreviousPtr );
	}
	return error;
}

static DialogElement *matchRoot( DialogElement *de, MatchMessage *mm )
{
	struct IntuiMessage *imsg;
	DialogElement *member, *match = NULL;

	if( !de )
		return NULL;
	if( !mm )
		return NULL;

	imsg = mm->mm_IntuiMsg;

	if( imsg->Class & IDCMP_REFRESHWINDOW )
		GT_BeginRefresh( imsg->IDCMPWindow );

	if( member = (DialogElement *)GetTagData( DA_Member, 0, de->taglist ) )
		match = mapDialogEvent( member, mm->mm_IntuiMsg );

	if( imsg->Class & IDCMP_REFRESHWINDOW )
		GT_EndRefresh( imsg->IDCMPWindow, TRUE );

	return match;
}

static VOID clearRoot( DialogElement *de, DialogMessage *dm )
{
	DialogElement *member;

	if( !de )
		return;

	if( member = (DialogElement *)GetTagData( DA_Member, 0, de->taglist ) )
		clearDialogElement( member );
}

/****** dialog.lib/dispatchRoot ******
*
*	NAME
*		dispatchRoot -- dispatches messages for root class dialog elements
*
*	SEE ALSO
*		--background--
*
**************************************/

ULONG dispatchRoot( struct Hook *hook, DialogElement *de, DialogMessage *dm )
{
	ULONG result;

	switch( dm->dm_MethodID )
	{
	case DIALOGM_GETSTRUCT:
		result = 0;
		break;
	case DIALOGM_SETUP:
		setupRoot( de );
		break;
	case DIALOGM_LAYOUT:
		result = layoutRoot( de, (LayoutMessage *)dm );
		break;
	case DIALOGM_MATCH:
		result = (ULONG)matchRoot( de, (MatchMessage *)dm );
		break;
	case DIALOGM_CLEAR:
		clearRoot( de, dm );
		break;
	}
	return result;
}
