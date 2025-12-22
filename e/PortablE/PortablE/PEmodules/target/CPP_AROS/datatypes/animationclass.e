OPT NATIVE, PREPROCESS
MODULE 'target/utility/tagitem', 'target/datatypes/datatypesclass', 'target/datatypes/pictureclass', 'target/datatypes/soundclass', 'target/libraries/iffparse'
MODULE 'target/exec/types', 'target/graphics/gfx', 'target/graphics/view'
{#include <datatypes/animationclass.h>}
NATIVE {DATATYPES_ANIMATIONCLASS_H} CONST

NATIVE {ANIMATIONDTCLASS}	CONST
#define ANIMATIONDTCLASS animationdtclass
STATIC animationdtclass	= 'animation.datatype'

/* Tags */
NATIVE {ADTA_Dummy}		CONST ADTA_DUMMY		= (DTA_DUMMY + 600)
NATIVE {ADTA_ModeID}		CONST ADTA_MODEID		= PDTA_MODEID
NATIVE {ADTA_KeyFrame}		CONST ADTA_KEYFRAME		= PDTA_BITMAP
NATIVE {ADTA_ColorRegisters}	CONST ADTA_COLORREGISTERS	= PDTA_COLORREGISTERS
NATIVE {ADTA_CRegs}		CONST ADTA_CREGS		= PDTA_CREGS
NATIVE {ADTA_GRegs}		CONST ADTA_GREGS		= PDTA_GREGS
NATIVE {ADTA_ColorTable}		CONST ADTA_COLORTABLE		= PDTA_COLORTABLE
NATIVE {ADTA_ColorTable2}	CONST ADTA_COLORTABLE2	= PDTA_COLORTABLE2
NATIVE {ADTA_Allocated}		CONST ADTA_ALLOCATED		= PDTA_ALLOCATED
NATIVE {ADTA_NumColors}		CONST ADTA_NUMCOLORS		= PDTA_NUMCOLORS
NATIVE {ADTA_NumAlloc}		CONST ADTA_NUMALLOC		= PDTA_NUMALLOC
NATIVE {ADTA_Remap}		CONST ADTA_REMAP		= PDTA_REMAP
NATIVE {ADTA_Screen}		CONST ADTA_SCREEN		= PDTA_SCREEN
NATIVE {ADTA_Width}		CONST ADTA_WIDTH		= (ADTA_DUMMY + 1)
NATIVE {ADTA_Height}		CONST ADTA_HEIGHT		= (ADTA_DUMMY + 2)
NATIVE {ADTA_Depth}		CONST ADTA_DEPTH		= (ADTA_DUMMY + 3)
NATIVE {ADTA_Frames}		CONST ADTA_FRAMES		= (ADTA_DUMMY + 4)
NATIVE {ADTA_Frame}		CONST ADTA_FRAME		= (ADTA_DUMMY + 5)
NATIVE {ADTA_FramesPerSecond}	CONST ADTA_FRAMESPERSECOND	= (ADTA_DUMMY + 6)
NATIVE {ADTA_FrameIncrement}	CONST ADTA_FRAMEINCREMENT	= (ADTA_DUMMY + 7)
NATIVE {ADTA_Sample}		CONST ADTA_SAMPLE		= SDTA_SAMPLE
NATIVE {ADTA_SampleLength}	CONST ADTA_SAMPLELENGTH	= SDTA_SAMPLELENGTH
NATIVE {ADTA_Period}		CONST ADTA_PERIOD		= SDTA_PERIOD
NATIVE {ADTA_Volume}		CONST ADTA_VOLUME		= SDTA_VOLUME
NATIVE {ADTA_Cycles}		CONST ADTA_CYCLES		= SDTA_CYCLES

/* New in V44 */
NATIVE {ADTA_PreloadFrameCount}	CONST ADTA_PRELOADFRAMECOUNT	= (ADTA_DUMMY + 8)
NATIVE {ADTA_LeftSample}		CONST ADTA_LEFTSAMPLE		= SDTA_LEFTSAMPLE
NATIVE {ADTA_RightSample}	CONST ADTA_RIGHTSAMPLE	= SDTA_RIGHTSAMPLE
NATIVE {ADTA_SamplesPerSec}	CONST ADTA_SAMPLESPERSEC	= SDTA_SAMPLESPERSEC

/* IFF ANIM chunks */

NATIVE {ID_ANIM}             	CONST ID_ANIM             	= "ANIM"
NATIVE {ID_ANHD}             	CONST ID_ANHD             	= "ANHD"
NATIVE {ID_DLTA}             	CONST ID_DLTA             	= "DLTA"

NATIVE {AnimHeader} OBJECT animheader
    {ah_Operation}	operation	:UBYTE
    {ah_Mask}	mask	:UBYTE
    {ah_Width}	width	:UINT
    {ah_Height}	height	:UINT
    {ah_Left}	left	:INT
    {ah_Top}	top	:INT
    {ah_AbsTime}	abstime	:ULONG
    {ah_RelTime}	reltime	:ULONG
    {ah_Interleave}	interleave	:UBYTE
    {ah_Pad0}	pad0	:UBYTE
    {ah_Flags}	flags	:ULONG
    {ah_Pad}	pad[16]	:ARRAY OF UBYTE
ENDOBJECT

/* Methods */

NATIVE {ADTM_Dummy}		CONST ADTM_DUMMY		= $700
NATIVE {ADTM_LOADFRAME}		CONST ADTM_LOADFRAME		= $701
NATIVE {ADTM_UNLOADFRAME}	CONST ADTM_UNLOADFRAME	= $702
NATIVE {ADTM_START}		CONST ADTM_START		= $703
NATIVE {ADTM_PAUSE}		CONST ADTM_PAUSE		= $704
NATIVE {ADTM_STOP}		CONST ADTM_STOP		= $705
NATIVE {ADTM_LOCATE}		CONST ADTM_LOCATE		= $706

/* New in V44 */
NATIVE {ADTM_LOADNEWFORMATFRAME}	    CONST ADTM_LOADNEWFORMATFRAME	    = $707
NATIVE {ADTM_UNLOADNEWFORMATFRAME}   CONST ADTM_UNLOADNEWFORMATFRAME   = $708

NATIVE {adtFrame} OBJECT adtframe
    {MethodID}	methodid	:ULONG
    {alf_TimeStamp}	timestamp	:ULONG
    {alf_Frame}	frame	:ULONG
    {alf_Duration}	duration	:ULONG
    {alf_BitMap}	bitmap	:PTR TO bitmap
    {alf_CMap}	cmap	:PTR TO colormap
    {alf_Sample}	sample	:PTR TO BYTE
    {alf_SampleLength}	samplelength	:ULONG
    {alf_Period}	period	:ULONG
    {alf_UserData}	userdata	:APTR
ENDOBJECT

NATIVE {adtNewFormatFrame} OBJECT adtnewformatframe
    {MethodID}	methodid	:ULONG
    {alf_TimeStamp}	timestamp	:ULONG
    {alf_Frame}	frame	:ULONG
    {alf_Duration}	duration	:ULONG
    {alf_BitMap}	bitmap	:PTR TO bitmap
    {alf_CMap}	cmap	:PTR TO colormap
    {alf_Sample}	sample	:PTR TO BYTE
    {alf_SampleLength}	samplelength	:ULONG
    {alf_Period}	period	:ULONG
    {alf_UserData}	userdata	:APTR
    {alf_Size}	size	:ULONG
    {alf_LeftSample}	leftsample	:PTR TO BYTE
    {alf_RightSample}	rightsample	:PTR TO BYTE
    {alf_SamplesPerSec}	samplespersec	:ULONG
ENDOBJECT

NATIVE {adtStart} OBJECT adtstart
    {MethodID}	methodid	:ULONG
    {asa_Frame}	frame	:ULONG
ENDOBJECT
