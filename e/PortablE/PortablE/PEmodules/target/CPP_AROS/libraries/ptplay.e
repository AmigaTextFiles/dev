/* protracker 2.3a player */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/utility/tagitem'
{#include <libraries/ptplay.h>}
NATIVE {LIBRARIES_PTREPLAY_H} CONST

STATIC ptplay_name = 'ptplay.library'

NATIVE {PT_MOD_UNKNOWN}		CONST PT_MOD_UNKNOWN		= 0
NATIVE {PT_MOD_PROTRACKER}	CONST PT_MOD_PROTRACKER	= 1

NATIVE {MODF_DOSONGEND}		CONST MODF_DOSONGEND		= $0001		/* perform song-end detection */
NATIVE {MODF_ALLOWPANNING}	CONST MODF_ALLOWPANNING	= $0002		/* allow mod to use command $8 for panning */
NATIVE {MODF_ALLOWFILTER}	CONST MODF_ALLOWFILTER	= $0004		/* allow mod to set lowpass filter */
NATIVE {MODF_SONGEND}			CONST MODF_SONGEND			= $0008		/* songend occured */

NATIVE {PlayMod} OBJECT playmod
ENDOBJECT 

NATIVE {PatternData} OBJECT patterndata
	{period}	period	:VALUE
	{sample}	sample	:VALUE
	{effect}	effect	:UBYTE
	{efd1}	efd1	:UBYTE
	{efd2}	efd2	:UBYTE
	{efboth}	efboth	:UBYTE
	{pad}	pad	:VALUE
ENDOBJECT

NATIVE {Pattern} OBJECT pattern
	{data}	data	:ARRAY OF ARRAY OF patterndata
ENDOBJECT

NATIVE {PTPLAY_CIAspeed}			CONST PTPLAY_CIAspeed			= (TAG_USER + $00)	/* SG	ULONG					Default: 125					*/
NATIVE {PTPLAY_Flags}				CONST PTPLAY_Flags				= (TAG_USER + $01)	/* SG ULONG					Default: MODF_ALLOWFILTER	*/
NATIVE {PTPLAY_MasterVolume}		CONST PTPLAY_MasterVolume		= (TAG_USER + $02)	/* SG	ULONG					Default: 256 					*/
NATIVE {PTPLAY_PatternData}		CONST PTPLAY_PatternData		= (TAG_USER + $03)	/* .G struct Pattern *										*/
NATIVE {PTPLAY_PatternPosition}	CONST PTPLAY_PatternPosition	= (TAG_USER + $04)	/* SG ULONG														*/
NATIVE {PTPLAY_Patterns}			CONST PTPLAY_Patterns			= (TAG_USER + $05)	/* .G ULONG														*/
NATIVE {PTPLAY_Positions}			CONST PTPLAY_Positions			= (TAG_USER + $06)	/* .G	ULONG *													*/
NATIVE {PTPLAY_SongLength}			CONST PTPLAY_SongLength			= (TAG_USER + $07)	/* .G	ULONG														*/
NATIVE {PTPLAY_SongLoopCount}		CONST PTPLAY_SongLoopCount		= (TAG_USER + $08)	/* .G	ULONG														*/
NATIVE {PTPLAY_SongPosition}		CONST PTPLAY_SongPosition		= (TAG_USER + $09)	/* SG ULONG														*/
NATIVE {PTPLAY_SongTitle}			CONST PTPLAY_SongTitle			= (TAG_USER + $0A)	/* .G	STRPTR													*/
NATIVE {PTPLAY_TotalTime}			CONST PTPLAY_TotalTime			= (TAG_USER + $0B)	/* .G ULONG														*/
