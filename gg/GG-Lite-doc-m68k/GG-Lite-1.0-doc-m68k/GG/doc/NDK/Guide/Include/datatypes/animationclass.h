@DATABASE "gg:doc/NDK/Guide/Include/datatypes/animationclass.h"
@MASTER   "gg:os-include/datatypes/animationclass.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:05
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "datatypes/animationclass.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"datatypes/animationclass.h" LINK File}


@{b}Structures@{ub}

@{"adtFrame" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 207}  @{"adtNewFormatFrame" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 229}  @{"adtStart" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 257}  @{"AnimHeader" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 101}


@{b}#defines@{ub}

@{"ADTA_Allocated" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 51}       @{"ADTA_ColorRegisters" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 46}        @{"ADTA_ColorTable" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 49}
@{"ADTA_ColorTable2" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 50}     @{"ADTA_CRegs" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 47}                 @{"ADTA_Cycles" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 86}
@{"ADTA_Depth" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 63}           @{"ADTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 40}                 @{"ADTA_Frame" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 68}
@{"ADTA_FrameIncrement" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 76}  @{"ADTA_Frames" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 65}                @{"ADTA_FramesPerSecond" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 71}
@{"ADTA_GRegs" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 48}           @{"ADTA_Height" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 62}                @{"ADTA_KeyFrame" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 44}
@{"ADTA_LeftSample" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 88}      @{"ADTA_ModeID" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 41}                @{"ADTA_NumAlloc" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 53}
@{"ADTA_NumColors" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 52}       @{"ADTA_Period" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 84}                @{"ADTA_PreloadFrameCount" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 79}
@{"ADTA_Remap" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 56}           @{"ADTA_RightSample" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 89}           @{"ADTA_Sample" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 82}
@{"ADTA_SampleLength" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 83}    @{"ADTA_SamplesPerSec" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 90}         @{"ADTA_Screen" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 59}
@{"ADTA_Volume" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 85}          @{"ADTA_Width" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 61}                 @{"ADTM_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 178}
@{"ADTM_LOADFRAME" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 181}       @{"ADTM_LOADNEWFORMATFRAME" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 199}    @{"ADTM_LOCATE" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 196}
@{"ADTM_PAUSE" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 190}           @{"ADTM_START" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 187}                 @{"ADTM_STOP" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 193}
@{"ADTM_UNLOADFRAME" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 184}     @{"ADTM_UNLOADNEWFORMATFRAME" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 202}  @{"ANIMATIONDTCLASS" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 35}
@{"ID_ANHD" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 95}              @{"ID_ANIM" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 94}                    @{"ID_DLTA" LINK "gg:doc/NDK/Guide/Include/datatypes/animationclass.h/File" 96}

@ENDNODE
@NODE File "datatypes/animationclass.h"
#ifndef DATATYPES_ANIMATIONCLASS_H
#define DATATYPES_ANIMATIONCLASS_H
/*
**      $VER: animationclass.h 44.2 (27.3.1999)
**      Includes Release 45.1
**
**      Interface definitions for DataType animation objects.
**
**      (C) Copyright 1992-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

#ifndef DATATYPES_DATATYPESCLASS_H
#include <@{"datatypes/datatypesclass.h" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File"}>
#endif

#ifndef DATATYPES_PICTURECLASS_H
#include <@{"datatypes/pictureclass.h" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File"}>
#endif

#ifndef DATATYPES_SOUNDCLASS_H
#include <@{"datatypes/soundclass.h" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File"}>
#endif

#ifndef LIBRARIES_IFFPARSE_H
#include <@{"libraries/iffparse.h" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File"}>
#endif

/*****************************************************************************/

#define ANIMATIONDTCLASS                "animation.datatype"

/*****************************************************************************/

/* Animation attributes */
#define ADTA_Dummy              (@{"DTA_Dummy" LINK "gg:doc/NDK/Guide/Include/datatypes/datatypesclass.h/File" 39} + 600)
#define ADTA_ModeID             @{"PDTA_ModeID" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 34}

/* (@{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *) Key frame (first frame) bitmap */
#define ADTA_KeyFrame           @{"PDTA_BitMap" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 43}

#define ADTA_ColorRegisters     @{"PDTA_ColorRegisters" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 46}
#define ADTA_CRegs              @{"PDTA_CRegs" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 49}
#define ADTA_GRegs              @{"PDTA_GRegs" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 56}
#define ADTA_ColorTable         @{"PDTA_ColorTable" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 61}
#define ADTA_ColorTable2        @{"PDTA_ColorTable2" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 69}
#define ADTA_Allocated          @{"PDTA_Allocated" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 72}
#define ADTA_NumColors          @{"PDTA_NumColors" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 75}
#define ADTA_NumAlloc           @{"PDTA_NumAlloc" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 78}

/* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) : Remap animation (defaults to @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95}) */
#define ADTA_Remap              @{"PDTA_Remap" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 81}

/* (@{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} *) Screen to remap to */
#define ADTA_Screen             @{"PDTA_Screen" LINK "gg:doc/NDK/Guide/Include/datatypes/pictureclass.h/File" 84}

#define ADTA_Width              (@{"ADTA_Dummy" LINK File 40} + 1)
#define ADTA_Height             (@{"ADTA_Dummy" LINK File 40} + 2)
#define ADTA_Depth              (@{"ADTA_Dummy" LINK File 40} + 3)
/* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Number of frames in the animation */
#define ADTA_Frames             (@{"ADTA_Dummy" LINK File 40} + 4)

/* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Current frame */
#define ADTA_Frame              (@{"ADTA_Dummy" LINK File 40} + 5)

/* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Frames per second */
#define ADTA_FramesPerSecond    (@{"ADTA_Dummy" LINK File 40} + 6)

/* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Amount to change frame by when fast forwarding or
 * rewinding.  Defaults to 10.
 */
#define ADTA_FrameIncrement     (@{"ADTA_Dummy" LINK File 40} + 7)

/* (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) Number of frames to preload; defaults to 10 */
#define ADTA_PreloadFrameCount  (@{"ADTA_Dummy" LINK File 40} + 8)        /* (V44) */

/* Sound attributes */
#define ADTA_Sample             @{"SDTA_Sample" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 40}
#define ADTA_SampleLength       @{"SDTA_SampleLength" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 43}
#define ADTA_Period             @{"SDTA_Period" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 46}
#define ADTA_Volume             @{"SDTA_Volume" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 49}
#define ADTA_Cycles             @{"SDTA_Cycles" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 51}

#define ADTA_LeftSample         @{"SDTA_LeftSample" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 85}         /* (V44) */
#define ADTA_RightSample        @{"SDTA_RightSample" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 86}        /* (V44) */
#define ADTA_SamplesPerSec      @{"SDTA_SamplesPerSec" LINK "gg:doc/NDK/Guide/Include/datatypes/soundclass.h/File" 79}      /* (V44) */

/*****************************************************************************/

#define ID_ANIM         @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('A','N','I','M')
#define ID_ANHD         @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('A','N','H','D')
#define ID_DLTA         @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}('D','L','T','A')

/*****************************************************************************/

/*  Required ANHD structure describes an ANIM frame */
struct AnimHeader
{
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}        ah_Operation;  /*  The compression method:
                                     0  set directly (normal ILBM BODY),
                                     1  XOR ILBM mode,
                                     2  Long Delta mode,
                                     3  Short Delta mode,
                                     4  Generalized short/long Delta mode,
                                     5  Byte Vertical Delta mode
                                     6  Stereo op 5 (third party)
                                    74  (ascii 'J') reserved for Eric Graham's
                                        compression technique (details to be
                                        released later). */

    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}        ah_Mask;       /* (XOR mode only - plane mask where each
                                   bit is set =1 if there is data and =0
                                   if not.) */

    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}        ah_Width;      /* (XOR mode only - width and height of the */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}        ah_Height;     /* area represented by the BODY to eliminate */
                                /* unnecessary un-changed data) */


    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}         ah_Left;       /* (XOR mode only - position of rectangular */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}         ah_Top;        /* area representd by the BODY) */


    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        ah_AbsTime;    /* Timing for a frame relative to the time
                                   the first frame was displayed, in
                                   jiffies (1/60 sec) */

    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        ah_RelTime;    /* Timing for frame relative to time
                                   previous frame was displayed - in
                                   jiffies (1/60 sec) */

    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}        ah_Interleave; /* Indicates how may frames back this data is to
                                   modify.  0 defaults to indicate two frames back
                                   (for double buffering). n indicates n frames back.
                                   The main intent here is to allow values
                                   of 1 for special applications where
                                   frame data would modify the immediately
                                   previous frame. */

    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}        ah_Pad0;       /* Pad byte, not used at present. */

    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}        ah_Flags;      /* 32 option bits used by options=4 and 5.
                                   At present only 6 are identified, but the
                                   rest are set =0 so they can be used to
                                   implement future ideas.  These are defined
                                   for option 4 only at this point.  It is
                                   recommended that all bits be set =0 for
                                   option 5 and that any bit settings
                                   used in the future (such as for XOR mode)
                                   be compatible with the option 4
                                   bit settings.   Player code should check
                                   undefined bits in options 4 and 5 to assure
                                   they are zero.

                                   The six bits for current use are:

                                    bit #       set =0                  set =1
                                    ===============================================
                                    0           short data              long data
                                    1           set                     XOR
                                    2           separate info           one info list
                                                for each plane          for all planes
                                    3           not RLC                 RLC (run length coded)
                                    4           horizontal              vertical
                                    5           short info offsets      long info offsets
                                */

    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}        ah_Pad[16];    /* This is a pad for future use for future
                                   compression modes. */
};

/*****************************************************************************/

#define ADTM_Dummy              (0x700)

/* Used to load a frame of the animation */
#define ADTM_LOADFRAME          (0x701)

/* Used to unload a frame of the animation */
#define ADTM_UNLOADFRAME        (0x702)

/* Used to start the animation */
#define ADTM_START              (0x703)

/* Used to pause the animation (don't reset the timer) */
#define ADTM_PAUSE              (0x704)

/* Used to stop the animation */
#define ADTM_STOP               (0x705)

/* Used to locate a frame in the animation (as set by a slider...) */
#define ADTM_LOCATE             (0x706)

/* Used to load a new format frame of the animation (V44) */
#define ADTM_LOADNEWFORMATFRAME (0x707)

/* Used to unload a new format frame of the animation (V44) */
#define ADTM_UNLOADNEWFORMATFRAME (0x708)

/*****************************************************************************/

/* @{"ADTM_LOADFRAME" LINK File 181}, @{"ADTM_UNLOADFRAME" LINK File 184} */
struct adtFrame
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                MethodID;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                alf_TimeStamp;         /* Timestamp of frame to load */

    /* The following fields are filled in by the @{"ADTM_LOADFRAME" LINK File 181} method, */
    /* and are read-only for any other methods. */

    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                alf_Frame;             /* Frame number */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                alf_Duration;          /* Duration of frame */

    @{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46}       *alf_BitMap;            /* Loaded BitMap */
    @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143}     *alf_CMap;              /* Colormap, if changed */

    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}                *alf_Sample;            /* Sound data */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                alf_SampleLength;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                alf_Period;

    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}                 alf_UserData;          /* Used by load frame for extra data */
};

/* @{"ADTM_LOADNEWFORMATFRAME" LINK File 199}, @{"ADTM_UNLOADNEWFORMATFRAME" LINK File 202} */
struct adtNewFormatFrame
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               MethodID;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               alf_TimeStamp;          /* Timestamp of frame to load */

    /* The following fields are filled in by the ADTM_NEWLOADFRAME method, */
    /* and are read-only for any other methods. */

    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               alf_Frame;              /* Frame number */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               alf_Duration;           /* Duration of frame */

    @{"struct BitMap" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 46} *     alf_BitMap;             /* Loaded BitMap */
    @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *   alf_CMap;               /* Colormap, if changed */

    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} *              alf_Sample;             /* Sound data */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               alf_SampleLength;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               alf_Period;

    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}                alf_UserData;           /* Used by load frame for extra data */

    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               alf_Size;               /* Size of this data structure (in bytes) */

    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} *              alf_LeftSample;         /* Sound for left channel, or @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} if none */
    @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58} *              alf_RightSample;        /* Sound for right channel, or @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} if none */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               alf_SamplesPerSec;      /* Replay speed; if > 0, this overrides alf_Period */
};

/* @{"ADTM_START" LINK File 187}, @{"ADTM_PAUSE" LINK File 190}, @{"ADTM_STOP" LINK File 193}, @{"ADTM_LOCATE" LINK File 196} */
struct adtStart
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                MethodID;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                asa_Frame;             /* Frame # to start at */
};

/*****************************************************************************/

#endif  /* DATATYPES_ANIMATIONCLASS_H */
@ENDNODE
