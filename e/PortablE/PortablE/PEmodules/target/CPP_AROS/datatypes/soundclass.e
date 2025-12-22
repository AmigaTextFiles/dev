OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/datatypes/datatypes_shared'
MODULE 'target/utility/tagitem', 'target/datatypes/datatypesclass', 'target/libraries/iffparse', 'target/devices/timer'
MODULE 'target/exec/types'
{#include <datatypes/soundclass.h>}
NATIVE {DATATYPES_SOUNDCLASS_H} CONST

NATIVE {SOUNDDTCLASS}		CONST
#define SOUNDDTCLASS sounddtclass
STATIC sounddtclass		= 'sound.datatype'

/* Tags */

NATIVE {SDTA_Dummy}		CONST SDTA_DUMMY		= (DTA_DUMMY + 500)
NATIVE {SDTA_VoiceHeader}	CONST SDTA_VOICEHEADER	= (SDTA_DUMMY + 1)
NATIVE {SDTA_Sample}		CONST SDTA_SAMPLE		= (SDTA_DUMMY + 2)
NATIVE {SDTA_SampleLength}	CONST SDTA_SAMPLELENGTH	= (SDTA_DUMMY + 3)
NATIVE {SDTA_Period}		CONST SDTA_PERIOD		= (SDTA_DUMMY + 4)
NATIVE {SDTA_Volume}		CONST SDTA_VOLUME		= (SDTA_DUMMY + 5)
NATIVE {SDTA_Cycles}		CONST SDTA_CYCLES		= (SDTA_DUMMY + 6)
NATIVE {SDTA_SignalTask}		CONST SDTA_SIGNALTASK		= (SDTA_DUMMY + 7)
NATIVE {SDTA_SignalBit}		CONST SDTA_SIGNALBIT		= (SDTA_DUMMY + 8)
NATIVE {SDTA_SignalBitMask}	CONST SDTA_SIGNALBITMASK	= SDTA_SIGNALBIT
NATIVE {SDTA_Continuous}		CONST SDTA_CONTINUOUS		= (SDTA_DUMMY + 9)

/* New in V44 */

NATIVE {SDTA_SignalBitNumber}	CONST SDTA_SIGNALBITNUMBER	= (SDTA_DUMMY + 10)
NATIVE {SDTA_SamplesPerSec}	CONST SDTA_SAMPLESPERSEC	= (SDTA_DUMMY + 11)
NATIVE {SDTA_ReplayPeriod}	CONST SDTA_REPLAYPERIOD	= (SDTA_DUMMY + 12)
NATIVE {SDTA_LeftSample}		CONST SDTA_LEFTSAMPLE		= (SDTA_DUMMY + 13)
NATIVE {SDTA_RightSample}	CONST SDTA_RIGHTSAMPLE	= (SDTA_DUMMY + 14)
NATIVE {SDTA_Pan}		CONST SDTA_PAN		= (SDTA_DUMMY + 15)
NATIVE {SDTA_FreeSampleData}	CONST SDTA_FREESAMPLEDATA	= (SDTA_DUMMY + 16)
NATIVE {SDTA_SyncSampleChange}	CONST SDTA_SYNCSAMPLECHANGE	= (SDTA_DUMMY + 17)


/* Data compression methods */

NATIVE {CMP_NONE}     	    	CONST CMP_NONE     	    	= 0
NATIVE {CMP_FIBDELTA} 	    	CONST CMP_FIBDELTA 	    	= 1

/* Unity = Fixed 1.0 = maximum volume */
NATIVE {Unity} 	    	    	CONST UNITY 	    	    	= $10000

NATIVE {VoiceHeader} OBJECT voiceheader
    {vh_OneShotHiSamples}	oneshothisamples	:ULONG
    {vh_RepeatHiSamples}	repeathisamples	:ULONG
    {vh_SamplesPerHiCycle}	samplesperhicycle	:ULONG
    {vh_SamplesPerSec}	samplespersec	:UINT
    {vh_Octaves}	octaves	:UBYTE
    {vh_Compression}	compression	:UBYTE
    {vh_Volume}	volume	:ULONG
ENDOBJECT


/* Channel allocation */

NATIVE {SAMPLETYPE_Left}		CONST SAMPLETYPE_LEFT		= 2
NATIVE {SAMPLETYPE_Right}	CONST SAMPLETYPE_RIGHT	= 4
NATIVE {SAMPLETYPE_Stereo}	CONST SAMPLETYPE_STEREO	= 6

NATIVE {SampleType} CONST

/* IFF types */

NATIVE {ID_8SVX}	    	    	CONST ID_8SVX	    	    	= "8SVX"
NATIVE {ID_VHDR}	    	    	CONST ID_VHDR	    	    	= "VHDR"
NATIVE {ID_CHAN}	    	    	CONST ID_CHAN	    	    	= "CHAN"
->"CONST ID_BODY" is on-purposely missing from here (it can be found in 'datatypes/datatypes_shared')
