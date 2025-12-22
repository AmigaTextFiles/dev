	IFND	LIBRARIES_STUDIO16FILE_I
LIBRARIES_STUDIO16FILE_I	SET	1

**
**	The unofficial developer docs for Studio 16 files.
**
**		$VER: Studio16fileformats 3.1 (08.12.97)
**
**	This document is copyright by Kenneth "Kenny" Nilsen.
**	Freely distributable. Commercial authors should read the
**	NOTE file in the Studio16add.lha archive.
**
**	Cuelist file analyzed by
**
**		Kenneth "Kenny" Nilsen <kenny@bgnett.no> and
**		John Blyth <john.blyth@edserv.monash.edu.au>
**
**	- STUDIO16 SAMPLE      [KWK3] full description of sample files
**	- STUDIO16 CUELIST     [TLC1] full description of cuelist files
**	- STUDIO16 TRACK       [TRAX] full description of track files
**	- STUDIO16 VOL/PAN ENV [SRMX] full description of mixer files
**	- STUDIO16 GRAPHFILE   <noID>  [not included in this release]
**


	IFND	EXEC_TYPES_I
	include	"exec/types.i"
	ENDC

; Initializers

ID_KWK	=	'KWK3'		;S16 sample files.
ID_TLC	=	'TLC1'		;S16 cuelist files.
ID_TYPE	=	'TYPE'		;S16 cuelist chunks.
ID_SAMP	=	'SAMP'
ID_EVNT	=	'EVNT'
ID_END	=	'END!'		;End mark in S16 cuelist files.
ID_TRAX	=	'TRAX'		;S16 Cuelist track files.
ID_SRMX	=	'SRMX'		;Volume/Pan envelope files.
ID_VOL	=	'VOL '		;SRMX chunks.
ID_PAN	=	'PAN '
ID_CHAN	=	'CHAN'


S16FILTERINIT	= $1		;use may also use S16S_RATE (S16R_RATE/2).
S16FLAGINIT	= $0		;init S16S_FLAGS with this value.


; structure of a SMPTE stamp:

    STRUCTURE	S16SMPTESTAMP,0
	UBYTE	S16SMPTE_HOURS		;number of hours
	UBYTE	S16SMPTE_MIN		;number of minuttes.
	UBYTE	S16SMPTE_SEC		;number of seconds.
	UBYTE	S16SMPTE_FRAMES		;number of frames rel. to PAL/NTSC etc.
	LABEL	S16SMPTE_SIZEOF

* File header structure

; Studio 16 SAMPLEFILE contains:
;
;   [STUDIO16SAMPLE]    SampleClips and Regions inclusive (below)
;   [SAMPLEDATA]
;
; Originally:
;
;   [HEADERID]
;   [SAMPLEINFO STRUCT]
;   [SAMPLECLIPS x128]
;   [REGIONS x32]
;   [SAMPLEDATA]
;
; Sampledata consists of pure signed RAW 16-bit data in Motorola format

    STRUCTURE S16SAMPLE,0	;Studio 16 SAMPLE files.

	ULONG	S16S_ID		;FILE HEADER ID (Init with ID_KWK).

; SampleInfo struct:

	ULONG	S16S_RATE	;sample rate in integer.
	ULONG	S16S_FILTER	;Init with S16FILTERINIT or (S16F_RATE).
	UWORD	S16S_VOLUME	;Calculated volume.
	STRUCT	S16S_SMPTE,S16SMPTE_SIZEOF	;SMPTE timecode.
	FLOAT	S16S_SMPTEFLOAT	;SMPTE sampling rate as float.
	ULONG	S16S_PAN	;Calculated pan.
	ULONG	S16S_FLAGS	;(undocumented), init with S16FLAGSINIT.
	ULONG	S16S_res	;Reserved field.

; Related to the sample data:

	ULONG	S16S_REALSIZE	;number of samples (bytesize/2).
	ULONG	S16S_EDITSIZE	;number of samples after editlist.

; here follows a list of SampleClips (see format of sampleclips below)

	ULONG	S16S_EDITLIST	;here starts the SampleClip list.
	ULONG	S16S_END	;init this with REALSIZE-1 if newfile.

	STRUCT	S16S_SAMPLECLIPLIST,1016 ;list excl. the one above (=1024)

; Here starts the Region list

	STRUCT	S16S_REGIONLIST,2624	;region list (S16R_SIZEOF x32).
	LABEL	S16S_SIZEOF		;=3690.


; Edit size is calculated by calculating the sum of all SampleClips:
;
;	S16SC_END-S16SC_START+1
;
; How to determine SampleClip-list end:
;
;	Add all SampleClips togetter until (S16S_END or S16SC_END) = 0 AND
;	the size you have got equals S16R_EDITSIZE. The reason is that some
;	SampleClip may result in a NULL size since it's included due to non
;	size edits such as volume changes.

; The SampleClip structure is contained in the STUDIO16FILE structure. It is
; repeated 128 times:

    STRUCTURE S16SAMPLECLIP,0
	ULONG	S16SC_START		;start pos in range.
	ULONG	S16SC_END		;end pos in range.
	LABEL	S16SC_SIZEOF

MAXSAMPLECLIPS	=	128		;max number of clips in file.

; Regions are ranges which keep their own settings so you can make a region
; act like a seperate file:

S16REGIONINIT	=	0		;or use S16F_RATE as FLOAT.
S16REGIONSIZE	=	82

    STRUCTURE	S16REGION,0
	STRUCT	S16R_NAME,40		;name on region.

;sampleclip

	ULONG	S16R_START		;sample start pos.
	ULONG	S16R_END		;sample end pos - size=end-start+1.

;sampleinfo

	ULONG	S16R_RATE		;sample rate.
	ULONG	S16R_FILTER		;Init with $1 (K16FINIT).
	UWORD	S16R_VOLUME		;sample volume.
	STRUCT	S16R_SMPTE,S16SMPTE_SIZEOF	;SMPTE timecode.
	FLOAT	S16R_SMPTEFLOAT		;init with S16REGIONINIT.
	ULONG	S16R_PAN		;pan.
	ULONG	S16R_FLAGS		;misc flags (undocumented).
	STRUCT	S16R_res,8		;reserved space.
	LABEL	S16R_SIZEOF		;=82 bytes.

MAXREGIONS	=	32		;max number of regions in list.
MAXREGIONNAME	=	24		;max number of chars in name - use this
					;to be compatible with Studio 16 editor.

; Sample rates for Studio 16:

S16_FREQ_0	EQU	$1589	; 5513 hz
S16_FREQ_1	EQU	$19D7	; 6615 hz
S16_FREQ_2	EQU	$1F40	; 8000 hz RA (RealAudio)
S16_FREQ_3	EQU	$2580	; 9600 hz TELE
S16_FREQ_4	EQU	$2B11	;11025 hz
S16_FREQ_5	EQU	$3e80	;16000 hz
S16_FREQ_6	EQU	$49D4	;18900 hz
S16_FREQ_7	EQU	$5622	;22050 hz
S16_FREQ_8	EQU	$6B25	;27429 hz
S16_FREQ_9	EQU	$7D00	;32000 hz FM, REELS
S16_FREQ_A	EQU	$8133	;33075 hz HIBAND -> Betacam/MII/Umatic
S16_FREQ_B	EQU	$93A8	;37800 hz
S16_FREQ_C	EQU	$AC44	;44100 hz CD
S16_FREQ_D	EQU	$BB80	;48000 hz DAT

; For convinience only:

S16_FREQ_RA	EQU	S16_FREQ_2
S16_FREQ_TELE	EQU	S16_FREQ_3
S16_FREQ_FM	EQU	S16_FREQ_9
S16_FREQ_REEL	EQU	S16_FREQ_9
S16_FREQ_HIBAND	EQU	S16_FREQ_A
S16_FREQ_CD	EQU	S16_FREQ_C
S16_FREQ_DAT	EQU	S16_FREQ_D

; Volumes
;
; Calc: S16F_VOLUME/S16_VOL_STEPS-100 = x dB
;       value = (x dB + 100) x S16_VOL_STEPS

S16_VOL_0	EQU	$C80	; +0 dB
S16_VOL_OFF	EQU	0	; oo dB

S16_VOL_STEPS	EQU	$20	;you may use 1/4th of this step.

; for convinience only:

S16_VOL_DOUBLE	EQU	$D40	; +6.0 dB (200 % volume).
S16_VOL_NORMAL	EQU	$C80	; +0.0 dB (100 % volume).
S16_VOL_HALF	EQU	$BC0	; -6.0 dB ( 50 % volume).
S16_VOL_QUATER	EQU	$B00	;-12.0 dB ( 25 % volume).
S16_VOL_BACK	EQU	$9C0	;-22.0 dB (music for voiceover).

; Pans
;
; Calc: S16F_PAN/S16_PAN_STEPS = Pan pos 0-200, 100=center
;       value = Pan x S16_PAN_STEPS

S16_PAN_LEFT	EQU	$0	;full left.
S16_PAN_MID	EQU	$C80	;center.
S16_PAN_RIGHT	EQU	$1900	;full right.

S16_PAN_STEPS	EQU	$20	;you may use 1/4th of this step.

; for convinience only:

S16_PAN_LEFT50	EQU	$640	;50% to left.
S16_PAN_RIGHT50	EQU	$12C0	;50% to right.

*---------------------------------------------------------------------------
* From 4.0
*---------------------------------------------------------------------------

* NOTE: The strings used below (except _COMMENT) are of the following format:
*
*	ULONG  STRINGLENGTH
*	STRUCT STRING,STRINGLENGTH
*
* In the stucture overview you will find a container marked [-SOMETHING] which
* means this is a string of the above format.

* NOTE: All DOUBLE sizes are in seconds. The mantissa is one second's
* resolution, however the resolution can never be greater than the
* frequency (max 1/48000th of a second) in real life.

; Cuelist fileformat 'TLC1' -
;
; A Cuelist file is built like this:
;
; [TLC1HEADER]
; [TYPE]
; [SAMP/EVNT * n]
; [END mark]
; [TYPE]
; [SAMP/EVNT * n]
; [END mark]
; [TYPE]
; [...and so on...]
; [END mark]
; [END mark]	the double END! mark is end of file


; TLC1 HEADER consists of:
;
;	[TLCHEAD]
;	[-PATH x2]
;	[-NAME x2]
;	[TLCBODY]

    STRUCTURE TLCHEAD,0
	ULONG	TLCH_ID		;file ID [=TLC1].
	ULONG	TLCH_WINLEFT	;window position/sizes when saved. Will
	ULONG	TLCH_WINTOP	;become the zip size when loaded.
	ULONG	TLCH_WINHEIGHT	;minimum 90.
	ULONG	TLCH_WINWIDTH	;minimum 377.
	LABEL	TLCH_SIZEOF

TLCMINWINWIDTH		=	377
TLCMINWINHEIGHT		=	90

; then there follows four strings in this format:
;
;  [(ULONG)Length of string] [String]
;
; - The first string is 'Track' path
; - The second string is 'Cuelist' path
; - The third string is 'Trackname'
; - The fourth string is 'Cuelistfilename'

    STRUCTURE TLCBODY,0

; preferences

	STRUCT	TLCB_res0,6		;<unknown settings - ignored>.
	UBYTE	TLCB_FADEINTYPE		;See SAMPBODY for different types.
	UBYTE	TLCB_FADEOUTTYPE
	DOUBLE	TLCB_MAXTIME		;use f.ex. ieeedoubbas.library.
	DOUBLE	TLCB_GRIDSPACING
	DOUBLE	TLCB_STARTTIME		;start of cuelist
	ULONG	TLCB_TOTALLENGTH	;in seconds*100
	ULONG	TLCB_VIEWSIZE		;when saved (sec*100)
	ULONG	TLCB_VIEWSTART		;(sec*100)
	ULONG	TLCB_BPM		;Beats Per Minutes.
	ULONG	TLCB_BPMX		;BPM X/Y (f.ex 4/4).
	ULONG	TLCB_BPMY
	ULONG	TLCB_TIMEOPTIONS	;what timer is used (SMPTE/CLK/BPM).
	STRUCT	TLCB_res1,122

; Flag markers

	DOUBLE	TLCB_F1POS		;position of mark (-1=not used).
	LONG	TLCB_F1VIEWPOS		;If -1 then the flag is not in view.
					;else, start of view in sec*100
					;you may ignore this value.
	STRUCT	TLCB_F1COMMENT,80	;Comment including NULL termination.
	STRUCT	TLCB_f1reserved,30	;Reserved for ASCII representation,
					;but isn't implemented officially.

	DOUBLE	TLCB_F2POS
	LONG	TLCB_F2VIEWPOS
	STRUCT	TLCB_F2COMMENT,80
	STRUCT	TLCB_f2reserved,30

	DOUBLE	TLCB_F3POS
	LONG	TLCB_F3VIEWPOS
	STRUCT	TLCB_F3COMMENT,80
	STRUCT	TLCB_f3reserved,30

	DOUBLE	TLCB_F4POS
	LONG	TLCB_F4VIEWPOS
	STRUCT	TLCB_F4COMMENT,80
	STRUCT	TLCB_f4reserved,30

	DOUBLE	TLCB_F5POS
	LONG	TLCB_F5VIEWPOS
	STRUCT	TLCB_F5COMMENT,80
	STRUCT	TLCB_f5reserved,30

	DOUBLE	TLCB_F6POS
	LONG	TLCB_F6VIEWPOS
	STRUCT	TLCB_F6COMMENT,80
	STRUCT	TLCB_f6reserved,30

	DOUBLE	TLCB_F7POS
	LONG	TLCB_F7VIEWPOS
	STRUCT	TLCB_F7COMMENT,80
	STRUCT	TLCB_f7reserved,30

	DOUBLE	TLCB_F8POS
	LONG	TLCB_F8VIEWPOS
	STRUCT	TLCB_F8COMMENT,80
	STRUCT	TLCB_f8reserved,30

	DOUBLE	TLCB_F9POS
	LONG	TLCB_F9VIEWPOS
	STRUCT	TLCB_F9COMMENT,80
	STRUCT	TLCB_f9reserved,30

	DOUBLE	TLCB_F10POS
	LONG	TLCB_F10VIEWPOS
	STRUCT	TLCB_F10COMMENT,80
	STRUCT	TLCB_f10reserved,30

	DOUBLE	TLCB_LOCATEPOS		;red location mark.
	LONG	TLCB_LOCATEVIEWPOS
	STRUCT	TLCB_LOCATECOMMENT,80
	STRUCT	TLCB_LOCATEASCII,30	;ASCII representation of location mark
					;only mark which has support for this.
					;Note that the ascii also reflects
					;which time mode is used (SMPTE/BPM..).

	DOUBLE	TLCB_STARTPOS		;blue start mark.
	LONG	TLCB_STARTVIEWPOS
	STRUCT	TLCB_STARTCOMMENT,80
	STRUCT	TLCB_startreserved,30	;reserved.

	DOUBLE	TLCB_PUNCHINPOS		;yellow punch-in mark.
	LONG	TLCB_PUNCHINVIEWPOS
	STRUCT	TLCB_PUNCHINCOMMENT,80
	STRUCT	TLCB_punchinreserved,30

	DOUBLE	TLCB_PUNCHOUTPOS	;yellow punch-out mark.
	LONG	TLCB_PUNCHOUTVIEWPOS
	STRUCT	TLCB_PUNCHOUTCOMMENT,80
	STRUCT	TLCB_punchoutreserved,30

	STRUCT	TLCB_res2,100		;reserved.

	LABEL	TLCB_SIZEOF		;=1990 bytes.

; Timer options:

TLCTIME_HOURMINUTESECOND	EQU	$0
TLCTIME_SMPTE			EQU	$1
TLCTIME_BPM			EQU	$2
TLCTIME_SMPTEPLUS		EQU	$4

TLCMARK_NOTINUSE		EQU	-1	;Mark isn't used.
TLCMARK_OUTSIDE			EQU	-1	;Mark is not in view.

; Bit defs

TLCTIMEB_SMPTE			EQU	0
TLCTIMEB_BPM			EQU	1
TLCTIMEB_SMPTEPLUS		EQU	2


; The 'TYPE' chunk can be two types: "Audio" or "AREXX". The Type describes
; each track in the cuelist.
;
; You first need to check which type of track this is and then
; use the structure for the tracktype.
;
; To determine the track type you must first read the first
; string:
;
;  [(ULONG)Length of string] [String]
;
; This can be either "Audio" or "AREXX".
;
; You must then read the next string in the same format to get the track name.
; This applies to both types.
;
; If the type="AREXX" then you must read an additional string to get the port
; name.


; TYPE CHUNK consists of:
;
; Common:
;	[-TYPE OF TRACK STRING]
;	[-NAME OF TRACK]
;
; Audio:
;	[TYPEAUDIO]
;	[-PLAY CHANNEL]
;	[-REC CHANNEL]
;	[TYPEAUDIOFOOT]
;
; AREXX:
;	[-NAME OF PORT]
;	[TYPEAREXX]


; "Audio" TRACK -

    STRUCTURE TYPEAUDIO,0
	DOUBLE	TYPA_RATE	;this track's frequency.
	UBYTE	TYPA_USELPREFS	;prefs when entries are unselected.
	UBYTE	TYPA_SELPREFS	;prefs when entries are selected.
	UBYTE	TYPA_TRACKPREFS	;prefs for track status.
	UBYTE	TYPA_ENTRIES	;if track contains (un)selected entries.
	LABEL	TYPA_SIZEOF

; For type there are two more strings right after this structure you must read.
; The first string is name on the play channel, the second is the name of the
; record channel. Note that some types of channel (like 'Any') gets prefixed by
; what card is used (f.ex. "AD516.Any").
;
; After the two strings there is reserved 100 bytes which you must skip to get
; the next chunk.
 
    STRUCTURE TYPEAUDIOFOOT,0
	STRUCT	TYPAF_res,100
	LABEL	TYPAF_SIZEOF


; "AREXX" TRACK -

    STRUCTURE TYPEAREXX,0
	UWORD	TYPR_res0
	UBYTE	TYPR_TRACKPREFS
	UBYTE	TYPR_pad0
	STRUCT	TYPR_res1,100
	LABEL	TYPR_SIZEOF

; flags for track preferences:

TYPAPREF_SHOWREGIONNAME		EQU	$1
TYPAPREF_SHOWSTARTTIME		EQU	$2
TYPAPREF_SHOWSAMPLESIZE		EQU	$4
TYPAPREF_SHOWFADETIME		EQU	$8

; for both track types (Audio/AREXX):

TYPTRACK_SOUNDBUTTONON		EQU	$1
TYPTRACK_SOLOBUTTONON		EQU	$2
TYPTRACK_TRACKSELECTED		EQU	$4

; entries' status in track (global for one track):

TYPTRACK_ENTRIESUNSELECTED	EQU	$0
TYPTRACK_ENTRIESSELECTED	EQU	$2

; bit defs:

TYPAPREFB_SHOWREGIONNAME	EQU	0	;OR togetter to set more
TYPAPREFB_SHOWSTARTTIME		EQU	1	;options at the same time.
TYPAPREFB_SHOWSAMPLESIZE	EQU	2
TYPAPREFB_SHOWFADETIME		EQU	3

TYPTRACKB_SOUNDBUTTONON		EQU	0
TYPTRACKB_SOLOBUTTONON		EQU	1
TYPTRACKB_TRACKSELECTED		EQU	2

TYPTRACKB_ENTRIESSELECTED	EQU	1


; The 'SAMP' chunk contains data of each entries on an 'Audio' type of track.
; You can find volume, pan, position, sizes, fades and so on.

; SAMP -
;
; SAMP CHUNK consist of:
;
;	[SAMPHEAD]
;	[-SAMPLE PATH/NAME]
;	[SAMPBODY]


    STRUCTURE SAMPHEAD,0
	ULONG	SAMPH_STATUS	;status of entry.
	DOUBLE	SAMPH_STARTPOS	;startposition of entry in sec.
	DOUBLE	SAMPH_ENDPOS
	ULONG	SAMPH_res0
	ULONG	SAMPH_GROUPID	;Group this entry belongs to (null=none).
	LABEL	SAMPH_SIZEOF

; Right after this structure you will find a string of the type:
;
;  [(ULONG)Length of string] [String]
;
; which contains path and sample name. Then the chunk continues with
; this structure:

    STRUCTURE SAMPBODY,0
	WORD	SAMPB_res0
	UBYTE	SAMPB_FADEINTYPE	;what fadetype is used for intro.
	UBYTE	SAMPB_FADEOUTTYPE
	DOUBLE	SAMPB_FADEINTIME	;fade time 0=none.
	DOUBLE	SAMPB_FADEOUTTIME
	ULONG	SAMPB_CROPIN	        ;Sample start (rel. to pos) in
	ULONG	SAMPB_CROPOUT           ;number of samples
	UWORD	SAMPB_VOLUME		;see S16S_VOL_...
	ULONG	SAMPB_PAN		;see S16S_PAN_...
	STRUCT	SAMPB_res1,50		;50 bytes reserved.
	LABEL	SAMPB_SIZEOF

; flags for sample entry status:

SAMPSTAT_NOEXIST	EQU	$0
SAMPSTAT_NOEXISTSEL	EQU	$1
SAMPSTAT_OK		EQU	$2
SAMPSTAT_OKSEL		EQU	$3

; flags for fade types:

FADE_LINEAR		EQU	$0	;linear fade.
FADE_BUTT		EQU	$1	;no fade.
FADE_LOGA		EQU	$2	;logaritmic fade.
FADE_EXPO		EQU	$4	;exponential fade.

; bit defs

SAMPSTATB_SELECTED	EQU	0	;sample is selected.
SAMPSTATB_OK		EQU	1	;sample exists.

FADEB_BUTT		EQU	0
FADEB_LOGA		EQU	1
FADEB_EXPO		EQU	2

; The 'EVNT' chunk is for "AREXX" type of tracks. It contains
; mostly strings for the comands you specify.

; EVNT -
;
; ENVT CHUNK consists of
;
;	[EVENTHEAD]
;	[-ENTRYNAME]
;	[EVENTBODY]
;	[-COMANDS x9]
;	[EVENTFOOT]

    STRUCTURE EVENTHEAD,0
	ULONG	EVENTH_STATUS		;status of entry.
	DOUBLE	EVENTH_STARTPOS		;startpos of script.
	DOUBLE	EVENTH_ENDPOS
	ULONG	EVENTH_res0
	ULONG	EVENTH_GROUPID		;group this script belongs to.
	ULONG	EVENTH_res1
	LABEL	EVENTH_SIZEOF

; Following this structure you will find a string of the type:
;
;  [(ULONG)Length of string] [String]
;
; which contains the name of the entry. After the string you will
; find a SMPTE stamp:

    STRUCTURE EVENTBODY,0
	STRUCT	EVENTB_SMPTE,S16SMPTE_SIZEOF	;see S16SMPTESTAMP
	LABEL	EVENTB_SIZEOF

; Following this structure you will find 9 string of the type:
;
;  [(ULONG)Length of string] [String]
;
; which contains comand definitions from 1-9. Note that the stringsize may be
; NULL. After those strings you will have to skip 50 bytes reserved space to
; get to the next chunk.

    STRUCTURE EVENTFOOT,0
	STRUCT	EVENTF_res,50
	LABEL	EVENTF_SIZEOF


EVENTSTAT_UNSELECTED	EQU	0
EVENTSTAT_SELECTED	EQU	1

; bit defs

EVENTSTATB_SELECTED	EQU	0

;------------------------------------------------------------------------------
* TRACK 'TRAX' files is similar to 'TLC1' except they don't have a TLC1 header,
* they only have one TYPE chunk followed by either 'SAMP' or 'EVNT' dependent
* on TYPE type. Then SAMP or EVNT chunks follows ended with a END!.
*
* TRAX FILE consists of:
*
* [TRAXID]
* [TYPE]
* [SAMP or EVNT]
* [END!]

;------------------------------------------------------------------------------
* VOLUME AND PAN ENVELOPE FILES (MIXER FILES)

; Volume/Pan env file is a standard IFF file. It consists of the following
; chunks:
;
;  [FORM=SRMX]
;  ['VOL ']
;  ['PAN ']
;  ['CHAN']
;
; There are ten channels in a file (atleast on a singlecard system), eight are
; play channels, while one is input channel and one is output channel.

; 'VOL ' CHUNK consists of
;
;  [ Time         ]
;  [ (Vol+100)*32 ]
;
; These are repeated x number of times. Only changes are recorded.
; The size will always be dividable with eight.

    STRUCTURE SRMXVOL,0
	ULONG	SVOL_POSITION
	ULONG	SVOL_VOLUME
	LABEL	SVOL_SIZEOF

; 'PAN ' CHUNK consists of
;
;  [ Time   ]
;  [ Pan*32 ]
;
; These are repeated x number of times. Only changes are recorded.
; The size will always be dividable with eight.

    STRUCTURE SRMXPAN,0
	ULONG	SPAN_POSITION
	ULONG	SPAN_PAN
	LABEL	SPAN_SIZEOF

; 'CHAN' CHUNK consists of
;
; [CHANID]
; [unknown]
; [PREFS]
; [RESERVED]

    STRUCTURE SRMXCHAN,0
	UWORD	SCHAN_CARDID	;Card ID, count from 0-3
	UWORD	SCHAN_CHANID	;channel ID. (physical channel)
	ULONG	SCHAN_STATUS	;(unknown=always seem to be -1).
	UBYTE	SCHAN_VOLMIDICH	;MIDI channel for volumes.
	UBYTE	SCHAN_VOLCTRLID	;volume (MIDI) controller ID (def.=7).
	UBYTE	SCHAN_PANMIDCH	;midi channel for pan.
	UBYTE	SCHAN_PANCTRLID	;pan (MIDI) controller ID    (def.=10).
	UWORD	SCHAN_GROUPTYPE	;fader connections.
	UWORD	SCHAN_res1
	LABEL	SCHAN_SIZEOF	;=16 bytes.

SRMX_TIME	=	$100	;256 steps per second, position 10s = $A00
				;second 0 to 1 uses (0-255).

SCHANSTATUS_INIT	=	-1	;init _STATUS with this value

; channel IDs

CHANID_INPUT		=	$0	;IDs used in _CHANID
CHANID_CHAN1		=	$1
CHANID_CHAN2		=	$2
CHANID_CHAN3		=	$3
CHANID_CHAN4		=	$4
CHANID_CHAN5		=	$5
CHANID_CHAN6		=	$6
CHANID_CHAN7		=	$7
CHANID_CHAN8		=	$8
CHANID_OUTPUT		=	$D	;start to count from beg. for next card

; group methode

CHANGROUP_OFF		=	$0
CHANGROUP_ALONG		=	$1
CHANGROUP_AGAINST	=	$2

; bit defs

CHANGROUPB_ALONG	=	0
CHANGROUPB_AGAINST	=	1

;------------------------------------------------------------------------------
* GRAPH FILES for Studio 16 samples
*

; SORRY ! - the graph file analysis didn't make it for this release!

	ENDC	;LIBRARIES_STUDIO16FILE_I
