/* $Id: gameport.h 12452 2001-10-24 10:02:53Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/io'
MODULE 'target/exec/types'
{#include <devices/gameport.h>}
NATIVE {DEVICES_GAMEPORT_H} CONST

/**********************************************************************
 ********************** Gameport Device Commands **********************
 **********************************************************************/

NATIVE {GPD_READEVENT}        CONST GPD_READEVENT        = (CMD_NONSTD + 0)
NATIVE {GPD_ASKCTYPE}         CONST GPD_ASKCTYPE         = (CMD_NONSTD + 1)
NATIVE {GPD_SETCTYPE}         CONST GPD_SETCTYPE         = (CMD_NONSTD + 2)
NATIVE {GPD_ASKTRIGGER}       CONST GPD_ASKTRIGGER       = (CMD_NONSTD + 3)
NATIVE {GPD_SETTRIGGER}       CONST GPD_SETTRIGGER       = (CMD_NONSTD + 4)

/********************************************************
 ********************** Structures **********************
 ********************************************************/
 
NATIVE {GPTB_DOWNKEYS}	CONST GPTB_DOWNKEYS	= 0
NATIVE {GPTB_UPKEYS}	CONST GPTB_UPKEYS	= 1
 
NATIVE {GPTF_DOWNKEYS}	CONST GPTF_DOWNKEYS	= $1
NATIVE {GPTF_UPKEYS}	CONST GPTF_UPKEYS	= $2
 
NATIVE {GamePortTrigger} OBJECT gameporttrigger
    {gpt_Keys}	keys	:UINT
    {gpt_Timeout}	timeout	:UINT
    {gpt_XDelta}	xdelta	:UINT
    {gpt_YDelta}	ydelta	:UINT
ENDOBJECT


/**************************************************************
 ********************** Controller Types **********************
 **************************************************************/

NATIVE {GPCT_ALLOCATED}		CONST GPCT_ALLOCATED		= -1
NATIVE {GPCT_NOCONTROLLER}	CONST GPCT_NOCONTROLLER	= 0
NATIVE {GPCT_MOUSE}		CONST GPCT_MOUSE		= 1
NATIVE {GPCT_RELJOYSTICK}	CONST GPCT_RELJOYSTICK	= 2
NATIVE {GPCT_ABSJOYSTICK}	CONST GPCT_ABSJOYSTICK	= 3
