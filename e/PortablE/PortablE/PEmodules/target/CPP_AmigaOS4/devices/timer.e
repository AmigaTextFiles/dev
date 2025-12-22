/* $Id: timer.h,v 1.17 2005/11/10 15:31:33 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/io'
/*{
//#define __USE_OLD_TIMEVAL__
#define timeval TimeVal
#define timerequest TimeRequest
#define tv_secs Seconds
#define tv_micro Microseconds
#define tr_node Request
#define tr_time Time

#include <devices/timer.h>
}
NATIVE {TimeVal} OBJECT
NATIVE {TimeRequest} OBJECT
NATIVE {Seconds} DEF
NATIVE {Microseconds} DEF
->NATIVE {Request} DEF
NATIVE {Time} DEF

NATIVE {timeval} OBJECT timeval
    {tv_secs}	secs	:ULONG
    {tv_micro}	micro	:ULONG
ENDOBJECT
NATIVE {timerequest} OBJECT timerequest
    {tr_node}	io	:io
    {tr_time}	time	:timeval
ENDOBJECT
*/
{#include <devices/timer.h>}

NATIVE {DEVICES_TIMER_H} CONST

/* unit defintions */
NATIVE {enTimerUnits} DEF
NATIVE {UNIT_MICROHZ}    CONST UNIT_MICROHZ    = 0    /* 1/1000000 second granularity */
NATIVE {UNIT_VBLANK}     CONST UNIT_VBLANK     = 1    /* 1/60 second granularity */
NATIVE {UNIT_ECLOCK}     CONST UNIT_ECLOCK     = 2    /* system dependant number of ticks/second */
NATIVE {UNIT_WAITUNTIL}  CONST UNIT_WAITUNTIL  = 3    /* wait until a certain point of time */
NATIVE {UNIT_WAITECLOCK} CONST UNIT_WAITECLOCK = 4    /* wait until a certain point of time
                              (in EClock ticks) */
NATIVE {UNIT_ENTROPY}    CONST UNIT_ENTROPY    = 5    /* Read entropy data */


/****************************************************************************/

NATIVE {TIMERNAME} CONST
#define TIMERNAME timername
STATIC timername = 'timer.device'

/****************************************************************************/

/* The 'C' runtime library may have its own ideas of how the following
   data structure should be defined, so we skip if it necessary. */

NATIVE {TimeVal} OBJECT timeval
    {Seconds}	secs	:ULONG
    {Microseconds}	micro	:ULONG
ENDOBJECT

/****************************************************************************/

/* This is really a 64 bit integer value split into two 32 bit integers. */
NATIVE {EClockVal} OBJECT eclockval
    {ev_hi}	hi	:ULONG
    {ev_lo}	lo	:ULONG
ENDOBJECT

/****************************************************************************/

NATIVE {TimeRequest} OBJECT timerequest
    {Request}	io	:io
    {Time}	time	:timeval
ENDOBJECT

/****************************************************************************/

NATIVE {enTimerCmd} DEF
NATIVE {TR_ADDREQUEST}  CONST TR_ADDREQUEST  = CMD_NONSTD      /* Add a timer request */
NATIVE {TR_GETSYSTIME}  CONST TR_GETSYSTIME  = (CMD_NONSTD+1)  /* Set the system time */
NATIVE {TR_SETSYSTIME}  CONST TR_SETSYSTIME  = (CMD_NONSTD+2)  /* Obtain the system time */
NATIVE {TR_READENTROPY} CONST TR_READENTROPY = (CMD_NONSTD+3)
