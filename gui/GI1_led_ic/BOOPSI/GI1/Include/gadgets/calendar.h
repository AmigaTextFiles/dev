#ifndef	GADGETS_CALENDAR_H
#define	GADGETS_CALENDAR_H

/*
**	$VER: calendar.h 42.3 (14.2.94)
**	Includes Release 42.1
**
**	Definitions for the calendar BOOPSI gadget class
**
**	(C) Copyright 1994 Commodore-Amiga Inc.
**	All Rights Reserved
*/

/*****************************************************************************/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef UTILITY_DATE_H
#include <utility/date.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef INTUITION_GADGETCLASS_H
#include <intuition/gadgetclass.h>
#endif

/*****************************************************************************/

#define	DL_TEXTPEN		0
#define	DL_BACKGROUNDPEN	1
#define	DL_FILLTEXTPEN		2
#define	DL_FILLPEN		3
#define	MAX_DL_PENS		4

/*****************************************************************************/

/* This structure is used to describe the days of the month */
typedef struct tagDayLabel
{
    STRPTR		 dl_Label;		/* Label */
    WORD		 dl_Pens[MAX_DL_PENS];	/* Pens */
    struct TagItem	*dl_Attrs;		/* Additional attributes */
    ULONG		 dl_Flags;		/* Control flags */

} DayLabel, *DayLabelP;

/*****************************************************************************/

#define	DLF_SELECTED	(1L<<0)
#define	DLF_DISABLED	(1L<<1)

/*****************************************************************************/

/* Additional attributes defined by the calendar.gadget class */
#define CALENDAR_Dummy		(TAG_USER+0x04000000)

#define	CALENDAR_Day		(CALENDAR_Dummy+1)
    /* (LONG) Day of the week */

#define	CALENDAR_ClockData	(CALENDAR_Dummy+2)
    /* (struct ClockData *) defining clock data */

#define CALENDAR_FirstWeekday	(CALENDAR_Dummy+3)
    /* (LONG) First day of the week.  Default is 0 for Sunday. */

#define	CALENDAR_Days		(CALENDAR_Dummy+4)
    /* (STRPTR *) Text for days of the week */

#define	CALENDAR_Multiselect	(CALENDAR_Dummy+5)
    /* (BOOL) Can more than one day be selected at a time.  Defaults
     * to FALSE. */

#define	CALENDAR_Labels		(CALENDAR_Dummy+6)
    /* (DayLabelP) Array of labels for the days of the month.  Optional,
     * but if provided, must be an array of 31 entries. */

#define	CALENDAR_Label		(CALENDAR_Dummy+7)
    /* (BOOL) Indicate whether there should be a label across the top
     * showing the names of the days of the week.  Defaults to TRUE. */

/*****************************************************************************/

#endif /* GADGETS_CALENDAR_H */
