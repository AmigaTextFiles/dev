/* $Id: input.h,v 1.15 2006/01/21 13:17:12 sfalke Exp $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/io', 'target/devices/timer', 'target/devices/gameport', 'target/utility/hooks'
{#include <devices/input.h>}
NATIVE {DEVICES_INPUT_H} CONST

NATIVE {INPUTNAME} CONST
#define INPUTNAME inputname
STATIC inputname = 'input.device'

/****************************************************************************/

/* input.device commands */
NATIVE {IND_ADDHANDLER}         CONST IND_ADDHANDLER         = (CMD_NONSTD+0)
NATIVE {IND_REMHANDLER}         CONST IND_REMHANDLER         = (CMD_NONSTD+1)
NATIVE {IND_WRITEEVENT}         CONST IND_WRITEEVENT         = (CMD_NONSTD+2)
NATIVE {IND_SETTHRESH}          CONST IND_SETTHRESH          = (CMD_NONSTD+3)
NATIVE {IND_SETPERIOD}          CONST IND_SETPERIOD          = (CMD_NONSTD+4)
NATIVE {IND_SETMPORT}           CONST IND_SETMPORT           = (CMD_NONSTD+5)
NATIVE {IND_SETMTYPE}           CONST IND_SETMTYPE           = (CMD_NONSTD+6)
NATIVE {IND_SETMTRIG}           CONST IND_SETMTRIG           = (CMD_NONSTD+7)
NATIVE {IND_SETMDEVICE}         CONST IND_SETMDEVICE         = (CMD_NONSTD+8)  /* V50 */
NATIVE {IND_SETKDEVICE}         CONST IND_SETKDEVICE         = (CMD_NONSTD+9)  /* V50 */
NATIVE {IND_GETMDEVICE}         CONST IND_GETMDEVICE         = (CMD_NONSTD+10) /* V50 */
NATIVE {IND_GETKDEVICE}         CONST IND_GETKDEVICE         = (CMD_NONSTD+11) /* V50 */
NATIVE {IND_ADDNOTIFY}          CONST IND_ADDNOTIFY          = (CMD_NONSTD+12) /* V50 */
NATIVE {IND_IMMEDIATEADDNOTIFY} CONST IND_IMMEDIATEADDNOTIFY = (CMD_NONSTD+13) /* V50 */
NATIVE {IND_REMOVENOTIFY}       CONST IND_REMOVENOTIFY       = (CMD_NONSTD+14) /* V50 */
NATIVE {IND_ADDEVENT}           CONST IND_ADDEVENT           = (CMD_NONSTD+15) /* V50 */
NATIVE {IND_GETTHRESH}          CONST IND_GETTHRESH          = (CMD_NONSTD+16) /* V50 */
NATIVE {IND_GETPERIOD}          CONST IND_GETPERIOD          = (CMD_NONSTD+17) /* V50 */
NATIVE {IND_GETHANDLERLIST}     CONST IND_GETHANDLERLIST     = (CMD_NONSTD+18) /* V50 */

/****************************************************************************/

/* This is used to configure and query the keyboard
 * and gameport devices
 */
NATIVE {InputDeviceOption} OBJECT inputdeviceoption
    {Name}	name	:ARRAY OF CHAR /*STRPTR*/     /* Device name */
    {NameSize}	namesize	:VALUE /* Size of name buffer (for queries) */
    {Unit}	unit	:VALUE     /* Unit number */
ENDOBJECT

/****************************************************************************/

/* Errors produced by input.device */
NATIVE {IDERR_BadName}          CONST IDERR_BADNAME          = 1 /* Device name submitted to
                                    IND_SETKDEVICE or IND_SETMDEVICE
                                    is not valid */
NATIVE {IDERR_OutOfMemory}      CONST IDERR_OUTOFMEMORY      = 2 /* Not enough memory to perform
                                    requested action */
NATIVE {IDERR_NameTooLong}      CONST IDERR_NAMETOOLONG      = 3 /* The device name is too long to
                                    fit into the supplied buffer */
NATIVE {IDERR_AlreadyInstalled} CONST IDERR_ALREADYINSTALLED = 4 /* The notification hook you tried to
                                    install is already present */
NATIVE {IDERR_NotInstalled}     CONST IDERR_NOTINSTALLED     = 5 /* The notification hook you wanted to
                                    be removed was not even installed */

/****************************************************************************/

/* Messages passed to a notification hook. */

NATIVE {IDNOTIFY_Threshold} CONST IDNOTIFY_THRESHOLD = 1

NATIVE {IDThresholdNotifyMsg} OBJECT idthresholdnotifymsg
    {idnm_Type}	type	:VALUE      /* Set to IDNOTIFY_Threshold */
    {idnm_Threshold}	threshold	:timeval /* Key repeat threshold */
ENDOBJECT

NATIVE {IDNOTIFY_Period} CONST IDNOTIFY_PERIOD = 2

NATIVE {IDPeriodNotifyMsg} OBJECT idperiodnotifymsg
    {idnm_Type}	type	:VALUE   /* Set to IDNOTIFY_Period */
    {idnm_Period}	period	:timeval /* Key repeat period */
ENDOBJECT

NATIVE {IDNOTIFY_MousePort} CONST IDNOTIFY_MOUSEPORT = 3

NATIVE {IDMousePortNotifyMsg} OBJECT idmouseportnotifymsg
    {idnm_Type}	type	:VALUE      /* Set to IDNOTIFY_MousePort */
    {idnm_MousePort}	mouseport	:VALUE /* Mouse port number; otherwise
                           identical to gameport.device
                           unit number to obtain mouse
                           events from. */
ENDOBJECT

NATIVE {IDNOTIFY_MouseType} CONST IDNOTIFY_MOUSETYPE = 4

NATIVE {IDMouseTypeNotifyMsg} OBJECT idmousetypenotifymsg
    {idnm_Type}	type	:VALUE      /* Set to IDNOTIFY_MouseType */
    {idnm_MouseType}	mousetype	:VALUE /* Controller type, as defined
                            in <devices/gameport.h> by
                            the GPCT_[..] symbols. */
ENDOBJECT

NATIVE {IDNOTIFY_MouseTrigger} CONST IDNOTIFY_MOUSETRIGGER = 5

NATIVE {IDMouseTriggerNotifyMsg} OBJECT idmousetriggernotifymsg
    {idnm_Type}	type	:VALUE    /* Set to IDNOTIFY_MouseTrigger */
    {idnm_Trigger}	trigger	:gameporttrigger /* Conditions for a mouse port
                                            report. */
ENDOBJECT

NATIVE {IDNOTIFY_MouseDevice} CONST IDNOTIFY_MOUSEDEVICE = 6

NATIVE {IDMouseDeviceNotifyMsg} OBJECT idmousedevicenotifymsg
    {idnm_Type}	type	:VALUE /* Set to IDNOTIFY_MouseDevice */
    {idnm_Name}	name	:ARRAY OF CHAR /*STRPTR*/ /* The name of the gameport.device
                         driver mouse events are obtained
                         from */
    {idnm_Unit}	unit	:VALUE /* The mouse port or unit number
                         of the gameport.device driver */
ENDOBJECT

NATIVE {IDNOTIFY_KeyboardDevice} CONST IDNOTIFY_KEYBOARDDEVICE = 7

NATIVE {IDKeyboardDeviceNotifyMsg} OBJECT idkeyboarddevicenotifymsg
    {idnm_Type}	type	:VALUE /* Set to IDNOTIFY_KeyboardDevice */
    {idnm_Name}	name	:ARRAY OF CHAR /*STRPTR*/ /* The name of the keyboard.device
                         driver key events are obtained
                         from. */
    {idnm_Unit}	unit	:VALUE /* The unit number of the
                         keyboard.device driver */
ENDOBJECT
