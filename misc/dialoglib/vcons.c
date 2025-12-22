#include <clib/macros.h>
#include <proto/utility.h>
#include "dialog.h"
#ifdef DEBUG1
	#include <stdio.h>
#endif

/* filters for structure flag common among car and cdr */
static ULONG getVConsStructure( DialogElement *de )
{
	DialogElement *car, *cdr;
	ULONG vstructure = DESF_VBaseline;

	if( !de )
		return 0;

	if( car = (DialogElement *)GetTagData( DA_CAR, 0, de->taglist ) )
		vstructure &= getDialogElementStructure( car );
	if( cdr = (DialogElement *)GetTagData( DA_CDR, 0, de->taglist ) )
		vstructure &= getDialogElementStructure( cdr );

	return vstructure | DESF_HBaseline;
}

static VOID setupVCons( DialogElement *de )
{
	DialogElement *car, *cdr;
	LONG alignment, minleft, minright, minwidth, maxleft, maxright, maxwidth;
	ULONG substructure;

	if( !de )
		return;

	alignment = GetTagData( DA_Alignment, 0, de->taglist );	/* currently unused */

	/* determine structure */
	de->structure = getDialogElementStructure( de );

	/* these value are modified later */
	setMinTopExtent( de, 0 );
	setMaxTopExtent( de, 0 );
	setMinBottomExtent( de, 0 );
	setMaxBottomExtent( de, 0 );
	if( de->structure & DESF_VBaseline )
	{
		setMaxLeftExtent( de, 0 );
		setMaxRightExtent( de, 0 );
	}
	else
		setMaxWidth( de, 0 );

	if( car = (DialogElement *)GetTagData( DA_CAR, 0, de->taglist ) )
	{
		setupDialogElement( car );
		de->idcmp_mask |= car->idcmp_mask;
		substructure = getDialogElementStructure( car );

		/* modify Min/MaxTopExtent to accomodate car */
		if( substructure & DESF_HBaseline )
		{
			setMinTopExtent( de, getMinTopExtent( car ) + getMinBottomExtent( car ) );
			setMaxTopExtent( de, getMaxTopExtent( car ) + getMaxBottomExtent( car ) );
		}
		else
		{
			setMinTopExtent( de, getMinHeight( car ) );
			setMaxTopExtent( de, getMaxHeight( car ) );
		}

		/* modify Min/MaxWidth or Min/MaxLeft/RightExtent to accomodate car */
		if( substructure & DESF_VBaseline )
		{
			minleft = getMinLeftExtent( car );
			minright = getMinRightExtent( car );
			maxleft = getMaxLeftExtent( car );
			maxright = getMaxRightExtent( car );
			if( de->structure & DESF_VBaseline )
			{
				if( minleft > getMinLeftExtent( de ) )
					setMinLeftExtent( de, minleft );
				if( minright > getMinRightExtent( de ) )
					setMinRightExtent( de, minright );
				if( maxleft > getMaxLeftExtent( de ) )
					setMaxLeftExtent( de, maxleft );
				if( maxright > getMaxRightExtent( de ) )
					setMaxRightExtent( de, maxright );
			}
			else
			{
				minwidth = minleft + minright;
				maxwidth = maxleft + maxright;
				if( minwidth > getMinWidth( de ) )
					setMinWidth( de, minwidth );
				if( maxwidth > getMaxWidth( de ) )
					setMaxWidth( de, maxwidth );
			}
		}
		else
		{
			minwidth = getMinWidth( car );
			maxwidth = getMaxWidth( car );
			if( minwidth > getMinWidth( de ) )
				setMinWidth( de, minwidth );
			if( maxwidth > getMaxWidth( de ) )
				setMaxWidth( de, maxwidth );
		}
	}
	if( cdr = (DialogElement *)GetTagData( DA_CDR, 0, de->taglist ) )
	{
		setupDialogElement( cdr );
		de->idcmp_mask |= cdr->idcmp_mask;
		substructure = getDialogElementStructure( cdr );

		/* modify Min/MaxBottomExtent to accomodate cdr */
		if( substructure & DESF_HBaseline )
		{
			setMinBottomExtent( de, getMinTopExtent( cdr ) + getMinBottomExtent( cdr ) );
			setMaxBottomExtent( de, getMaxTopExtent( cdr ) + getMaxBottomExtent( cdr ) );
		}
		else
		{
			setMinBottomExtent( de, getMinHeight( cdr ) );
			setMaxBottomExtent( de, getMaxHeight( cdr ) );
		}

		/* modify Min/MaxWidth or Min/MaxLeft/RightExtent to accomodate cdr */
		if( substructure & DESF_VBaseline )
		{
			minleft = getMinLeftExtent( cdr );
			minright = getMinRightExtent( cdr );
			maxleft = getMaxLeftExtent( cdr );
			maxright = getMaxRightExtent( cdr );
			if( de->structure & DESF_VBaseline )
			{
				if( minleft > getMinLeftExtent( de ) )
					setMinLeftExtent( de, minleft );
				if( minright > getMinRightExtent( de ) )
					setMinRightExtent( de, minright );
				if( maxleft > getMaxLeftExtent( de ) )
					setMaxLeftExtent( de, maxleft );
				if( maxright > getMaxRightExtent( de ) )
					setMaxRightExtent( de, maxright );
			}
			else
			{
				minwidth = minleft + minright;
				maxwidth = maxleft + maxright;
				if( minwidth > getMinWidth( de ) )
					setMinWidth( de, minwidth );
				if( maxwidth > getMaxWidth( de ) )
					setMaxWidth( de, maxwidth );
			}
		}
		else
		{
			minwidth = getMinWidth( cdr );
			maxwidth = getMaxWidth( cdr );
			if( minwidth > getMinWidth( de ) )
				setMinWidth( de, minwidth );
			if( maxwidth > getMaxWidth( de ) )
				setMaxWidth( de, maxwidth );
		}
	}
}

static ULONG layoutVCons( DialogElement *de, LayoutMessage *lm )
{
	DialogElement *car, *cdr;
	LayoutMessage message;
	LONG alignment;
	LONG y, top, bottom, white, spare;
	ULONG substructure, error = DIALOGERR_OK;

	if( !de )
		return DIALOGERR_BAD_ARGS;
	if( !lm )
		return DIALOGERR_BAD_ARGS;

#ifdef DEBUG1
	printf(
	"layoutVCons : x %d, y %d, width %d, height %d, left %d, right %d, top %d, bottom %d\n",
		lm->lm_X, lm->lm_Y, lm->lm_Width, lm->lm_Height,
		lm->lm_Left, lm->lm_Right, lm->lm_Top, lm->lm_Bottom );
#endif

	alignment = GetTagData( DA_Alignment, 0, de->taglist );	/* currently ignored */

	if( car = (DialogElement *)GetTagData( DA_CAR, 0, de->taglist ) )
	{
		substructure = prepareMemberLayoutH( &message, de, car, lm );
		y = lm->lm_Y;
		if( substructure & DESF_HBaseline )
		{
			LONG mintop, minbottom;

			mintop = getMinTopExtent( car );
			minbottom = getMinBottomExtent( car );
			white = lm->lm_Top - mintop - minbottom;
			top = getMaxTopExtent( car ) - mintop;
			bottom = getMaxBottomExtent( car ) - minbottom;
			spare = top + bottom;
			top = mintop + ( ( spare ) ? ( top * white ) / spare : 0 );
			bottom = minbottom + ( ( spare ) ? ( bottom * white ) / spare : 0 );
			prepareLayoutHBaseline( &message, top, bottom );
			y -= bottom;
		}
		else
		{
			prepareLayoutNoHBaseline( &message, lm->lm_Top );
			y -= lm->lm_Top;
		}
		prepareLayoutY( &message, y );
		error = layoutDialogElement( car, &message, lm->lm_PreviousPtr );
		if( error )
			goto termination;
	}
	if( cdr = (DialogElement *)GetTagData( DA_CDR, 0, de->taglist ) )
	{
		substructure = prepareMemberLayoutH( &message, de, cdr, lm );
		y = lm->lm_Y;
		if( substructure & DESF_HBaseline )
		{
			LONG mintop, minbottom;

			mintop = getMinTopExtent( cdr );
			minbottom = getMinBottomExtent( cdr );
			white = lm->lm_Bottom - mintop - minbottom;
			top = getMaxTopExtent( cdr ) - mintop;
			bottom = getMaxBottomExtent( cdr ) - minbottom;
			spare = top + bottom;
			top = mintop + ( ( spare ) ? ( top * white ) / spare : 0 );
			bottom = minbottom + ( ( spare ) ? ( bottom * white ) / spare : 0 );
			prepareLayoutHBaseline( &message, top, bottom );
			y += top;
		}
		else
			prepareLayoutNoHBaseline( &message, lm->lm_Bottom );
		prepareLayoutY( &message, y );
		error = layoutDialogElement( cdr, &message, lm->lm_PreviousPtr );
		if( error )
			goto termination;
	}
termination:
	return error;
}

static DialogElement *matchVCons( DialogElement *de, MatchMessage *mm )
{
	DialogElement *car, *cdr, *match = NULL;

	if( !de )
		return NULL;
	if( !mm )
		return NULL;

	if( car = (DialogElement *)GetTagData( DA_CAR, 0, de->taglist ) )
		if( match = mapDialogEvent( car, mm->mm_IntuiMsg ) )
			goto termination;
	if( cdr = (DialogElement *)GetTagData( DA_CDR, 0, de->taglist ) )
		if( match = mapDialogEvent( cdr, mm->mm_IntuiMsg ) )
			goto termination;
termination:
	return match;
}

static VOID clearVCons( DialogElement *de )
{
	DialogElement *car, *cdr;

	if( !de )
		return;

	if( car = (DialogElement *)GetTagData( DA_CAR, 0, de->taglist ) )
		clearDialogElement( car );
	if( cdr = (DialogElement *)GetTagData( DA_CDR, 0, de->taglist ) )
		clearDialogElement( cdr );
}

ULONG dispatchVCons( struct Hook *hook, DialogElement *de, DialogMessage *dm )
{
	ULONG result;

	switch( dm->dm_MethodID )
	{
	case DIALOGM_GETSTRUCT:
		result = getVConsStructure( de );
		break;
	case DIALOGM_SETUP:
		setupVCons( de );
		break;
	case DIALOGM_LAYOUT:
		result = layoutVCons( de, (LayoutMessage *)dm );
		break;
	case DIALOGM_MATCH:
		result = (ULONG)matchVCons( de, (MatchMessage *)dm );
		break;
	case DIALOGM_CLEAR:
		clearVCons( de );
		break;
	}
	return result;
}
