@DATABASE "gg:doc/NDK/Guide/Include/devices/audio.h"
@MASTER   "gg:os-include/devices/audio.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:17
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/audio.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/audio.h" LINK File}


@{b}Structures@{ub}

@{"IOAudio" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 45}


@{b}#defines@{ub}

@{"ADALLOC_MAXPREC" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 22}        @{"ADALLOC_MINPREC" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 21}       @{"ADCMD_ALLOCATE" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 30}
@{"ADCMD_FINISH" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 26}           @{"ADCMD_FREE" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 24}            @{"ADCMD_LOCK" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 28}
@{"ADCMD_PERVOL" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 27}           @{"ADCMD_SETPREC" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 25}         @{"ADCMD_WAITCYCLE" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 29}
@{"ADHARD_CHANNELS" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 19}        @{"ADIOB_NOWAIT" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 36}          @{"ADIOB_PERVOL" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 32}
@{"ADIOB_SYNCCYCLE" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 34}        @{"ADIOB_WRITEMESSAGE" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 38}    @{"ADIOERR_ALLOCFAILED" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 42}
@{"ADIOERR_CHANNELSTOLEN" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 43}  @{"ADIOERR_NOALLOCATION" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 41}  @{"ADIOF_NOWAIT" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 37}
@{"ADIOF_PERVOL" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 33}           @{"ADIOF_SYNCCYCLE" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 35}       @{"ADIOF_WRITEMESSAGE" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 39}
@{"AUDIONAME" LINK "gg:doc/NDK/Guide/Include/devices/audio.h/File" 17}              

@ENDNODE
@NODE File "devices/audio.h"
#ifndef DEVICES_AUDIO_H
#define DEVICES_AUDIO_H
/*
**      $VER: audio.h 36.3 (29.8.1990)
**      Includes Release 45.1
**
**      @{"audio.device" LINK "gg:doc/NDK/Guide/audio/MAIN"} include file
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_IO_H
#include <@{"exec/io.h" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File"}>
#endif

#define AUDIONAME               "audio.device"

#define ADHARD_CHANNELS         4

#define ADALLOC_MINPREC         -128
#define ADALLOC_MAXPREC         127

#define @{"ADCMD_FREE" LINK "gg:doc/NDK/Guide/audio/ADCMD_FREE"}              (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+0)
#define @{"ADCMD_SETPREC" LINK "gg:doc/NDK/Guide/audio/ADCMD_SETPREC"}           (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+1)
#define @{"ADCMD_FINISH" LINK "gg:doc/NDK/Guide/audio/ADCMD_FINISH"}            (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+2)
#define @{"ADCMD_PERVOL" LINK "gg:doc/NDK/Guide/audio/ADCMD_PERVOL"}            (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+3)
#define @{"ADCMD_LOCK" LINK "gg:doc/NDK/Guide/audio/ADCMD_LOCK"}              (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+4)
#define @{"ADCMD_WAITCYCLE" LINK "gg:doc/NDK/Guide/audio/ADCMD_WAITCYCLE"}         (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+5)
#define @{"ADCMD_ALLOCATE" LINK "gg:doc/NDK/Guide/audio/ADCMD_ALLOCATE"}          32

#define ADIOB_PERVOL            4
#define ADIOF_PERVOL            (1<<4)
#define ADIOB_SYNCCYCLE         5
#define ADIOF_SYNCCYCLE         (1<<5)
#define ADIOB_NOWAIT            6
#define ADIOF_NOWAIT            (1<<6)
#define ADIOB_WRITEMESSAGE      7
#define ADIOF_WRITEMESSAGE      (1<<7)

#define ADIOERR_NOALLOCATION    -10
#define ADIOERR_ALLOCFAILED     -11
#define ADIOERR_CHANNELSTOLEN   -12

struct IOAudio {
    @{"struct IORequest" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 18} ioa_Request;
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} ioa_AllocKey;
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *ioa_Data;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} ioa_Length;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ioa_Period;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ioa_Volume;
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} ioa_Cycles;
    @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} ioa_WriteMsg;
};

#endif  /* DEVICES_AUDIO_H */
@ENDNODE
