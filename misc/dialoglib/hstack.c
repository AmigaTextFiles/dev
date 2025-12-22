#include <clib/macros.h>
#include <proto/utility.h>
#include "dialog.h"
#ifdef DEBUG1
	#include <stdio.h>
#endif

/* filters for structure flag common among all members */
static ULONG getHStackStructure( DialogElement *de )
{
	struct TagItem *tstate, *tag;
	DialogElement *member;
	ULONG structure = DESF_HBaseline;

	if( !de )
		return 0;

	if( GetTagData( DA_Alignment, 0, de->taglist ) )
		structure = 0;
	else
		for( tstate = de->taglist; tag = NextTagItem( &tstate ); )
			if( tag->ti_Tag == DA_Member )
				if( member = (DialogElement *)tag->ti_Data )
					structure &= getDialogElementStructure( member );
	return structure;
}

static VOID setupHStack( DialogElement *de )
{
	struct TagItem *tstate, *tag;
	DialogElement *member;
	LONG mintop, minbottom, minheight, maxtop, maxbottom, maxheight;

	if( !de )
		return;

	/* determine structure */
	de->structure = getDialogElementStructure( de );

	setMinWidth( de, 0 );			/* modified later */
	setMaxWidth( de, MAX_SPACE );
	if( de->structure & DESF_HBaseline )
	{
		setMinTopExtent( de, 0 );
		setMinBottomExtent( de, 0 );
		setMaxTopExtent( de, 0 );
		setMaxBottomExtent( de, 0 );
	}
	else
	{
		setMinHeight( de, 0 );
		setMaxHeight( de, 0 );
	}

	for( tstate = de->taglist; tag = NextTagItem( &tstate ); )
		if( tag->ti_Tag == DA_Member )
			if( member = (DialogElement *)tag->ti_Data )
			{
				ULONG substructure;

				setupDialogElement( member );
				de->idcmp_mask |= member->idcmp_mask;
				substructure = getDialogElementStructure( member );

				/* modify Min/MaxWidth to accomodate member */
				if( substructure & DESF_VBaseline )
					setMinWidth( de, getMinWidth( de ) +
						getMinLeftExtent( member ) + getMinRightExtent( member ) );
				else
					setMinWidth( de, getMinWidth( de ) + getMinWidth( member ) );

				/* modify Min/MaxHeight or Min/MaxTop/BottomExtent to accomodate member */
				if( substructure & DESF_HBaseline )
				{
					mintop = getMinTopExtent( member );
					minbottom = getMinBottomExtent( member );
					maxtop = getMaxTopExtent( member );
					maxbottom = getMaxBottomExtent( member );
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
					minheight = getMinHeight( member );
					maxheight = getMaxHeight( member );
					if( minheight > getMinHeight( de ) )
						setMinHeight( de, minheight );
					if( maxheight > getMaxHeight( de ) )
						setMaxHeight( de, maxheight );
				}
			}
}

static ULONG layoutHStack( DialogElement *de, LayoutMessage *lm )
{
	struct TagItem *tstate, *tag;
	DialogElement *member;
	LayoutMessage message;
	LONG count, maxwidth, minwidth, x, white, spare;
	LONG left, right, width;
	ULONG substructure, error = DIALOGERR_OK;

	if( !de )
		return DIALOGERR_BAD_ARGS;
	if( !lm )
		return DIALOGERR_BAD_ARGS;

#ifdef DEBUG1
	printf(
	"layoutHStack : x %d, y %d, width %d, height %d, left %d, right %d, top %d, bottom %d\n",
		lm->lm_X, lm->lm_Y, lm->lm_Width, lm->lm_Height,
		lm->lm_Left, lm->lm_Right, lm->lm_Top, lm->lm_Bottom );
#endif

	x = lm->lm_X;
	count = maxwidth = minwidth = 0;
	for( tstate = de->taglist; tag = NextTagItem( &tstate ); )
		if( tag->ti_Tag == DA_Member )
			if( member = (DialogElement *)tag->ti_Data )
			{
				substructure = getDialogElementStructure( member );
				if( substructure & DESF_VBaseline )
				{
					minwidth += getMinLeftExtent( member ) + getMinRightExtent( member );
					maxwidth += getMaxLeftExtent( member ) + getMaxRightExtent( member );
				}
				else
				{
					minwidth += getMinWidth( member );
					maxwidth += getMaxWidth( member );
				}
				count++;
			}
	spare = maxwidth - minwidth;
	white = lm->lm_Width - minwidth;
#ifdef DEBUG1
	printf( "layoutHStack : white %d\n", white );
#endif
	if( white >= spare )	/* extend all members to their maximal horizontal size */
	{
		for( tstate = de->taglist; tag = NextTagItem( &tstate ); )
			if( tag->ti_Tag == DA_Member )
				if( member = (DialogElement *)tag->ti_Data )
				{
					substructure = prepareMemberLayoutV( &message, de, member, lm );
					if( substructure & DESF_VBaseline )
					{
						left = getMaxLeftExtent( member );
						right = getMaxRightExtent( member );
						prepareLayoutVBaseline( &message, left, right );
						x += left;
					}
					else
					{
						width = getMaxWidth( member );
						prepareLayoutNoVBaseline( &message, width );
					}
					prepareLayoutX( &message, x );
					error = layoutDialogElement( member, &message, lm->lm_PreviousPtr );
					if( error )
						break;
					if( count > 1 )
						x += white / ( count - 1 );
					if( substructure & DESF_VBaseline )
						x += getMaxRightExtent( member );
					else
						x += getMaxWidth( member );
				}
	}
	else
	{
		for( tstate = de->taglist; tag = NextTagItem( &tstate ); )
			if( tag->ti_Tag == DA_Member )
				if( member = (DialogElement *)tag->ti_Data )
				{
					substructure = prepareMemberLayoutV( &message, de, member, lm );
					if( substructure & DESF_VBaseline )
					{
						LONG minleft, minright;

						minleft = getMinLeftExtent( member );
						minright = getMinRightExtent( member );
						left = getMaxLeftExtent( member ) - minleft;
						left = minleft + ( ( spare ) ? ( left * white ) / spare : 0 );
						right = getMaxRightExtent( member ) - minright;
						right = minright + ( ( spare ) ? ( right * white ) / spare : 0 );
						prepareLayoutVBaseline( &message, left, right );
						x += left;
					}
					else
					{
						LONG minwidth;

						minwidth = getMinWidth( member );
						width = getMaxWidth( member ) - minwidth;
						width = minwidth + ( ( spare ) ? ( width * white ) / spare : 0 );
						prepareLayoutNoVBaseline( &message, width );
					}
					prepareLayoutX( &message, x );
					error = layoutDialogElement( member, &message, lm->lm_PreviousPtr );
					if( error )
						break;
					if( substructure & DESF_VBaseline )
						x += right;
					else
						x += width;
				}
	}
	return error;
}

static DialogElement *matchHStack( DialogElement *de, MatchMessage *mm )
{
	struct TagItem *tstate, *tag;
	DialogElement *member, *match = NULL;

	if( !de )
		return NULL;
	if( !mm )
		return NULL;

	for( tstate = de->taglist; tag = NextTagItem( &tstate ); )
		if( tag->ti_Tag == DA_Member )
			if( member = (DialogElement *)tag->ti_Data )
				if( match = mapDialogEvent( member, mm->mm_IntuiMsg ) )
					break;
	return match;
}

static VOID clearHStack( DialogElement *de )
{
	struct TagItem *tstate, *tag;
	DialogElement *member;

	if( !de )
		return;

	for( tstate = de->taglist; tag = NextTagItem( &tstate ); )
		if( tag->ti_Tag == DA_Member )
			if( member = (DialogElement *)tag->ti_Data )
				clearDialogElement( member );
}

ULONG dispatchHStack( struct Hook *hook, DialogElement *de, DialogMessage *dm )
{
	ULONG result;

	switch( dm->dm_MethodID )
	{
	case DIALOGM_GETSTRUCT:
		result = getHStackStructure( de );
		break;
	case DIALOGM_SETUP:
		setupHStack( de );
		break;
	case DIALOGM_LAYOUT:
		result = layoutHStack( de, (LayoutMessage *)dm );
		break;
	case DIALOGM_MATCH:
		result = (ULONG)matchHStack( de, (MatchMessage *)dm );
		break;
	case DIALOGM_CLEAR:
		clearHStack( de );
		break;
	}
	return result;
}
