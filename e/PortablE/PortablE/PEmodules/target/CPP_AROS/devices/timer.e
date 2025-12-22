/* $Id: timer.h 37689 2011-03-20 16:15:51Z verhaegs $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/io', 'target/exec/types' /*, 'target/aros/types/timeval_s'*/
PUBLIC MODULE 'target/aros/types/timeval_s'
{#include <devices/timer.h>}
NATIVE {DEVICES_TIMER_H} CONST

NATIVE {TIMERNAME} CONST
#define TIMERNAME timername
STATIC timername = 'timer.device'

/* Units */
NATIVE {UNIT_MICROHZ}    CONST UNIT_MICROHZ    = 0
NATIVE {UNIT_VBLANK}     CONST UNIT_VBLANK     = 1
NATIVE {UNIT_ECLOCK}     CONST UNIT_ECLOCK     = 2
NATIVE {UNIT_WAITUNTIL}  CONST UNIT_WAITUNTIL  = 3
NATIVE {UNIT_WAITECLOCK} CONST UNIT_WAITECLOCK = 4

/* IO-Commands */
NATIVE {TR_ADDREQUEST} CONST TR_ADDREQUEST = (CMD_NONSTD+0)
NATIVE {TR_GETSYSTIME} CONST TR_GETSYSTIME = (CMD_NONSTD+1)
NATIVE {TR_SETSYSTIME} CONST TR_SETSYSTIME = (CMD_NONSTD+2)

NATIVE {EClockVal} OBJECT eclockval
    {ev_hi}	hi	:ULONG
    {ev_lo}	lo	:ULONG
ENDOBJECT

NATIVE {timerequest} OBJECT timerequest
    {tr_node}	io	:io
    {tr_time}	time	:timeval
ENDOBJECT
