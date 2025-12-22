/* $Id: newstyle.h,v 1.10 2005/11/10 15:31:33 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
{#include <devices/newstyle.h>}
NATIVE {DEVICES_NEWSTYLE_H} CONST

/*
 *  At the moment there is just a single new style general command:
 */

NATIVE {NSCMD_DEVICEQUERY} CONST NSCMD_DEVICEQUERY = $4000

/****************************************************************************/

NATIVE {NSDeviceQueryResult} OBJECT nsdevicequeryresult
    /*
    ** Standard information, must be reset for every query
    */
    {DevQueryFormat}	devqueryformat	:ULONG         /* this is type 0 */
    {SizeAvailable}	sizeavailable	:ULONG          /* bytes available */

    /*
    ** Common information (READ ONLY!)
    */
    {DeviceType}	devicetype	:UINT             /* what the device does */
    {DeviceSubType}	devicesubtype	:UINT          /* depends on the main type */
    {SupportedCommands}	supportedcommands	:PTR TO UINT      /* 0 terminated list of cmd's */

    /* May be extended in the future! Check SizeAvailable! */
ENDOBJECT

/****************************************************************************/

NATIVE {NSDEVTYPE_UNKNOWN}    CONST NSDEVTYPE_UNKNOWN    = 0  /* No suitable category, anything */
NATIVE {NSDEVTYPE_GAMEPORT}   CONST NSDEVTYPE_GAMEPORT   = 1  /* like gameport.device */
NATIVE {NSDEVTYPE_TIMER}      CONST NSDEVTYPE_TIMER      = 2  /* like timer.device */
NATIVE {NSDEVTYPE_KEYBOARD}   CONST NSDEVTYPE_KEYBOARD   = 3  /* like keyboard.device */
NATIVE {NSDEVTYPE_INPUT}      CONST NSDEVTYPE_INPUT      = 4  /* like input.device */
NATIVE {NSDEVTYPE_TRACKDISK}  CONST NSDEVTYPE_TRACKDISK  = 5  /* like trackdisk.device */
NATIVE {NSDEVTYPE_CONSOLE}    CONST NSDEVTYPE_CONSOLE    = 6  /* like console.device */
NATIVE {NSDEVTYPE_SANA2}      CONST NSDEVTYPE_SANA2      = 7  /* A >=SANA2R2 networking device */
NATIVE {NSDEVTYPE_AUDIO}      CONST NSDEVTYPE_AUDIO      = 8  /* like audio.device */
NATIVE {NSDEVTYPE_CLIPBOARD}  CONST NSDEVTYPE_CLIPBOARD  = 9  /* like clipboard.device */
NATIVE {NSDEVTYPE_PRINTER}   CONST NSDEVTYPE_PRINTER   = 10  /* like printer.device */
NATIVE {NSDEVTYPE_SERIAL}    CONST NSDEVTYPE_SERIAL    = 11  /* like serial.device */
NATIVE {NSDEVTYPE_PARALLEL}  CONST NSDEVTYPE_PARALLEL  = 12  /* like parallel.device */

/****************************************************************************/

/* The following defines should really be part of device specific
 * includes. So we protect them from being redefined.
 */

->#ifndef NSCMD_TD_READ64

/****************************************************************************/

/*
 *  An early new style trackdisk like device can also return this
 *  new identifier for TD_GETDRIVETYPE. This should no longer
 *  be the case though for newly written or updated NSD devices.
 *  This identifier is ***OBSOLETE***
 */

NATIVE {DRIVE_NEWSTYLE} CONST DRIVE_NEWSTYLE = ($4E535459)   /* 'NSTY' */

/*
 *  At the moment, only four new style commands in the device
 *  specific range and their ETD counterparts may be implemented.
 */

NATIVE {NSCMD_TD_READ64}     CONST NSCMD_TD_READ64     = $C000
NATIVE {NSCMD_TD_WRITE64}    CONST NSCMD_TD_WRITE64    = $C001
NATIVE {NSCMD_TD_SEEK64}     CONST NSCMD_TD_SEEK64     = $C002
NATIVE {NSCMD_TD_FORMAT64}   CONST NSCMD_TD_FORMAT64   = $C003

NATIVE {NSCMD_ETD_READ64}    CONST NSCMD_ETD_READ64    = $E000
NATIVE {NSCMD_ETD_WRITE64}   CONST NSCMD_ETD_WRITE64   = $E001
NATIVE {NSCMD_ETD_SEEK64}    CONST NSCMD_ETD_SEEK64    = $E002
NATIVE {NSCMD_ETD_FORMAT64}  CONST NSCMD_ETD_FORMAT64  = $E003

/****************************************************************************/

->#endif /* NSCMD_TD_READ64 */
