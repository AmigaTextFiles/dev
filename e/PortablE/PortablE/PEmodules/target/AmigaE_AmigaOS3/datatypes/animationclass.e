/* $VER: animationclass.h 44.2 (27.3.1999) */
OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/libraries/iff_shared6'
MODULE 'target/utility/tagitem', 'target/datatypes/datatypesclass', 'target/datatypes/pictureclass', 'target/datatypes/soundclass', 'target/libraries/iffparse'
MODULE 'target/exec/types', 'target/graphics/gfx', 'target/graphics/view'
{MODULE 'datatypes/animationclass'}

NATIVE {ANIMATIONDTCLASS}		CONST
#define ANIMATIONDTCLASS animationdtclass
STATIC animationdtclass		= 'animation.datatype'

/*****************************************************************************/

/* Animation attributes */
NATIVE {ADTA_DUMMY}		CONST ADTA_DUMMY		= (DTA_DUMMY + 600)
NATIVE {ADTA_MODEID}		CONST ADTA_MODEID		= PDTA_MODEID

/* (struct BitMap *) Key frame (first frame) bitmap */
NATIVE {ADTA_KEYFRAME}		CONST ADTA_KEYFRAME		= PDTA_BITMAP

NATIVE {ADTA_COLORREGISTERS}	CONST ADTA_COLORREGISTERS	= PDTA_COLORREGISTERS
NATIVE {ADTA_CREGS}		CONST ADTA_CREGS		= PDTA_CREGS
NATIVE {ADTA_GREGS}		CONST ADTA_GREGS		= PDTA_GREGS
NATIVE {ADTA_COLORTABLE}		CONST ADTA_COLORTABLE		= PDTA_COLORTABLE
NATIVE {ADTA_COLORTABLE2}	CONST ADTA_COLORTABLE2	= PDTA_COLORTABLE2
NATIVE {ADTA_ALLOCATED}		CONST ADTA_ALLOCATED		= PDTA_ALLOCATED
NATIVE {ADTA_NUMCOLORS}		CONST ADTA_NUMCOLORS		= PDTA_NUMCOLORS
NATIVE {ADTA_NUMALLOC}		CONST ADTA_NUMALLOC		= PDTA_NUMALLOC

/* (BOOL) : Remap animation (defaults to TRUE) */
NATIVE {ADTA_REMAP}		CONST ADTA_REMAP		= PDTA_REMAP

/* (struct Screen *) Screen to remap to */
NATIVE {ADTA_SCREEN}		CONST ADTA_SCREEN		= PDTA_SCREEN

NATIVE {ADTA_WIDTH}		CONST ADTA_WIDTH		= (ADTA_DUMMY + 1)
NATIVE {ADTA_HEIGHT}		CONST ADTA_HEIGHT		= (ADTA_DUMMY + 2)
NATIVE {ADTA_DEPTH}		CONST ADTA_DEPTH		= (ADTA_DUMMY + 3)
/* (ULONG) Number of frames in the animation */
NATIVE {ADTA_FRAMES}		CONST ADTA_FRAMES		= (ADTA_DUMMY + 4)

/* (ULONG) Current frame */
NATIVE {ADTA_FRAME}		CONST ADTA_FRAME		= (ADTA_DUMMY + 5)

/* (ULONG) Frames per second */
NATIVE {ADTA_FRAMESPERSECOND}	CONST ADTA_FRAMESPERSECOND	= (ADTA_DUMMY + 6)

/* (LONG) Amount to change frame by when fast forwarding or
 * rewinding.  Defaults to 10.
 */
NATIVE {ADTA_FRAMEINCREMENT}	CONST ADTA_FRAMEINCREMENT	= (ADTA_DUMMY + 7)

/* (ULONG) Number of frames to preload; defaults to 10 */
CONST ADTA_PRELOADFRAMECOUNT	= (ADTA_DUMMY + 8)	/* (V44) */

/* Sound attributes */
NATIVE {ADTA_SAMPLE}		CONST ADTA_SAMPLE		= SDTA_SAMPLE
NATIVE {ADTA_SAMPLELENGTH}	CONST ADTA_SAMPLELENGTH	= SDTA_SAMPLELENGTH
NATIVE {ADTA_PERIOD}		CONST ADTA_PERIOD		= SDTA_PERIOD
NATIVE {ADTA_VOLUME}		CONST ADTA_VOLUME		= SDTA_VOLUME
NATIVE {ADTA_CYCLES}		CONST ADTA_CYCLES		= SDTA_CYCLES

CONST ADTA_LEFTSAMPLE		= SDTA_LEFTSAMPLE		/* (V44) */
CONST ADTA_RIGHTSAMPLE	= SDTA_RIGHTSAMPLE	/* (V44) */
CONST ADTA_SAMPLESPERSEC	= SDTA_SAMPLESPERSEC	/* (V44) */

/*****************************************************************************/

->"CONST ID_ANIM" is on-purposely missing from here (it can be found in 'libraries/iff_shared6')
->"CONST ID_ANHD" is on-purposely missing from here (it can be found in 'libraries/iff_shared6')
->"CONST ID_DLTA" is on-purposely missing from here (it can be found in 'libraries/iff_shared6')

/*****************************************************************************/

/*  Required ANHD structure describes an ANIM frame */
NATIVE {animheader} OBJECT animheader
    {operation}	operation	:UBYTE	/*  The compression method:
				     0	set directly (normal ILBM BODY),
				     1	XOR ILBM mode,
				     2	Long Delta mode,
				     3	Short Delta mode,
				     4	Generalized short/long Delta mode,
				     5	Byte Vertical Delta mode
				     6	Stereo op 5 (third party)
				    74	(ascii 'J') reserved for Eric Graham's
				        compression technique (details to be
				        released later). */

    {mask}	mask	:UBYTE	/* (XOR mode only - plane mask where each
				   bit is set =1 if there is data and =0
				   if not.) */

    {width}	width	:UINT      /* (XOR mode only - width and height of the */
    {height}	height	:UINT	/* area represented by the BODY to eliminate */
				/* unnecessary un-changed data) */


    {left}	left	:INT	/* (XOR mode only - position of rectangular */
    {top}	top	:INT	/* area representd by the BODY) */


    {abstime}	abstime	:ULONG	/* Timing for a frame relative to the time
				   the first frame was displayed, in
				   jiffies (1/60 sec) */

    {reltime}	reltime	:ULONG	/* Timing for frame relative to time
                                   previous frame was displayed - in
				   jiffies (1/60 sec) */

    {interleave}	interleave	:UBYTE	/* Indicates how may frames back this data is to
				   modify.  0 defaults to indicate two frames back
				   (for double buffering). n indicates n frames back.
				   The main intent here is to allow values
				   of 1 for special applications where
				   frame data would modify the immediately
				   previous frame. */

    {pad0}	pad0	:UBYTE	/* Pad byte, not used at present. */

    {flags}	flags	:ULONG	/* 32 option bits used by options=4 and 5.
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

				    bit #	set =0			set =1
				    ===============================================
				    0		short data		long data
				    1		set       		XOR
				    2		separate info		one info list
						for each plane		for all planes
				    3		not RLC			RLC (run length coded)
				    4		horizontal		vertical
				    5		short info offsets	long info offsets
				*/

    {pad}	pad[16]	:ARRAY OF UBYTE	/* This is a pad for future use for future
				   compression modes. */
ENDOBJECT

/*****************************************************************************/

NATIVE {ADTM_DUMMY}		CONST ADTM_DUMMY		= ($700)

/* Used to load a frame of the animation */
NATIVE {ADTM_LOADFRAME}		CONST ADTM_LOADFRAME		= ($701)

/* Used to unload a frame of the animation */
NATIVE {ADTM_UNLOADFRAME}	CONST ADTM_UNLOADFRAME	= ($702)

/* Used to start the animation */
NATIVE {ADTM_START}		CONST ADTM_START		= ($703)

/* Used to pause the animation (don't reset the timer) */
NATIVE {ADTM_PAUSE}		CONST ADTM_PAUSE		= ($704)

/* Used to stop the animation */
NATIVE {ADTM_STOP}		CONST ADTM_STOP		= ($705)

/* Used to locate a frame in the animation (as set by a slider...) */
NATIVE {ADTM_LOCATE}		CONST ADTM_LOCATE		= ($706)

/* Used to load a new format frame of the animation (V44) */
CONST ADTM_LOADNEWFORMATFRAME	= ($707)

/* Used to unload a new format frame of the animation (V44) */
CONST ADTM_UNLOADNEWFORMATFRAME = ($708)

/*****************************************************************************/

/* ADTM_LOADFRAME, ADTM_UNLOADFRAME */
NATIVE {adtframe} OBJECT adtframe
    {methodid}	methodid	:ULONG
    {timestamp}	timestamp	:ULONG		/* Timestamp of frame to load */

    /* The following fields are filled in by the ADTM_LOADFRAME method, */
    /* and are read-only for any other methods. */

    {frame}	frame	:ULONG		/* Frame number */
    {duration}	duration	:ULONG		/* Duration of frame */

    {bitmap}	bitmap	:PTR TO bitmap		/* Loaded BitMap */
    {cmap}	cmap	:PTR TO colormap		/* Colormap, if changed */

    {sample}	sample	:PTR TO BYTE		/* Sound data */
    {samplelength}	samplelength	:ULONG
    {period}	period	:ULONG

    {userdata}	userdata	:APTR		/* Used by load frame for extra data */
ENDOBJECT

/* ADTM_LOADNEWFORMATFRAME, ADTM_UNLOADNEWFORMATFRAME */
OBJECT adtnewformatframe
    methodid	:ULONG
    timestamp	:ULONG		/* Timestamp of frame to load */

    /* The following fields are filled in by the ADTM_NEWLOADFRAME method, */
    /* and are read-only for any other methods. */

    frame	:ULONG		/* Frame number */
    duration	:ULONG		/* Duration of frame */

    bitmap	:PTR TO bitmap		/* Loaded BitMap */
    cmap	:PTR TO colormap		/* Colormap, if changed */

    sample	:PTR TO BYTE		/* Sound data */
    samplelength	:ULONG
    period	:ULONG

    userdata	:APTR		/* Used by load frame for extra data */

    size	:ULONG		/* Size of this data structure (in bytes) */

    leftsample	:PTR TO BYTE		/* Sound for left channel, or NULL if none */
    rightsample	:PTR TO BYTE	/* Sound for right channel, or NULL if none */
    samplespersec	:ULONG	/* Replay speed; if > 0, this overrides alf_Period */
ENDOBJECT

/* ADTM_START, ADTM_PAUSE, ADTM_STOP, ADTM_LOCATE */
NATIVE {adtstart} OBJECT adtstart
    {methodid}	methodid	:ULONG
    {frame}	frame	:ULONG		/* Frame # to start at */
ENDOBJECT
