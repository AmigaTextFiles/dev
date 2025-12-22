#include <libraries/gadtools.h>
#include <proto/utility.h>
#include "dialog.h"
#ifdef DEBUG1
	#include <stdio.h>
#endif

static VOID setupVSpring( DialogElement *de )
{
	if( !de )
		return;

	setMinLeftExtent( de, 0 );
	setMaxLeftExtent( de, 0 );
	setMinRightExtent( de, 0 );
	setMaxRightExtent( de, 0 );
	setMinHeight( de, 0 );
	setMaxHeight( de, MAX_SPACE );
}

#ifdef DEBUG1
VOID debug_layoutVSpring( DialogElement *de, LayoutMessage *lm )
{
	printf(
	"layoutVSpring : x %d, y %d, width %d, height %d, left %d, right %d, top %d, bottom %d\n",
		lm->lm_X, lm->lm_Y, lm->lm_Width, lm->lm_Height,
		lm->lm_Left, lm->lm_Right, lm->lm_Top, lm->lm_Bottom );
}
#endif

ULONG dispatchVSpring( struct Hook *hook, DialogElement *de, DialogMessage *dm )
{
	ULONG result;

	switch( dm->dm_MethodID )
	{
	case DIALOGM_GETSTRUCT:
		result = DESF_VBaseline;
		break;
	case DIALOGM_SETUP:
		setupVSpring( de );
		break;
	case DIALOGM_LAYOUT:
#ifdef DEBUG1
		debug_layoutVSpring( de, (LayoutMessage *)dm );
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
