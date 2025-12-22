#ifndef DEVICES_TIMER_H
#define DEVICES_TIMER_H 1

MODULE  'exec/types'
MODULE  'exec/io'

#define UNIT_MICROHZ	0
#define UNIT_VBLANK	1
#define UNIT_ECLOCK	2
#define UNIT_WAITUNTIL	3
#define	UNIT_WAITECLOCK	4
#define TIMERNAME	'timer.device'
OBJECT timeval
 
    secs:LONG
    micro:LONG
ENDOBJECT

OBJECT EClockVal
 
    hi:LONG
    lo:LONG
ENDOBJECT

OBJECT timerequest
 
      node:IORequest
      time:timeval
ENDOBJECT


#define TR_ADDREQUEST	CMD_NONSTD
#define TR_GETSYSTIME	(CMD_NONSTD+1)
#define TR_SETSYSTIME	(CMD_NONSTD+2)
#endif 
