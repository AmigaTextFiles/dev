/*------------------------------------------------------------------------*/
/*
 * $Id: newstyle.h 1.1 1997/05/15 18:53:15 heinz Exp $
 *
 * Support header for the New Style Device standard
 *
 * (C)1996-1997 by Amiga International, Inc.
 *
 */
/*------------------------------------------------------------------------*/
/*
 *  At the moment there is just a single new style general command:
 */
CONST NSCMD_DEVICEQUERY=$4000

OBJECT NSDeviceQueryResult
  DevQueryFormat:ULONG,              /* this is type 0               */
  SizeAvailable:ULONG,               /* bytes available              */
  DeviceType:UWORD,                  /* what the device does         */
  DeviceSubType:UWORD,               /* depends on the main type     */
  SupportedCommands:PTR TO UWORD     /* 0 terminated list of cmd's   */

CONST NSDEVTYPE_UNKNOWN=0,   /* No suitable category, anything */
 NSDEVTYPE_GAMEPORT=1,    /* like gameport.device */
 NSDEVTYPE_TIMER=2,    /* like timer.device */
 NSDEVTYPE_KEYBOARD=3,    /* like keyboard.device */
 NSDEVTYPE_INPUT=4,    /* like input.device */
 NSDEVTYPE_TRACKDISK=5,    /* like trackdisk.device */
 NSDEVTYPE_CONSOLE=6,    /* like console.device */
 NSDEVTYPE_SANA2=7,    /* A >=SANA2R2 networking device */
 NSDEVTYPE_AUDIO=8,    /* like audio.device */
 NSDEVTYPE_CLIPBOARD=9,    /* like clipboard.device */
 NSDEVTYPE_PRINTER=10,   /* like printer.device */
 NSDEVTYPE_SERIAL=11,   /* like serial.device */
 NSDEVTYPE_PARALLEL=12   /* like parallel.device */
/*------------------------------------------------------------------------*/
/* The following defines should really be part of device specific
 * includes. So we protect them from being redefined.
 */
#ifndef NSCMD_TD_READ64
/*
 *  An early new style trackdisk like device can also return this
 *  new identifier for TD_GETDRIVETYPE. This should no longer
 *  be the case though for newly written or updated NSD devices.
 *  This identifier is ***OBSOLETE***
 */
CONST DRIVE_NEWSTYLE=$4E535459,      /* 'NSTY' */
/*
 *  At the moment, only four new style commands in the device
 *  specific range and their ETD counterparts may be implemented.
 */
 NSCMD_TD_READ64=$C000,
 NSCMD_TD_WRITE64=$C001,
 NSCMD_TD_SEEK64=$C002,
 NSCMD_TD_FORMAT64=$C003,
 NSCMD_ETD_READ64=$E000,
 NSCMD_ETD_WRITE64=$E001,
 NSCMD_ETD_SEEK64=$E002,
 NSCMD_ETD_FORMAT64=$E003
#endif
/* NSCMD_TD_READ64 */
/*------------------------------------------------------------------------*/
