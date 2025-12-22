#ifndef  DEVICES_TIMER_H
#define  DEVICES_TIMER_H 1

/*$Id: timer.h,v 1.1 1993/01/22 09:44:07 wjm Exp $*/
/****************************************************************************
*                                                                           *
*     NAME                                                                  *
*        timer.h - public include used by timer device and its clients      *
*                                                                           *
*     FUNCTION                                                              *
*        This file defines the extended I/O Request and commands            *
*        used by the timer device.  This file is a compatible               *
*        replacement/extension of the native C= include.  The I/O           *
*        request structure is extended beyond the native, as is             *
*        the command set.  If you don't use the extended command set,       *
*        you won't break anything by compiling native code with this,       *
*        and then using the vanilla timer.device.   You may use the         *
*        extended command set provided the native timer.device has been     *
*        extended via timer.amiga.device.                                   *
*                                                                           *
*        Inline comments indicate the extensions made.                      *
*                                                                           *
*        Disclaimer:  I can't see how this extension scheme could be        *
*        broken by future releases of the OS, but I won't promise.          *
*                                                                           *
*     HISTORY                                                               *
*        VHF  ddmmmyy - Created.                                            *
*        WJM  29Oct92 - Brought the include up to C= 2.04 and expressed     *
*                       the VME timer I/O request as an extension, rather   *
*                       than replacement, of the native request.            *
*                                                                           *
****************************************************************************/
#ifndef  EXEC_IO_H
#include <exec/io.h>
#endif

#define TIMERNAME	"timer.device"

/* Unit Definitions */

#define UNIT_MICROHZ	   0
#define UNIT_VBLANK	   1
#define UNIT_ECLOCK	   2
#define UNIT_WAITUNTIL	3
#define UNIT_WAITECLOCK	4
#define UNIT_PERIODIC   10    /* open this unit to get extended command set */


struct timeval
   {
   ULONG tv_secs;
   ULONG tv_micro;
   };

struct EClockVal
   {
   ULONG ev_hi;
   ULONG ev_lo;
   };

struct timerequest 
   {
   struct IORequest tr_node;
   struct timeval tr_time;

   /* Extensions required by UNIT_PERIODIC. */

   LONG   tr_milli;        /* number of milliseconds in delay request */
   ULONG  period;          /* number of milliseconds for periodic request */
   ULONG  signal;          /* signal to use when period expires */
   struct Task *sigtask;   /* task to signal when period expires */
   };


/* Timer device commands. */

#define TR_ADDREQUEST   CMD_NONSTD
#define TR_GETSYSTIME	CMD_NONSTD + 1
#define TR_SETSYSTIME	CMD_NONSTD + 2
#define TR_PERIODIC     CMD_NONSTD + 3       /* supported by UNIT_PERIODIC */
#define TR_PERIODICINT  CMD_NONSTD + 4       /* supported by UNIT_PERIODIC */

#endif
