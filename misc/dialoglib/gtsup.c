#include <proto/gadtools.h>
#include "dialog.h"
#include "gtsup.h"

VOID setGTAttrs( DialogElement *de, SetAttrsMessage *sam )
{
	GT_SetGadgetAttrsA( de->object, sam->sam_Window, sam->sam_Requester, de->taglist );
}

ULONG getTextPlacement( ULONG flags, ULONG def_place )
{
	ULONG place;

	flags &= PLACETEXT_MASK;
	switch( flags )
	{
	case PLACETEXT_IN:
	case PLACETEXT_LEFT:
	case PLACETEXT_RIGHT:
	case PLACETEXT_ABOVE:
	case PLACETEXT_BELOW:
		place = flags;
		break;
	default:
		place = def_place;
		break;
	}
	return place;
}

VOID layoutGTSingleLined( struct NewGadget *ng, LayoutMessage *lm, ULONG defplace )
{
	ng->ng_LeftEdge = lm->lm_X;
	ng->ng_TopEdge = lm->lm_Y;
	switch( getTextPlacement( ng->ng_Flags, defplace ) )
	{
	case PLACETEXT_LEFT:
		ng->ng_TopEdge -= lm->lm_Top;
		ng->ng_Width = lm->lm_Right;
		ng->ng_Height = lm->lm_Top + lm->lm_Bottom;
		break;
	case PLACETEXT_RIGHT:
		ng->ng_LeftEdge -= lm->lm_Left;
		ng->ng_TopEdge -= lm->lm_Top;
		ng->ng_Width = lm->lm_Left;
		ng->ng_Height = lm->lm_Top + lm->lm_Bottom;
		break;
	case PLACETEXT_ABOVE:
		ng->ng_Width = lm->lm_Width;
		ng->ng_Height = lm->lm_Bottom;
		break;
	case PLACETEXT_BELOW:
		ng->ng_TopEdge -= lm->lm_Top;
		ng->ng_Width = lm->lm_Width;
		ng->ng_Height = lm->lm_Top;
		break;
	case PLACETEXT_IN:
		ng->ng_TopEdge -= lm->lm_Top;
		ng->ng_Width = lm->lm_Width;
		ng->ng_Height = lm->lm_Top + lm->lm_Bottom;
		break;
	}
}
