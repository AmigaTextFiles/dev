/* $VER: timer.h 36.16 (25.1.1991) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/io'
{#include <devices/timer.h>}
NATIVE {DEVICES_TIMER_H} CONST

/* unit defintions */
NATIVE {UNIT_MICROHZ}	CONST UNIT_MICROHZ	= 0
NATIVE {UNIT_VBLANK}	CONST UNIT_VBLANK	= 1
NATIVE {UNIT_ECLOCK}	CONST UNIT_ECLOCK	= 2
NATIVE {UNIT_WAITUNTIL}	CONST UNIT_WAITUNTIL	= 3
NATIVE {UNIT_WAITECLOCK}	CONST UNIT_WAITECLOCK	= 4

NATIVE {TIMERNAME}	CONST
#define TIMERNAME timername
STATIC timername	= 'timer.device'

NATIVE {timeval} OBJECT timeval
    {tv_secs}	secs	:ULONG
    {tv_micro}	micro	:ULONG
ENDOBJECT

NATIVE {EClockVal} OBJECT eclockval
    {ev_hi}	hi	:ULONG
    {ev_lo}	lo	:ULONG
ENDOBJECT

NATIVE {timerequest} OBJECT timerequest
    {tr_node}	io	:io
    {tr_time}	time	:timeval
ENDOBJECT

/* IO_COMMAND to use for adding a timer */
NATIVE {TR_ADDREQUEST}	CONST TR_ADDREQUEST	= CMD_NONSTD
NATIVE {TR_GETSYSTIME}	CONST TR_GETSYSTIME	= (CMD_NONSTD+1)
NATIVE {TR_SETSYSTIME}	CONST TR_SETSYSTIME	= (CMD_NONSTD+2)
