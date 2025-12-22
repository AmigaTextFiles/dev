	IFND	MISC_TIME_I
MISC_TIME_I	SET  1

**
**  $VER: time.i V1.0
**
**  Time Object.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**	All Rights Reserved.
**

*****************************************************************************
* Time Object.

    STRUCTURE	TM,HEAD_SIZEOF   ;Standard header.
	WORD	TM_Year          ;Year    (-ve for BC, +ve for AD)
	WORD	TM_Month         ;Month   (1 - 12)
	WORD	TM_Day           ;Day     (1 - 31)
	WORD	TM_Hour          ;Hour    (0 - 23)
	WORD	TM_Minute        ;Minute  (0 - 59)
	WORD	TM_Second        ;Second  (0 - 59)
	WORD	TM_Micro         ;Micro   (0 - 99 micro-seconds)

  ENDC	;MISC_TIME_I
