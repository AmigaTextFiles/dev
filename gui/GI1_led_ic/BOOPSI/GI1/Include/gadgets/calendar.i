	IFND	GADGETS_CALENDAR_I
GADGETS_CALENDAR_I	SET	1

**
**	$VER: calendar.i 42.1 (10.1.94)
**	Includes Release 42.1
**
**	Definitions for the calendar BOOPSI class
**
**	(C) Copyright 1994 Commodore-Amiga Inc.
**	All Rights Reserved
**

;*****************************************************************************

    IFND EXEC_TYPES_I
    INCLUDE "exec/types.i"
    ENDC

    IFND UTILITY_DATE_H
    INCLUDE "utility/date.i"
    ENDC

    IFND UTILITY_TAGITEM_H
    INCLUDE "utility/tagitem.i"
    ENDC

    IFND INTUITION_GADGETCLASS_I
    INCLUDE "intuition/gadgetclass.i"
    ENDC

;*****************************************************************************

DL_TEXTPEN		equ	0
DL_BACKGROUNDPEN	equ	1
DL_FILLTEXTPEN		equ	2
DL_FILLPEN		equ	3
MAX_DL_PENS		equ	4

;*****************************************************************************

; This structure is used to describe the days of the month
    STRUCTURE DayLabel,0
	APTR	 dl_Label			; Label
	STRUCT	 dl_Pens,(MAX_DL_PENS*2)	; Pens (array of UWORD's)
	APTR	 dl_Attrs			; Additional attributes
	ULONG	 dl_Flags			; Control flags

    LABEL DayLabel_SIZEOF

;*****************************************************************************

    BITDEF	DL,SELECTED,1				; Day selected
    BITDEF	DL,DISABLED,2				; Day disabled

;*****************************************************************************

; Additional attributes defined by the calendar.gadget class
CALENDAR_Dummy		equ	(TAG_USER+$4000000)

CALENDAR_Day		equ	(CALENDAR_Dummy+1)
    ; (LONG) Day of the week

CALENDAR_ClockData	equ	(CALENDAR_Dummy+2)
    ; (struct ClockData *) defining clock data

CALENDAR_FirstWeekday	equ	(CALENDAR_Dummy+3)
    ; (LONG) First day of the week.  Default is 0 for Sunday.

CALENDAR_Days		equ	(CALENDAR_Dummy+4)
    ; (STRPTR *) Text for days of the week

CALENDAR_Multiselect	equ	(CALENDAR_Dummy+5)
    ; (BOOL) Can more than one day be selected at a time.  Defaults
    ; to FALSE.

CALENDAR_Labels		equ	(CALENDAR_Dummy+6)
    ; (DayLabelP) Array of labels for the days of the month.  Optional,
    ; but if provided, must be an array of 31 entries.

CALENDAR_Label		equ	(CALENDAR_Dummy+7)
    ; (BOOL) Indicate whether there should be a label across the top
    ; showing the names of the days of the week.  Defaults to TRUE.

;*****************************************************************************

    ENDC	; GADGETS_CALENDAR_I
