/*
**      $Filename: libraries/playsidbase.e $
**      $Release: 1.0 $
**
**      (C) Copyright 1994 Per Håkan Sundell and Ron Birk
**          All Rights Reserved
**      Converted by Petter E. Stokke, 23 Nov 1995
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'exec/libraries','exec/lists'

#define PLAYSIDNAME 'playsid.library'
CONST PLAYSIDVERSION=1

OBJECT playsidbase
    libnode:lib
    flags:CHAR
    pad:CHAR
    syslib:LONG
    seglist:LONG
    playmode:INT
    timeseconds:INT
    timeminutes:INT
ENDOBJECT

OBJECT displaydata
    sample[4]:ARRAY OF LONG
    length[4]:ARRAY OF INT
    period[4]:ARRAY OF INT
    enve[4]:ARRAY OF INT
    synclength[3]:ARRAY OF INT
    volume:INT
    syncind[3]:ARRAY OF CHAR
ENDOBJECT

/* --- Error -------------------------------------------------------- */
CONST SID_NOMEMORY       =-1,
      SID_NOAUDIODEVICE  =-2,
      SID_NOCIATIMER     =-3,
      SID_NOPAUSE        =-4,
      SID_NOMODULE       =-5,
      SID_NOICON         =-6,
      SID_BADTOOLTYPE    =-7,
      SID_NOLIBRARY      =-8,
      SID_BADHEADER      =-9,
      SID_NOSONG         =-10,
      SID_LIBINUSE       =-11

/* --- Playing Modes ------------------------------------------------ */
ENUM PM_STOP=0,PM_PLAY,PM_PAUSE

/* --- Module Header ------------------------------------------------ */
CONST SID_HEADER="PSID",SID_VERSION=2,HEADERINFO_SIZE=32,
      SID_SIDSONG=0,SIDF_SIDSONG=1

OBJECT sidheader
    id:LONG
    version:INT
    length:INT
    start:INT
    init:INT
    main:INT
    number:INT
    defsong:INT
    speed:LONG
    name[HEADERINFO_SIZE]:ARRAY OF CHAR
    author[HEADERINFO_SIZE]:ARRAY OF CHAR
    copyright[HEADERINFO_SIZE]:ARRAY OF CHAR
    flags:INT
    reserved:LONG
ENDOBJECT

