/* protracker 2.3a player */
OPT NATIVE
MODULE 'target/utility/tagitem'
{MODULE 'libraries/ptplay'}

STATIC ptplay_name = 'ptplay.library'

NATIVE {PTPLAY_CIAspeed}			CONST PTPLAY_CIAspeed			= (TAG_USER + $00)	/* SG	ULONG		Default: 125					*/
NATIVE {PTPLAY_Flags}				CONST PTPLAY_Flags				= (TAG_USER + $01)	/* SG ULONG		Default: MODF_ALLOWFILTER	*/
NATIVE {PTPLAY_MasterVolume}		CONST PTPLAY_MasterVolume		= (TAG_USER + $02)	/* SG	ULONG		Default: 256 					*/
NATIVE {PTPLAY_PatternPosition}		CONST PTPLAY_PatternPosition	= (TAG_USER + $04)	/* SG ULONG											*/
NATIVE {PTPLAY_Patterns}			CONST PTPLAY_Patterns			= (TAG_USER + $05)	/* .G ULONG		Number of patterns			*/
NATIVE {PTPLAY_SongLength}			CONST PTPLAY_SongLength			= (TAG_USER + $07)	/* .G	ULONG 	Song length in patterns		*/
NATIVE {PTPLAY_SongLoopCount}		CONST PTPLAY_SongLoopCount		= (TAG_USER + $08)	/* .G	ULONG		Number of loops done			*/
NATIVE {PTPLAY_SongPosition}		CONST PTPLAY_SongPosition		= (TAG_USER + $09)	/* SG ULONG		Current position				*/
NATIVE {PTPLAY_SongTitle}			CONST PTPLAY_SongTitle			= (TAG_USER + $0A)	/* .G	STRPTR	Song name						*/
NATIVE {PTPLAY_TotalTime}			CONST PTPLAY_TotalTime			= (TAG_USER + $0B)	/* .G ULONG 	Song length in seconds		*/

NATIVE {PT_MOD_UNKNOWN}			CONST PT_MOD_UNKNOWN			= 0
NATIVE {PT_MOD_PROTRACKER}		CONST PT_MOD_PROTRACKER		= 1
NATIVE {PT_MOD_SOUNDTRACKER}	CONST PT_MOD_SOUNDTRACKER	= 2
NATIVE {PT_MOD_SOUNDFX}			CONST PT_MOD_SOUNDFX			= 3

/* Values for PTPLAY_Flags
 */

NATIVE {MODF_DOSONGEND}		CONST MODF_DOSONGEND		= $0001		/* perform song-end detection */
NATIVE {MODF_ALLOWPANNING}	CONST MODF_ALLOWPANNING	= $0002		/* allow mod to use command $8 for panning */
NATIVE {MODF_ALLOWFILTER}	CONST MODF_ALLOWFILTER	= $0004		/* allow mod to set lowpass filter */
NATIVE {MODF_SONGEND}		CONST MODF_SONGEND			= $0008		/* songend occured */
