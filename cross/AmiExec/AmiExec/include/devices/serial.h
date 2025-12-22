/****************************************************************************

$Source: MASTER:include/devices/serial.h,v $
$Revision: 1.1 $
$Date: 1993/09/13 15:24:37 $

Public include for serial device and its clients.  This file extends the
native C= include with declarations for features not present in the native
serial device.  i.e. It's fine to use this file for native serial.device
code, as long as the extended features aren't used.  Currently, the
extensions consist of the declarations necessary to support the
SetCtrlLines command.

****************************************************************************/
#include "SC:include/devices/serial.h"


/* Command Extensions. */

#define SDCMD_SETCTRLLINES (CMD_NONSTD+10)


/* Bits and flags for use with the SetCtrlLines command. */

#define SERCTRLB_RTS    0

#define SERCTRLF_RTS    (1 << SERCTRLB_RTS)


/* Status bit extensions.  The bits aren't extensions, only the defines. */

#define IO_STATB_CTS    4
#define IO_STATB_RTS    6

#define IO_STATF_CTS    (1 << IO_STATB_CTS)
#define IO_STATF_RTS    (1 << IO_STATB_RTS)
