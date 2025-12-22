/* $VER: ahi.h 5.1 (3.6.00) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/io', 'target/utility/tagitem', 'target/libraries/iffparse'
MODULE 'target/utility/hooks'
{#include <devices/ahi.h>}
NATIVE {DEVICES_AHI_H} CONST

TYPE AHIFIXED IS NATIVE {Fixed} VALUE


NATIVE {Fixed} CONST				/* A fixed-point value, 16 bits
						   to the left of the point and
						   16 bits to the right */
NATIVE {sposition} OBJECT

/*** STRUCTURES */

 /* AHIAudioCtrl */
NATIVE {AHIAudioCtrl} OBJECT ahiaudioctrl
	{ahiac_UserData}	userdata	:APTR
	/* Lots of private data follows! */
ENDOBJECT

 /* AHISoundMessage */
NATIVE {AHISoundMessage} OBJECT ahisoundmessage
 	{ahism_Channel}	channel	:UINT
ENDOBJECT

 /* AHIRecordMessage */
NATIVE {AHIRecordMessage} OBJECT ahirecordmessage
	{ahirm_Type}	type	:ULONG			/* Format of buffer (object) */
	{ahirm_Buffer}	buffer	:APTR			/* Pointer to the sample array */
	{ahirm_Length}	length	:ULONG			/* Number of sample frames in buffer */
ENDOBJECT

 /* AHISampleInfo */
NATIVE {AHISampleInfo} OBJECT ahisampleinfo
	{ahisi_Type}	type	:ULONG			/* Format of samples */
	{ahisi_Address}	address	:APTR			/* Address to array of samples */
	{ahisi_Length}	length	:ULONG			/* Number of samples in array */
ENDOBJECT


 /* AHIAudioModeRequester */
NATIVE {AHIAudioModeRequester} OBJECT ahiaudiomoderequester
	{ahiam_AudioID}	audioid	:ULONG			/* Selected audio mode */
	{ahiam_MixFreq}	mixfreq	:ULONG			/* Selected mixing/sampling frequency */

	{ahiam_LeftEdge}	leftedge	:INT			/* Coordinates of requester on exit */
	{ahiam_TopEdge}	topedge	:INT
	{ahiam_Width}	width	:INT
	{ahiam_Height}	height	:INT

	{ahiam_InfoOpened}	infoopened	:INT		/* Info window opened on exit? */
	{ahiam_InfoLeftEdge}	infoleftedge	:INT		/* Last coordinates of Info window */
	{ahiam_InfoTopEdge}	infotopedge	:INT
	{ahiam_InfoWidth}	infowidth	:INT
	{ahiam_InfoHeight}	infoheight	:INT

	{ahiam_ObsoleteUserData}	obsoleteuserdata[2]	:ARRAY OF UINT
	{ahiam_Pad}	pad	:UINT
	{ahiam_UserData}	userdata	:APTR			/* You can store your own data here (V5) */
	/* Lots of private data follows! */
ENDOBJECT

 /* AHIEffMasterVolume */
NATIVE {AHIEffMasterVolume} OBJECT ahieffmastervolume
	{ahie_Effect}	effect	:ULONG			/* Set to AHIET_MASTERVOLUME */
	{ahiemv_Volume}	volume	:AHIFIXED			/* See autodocs for range! */
ENDOBJECT

 /* AHIEffOutputBuffer */
NATIVE {AHIEffOutputBuffer} OBJECT ahieffoutputbuffer
	{ahie_Effect}	effect	:ULONG		/* Set to AHIET_OUTPUTBUFFER */
	{ahieob_Func}	func	:PTR TO hook
 /* These fields are filled by AHI */
	{ahieob_Type}	type	:ULONG		/* Format of buffer */
	{ahieob_Buffer}	buffer	:APTR		/* Pointer to the sample array */
	{ahieob_Length}	length	:ULONG		/* Number of sample frames in buffer */
ENDOBJECT

 /* AHIEffDSPMask (V4) */
NATIVE {AHIEffDSPMask} OBJECT ahieffdspmask
	{ahie_Effect}	effect	:ULONG			/* Set to AHIET_DSPMASK */
	{ahiedm_Channels}	channels	:UINT		/* Number of elements in array */
	{ahiedm_Mask}	mask	:ARRAY OF UBYTE			/* Here follows the array */
ENDOBJECT

NATIVE {AHIEDM_WET}		CONST AHIEDM_WET		= (0)
NATIVE {AHIEDM_DRY}		CONST AHIEDM_DRY		= (1)

 /* AHIEffDSPEcho (V4) */
NATIVE {AHIEffDSPEcho} OBJECT ahieffdspecho
	{ahie_Effect}	effect	:ULONG			/* Set to AHIET_DSPECHO */
	{ahiede_Delay}	delay	:ULONG			/* In samples */
	{ahiede_Feedback}	feedback	:AHIFIXED
	{ahiede_Mix}	mix	:AHIFIXED
	{ahiede_Cross}	cross	:AHIFIXED
ENDOBJECT

NATIVE {AHIDSPEcho} CONST		/* Fix for error in V4 includes	*/

 /* AHIEffChannelInfo (V4) */

NATIVE {AHIEffChannelInfo} OBJECT ahieffchannelinfo
	{ahie_Effect}	effect	:ULONG		/* Set to AHIET_CHANNELINFO */
	{ahieci_Func}	func	:PTR TO hook
	{ahieci_Channels}	channels	:UINT
	{ahieci_Pad}	pad	:UINT
 /* The rest is filled by AHI */
 	{ahieci_Offset}	offset	:ARRAY OF ULONG	/* The array follows */
ENDOBJECT

/*** TAGS */

NATIVE {AHI_TagBase}		CONST AHI_TAGBASE		= (TAG_USER)
NATIVE {AHI_TagBaseR}		CONST AHI_TAGBASER		= (AHI_TAGBASE OR $8000)

 /* AHI_AllocAudioA tags */
NATIVE {AHIA_AudioID}		CONST AHIA_AUDIOID		= (AHI_TAGBASE+1)		/* Desired audio mode */
NATIVE {AHIA_MixFreq}		CONST AHIA_MIXFREQ		= (AHI_TAGBASE+2)		/* Suggested mixing frequency */
NATIVE {AHIA_Channels}		CONST AHIA_CHANNELS		= (AHI_TAGBASE+3)		/* Suggested number of channels */
NATIVE {AHIA_Sounds}		CONST AHIA_SOUNDS		= (AHI_TAGBASE+4)		/* Number of sounds to use */
NATIVE {AHIA_SoundFunc}		CONST AHIA_SOUNDFUNC		= (AHI_TAGBASE+5)		/* End-of-Sound Hook */
NATIVE {AHIA_PlayerFunc}		CONST AHIA_PLAYERFUNC		= (AHI_TAGBASE+6)		/* Player Hook */
NATIVE {AHIA_PlayerFreq}		CONST AHIA_PLAYERFREQ		= (AHI_TAGBASE+7)		/* Frequency for player Hook (Fixed)*/
NATIVE {AHIA_MinPlayerFreq}	CONST AHIA_MINPLAYERFREQ	= (AHI_TAGBASE+8)		/* Minimum Frequency for player Hook */
NATIVE {AHIA_MaxPlayerFreq}	CONST AHIA_MAXPLAYERFREQ	= (AHI_TAGBASE+9)		/* Maximum Frequency for player Hook */
NATIVE {AHIA_RecordFunc}		CONST AHIA_RECORDFUNC		= (AHI_TAGBASE+10)	/* Sample recording Hook */
NATIVE {AHIA_UserData}		CONST AHIA_USERDATA		= (AHI_TAGBASE+11)	/* What to put in ahiac_UserData */
NATIVE {AHIA_AntiClickSamples}	CONST AHIA_ANTICLICKSAMPLES	= (AHI_TAGBASE+13)	/* # of samples to smooth (V5)	*/

  /* AHI_PlayA tags (V4) */
NATIVE {AHIP_BeginChannel}	CONST AHIP_BEGINCHANNEL	= (AHI_TAGBASE+40)	/* All command tags should be... */
NATIVE {AHIP_EndChannel}		CONST AHIP_ENDCHANNEL		= (AHI_TAGBASE+41)	/* ... enclosed by these tags. */
NATIVE {AHIP_Freq}		CONST AHIP_FREQ		= (AHI_TAGBASE+50)
NATIVE {AHIP_Vol}		CONST AHIP_VOL		= (AHI_TAGBASE+51)
NATIVE {AHIP_Pan}		CONST AHIP_PAN		= (AHI_TAGBASE+52)
NATIVE {AHIP_Sound}		CONST AHIP_SOUND		= (AHI_TAGBASE+53)
NATIVE {AHIP_Offset}		CONST AHIP_OFFSET		= (AHI_TAGBASE+54)
NATIVE {AHIP_Length}		CONST AHIP_LENGTH		= (AHI_TAGBASE+55)
NATIVE {AHIP_LoopFreq}		CONST AHIP_LOOPFREQ		= (AHI_TAGBASE+60)
NATIVE {AHIP_LoopVol}		CONST AHIP_LOOPVOL		= (AHI_TAGBASE+61)
NATIVE {AHIP_LoopPan}		CONST AHIP_LOOPPAN		= (AHI_TAGBASE+62)
NATIVE {AHIP_LoopSound}		CONST AHIP_LOOPSOUND		= (AHI_TAGBASE+63)
NATIVE {AHIP_LoopOffset}		CONST AHIP_LOOPOFFSET		= (AHI_TAGBASE+64)
NATIVE {AHIP_LoopLength}		CONST AHIP_LOOPLENGTH		= (AHI_TAGBASE+65)

 /* AHI_ControlAudioA tags */
NATIVE {AHIC_Play}		CONST AHIC_PLAY		= (AHI_TAGBASE+80)	/* Boolean */
NATIVE {AHIC_Record}		CONST AHIC_RECORD		= (AHI_TAGBASE+81)	/* Boolean */
NATIVE {AHIC_MonitorVolume}	CONST AHIC_MONITORVOLUME	= (AHI_TAGBASE+82)
NATIVE {AHIC_MonitorVolume_Query} CONST AHIC_MONITORVOLUME_QUERY = (AHI_TAGBASE+83)	/* ti_Data is pointer to Fixed (LONG) */
NATIVE {AHIC_MixFreq_Query}	CONST AHIC_MIXFREQ_QUERY	= (AHI_TAGBASE+84)	/* ti_Data is pointer to ULONG */
/* --- New for V2, they will be ignored by V1 --- */
NATIVE {AHIC_InputGain}		CONST AHIC_INPUTGAIN		= (AHI_TAGBASE+85)
NATIVE {AHIC_InputGain_Query}	CONST AHIC_INPUTGAIN_QUERY	= (AHI_TAGBASE+86)	/* ti_Data is pointer to Fixed (LONG) */
NATIVE {AHIC_OutputVolume}	CONST AHIC_OUTPUTVOLUME	= (AHI_TAGBASE+87)
NATIVE {AHIC_OutputVolume_Query}	CONST AHIC_OUTPUTVOLUME_QUERY	= (AHI_TAGBASE+88)	/* ti_Data is pointer to Fixed (LONG) */
NATIVE {AHIC_Input}		CONST AHIC_INPUT		= (AHI_TAGBASE+89)
NATIVE {AHIC_Input_Query}	CONST AHIC_INPUT_QUERY	= (AHI_TAGBASE+90)	/* ti_Data is pointer to ULONG */
NATIVE {AHIC_Output}		CONST AHIC_OUTPUT		= (AHI_TAGBASE+91)
NATIVE {AHIC_Output_Query}	CONST AHIC_OUTPUT_QUERY	= (AHI_TAGBASE+92)	/* ti_Data is pointer to ULONG */

 /* AHI_GetAudioAttrsA tags */
NATIVE {AHIDB_AudioID}		CONST AHIDB_AUDIOID		= (AHI_TAGBASE+100)
NATIVE {AHIDB_Driver}		CONST AHIDB_DRIVER		= (AHI_TAGBASER+101)	/* Pointer to name of driver */
NATIVE {AHIDB_Flags}		CONST AHIDB_FLAGS		= (AHI_TAGBASE+102)	/* Private! */
NATIVE {AHIDB_Volume}		CONST AHIDB_VOLUME		= (AHI_TAGBASE+103)	/* Boolean */
NATIVE {AHIDB_Panning}		CONST AHIDB_PANNING		= (AHI_TAGBASE+104)	/* Boolean */
NATIVE {AHIDB_Stereo}		CONST AHIDB_STEREO		= (AHI_TAGBASE+105)	/* Boolean */
NATIVE {AHIDB_HiFi}		CONST AHIDB_HIFI		= (AHI_TAGBASE+106)	/* Boolean */
NATIVE {AHIDB_PingPong}		CONST AHIDB_PINGPONG		= (AHI_TAGBASE+107)	/* Boolean */
NATIVE {AHIDB_MultTable}		CONST AHIDB_MULTTABLE		= (AHI_TAGBASE+108)	/* Private! */
NATIVE {AHIDB_Name}		CONST AHIDB_NAME		= (AHI_TAGBASER+109)	/* Pointer to name of this mode */
NATIVE {AHIDB_Bits}		CONST AHIDB_BITS		= (AHI_TAGBASE+110)	/* Output bits */
NATIVE {AHIDB_MaxChannels}	CONST AHIDB_MAXCHANNELS	= (AHI_TAGBASE+111)	/* Max supported channels */
NATIVE {AHIDB_MinMixFreq}	CONST AHIDB_MINMIXFREQ	= (AHI_TAGBASE+112)	/* Min mixing freq. supported */
NATIVE {AHIDB_MaxMixFreq}	CONST AHIDB_MAXMIXFREQ	= (AHI_TAGBASE+113)	/* Max mixing freq. supported */
NATIVE {AHIDB_Record}		CONST AHIDB_RECORD		= (AHI_TAGBASE+114)	/* Boolean */
NATIVE {AHIDB_Frequencies}	CONST AHIDB_FREQUENCIES	= (AHI_TAGBASE+115)
NATIVE {AHIDB_FrequencyArg}	CONST AHIDB_FREQUENCYARG	= (AHI_TAGBASE+116)	/* ti_Data is frequency index */
NATIVE {AHIDB_Frequency}		CONST AHIDB_FREQUENCY		= (AHI_TAGBASE+117)
NATIVE {AHIDB_Author}		CONST AHIDB_AUTHOR		= (AHI_TAGBASE+118)	/* Pointer to driver author name */
NATIVE {AHIDB_Copyright}		CONST AHIDB_COPYRIGHT		= (AHI_TAGBASE+119)	/* Pointer to driver copyright notice */
NATIVE {AHIDB_Version}		CONST AHIDB_VERSION		= (AHI_TAGBASE+120)	/* Pointer to driver version string */
NATIVE {AHIDB_Annotation}	CONST AHIDB_ANNOTATION	= (AHI_TAGBASE+121)	/* Pointer to driver annotation text */
NATIVE {AHIDB_BufferLen}		CONST AHIDB_BUFFERLEN		= (AHI_TAGBASE+122)	/* Specifies the string buffer size */
NATIVE {AHIDB_IndexArg}		CONST AHIDB_INDEXARG		= (AHI_TAGBASE+123)	/* ti_Data is frequency! */
NATIVE {AHIDB_Index}		CONST AHIDB_INDEX		= (AHI_TAGBASE+124)
NATIVE {AHIDB_Realtime}		CONST AHIDB_REALTIME		= (AHI_TAGBASE+125)	/* Boolean */
NATIVE {AHIDB_MaxPlaySamples}	CONST AHIDB_MAXPLAYSAMPLES	= (AHI_TAGBASE+126)	/* It's sample *frames* */
NATIVE {AHIDB_MaxRecordSamples}	CONST AHIDB_MAXRECORDSAMPLES	= (AHI_TAGBASE+127)	/* It's sample *frames* */
NATIVE {AHIDB_FullDuplex}	CONST AHIDB_FULLDUPLEX	= (AHI_TAGBASE+129)	/* Boolean */
/* --- New for V2, they will be ignored by V1 --- */
NATIVE {AHIDB_MinMonitorVolume}	CONST AHIDB_MINMONITORVOLUME	= (AHI_TAGBASE+130)
NATIVE {AHIDB_MaxMonitorVolume}	CONST AHIDB_MAXMONITORVOLUME	= (AHI_TAGBASE+131)
NATIVE {AHIDB_MinInputGain}	CONST AHIDB_MININPUTGAIN	= (AHI_TAGBASE+132)
NATIVE {AHIDB_MaxInputGain}	CONST AHIDB_MAXINPUTGAIN	= (AHI_TAGBASE+133)
NATIVE {AHIDB_MinOutputVolume}	CONST AHIDB_MINOUTPUTVOLUME	= (AHI_TAGBASE+134)
NATIVE {AHIDB_MaxOutputVolume}	CONST AHIDB_MAXOUTPUTVOLUME	= (AHI_TAGBASE+135)
NATIVE {AHIDB_Inputs}		CONST AHIDB_INPUTS		= (AHI_TAGBASE+136)
NATIVE {AHIDB_InputArg}		CONST AHIDB_INPUTARG		= (AHI_TAGBASE+137)	/* ti_Data is input index */
NATIVE {AHIDB_Input}		CONST AHIDB_INPUT		= (AHI_TAGBASE+138)
NATIVE {AHIDB_Outputs}		CONST AHIDB_OUTPUTS		= (AHI_TAGBASE+139)
NATIVE {AHIDB_OutputArg}		CONST AHIDB_OUTPUTARG		= (AHI_TAGBASE+140)	/* ti_Data is input index */
NATIVE {AHIDB_Output}		CONST AHIDB_OUTPUT		= (AHI_TAGBASE+141)
/* --- New for V4, they will be ignored by V2 and earlier --- */
NATIVE {AHIDB_Data}		CONST AHIDB_DATA		= (AHI_TAGBASER+142)	/* Private! */

 /* AHI_BestAudioIDA tags */
/* --- New for V4, they will be ignored by V2 and earlier --- */
NATIVE {AHIB_Dizzy}		CONST AHIB_DIZZY		= (AHI_TAGBASE+190)

 /* AHI_AudioRequestA tags */
	/* Window control */
NATIVE {AHIR_Window}		CONST AHIR_WINDOW		= (AHI_TAGBASE+200)	/* Parent window */
NATIVE {AHIR_Screen}		CONST AHIR_SCREEN		= (AHI_TAGBASE+201)	/* Screen to open on if no window */
NATIVE {AHIR_PubScreenName}	CONST AHIR_PUBSCREENNAME	= (AHI_TAGBASE+202)	/* Name of public screen */
NATIVE {AHIR_PrivateIDCMP}	CONST AHIR_PRIVATEIDCMP	= (AHI_TAGBASE+203)	/* Allocate private IDCMP? */
NATIVE {AHIR_IntuiMsgFunc}	CONST AHIR_INTUIMSGFUNC	= (AHI_TAGBASE+204)	/* Function to handle IntuiMessages */
NATIVE {AHIR_SleepWindow}	CONST AHIR_SLEEPWINDOW	= (AHI_TAGBASE+205)	/* Block input in AHIR_Window? */
NATIVE {AHIR_ObsoleteUserData}	CONST AHIR_OBSOLETEUSERDATA	= (AHI_TAGBASE+206)	/* V4 UserData */
NATIVE {AHIR_UserData}		CONST AHIR_USERDATA		= (AHI_TAGBASE+207)	/* What to put in ahiam_UserData (V5) */
	/* Text display */
NATIVE {AHIR_TextAttr}		CONST AHIR_TEXTATTR		= (AHI_TAGBASE+220)	/* Text font to use for gadget text */
NATIVE {AHIR_Locale}		CONST AHIR_LOCALE		= (AHI_TAGBASE+221)	/* Locale to use for text */
NATIVE {AHIR_TitleText}		CONST AHIR_TITLETEXT		= (AHI_TAGBASE+222)	/* Title of requester */
NATIVE {AHIR_PositiveText}	CONST AHIR_POSITIVETEXT	= (AHI_TAGBASE+223)	/* Positive gadget text */
NATIVE {AHIR_NegativeText}	CONST AHIR_NEGATIVETEXT	= (AHI_TAGBASE+224)	/* Negative gadget text */
	/* Initial settings */
NATIVE {AHIR_InitialLeftEdge}	CONST AHIR_INITIALLEFTEDGE	= (AHI_TAGBASE+240)	/* Initial requester coordinates */
NATIVE {AHIR_InitialTopEdge}	CONST AHIR_INITIALTOPEDGE	= (AHI_TAGBASE+241)
NATIVE {AHIR_InitialWidth}	CONST AHIR_INITIALWIDTH	= (AHI_TAGBASE+242)	/* Initial requester dimensions */
NATIVE {AHIR_InitialHeight}	CONST AHIR_INITIALHEIGHT	= (AHI_TAGBASE+243)
NATIVE {AHIR_InitialAudioID}	CONST AHIR_INITIALAUDIOID	= (AHI_TAGBASE+244)	/* Initial audio mode id */
NATIVE {AHIR_InitialMixFreq}	CONST AHIR_INITIALMIXFREQ	= (AHI_TAGBASE+245)	/* Initial mixing/sampling frequency */
NATIVE {AHIR_InitialInfoOpened}	CONST AHIR_INITIALINFOOPENED	= (AHI_TAGBASE+246)	/* Info window initially opened? */
NATIVE {AHIR_InitialInfoLeftEdge} CONST AHIR_INITIALINFOLEFTEDGE = (AHI_TAGBASE+247)	/* Initial Info window coords. */
NATIVE {AHIR_InitialInfoTopEdge} CONST AHIR_INITIALINFOTOPEDGE = (AHI_TAGBASE+248)
NATIVE {AHIR_InitialInfoWidth}	CONST AHIR_INITIALINFOWIDTH	= (AHI_TAGBASE+249)	/* Not used! */
NATIVE {AHIR_InitialInfoHeight}	CONST AHIR_INITIALINFOHEIGHT	= (AHI_TAGBASE+250)	/* Not used! */
	/* Options */
NATIVE {AHIR_DoMixFreq}		CONST AHIR_DOMIXFREQ		= (AHI_TAGBASE+260)	/* Allow selection of mixing frequency? */
NATIVE {AHIR_DoDefaultMode}	CONST AHIR_DODEFAULTMODE	= (AHI_TAGBASE+261)	/* Allow selection of default mode? (V4) */
	/* Filtering */
NATIVE {AHIR_FilterTags}		CONST AHIR_FILTERTAGS		= (AHI_TAGBASE+270)	/* Pointer to filter taglist */
NATIVE {AHIR_FilterFunc}		CONST AHIR_FILTERFUNC		= (AHI_TAGBASE+271)	/* Function to filter mode id's */

/*** DEFS */

NATIVE {AHINAME}			CONST
#define AHINAME ahiname
STATIC  ahiname			= 'ahi.device'
NATIVE {AHI_INVALID_ID}		CONST AHI_INVALID_ID		= (NOT 0)			/* Invalid Audio ID */
NATIVE {AHI_DEFAULT_ID}		CONST AHI_DEFAULT_ID		= ($00000000)		/* Only for AHI_AllocAudioA()! */
NATIVE {AHI_LOOPBACK_ID}		CONST AHI_LOOPBACK_ID		= ($00000001)		/* Special sample render Audio ID */
NATIVE {AHI_DEFAULT_FREQ}	CONST AHI_DEFAULT_FREQ	= (0)			/* Only for AHI_AllocAudioA()! */
NATIVE {AHI_MIXFREQ}		CONST AHI_MIXFREQ		= (NOT 0)			/* Special frequency for AHI_SetFreq() */
NATIVE {AHI_NOSOUND}		CONST AHI_NOSOUND		= ($ffff)		/* Turns a channel off */

 /* Set#? Flags */
NATIVE {AHISF_IMM}		CONST AHISF_IMM		= 1 SHL 0	/* Trigger action immediately	*/
NATIVE {AHISF_NODELAY}		CONST AHISF_NODELAY		= 1 SHL 1	/* Don't wait for zero-crossing */

NATIVE {AHISF_NONE}		CONST AHISF_NONE		= (0)		/* No flags (V5)		*/

NATIVE {AHISB_IMM}		CONST AHISB_IMM		= (0)
NATIVE {AHISB_NODELAY}		CONST AHISB_NODELAY		= (1)

 /* Effect Types */
NATIVE {AHIET_CANCEL}		CONST AHIET_CANCEL		= 1 SHL 31		/* OR with effect to disable */
NATIVE {AHIET_MASTERVOLUME}	CONST AHIET_MASTERVOLUME	= (1)
NATIVE {AHIET_OUTPUTBUFFER}	CONST AHIET_OUTPUTBUFFER	= (2)
/* --- New for V4 --- */
NATIVE {AHIET_DSPMASK}		CONST AHIET_DSPMASK		= (3)
NATIVE {AHIET_DSPECHO}		CONST AHIET_DSPECHO		= (4)
NATIVE {AHIET_CHANNELINFO}	CONST AHIET_CHANNELINFO	= (5)

 /* Sound Types */
NATIVE {AHIST_NOTYPE}		CONST AHIST_NOTYPE		= (NOT 0)			/* Private */
NATIVE {AHIST_SAMPLE}		CONST AHIST_SAMPLE		= (0)			/* 8 or 16 bit sample */
NATIVE {AHIST_DYNAMICSAMPLE}	CONST AHIST_DYNAMICSAMPLE	= (1)			/* Dynamic sample */
NATIVE {AHIST_INPUT}		CONST AHIST_INPUT		= 1 SHL 29		/* The input from your sampler */
NATIVE {AHIST_BW}		CONST AHIST_BW		= 1 SHL 30		/* Private */

 /* Sample types */
/* Note that only AHIST_M8S, AHIST_S8S, AHIST_M16S and AHIST_S16S
   are supported by AHI_LoadSound(). */
NATIVE {AHIST_M8S}		CONST AHIST_M8S		= (0)			/* Mono, 8 bit signed (BYTE) */
NATIVE {AHIST_M16S}		CONST AHIST_M16S		= (1)			/* Mono, 16 bit signed (WORD) */
NATIVE {AHIST_S8S}		CONST AHIST_S8S		= (2)			/* Stereo, 8 bit signed (2×BYTE) */
NATIVE {AHIST_S16S}		CONST AHIST_S16S		= (3)			/* Stereo, 16 bit signed (2×WORD) */
NATIVE {AHIST_M32S}		CONST AHIST_M32S		= (8)			/* Mono, 32 bit signed (LONG) */
NATIVE {AHIST_S32S}		CONST AHIST_S32S		= (10)			/* Stereo, 32 bit signed (2×LONG) */

NATIVE {AHIST_M8U}		CONST AHIST_M8U		= (4)			/* OBSOLETE! */

 /* Error codes */
NATIVE {AHIE_OK}			CONST AHIE_OK			= (0)			/* No error */
NATIVE {AHIE_NOMEM}		CONST AHIE_NOMEM		= (1)			/* Out of memory */
NATIVE {AHIE_BADSOUNDTYPE}	CONST AHIE_BADSOUNDTYPE	= (2)			/* Unknown sound type */
NATIVE {AHIE_BADSAMPLETYPE}	CONST AHIE_BADSAMPLETYPE	= (3)			/* Unknown/unsupported sample type */
NATIVE {AHIE_ABORTED}		CONST AHIE_ABORTED		= (4)			/* User-triggered abortion */
NATIVE {AHIE_UNKNOWN}		CONST AHIE_UNKNOWN		= (5)			/* Error, but unknown */
NATIVE {AHIE_HALFDUPLEX}		CONST AHIE_HALFDUPLEX		= (6)			/* CMD_WRITE/CMD_READ failure */



/* DEVICE INTERFACE DEFINITIONS FOLLOWS ************************************/

 /* Device units */

NATIVE {AHI_DEFAULT_UNIT}	CONST AHI_DEFAULT_UNIT	= (0)
NATIVE {AHI_NO_UNIT}		CONST AHI_NO_UNIT		= (255)


 /* The preference file */

NATIVE {ID_AHIU} CONST ID_AHIU = "AHIU"	->MAKE_ID("A","H","I","U")
NATIVE {ID_AHIG} CONST ID_AHIG = "AHIG"	->MAKE_ID("A","H","I","G")

NATIVE {AHIUnitPrefs} OBJECT ahiunitprefs
	{ahiup_Unit}	unit	:UBYTE
	{ahiup_Pad}	pad	:UBYTE
	{ahiup_Channels}	channels	:UINT
	{ahiup_AudioMode}	audiomode	:ULONG
	{ahiup_Frequency}	frequency	:ULONG
	{ahiup_MonitorVolume}	monitorvolume	:AHIFIXED
	{ahiup_InputGain}	inputgain	:AHIFIXED
	{ahiup_OutputVolume}	outputvolume	:AHIFIXED
	{ahiup_Input}	input	:ULONG
	{ahiup_Output}	output	:ULONG
ENDOBJECT

NATIVE {AHIGlobalPrefs} OBJECT ahiglobalprefs
	{ahigp_DebugLevel}	debuglevel	:UINT			/* Range: 0-3 (for None, Low,
							   High and All) */
	{ahigp_DisableSurround}	disablesurround	:INT
	{ahigp_DisableEcho}	disableecho	:INT
	{ahigp_FastEcho}	fastecho	:INT
	{ahigp_MaxCPU}	maxcpu	:AHIFIXED
	{ahigp_ClipMasterVolume}	clipmastervolume	:INT
	{ahigp_Pad}	pad	:UINT
	{ahigp_AntiClickTime}	anticlicktime	:AHIFIXED			/* In seconds (V5) */
ENDOBJECT

 /* Debug levels */
NATIVE {AHI_DEBUG_NONE}		CONST AHI_DEBUG_NONE		= (0)
NATIVE {AHI_DEBUG_LOW}		CONST AHI_DEBUG_LOW		= (1)
NATIVE {AHI_DEBUG_HIGH}		CONST AHI_DEBUG_HIGH		= (2)
NATIVE {AHI_DEBUG_ALL}		CONST AHI_DEBUG_ALL		= (3)

 /* AHIRequest */

NATIVE {AHIRequest} OBJECT ahirequest
	{ahir_Std}	iostd	:iostd		/* Standard IO request */
	{ahir_Version}	version	:UINT		/* Needed version */
/* --- New for V4, they will be ignored by V2 and earlier --- */
	{ahir_Pad1}	pad1	:UINT
	{ahir_Private[0]}	private1	:ULONG	/* Hands off! */
	{ahir_Private[1]}	private2	:ULONG	/* Hands off! */
	{ahir_Type}	type	:ULONG		/* Sample format */
	{ahir_Frequency}	frequency	:ULONG	/* Sample/Record frequency */
	{ahir_Volume}	volume	:AHIFIXED		/* Sample volume */
	{ahir_Position}	position	:AHIFIXED		/* Stereo position */
	{ahir_Link}	link	:PTR TO ahirequest		/* For double buffering */
ENDOBJECT

 /* Flags for OpenDevice() */

NATIVE {AHIDF_NOMODESCAN}	CONST AHIDF_NOMODESCAN	= 1 SHL 0
NATIVE {AHIDB_NOMODESCAN}	CONST AHIDB_NOMODESCAN	= (0)
