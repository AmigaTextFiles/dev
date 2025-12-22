MODULE 'graphics/view'

#define ANIMATIONDTCLASS 		'animation.datatype'

#define ADTA_Dummy 		(DTA_Dummy + 600)
#define ADTA_ModeID 		PDTA_ModeID
#define ADTA_KeyFrame 		PDTA_BitMap
#define ADTA_ColorRegisters 	PDTA_ColorRegisters
#define ADTA_CRegs 		PDTA_CRegs
#define ADTA_GRegs 		PDTA_GRegs
#define ADTA_ColorTable 		PDTA_ColorTable
#define ADTA_ColorTable2 	PDTA_ColorTable2
#define ADTA_Allocated 		PDTA_Allocated
#define ADTA_NumColors 		PDTA_NumColors
#define ADTA_NumAlloc 		PDTA_NumAlloc
#define ADTA_Remap 		PDTA_Remap
#define ADTA_Screen 		PDTA_Screen
#define ADTA_Width 		(ADTA_Dummy + 1)
#define ADTA_Height 		(ADTA_Dummy + 2)
#define ADTA_Depth 		(ADTA_Dummy + 3)
#define ADTA_Frames 		(ADTA_Dummy + 4)
#define ADTA_Frame 		(ADTA_Dummy + 5)
#define ADTA_FramesPerSecond 	(ADTA_Dummy + 6)
#define ADTA_FrameIncrement 	(ADTA_Dummy + 7)
#define ADTA_PreloadFrameCount 	(ADTA_Dummy + 8)	/* (V44) */
#define ADTA_Sample 		SDTA_Sample
#define ADTA_SampleLength 	SDTA_SampleLength
#define ADTA_Period 		SDTA_Period
#define ADTA_Volume 		SDTA_Volume
#define ADTA_Cycles 		SDTA_Cycles
#define ADTA_LeftSample 		SDTA_LeftSample		/* (V44) */
#define ADTA_RightSample 	SDTA_RightSample	/* (V44) */
#define ADTA_SamplesPerSec 	SDTA_SamplesPerSec	/* (V44) */

#define ID_ANIM          MAKE_ID("A","N","I","M")
#define ID_ANHD          MAKE_ID("A","N","H","D")
#define ID_DLTA          MAKE_ID("D","L","T","A")

OBJECT AnimHeader
	Operation:UBYTE,
	Mask:UBYTE,
	Width:UWORD,  
	Height:UWORD,
	Left:WORD,
	Top:WORD,
	AbsTime:ULONG,
	RelTime:ULONG,
	Interleave:UBYTE,
	Pad0:UBYTE,
	Flags:ULONG,
	Pad[16]:UBYTE

CONST	ADTM_DUMMY=$700,
		ADTM_LOADFRAME=$701,
		ADTM_UNLOADFRAME=$702,
		ADTM_START=$703,
		ADTM_PAUSE=$704,
		ADTM_STOP=$705,
		ADTM_LOCATE=$706,
		ADTM_LOADNEWFORMATFRAME=$707,
		ADTM_UNLOADNEWFORMATFRAME=$708

/* ADTM_LOADFRAME, ADTM_UNLOADFRAME */

OBJECT adtFrame
	MethodID:ULONG,
	TimeStamp:ULONG,
	Frame:ULONG,
	Duration:ULONG,
	BitMap:PTR TO BitMap,
	CMap:PTR TO ColorMap,
	Sample:PTR TO BYTE,
	SampleLength:ULONG,
	Period:ULONG,
	UserData:APTR             /* Used by load frame for extra data */

/* ADTM_LOADNEWFORMATFRAME, ADTM_UNLOADNEWFORMATFRAME */

OBJECT adtNewFormatFrame
	MethodID:ULONG,
	TimeStamp:ULONG,            /* Timestamp of frame to load */
	Frame:ULONG,                /* Frame number */
	Duration:ULONG,             /* Duration of frame */
	BitMap:PTR TO BitMap,       /* Loaded BitMap */
	CMap:PTR TO ColorMap,       /* Colormap, if changed */
	Sample:PTR TO BYTE,         /* Sound data */
	SampleLength:ULONG,
	Period:ULONG,
	UserData:APTR,               /* Used by load frame for extra data */
	Size:ULONG,                 /* Size of this data structure (in bytes) */
	LeftSample:PTR TO BYTE,     /* Sound for left channel, or NULL if none */
	RightSample:PTR TO BYTE,    /* Sound for right channel, or NULL if none */
	SamplesPerSec:ULONG         /* Replay speed; if > 0, this overrides alf_Period */

/* ADTM_START, ADTM_PAUSE, ADTM_STOP, ADTM_LOCATE */
OBJECT adtStart
	MethodID:ULONG,
	asa_Frame:ULONG     /* Frame # to start at */
