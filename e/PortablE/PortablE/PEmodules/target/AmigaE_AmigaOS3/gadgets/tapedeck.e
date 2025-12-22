/* $VER: tapedeck.h 40.0 (12.3.1993) */
OPT NATIVE
MODULE 'target/utility/tagitem'
{MODULE 'gadgets/tapedeck'}

NATIVE {TDECK_DUMMY}		CONST TDECK_DUMMY		= (TAG_USER+$05000000)
NATIVE {TDECK_MODE}		CONST TDECK_MODE		= (TDECK_DUMMY + 1)
NATIVE {TDECK_PAUSED}		CONST TDECK_PAUSED		= (TDECK_DUMMY + 2)

NATIVE {TDECK_TAPE}		CONST TDECK_TAPE		= (TDECK_DUMMY + 3)
	/* (BOOL) Indicate whether tapedeck or animation controls.  Defaults
	 * to FALSE. */

NATIVE {TDECK_FRAMES}		CONST TDECK_FRAMES		= (TDECK_DUMMY + 11)
	/* (LONG) Number of frames in animation.  Only valid when using
	 * animation controls. */

NATIVE {TDECK_CURRENTFRAME}	CONST TDECK_CURRENTFRAME	= (TDECK_DUMMY + 12)
	/* (LONG) Current frame.  Only valid when using animation controls. */

/*****************************************************************************/

/* Possible values for TDECK_Mode */
NATIVE {BUT_REWIND}	CONST BUT_REWIND	= 0
NATIVE {BUT_PLAY}	CONST BUT_PLAY	= 1
NATIVE {BUT_FORWARD}	CONST BUT_FORWARD	= 2
NATIVE {BUT_STOP}	CONST BUT_STOP	= 3
NATIVE {BUT_PAUSE}	CONST BUT_PAUSE	= 4
NATIVE {BUT_BEGIN}	CONST BUT_BEGIN	= 5
NATIVE {BUT_FRAME}	CONST BUT_FRAME	= 6
NATIVE {BUT_END}		CONST BUT_END		= 7
