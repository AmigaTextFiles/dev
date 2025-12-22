	IFND INPUT_JOYPORTS_I
INPUT_JOYPORTS_I  SET  1

**
**  $VER: joyports.i
**
**  JoyPort definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**
**

	IFND    DPKERNEL_I
	include 'dpkernel/dpkernel.i'
	ENDC

******************************************************************************
* JoyData object.

JOYVERSION   = 2
TAGS_JOYDATA = ((ID_SPCTAGS<<16)|ID_JOYDATA)

    STRUCTURE	JD,HEAD_SIZEOF
	WORD	JD_Port          ;Port number, 1/2/3/4.
	WORD	JD_XChange       ;Change in the x coordinate.
	WORD	JD_YChange       ;Change in the y coordinate.
	WORD	JD_ZChange       ;Change in the z coordinate.
	LONG	JD_Buttons       ;Contains button bits, flags defined below.
	WORD	JD_ButtonTimeOut ;Micro-seconds before button time-out.
	WORD	JD_MoveTimeOut   ;Micro-seconds before movement time-out.
	WORD	JD_NXLimit       ;Negative X limit.
	WORD	JD_NYLimit       ;Negative Y limit.
	WORD	JD_PXLimit       ;Positive X limit.
	WORD	JD_PYLimit       ;Positive Y limit.

;Bit settings for buttons field.

JB_FIRE1 =	0               ;Standard Fire Button (1) - LMB.
JB_FIRE2 =	1               ;Standard Fire Button (2) - RMB.
JB_FIRE3 =	2               ;Standard Fire Button (3) - MMB.
JB_FIRE4 =	3
JB_FIRE5 =	4
JB_FIRE6 =	5
JB_FIRE7 =	6
JB_FIRE8 =	7
JB_LMB   =	JB_FIRE1
JB_RMB   =	JB_FIRE2
JB_MMB   =	JB_FIRE3

;Flags for buttons field.

JF_FIRE1 =	(1<<JB_FIRE1)
JF_FIRE2 =	(1<<JB_FIRE2)
JF_FIRE3 =	(1<<JB_FIRE3)
JF_FIRE4 =	(1<<JB_FIRE4)
JF_FIRE5 =	(1<<JB_FIRE5)
JF_FIRE6 =	(1<<JB_FIRE6)
JF_FIRE7 =	(1<<JB_FIRE7)
JF_FIRE8 =	(1<<JB_FIRE8)
JF_LMB   =	JF_FIRE1
JF_RMB   =	JF_FIRE2
JF_MMB   =	JF_FIRE3

JPORT_DIGITAL  = -1
JPORT_ANALOGUE = -2

  ENDC ;INPUT_JOYPORTS_I

