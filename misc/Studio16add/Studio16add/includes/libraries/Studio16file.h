#ifndef LIBRARIES_STUDIO16FILE_H
#define LIBRARIES_STUDIO16FILE_H

/*
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
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

/* Initializers */

#define	ID_KWK	0x4B574B33	/* S16 sample files. */
#define	ID_TLC	0x544C4331	/* S16 cuelist files. */
#define	ID_TYPE	0x54595045	/* S16 cuelist chunks. */
#define	ID_SAMP	0x53414D50
#define	ID_EVNT	0x45564E54
#define	ID_END	0x454E4421	/* End mark in S16 cuelist files. */
#define	ID_TRAX	0x54524158	/* S16 Cuelist track files. */
#define	ID_SRMX	0x53524D58	/* Volume/Pan envelope files. */
#define	ID_VOL	0x564F4C20	/* SRMX chunks. */
#define	ID_PAN	0x50414E20
#define	ID_CHAN	0x4348414E


#define	S16FILTERINIT	1L	/* use may also use S16S_RATE (S16R_RATE/2). */
#define	S16FLAGINIT	0L	/* init S16S_FLAGS with this value. */


/*  Structure of a SMPTE stamp: */

struct	S16SMPTESTAMP
{
	UBYTE	S16SMPTE_HOURS;	 /* number of hours */
	UBYTE	S16SMPTE_MIN;	 /* number of minuttes. */
	UBYTE	S16SMPTE_SEC;	 /* number of seconds. */
	UBYTE	S16SMPTE_FRAMES; /* number of frames rel. to PAL/NTSC etc. */
}

/* File header structure

   Studio 16 SAMPLEFILE contains:

    [STUDIO16SAMPLE]    SampleClips and Regions inclusive (below)
    [SAMPLEDATA]

  Originally:

    [HEADERID]
    [SAMPLEINFO STRUCT]
    [SAMPLECLIPS x128]
    [REGIONS x32]
    [SAMPLEDATA]

  Sampledata consists of pure signed RAW 16-bit data in Motorola format */

struct	S16SAMPLE,0	/* Studio 16 SAMPLE files. 
{

	ULONG	S16S_ID;	/* FILE HEADER ID (Init with ID_KWK). */

/*  SampleInfo struct: */

	ULONG	S16S_RATE;	/* sample rate in integer. */
	ULONG	S16S_FILTER;	/* Init with S16FILTERINIT or (S16F_RATE). */
	UWORD	S16S_VOLUME;	/* Calculated volume. */
	struct	S16SMPTESTAMP *S16S_SMPTE;	/* SMPTE timecode. */
	FLOAT	S16S_SMPTEFLOAT;	/* SMPTE sampling rate as float. */
	ULONG	S16S_PAN;	/* Calculated pan. */
	ULONG	S16S_FLAGS;	/* (undocumented), init with S16FLAGSINIT. */
	ULONG	S16S_res;	/* Reserved field. */

/*  Related to the sample data: */

	ULONG	S16S_REALSIZE;	/* number of samples (bytesize/2). */
	ULONG	S16S_EDITSIZE;	/* number of samples after editlist. */

/*  here follows a list of SampleClips (see format of sampleclips below) */

	ULONG	S16S_EDITLIST;	/* here starts the SampleClip list. */
	ULONG	S16S_END;	/* init this with REALSIZE-1 if newfile. */

	UBYTE	S16S_SAMPLECLIPLIST[1016]; /* list excl. the one above (=1024) */

/*  Here starts the Region list */

	UBYTE	S16S_REGIONLIST[2624];	/* region list (S16R_SIZEOF x32). */
}


/*  Edit size is calculated by calculating the sum of all SampleClips:

	S16SC_END-S16SC_START+1

 How to determine SampleClip-list end:

 	Add all SampleClips togetter until (S16S_END or S16SC_END) = 0 AND
 	the size you have got equals S16R_EDITSIZE. The reason is that some
 	SampleClip may result in a NULL size since it's included due to non
 	size edits such as volume changes.

  The SampleClip structure is contained in the STUDIO16FILE structure. It is
  repeated 128 times: */

struct	S16SAMPLECLIP
{
	ULONG	S16SC_START;		/* start pos in range. */
	ULONG	S16SC_END;		/* end pos in range. */
}

#define	MAXSAMPLECLIPS	128		/* max number of clips in file. */

/*  Regions are ranges which keep their own settings so you can make a region */
/*  act like a seperate file: */

#define	S16REGIONINIT	0		/* or use S16F_RATE as FLOAT. */
#define	S16REGIONSIZE	82

struct	S16REGION
{
	UBYTE	S16R_NAME[40];		/* name on region. */

/* sampleclip: */

	ULONG	S16R_START;		/* sample start pos. */
	ULONG	S16R_END;		/* sample end pos - size=end-start+1. */

/* sampleinfo: */

	ULONG	S16R_RATE;		/* sample rate. */
	ULONG	S16R_FILTER;		/* Init with $1 (K16FINIT). */
	UWORD	S16R_VOLUME;		/* sample volume. */
	struct	S16SMPTESTAMP *S16R_SMPTE;	/* SMPTE timecode. */
	FLOAT	S16R_SMPTEFLOAT;		/* init with S16REGIONINIT. */
	ULONG	S16R_PAN;		/* pan. */
	ULONG	S16R_FLAGS;		/* misc flags (undocumented). */
	UBYTE	S16R_res[8];		/* reserved space. */
}

#define	MAXREGIONS	32		/* max number of regions in list. */
#define	MAXREGIONNAME	24		/* max number of chars in name - use this */
					/* to be compatible with Studio 16 editor. */

/*  Sample rates for Studio 16: */

#define	S16_FREQ_0	0x1589	/*  5513 hz 				*/
#define	S16_FREQ_1	0x19D7	/*  6615 hz				*/
#define	S16_FREQ_2	0x1F40	/*  8000 hz RA (RealAudio)		*/
#define	S16_FREQ_3	0x2580	/*  9600 hz TELE			*/
#define	S16_FREQ_4	0x2B11	/* 11025 hz				*/
#define	S16_FREQ_5	0x3e80	/* 16000 hz				*/
#define	S16_FREQ_6	0x49D4	/* 18900 hz				*/
#define	S16_FREQ_7	0x5622	/* 22050 hz				*/
#define	S16_FREQ_8	0x6B25	/* 27429 hz				*/
#define	S16_FREQ_9	0x7D00	/* 32000 hz FM, REELS			*/
#define	S16_FREQ_A	0x8133	/* 33075 hz HIBAND ->Betacam/MII/Umatic	*/
#define	S16_FREQ_B	0x93A8	/* 37800 hz				*/
#define	S16_FREQ_C	0xAC44	/* 44100 hz CD				*/
#define	S16_FREQ_D	0xBB80	/* 48000 hz DAT				*/

/*  For convinience only: */

#define	S16_FREQ_RA	S16_FREQ_2
#define	S16_FREQ_TELE	S16_FREQ_3
#define	S16_FREQ_FM	S16_FREQ_9
#define	S16_FREQ_REEL	S16_FREQ_9
#define	S16_FREQ_HIBAND	S16_FREQ_A
#define	S16_FREQ_CD	S16_FREQ_C
#define	S16_FREQ_DAT	S16_FREQ_D

/*  Volumes

 Calc: S16F_VOLUME/S16_VOL_STEPS-100 = x dB
       value = (x dB + 100) x S16_VOL_STEPS */

#define	S16_VOL_0	0x0C80	/*  +0 dB */
#define	S16_VOL_OFF	0x0000	/*  oo dB */

#define	S16_VOL_STEPS	0x0020	/* you may use 1/4th of this step. */

/*  for convinience only: */

#define	S16_VOL_DOUBLE	0x0D40	/*  +6.0 dB (200 % volume). */
#define	S16_VOL_NORMAL	0x0C80	/*  +0.0 dB (100 % volume). */
#define	S16_VOL_HALF	0x0BC0	/*  -6.0 dB ( 50 % volume). */
#define	S16_VOL_QUATER	0x0B00	/* -12.0 dB ( 25 % volume). */
#define	S16_VOL_BACK	0x09C0	/* -22.0 dB (music for voiceover). */

/* Pans

  Calc: S16F_PAN/S16_PAN_STEPS = Pan pos 0-200, 100=center
        value = Pan x S16_PAN_STEPS */

#define	S16_PAN_LEFT	0x0000	/* full left. */
#define	S16_PAN_MID	0x0C80	/* center. */
#define	S16_PAN_RIGHT	0x1900	/* full right. */

#define	S16_PAN_STEPS	0x0020	/* you may use 1/4th of this step. */

/*  for convinience only: */

#define	S16_PAN_LEFT50	0x0640	/* 50% to left. */
#define	S16_PAN_RIGHT50	0x12C0	/* 50% to right. */

/*---------------------------------------------------------------------------
** From 4.0
**---------------------------------------------------------------------------*/

/* NOTE: The strings used below (except _COMMENT) are of the following format:
*
*	ULONG  STRINGLENGTH
*	STRUCT STRING,STRINGLENGTH
*
* In the stucture overview you will find a container marked [-SOMETHING] which
* means this is a string of the above format. */

/* NOTE: All DOUBLE sizes are in seconds. The mantissa is one second's
* resolution, however the resolution can never be greater than the
* frequency (max 1/48000th of a second) in real life. */

/* Cuelist fileformat 'TLC1' -

 A Cuelist file is built like this:

 [TLC1HEADER]
 [TYPE]
 [SAMP/EVNT * n]
 [END mark]
 [TYPE]
 [SAMP/EVNT * n]
 [END mark]
 [TYPE]
 [...and so on...]
 [END mark]
 [END mark]	the double END! mark is end of file
*/


/* TLC1 HEADER consists of:

	[TLCHEAD]
	[-PATH x2]
	[-NAME x2]
	[TLCBODY]
*/

struct	TLCHEAD
{
	ULONG	TLCH_ID;	/* file ID [=TLC1]. */
	ULONG	TLCH_WINLEFT;	/* window position/sizes when saved. Will */
	ULONG	TLCH_WINTOP;	/* become the zip size when loaded. */
	ULONG	TLCH_WINHEIGHT;	/* minimum 90. */
	ULONG	TLCH_WINWIDTH;	/* minimum 377. */
}

#define	TLCMINWINWIDTH		377L
#define	TLCMINWINHEIGHT		90L

/* then there follows four strings in this format:

  [(ULONG)Length of string] [String]

 - The first string is 'Track' path
 - The second string is 'Cuelist' path
 - The third string is 'Trackname'
 - The fourth string is 'Cuelistfilename'
*/

struct	TLCBODY
{

/*  preferences */

	UBYTE	TLCB_res0[6];		/* <unknown settings - ignored>. */
	UBYTE	TLCB_FADEINTYPE;	/* See SAMPBODY for different types. */
	UBYTE	TLCB_FADEOUTTYPE;
	DOUBLE	TLCB_MAXTIME;		/* use f.ex. ieeedoubbas.library. */
	DOUBLE	TLCB_GRIDSPACING;
	DOUBLE	TLCB_STARTTIME;		/* start of cuelist */
	ULONG	TLCB_TOTALLENGTH;	/* in seconds*100 */
	ULONG	TLCB_VIEWSIZE;		/* when saved (sec*100) */
	ULONG	TLCB_VIEWSTART;		/* (sec*100) */
	ULONG	TLCB_BPM;		/* Beats Per Minutes. */
	ULONG	TLCB_BPMX;		/* BPM X/Y (f.ex 4/4). */
	ULONG	TLCB_BPMY;
	ULONG	TLCB_TIMEOPTIONS;	/* what timer is used (SMPTE/CLK/BPM). */
	UBYTE	TLCB_res1[122];

/*  Flag markers */

	DOUBLE	TLCB_F1POS;		/* position of mark (-1=not used). */
	LONG	TLCB_F1VIEWPOS;		/* If -1 then the flag is not in view.
					   else, start of view in sec*100
					   you may ignore this value. */
	UBYTE	TLCB_F1COMMENT[80];	/* Comment including NULL termination. */
	UBYTE	TLCB_f1reserved[30];	/* Reserved for ASCII representation, */
					/* but isn't implemented officially. */

	DOUBLE	TLCB_F2POS;
	LONG	TLCB_F2VIEWPOS;
	UBYTE	TLCB_F2COMMENT[80];
	UBYTE	TLCB_f2reserved[30];

	DOUBLE	TLCB_F3POS;
	LONG	TLCB_F3VIEWPOS;
	UBYTE	TLCB_F3COMMENT[80];
	UBYTE	TLCB_f3reserved[30];

	DOUBLE	TLCB_F4POS;
	LONG	TLCB_F4VIEWPOS;
	UBYTE	TLCB_F4COMMENT[80];
	UBYTE	TLCB_f4reserved[30];

	DOUBLE	TLCB_F5POS;
	LONG	TLCB_F5VIEWPOS;
	UBYTE	TLCB_F5COMMENT[80];
	UBYTE	TLCB_f5reserved[30];

	DOUBLE	TLCB_F6POS;
	LONG	TLCB_F6VIEWPOS;
	UBYTE	TLCB_F6COMMENT[80];
	UBYTE	TLCB_f6reserved[30];

	DOUBLE	TLCB_F7POS;
	LONG	TLCB_F7VIEWPOS;
	UBYTE	TLCB_F7COMMENT[80];
	UBYTE	TLCB_f7reserved[30];

	DOUBLE	TLCB_F8POS;
	LONG	TLCB_F8VIEWPOS;
	UBYTE	TLCB_F8COMMENT[80];
	UBYTE	TLCB_f8reserved[30];

	DOUBLE	TLCB_F9POS;
	LONG	TLCB_F9VIEWPOS;
	UBYTE	TLCB_F9COMMENT[80];
	UBYTE	TLCB_f9reserved[30];

	DOUBLE	TLCB_F10POS;
	LONG	TLCB_F10VIEWPOS;
	UBYTE	TLCB_F10COMMENT[80];
	UBYTE	TLCB_f10reserved[30];

	DOUBLE	TLCB_LOCATEPOS;		/* red location mark. */
	LONG	TLCB_LOCATEVIEWPOS;
	UBYTE	TLCB_LOCATECOMMENT[80];
	UBYTE	TLCB_LOCATEASCII[30];	/* ASCII representation of location mark */
					/* only mark which has support for this. */
					/* Note that the ascii also reflects */
					/* which time mode is used (SMPTE/BPM..). */

	DOUBLE	TLCB_STARTPOS;		/* blue start mark. */
	LONG	TLCB_STARTVIEWPOS;
	UBYTE	TLCB_STARTCOMMENT[80];
	UBYTE	TLCB_startreserved[30];	/* reserved. */

	DOUBLE	TLCB_PUNCHINPOS;	/* yellow punch-in mark. */
	LONG	TLCB_PUNCHINVIEWPOS;
	UBYTE	TLCB_PUNCHINCOMMENT[80];
	UBYTE	TLCB_punchinreserved[30];

	DOUBLE	TLCB_PUNCHOUTPOS;	/* yellow punch-out mark. */
	LONG	TLCB_PUNCHOUTVIEWPOS;
	UBYTE	TLCB_PUNCHOUTCOMMENT[80];
	UBYTE	TLCB_punchoutreserved[30];

	UBYTE	TLCB_res2[100];		/* reserved. */

}

/*  Timer options: */

#define	TLCTIME_HOURMINUTESECOND	0x00
#define	TLCTIME_SMPTE			0x01
#define	TLCTIME_BPM			0x02
#define	TLCTIME_SMPTEPLUS		0x04

#define	TLCMARK_NOTINUSE		-1	/* Mark isn't used. */
#define	TLCMARK_OUTSIDE			-1	/* Mark is not in view. */

/*  Bit defs */

#define	TLCTIMEB_SMPTE			0
#define	TLCTIMEB_BPM			1
#define	TLCTIMEB_SMPTEPLUS		2


/*  The 'TYPE' chunk can be two types: "Audio" or "AREXX". The Type describes
*  each track in the cuelist.
* 
*  You first need to check which type of track this is and then
*  use the structure for the tracktype.
* 
*  To determine the track type you must first read the first
*  string:
* 
*   [(ULONG)Length of string] [String]
* 
*  This can be either "Audio" or "AREXX".
* 
*  You must then read the next string in the same format to get the track name.
*  This applies to both types.
* 
*  If the type="AREXX" then you must read an additional string to get the port
*  name.
*/

/*  TYPE CHUNK consists of:
* 
*  Common:
* 	[-TYPE OF TRACK STRING]
* 	[-NAME OF TRACK]
* 
*  Audio:
* 	[TYPEAUDIO]
* 	[-PLAY CHANNEL]
* 	[-REC CHANNEL]
* 	[TYPEAUDIOFOOT]
* 
*  AREXX:
* 	[-NAME OF PORT]
* 	[TYPEAREXX]
*/

/*  "Audio" TRACK - */

struct	TYPEAUDIO
{
	DOUBLE	TYPA_RATE;	/* this track's frequency. */
	UBYTE	TYPA_USELPREFS;	/* prefs when entries are unselected. */
	UBYTE	TYPA_SELPREFS;	/* prefs when entries are selected. */
	UBYTE	TYPA_TRACKPREFS;	/* prefs for track status. */
	UBYTE	TYPA_ENTRIES;	/* if track contains (un)selected entries. */
}

/*  For type there are two more strings right after this structure you must read.
*  The first string is name on the play channel, the second is the name of the
*  record channel. Note that some types of channel (like 'Any') gets prefixed by
*  what card is used (f.ex. "AD516.Any").
* 
*  After the two strings there is reserved 100 bytes which you must skip to get
*  the next chunk.
*/

struct	TYPEAUDIOFOOT
{
	UBYTE	TYPAF_res[100];
}


/*  "AREXX" TRACK - */

struct	TYPEAREXX
{
	UWORD	TYPR_res0;
	UBYTE	TYPR_TRACKPREFS;
	UBYTE	TYPR_pad0;
	UBYTE	TYPR_res1[100];
}


/*  flags for track preferences: */

#define	TYPAPREF_SHOWREGIONNAME		0x01
#define	TYPAPREF_SHOWSTARTTIME		0x02
#define	TYPAPREF_SHOWSAMPLESIZE		0x04
#define	TYPAPREF_SHOWFADETIME		0x08

/*  for both track types (Audio/AREXX): */

#define	TYPTRACK_SOUNDBUTTONON		0x01
#define	TYPTRACK_SOLOBUTTONON		0x02
#define	TYPTRACK_TRACKSELECTED		0x04

/*  entries' status in track (global for one track): */

#define	TYPTRACK_ENTRIESUNSELECTED	0x00
#define	TYPTRACK_ENTRIESSELECTED	0x02

/*  bit defs: */

#define	TYPAPREFB_SHOWREGIONNAME	0	/* OR togetter to set more */
#define	TYPAPREFB_SHOWSTARTTIME		1	/* options at the same time. */
#define	TYPAPREFB_SHOWSAMPLESIZE	2
#define	TYPAPREFB_SHOWFADETIME		3

#define	TYPTRACKB_SOUNDBUTTONON		0
#define	TYPTRACKB_SOLOBUTTONON		1
#define	TYPTRACKB_TRACKSELECTED		2

#define	TYPTRACKB_ENTRIESSELECTED	1


/*  The 'SAMP' chunk contains data of each entries on an 'Audio' type of track.
*  You can find volume, pan, position, sizes, fades and so on.
*/

/*  SAMP -
* 
*  SAMP CHUNK consist of:
* 
* 	[SAMPHEAD]
* 	[-SAMPLE PATH/NAME]
* 	[SAMPBODY]
*/

struct	SAMPHEAD
{
	ULONG	SAMPH_STATUS;	/* status of entry. */
	DOUBLE	SAMPH_STARTPOS;	/* startposition of entry in sec. */
	DOUBLE	SAMPH_ENDPOS;
	ULONG	SAMPH_res0;
	ULONG	SAMPH_GROUPID;	/* Group this entry belongs to (null=none). */
}

/* Right after this structure you will find a string of the type:
* 
*   [(ULONG)Length of string] [String]
* 
*  which contains path and sample name. Then the chunk continues with
*  this structure:
*/

struct	SAMPBODY
{
	WORD	SAMPB_res0;
	UBYTE	SAMPB_FADEINTYPE;	/* what fadetype is used for intro. */
	UBYTE	SAMPB_FADEOUTTYPE;
	DOUBLE	SAMPB_FADEINTIME;	/* fade time 0=none. */
	DOUBLE	SAMPB_FADEOUTTIME;
	ULONG	SAMPB_CROPIN;	        /* Sample start (rel. to pos) in */
	ULONG	SAMPB_CROPOUT;		/* number of samples */
	UWORD	SAMPB_VOLUME;		/* see S16S_VOL_... */
	ULONG	SAMPB_PAN;		/* see S16S_PAN_... */
	UBYTE	SAMPB_res1[50];		/* 50 bytes reserved. */
}

/*  flags for sample entry status: */

#define	SAMPSTAT_NOEXIST	0x00
#define	SAMPSTAT_NOEXISTSEL	0x01
#define	SAMPSTAT_OK		0x02
#define	SAMPSTAT_OKSEL		0x03

/*  flags for fade types: */

#define	FADE_LINEAR		0x00	/* linear fade. */
#define	FADE_BUTT		0x01	/* no fade. */
#define	FADE_LOGA		0x02	/* logaritmic fade. */
#define	FADE_EXPO		0x04	/* exponential fade. */

/*  bit defs */

#define	SAMPSTATB_SELECTED	0	/* sample is selected. */
#define	SAMPSTATB_OK		1	/* sample exists. */

#define	FADEB_BUTT		0
#define	FADEB_LOGA		1
#define	FADEB_EXPO		2

/*  The 'EVNT' chunk is for "AREXX" type of tracks. It contains
*  mostly strings for the comands you specify.
*/

/*  EVNT -
* 
*  ENVT CHUNK consists of
* 
* 	[EVENTHEAD]
* 	[-ENTRYNAME]
* 	[EVENTBODY]
* 	[-COMANDS x9]
* 	[EVENTFOOT]
*/

struct	EVENTHEAD
{
	ULONG	EVENTH_STATUS;		/* status of entry. */
	DOUBLE	EVENTH_STARTPOS;	/* startpos of script. */
	DOUBLE	EVENTH_ENDPOS;
	ULONG	EVENTH_res0;
	ULONG	EVENTH_GROUPID;		/* group this script belongs to. */
	ULONG	EVENTH_res1;
}

/*  Following this structure you will find a string of the type:
* 
*   [(ULONG)Length of string] [String]
* 
*  which contains the name of the entry. After the string you will
*  find a SMPTE stamp:
*/

struct	EVENTBODY
{
	struct	S16SMPTESTAMP *EVENTB_SMPTE;	/* see S16SMPTESTAMP */
}

/*  Following this structure you will find 9 string of the type:
* 
*   [(ULONG)Length of string] [String]
* 
*  which contains comand definitions from 1-9. Note that the stringsize may be
*  NULL. After those strings you will have to skip 50 bytes reserved space to
*  get to the next chunk.
*/

struct	EVENTFOOT
{
	UBYTE	EVENTF_res[50];
}


#define	EVENTSTAT_UNSELECTED	0
#define	EVENTSTAT_SELECTED	1

/*  bit defs */

#define	TSTATB_SELECTED		0

/* ------------------------------------------------------------------------------
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
*/

/* ------------------------------------------------------------------------------
* VOLUME AND PAN ENVELOPE FILES (MIXER FILES)
*/

/*  Volume/Pan env file is a standard IFF file. It consists of the following
*  chunks:
* 
*   [FORM=SRMX]
*   ['VOL ']
*   ['PAN ']
*   ['CHAN']
* 
*  There are ten channels in a file (atleast on a singlecard system), eight are
*  play channels, while one is input channel and one is output channel.
*/

/*  'VOL ' CHUNK consists of
* 
*   [ Time         ]
*   [ (Vol+100)*32 ]
* 
*  These are repeated x number of times. Only changes are recorded.
*  The size will always be dividable with eight.
*/

struct	SRMXVOL
{
	ULONG	SVOL_POSITION;
	ULONG	SVOL_VOLUME;
}

/*  'PAN ' CHUNK consists of
* 
*   [ Time   ]
*   [ Pan*32 ]
* 
*  These are repeated x number of times. Only changes are recorded.
*  The size will always be dividable with eight.
*/

struct	SRMXPAN
{
	ULONG	SPAN_POSITION;
	ULONG	SPAN_PAN;
}

/*  'CHAN' CHUNK consists of
* 
*  [CHANID]
*  [unknown]
*  [PREFS]
*  [RESERVED]
*/

struct	SRMXCHAN
{
	UWORD	SCHAN_CARDID;	/* Card ID, count from 0-3 */
	UWORD	SCHAN_CHANID;	/* channel ID. */
	ULONG	SCHAN_STATUS;	/* (unknown=always seem to be -1). */
	UBYTE	SCHAN_VOLMIDICH; /* MIDI channel for volumes. */
	UBYTE	SCHAN_VOLCTRLID; /* volume (MIDI) controller  ID (def.=7). */
	UBYTE	SCHAN_PANMIDCH;	/* midi channel for pan. */
	UBYTE	SCHAN_PANCTRLID; /* pan (MIDI) controller ID  (def.=10). */
	UWORD	SCHAN_GROUPTYPE; /* fader connections. */
	UWORD	SCHAN_res1;
}

#define	SRMX_TIME	0x0100	/* 256 steps per second, position 10s = $A00 */
				/* second 0 to 1 uses (0-255). */

#define	SCHANSTATUS_INIT -1L	/* init _STATUS with this value */

/*  channel IDs */

#define	CHANID_INPUT		0x0000 /* IDs used in _CHANID */
#define	CHANID_CHAN1		0x0001
#define	CHANID_CHAN2		0x0002
#define	CHANID_CHAN3		0x0003
#define	CHANID_CHAN4		0x0004
#define	CHANID_CHAN5		0x0005
#define	CHANID_CHAN6		0x0006
#define	CHANID_CHAN7		0x0007
#define	CHANID_CHAN8		0x0008
#define	CHANID_OUTPUT		0x000D

/*  group methode */

#define	CHANGROUP_OFF		0x00
#define	CHANGROUP_ALONG		0x01
#define	CHANGROUP_AGAINST	0x02

/*  bit defs */

#define	CHANGROUPB_ALONG	0
#define	CHANGROUPB_AGAINST	1

/* ------------------------------------------------------------------------------
* GRAPH FILES for Studio 16 samples
*/

/*  SORRY ! - the graph file analysis didn't make it for this release! */

#endif /* LIBRARIES_STUDIO16FILE_H */
