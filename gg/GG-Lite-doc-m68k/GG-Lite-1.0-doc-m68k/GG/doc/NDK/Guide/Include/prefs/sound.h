@DATABASE "gg:doc/NDK/Guide/Include/prefs/sound.h"
@MASTER   "gg:os-include/prefs/sound.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:57
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "prefs/sound.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"prefs/sound.h" LINK File}


@{b}Structures@{ub}

@{"SoundPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/sound.h/File" 31}


@{b}#defines@{ub}

@{"ID_SOND" LINK "gg:doc/NDK/Guide/Include/prefs/sound.h/File" 28}  @{"SPTYPE_BEEP" LINK "gg:doc/NDK/Guide/Include/prefs/sound.h/File" 45}  @{"SPTYPE_SAMPLE" LINK "gg:doc/NDK/Guide/Include/prefs/sound.h/File" 46}

@ENDNODE
@NODE File "prefs/sound.h"
#ifndef PREFS_SOUND_H
#define PREFS_SOUND_H
/*
**      $VER: sound.h 38.2 (20.6.1991)
**      Includes Release 45.1
**
**      File format for sound preferences
**
**      (C) Copyright 1991-2001 Amiga, Inc.
**      All Rights Reserved
*/

/*****************************************************************************/


#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif


/*****************************************************************************/


#define ID_SOND @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('S','O','N','D')


struct SoundPrefs
{
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}  sop_Reserved[4];            /* System reserved            */
    @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}  sop_DisplayQueue;           /* Flash the display?         */
    @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}  sop_AudioQueue;             /* Make some sound?           */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} sop_AudioType;              /* Type of sound, see below   */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} sop_AudioVolume;            /* Volume of sound, 0..64     */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} sop_AudioPeriod;            /* Period of sound, 127..2500 */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} sop_AudioDuration;          /* Length of simple beep      */
    char  sop_AudioFileName[256];     /* Filename of 8SVX file      */
};


/* constants for SoundPrefs.sop_AudioType */
#define SPTYPE_BEEP     0       /* simple beep sound */
#define SPTYPE_SAMPLE   1       /* sampled sound     */


/*****************************************************************************/


#endif /* PREFS_SOUND_H */
@ENDNODE
