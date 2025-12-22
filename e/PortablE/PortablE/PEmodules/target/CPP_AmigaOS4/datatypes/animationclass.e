/* $Id: animationclass.h,v 1.12 2005/11/10 15:31:11 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/libraries/iff_shared6'
MODULE 'target/utility/tagitem', 'target/datatypes/datatypesclass', 'target/datatypes/pictureclass', 'target/datatypes/soundclass', 'target/libraries/iffparse'
MODULE 'target/exec/types', 'target/graphics/gfx', 'target/graphics/view'
{#include <datatypes/animationclass.h>}
NATIVE {DATATYPES_ANIMATIONCLASS_H} CONST

NATIVE {ANIMATIONDTCLASS} CONST
#define ANIMATIONDTCLASS animationdtclass
STATIC animationdtclass = 'animation.datatype'

/*****************************************************************************/

/* Animation attributes */
NATIVE {ADTA_Dummy}             CONST ADTA_DUMMY             = (DTA_DUMMY + 600)
NATIVE {ADTA_ModeID}            CONST ADTA_MODEID            = PDTA_MODEID

/* (struct BitMap *) Key frame (first frame) bitmap */
NATIVE {ADTA_KeyFrame}          CONST ADTA_KEYFRAME          = PDTA_BITMAP

NATIVE {ADTA_ColorRegisters}    CONST ADTA_COLORREGISTERS    = PDTA_COLORREGISTERS
NATIVE {ADTA_CRegs}             CONST ADTA_CREGS             = PDTA_CREGS
NATIVE {ADTA_GRegs}             CONST ADTA_GREGS             = PDTA_GREGS
NATIVE {ADTA_ColorTable}        CONST ADTA_COLORTABLE        = PDTA_COLORTABLE
NATIVE {ADTA_ColorTable2}       CONST ADTA_COLORTABLE2       = PDTA_COLORTABLE2
NATIVE {ADTA_Allocated}         CONST ADTA_ALLOCATED         = PDTA_ALLOCATED
NATIVE {ADTA_NumColors}         CONST ADTA_NUMCOLORS         = PDTA_NUMCOLORS
NATIVE {ADTA_NumAlloc}          CONST ADTA_NUMALLOC          = PDTA_NUMALLOC

/* (BOOL) : Remap animation (defaults to TRUE) */
NATIVE {ADTA_Remap}             CONST ADTA_REMAP             = PDTA_REMAP

/* (struct Screen *) Screen to remap to */
NATIVE {ADTA_Screen}            CONST ADTA_SCREEN            = PDTA_SCREEN

NATIVE {ADTA_Width}             CONST ADTA_WIDTH             = (ADTA_DUMMY + 1)
NATIVE {ADTA_Height}            CONST ADTA_HEIGHT            = (ADTA_DUMMY + 2)
NATIVE {ADTA_Depth}             CONST ADTA_DEPTH             = (ADTA_DUMMY + 3)
/* (ULONG) Number of frames in the animation */
NATIVE {ADTA_Frames}            CONST ADTA_FRAMES            = (ADTA_DUMMY + 4)

/* (ULONG) Current frame */
NATIVE {ADTA_Frame}             CONST ADTA_FRAME             = (ADTA_DUMMY + 5)

/* (ULONG) Frames per second */
NATIVE {ADTA_FramesPerSecond}   CONST ADTA_FRAMESPERSECOND   = (ADTA_DUMMY + 6)

/* (LONG) Amount to change frame by when fast forwarding or
 * rewinding.  Defaults to 10.
 */
NATIVE {ADTA_FrameIncrement}    CONST ADTA_FRAMEINCREMENT    = (ADTA_DUMMY + 7)

/* (ULONG) Number of frames to preload; defaults to 10 */
NATIVE {ADTA_PreloadFrameCount} CONST ADTA_PRELOADFRAMECOUNT = (ADTA_DUMMY + 8)    /* (V44) */

/* Sound attributes */
NATIVE {ADTA_Sample}            CONST ADTA_SAMPLE            = SDTA_SAMPLE
NATIVE {ADTA_SampleLength}      CONST ADTA_SAMPLELENGTH      = SDTA_SAMPLELENGTH
NATIVE {ADTA_Period}            CONST ADTA_PERIOD            = SDTA_PERIOD
NATIVE {ADTA_Volume}            CONST ADTA_VOLUME            = SDTA_VOLUME
NATIVE {ADTA_Cycles}            CONST ADTA_CYCLES            = SDTA_CYCLES

NATIVE {ADTA_LeftSample}        CONST ADTA_LEFTSAMPLE        = SDTA_LEFTSAMPLE    /* (V44) */
NATIVE {ADTA_RightSample}       CONST ADTA_RIGHTSAMPLE       = SDTA_RIGHTSAMPLE   /* (V44) */
NATIVE {ADTA_SamplesPerSec}     CONST ADTA_SAMPLESPERSEC     = SDTA_SAMPLESPERSEC /* (V44) */

/*****************************************************************************/

->"CONST ID_ANIM" is on-purposely missing from here (it can be found in 'libraries/iff_shared6')
->"CONST ID_ANHD" is on-purposely missing from here (it can be found in 'libraries/iff_shared6')
->"CONST ID_DLTA" is on-purposely missing from here (it can be found in 'libraries/iff_shared6')

/*****************************************************************************/

/*  Required ANHD structure describes an ANIM frame */
NATIVE {AnimHeader} OBJECT animheader
    {ah_Operation}	operation	:UBYTE /* The compression method:
                           0 set directly (normal ILBM BODY),
                           1 XOR ILBM mode,
                           2 Long Delta mode,
                           3 Short Delta mode,
                           4 Generalized short/long Delta mode,
                           5 Byte Vertical Delta mode
                           6 Stereo op 5 (third party)
                          74 (ascii 'J') reserved for Eric Graham's
                             compression technique (details to be
                             released later). */

    {ah_Mask}	mask	:UBYTE /* (XOR mode only - plane mask where each
                      bit is set =1 if there is data and =0
                      if not.) */

    {ah_Width}	width	:UINT  /* (XOR mode only - width and height of the */
    {ah_Height}	height	:UINT /* area represented by the BODY to eliminate */
                     /* unnecessary un-changed data) */


    {ah_Left}	left	:INT   /* (XOR mode only - position of rectangular */
    {ah_Top}	top	:INT    /* area representd by the BODY) */


    {ah_AbsTime}	abstime	:ULONG /* Timing for a frame relative to the time
                         the first frame was displayed, in
                         jiffies (1/60 sec) */

    {ah_RelTime}	reltime	:ULONG /* Timing for frame relative to time
                         previous frame was displayed - in
                         jiffies (1/60 sec) */

    {ah_Interleave}	interleave	:UBYTE /* Indicates how may frames back this data is to
                            modify.  0 defaults to indicate two frames back
                            (for double buffering). n indicates n frames back.
                            The main intent here is to allow values
                            of 1 for special applications where
                            frame data would modify the immediately
                            previous frame. */

    {ah_Pad0}	pad0	:UBYTE  /* Pad byte, not used at present. */

    {ah_Flags}	flags	:ULONG /* 32 option bits used by options=4 and 5.
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

                        bit #    set =0             set =1
                        ================================================
                        0        short data         long data
                        1        set                XOR
                        2        separate info      one info list
                                 for each plane     for all planes
                        3        not RLC            RLC (run length coded)
                        4        horizontal         vertical
                        5        short info offsets long info offsets
                     */

    {ah_Pad}	pad[16]	:ARRAY OF UBYTE /* This is a pad for future use for future
                         compression modes. */
ENDOBJECT

/*****************************************************************************/

NATIVE {ADTM_Dummy}                CONST ADTM_DUMMY                = ($700)

/* Used to load a frame of the animation */
NATIVE {ADTM_LOADFRAME}            CONST ADTM_LOADFRAME            = ($701)

/* Used to unload a frame of the animation */
NATIVE {ADTM_UNLOADFRAME}          CONST ADTM_UNLOADFRAME          = ($702)

/* Used to start the animation */
NATIVE {ADTM_START}                CONST ADTM_START                = ($703)

/* Used to pause the animation (don't reset the timer) */
NATIVE {ADTM_PAUSE}                CONST ADTM_PAUSE                = ($704)

/* Used to stop the animation */
NATIVE {ADTM_STOP}                 CONST ADTM_STOP                 = ($705)

/* Used to locate a frame in the animation (as set by a slider...) */
NATIVE {ADTM_LOCATE}               CONST ADTM_LOCATE               = ($706)

/* Used to load a new format frame of the animation (V44) */
NATIVE {ADTM_LOADNEWFORMATFRAME}   CONST ADTM_LOADNEWFORMATFRAME   = ($707)

/* Used to unload a new format frame of the animation (V44) */
NATIVE {ADTM_UNLOADNEWFORMATFRAME} CONST ADTM_UNLOADNEWFORMATFRAME = ($708)

/*****************************************************************************/

/* ADTM_LOADFRAME, ADTM_UNLOADFRAME */
NATIVE {adtFrame} OBJECT adtframe
    {MethodID}	methodid	:ULONG
    {alf_TimeStamp}	timestamp	:ULONG    /* Timestamp of frame to load */

    /* The following fields are filled in by the ADTM_LOADFRAME method, */
    /* and are read-only for any other methods. */

    {alf_Frame}	frame	:ULONG        /* Frame number */
    {alf_Duration}	duration	:ULONG     /* Duration of frame */

    {alf_BitMap}	bitmap	:PTR TO bitmap       /* Loaded BitMap */
    {alf_CMap}	cmap	:PTR TO colormap         /* Colormap, if changed */

    {alf_Sample}	sample	:PTR TO BYTE       /* Sound data */
    {alf_SampleLength}	samplelength	:ULONG
    {alf_Period}	period	:ULONG

    {alf_UserData}	userdata	:APTR     /* Used by load frame for extra data */
ENDOBJECT

/* ADTM_LOADNEWFORMATFRAME, ADTM_UNLOADNEWFORMATFRAME */
NATIVE {adtNewFormatFrame} OBJECT adtnewformatframe
    {MethodID}	methodid	:ULONG
    {alf_TimeStamp}	timestamp	:ULONG     /* Timestamp of frame to load */

    /* The following fields are filled in by the ADTM_NEWLOADFRAME method, */
    /* and are read-only for any other methods. */

    {alf_Frame}	frame	:ULONG         /* Frame number */
    {alf_Duration}	duration	:ULONG      /* Duration of frame */

    {alf_BitMap}	bitmap	:PTR TO bitmap        /* Loaded BitMap */
    {alf_CMap}	cmap	:PTR TO colormap          /* Colormap, if changed */

    {alf_Sample}	sample	:PTR TO BYTE        /* Sound data */
    {alf_SampleLength}	samplelength	:ULONG
    {alf_Period}	period	:ULONG

    {alf_UserData}	userdata	:APTR      /* Used by load frame for extra data */

    {alf_Size}	size	:ULONG          /* Size of this data structure (in bytes) */

    {alf_LeftSample}	leftsample	:PTR TO BYTE    /* Sound for left channel, or NULL if none */
    {alf_RightSample}	rightsample	:PTR TO BYTE   /* Sound for right channel, or NULL if none */
    {alf_SamplesPerSec}	samplespersec	:ULONG /* Replay speed; if > 0, this overrides alf_Period */
ENDOBJECT

/* ADTM_START, ADTM_PAUSE, ADTM_STOP, ADTM_LOCATE */
NATIVE {adtStart} OBJECT adtstart
    {MethodID}	methodid	:ULONG
    {asa_Frame}	frame	:ULONG /* Frame # to start at */
ENDOBJECT
