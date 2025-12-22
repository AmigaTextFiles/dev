CONST	SDTA_Dummy=$800011F4,
		SDTA_VoiceHeader=$800011F5,
		SDTA_Sample=$800011F6,
		SDTA_SampleLength=$800011F7,
		SDTA_Period=$800011F8,  -> Data for this tag is unsigned INT
		SDTA_Volume=$800011F9,  -> Data for this tag is unsigned INT
		SDTA_Cycles=$800011FA,
		SDTA_SignalTask=$800011FB,
		SDTA_SignalBit=$800011FC,
		SDTA_Continuous=$800011FD,
		SDTA_SignalBitNumber=$800011FE, /* V44 tags */
		SDTA_SamplesPerSec=$800011FF,
		SDTA_ReplayPeriod=$80001200,
    SDTA_LeftSample=$80001201,
    SDTA_RightSample=$80001202,
    SDTA_Pan=$80001203,
    SDTA_FreeSampleData=$80001204,
    SDTA_SyncSampleChange=$80001205

#define SOUNDDTCLASS 'sound.datatype'

OBJECT VoiceHeader
	OneShotHiSamples:ULONG,
	RepeatHiSamples:ULONG,
	SamplesPerHiCycle:ULONG,
	SamplesPerSec:UWORD,
	Octaves:UBYTE,
	Compression:UBYTE,
	Volume:ULONG

CONST CMP_NONE=0,
		CMP_FIBDELTA=1,
		ID_8SVX=$38535658,
		ID_VHDR=$56484452,
		ID_CHAN=$4348414E,
		ID_BODY=$424F4459,
		Unity=$10000,
		SAMPLETYPE_Left=2,
    SAMPLETYPE_Right=4,
    SAMPLETYPE_Stereo=6

TDEF SampleType:LONG
