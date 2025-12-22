MODULE	'exec/io'

CONST	UNIT_MICROHZ=0,
		UNIT_VBLANK=1,
		UNIT_ECLOCK=2,
		UNIT_WAITUNTIL=3,
		UNIT_WAITECLOCK=4

#define TIMERNAME 'timer.device'

OBJECT timeval|TimeVal
	Secs|secs:ULONG,
	Micro|micro:ULONG

OBJECT EClockVal
	Hi|hi:ULONG,
	Lo|lo:ULONG

OBJECT timerequest|TimeRequest
	node|IO:IO,
	time|Time:timeval

CONST	TR_ADDREQUEST=9,
		TR_GETSYSTIME=10,
		TR_SETSYSTIME=11
