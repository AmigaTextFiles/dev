/* $Filename: libraries/reqtools.h $Release: 2.5 $Revision: 38.13 $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/lists', 'target/exec/libraries', 'target/exec/semaphores', 'target/libraries/dos', 'target/libraries/dosextens', 'target/libraries/diskfont', 'target/graphics/text', 'target/utility/tagitem'
MODULE 'target/intuition/intuitionbase', 'target/graphics/gfxbase', 'target/utility/hooks'
{#include <libraries/reqtools.h>}
NATIVE {LIBRARIES_REQTOOLS_H} CONST

NATIVE {REQTOOLSNAME}		 CONST 
#define REQTOOLSNAME reqtoolsname
STATIC reqtoolsname		 = 'reqtools.library'

NATIVE {REQTOOLSVERSION}		 CONST REQTOOLSVERSION		 = 38

/***********************
*                      *
*     Preferences      *
*                      *
***********************/

NATIVE {RTPREF_FILEREQ}		 CONST RTPREF_FILEREQ		 = 0
NATIVE {RTPREF_FONTREQ}		 CONST RTPREF_FONTREQ		 = 1
NATIVE {RTPREF_PALETTEREQ}	 CONST RTPREF_PALETTEREQ	 = 2
NATIVE {RTPREF_SCREENMODEREQ}	 CONST RTPREF_SCREENMODEREQ	 = 3
NATIVE {RTPREF_VOLUMEREQ}	 CONST RTPREF_VOLUMEREQ	 = 4
NATIVE {RTPREF_OTHERREQ}		 CONST RTPREF_OTHERREQ		 = 5
NATIVE {RTPREF_NR_OF_REQ}	 CONST RTPREF_NR_OF_REQ	 = 6

NATIVE {ReqDefaults} OBJECT reqdefaults
   {Size}	size	:ULONG
   {ReqPos}	reqpos	:ULONG
   {LeftOffset}	leftoffset	:UINT
   {TopOffset}	topoffset	:UINT
	{MinEntries}	minentries	:UINT
	{MaxEntries}	maxentries	:UINT
   ENDOBJECT

NATIVE {ReqToolsPrefs} OBJECT reqtoolsprefs
   /* Size of preferences (_without_ this field and the semaphore) */
   {PrefsSize}	prefssize	:ULONG
   {PrefsSemaphore}	prefssemaphore	:ss
   /* Start of real preferences */
   {Flags}	flags	:ULONG
   {ReqDefaults}	reqdefaults[RTPREF_NR_OF_REQ]	:ARRAY OF reqdefaults
   ENDOBJECT

NATIVE {RTPREFS_SIZE} CONST RTPREFS_SIZE = $64	->SIZEOF reqtoolsprefs - SIZEOF signalsemaphore - 4

/* Flags */

NATIVE {RTPRB_DIRSFIRST}		 CONST RTPRB_DIRSFIRST		 = 0
NATIVE {RTPRF_DIRSFIRST}		 CONST RTPRF_DIRSFIRST		 = (1 SHL RTPRB_DIRSFIRST)
NATIVE {RTPRB_DIRSMIXED}		 CONST RTPRB_DIRSMIXED		 = 1
NATIVE {RTPRF_DIRSMIXED}		 CONST RTPRF_DIRSMIXED		 = (1 SHL RTPRB_DIRSMIXED)
NATIVE {RTPRB_IMMSORT}		 CONST RTPRB_IMMSORT		 = 2
NATIVE {RTPRF_IMMSORT}		 CONST RTPRF_IMMSORT		 = (1 SHL RTPRB_IMMSORT)
NATIVE {RTPRB_NOSCRTOFRONT}	 CONST RTPRB_NOSCRTOFRONT	 = 3
NATIVE {RTPRF_NOSCRTOFRONT}	 CONST RTPRF_NOSCRTOFRONT	 = (1 SHL RTPRB_NOSCRTOFRONT)
NATIVE {RTPRB_NOLED}		 CONST RTPRB_NOLED		 = 4
NATIVE {RTPRF_NOLED}		 CONST RTPRF_NOLED		 = (1 SHL RTPRB_NOLED)
NATIVE {RTPRB_DEFAULTFONT}	 CONST RTPRB_DEFAULTFONT	 = 5
NATIVE {RTPRF_DEFAULTFONT}	 CONST RTPRF_DEFAULTFONT	 = (1 SHL RTPRB_DEFAULTFONT)
NATIVE {RTPRB_DOWHEEL}		 CONST RTPRB_DOWHEEL		 = 6
NATIVE {RTPRF_DOWHEEL}		 CONST RTPRF_DOWHEEL		 = (1 SHL RTPRB_DOWHEEL)
NATIVE {RTPRB_FKEYS}		 CONST RTPRB_FKEYS		 = 7
NATIVE {RTPRF_FKEYS}		 CONST RTPRF_FKEYS		 = (1 SHL RTPRB_FKEYS)
NATIVE {RTPRB_FANCYWHEEL}	 CONST RTPRB_FANCYWHEEL	 = 8
NATIVE {RTPRF_FANCYWHEEL}	 CONST RTPRF_FANCYWHEEL	 = (1 SHL RTPRB_FANCYWHEEL)
NATIVE {RTPRB_MMBPARENT}		 CONST RTPRB_MMBPARENT		 = 9
NATIVE {RTPRF_MMBPARENT}		 CONST RTPRF_MMBPARENT		 = (1 SHL RTPRB_MMBPARENT)

/***********************
*                      *
*     Library Base     *
*                      *
***********************/

NATIVE {ReqToolsBase} OBJECT reqtoolsbase
   {LibNode}	lib	:lib
   {RTFlags}	rtflags	:UBYTE
   {pad}	pad[3]	:ARRAY OF UBYTE
   {SegList}	seglist	:BPTR

   /* PUBLIC FIELDS */

   /* NOTE: Some versions of the Manx C compiler contain a bug so it gets
            confused by the library bases below.  Add the rt_ prefix to the
            library names to fix the problem (e.g. rt_IntuitionBase). */

   /* The following library bases may be read and used by your program */
   {IntuitionBase}	intuitionbase	:PTR TO intuitionbase
   {GfxBase}	gfxbase	:PTR TO gfxbase
   {DOSBase}	dosbase	:PTR TO doslibrary
   /* Next two library bases are only (and always) valid on Kickstart 2.0!
      (1.3 version of reqtools also initializes these when run on 2.0) */
   {GadToolsBase}	gadtoolsbase	:PTR TO lib
   {UtilityBase}	utilitybase	:PTR TO lib

   /* PRIVATE FIELDS, THESE WILL CHANGE FROM RELEASE TO RELEASE! */

   /* The RealOpenCnt is for the buffered AvailFonts feature.  Since
      Kickstart 3.0 offers low memory handlers a release of ReqTools for 3.0
      will not use this field and start using the normal OpenCnt again. */
   {RealOpenCnt}	realopencnt	:UINT
   {AvailFontsLock}	availfontslock	:UINT
   {AvailFontsHeader}	availfontsheader	:PTR TO afh
   {FontsAssignType}	fontsassigntype	:ULONG
   {FontsAssignLock}	fontsassignlock	:BPTR
   {FontsAssignList}	fontsassignlist	:PTR TO assignlist
   {ReqToolsPrefs}	reqtoolsprefs	:reqtoolsprefs
   {prefspad}	prefspad	:UINT
   ENDOBJECT

/* types of requesters, for rtAllocRequestA() */
NATIVE {RT_FILEREQ}		 CONST RT_FILEREQ		 = 0
NATIVE {RT_REQINFO}		 CONST RT_REQINFO		 = 1
NATIVE {RT_FONTREQ}		 CONST RT_FONTREQ		 = 2
/* (V38) */
NATIVE {RT_SCREENMODEREQ}	 CONST RT_SCREENMODEREQ	 = 3

/***********************
*                      *
*    File requester    *
*                      *
***********************/

/* structure _MUST_ be allocated with rtAllocRequest() */

NATIVE {rtFileRequester} OBJECT rtfilerequester
   {ReqPos}	reqpos	:ULONG
   {LeftOffset}	leftoffset	:UINT
   {TopOffset}	topoffset	:UINT
   {Flags}	flags	:ULONG
   /* OBSOLETE IN V38! DON'T USE! */ {Hook}	private1	:PTR TO hook
   /* */
   {Dir}	dir	:ARRAY OF CHAR		     /* READ ONLY! Change with rtChangeReqAttrA()! */
   {MatchPat}	matchpat	:ARRAY OF CHAR	     /* READ ONLY! Change with rtChangeReqAttrA()! */
   /* */
   {DefaultFont}	defaultfont	:PTR TO textfont
   {WaitPointer}	waitpointer	:ULONG
   /* (V38) */
   {LockWindow}	lockwindow	:ULONG
   {ShareIDCMP}	shareidcmp	:ULONG
   {IntuiMsgFunc}	intuimsgfunc	:PTR TO hook
   {reserved1}	reserved1	:UINT
   {reserved2}	reserved2	:UINT
   {reserved3}	reserved3	:UINT
   {ReqHeight}	reqheight	:UINT	     /* READ ONLY!  Use RTFI_Height tag! */
   /* Private data follows! HANDS OFF :-) */
   ENDOBJECT

/* returned by rtFileRequestA() if multiselect is enabled,
   free list with rtFreeFileList() */

NATIVE {rtFileList} OBJECT rtfilelist
   {Next}	next	:PTR TO rtfilelist
   {StrLen}	strlen	:ULONG	     /* -1 for directories */
   {Name}	name	:ARRAY OF CHAR
   ENDOBJECT

/* structure passed to RTFI_FilterFunc callback hook by
   volume requester (see RTFI_VolumeRequest tag) */

NATIVE {rtVolumeEntry} OBJECT rtvolumeentry
   {Type}	type	:ULONG		     /* DLT_DEVICE or DLT_DIRECTORY */
   {Name}	name	:ARRAY OF CHAR
   ENDOBJECT

/***********************
*                      *
*    Font requester    *
*                      *
***********************/

/* structure _MUST_ be allocated with rtAllocRequest() */

NATIVE {rtFontRequester} OBJECT rtfontrequester
   {ReqPos}	reqpos	:ULONG
   {LeftOffset}	leftoffset	:UINT
   {TopOffset}	topoffset	:UINT
   {Flags}	flags	:ULONG
   /* OBSOLETE IN V38! DON'T USE! */ {Hook}	private1	:PTR TO hook
   /* */
   {Attr}	attr	:textattr	 /* READ ONLY! */
   /* */
   {DefaultFont}	defaultfont	:PTR TO textfont
   {WaitPointer}	waitpointer	:ULONG
   /* (V38) */
   {LockWindow}	lockwindow	:ULONG
   {ShareIDCMP}	shareidcmp	:ULONG
   {IntuiMsgFunc}	intuimsgfunc	:PTR TO hook
   {reserved1}	reserved1	:UINT
   {reserved2}	reserved2	:UINT
   {reserved3}	reserved3	:UINT
   {ReqHeight}	reqheight	:UINT		 /* READ ONLY!  Use RTFO_Height tag! */
   /* Private data follows! HANDS OFF :-) */
   ENDOBJECT

/*************************
*                        *
*  ScreenMode requester  *
*                        *
*************************/

/* structure _MUST_ be allocated with rtAllocRequest() */

NATIVE {rtScreenModeRequester} OBJECT rtscreenmoderequester
   {ReqPos}	reqpos	:ULONG
   {LeftOffset}	leftoffset	:UINT
   {TopOffset}	topoffset	:UINT
   {Flags}	flags	:ULONG
   {private1}	private1	:ULONG
   /* */
   {DisplayID}	displayid	:ULONG		 /* READ ONLY! */
   {DisplayWidth}	displaywidth	:UINT		 /* READ ONLY! */
   {DisplayHeight}	displayheight	:UINT		 /* READ ONLY! */
   /* */
   {DefaultFont}	defaultfont	:PTR TO textfont
   {WaitPointer}	waitpointer	:ULONG
   {LockWindow}	lockwindow	:ULONG
   {ShareIDCMP}	shareidcmp	:ULONG
   {IntuiMsgFunc}	intuimsgfunc	:PTR TO hook
   {reserved1}	reserved1	:UINT
   {reserved2}	reserved2	:UINT
   {reserved3}	reserved3	:UINT
   {ReqHeight}	reqheight	:UINT		 /* READ ONLY!  Use RTSC_Height tag! */
   /* */
   {DisplayDepth}	displaydepth	:UINT		 /* READ ONLY! */
   {OverscanType}	overscantype	:UINT		 /* READ ONLY! */
   {AutoScroll}	autoscroll	:ULONG		 /* READ ONLY! */
   /* Private data follows! HANDS OFF :-) */
   ENDOBJECT

/***********************
*                      *
*    Requester Info    *
*                      *
***********************/

/* for rtEZRequestA(), rtGetLongA(), rtGetStringA() and rtPaletteRequestA(),
   _MUST_ be allocated with rtAllocRequest() */

NATIVE {rtReqInfo} OBJECT rtreqinfo
   {ReqPos}	reqpos	:ULONG
   {LeftOffset}	leftoffset	:UINT
   {TopOffset}	topoffset	:UINT
   {Width}	width	:ULONG			 /* not for rtEZRequestA() */
   {ReqTitle}	reqtitle	:ARRAY OF CHAR		 /* currently only for rtEZRequestA() */
   {Flags}	flags	:ULONG
   {DefaultFont}	defaultfont	:PTR TO textfont /* currently only for rtPaletteRequestA() */
   {WaitPointer}	waitpointer	:ULONG
   /* (V38) */
   {LockWindow}	lockwindow	:ULONG
   {ShareIDCMP}	shareidcmp	:ULONG
   {IntuiMsgFunc}	intuimsgfunc	:PTR TO hook
   /* structure may be extended in future */
   ENDOBJECT

/***********************
*                      *
*     Handler Info     *
*                      *
***********************/

/* for rtReqHandlerA(), will be allocated for you when you use
   the RT_ReqHandler tag, never try to allocate this yourself! */

NATIVE {rtHandlerInfo} OBJECT rthandlerinfo
   {WaitMask}	waitmask	:ULONG
   {DoNotWait}	donotwait	:ULONG
   /* Private data follows, HANDS OFF :-) */
->   {private1}	private1	:ULONG
   ENDOBJECT

/* possible return codes from rtReqHandlerA() */

NATIVE {CALL_HANDLER}		 CONST CALL_HANDLER		 = $80000000


/*************************************
*                                    *
*                TAGS                *
*                                    *
*************************************/

NATIVE {RT_TagBase}		 CONST RT_TAGBASE		 = TAG_USER

/*** tags understood by most requester functions ***
*/
/* optional pointer to window */
NATIVE {RT_Window}		 CONST RT_WINDOW		 = (RT_TAGBASE+1)
/* idcmp flags requester should abort on (useful for IDCMP_DISKINSERTED) */
NATIVE {RT_IDCMPFlags}		 CONST RT_IDCMPFLAGS		 = (RT_TAGBASE+2)
/* position of requester window (see below) - default REQPOS_POINTER */
NATIVE {RT_ReqPos}		 CONST RT_REQPOS		 = (RT_TAGBASE+3)
/* leftedge offset of requester relative to position specified by RT_ReqPos */
NATIVE {RT_LeftOffset}		 CONST RT_LEFTOFFSET		 = (RT_TAGBASE+4)
/* topedge offset of requester relative to position specified by RT_ReqPos */
NATIVE {RT_TopOffset}		 CONST RT_TOPOFFSET		 = (RT_TAGBASE+5)
/* name of public screen to put requester on (Kickstart 2.0 only!) */
NATIVE {RT_PubScrName}		 CONST RT_PUBSCRNAME		 = (RT_TAGBASE+6)
/* address of screen to put requester on */
NATIVE {RT_Screen}		 CONST RT_SCREEN		 = (RT_TAGBASE+7)
/* tagdata must hold the address of (!) an APTR variable */
NATIVE {RT_ReqHandler}		 CONST RT_REQHANDLER		 = (RT_TAGBASE+8)
/* font to use when screen font is rejected, _MUST_ be fixed-width font!
   (struct TextFont *, not struct TextAttr *!)
   - default GfxBase->DefaultFont */
NATIVE {RT_DefaultFont}		 CONST RT_DEFAULTFONT		 = (RT_TAGBASE+9)
/* boolean to set the standard wait pointer in window - default FALSE */
NATIVE {RT_WaitPointer}		 CONST RT_WAITPOINTER		 = (RT_TAGBASE+10)
/* (V38) char preceding keyboard shortcut characters (will be underlined) */
NATIVE {RT_Underscore}		 CONST RT_UNDERSCORE		 = (RT_TAGBASE+11)
/* (V38) share IDCMP port with window - default FALSE */
NATIVE {RT_ShareIDCMP}		 CONST RT_SHAREIDCMP		 = (RT_TAGBASE+12)
/* (V38) lock window and set standard wait pointer - default FALSE */
NATIVE {RT_LockWindow}		 CONST RT_LOCKWINDOW		 = (RT_TAGBASE+13)
/* (V38) boolean to make requester's screen pop to front - default TRUE */
NATIVE {RT_ScreenToFront}	 CONST RT_SCREENTOFRONT	 = (RT_TAGBASE+14)
/* (V38) Requester should use this font - default: screen font */
NATIVE {RT_TextAttr}		 CONST RT_TEXTATTR		 = (RT_TAGBASE+15)
/* (V38) call this hook for every IDCMP message not for requester */
NATIVE {RT_IntuiMsgFunc}		 CONST RT_INTUIMSGFUNC		 = (RT_TAGBASE+16)
/* (V38) Locale ReqTools should use for text */
NATIVE {RT_Locale}		 CONST RT_LOCALE		 = (RT_TAGBASE+17)

/*** tags specific to rtEZRequestA ***
*/
/* title of requester window - english default "Request" or "Information" */
NATIVE {RTEZ_ReqTitle}		 CONST RTEZ_REQTITLE		 = (RT_TAGBASE+20)
/* (RT_TAGBASE+21) reserved */
/* various flags (see below) */
NATIVE {RTEZ_Flags}		 CONST RTEZ_FLAGS		 = (RT_TAGBASE+22)
/* default response (activated by pressing RETURN) - default TRUE */
NATIVE {RTEZ_DefaultResponse}	 CONST RTEZ_DEFAULTRESPONSE	 = (RT_TAGBASE+23)

/*** tags specific to rtGetLongA ***
*/
/* minimum allowed value - default MININT */
NATIVE {RTGL_Min}		 CONST RTGL_MIN		 = (RT_TAGBASE+30)
/* maximum allowed value - default MAXINT */
NATIVE {RTGL_Max}		 CONST RTGL_MAX		 = (RT_TAGBASE+31)
/* suggested width of requester window (in pixels) */
NATIVE {RTGL_Width}		 CONST RTGL_WIDTH		 = (RT_TAGBASE+32)
/* boolean to show the default value - default TRUE */
NATIVE {RTGL_ShowDefault}	 CONST RTGL_SHOWDEFAULT	 = (RT_TAGBASE+33)
/* (V38) string with possible responses - english default " _Ok |_Cancel" */
NATIVE {RTGL_GadFmt} 		 CONST RTGL_GADFMT 		 = (RT_TAGBASE+34)
/* (V38) optional arguments for RTGL_GadFmt */
NATIVE {RTGL_GadFmtArgs}		 CONST RTGL_GADFMTARGS		 = (RT_TAGBASE+35)
/* (V38) invisible typing - default FALSE */
NATIVE {RTGL_Invisible}		 CONST RTGL_INVISIBLE		 = (RT_TAGBASE+36)
/* (V38) window backfill - default TRUE */
NATIVE {RTGL_BackFill}		 CONST RTGL_BACKFILL		 = (RT_TAGBASE+37)
/* (V38) optional text above gadget */
NATIVE {RTGL_TextFmt}		 CONST RTGL_TEXTFMT		 = (RT_TAGBASE+38)
/* (V38) optional arguments for RTGS_TextFmt */
NATIVE {RTGL_TextFmtArgs}	 CONST RTGL_TEXTFMTARGS	 = (RT_TAGBASE+39)
/* (V38) Center text - default FALSE */
NATIVE {RTGL_CenterText}		 CONST RTGL_CENTERTEXT		 = (RT_TAGBASE+100)
/* (V38) various flags (see below) */
NATIVE {RTGL_Flags}		 CONST RTGL_FLAGS		 = RTEZ_FLAGS

/*** tags specific to rtGetStringA ***
*/
/* suggested width of requester window (in pixels) */
NATIVE {RTGS_Width}		 CONST RTGS_WIDTH		 = RTGL_WIDTH
/* allow empty string to be accepted - default FALSE */
NATIVE {RTGS_AllowEmpty}		 CONST RTGS_ALLOWEMPTY		 = (RT_TAGBASE+80)
/* (V38) string with possible responses - english default " _Ok |_Cancel" */
NATIVE {RTGS_GadFmt} 		 CONST RTGS_GADFMT 		 = RTGL_GADFMT
/* (V38) optional arguments for RTGS_GadFmt */
NATIVE {RTGS_GadFmtArgs}		 CONST RTGS_GADFMTARGS		 = RTGL_GADFMTARGS
/* (V38) invisible typing - default FALSE */
NATIVE {RTGS_Invisible}		 CONST RTGS_INVISIBLE		 = RTGL_INVISIBLE
/* (V38) window backfill - default TRUE */
NATIVE {RTGS_BackFill}		 CONST RTGS_BACKFILL		 = RTGL_BACKFILL
/* (V38) optional text above gadget */
NATIVE {RTGS_TextFmt}		 CONST RTGS_TEXTFMT		 = RTGL_TEXTFMT
/* (V38) optional arguments for RTGS_TextFmt */
NATIVE {RTGS_TextFmtArgs}	 CONST RTGS_TEXTFMTARGS	 = RTGL_TEXTFMTARGS
/* (V38) Center text - default FALSE */
NATIVE {RTGS_CenterText}		 CONST RTGS_CENTERTEXT		 = RTGL_CENTERTEXT
/* (V38) various flags (see below) */
NATIVE {RTGS_Flags}		 CONST RTGS_FLAGS		 = RTEZ_FLAGS

/*** tags specific to rtFileRequestA ***
*/
/* various flags (see below) */
NATIVE {RTFI_Flags}		 CONST RTFI_FLAGS		 = (RT_TAGBASE+40)
/* suggested height of file requester */
NATIVE {RTFI_Height}		 CONST RTFI_HEIGHT		 = (RT_TAGBASE+41)
/* replacement text for 'Ok' gadget (max 6 chars) */
NATIVE {RTFI_OkText}		 CONST RTFI_OKTEXT		 = (RT_TAGBASE+42)
/* (V38) bring up volume requester, tag data holds flags (see below) */
NATIVE {RTFI_VolumeRequest}	 CONST RTFI_VOLUMEREQUEST	 = (RT_TAGBASE+43)
/* (V38) call this hook for every file in the directory */
NATIVE {RTFI_FilterFunc}		 CONST RTFI_FILTERFUNC		 = (RT_TAGBASE+44)
/* (V38) allow empty file to be accepted - default FALSE */
NATIVE {RTFI_AllowEmpty}		 CONST RTFI_ALLOWEMPTY		 = (RT_TAGBASE+45)

/*** tags specific to rtFontRequestA ***
*/
/* various flags (see below) */
NATIVE {RTFO_Flags}		 CONST RTFO_FLAGS		 = RTFI_FLAGS
/* suggested height of font requester */
NATIVE {RTFO_Height}		 CONST RTFO_HEIGHT		 = RTFI_HEIGHT
/* replacement text for 'Ok' gadget (max 6 chars) */
NATIVE {RTFO_OkText}		 CONST RTFO_OKTEXT		 = RTFI_OKTEXT
/* suggested height of font sample display - default 24 */
NATIVE {RTFO_SampleHeight}	 CONST RTFO_SAMPLEHEIGHT	 = (RT_TAGBASE+60)
/* minimum height of font displayed */
NATIVE {RTFO_MinHeight}		 CONST RTFO_MINHEIGHT		 = (RT_TAGBASE+61)
/* maximum height of font displayed */
NATIVE {RTFO_MaxHeight}		 CONST RTFO_MAXHEIGHT		 = (RT_TAGBASE+62)
/* [(RT_TAGBASE+63) to (RT_TAGBASE+66) used below] */
/* (V38) call this hook for every font */
NATIVE {RTFO_FilterFunc}		 CONST RTFO_FILTERFUNC		 = RTFI_FILTERFUNC

/*** (V38) tags for rtScreenModeRequestA ***
*/
/* various flags (see below) */
NATIVE {RTSC_Flags}		 CONST RTSC_FLAGS		 = RTFI_FLAGS
/* suggested height of screenmode requester */
NATIVE {RTSC_Height}		 CONST RTSC_HEIGHT		 = RTFI_HEIGHT
/* replacement text for 'Ok' gadget (max 6 chars) */
NATIVE {RTSC_OkText}		 CONST RTSC_OKTEXT		 = RTFI_OKTEXT
/* property flags (see also RTSC_PropertyMask) */
NATIVE {RTSC_PropertyFlags}	 CONST RTSC_PROPERTYFLAGS	 = (RT_TAGBASE+90)
/* property mask - default all bits in RTSC_PropertyFlags considered */
NATIVE {RTSC_PropertyMask}	 CONST RTSC_PROPERTYMASK	 = (RT_TAGBASE+91)
/* minimum display width allowed */
NATIVE {RTSC_MinWidth}		 CONST RTSC_MINWIDTH		 = (RT_TAGBASE+92)
/* maximum display width allowed */
NATIVE {RTSC_MaxWidth}		 CONST RTSC_MAXWIDTH		 = (RT_TAGBASE+93)
/* minimum display height allowed */
NATIVE {RTSC_MinHeight}		 CONST RTSC_MINHEIGHT		 = (RT_TAGBASE+94)
/* maximum display height allowed */
NATIVE {RTSC_MaxHeight}		 CONST RTSC_MAXHEIGHT		 = (RT_TAGBASE+95)
/* minimum display depth allowed */
NATIVE {RTSC_MinDepth}		 CONST RTSC_MINDEPTH		 = (RT_TAGBASE+96)
/* maximum display depth allowed */
NATIVE {RTSC_MaxDepth}		 CONST RTSC_MAXDEPTH		 = (RT_TAGBASE+97)
/* call this hook for every display mode id */
NATIVE {RTSC_FilterFunc}		 CONST RTSC_FILTERFUNC		 = RTFI_FILTERFUNC

/*** tags for rtChangeReqAttrA ***
*/
/* file requester - set directory */
NATIVE {RTFI_Dir}		 CONST RTFI_DIR		 = (RT_TAGBASE+50)
/* file requester - set wildcard pattern */
NATIVE {RTFI_MatchPat}		 CONST RTFI_MATCHPAT		 = (RT_TAGBASE+51)
/* file requester - add a file or directory to the buffer */
NATIVE {RTFI_AddEntry}		 CONST RTFI_ADDENTRY		 = (RT_TAGBASE+52)
/* file requester - remove a file or directory from the buffer */
NATIVE {RTFI_RemoveEntry}	 CONST RTFI_REMOVEENTRY	 = (RT_TAGBASE+53)
/* font requester - set font name of selected font */
NATIVE {RTFO_FontName}		 CONST RTFO_FONTNAME		 = (RT_TAGBASE+63)
/* font requester - set font size */
NATIVE {RTFO_FontHeight}		 CONST RTFO_FONTHEIGHT		 = (RT_TAGBASE+64)
/* font requester - set font style */
NATIVE {RTFO_FontStyle}		 CONST RTFO_FONTSTYLE		 = (RT_TAGBASE+65)
/* font requester - set font flags */
NATIVE {RTFO_FontFlags}		 CONST RTFO_FONTFLAGS		 = (RT_TAGBASE+66)
/* (V38) screenmode requester - get display attributes from screen */
NATIVE {RTSC_ModeFromScreen}	 CONST RTSC_MODEFROMSCREEN	 = (RT_TAGBASE+80)
/* (V38) screenmode requester - set display mode id (32-bit extended) */
NATIVE {RTSC_DisplayID}		 CONST RTSC_DISPLAYID		 = (RT_TAGBASE+81)
/* (V38) screenmode requester - set display width */
NATIVE {RTSC_DisplayWidth}	 CONST RTSC_DISPLAYWIDTH	 = (RT_TAGBASE+82)
/* (V38) screenmode requester - set display height */
NATIVE {RTSC_DisplayHeight}	 CONST RTSC_DISPLAYHEIGHT	 = (RT_TAGBASE+83)
/* (V38) screenmode requester - set display depth */
NATIVE {RTSC_DisplayDepth}	 CONST RTSC_DISPLAYDEPTH	 = (RT_TAGBASE+84)
/* (V38) screenmode requester - set overscan type, 0 for regular size */
NATIVE {RTSC_OverscanType}	 CONST RTSC_OVERSCANTYPE	 = (RT_TAGBASE+85)
/* (V38) screenmode requester - set autoscroll */
NATIVE {RTSC_AutoScroll}		 CONST RTSC_AUTOSCROLL		 = (RT_TAGBASE+86)

/*** tags for rtPaletteRequestA ***
*/
/* initially selected color - default 1 */
NATIVE {RTPA_Color}		 CONST RTPA_COLOR		 = (RT_TAGBASE+70)

/*** tags for rtReqHandlerA ***
*/
/* end requester by software control, set tagdata to REQ_CANCEL, REQ_OK or
   in case of rtEZRequest to the return value */
NATIVE {RTRH_EndRequest}		 CONST RTRH_ENDREQUEST		 = (RT_TAGBASE+60)

/*** tags for rtAllocRequestA ***/
/* no tags defined yet */


/************
* RT_ReqPos *
************/
NATIVE {REQPOS_POINTER}		 CONST REQPOS_POINTER		 = 0
NATIVE {REQPOS_CENTERWIN}	 CONST REQPOS_CENTERWIN	 = 1
NATIVE {REQPOS_CENTERSCR}	 CONST REQPOS_CENTERSCR	 = 2
NATIVE {REQPOS_TOPLEFTWIN}	 CONST REQPOS_TOPLEFTWIN	 = 3
NATIVE {REQPOS_TOPLEFTSCR}	 CONST REQPOS_TOPLEFTSCR	 = 4

/******************
* RTRH_EndRequest *
******************/
NATIVE {REQ_CANCEL}		 CONST REQ_CANCEL		 = 0
NATIVE {REQ_OK}			 CONST REQ_OK			 = 1

/***************************************
* flags for RTFI_Flags and RTFO_Flags  *
* or filereq->Flags and fontreq->Flags *
***************************************/
NATIVE {FREQB_NOBUFFER}		 CONST FREQB_NOBUFFER		 = 2
NATIVE {FREQF_NOBUFFER}		 CONST FREQF_NOBUFFER		 = (1 SHL FREQB_NOBUFFER)

/*****************************************
* flags for RTFI_Flags or filereq->Flags *
*****************************************/
NATIVE {FREQB_MULTISELECT}	 CONST FREQB_MULTISELECT	 = 0
NATIVE {FREQF_MULTISELECT}	 CONST FREQF_MULTISELECT	 = (1 SHL FREQB_MULTISELECT)
NATIVE {FREQB_SAVE}		 CONST FREQB_SAVE		 = 1
NATIVE {FREQF_SAVE}		 CONST FREQF_SAVE		 = (1 SHL FREQB_SAVE)
NATIVE {FREQB_NOFILES}		 CONST FREQB_NOFILES		 = 3
NATIVE {FREQF_NOFILES}		 CONST FREQF_NOFILES		 = (1 SHL FREQB_NOFILES)
NATIVE {FREQB_PATGAD}		 CONST FREQB_PATGAD		 = 4
NATIVE {FREQF_PATGAD}		 CONST FREQF_PATGAD		 = (1 SHL FREQB_PATGAD)
NATIVE {FREQB_SELECTDIRS}	 CONST FREQB_SELECTDIRS	 = 12
NATIVE {FREQF_SELECTDIRS}	 CONST FREQF_SELECTDIRS	 = (1 SHL FREQB_SELECTDIRS)

/*****************************************
* flags for RTFO_Flags or fontreq->Flags *
*****************************************/
NATIVE {FREQB_FIXEDWIDTH}	 CONST FREQB_FIXEDWIDTH	 = 5
NATIVE {FREQF_FIXEDWIDTH}	 CONST FREQF_FIXEDWIDTH	 = (1 SHL FREQB_FIXEDWIDTH)
NATIVE {FREQB_COLORFONTS}	 CONST FREQB_COLORFONTS	 = 6
NATIVE {FREQF_COLORFONTS}	 CONST FREQF_COLORFONTS	 = (1 SHL FREQB_COLORFONTS)
NATIVE {FREQB_CHANGEPALETTE}	 CONST FREQB_CHANGEPALETTE	 = 7
NATIVE {FREQF_CHANGEPALETTE}	 CONST FREQF_CHANGEPALETTE	 = (1 SHL FREQB_CHANGEPALETTE)
NATIVE {FREQB_LEAVEPALETTE}	 CONST FREQB_LEAVEPALETTE	 = 8
NATIVE {FREQF_LEAVEPALETTE}	 CONST FREQF_LEAVEPALETTE	 = (1 SHL FREQB_LEAVEPALETTE)
NATIVE {FREQB_SCALE}		 CONST FREQB_SCALE		 = 9
NATIVE {FREQF_SCALE}		 CONST FREQF_SCALE		 = (1 SHL FREQB_SCALE)
NATIVE {FREQB_STYLE}		 CONST FREQB_STYLE		 = 10
NATIVE {FREQF_STYLE}		 CONST FREQF_STYLE		 = (1 SHL FREQB_STYLE)

/*****************************************************
* (V38) flags for RTSC_Flags or screenmodereq->Flags *
*****************************************************/
NATIVE {SCREQB_SIZEGADS}		 CONST SCREQB_SIZEGADS		 = 13
NATIVE {SCREQF_SIZEGADS}		 CONST SCREQF_SIZEGADS		 = (1 SHL SCREQB_SIZEGADS)
NATIVE {SCREQB_DEPTHGAD}		 CONST SCREQB_DEPTHGAD		 = 14
NATIVE {SCREQF_DEPTHGAD}		 CONST SCREQF_DEPTHGAD		 = (1 SHL SCREQB_DEPTHGAD)
NATIVE {SCREQB_NONSTDMODES}	 CONST SCREQB_NONSTDMODES	 = 15
NATIVE {SCREQF_NONSTDMODES}	 CONST SCREQF_NONSTDMODES	 = (1 SHL SCREQB_NONSTDMODES)
NATIVE {SCREQB_GUIMODES}		 CONST SCREQB_GUIMODES		 = 16
NATIVE {SCREQF_GUIMODES}		 CONST SCREQF_GUIMODES		 = (1 SHL SCREQB_GUIMODES)
NATIVE {SCREQB_AUTOSCROLLGAD}	 CONST SCREQB_AUTOSCROLLGAD	 = 18
NATIVE {SCREQF_AUTOSCROLLGAD}	 CONST SCREQF_AUTOSCROLLGAD	 = (1 SHL SCREQB_AUTOSCROLLGAD)
NATIVE {SCREQB_OVERSCANGAD}	 CONST SCREQB_OVERSCANGAD	 = 19
NATIVE {SCREQF_OVERSCANGAD}	 CONST SCREQF_OVERSCANGAD	 = (1 SHL SCREQB_OVERSCANGAD)

/*****************************************
* flags for RTEZ_Flags or reqinfo->Flags *
*****************************************/
NATIVE {EZREQB_NORETURNKEY}	 CONST EZREQB_NORETURNKEY	 = 0
NATIVE {EZREQF_NORETURNKEY}	 CONST EZREQF_NORETURNKEY	 = (1 SHL EZREQB_NORETURNKEY)
NATIVE {EZREQB_LAMIGAQUAL}	 CONST EZREQB_LAMIGAQUAL	 = 1
NATIVE {EZREQF_LAMIGAQUAL}	 CONST EZREQF_LAMIGAQUAL	 = (1 SHL EZREQB_LAMIGAQUAL)
NATIVE {EZREQB_CENTERTEXT}	 CONST EZREQB_CENTERTEXT	 = 2
NATIVE {EZREQF_CENTERTEXT}	 CONST EZREQF_CENTERTEXT	 = (1 SHL EZREQB_CENTERTEXT)

/***********************************************
* (V38) flags for RTGL_Flags or reqinfo->Flags *
***********************************************/
NATIVE {GLREQB_CENTERTEXT}	 CONST GLREQB_CENTERTEXT	 = EZREQB_CENTERTEXT
NATIVE {GLREQF_CENTERTEXT}	 CONST GLREQF_CENTERTEXT	 = EZREQF_CENTERTEXT
NATIVE {GLREQB_HIGHLIGHTTEXT}	 CONST GLREQB_HIGHLIGHTTEXT	 = 3
NATIVE {GLREQF_HIGHLIGHTTEXT}	 CONST GLREQF_HIGHLIGHTTEXT	 = (1 SHL GLREQB_HIGHLIGHTTEXT)

/***********************************************
* (V38) flags for RTGS_Flags or reqinfo->Flags *
***********************************************/
NATIVE {GSREQB_CENTERTEXT}	 CONST GSREQB_CENTERTEXT	 = EZREQB_CENTERTEXT
NATIVE {GSREQF_CENTERTEXT}	 CONST GSREQF_CENTERTEXT	 = EZREQF_CENTERTEXT
NATIVE {GSREQB_HIGHLIGHTTEXT}	 CONST GSREQB_HIGHLIGHTTEXT	 = GLREQB_HIGHLIGHTTEXT
NATIVE {GSREQF_HIGHLIGHTTEXT}	 CONST GSREQF_HIGHLIGHTTEXT	 = GLREQF_HIGHLIGHTTEXT

/*****************************************
* (V38) flags for RTFI_VolumeRequest tag *
*****************************************/
NATIVE {VREQB_NOASSIGNS}		 CONST VREQB_NOASSIGNS		 = 0
NATIVE {VREQF_NOASSIGNS}		 CONST VREQF_NOASSIGNS		 = (1 SHL VREQB_NOASSIGNS)
NATIVE {VREQB_NODISKS}		 CONST VREQB_NODISKS		 = 1
NATIVE {VREQF_NODISKS}		 CONST VREQF_NODISKS		 = (1 SHL VREQB_NODISKS)
NATIVE {VREQB_ALLDISKS}		 CONST VREQB_ALLDISKS		 = 2
NATIVE {VREQF_ALLDISKS}		 CONST VREQF_ALLDISKS		 = (1 SHL VREQB_ALLDISKS)

/*
   Following things are obsolete in ReqTools V38.
   DON'T USE THESE IN NEW CODE!
*/
->#ifndef NO_REQTOOLS_OBSOLETE
NATIVE {REQHOOK_WILDFILE} CONST REQHOOK_WILDFILE = 0
NATIVE {REQHOOK_WILDFONT} CONST REQHOOK_WILDFONT = 1
NATIVE {FREQB_DOWILDFUNC} CONST FREQB_DOWILDFUNC = 11
NATIVE {FREQF_DOWILDFUNC} CONST FREQF_DOWILDFUNC = (1 SHL FREQB_DOWILDFUNC)
->#endif
