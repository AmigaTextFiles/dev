#include <intuition/intuition.h>
#include <proto/utility.h>
#include <clib/macros.h>
#include "dialog.h"
#ifdef DEBUG1
	#include <stdio.h>
#endif

typedef ULONG (*Callback)();
VOID SetupHook( struct Hook *, Callback, VOID * );
ULONG CallHook( struct Hook *, APTR, ... );
ULONG CallHookA( struct Hook *, APTR, APTR );

VOID setMaxWidth( DialogElement *de, LONG space )
{
	de->maxWidth = MIN( space, MAX_SPACE );
}

VOID setMaxHeight( DialogElement *de, LONG space )
{
	de->maxHeight = MIN( space, MAX_SPACE );
}

VOID setMaxLeftExtent( DialogElement *de, LONG space )
{
	de->maxLeftExtent = MIN( space, MAX_SPACE );
}

VOID setMaxRightExtent( DialogElement *de, LONG space )
{
	de->maxRightExtent = MIN( space, MAX_SPACE );
}

VOID setMaxTopExtent( DialogElement *de, LONG space )
{
	de->maxTopExtent = MIN( space, MAX_SPACE );
}

VOID setMaxBottomExtent( DialogElement *de, LONG space )
{
	de->maxBottomExtent = MIN( space, MAX_SPACE );
}

VOID setMinWidth( DialogElement *de, LONG space )
{
	de->minWidth = MIN( space, MAX_SPACE );
}

VOID setMinHeight( DialogElement *de, LONG space )
{
	de->minHeight = MIN( space, MAX_SPACE );
}

VOID setMinLeftExtent( DialogElement *de, LONG space )
{
	de->minLeftExtent = MIN( space, MAX_SPACE );
}

VOID setMinRightExtent( DialogElement *de, LONG space )
{
	de->minRightExtent = MIN( space, MAX_SPACE );
}

VOID setMinTopExtent( DialogElement *de, LONG space )
{
	de->minTopExtent = MIN( space, MAX_SPACE );
}

VOID setMinBottomExtent( DialogElement *de, LONG space )
{
	de->minBottomExtent = MIN( space, MAX_SPACE );
}

LONG getMinWidth( DialogElement *de )
{
	return de->minWidth;
}

LONG getMinHeight( DialogElement *de )
{
	return de->minHeight;
}

LONG getMinLeftExtent( DialogElement *de )
{
	return de->minLeftExtent;
}

LONG getMinRightExtent( DialogElement *de )
{
	return de->minRightExtent;
}

LONG getMinTopExtent( DialogElement *de )
{
	return de->minTopExtent;
}

LONG getMinBottomExtent( DialogElement *de )
{
	return de->minBottomExtent;
}

LONG getMaxWidth( DialogElement *de )
{
	return de->maxWidth;
}

LONG getMaxHeight( DialogElement *de )
{
	return de->maxHeight;
}

LONG getMaxLeftExtent( DialogElement *de )
{
	return de->maxLeftExtent;
}

LONG getMaxRightExtent( DialogElement *de )
{
	return de->maxRightExtent;
}

LONG getMaxTopExtent( DialogElement *de )
{
	return de->maxTopExtent;
}

LONG getMaxBottomExtent( DialogElement *de )
{
	return de->maxBottomExtent;
}

VOID initDialogElementA( DialogElement *de, DialogElement *root, DialogCallback dc,
	ULONG *error, struct TagItem *taglist )
{
	if( !de )
		return;

	de->object = NULL;
	de->taglist = NULL;

	if( *error != DIALOGERR_NO_ERROR )
		return;

	de->taglist = CloneTagItems( taglist );
	if( !de->taglist )
	{
		*error = DIALOGERR_NO_MEMORY;
		return;
	}
	SetupHook( &de->hook, (Callback)dc, de );
	setMinWidth( de, 0 );
	setMinHeight( de, 0 );
	setMinLeftExtent( de, 0 );
	setMinRightExtent( de, 0 );
	setMinTopExtent( de, 0 );
	setMinBottomExtent( de, 0 );
	setMaxWidth( de, MAX_SPACE );
	setMaxHeight( de, MAX_SPACE );
	setMaxLeftExtent( de, MAX_SPACE );
	setMaxRightExtent( de, MAX_SPACE );
	setMaxTopExtent( de, MAX_SPACE );
	setMaxBottomExtent( de, MAX_SPACE );
	de->root = root;
}

VOID initDialogElement( DialogElement *de, DialogElement *root, DialogCallback dc,
	ULONG *error, ULONG first, ... )
{
	initDialogElementA( de, root, dc, error, (struct TagItem *)&first );
}

VOID cleanupDialogElement( DialogElement *de )
{
	if( !de )
		return;

	if( de->taglist )
		FreeTagItems( de->taglist );
}

VOID setupDialogElement( DialogElement *de )
{
	if( !de )
		return;

	de->idcmp_mask = GetTagData( DA_MatchEventClasses, 0, de->taglist );
	CallHook( &de->hook, de, DIALOGM_SETUP );
#ifdef DEBUG1
	printf( "setupDialogElement : "
	"de %08lx, min width %d, height %d, left %d, right %d, top %d, bottom %d\n",
		de,
		getMinWidth( de ),
		getMinHeight( de ),
		getMinLeftExtent( de ),
		getMinRightExtent( de ),
		getMinTopExtent( de ),
		getMinBottomExtent( de ) );
#endif
}

ULONG getDialogElementStructure( DialogElement *de )
{
	if( !de )
		return 0;

	return CallHook( &de->hook, de, DIALOGM_GETSTRUCT );
}

VOID prepareLayoutX( LayoutMessage *lm, LONG x )
{
	if( !lm )
		return;

	lm->lm_X = x;
}

VOID prepareLayoutY( LayoutMessage *lm, LONG y )
{
	if( !lm )
		return;

	lm->lm_Y = y;
}

VOID prepareLayoutHBaseline( LayoutMessage *lm, LONG top, LONG bottom )
{
	if( !lm )
		return;

	lm->lm_Top = top;
	lm->lm_Bottom = bottom;
}

VOID prepareLayoutNoHBaseline( LayoutMessage *lm, LONG height )
{
	if( !lm )
		return;

	lm->lm_Height = height;
}

VOID prepareLayoutVBaseline( LayoutMessage *lm, LONG left, LONG right )
{
	if( !lm )
		return;

	lm->lm_Left = left;
	lm->lm_Right = right;
}

VOID prepareLayoutNoVBaseline( LayoutMessage *lm, LONG width )
{
	if( !lm )
		return;

	lm->lm_Width = width;
}

ULONG layoutDialogElement( DialogElement *de, LayoutMessage *lm, APTR prevptr )
{
	ULONG error;

	if( !de )
		return DIALOGERR_BAD_ARGS;
	if( !lm )
		return DIALOGERR_BAD_ARGS;

	lm->lm_MethodID = DIALOGM_LAYOUT;
	lm->lm_PreviousPtr = prevptr;
	error = CallHookA( &de->hook, de, lm );
	return error;
}

VOID clearDialogElement( DialogElement *de )
{
	if( !de )
		return;

	CallHook( &de->hook, de, DIALOGM_CLEAR );
}

static ULONG matchSpecialEvent( DialogElement *de, struct IntuiMessage *imsg )
{
	if( !de )
		return 0;

	return imsg->Class & GetTagData( DA_MatchEventClasses, 0, de->taglist );
}

DialogElement *mapDialogEvent( DialogElement *de, struct IntuiMessage *imsg )
{
	DialogElement *match = NULL;

	if( matchSpecialEvent( de, imsg ) )
		match = de;
	else
		match = (DialogElement *)CallHook( &de->hook, de, DIALOGM_MATCH, imsg );

	return match;
}

static LONG countComplementA( struct TagItem *list, struct TagItem *set )
{
	struct TagItem *tag, *tstate;
	LONG count;

	count = 0;
	tstate = list;
	while( tag = NextTagItem( &tstate ) )
		if( !FindTagItem( tag->ti_Tag, set ) )
			count++;
	return count;
}

static LONG countComplement( struct TagItem *list, ULONG first )
{
	return countComplementA( list, (struct TagItem *)&first );
}

ULONG setDialogElementAttrsA( DialogElement *de,
	struct Window *window, struct Requester *requester, struct TagItem *taglist )
{
	struct TagItem *tag, *old, *update, *new, *tstate;
	LONG count;
	ULONG result = FALSE;

	/* determine number of items in new (combined) tag list */
	count = countComplement( de->taglist, TAG_DONE ) +
			countComplementA( taglist, de->taglist );

	/* allocate new tag list */
	new = AllocateTagItems( count );
	if( !new )
		goto termination;

	/* now merge old and new list together */
	tag = new;
	tstate = de->taglist;
	while( old = NextTagItem( &tstate ) )
	{
		tag->ti_Tag = old->ti_Tag;
		if( update = FindTagItem( old->ti_Tag, taglist ) )
			tag->ti_Data = update->ti_Data;
		else
			tag->ti_Data = old->ti_Data;
		tag++;
	}
	FreeTagItems( de->taglist );
	de->taglist = new;
	CallHook( &de->hook, de, DIALOGM_SETATTRS, window, requester );
	result = TRUE;
termination:
	return result;
}

ULONG setDialogElementAttrs( DialogElement *de,
	struct Window *window, struct Requester *requester, ULONG firsttag, ... )
{
	return setDialogElementAttrsA( de, window, requester, (struct TagItem *)&firsttag );
}

ULONG prepareMemberLayoutH( LayoutMessage *message,
	DialogElement *de, DialogElement *member, LayoutMessage *lm )
{
	ULONG substructure;
	LONG alignment, x, left, right, width;

	if( !de )
		return 0;
	if( !lm )
		return 0;

	alignment = GetTagData( DA_Alignment, 0, de->taglist );

	x = lm->lm_X;
	substructure = getDialogElementStructure( member );
	if( substructure & DESF_VBaseline )
	{
		if( de->structure & DESF_VBaseline )
		{
			left = getMaxLeftExtent( member );
			left = MIN( lm->lm_Left, left );
			right = getMaxRightExtent( member );
			right = MIN( lm->lm_Right, right );
		}
		else
		{
			LONG minleft, minright, spare, white;

			minleft = getMinLeftExtent( member );
			minright = getMinRightExtent( member );
			white = lm->lm_Width - minleft - minright;
			left = getMaxLeftExtent( member ) - minleft;
			right = getMaxRightExtent( member ) - minright;
			spare = left + right;
			if( white > spare )
				white = spare;
			left = minleft + ( ( spare ) ? ( left * white ) / spare : 0 );
			right = minright + ( ( spare ) ? ( right * white ) / spare : 0 );
			switch( alignment )
			{
			case -1:
				x += left;
				break;
			case 0:
				x += ( lm->lm_Width + left - right ) / 2;
				break;
			case +1:
				x += lm->lm_Width - right;
				break;
			}
		}
		prepareLayoutVBaseline( message, left, right );
	}
	else
	{
		width = getMaxWidth( member );
		width = MIN( lm->lm_Width, width );
		prepareLayoutNoVBaseline( message, width );
		switch( alignment )
		{
		case -1:
			break;
		case 0:
			x += ( lm->lm_Width - width ) / 2;
			break;
		case +1:
			x += lm->lm_Width - width;
			break;
		}
	}
	prepareLayoutX( message, x );
	return substructure;
}

ULONG prepareMemberLayoutV( LayoutMessage *message,
	DialogElement *de, DialogElement *member, LayoutMessage *lm )
{
	ULONG substructure;
	LONG alignment, y, top, bottom, height;

	if( !de )
		return 0;
	if( !lm )
		return 0;

	alignment = GetTagData( DA_Alignment, 0, de->taglist );

	y = lm->lm_Y;
	substructure = getDialogElementStructure( member );
	if( substructure & DESF_HBaseline )
	{
		if( de->structure & DESF_HBaseline )
		{
			top = getMaxTopExtent( member );
			top = MIN( lm->lm_Top, top );
			bottom = getMaxBottomExtent( member );
			bottom = MIN( lm->lm_Bottom, bottom );
		}
		else
		{
			LONG mintop, minbottom, spare, white;

			mintop = getMinTopExtent( member );
			minbottom = getMinBottomExtent( member );
			white = lm->lm_Height - mintop - minbottom;
			top = getMaxTopExtent( member ) - mintop;
			bottom = getMaxBottomExtent( member ) - minbottom;
			spare = top + bottom;
			if( white > spare )
				white = spare;
			top = mintop + ( ( spare ) ? ( top * white ) / spare : 0 );
			bottom = minbottom + ( ( spare ) ? ( bottom * white ) / spare : 0 );
			switch( alignment )
			{
			case -1:
				y += top;
				break;
			case 0:
				y += ( lm->lm_Height + top - bottom ) / 2;
				break;
			case +1:
				y += lm->lm_Height - bottom;
				break;
			}
		}
		prepareLayoutHBaseline( message, top, bottom );
	}
	else
	{
		height = getMaxHeight( member );
		height = MIN( lm->lm_Height, height );
		prepareLayoutNoHBaseline( message, height );
		switch( alignment )
		{
		case -1:
			break;
		case 0:
			y += ( lm->lm_Height - height ) / 2;
			break;
		case +1:
			y += lm->lm_Height - height;
			break;
		}
	}
	prepareLayoutY( message, y );
	return substructure;
}
