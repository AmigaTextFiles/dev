	IFND	LIBRARIES_VOICE_I
LIBRARIES_VOICE_I SET	1
**
**	$Filename: libraries/voice.i $
**	$Release: 1.00 $
**	$Revision: 1.1 $
**	$Date: 93/06/18 $
**
**	Voice.library definitions
**
**	Written originally by Tomi Blinnikka
**

VOICEVERSION	EQU	8

**	Library offsets

_LVOLearn		EQU	-30
_LVORecognize		EQU	-36
_LVOAddVoiceTask	EQU	-42
_LVORemVoiceTask	EQU	-48
_LVOGainUp		EQU	-54
_LVOGainDown		EQU	-60
_LVORecDataAddress	EQU	-66
_LVORecMapAddress	EQU	-72
_LVOWordScore		EQU	-78
_LVOPickSampler		EQU	-84
_LVOSetVoicePri		EQU	-90
_LVOPickTimer		EQU	-96
_LVOWhatGain		EQU	-102
_LVOPickChannel		EQU	-108
_LVOPickInput		EQU	-114


**	Macro for library name

VoiceName	MACRO
		dc.b	'voice.library',0
		ds.w	0
		ENDM


**	Timer to use with VoiceTask

TIMER_B		EQU	0
TIMER_A		EQU	1


**	The samplers supported by voice.library

SAMP_PERFSND	EQU	0
SAMP_SNDMSTR	EQU	1
SAMP_GENERIC	EQU	2
SAMP_DSS8	EQU	3


**	Frequency analysis resolution

RES_HI		EQU	0
RES_LO		EQU	1

**	Which channel to use. FOR: PerfectSound, SoundMaster and DSS 8
**	only

CHANNEL_RIGHT	EQU	0
CHANNEL_LEFT	EQU	1


**	Input level (microphone or line) to use. FOR: PerfectSound,
**	SoundMaster and DSS 8

INPUT_MIC	EQU	0
INPUT_LINE	EQU	1


	ENDC	; LIBRARIES_VOICE_I
