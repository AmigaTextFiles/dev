/* based upon $VER: ahi.h 5.1 (3.6.00) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/io', 'target/utility/tagitem', 'target/libraries/iffparse'
MODULE 'target/utility/hooks'
{MODULE 'devices/ahi'}

TYPE AHIFIXED IS VALUE


/*** STRUCTURES */

 /* AHIAudioCtrl */
NATIVE {ahiaudioctrl} OBJECT ahiaudioctrl
	{userdata}	userdata	:APTR
	/* Lots of private data follows! */
ENDOBJECT

 /* AHISoundMessage */
NATIVE {ahisoundmessage} OBJECT ahisoundmessage
 	{channel}	channel	:UINT
ENDOBJECT

 /* AHIRecordMessage */
NATIVE {ahirecordmessage} OBJECT ahirecordmessage
	{type}	type	:ULONG			/* Format of buffer (object) */
	{buffer}	buffer	:APTR			/* Pointer to the sample array */
	{length}	length	:ULONG			/* Number of sample frames in buffer */
ENDOBJECT

 /* AHISampleInfo */
NATIVE {ahisampleinfo} OBJECT ahisampleinfo
	{type}	type	:ULONG			/* Format of samples */
	{address}	address	:APTR			/* Address to array of samples */
	{length}	length	:ULONG			/* Number of samples in array */
ENDOBJECT


 /* AHIAudioModeRequester */
NATIVE {ahiaudiomoderequester} OBJECT ahiaudiomoderequester
	{audioid}	audioid	:ULONG			/* Selected audio mode */
	{mixfreq}	mixfreq	:ULONG			/* Selected mixing/sampling frequency */

	{leftedge}	leftedge	:INT			/* Coordinates of requester on exit */
	{topedge}	topedge	:INT
	{width}	width	:INT
	{height}	height	:INT

	{infoopened}	infoopened	:INT		/* Info window opened on exit? */
	{infoleftedge}	infoleftedge	:INT		/* Last coordinates of Info window */
	{infotopedge}	infotopedge	:INT
	{infowidth}	infowidth	:INT
	{infoheight}	infoheight	:INT

	{obsoleteuserdata}	obsoleteuserdata[2]	:ARRAY OF UINT
	/* Lots of private data follows! */
ENDOBJECT

 /* AHIEffMasterVolume */
NATIVE {ahieffmastervolume} OBJECT ahieffmastervolume
	{effect}	effect	:ULONG			/* Set to AHIET_MASTERVOLUME */
	{volume}	volume	:AHIFIXED			/* See autodocs for range! */
ENDOBJECT

 /* AHIEffOutputBuffer */
NATIVE {ahieffoutputbuffer} OBJECT ahieffoutputbuffer
	{effect}	effect	:ULONG		/* Set to AHIET_OUTPUTBUFFER */
	{func}	func	:PTR TO hook
 /* These fields are filled by AHI */
	{type}	type	:ULONG		/* Format of buffer */
	{buffer}	buffer	:APTR		/* Pointer to the sample array */
	{length}	length	:ULONG		/* Number of sample frames in buffer */
ENDOBJECT

 /* AHIEffDSPMask (V4) */
NATIVE {ahieffdspmask} OBJECT ahieffdspmask
	{effect}	effect	:ULONG			/* Set to AHIET_DSPMASK */
	{channels}	channels	:UINT		/* Number of elements in array */
ENDOBJECT

NATIVE {AHIEDM_WET}		CONST AHIEDM_WET		= (0)
NATIVE {AHIEDM_DRY}		CONST AHIEDM_DRY		= (1)

 /* AHIEffDSPEcho (V4) */
NATIVE {ahieffdspecho} OBJECT ahieffdspecho
	{effect}	effect	:ULONG			/* Set to AHIET_DSPECHO */
	{delay}	delay	:ULONG			/* In samples */
	{feedback}	feedback	:AHIFIXED
	{mix}	mix	:AHIFIXED
	{cross}	cross	:AHIFIXED
ENDOBJECT

->NATIVE {AHIDSPEcho} CONST		/* Fix for error in V4 includes	*/

 /* AHIEffChannelInfo (V4) */

NATIVE {ahieffchannelinfo} OBJECT ahieffchannelinfo
	{effect}	effect	:ULONG		/* Set to AHIET_CHANNELINFO */
	{func}	func	:PTR TO hook
	{channels}	channels	:UINT
	{pad}	pad	:UINT
 /* The rest is filled by AHI */
ENDOBJECT

/*** TAGS */

NATIVE {AHI_TAGBASE}		CONST AHI_TAGBASE		= (TAG_USER)
NATIVE {AHI_TAGBASER}		CONST AHI_TAGBASER		= (AHI_TAGBASE OR $8000)

 /* AHI_AllocAudioA tags */
NATIVE {AHIA_AUDIOID}		CONST AHIA_AUDIOID		= (AHI_TAGBASE+1)		/* Desired audio mode */
NATIVE {AHIA_MIXFREQ}		CONST AHIA_MIXFREQ		= (AHI_TAGBASE+2)		/* Suggested mixing frequency */
NATIVE {AHIA_CHANNELS}		CONST AHIA_CHANNELS		= (AHI_TAGBASE+3)		/* Suggested number of channels */
NATIVE {AHIA_SOUNDS}		CONST AHIA_SOUNDS		= (AHI_TAGBASE+4)		/* Number of sounds to use */
NATIVE {AHIA_SOUNDFUNC}		CONST AHIA_SOUNDFUNC		= (AHI_TAGBASE+5)		/* End-of-Sound Hook */
NATIVE {AHIA_PLAYERFUNC}		CONST AHIA_PLAYERFUNC		= (AHI_TAGBASE+6)		/* Player Hook */
NATIVE {AHIA_PLAYERFREQ}		CONST AHIA_PLAYERFREQ		= (AHI_TAGBASE+7)		/* Frequency for player Hook (Fixed)*/
NATIVE {AHIA_MINPLAYERFREQ}	CONST AHIA_MINPLAYERFREQ	= (AHI_TAGBASE+8)		/* Minimum Frequency for player Hook */
NATIVE {AHIA_MAXPLAYERFREQ}	CONST AHIA_MAXPLAYERFREQ	= (AHI_TAGBASE+9)		/* Maximum Frequency for player Hook */
NATIVE {AHIA_RECORDFUNC}		CONST AHIA_RECORDFUNC		= (AHI_TAGBASE+10)	/* Sample recording Hook */
NATIVE {AHIA_USERDATA}		CONST AHIA_USERDATA		= (AHI_TAGBASE+11)	/* What to put in ahiac_UserData */
CONST AHIA_ANTICLICKSAMPLES	= (AHI_TAGBASE+13)	/* # of samples to smooth (V5)	*/

  /* AHI_PlayA tags (V4) */
NATIVE {AHIP_BEGINCHANNEL}	CONST AHIP_BEGINCHANNEL	= (AHI_TAGBASE+40)	/* All command tags should be... */
NATIVE {AHIP_ENDCHANNEL}		CONST AHIP_ENDCHANNEL		= (AHI_TAGBASE+41)	/* ... enclosed by these tags. */
NATIVE {AHIP_FREQ}		CONST AHIP_FREQ		= (AHI_TAGBASE+50)
NATIVE {AHIP_VOL}		CONST AHIP_VOL		= (AHI_TAGBASE+51)
NATIVE {AHIP_PAN}		CONST AHIP_PAN		= (AHI_TAGBASE+52)
NATIVE {AHIP_SOUND}		CONST AHIP_SOUND		= (AHI_TAGBASE+53)
NATIVE {AHIP_OFFSET}		CONST AHIP_OFFSET		= (AHI_TAGBASE+54)
NATIVE {AHIP_LENGTH}		CONST AHIP_LENGTH		= (AHI_TAGBASE+55)
NATIVE {AHIP_LOOPFREQ}		CONST AHIP_LOOPFREQ		= (AHI_TAGBASE+60)
NATIVE {AHIP_LOOPVOL}		CONST AHIP_LOOPVOL		= (AHI_TAGBASE+61)
NATIVE {AHIP_LOOPPAN}		CONST AHIP_LOOPPAN		= (AHI_TAGBASE+62)
NATIVE {AHIP_LOOPSOUND}		CONST AHIP_LOOPSOUND		= (AHI_TAGBASE+63)
NATIVE {AHIP_LOOPOFFSET}		CONST AHIP_LOOPOFFSET		= (AHI_TAGBASE+64)
NATIVE {AHIP_LOOPLENGTH}		CONST AHIP_LOOPLENGTH		= (AHI_TAGBASE+65)

 /* AHI_ControlAudioA tags */
NATIVE {AHIC_PLAY}		CONST AHIC_PLAY		= (AHI_TAGBASE+80)	/* Boolean */
NATIVE {AHIC_RECORD}		CONST AHIC_RECORD		= (AHI_TAGBASE+81)	/* Boolean */
NATIVE {AHIC_MONITORVOLUME}	CONST AHIC_MONITORVOLUME	= (AHI_TAGBASE+82)
NATIVE {AHIC_MONITORVOLUME_QUERY} CONST AHIC_MONITORVOLUME_QUERY = (AHI_TAGBASE+83)	/* ti_Data is pointer to Fixed (LONG) */
NATIVE {AHIC_MIXFREQ_QUERY}	CONST AHIC_MIXFREQ_QUERY	= (AHI_TAGBASE+84)	/* ti_Data is pointer to ULONG */
/* --- New for V2, they will be ignored by V1 --- */
NATIVE {AHIC_INPUTGAIN}		CONST AHIC_INPUTGAIN		= (AHI_TAGBASE+85)
NATIVE {AHIC_INPUTGAIN_QUERY}	CONST AHIC_INPUTGAIN_QUERY	= (AHI_TAGBASE+86)	/* ti_Data is pointer to Fixed (LONG) */
NATIVE {AHIC_OUTPUTVOLUME}	CONST AHIC_OUTPUTVOLUME	= (AHI_TAGBASE+87)
NATIVE {AHIC_OUTPUTVOLUME_QUERY}	CONST AHIC_OUTPUTVOLUME_QUERY	= (AHI_TAGBASE+88)	/* ti_Data is pointer to Fixed (LONG) */
NATIVE {AHIC_INPUT}		CONST AHIC_INPUT		= (AHI_TAGBASE+89)
NATIVE {AHIC_INPUT_QUERY}	CONST AHIC_INPUT_QUERY	= (AHI_TAGBASE+90)	/* ti_Data is pointer to ULONG */
NATIVE {AHIC_OUTPUT}		CONST AHIC_OUTPUT		= (AHI_TAGBASE+91)
NATIVE {AHIC_OUTPUT_QUERY}	CONST AHIC_OUTPUT_QUERY	= (AHI_TAGBASE+92)	/* ti_Data is pointer to ULONG */

 /* AHI_GetAudioAttrsA tags */
NATIVE {AHIDB_AUDIOID}		CONST AHIDB_AUDIOID		= (AHI_TAGBASE+100)
NATIVE {AHIDB_DRIVER}		CONST AHIDB_DRIVER		= (AHI_TAGBASER+101)	/* Pointer to name of driver */
NATIVE {AHIDB_FLAGS}		CONST AHIDB_FLAGS		= (AHI_TAGBASE+102)	/* Private! */
NATIVE {AHIDB_VOLUME}		CONST AHIDB_VOLUME		= (AHI_TAGBASE+103)	/* Boolean */
NATIVE {AHIDB_PANNING}		CONST AHIDB_PANNING		= (AHI_TAGBASE+104)	/* Boolean */
NATIVE {AHIDB_STEREO}		CONST AHIDB_STEREO		= (AHI_TAGBASE+105)	/* Boolean */
NATIVE {AHIDB_HIFI}		CONST AHIDB_HIFI		= (AHI_TAGBASE+106)	/* Boolean */
NATIVE {AHIDB_PINGPONG}		CONST AHIDB_PINGPONG		= (AHI_TAGBASE+107)	/* Boolean */
NATIVE {AHIDB_MULTTABLE}		CONST AHIDB_MULTTABLE		= (AHI_TAGBASE+108)	/* Private! */
NATIVE {AHIDB_NAME}		CONST AHIDB_NAME		= (AHI_TAGBASER+109)	/* Pointer to name of this mode */
NATIVE {AHIDB_BITS}		CONST AHIDB_BITS		= (AHI_TAGBASE+110)	/* Output bits */
NATIVE {AHIDB_MAXCHANNELS}	CONST AHIDB_MAXCHANNELS	= (AHI_TAGBASE+111)	/* Max supported channels */
NATIVE {AHIDB_MINMIXFREQ}	CONST AHIDB_MINMIXFREQ	= (AHI_TAGBASE+112)	/* Min mixing freq. supported */
NATIVE {AHIDB_MAXMIXFREQ}	CONST AHIDB_MAXMIXFREQ	= (AHI_TAGBASE+113)	/* Max mixing freq. supported */
NATIVE {AHIDB_RECORD}		CONST AHIDB_RECORD		= (AHI_TAGBASE+114)	/* Boolean */
NATIVE {AHIDB_FREQUENCIES}	CONST AHIDB_FREQUENCIES	= (AHI_TAGBASE+115)
NATIVE {AHIDB_FREQUENCYARG}	CONST AHIDB_FREQUENCYARG	= (AHI_TAGBASE+116)	/* ti_Data is frequency index */
NATIVE {AHIDB_FREQUENCY}		CONST AHIDB_FREQUENCY		= (AHI_TAGBASE+117)
NATIVE {AHIDB_AUTHOR}		CONST AHIDB_AUTHOR		= (AHI_TAGBASE+118)	/* Pointer to driver author name */
NATIVE {AHIDB_COPYRIGHT}		CONST AHIDB_COPYRIGHT		= (AHI_TAGBASE+119)	/* Pointer to driver copyright notice */
NATIVE {AHIDB_VERSION}		CONST AHIDB_VERSION		= (AHI_TAGBASE+120)	/* Pointer to driver version string */
NATIVE {AHIDB_ANNOTATION}	CONST AHIDB_ANNOTATION	= (AHI_TAGBASE+121)	/* Pointer to driver annotation text */
NATIVE {AHIDB_BUFFERLEN}		CONST AHIDB_BUFFERLEN		= (AHI_TAGBASE+122)	/* Specifies the string buffer size */
NATIVE {AHIDB_INDEXARG}		CONST AHIDB_INDEXARG		= (AHI_TAGBASE+123)	/* ti_Data is frequency! */
NATIVE {AHIDB_INDEX}		CONST AHIDB_INDEX		= (AHI_TAGBASE+124)
NATIVE {AHIDB_REALTIME}		CONST AHIDB_REALTIME		= (AHI_TAGBASE+125)	/* Boolean */
NATIVE {AHIDB_MAXPLAYSAMPLES}	CONST AHIDB_MAXPLAYSAMPLES	= (AHI_TAGBASE+126)	/* It's sample *frames* */
NATIVE {AHIDB_MAXRECORDSAMPLES}	CONST AHIDB_MAXRECORDSAMPLES	= (AHI_TAGBASE+127)	/* It's sample *frames* */
NATIVE {AHIDB_FULLDUPLEX}	CONST AHIDB_FULLDUPLEX	= (AHI_TAGBASE+129)	/* Boolean */
/* --- New for V2, they will be ignored by V1 --- */
NATIVE {AHIDB_MINMONITORVOLUME}	CONST AHIDB_MINMONITORVOLUME	= (AHI_TAGBASE+130)
NATIVE {AHIDB_MAXMONITORVOLUME}	CONST AHIDB_MAXMONITORVOLUME	= (AHI_TAGBASE+131)
NATIVE {AHIDB_MININPUTGAIN}	CONST AHIDB_MININPUTGAIN	= (AHI_TAGBASE+132)
NATIVE {AHIDB_MAXINPUTGAIN}	CONST AHIDB_MAXINPUTGAIN	= (AHI_TAGBASE+133)
NATIVE {AHIDB_MINOUTPUTVOLUME}	CONST AHIDB_MINOUTPUTVOLUME	= (AHI_TAGBASE+134)
NATIVE {AHIDB_MAXOUTPUTVOLUME}	CONST AHIDB_MAXOUTPUTVOLUME	= (AHI_TAGBASE+135)
NATIVE {AHIDB_INPUTS}		CONST AHIDB_INPUTS		= (AHI_TAGBASE+136)
NATIVE {AHIDB_INPUTARG}		CONST AHIDB_INPUTARG		= (AHI_TAGBASE+137)	/* ti_Data is input index */
NATIVE {AHIDB_INPUT}		CONST AHIDB_INPUT		= (AHI_TAGBASE+138)
NATIVE {AHIDB_OUTPUTS}		CONST AHIDB_OUTPUTS		= (AHI_TAGBASE+139)
NATIVE {AHIDB_OUTPUTARG}		CONST AHIDB_OUTPUTARG		= (AHI_TAGBASE+140)	/* ti_Data is input index */
NATIVE {AHIDB_OUTPUT}		CONST AHIDB_OUTPUT		= (AHI_TAGBASE+141)
/* --- New for V4, they will be ignored by V2 and earlier --- */
NATIVE {AHIDB_DATA}		CONST AHIDB_DATA		= (AHI_TAGBASER+142)	/* Private! */

 /* AHI_BestAudioIDA tags */
/* --- New for V4, they will be ignored by V2 and earlier --- */
NATIVE {AHIB_DIZZY}		CONST AHIB_DIZZY		= (AHI_TAGBASE+190)

 /* AHI_AudioRequestA tags */
	/* Window control */
NATIVE {AHIR_WINDOW}		CONST AHIR_WINDOW		= (AHI_TAGBASE+200)	/* Parent window */
NATIVE {AHIR_SCREEN}		CONST AHIR_SCREEN		= (AHI_TAGBASE+201)	/* Screen to open on if no window */
NATIVE {AHIR_PUBSCREENNAME}	CONST AHIR_PUBSCREENNAME	= (AHI_TAGBASE+202)	/* Name of public screen */
NATIVE {AHIR_PRIVATEIDCMP}	CONST AHIR_PRIVATEIDCMP	= (AHI_TAGBASE+203)	/* Allocate private IDCMP? */
NATIVE {AHIR_INTUIMSGFUNC}	CONST AHIR_INTUIMSGFUNC	= (AHI_TAGBASE+204)	/* Function to handle IntuiMessages */
NATIVE {AHIR_SLEEPWINDOW}	CONST AHIR_SLEEPWINDOW	= (AHI_TAGBASE+205)	/* Block input in AHIR_Window? */
CONST AHIR_OBSOLETEUSERDATA	= (AHI_TAGBASE+206)	/* V4 UserData */
NATIVE {AHIR_USERDATA}		CONST AHIR_USERDATA		= (AHI_TAGBASE+207)	/* What to put in ahiam_UserData (V5) */
	/* Text display */
NATIVE {AHIR_TEXTATTR}		CONST AHIR_TEXTATTR		= (AHI_TAGBASE+220)	/* Text font to use for gadget text */
NATIVE {AHIR_LOCALE}		CONST AHIR_LOCALE		= (AHI_TAGBASE+221)	/* Locale to use for text */
NATIVE {AHIR_TITLETEXT}		CONST AHIR_TITLETEXT		= (AHI_TAGBASE+222)	/* Title of requester */
NATIVE {AHIR_POSITIVETEXT}	CONST AHIR_POSITIVETEXT	= (AHI_TAGBASE+223)	/* Positive gadget text */
NATIVE {AHIR_NEGATIVETEXT}	CONST AHIR_NEGATIVETEXT	= (AHI_TAGBASE+224)	/* Negative gadget text */
	/* Initial settings */
NATIVE {AHIR_INITIALLEFTEDGE}	CONST AHIR_INITIALLEFTEDGE	= (AHI_TAGBASE+240)	/* Initial requester coordinates */
NATIVE {AHIR_INITIALTOPEDGE}	CONST AHIR_INITIALTOPEDGE	= (AHI_TAGBASE+241)
NATIVE {AHIR_INITIALWIDTH}	CONST AHIR_INITIALWIDTH	= (AHI_TAGBASE+242)	/* Initial requester dimensions */
NATIVE {AHIR_INITIALHEIGHT}	CONST AHIR_INITIALHEIGHT	= (AHI_TAGBASE+243)
NATIVE {AHIR_INITIALAUDIOID}	CONST AHIR_INITIALAUDIOID	= (AHI_TAGBASE+244)	/* Initial audio mode id */
NATIVE {AHIR_INITIALMIXFREQ}	CONST AHIR_INITIALMIXFREQ	= (AHI_TAGBASE+245)	/* Initial mixing/sampling frequency */
NATIVE {AHIR_INITIALINFOOPENED}	CONST AHIR_INITIALINFOOPENED	= (AHI_TAGBASE+246)	/* Info window initially opened? */
NATIVE {AHIR_INITIALINFOLEFTEDGE} CONST AHIR_INITIALINFOLEFTEDGE = (AHI_TAGBASE+247)	/* Initial Info window coords. */
NATIVE {AHIR_INITIALINFOTOPEDGE} CONST AHIR_INITIALINFOTOPEDGE = (AHI_TAGBASE+248)
NATIVE {AHIR_INITIALINFOWIDTH}	CONST AHIR_INITIALINFOWIDTH	= (AHI_TAGBASE+249)	/* Not used! */
NATIVE {AHIR_INITIALINFOHEIGHT}	CONST AHIR_INITIALINFOHEIGHT	= (AHI_TAGBASE+250)	/* Not used! */
	/* Options */
NATIVE {AHIR_DOMIXFREQ}		CONST AHIR_DOMIXFREQ		= (AHI_TAGBASE+260)	/* Allow selection of mixing frequency? */
NATIVE {AHIR_DODEFAULTMODE}	CONST AHIR_DODEFAULTMODE	= (AHI_TAGBASE+261)	/* Allow selection of default mode? (V4) */
	/* Filtering */
NATIVE {AHIR_FILTERTAGS}		CONST AHIR_FILTERTAGS		= (AHI_TAGBASE+270)	/* Pointer to filter taglist */
NATIVE {AHIR_FILTERFUNC}		CONST AHIR_FILTERFUNC		= (AHI_TAGBASE+271)	/* Function to filter mode id's */

/*** DEFS */

NATIVE {AHINAME}			CONST
#define AHINAME ahiname
STATIC ahiname			= 'ahi.device'

NATIVE {AHI_INVALID_ID}		CONST AHI_INVALID_ID		= (NOT $0)			/* Invalid Audio ID */
NATIVE {AHI_DEFAULT_ID}		CONST AHI_DEFAULT_ID		= ($00000000)		/* Only for AHI_AllocAudioA()! */
NATIVE {AHI_LOOPBACK_ID}		CONST AHI_LOOPBACK_ID		= ($00000001)		/* Special sample render Audio ID */
NATIVE {AHI_DEFAULT_FREQ}	CONST AHI_DEFAULT_FREQ	= (0)			/* Only for AHI_AllocAudioA()! */
NATIVE {AHI_MIXFREQ}		CONST AHI_MIXFREQ		= (NOT $0)			/* Special frequency for AHI_SetFreq() */
NATIVE {AHI_NOSOUND}		CONST AHI_NOSOUND		= ($ffff)		/* Turns a channel off */

 /* Set#? Flags */
NATIVE {AHISF_IMM}		CONST AHISF_IMM		= $1	/* Trigger action immediately	*/
CONST AHISF_NODELAY		= $2	/* Don't wait for zero-crossing */

CONST AHISF_NONE		= (0)		/* No flags (V5)		*/

CONST AHISB_IMM		= (0)
CONST AHISB_NODELAY		= (1)

 /* Effect Types */
NATIVE {AHIET_CANCEL}		CONST AHIET_CANCEL		= $80000000		/* OR with effect to disable */
NATIVE {AHIET_MASTERVOLUME}	CONST AHIET_MASTERVOLUME	= (1)
NATIVE {AHIET_OUTPUTBUFFER}	CONST AHIET_OUTPUTBUFFER	= (2)
/* --- New for V4 --- */
NATIVE {AHIET_DSPMASK}		CONST AHIET_DSPMASK		= (3)
NATIVE {AHIET_DSPECHO}		CONST AHIET_DSPECHO		= (4)
NATIVE {AHIET_CHANNELINFO}	CONST AHIET_CHANNELINFO	= (5)

 /* Sound Types */
NATIVE {AHIST_NOTYPE}		CONST AHIST_NOTYPE		= (NOT $0)			/* Private */
NATIVE {AHIST_SAMPLE}		CONST AHIST_SAMPLE		= (0)			/* 8 or 16 bit sample */
NATIVE {AHIST_DYNAMICSAMPLE}	CONST AHIST_DYNAMICSAMPLE	= (1)			/* Dynamic sample */
NATIVE {AHIST_INPUT}		CONST AHIST_INPUT		= $20000000		/* The input from your sampler */
NATIVE {AHIST_BW}		CONST AHIST_BW		= $40000000		/* Private */

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

NATIVE {ahiunitprefs} OBJECT ahiunitprefs
	{unit}	unit	:UBYTE
	{pad}	pad	:UBYTE
	{channels}	channels	:UINT
	{audiomode}	audiomode	:ULONG
	{frequency}	frequency	:ULONG
	{monitorvolume}	monitorvolume	:AHIFIXED
	{inputgain}	inputgain	:AHIFIXED
	{outputvolume}	outputvolume	:AHIFIXED
	{input}	input	:ULONG
	{output}	output	:ULONG
ENDOBJECT

NATIVE {ahiglobalprefs} OBJECT ahiglobalprefs
	{debuglevel}	debuglevel	:UINT			/* Range: 0-3 (for None, Low,
							   High and All) */
	{disablesurround}	disablesurround	:INT
	{disableecho}	disableecho	:INT
	{fastecho}	fastecho	:INT
	{maxcpu}	maxcpu	:AHIFIXED
	{clipmastervolume}	clipmastervolume	:INT
	{pad}	pad	:UINT
	{anticlicktime}	anticlicktime	:AHIFIXED			/* In seconds (V5) */
ENDOBJECT

 /* Debug levels */
NATIVE {AHI_DEBUG_NONE}		CONST AHI_DEBUG_NONE		= (0)
NATIVE {AHI_DEBUG_LOW}		CONST AHI_DEBUG_LOW		= (1)
NATIVE {AHI_DEBUG_HIGH}		CONST AHI_DEBUG_HIGH		= (2)
NATIVE {AHI_DEBUG_ALL}		CONST AHI_DEBUG_ALL		= (3)

 /* AHIRequest */

NATIVE {ahirequest} OBJECT ahirequest
	{iostd}	iostd	:iostd		/* Standard IO request */
	{version}	version	:UINT		/* Needed version */
/* --- New for V4, they will be ignored by V2 and earlier --- */
	{pad1}	pad1	:UINT
	{private1}	private1	:ULONG	/* Hands off! */
	{private2}	private2	:ULONG	/* Hands off! */
	{type}	type	:ULONG		/* Sample format */
	{frequency}	frequency	:ULONG	/* Sample/Record frequency */
	{volume}	volume	:AHIFIXED		/* Sample volume */
	{position}	position	:AHIFIXED		/* Stereo position */
	{link}	link	:PTR TO ahirequest		/* For double buffering */
ENDOBJECT

 /* Flags for OpenDevice() */

NATIVE {AHIDF_NOMODESCAN}	CONST AHIDF_NOMODESCAN	= $1
CONST AHIDB_NOMODESCAN	= (0)
