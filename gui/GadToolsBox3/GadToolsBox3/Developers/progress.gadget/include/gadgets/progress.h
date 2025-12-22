#ifndef GADGETS_PROGRESS_H
#define GADGETS_PROGRESS_H
/*
**	$VER: progress.h 37.0 (13.2.96)
**
**	Definitions for the progress BOOPSI class
**
**	(C) Copyright 1996 Tomasz Muszynski.
**	All Rights Reserved
*/

/*****************************************************************************/


#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif


/*****************************************************************************/

#define PROGRESSNAME "gadgets/progress.gadget"
#define PROGRESSVERSION 37


#define PROG_Dummy		(TAG_USER+0x00001000)
#define PROG_MaxVal		(PROG_Dummy+1)
#define PROG_CurVal		(PROG_Dummy+2)
#define PROG_TextFont		(PROG_Dummy+3)
#define PROG_ConvertToPercents		(PROG_Dummy+4)
#define PROG_Format		(PROG_Dummy+5)
#define PROG_Border		(PROG_Dummy+6)
#define PROG_Placement		(PROG_Dummy+7)


/*****************************************************************************/


#endif /* GADGETS_PROGRESS_H */
