{
    Libraries/ReqTools.i
}

(*
**  $Filename: libraries/reqtools.h $
**  $Release: 2.5 $
**  $Revision: 38.13 $
**
**  reqtools.library definitions
**
**  (C) Copyright 1991-1994 Nico François
**                1995-1996 Magnus Homgren
**  All Rights Reserved
**
**  This is reqtools.i for PCQ Pascal
**
**  This header defines some functions with variable
**  numbers of args.
**
**  rtEZRequest has three functions, you can use them
**  like this.
**
**  rtEZRequestA    : is the normal function
**  rtEZRequest     : This one use a variable number of args
**                    for RawDoFmt.
**  rtEZRequestTags : This one use a variable number of args
**                    for Tags.
**
**  If you want to use both RawDoFmt and Tags you can do like this.
**
**  Set up an array of integers, fill in your values in the array
**  and call the function like this.
**
**  value[0] := 5;
**  value[1] := INTEGER("five");
**  ret := rtEZRequestTags("Your body text %ld and some more %s",
**                         "_Proceed",NIL,@value[0],RT_Underscore,'_',TAG_DONE);
**
**  For more info and tips check out the demo RTDemo.p
**
**  If you want to use reqtools don't forget to link with
**  reqtools.lib, this linklib has all the glue and varargs
**  functions for PCQ Pascal. The glue is NOT in pcq.lib anymore.
**
**  nils.sjoholm@mailbox.swipnet.se  (Nils Sjoholm)
**
*)
    

{$I "Include:exec/types.i"}
{$I "Include:exec/lists.i"}
{$I "Include:exec/libraries.i"}
{$I "Include:exec/semaphores.i"}
{$I "Include:DOS/dos.i"}
{$I "Include:DOS/dosextens.i"}
{$I "Include:DiskFont/diskfont.i"}
{$I "Include:graphics/text.i"}
{$I "Include:utility/tagitem.i"}
{$I "Include:Intuition/Intuition.i"}


{***********************
*                      *
*     Preferences      *
*                      *
***********************}

CONST   RTPREF_FILEREQ          = 0;
        RTPREF_FONTREQ          = 1;
        RTPREF_PALETTEREQ       = 2;
        RTPREF_SCREENMODEREQ    = 3;
        RTPREF_VOLUMEREQ        = 4;
        RTPREF_OTHERREQ         = 5;
        RTPREF_NR_OF_REQ        = 6;

Type
    ReqDefaultsPtr = ^ReqDefaults;
    ReqDefaults = Record
        Size       : INTEGER;
        ReqPos     : INTEGER;
        LeftOffset : WORD;
        TopOffset  : WORD;
        MinEntries : WORD;
        MaxEntries : WORD;
    END;

    ReqToolsPrefsPtr = ^ReqToolsPrefs;
    ReqToolsPrefs = Record
    { Size of preferences (_without_ this field and the semaphore) }
        PrefsSize      : INTEGER;
        PrefsSemaphore : SignalSemaphore;
    { Start of real preferences }
        Flags          : INTEGER;
        _ReqDefaults   : ARRAY [1..RTPREF_NR_OF_REQ] OF ReqDefaults;
    END;
{
#define RTPREFS_SIZE \
   (sizeof (struct ReqToolsPrefs) - sizeof (struct SignalSemaphore) - 4)  }

CONST
     RTPREFS_SIZE = 100;

{ Flags }

     RTPRB_DIRSFIRST       = 0;
     RTPRF_DIRSFIRST       = 1;
     RTPRB_DIRSMIXED       = 1;
     RTPRF_DIRSMIXED       = 2;
     RTPRB_IMMSORT         = 2;
     RTPRF_IMMSORT         = 4;
     RTPRB_NOSCRTOFRONT    = 3;
     RTPRF_NOSCRTOFRONT    = 8;
     RTPRB_NOLED           = 4;
     RTPRF_NOLED           = 16;
     RTPRB_DEFAULTFONT     = 5;
     RTPRF_DEFAULTFONT     = 32;
     RTPRB_DOWHEEL         = 6;
     RTPRF_DOWHEEL         = 64;
     RTPRB_FKEYS           = 7;
     RTPRF_FKEYS           = 128;
     RTPRB_FANCYWHEEL      = 8;
     RTPRF_FANCYWHEEL      = 256;
     RTPRB_MMBPARENT       = 9;
     RTPRF_MMBPARENT       = 512;

{***********************
*                      *
*     Library Base     *
*                      *
***********************}

Const
    
    REQTOOLSNAME = "reqtools.library";
    REQTOOLSVERSION = 38;

Type

    ReqToolsBasePtr = ^ReqToolsBase;
    ReqToolsBase = Record
        LibNode           : LibraryPtr;
        RTFlags           : Byte;
        Pad               : Array[0..2] of Byte;
        SegList           : BPTR;

        { The following library bases may be read and used by your program }

        IntuitionBase     : LibraryPtr;
        GfxBase           : LibraryPtr;
        DOSBase           : LibraryPtr;

        { Next two library bases are only (and always) valid on Kickstart 2.0!
          (1.3 version of reqtools also initializes these when run on 2.0) }

        GadToolsBase      : LibraryPtr;
        UtilityBase       : LibraryPtr;

        { PRIVATE FIELDS, THESE WILL CHANGE FROM RELEASE TO RELEASE! }

        { The RealOpenCnt is for the buffered AvailFonts feature.  Since
          Kickstart 3.0 offers low memory handlers a release of ReqTools for 3.0
          will not use this field and start using the normal OpenCnt again. }

        RealOpenCnt       : WORD;
        AvailFontsLock    : WORD;
        _AvailFontsHeader : AvailFontsHeaderPtr;
        FontsAssignType   : INTEGER;
        FontsAssignLock   : BPTR;
        FontsAssignList   : AssignListPtr;
        _ReqToolsPrefs    : ReqToolsPrefs;
        prefspad          : WORD;
    end;
  

Const

{ types of requesters, for rtAllocRequestA() }

    RT_FILEREQ       = 0;
    RT_REQINFO       = 1;
    RT_FONTREQ       = 2;
    { (V38) }
    RT_SCREENMODEREQ = 3;

{***********************
*                      *
*    File requester    *
*                      *
***********************}

type

{ structure _MUST_ be allocated with rtAllocRequest() }

    rtFileRequesterPtr = ^rtFileRequester;
    rtFileRequester  = Record
         ReqPos      : Integer;
         LeftOffset  : WORD;
         TopOffset   : WORD;
         Flags       : Integer;

         { OBSOLETE IN V38! DON'T USE! } Hook: HookPtr;

         Dir         : String;     { READ ONLY! Change with rtChangeReqAttrA()! }
         MatchPat    : String;     { READ ONLY! Change with rtChangeReqAttrA()! }
         DefaultFont : TextFontPtr;
         WaitPointer : Integer;
         { (V38) }
         LockWindow  : Integer;
         ShareIDCMP  : Integer;
         IntuiMsgFunc: HookPtr;
         reserved1   : WORD;
         reserved2   : WORD;
         reserved3   : WORD;
         ReqHeight   : WORD;     { READ ONLY! Use RTFI_Height tag! }
         { Private data follows! HANDS OFF }
    end;
   

{ returned by rtFileRequestA() if multiselect is enabled,
  free list with rtFreeFileList() }

    rtFileListPtr = ^rtFileList;
    rtFileList = Record
         Next    : rtFileListPtr;
         StrLen  : Integer;        { -1 for directories }
         Name    : String;
    end;
   
{ structure passed to RTFI_FilterFunc callback hook by
   volume requester (see RTFI_VolumeRequest tag) }

    rtVolumeEntryPtr = ^rtVolumeEntry;
    rtVolumeEntry = Record
        Type_ : INTEGER;           { DLT_DEVICE or DLT_DIRECTORY }
        Name  : STRING;
    END;

{***********************
*                      *
*    Font requester    *
*                      *
***********************}

{ structure _MUST_ be allocated with rtAllocRequest() }

    rtFontRequesterPtr = ^rtFontRequester;
    rtFontRequester = Record
         ReqPos        : Integer;
         LeftOffset    : WORD;
         TopOffset     : WORD;
         Flags         : Integer;
         { OBSOLETE IN V38! DON'T USE! } Hook: HookPtr;
         Attr          : TextAttr; { READ ONLY! }
         DefaultFont   : TextFontPtr;
         WaitPointer   : Integer;
         { (V38) }
         LockWindow    : Integer;
         ShareIDCMP    : Integer;
         IntuiMsgFunc  : HookPtr;
         reserved1     : WORD;
         reserved2     : WORD;
         reserved3     : WORD;
         ReqHeight     : WORD; { READ ONLY!  Use RTFO_Height tag! }
         { Private data follows! HANDS OFF }
    end;
    

{*************************
*                        *
*  ScreenMode requester  *
*                        *
*************************}

{ structure _MUST_ be allocated with rtAllocRequest() }

    rtScreenModeRequesterPtr = ^rtScreenModeRequester;
    rtScreenModeRequester = Record
         ReqPos      : Integer;
         LeftOffset  : WORD;
         TopOffset   : WORD;
         Flags       : Integer;
         private1    : Integer;
         DisplayID   : Integer;  { READ ONLY! }
         DisplayWidth: WORD;    { READ ONLY! }
         DisplayHeight: WORD;   { READ ONLY! }
         DefaultFont : TextFontPtr;
         WaitPointer : Integer;
         LockWindow  : Integer;
         ShareIDCMP  : Integer;
         IntuiMsgFunc: HookPtr;
         reserved1   : WORD;
         reserved2   : WORD;
         reserved3   : WORD;
         ReqHeight   : WORD;    { READ ONLY!  Use RTSC_Height tag! }
         DisplayDepth: WORD;    { READ ONLY! }
         OverscanType: WORD;    { READ ONLY! }
         AutoScroll  : Integer;  { READ ONLY! }
         { Private data follows! HANDS OFF }
    end;
    

{***********************
*                      *
*    Requester Info    *
*                      *
***********************}

{ for rtEZRequestA(), rtGetLongA(), rtGetStringA() and rtPaletteRequestA(),
   _MUST_ be allocated with rtAllocRequest() }

    rtReqInfoPtr = ^rtReqInfo;
    rtReqInfo = Record
         ReqPos      : Integer;
         LeftOffset  : WORD;
         TopOffset   : WORD;
         Width       : Integer;        { not for rtEZRequestA() }
         ReqTitle    : String;         { currently only for rtEZRequestA() }
         Flags       : Integer;        { currently only for rtEZRequestA() }
         DefaultFont : TextFontPtr;    { currently only for rtPaletteRequestA() }
         WaitPointer : Integer;
         { (V38) }
         LockWindow  : Integer;
         ShareIDCMP  : Integer;
         IntuiMsgFunc: HookPtr;
         { structure may be extended in future }
     end;
    

{***********************
*                      *
*     Handler Info     *
*                      *
***********************}

{ for rtReqHandlerA(), will be allocated for you when you use
   the RT_ReqHandler tag, never try to allocate this yourself! }

    rtHandlerInfoPtr = ^rtHandlerInfo;
    rtHandlerInfo = Record
         private1  : Integer;
         WaitMask  : Integer;
         DoNotWait : Integer;
         { Private data follows, HANDS OFF }
    end;
    

Const

{ possible return codes from rtReqHandlerA() }

    CALL_HANDLER = $80000000;

{*************************************
*                                    *
*                TAGS                *
*                                    *
*************************************}

    RT_TagBase = TAG_USER;

{ *** tags understood by most requester functions *** }

RT_Window       = $80000001; { Optional pointer to window }
RT_IDCMPFlags   = $80000002; { idcmp flags requester should abort on (useful for IDCMP_DISKINSERTED) }
RT_ReqPos       = $80000003; { position of requester window (see below) - default REQPOS_POINTER }
RT_LeftOffset   = $80000004; { signal mask to wait for abort signal }
RT_TopOffset    = $80000005; { topedge offset of requester relative to position specified by RT_ReqPos }
RT_PubScrName   = $80000006; { name of public screen to put requester on (Kickstart 2.0 only!) }
RT_Screen       = $80000007; { address of screen to put requester on }
RT_ReqHandler   = $80000008; { tagdata must hold the address of (!) an APTR variable }
RT_DefaultFont  = $80000009; { font to use when screen font is rejected, _MUST_ be fixed-width font! pTextFont , not pTextAttr ) - default GfxBase^.DefaultFont }

RT_WaitPointer  = $8000000A; { boolean to set the standard wait pointer in window - default FALSE }
RT_Underscore   = $8000000B; { (V38) char preceding keyboard shortcut characters (will be underlined) }
RT_ShareIDCMP   = $8000000C; { (V38) share IDCMP port with window - default FALSE }
RT_LockWindow   = $8000000D; { (V38) lock window and set standard wait pointer - default FALSE }
RT_ScreenToFront= $8000000E; { (V38) boolean to make requester's screen pop to front - default TRUE }
RT_TextAttr     = $8000000F; { (V38) Requester should use this font - default: screen font }
RT_IntuiMsgFunc = $80000010; { (V38) call this hook for every IDCMP message not for requester }
RT_Locale       = $80000011; { (V38) Locale ReqTools should use for text }

{ *** tags specific to rtEZRequestA *** }
RTEZ_ReqTitle   = $80000014; { title of requester window - english default "Request" or "Information" }
                             { ($80000015) reserved }
RTEZ_Flags      = $80000016; { various flags (see below) }
RTEZ_DefaultResponse
                = $80000017; { default response (activated by pressing RETURN) - default TRUE }


{ *** tags specific to rtGetLongA *** }
RTGL_Min        = $8000001E; { minimum allowed value - default MININT }
RTGL_Max        = $8000001F; { maximum allowed value - default MAXINT }
RTGL_Width      = $80000020; { suggested width of requester window (in pixels) }
RTGL_ShowDefault= $80000021; { boolean to show the default value - default TRUE }
RTGL_GadFmt     = $80000022; { (V38) string with possible responses - english default " _Ok |_Cancel" }
RTGL_GadFmtArgs = $80000023; { (V38) optional arguments for RTGL_GadFmt }
RTGL_Invisible  = $80000024; { (V38) invisible typing - default FALSE }
RTGL_Backfill   = $80000025; { (V38) window backfill - default TRUE }
RTGL_TextFmt    = $80000026; { (V38) optional text above gadget }
RTGL_TextFmtArgs= $80000027; { (V38) optional arguments for RTGS_TextFmt }
RTGL_Flags = RTEZ_Flags;     { (V38) various flags (see below) }


{ *** tags specific to rtGetStringA *** }
RTGS_Width      = RTGL_Width;       { suggested width of requester window (in pixels) }
RTGS_AllowEmpty = $80000050;        { allow empty string to be accepted - default FALSE }
RTGS_GadFmt     = RTGL_GadFmt;      { (V38) string with possible responses - english default " _Ok |_Cancel" }
RTGS_GadFmtArgs = RTGL_GadFmtArgs;  { (V38) optional arguments for RTGS_GadFmt }
RTGS_Invisible  = RTGL_Invisible;   { (V38) invisible typing - default FALSE }
RTGS_Backfill   = RTGL_Backfill;    { (V38) window backfill - default TRUE }
RTGS_TextFmt    = RTGL_TextFmt;     { (V38) optional text above gadget }
RTGS_TextFmtArgs= RTGL_TextFmtArgs; { (V38) optional arguments for RTGS_TextFmt }
RTGS_Flags      = RTEZ_Flags;       { (V38) various flags (see below) }


{ *** tags specific to rtFileRequestA *** }
RTFI_Flags      = $80000028; { various flags (see below) }
RTFI_Height     = $80000029; { suggested height of file requester }
RTFI_OkText     = $8000002A; { replacement text for 'Ok' gadget (max 6 chars) }
RTFI_VolumeRequest=$8000002B;{ (V38) bring up volume requester, tag data holds flags (see below) }
RTFI_FilterFunc = $8000002C; { (V38) call this hook for every file in the directory }
RTFI_AllowEmpty = $8000002D; { (V38) allow empty file to be accepted - default FALSE }


{ *** tags specific to rtFontRequestA *** }
RTFO_Flags      = RTFI_Flags;  { various flags (see below) }
RTFO_Height     = RTFI_Height; { suggested height of font requester }
RTFO_OkText     = RTFI_OkText; { replacement text for 'Ok' gadget (max 6 chars) }
RTFO_SampleHeight=$8000003C;   { suggested height of font sample display - default 24 }
RTFO_MinHeight  = $8000003D;   { minimum height of font displayed }
RTFO_MaxHeight  = $8000003E;   { maximum height of font displayed }
{ [($8000003F) to ($80000042) used below] }
RTFO_FilterFunc = RTFI_FilterFunc;{ (V38) call this hook for every font }


{ *** (V38) tags for rtScreenModeRequestA *** }
RTSC_Flags         = RTFI_Flags;{ various flags (see below) }
RTSC_Height        = RTFI_Height;{ suggested height of screenmode requester }
RTSC_OkText        = RTFI_OkText;{ replacement text for 'Ok' gadget (max 6 chars) }
RTSC_PropertyFlags = $8000005A;{ property flags (see also RTSC_PropertyMask) }
RTSC_PropertyMask  = $8000005B;{ property mask - default all bits in RTSC_PropertyFlags considered }
RTSC_MinWidth      = $8000005C;{ minimum display width allowed }
RTSC_MaxWidth      = $8000005D;{ maximum display width allowed }
RTSC_MinHeight     = $8000005E;{ minimum display height allowed }
RTSC_MaxHeight     = $8000005F;{ maximum display height allowed }
RTSC_MinDepth      = $80000060;{ minimum display depth allowed }
RTSC_MaxDepth      = $80000061;{ maximum display depth allowed }
RTSC_FilterFunc    = RTFI_FilterFunc;{ call this hook for every display mode id }


{ *** tags for rtChangeReqAttrA *** }
RTFI_Dir = $80000032;{ file requester - set directory }
RTFI_MatchPat = $80000033;{ file requester - set wildcard pattern }
RTFI_AddEntry = $80000034;{ file requester - add a file or directory to the buffer }
RTFI_RemoveEntry = $80000035;{ file requester - remove a file or directory from the buffer }
RTFO_FontName = $8000003F;{ font requester - set font name of selected font }
RTFO_FontHeight = $80000040;{ font requester - set font size }
RTFO_FontStyle = $80000041;{ font requester - set font style }
RTFO_FontFlags = $80000042;{ font requester - set font flags }
RTSC_ModeFromScreen = $80000050;{ (V38) screenmode requester - get display attributes from screen }
RTSC_DisplayID = $80000051;{ (V38) screenmode requester - set display mode id (32-bit extended) }
RTSC_DisplayWidth = $80000052;{ (V38) screenmode requester - set display width }
RTSC_DisplayHeight = $80000053;{ (V38) screenmode requester - set display height }
RTSC_DisplayDepth = $80000054;{ (V38) screenmode requester - set display depth }
RTSC_OverscanType = $80000055;{ (V38) screenmode requester - set overscan type, 0 for regular size }
RTSC_AutoScroll = $80000056;{ (V38) screenmode requester - set autoscroll }


{ *** tags for rtPaletteRequestA *** }
{ initially selected color - default 1 }
    RTPA_Color = $80000046;

{ *** tags for rtReqHandlerA *** }
{ end requester by software control, set tagdata to REQ_CANCEL, REQ_OK or
  in case of rtEZRequest to the return value }
    RTRH_EndRequest = $800003C;

{ *** tags for rtAllocRequestA *** }
{ no tags defined yet }

{************
* RT_ReqPos *
************}
    REQPOS_POINTER    = 0;
    REQPOS_CENTERWIN  = 1;
    REQPOS_CENTERSCR  = 2;
    REQPOS_TOPLEFTWIN = 3;
    REQPOS_TOPLEFTSCR = 4;
    
{******************
* RTRH_EndRequest *
******************}
    REQ_CANCEL = 0;
    REQ_OK     = 1;

{***************************************
* flags for RTFI_Flags and RTFO_Flags  *
* or filereq->Flags and fontreq->Flags *
***************************************}
    FREQB_NOBUFFER = 2;
    FREQF_NOBUFFER = 4;

{*****************************************
* flags for RTFI_Flags or filereq->Flags *
*****************************************}
    FREQB_MULTISELECT = 0;
    FREQF_MULTISELECT = 1;
    FREQB_SAVE        = 1;
    FREQF_SAVE        = 2;
    FREQB_NOFILES     = 3;
    FREQF_NOFILES     = 8;
    FREQB_PATGAD      = 4;
    FREQF_PATGAD      = 16;
    FREQB_SELECTDIRS  = 12;
    FREQF_SELECTDIRS  = 4096;

{*****************************************
* flags for RTFO_Flags or fontreq->Flags *
*****************************************}
    FREQB_FIXEDWIDTH    = 5;
    FREQF_FIXEDWIDTH    = 32;
    FREQB_COLORFONTS    = 6;
    FREQF_COLORFONTS    = 64;
    FREQB_CHANGEPALETTE = 7;
    FREQF_CHANGEPALETTE = 128;
    FREQB_LEAVEPALETTE  = 8;
    FREQF_LEAVEPALETTE  = 256;
    FREQB_SCALE         = 9;
    FREQF_SCALE         = 512;
    FREQB_STYLE         = 10;
    FREQF_STYLE         = 1024;

{*****************************************************
* (V38) flags for RTSC_Flags or screenmodereq->Flags *
*****************************************************}
    SCREQB_SIZEGADS      = 13;
    SCREQF_SIZEGADS      = 8192;
    SCREQB_DEPTHGAD      = 14;
    SCREQF_DEPTHGAD      = 16384;
    SCREQB_NONSTDMODES   = 15;
    SCREQF_NONSTDMODES   = 32768;
    SCREQB_GUIMODES      = 16;
    SCREQF_GUIMODES      = 65536;
    SCREQB_AUTOSCROLLGAD = 18;
    SCREQF_AUTOSCROLLGAD = 262144;
    SCREQB_OVERSCANGAD   = 19;
    SCREQF_OVERSCANGAD   = 524288;

{*****************************************
* flags for RTEZ_Flags or reqinfo->Flags *
*****************************************}
    EZREQB_NORETURNKEY = 0;
    EZREQF_NORETURNKEY = 1;
    EZREQB_LAMIGAQUAL  = 1;
    EZREQF_LAMIGAQUAL  = 2;
    EZREQB_CENTERTEXT  = 2;
    EZREQF_CENTERTEXT  = 4;

{***********************************************
* (V38) flags for RTGL_Flags or reqinfo->Flags *
***********************************************}
    GLREQB_CENTERTEXT    = EZREQB_CENTERTEXT;
    GLREQF_CENTERTEXT    = EZREQF_CENTERTEXT;
    GLREQB_HIGHLIGHTTEXT = 3;
    GLREQF_HIGHLIGHTTEXT = 8;

{***********************************************
* (V38) flags for RTGS_Flags or reqinfo->Flags *
***********************************************}
    GSREQB_CENTERTEXT    = EZREQB_CENTERTEXT;
    GSREQF_CENTERTEXT    = EZREQF_CENTERTEXT;
    GSREQB_HIGHLIGHTTEXT = GLREQB_HIGHLIGHTTEXT;
    GSREQF_HIGHLIGHTTEXT = GLREQF_HIGHLIGHTTEXT;

{*****************************************
* (V38) flags for RTFI_VolumeRequest tag *
*****************************************}
    VREQB_NOASSIGNS   = 0;
    VREQF_NOASSIGNS   = 1;
    VREQB_NODISKS     = 1;
    VREQF_NODISKS     = 2;
    VREQB_ALLDISKS    = 2;
    VREQF_ALLDISKS    = 4;

{*
   Following things are obsolete in ReqTools V38.
   DON'T USE THESE IN NEW CODE!
*}
    REQHOOK_WILDFILE  = 0;
    REQHOOK_WILDFONT  = 1;
    FREQB_DOWILDFUNC  = 11;
    FREQF_DOWILDFUNC  = 2048;


{************
* Functions *
************}

{$I "Include:Libraries/ReqToolsBaseVar.i"}

FUNCTION rtAllocRequestA(TheType : INTEGER; taglist: ADDRESS): ADDRESS;
EXTERNAL;

PROCEDURE rtFreeRequest (req: ADDRESS);
EXTERNAL;

PROCEDURE rtFreeReqBuffer (req: ADDRESS);
EXTERNAL;

FUNCTION rtChangeReqAttrA(req: ADDRESS; taglist: ADDRESS): INTEGER;
EXTERNAL;

FUNCTION rtFileRequestA(filereq : rtFileRequesterPtr; filename: STRING;
                        title: STRING; taglist: ADDRESS): ADDRESS;
EXTERNAL;

PROCEDURE rtFreeFileList (filelist : rtFileListPtr);
EXTERNAL;

FUNCTION rtEZRequestA(bodyfmt : STRING; gadfmt : STRING; reqinfo: rtReqInfoPtr;
                      argarray: ADDRESS; taglist: ADDRESS): INTEGER;
EXTERNAL;

FUNCTION rtGetStringA(buffer : STRING; maxchars : INTEGER; title: STRING;
                      reqinfo : rtReqInfoPtr; taglist : ADDRESS): INTEGER;
EXTERNAL;

FUNCTION rtGetLongA (VAR longptr : INTEGER; title : STRING; reqinfo : rtReqInfoPtr;
                     taglist: ADDRESS): INTEGER;
EXTERNAL;

FUNCTION rtFontRequestA(fontreq : rtFontRequesterPtr; title : STRING;
                        taglist : ADDRESS): BOOLEAN;
EXTERNAL;

FUNCTION rtPaletteRequestA (title : STRING; reqinfo : rtReqInfoPtr;
                            taglist : ADDRESS): INTEGER;
EXTERNAL;

FUNCTION rtReqHandlerA(handlerinfo : rtHandlerInfoPtr; sigs : INTEGER;
                       taglist : ADDRESS): INTEGER;
EXTERNAL;

PROCEDURE rtSetWaitPointer (win: WindowPtr);
EXTERNAL;

FUNCTION rtGetVScreenSize(scr : ScreenPtr ; VAR width, height : INTEGER): INTEGER;
EXTERNAL;

PROCEDURE rtSetReqPosition(reqpos : INTEGER; newwin : NewWindowPtr;
                           scr : ScreenPtr ; win : WindowPtr);
EXTERNAL;

PROCEDURE rtSpread(VAR posarray, sizearray : INTEGER; length, min, max, num : INTEGER);
EXTERNAL;

PROCEDURE rtScreenToFrontSafely (scr: ScreenPtr);
EXTERNAL;

FUNCTION rtScreenModeRequestA(screenmodereq : rtScreenModeRequesterPtr;
                              title : STRING; taglist : ADDRESS): INTEGER;
EXTERNAL;

PROCEDURE rtCloseWindowSafely (win: WindowPtr);
EXTERNAL;

FUNCTION rtLockWindow (win: WindowPtr): ADDRESS;
EXTERNAL;

PROCEDURE rtUnlockWindow(win : WindowPtr; winlock : ADDRESS);
EXTERNAL;

{ some extra functions to open and close the lib }

FUNCTION OpenReqToolsLib(vers : Integer): Boolean;
external;

PROCEDURE CloseReqToolsLib;
external;


{
   This are varargs functions to use with PCQ Pascal vers. 2.0 and above
}
     



{$C+}
FUNCTION rtAllocRequest(TheType : INTEGER; ...): ADDRESS;
EXTERNAL;

FUNCTION rtChangeReqAttr(req : ADDRESS; ...): INTEGER;
EXTERNAL;

FUNCTION rtFileRequest(filereq : rtFileRequesterPtr; filename: STRING;
                        title: STRING; ...): ADDRESS;
EXTERNAL;

FUNCTION rtFontRequest(fontreq : rtFontRequesterPtr; title: STRING; ...): BOOLEAN;
EXTERNAL;

FUNCTION rtGetLong(VAR longptr : INTEGER; title: STRING; reqinfo : rtReqInfoPtr; ...): INTEGER;
EXTERNAL;

FUNCTION rtGetString(buffer : STRING; maxchars : INTEGER; title: STRING;
                      reqinfo : rtReqInfoPtr; ...): INTEGER;
EXTERNAL;

FUNCTION rtPaletteRequest(title: STRING; reqinfo : rtReqInfoPtr; ...): INTEGER;
EXTERNAL;

FUNCTION rtEZRequest(bodyfmt , gadfmt : STRING; reqinfo : rtReqInfoPtr;
                     taglist : ADDRESS; ...): INTEGER;
EXTERNAL;

FUNCTION rtEZRequestTags(bodyfmt , gadfmt : STRING; reqinfo : rtReqInfoPtr;
                     argarray : ADDRESS; ...): INTEGER;
EXTERNAL;

FUNCTION rtReqHandler(handlerinfo : rtHandlerInfoPtr; sigs: INTEGER; ...): INTEGER;
EXTERNAL;

FUNCTION rtScreenModeRequest(screenmodereq : rtScreenModeRequesterPtr;
                             title : STRING; ...): INTEGER;
EXTERNAL;
{$C-}










