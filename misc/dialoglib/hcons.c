#include <clib/macros.h>
#include <proto/utility.h>
#include "dialog.h"
#ifdef DEBUG1
	#include <stdio.h>
#endif

/* filters for structure flag common among car and cdr */
static ULONG getHConsStructure( DialogElement *de )
{
	DialogElement *car, *cdr;
	ULONG hstructure = DESF_HBaseline;

	if( !de )
		return 0;

	if( car = (DialogElement *)GetTagData( DA_CAR, 0, de->taglist ) )
		hstructure &= getDialogElementStructure( car );
	if( cdr = (DialogElement *)GetTagData( DA_CDR, 0, de->taglist ) )
		hstructure &= getDialogElementStructure( cdr );
	return hstructure | DESF_VBaseline;
}

static VOID setupHCons( DialogElement *de )
{
	DialogElement *car, *cdr;
	LONG alignment, mintop, minbottom, minheight, maxtop, maxbottom, maxheight;
	ULONG substructure;

	if( !de )
		return;

	alignment = GetTagData( DA_Alignment, 0, de->taglist );	/* currently unused */

	/* determine structure */
	de->structure = getDialogElementStructure( de );

	/* these value are modified later */
	setMinLeftExtent( de, 0 );
	setMaxLeftExtent( de, 0 );
	setMinRightExtent( de, 0 );
	setMaxRightExtent( de, 0 );
	if( de->structure & DESF_HBaseline )
	{
		setMaxTopExtent( de, 0 );
		setMaxBottomExtent( de, 0 );
	}
	else
		setMaxHeight( de, 0 );

	if( car = (DialogElement *)GetTagData( DA_CAR, 0, de->taglist ) )
	{
		setupDialogElement( car );
		de->idcmp_mask |= car->idcmp_mask;
		substructure = getDialogElementStructure( car );

		/* modify Min/MaxLeftExtent to accomodate car */
		if( substructure & DESF_VBaseline )
		{
			setMinLeftExtent( de, getMinLeftExtent( car ) + getMinRightExtent( car ) );
			setMaxLeftExtent( de, getMaxLeftExtent( car ) + getMaxRightExtent( car ) );
		}
		else
		{
			setMinLeftExtent( de, getMinWidth( car ) );
			setMaxLeftExtent( de, getMaxWidth( car ) );
		}

		/* modify Min/MaxHeight or Min/MaxTop/BottomExtent to accomodate car */
		if( substructure & DESF_HBaseline )
		{
			mintop = getMinTopExtent( car );
			minbottom = getMinBottomExtent( car );
			maxtop = getMaxTopExtent( car );
			maxbottom = getMaxBottomExtent( car );
			if( de->structure & DESF_HBaseline )
			{
				if( mintop > getMinTopExtent( de ) )
					setMinTopExtent( de, mintop );
				if( minbottom > getMinBottomExtent( de ) )
					setMinBottomExtent( de, minbottom );
				if( maxtop > getMaxTopExtent( de ) )
					setMaxTopExtent( de, maxtop );
				if( maxbottom > getMaxBottomExtent( de ) )
					setMaxBottomExtent( de, maxbottom );
			}
			else
			{
				minheight = mintop + minbottom;
				maxheight = maxtop + maxbottom;
				if( minheight > getMinHeight( de ) )
					setMinHeight( de, minheight );
				if( maxheight > getMaxHeight( de ) )
					setMaxHeight( de, maxheight );
			}
		}
		else
		{
			minheight = getMinHeight( car );
			maxheight = getMaxHeight( car );
			if( minheight > getMinHeight( de ) )
				setMinHeight( de, minheight );
			if( maxheight > getMaxHeight( de ) )
				setMaxHeight( de, maxheight );
		}
	}
	if( cdr = (DialogElement *)GetTagData( DA_CDR, 0, de->taglist ) )
	{
		setupDialogElement( cdr );
		de->idcmp_mask |= cdr->idcmp_mask;
		substructure = getDialogElementStructure( cdr );

		/* modify Min/MaxRightExtent to accomodate cdr */
		if( substructure & DESF_VBaseline )
		{
			setMinRightExtent( de, getMinLeftExtent( cdr ) + getMinRightExtent( cdr ) );
			setMaxRightExtent( de, getMaxLeftExtent( cdr ) + getMaxRightExtent( cdr ) );
		}
		else
		{
			setMinRightExtent( de, getMinWidth( cdr ) );
			setMaxRightExtent( de, getMaxWidth( cdr ) );
		}

		/* modify Min/MaxHeight or Min/MaxTop/BottomExtent to accomodate cdr */
		if( substructure & DESF_HBaseline )
		{
			mintop = getMinTopExtent( cdr );
			minbottom = getMinBottomExtent( cdr );
			maxtop = getMaxTopExtent( cdr );
			maxbottom = getMaxBottomExtent( cdr );
			if( de->structure & DESF_HBaseline )
			{
				if( mintop > getMinTopExtent( de ) )
					setMinTopExtent( de, mintop );
				if( minbottom > getMinBottomExtent( de ) )
					setMinBottomExtent( de, minbottom );
				if( maxtop > getMaxTopExtent( de ) )
					setMaxTopExtent( de, maxtop );
				if( maxbottom > getMaxBottomExtent( de ) )
					setMaxBottomExtent( de, maxbottom );
			}
			else
			{
				minheight = mintop + minbottom;
				maxheight = maxtop + maxbottom;
				if( minheight > getMinHeight( de ) )
					setMinHeight( de, minheight );
				if( maxheight > getMaxHeight( de ) )
					setMaxHeight( de, maxheight );
			}
		}
		else
		{
			minheight = getMinHeight( cdr );
			maxheight = getMaxHeight( cdr );
			if( minheight > getMinHeight( de ) )
				setMinHeight( de, minheight );
			if( maxheight > getMaxHeight( de ) )
				setMaxHeight( de, maxheight );
		}
	}
}

static ULONG layoutHCons( DialogElement *de, LayoutMessage *lm )
{
	DialogElement *car, *cdr;
	LayoutMessage message;
	LONG alignment;
	LONG x, left, right, white, spare;
	ULONG substructure, error = DIALOGERR_OK;

	if( !de )
		return DIALOGERR_BAD_ARGS;
	if( !lm )
		return DIALOGERR_BAD_ARGS;

#ifdef DEBUG1
	printf(
	"layoutHCons : x %d, y %d, width %d, height %d, left %d, right %d, top %d, bottom %d\n",
		lm->lm_X, lm->lm_Y, lm->lm_Width, lm->lm_Height,
		lm->lm_Left, lm->lm_Right, lm->lm_Top, lm->lm_Bottom );
#endif

	alignment = GetTagData( DA_Alignment, 0, de->taglist );	/* currently ignored */

	if( car = (DialogElement *)GetTagData( DA_CAR, 0, de->taglist ) )
	{
		substructure = prepareMemberLayoutV( &message, de, car, lm );
		x = lm->lm_X;
		if( substructure & DESF_VBaseline )
		{
			LONG minleft, minright;

			minleft = getMinLeftExtent( car );
			minright = getMinRightExtent( car );
			white = lm->lm_Left - minleft - minright;
			left = getMaxLeftExtent( car ) - minleft;
			right = getMaxRightExtent( car ) - minright;
			spare = left + right;
			left = minleft + ( ( spare ) ? ( left * white ) / spare : 0 );
			right = minright + ( ( spare ) ? ( right * white ) / spare : 0 );
			prepareLayoutVBaseline( &message, left, right );
			x -= right;
		}
		else
		{
			prepareLayoutNoVBaseline( &message, lm->lm_Left );
			x -= lm->lm_Left;
		}
		prepareLayoutX( &message, x );
		error = layoutDialogElement( car, &message, lm->lm_PreviousPtr );
		if( error )
			goto termination;
	}
	if( cdr = (DialogElement *)GetTagData( DA_CDR, 0, de->taglist ) )
	{
		substructure = prepareMemberLayoutV( &message, de, cdr, lm );
		x = lm->lm_X;
		if( substructure & DESF_VBaseline )
		{
			LONG minleft, minright;

			minleft = getMinLeftExtent( cdr );
			minright = getMinRightExtent( cdr );
			white = lm->lm_Right - minleft - minright;
			left = getMaxLeftExtent( cdr ) - minleft;
			right = getMaxRightExtent( cdr ) - minright;
			spare = left + right;
			left = minleft + ( ( spare ) ? ( left * white ) / spare : 0 );
			right = minright + ( ( spare ) ? ( right * white ) / spare : 0 );
			prepareLayoutVBaseline( &message, left, right );
			x += left;
		}
		else
			prepareLayoutNoVBaseline( &message, lm->lm_Right );
		prepareLayoutX( &message, x );
		error = layoutDialogElement( cdr, &message, lm->lm_PreviousPtr );
		if( error )
			goto termination;
	}
termination:
	return error;
}

static DialogElement *matchHCons( DialogElement *de, MatchMessage *mm )
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

static VOID clearHCons( DialogElement *de )
{
	DialogElement *car, *cdr;

	if( !de )
		return;

	if( car = (DialogElement *)GetTagData( DA_CAR, 0, de->taglist ) )
		clearDialogElement( car );
	if( cdr = (DialogElement *)GetTagData( DA_CDR, 0, de->taglist ) )
		clearDialogElement( cdr );
}

ULONG dispatchHCons( struct Hook *hook, DialogElement *de, DialogMessage *dm )
{
	ULONG result;

	switch( dm->dm_MethodID )
	{
	case DIALOGM_GETSTRUCT:
		result = getHConsStructure( de );
		break;
	case DIALOGM_SETUP:
		setupHCons( de );
		break;
	case DIALOGM_LAYOUT:
		result = layoutHCons( de, (LayoutMessage *)dm );
		break;
	case DIALOGM_MATCH:
		result = (ULONG)matchHCons( de, (MatchMessage *)dm );
		break;
	case DIALOGM_CLEAR:
		clearHCons( de );
		break;
	}
	return result;
}
