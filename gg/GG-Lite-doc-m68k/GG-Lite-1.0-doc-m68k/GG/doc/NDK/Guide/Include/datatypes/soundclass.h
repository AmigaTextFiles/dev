@DATABASE "gg:doc/NDK/Guide/Include/datatypes/soundclass.h"
@MASTER   "gg:os-include/datatypes/soundclass.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:14
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "datatypes/soundclass.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"datatypes/soundclass.h" LINK File}


@{b}Structures@{ub}

@{"VoiceHeader" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 112}


@{b}Typedefs@{ub}

@{"SampleType" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 133}


@{b}#defines@{ub}

@{"CMP_FIBDELTA" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 103}         @{"CMP_NONE" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 102}               @{"ID_8SVX" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 138}
@{"ID_BODY" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 141}              @{"ID_CHAN" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 140}                @{"ID_VHDR" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 139}
@{"SAMPLETYPE_Left" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 129}      @{"SAMPLETYPE_Right" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 130}       @{"SAMPLETYPE_Stereo" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 131}
@{"SDTA_Continuous" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 71}      @{"SDTA_Cycles" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 51}            @{"SDTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 36}
@{"SDTA_FreeSampleData" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 92}  @{"SDTA_LeftSample" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 85}        @{"SDTA_Pan" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 89}
@{"SDTA_Period" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 46}          @{"SDTA_ReplayPeriod" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 82}      @{"SDTA_RightSample" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 86}
@{"SDTA_Sample" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 40}          @{"SDTA_SampleLength" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 43}      @{"SDTA_SamplesPerSec" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 79}
@{"SDTA_SignalBit" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 67}       @{"SDTA_SignalBitMask" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 68}     @{"SDTA_SignalBitNumber" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 76}
@{"SDTA_SignalTask" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 56}      @{"SDTA_SyncSampleChange" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 97}  @{"SDTA_VoiceHeader" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 37}
@{"SDTA_Volume" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 49}          @{"SOUNDDTCLASS" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 31}           @{"Unity" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 108}

@ENDNODE
@NODE File "datatypes/soundclass.h"
#ifndef DATATYPES_SOUNDCLASS_H
#define DATATYPES_SOUNDCLASS_H
/*
**      $VER: soundclass.h 44.7 (6.6.1999)
**      Includes Release 45.1
**
**      Interface definitions for DataType sound objects.
**
**      Copyright © 1992-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

#ifndef DATATYPES_DATATYPESCLASS_H
#include <@{"datatypes/datatypesclass.h" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File"}>
#endif

#ifndef LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif

#ifndef DEVICES_TIMER_H
#include <@{"devices/timer.h" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File"}>
#endif

/*****************************************************************************/

#define SOUNDDTCLASS            "sound.datatype"

/*****************************************************************************/

/* Sound attributes */
#define SDTA_Dummy              (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 500)
#define SDTA_VoiceHeader        (@{"SDTA_Dummy" LINK File 36} + 1)

/* (@{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} *) Sample data */
#define SDTA_Sample             (@{"SDTA_Dummy" LINK File 36} + 2)

/* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Length of the sample data in UBYTEs */
#define SDTA_SampleLength       (@{"SDTA_Dummy" LINK File 36} + 3)

/* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Period */
#define SDTA_Period             (@{"SDTA_Dummy" LINK File 36} + 4)

/* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Volume. Range from 0 to 64 */
#define SDTA_Volume             (@{"SDTA_Dummy" LINK File 36} + 5)

#define SDTA_Cycles             (@{"SDTA_Dummy" LINK File 36} + 6)

/* The following tags are new for V40 */

/* (@{"struct Task" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File" 24} *) Task to signal when sound is complete or next buffer needed. */
#define SDTA_SignalTask         (@{"SDTA_Dummy" LINK File 36} + 7)

/* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Signal mask to use on completion or 0 to disable
 *
 *         NOTE: Due to a bug in @{"sound.datatype" LINK "gg:doc/NDK/Guide/sound_dtc/sound.datatype"} V40 @{"SDTA_SignalBit" LINK File 67}
 *               was actually implemented as a signal mask as opposed
 *               to a bit number. The documentation now reflects
 *               this. If you intend to use a signal bit number
 *               instead of the mask, use the new V44 tag
 *               @{"SDTA_SignalBitNumber" LINK File 76} below.
 */
#define SDTA_SignalBit          (@{"SDTA_Dummy" LINK File 36} + 8)
#define SDTA_SignalBitMask      @{"SDTA_SignalBit" LINK File 67}

/* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Playing a continuous stream of data.  Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */
#define SDTA_Continuous         (@{"SDTA_Dummy" LINK File 36} + 9)

/* The following tags are new for V44 */

/* (@{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}) Signal bit to use on completion or -1 to disable */
#define SDTA_SignalBitNumber    (@{"SDTA_Dummy" LINK File 36} + 10)

/* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Samples per second */
#define SDTA_SamplesPerSec      (@{"SDTA_Dummy" LINK File 36} + 11)

/* (@{"struct timeval" LINK "gg:doc/NDK/Guide/Include/devices/timer.h/File" 30} *) Sample replay period */
#define SDTA_ReplayPeriod       (@{"SDTA_Dummy" LINK File 36} + 12)

/* (@{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} *) Sample data */
#define SDTA_LeftSample         (@{"SDTA_Dummy" LINK File 36} + 13)
#define SDTA_RightSample        (@{"SDTA_Dummy" LINK File 36} + 14)

/* (@{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}) Stereo panning */
#define SDTA_Pan                (@{"SDTA_Dummy" LINK File 36} + 15)

/* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) @{"FreeVec()" LINK "gg:doc/NDK/Guide/exec/FreeVec"} all sample data upon @{"OM_DISPOSE" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 64}. */
#define SDTA_FreeSampleData     (@{"SDTA_Dummy" LINK File 36} + 16)

/* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Wait for the current sample to be played back before
 * switching to the new sample data.
 */
#define SDTA_SyncSampleChange   (@{"SDTA_Dummy" LINK File 36} + 17)

/*****************************************************************************/

/* Data compression methods */
#define CMP_NONE     0
#define CMP_FIBDELTA 1

/*****************************************************************************/

/* Unity = Fixed 1.0 = maximum volume */
#define Unity 0x10000UL

/*****************************************************************************/

struct VoiceHeader
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} vh_OneShotHiSamples;      /* # samples in the high octave 1-shot part */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} vh_RepeatHiSamples;       /* # samples in the high octave repeat part */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} vh_SamplesPerHiCycle;     /* # samples/cycle in high octave, else 0 */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} vh_SamplesPerSec;         /* data sampling rate */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} vh_Octaves;               /* # of octaves of waveforms */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} vh_Compression;           /* data compression technique used */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} vh_Volume;                /* playback nominal volume from 0 to Unity
                                         * (full volume). Map this value into
                                         * the output hardware's dynamic range.
                                         */
};

/*****************************************************************************/

/* Channel allocation */
#define SAMPLETYPE_Left         (2L)
#define SAMPLETYPE_Right        (4L)
#define SAMPLETYPE_Stereo       (6L)

typedef long SampleType;

/*****************************************************************************/

/* IFF types */
#define ID_8SVX @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('8','S','V','X')
#define ID_VHDR @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('V','H','D','R')
#define ID_CHAN @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('C','H','A','N')
#define @{"ID_BODY" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 261} @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('B','O','D','Y')

/*****************************************************************************/

#endif  /* DATATYPES_SOUNDCLASS_H */
@ENDNODE
