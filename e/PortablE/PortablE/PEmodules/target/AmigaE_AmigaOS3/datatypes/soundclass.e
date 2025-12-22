/* $VER: soundclass.h 44.7 (6.6.1999) */
OPT NATIVE, PREPROCESS
PUBLIC MODULE 'target/libraries/iff_shared3', 'target/libraries/iff_shared5'
MODULE 'target/utility/tagitem', 'target/datatypes/datatypesclass', 'target/libraries/iffparse', 'target/devices/timer'
MODULE 'target/exec/types'
{MODULE 'datatypes/soundclass'}

NATIVE {SOUNDDTCLASS}		CONST 
#define SOUNDDTCLASS sounddtclass
STATIC sounddtclass		= 'sound.datatype'

/*****************************************************************************/

/* Sound attributes */
NATIVE {SDTA_DUMMY}		CONST SDTA_DUMMY		= (DTA_DUMMY + 500)
NATIVE {SDTA_VOICEHEADER}	CONST SDTA_VOICEHEADER	= (SDTA_DUMMY + 1)

/* (BYTE *) Sample data */
NATIVE {SDTA_SAMPLE}		CONST SDTA_SAMPLE		= (SDTA_DUMMY + 2)

/* (ULONG) Length of the sample data in UBYTEs */
NATIVE {SDTA_SAMPLELENGTH}	CONST SDTA_SAMPLELENGTH	= (SDTA_DUMMY + 3)

/* (UWORD) Period */
NATIVE {SDTA_PERIOD}		CONST SDTA_PERIOD		= (SDTA_DUMMY + 4)

/* (UWORD) Volume. Range from 0 to 64 */
NATIVE {SDTA_VOLUME}		CONST SDTA_VOLUME		= (SDTA_DUMMY + 5)

NATIVE {SDTA_CYCLES}		CONST SDTA_CYCLES		= (SDTA_DUMMY + 6)

/* The following tags are new for V40 */

/* (struct Task *) Task to signal when sound is complete or next buffer needed. */
NATIVE {SDTA_SIGNALTASK}		CONST SDTA_SIGNALTASK		= (SDTA_DUMMY + 7)

/* (ULONG) Signal mask to use on completion or 0 to disable
 *
 *         NOTE: Due to a bug in sound.datatype V40 SDTA_SignalBit
 *               was actually implemented as a signal mask as opposed
 *               to a bit number. The documentation now reflects
 *               this. If you intend to use a signal bit number
 *               instead of the mask, use the new V44 tag
 *               SDTA_SignalBitNumber below.
 */
NATIVE {SDTA_SIGNALBIT}		CONST SDTA_SIGNALBIT		= (SDTA_DUMMY + 8)
CONST SDTA_SIGNALBITMASK	= SDTA_SIGNALBIT

/* (BOOL) Playing a continuous stream of data.  Defaults to FALSE. */
NATIVE {SDTA_CONTINUOUS}		CONST SDTA_CONTINUOUS		= (SDTA_DUMMY + 9)

/* The following tags are new for V44 */

/* (BYTE) Signal bit to use on completion or -1 to disable */
CONST SDTA_SIGNALBITNUMBER	= (SDTA_DUMMY + 10)

/* (UWORD) Samples per second */
CONST SDTA_SAMPLESPERSEC	= (SDTA_DUMMY + 11)

/* (struct timeval *) Sample replay period */
CONST SDTA_REPLAYPERIOD	= (SDTA_DUMMY + 12)

/* (BYTE *) Sample data */
CONST SDTA_LEFTSAMPLE		= (SDTA_DUMMY + 13)
CONST SDTA_RIGHTSAMPLE	= (SDTA_DUMMY + 14)

/* (BYTE) Stereo panning */
CONST SDTA_PAN		= (SDTA_DUMMY + 15)

/* (BOOL) FreeVec() all sample data upon OM_DISPOSE. */
CONST SDTA_FREESAMPLEDATA	= (SDTA_DUMMY + 16)

/* (BOOL) Wait for the current sample to be played back before
 * switching to the new sample data.
 */
CONST SDTA_SYNCSAMPLECHANGE	= (SDTA_DUMMY + 17)

/*****************************************************************************/

/* Data compression methods */
NATIVE {CMP_NONE}     CONST CMP_NONE     = 0
NATIVE {CMP_FIBDELTA} CONST CMP_FIBDELTA = 1

/*****************************************************************************/

/* Unity = Fixed 1.0 = maximum volume */
CONST UNITY = $10000

/*****************************************************************************/

NATIVE {voiceheader} OBJECT voiceheader
	{oneshothisamples}	oneshothisamples	:ULONG	/* # samples in the high octave 1-shot part */
	{repeathisamples}	repeathisamples	:ULONG	/* # samples in the high octave repeat part */
	{samplesperhicycle}	samplesperhicycle	:ULONG	/* # samples/cycle in high octave, else 0 */
	{samplespersec}	samplespersec	:UINT		/* data sampling rate */
	{octaves}	octaves	:UBYTE		/* # of octaves of waveforms */
	{compression}	compression	:UBYTE		/* data compression technique used */
	{volume}	volume	:ULONG		/* playback nominal volume from 0 to Unity
					 * (full volume). Map this value into
					 * the output hardware's dynamic range.
					 */
ENDOBJECT

/*****************************************************************************/

/* Channel allocation */
CONST SAMPLETYPE_LEFT		= (2)
CONST SAMPLETYPE_RIGHT	= (4)
CONST SAMPLETYPE_STEREO	= (6)

NATIVE {SampleType} CONST

/*****************************************************************************/

/* IFF types */
->"CONST ID_8SVX" is on-purposely missing from here (it can be found in 'libraries/iff_shared5')
->"CONST ID_VHDR" is on-purposely missing from here (it can be found in 'libraries/iff_shared5')
CONST ID_CHAN	= "CHAN"
->"CONST ID_BODY" is on-purposely missing from here (it can be found in 'libraries/iff_shared3')
