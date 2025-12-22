/* $Id: gameport.h,v 1.13 2005/11/10 15:31:33 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/exec/io'
{#include <devices/gameport.h>}
NATIVE {DEVICES_GAMEPORT_H} CONST

/****** GamePort commands ******/
NATIVE {GPD_READEVENT}  CONST GPD_READEVENT  = (CMD_NONSTD+0)
NATIVE {GPD_ASKCTYPE}   CONST GPD_ASKCTYPE   = (CMD_NONSTD+1)
NATIVE {GPD_SETCTYPE}   CONST GPD_SETCTYPE   = (CMD_NONSTD+2)
NATIVE {GPD_ASKTRIGGER} CONST GPD_ASKTRIGGER = (CMD_NONSTD+3)
NATIVE {GPD_SETTRIGGER} CONST GPD_SETTRIGGER = (CMD_NONSTD+4)

/****** GamePort structures ******/

/* gpt_Keys */
NATIVE {GPTB_DOWNKEYS} CONST GPTB_DOWNKEYS = 0
NATIVE {GPTF_DOWNKEYS} CONST GPTF_DOWNKEYS = $1
NATIVE {GPTB_UPKEYS}   CONST GPTB_UPKEYS   = 1
NATIVE {GPTF_UPKEYS}   CONST GPTF_UPKEYS   = $2

NATIVE {GamePortTrigger} OBJECT gameporttrigger
    {gpt_Keys}	keys	:UINT    /* key transition triggers */
    {gpt_Timeout}	timeout	:UINT /* time trigger (vertical blank units) */
    {gpt_XDelta}	xdelta	:UINT  /* X distance trigger */
    {gpt_YDelta}	ydelta	:UINT  /* Y distance trigger */
ENDOBJECT

/****** Controller Types ******/
NATIVE {GPCT_ALLOCATED}    CONST GPCT_ALLOCATED    = -1 /* allocated by another user */
NATIVE {GPCT_NOCONTROLLER}  CONST GPCT_NOCONTROLLER  = 0

NATIVE {GPCT_MOUSE}         CONST GPCT_MOUSE         = 1
NATIVE {GPCT_RELJOYSTICK}   CONST GPCT_RELJOYSTICK   = 2
NATIVE {GPCT_ABSJOYSTICK}   CONST GPCT_ABSJOYSTICK   = 3

/****** Errors ******/
NATIVE {GPDERR_SETCTYPE} CONST GPDERR_SETCTYPE = 1 /* this controller not valid at this time */

/****** Open Flags ******/
NATIVE {GPOB_FIXOVERRUNS} CONST GPOB_FIXOVERRUNS = 0
NATIVE {GPOF_FIXOVERRUNS} CONST GPOF_FIXOVERRUNS = $1 /* fix mouse counter overruns (V50) */
