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
      SID_NOCIATIMER     