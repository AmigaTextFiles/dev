#include <libraries/gadtools.h>
#include <proto/utility.h>
#include "dialog.h"
#ifdef DEBUG1
	#include <stdio.h>
#endif

static VOID setupHBumper( DialogElement *de )
{
	LONG width;

	if( !de )
		return;
	if( !de->root )
		return;

	width = GetTagData( DA_XSpacing, INTERWIDTH, de->root->taglist );
	setMinWidth( de, width );
	setMaxWidth( de, width );
	setMinTopExtent( de, 0 );
	setMaxTopExtent( de, 0 );
	setMinBottomExtent( de, 0 );
	setMaxBottomExtent( de, 0 );
}

#ifdef DEBUG1
VOID debug_layoutHBumper( DialogElement *de, LayoutMessage *lm )
{
	printf(
	"layoutHBumper : x %d, y %d, width %d, height %d, left %d, right %d, top %d, bottom %d\n",
		lm->lm_X, lm->lm_Y, lm->lm_Width, lm->lm_Height,
		lm->lm_Left, lm->lm_Right, lm->lm_Top, lm->lm_Bottom );
}
#endif

ULONG dispatchHBumper( struct Hook *hook, DialogElement *de, DialogMessage *dm )
{
	ULONG result;

	switch( dm->dm_MethodID )
	{
	case DIALOGM_GETSTRUCT:
		result = DESF_HBaseline;
		break;
	case DIALOGM_SETUP:
		setupHBumper( de );
		break;
	case DIALOGM_LAYOUT:
#ifdef DEBUG1
		debug_layoutHBumper( de, (LayoutMessage *)dm );
#endif
		result = DIALOGERR_OK;
		break;
	case DIALOGM_MATCH:
		result = 0;
		break;
	case DIALOGM_CLEAR:
		break;
	}
	return result;
}
