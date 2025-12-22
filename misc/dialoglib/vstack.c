#include <clib/macros.h>
#include <proto/utility.h>
#include "dialog.h"
#ifdef DEBUG1
	#include <stdio.h>
#endif

/* filters for structure flag common among all members */
static ULONG getVStackStructure( DialogElement *de )
{
	struct TagItem *tstate, *tag;
	DialogElement *member;
	ULONG structure = DESF_VBaseline;

	if( !de )
		return 0;

	/* a vstack can only have a vertical baseline if the members are centered */
	if( GetTagData( DA_Alignment, 0, de->taglist ) )
		structure = 0;
	else
		for( tstate = de->taglist; tag = NextTagItem( &tstate ); )
			if( tag->ti_Tag == DA_Member )
				if( member = (DialogElement *)tag->ti_Data )
					structure &= getDialogElementStructure( member );
	return structure;
}

static VOID setupVStack( DialogElement *de )
{
	struct TagItem *tstate, *tag;
	DialogElement *member;
	LONG minleft, minright, minwidth, maxleft, maxright, maxwidth;

	if( !de )
		return;

	/* determine structure */
	de->structure = getDialogElementStructure( de );

	setMinHeight( de, 0 );			/* modified later */
	setMaxHeight( de, MAX_SPACE );
	if( de->structure & DESF_VBaseline )
	{
		setMinLeftExtent( de, 0 );
		setMinRightExtent( de, 0 );
		setMaxLeftExtent( de, 0 );
		setMaxRightExtent( de, 0 );
	}
	else
	{
		setMinWidth( de, 0 );
		setMaxWidth( de, 0 );
	}

	for( tstate = de->taglist; tag = NextTagItem( &tstate ); )
		if( tag->ti_Tag == DA_Member )
			if( member = (DialogElement *)tag->ti_Data )
			{
				ULONG substructure;

				setupDialogElement( member );
				de->idcmp_mask |= member->idcmp_mask;
				substructure = getDialogElementStructure( member );

				/* modify Min/MaxHeight to accomodate member */
				if( substructure & DESF_HBaseline )
					setMinHeight( de, getMinHeight( de ) +
						getMinTopExtent( member ) + getMinBottomExtent( member ) );
				else
					setMinHeight( de, getMinHeight( de ) + getMinHeight( member ) );

				/* modify Min/MaxWidth or Min/MaxLeft/RightExtent to accomodate member */
				if( substructure & DESF_VBaseline )
				{
					minleft = getMinLeftExtent( member );
					minright = getMinRightExtent( member );
					maxleft = getMaxLeftExtent( member );
					maxright = getMaxRightExtent( member );
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
					minwidth = getMinWidth( member );
					maxwidth = getMaxWidth( member );
					if( minwidth > getMinWidth( de ) )
						setMinWidth( de, minwidth );
					if( maxwidth > getMaxWidth( de ) )
						setMaxWidth( de, maxwidth );
				}
			}
}

static ULONG layoutVStack( DialogElement *de, LayoutMessage *lm )
{
	struct TagItem *tstate, *tag;
	DialogElement *member;
	LayoutMessage message;
	LONG count, minheight, maxheight, spare, y, white;
	LONG top, bottom, height;
	ULONG substructure, error = DIALOGERR_OK;

	if( !de )
		return DIALOGERR_BAD_ARGS;
	if( !lm )
		return DIALOGERR_BAD_ARGS;

#ifdef DEBUG1
	printf(
	"layoutVStack : x %d, y %d, width %d, height %d, left %d, right %d, top %d, bottom %d\n",
		lm->lm_X, lm->lm_Y, lm->lm_Width, lm->lm_Height,
		lm->lm_Left, lm->lm_Right, lm->lm_Top, lm->lm_Bottom );
#endif

	y = lm->lm_Y;
	count = maxheight = minheight = 0;
	for( tstate = de->taglist; tag = NextTagItem( &tstate ); )
		if( tag->ti_Tag == DA_Member )
			if( member = (DialogElement *)tag->ti_Data )
			{
				substructure = getDialogElementStructure( member );
				if( substructure & DESF_HBaseline )
				{
					minheight += getMinTopExtent( member ) + getMinBottomExtent( member );
					maxheight += getMaxTopExtent( member ) + getMaxBottomExtent( member );
				}
				else
				{
					minheight += getMinHeight( member );
					maxheight += getMaxHeight( member );
				}
				count++;
			}
	spare = maxheight - minheight;
	white = lm->lm_Height - minheight;
#ifdef DEBUG1
	printf( "layoutVStack : white %d\n", white );
#endif
	if( white >= spare )	/* extend all members to their maximal vertical size */
	{
		for( tstate = de->taglist; tag = NextTagItem( &tstate ); )
			if( tag->ti_Tag == DA_Member )
				if( member = (DialogElement *)tag->ti_Data )
				{
					substructure = prepareMemberLayoutH( &message, de, member, lm );
					if( substructure & DESF_HBaseline )
					{
						top = getMaxTopExtent( member );
						bottom = getMaxBottomExtent( member );
						prepareLayoutHBaseline( &message, top, bottom );
						y += top;
#ifdef DEBUG1
	printf( "layoutVStack : top %d, bottom %d\n", top, bottom );
#endif
					}
					else
					{
						height = getMaxHeight( member );
						prepareLayoutNoHBaseline( &message, height );
					}
					prepareLayoutY( &message, y );
					error = layoutDialogElement( member, &message, lm->lm_PreviousPtr );
					if( error )
						break;
					if( count > 1 )
						y += white / ( count - 1 );
					if( substructure & DESF_HBaseline )
						y += bottom;
					else
						y += height;
				}
	}
	else
	{
		for( tstate = de->taglist; tag = NextTagItem( &tstate ); )
			if( tag->ti_Tag == DA_Member )
				if( member = (DialogElement *)tag->ti_Data )
				{
					substructure = prepareMemberLayoutH( &message, de, member, lm );
					if( substructure & DESF_HBaseline )
					{
						LONG mintop, minbottom;

						mintop = getMinTopExtent( member );
						minbottom = getMinBottomExtent( member );
						top = getMaxTopExtent( member ) - mintop;
						top = mintop + ( ( spare ) ? ( top * white ) / spare : 0 );
						bottom = getMaxBottomExtent( member ) - minbottom;
						bottom = minbottom + ( ( spare ) ? ( bottom * white ) / spare : 0 );
						prepareLayoutHBaseline( &message, top, bottom );
						y += top;
					}
					else
					{
						LONG minheight;

						minheight = getMinHeight( member );
						height = getMaxHeight( member ) - minheight;
						height = minheight + ( ( spare ) ? ( height * white ) / spare : 0 );
						prepareLayoutNoHBaseline( &message, height );
					}
					prepareLayoutY( &message, y );
					error = layoutDialogElement( member, &message, lm->lm_PreviousPtr );
					if( error )
						break;
					if( substructure & DESF_HBaseline )
						y += bottom;
					else
						y += height;
				}
	}
	return error;
}

static DialogElement *matchVStack( DialogElement *de, MatchMessage *mm )
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

static VOID clearVStack( DialogElement *de )
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

ULONG dispatchVStack( struct Hook *hook, DialogElement *de, DialogMessage *dm )
{
	ULONG result;

	switch( dm->dm_MethodID )
	{
	case DIALOGM_GETSTRUCT:
		result = getVStackStructure( de );
		break;
	case DIALOGM_SETUP:
		setupVStack( de );
		break;
	case DIALOGM_LAYOUT:
		result = layoutVStack( de, (LayoutMessage *)dm );
		break;
	case DIALOGM_MATCH:
		result = (ULONG)matchVStack( de, (MatchMessage *)dm );
		break;
	case DIALOGM_CLEAR:
		clearVStack( de );
		break;
	}
	return result;
}
