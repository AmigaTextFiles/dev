{ Unit:      Reqtools
  ~~~~~
  Version:   V0.06 / 08.08.94
  ~~~~~~~~
  Meaning:   Reqtools-Interface for KickPascal2.12/OS2
  ~~~~~~~    or MaxonPASCAL3 (compile it)

             for Reqtools.library V38 (last 2.2a / V38.1194)

  Copyright: © by the cooperation of
  ~~~~~~~~~~
               PackMAN (Falk Zühlsdorff)

                and

               Janosh (Jan Stötzer)

               for all KP/MP3 Interface / Demos / Includes / Units

             This version is FREEWARE (see © Reqtools.librray)

             © Nico François for the reqtools.library


  Author:    all OS2 versions are  written by PackMAN
  ~~~~~~~
  Address:   PackMAN
  ~~~~~~~~   c/o Falk Zühlsdorff
             Lindenberg 66
             98693 Ilmenau/Thuringia

             Germany

  Comment:   only OS2 or higher now
  ~~~~~~~~                                                           }

{--------------------------------------------------------------------}
UNIT REQTOOLS;

INTERFACE

USES INTUITION;

CONST
  REQTOOLSNAME = 'reqtools.library';
  REQTOOLSVERSION = 38;

TYPE
  BPTR     = long;
  p_ReqToolsBase = ^ReqToolsBase;
  ReqToolsBase = Record
                   Lib_Node : p_Library;
                   Flags    : Byte;
                   Pad      : Array[0..3] of Byte;
                   SegList  : BPTR;
                   IntuitionBase: p_Library;
                   GfxBase  : p_Library;
                   DOSBase  : p_Library;
                   GadToolsBase : p_Library;
                   UtilityBase  : p_Library;
                 END;

CONST

  RT_FILEREQ = 0;
  RT_REQINFO = 1;
  RT_FONTREQ = 2;
  RT_SCREENMODEREQ = 3;

TYPE

  p_rtFileRequester = ^rtFileRequester;
  rtFileRequester   = record
                        ReqPos      : long;
                        LeftOffset  : integer;
                        TopOffset   : integer;
                        Flags       : long;
                        Hook        : p_Hook;
                        Dir         : str;
                        MatchPat    : str;
                        DefaultFont : p_TextFont;
                        WaitPointer : long;
                        LockWindow  : long;
                        ShareIDCMP  : long;
                        IntuiMsgFunc: p_Hook;
                        reserved1   : integer;
                        reserved2   : integer;
                        reserved3   : integer;
                        ReqHeight   : integer;
                      END;

  p_rtFileList = ^rtFileList;
  rtFileList = record
                 Next    : p_rtFileList;
                 StrLen  : long;
                 Name    : str;
               END;

  p_rtFontRequester = ^rtFontRequester;
  rtFontRequester = record
                      ReqPos        : long;
                      LeftOffset    : integer;
                      TopOffset     : integer;
                      Flags         : long;
                      Hook          : p_Hook;
                      Attr          : TextAttr;
                      DefaultFont   : p_TextFont;
                      WaitPointer   : long;
                      LockWindow    : long;
                      ShareIDCMP    : long;
                      IntuiMsgFunc  : p_Hook;
                      reserved1     : integer;
                      reserved2     : integer;
                      reserved3     : integer;
                      ReqHeight     : integer;
                    END;

{ structure _MUST_ be allocated with rtAllocRequest() }

  p_rtScreenModeRequester = ^rtScreenModeRequester;
  rtScreenModeRequester = Record
                            ReqPos      : long;
                            LeftOffset  : integer;
                            TopOffset   : integer;
                            Flags       : long;
                            private1    : long;
                            DisplayID   : long;  { READ ONLY! }
                            DisplayWidth: integer;    { READ ONLY! }
                            DisplayHeight: integer;   { READ ONLY! }
                            DefaultFont : p_TextFont;
                            WaitPointer : long;
                            LockWindow  : long;
                            ShareIDCMP  : long;
                            IntuiMsgFunc: p_Hook;
                            reserved1   : integer;
                            reserved2   : integer;
                            reserved3   : integer;
                            ReqHeight   : integer;    { READ ONLY!  Use RTSC_Height tag! }
                            DisplayDepth: integer;    { READ ONLY! }
                            OverscanType: integer;    { READ ONLY! }
                            AutoScroll  : long;  { READ ONLY! }
                            { Private data follows! HANDS OFF }
                          END;

{***********************
*                      *
*    Requester Info    *
*                      *
***********************}

{ for rtEZRequestA(), rtGetLongA(), rtGetStringA() and rtPaletteRequestA(),
   _MUST_ be allocated with rtAllocRequest() }

  p_rtReqInfo = ^rtReqInfo;
  rtReqInfo = Record
                ReqPos      : long;
                LeftOffset  : integer;
                TopOffset   : integer;
                Width       : long;       { not for rtEZRequestA() }
                ReqTitle    : str;        { currently only for rtEZRequestA() }
                Flags       : long;       { currently only for rtEZRequestA() }
                DefaultFont : p_TextFont; { currently only for rtPaletteRequestA() }
                WaitPointer : long;
                { (V38) }
                LockWindow  : long;
                ShareIDCMP  : long;
                IntuiMsgFunc: p_Hook;
                { structure may be extended in future }
              END;

{***********************
*                      *
*     Handler Info     *
*                      *
***********************}

{ for rtReqHandlerA(), will be allocated for you when you use
   the RT_ReqHandler tag, never try to allocate this yourself! }

  p_rtHandlerInfo = ^rtHandlerInfo;
  rtHandlerInfo = record
                    private1  : long;
                    WaitMask  : long;
                    DoNotWait : long;
                    { Private data follows, HANDS OFF }
                  END;

CONST

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
RTSC_Flags         = RTFI_Flags; { various flags (see below) }
RTSC_Height        = RTFI_Height;{ suggested height of screenmode requester }
RTSC_OkText        = RTFI_OkText;{ replacement text for 'Ok' gadget (max 6 chars) }
RTSC_PropertyFlags = $8000005A;  { property flags (see also RTSC_PropertyMask) }
RTSC_PropertyMask  = $8000005B;  { property mask - default all bits in RTSC_PropertyFlags considered }
RTSC_MinWidth      = $8000005C;  { minimum display width allowed }
RTSC_MaxWidth      = $8000005D;  { maximum display width allowed }
RTSC_MinHeight     = $8000005E;  { minimum display height allowed }
RTSC_MaxHeight     = $8000005F;  { maximum display height allowed }
RTSC_MinDepth      = $80000060;  { minimum display depth allowed }
RTSC_MaxDepth      = $80000061;  { maximum display depth allowed }
RTSC_FilterFunc    = RTFI_FilterFunc;{ call this hook for every display mode id }


{ *** tags for rtChangeReqAttrA *** }
RTFI_Dir = $80000032;           { file requester - set directory }
RTFI_MatchPat = $80000033;      { file requester - set wildcard pattern }
RTFI_AddEntry = $80000034;      { file requester - add a file or directory to the buffer }
RTFI_RemoveEntry = $80000035;   { file requester - remove a file or directory from the buffer }
RTFO_FontName = $8000003F;      { font requester - set font name of selected font }
RTFO_FontHeight = $80000040;    { font requester - set font size }
RTFO_FontStyle = $80000041;     { font requester - set font style }
RTFO_FontFlags = $80000042;     { font requester - set font flags }
RTSC_ModeFromScreen = $80000050;{ (V38) screenmode requester - get display attributes from screen }
RTSC_DisplayID = $80000051;     { (V38) screenmode requester - set display mode id (32-bit extended) }
RTSC_DisplayWidth = $80000052;  { (V38) screenmode requester - set display width }
RTSC_DisplayHeight = $80000053; { (V38) screenmode requester - set display height }
RTSC_DisplayDepth = $80000054;  { (V38) screenmode requester - set display depth }
RTSC_OverscanType = $80000055;  { (V38) screenmode requester - set overscan TYPE, 0 for regular size }
RTSC_AutoScroll = $80000056;    { (V38) screenmode requester - set autoscroll }


{ *** tags for rtPaletteRequestA *** }
{ initially selected color - default 1 }
    RTPA_Color = $80000046;

{ *** tags for rtReqHandlerA *** }
{ END requester by software control, set tagdata to REQ_CANCEL, REQ_OK or
  in case of rtEZRequest to the return value }
    RTRH_EndRequest = $800003C;

{ *** tags for rtAllocRequestA *** }
{ no tags defined yet }

{************
* RT_ReqPos *
************}
  REQPOS_POINTER = 0;
  REQPOS_CENTERWIN = 1;
  REQPOS_CENTERSCR = 2;
  REQPOS_TOPLEFTWIN = 3;
  REQPOS_TOPLEFTSCR = 4;

{******************
* RTRH_EndRequest *
******************}
  REQ_CANCEL = 0;
  REQ_OK = 1;

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
  FREQB_SAVE = 1;
  FREQF_SAVE = 2;
  FREQB_NOFILES = 3;
  FREQF_NOFILES = 8;
  FREQB_PATGAD = 4;
  FREQF_PATGAD = 16;
  FREQB_SELECTDIRS = 12;
  FREQF_SELECTDIRS = 4096;

{*****************************************
* flags for RTFO_Flags or fontreq->Flags *
*****************************************}
  FREQB_FIXEDWIDTH = 5;
  FREQF_FIXEDWIDTH = 32;
  FREQB_COLORFONTS = 6;
  FREQF_COLORFONTS = 64;
  FREQB_CHANGEPALETTE = 7;
  FREQF_CHANGEPALETTE = 128;
  FREQB_LEAVEPALETTE = 8;
  FREQF_LEAVEPALETTE = 256;
  FREQB_SCALE = 9;
  FREQF_SCALE = 512;
  FREQB_STYLE = 10;
  FREQF_STYLE = 1024;

{*****************************************************
* (V38) flags for RTSC_Flags or screenmodereq->Flags *
*****************************************************}
  SCREQB_SIZEGADS = 13;
  SCREQF_SIZEGADS = 8192;
  SCREQB_DEPTHGAD = 14;
  SCREQF_DEPTHGAD = 16384;
  SCREQB_NONSTDMODES = 15;
  SCREQF_NONSTDMODES = 32768;
  SCREQB_GUIMODES = 16;
  SCREQF_GUIMODES = 65536;
  SCREQB_AUTOSCROLLGAD = 18;
  SCREQF_AUTOSCROLLGAD = 262144;
  SCREQB_OVERSCANGAD = 19;
  SCREQF_OVERSCANGAD = 524288;

{*****************************************
* flags for RTEZ_Flags or reqinfo->Flags *
*****************************************}
  EZREQB_NORETURNKEY = 0;
  EZREQF_NORETURNKEY = 1;
  EZREQB_LAMIGAQUAL = 1;
  EZREQF_LAMIGAQUAL = 2;
  EZREQB_CENTERTEXT = 2;
  EZREQF_CENTERTEXT = 4;

{***********************************************
* (V38) flags for RTGL_Flags or reqinfo->Flags *
***********************************************}
  GLREQB_CENTERTEXT = EZREQB_CENTERTEXT;
  GLREQF_CENTERTEXT = EZREQF_CENTERTEXT;
  GLREQB_HIGHLIGHTTEXT = 3;
  GLREQF_HIGHLIGHTTEXT = 8;

{***********************************************
* (V38) flags for RTGS_Flags or reqinfo->Flags *
***********************************************}
  GSREQB_CENTERTEXT = EZREQB_CENTERTEXT;
  GSREQF_CENTERTEXT = EZREQF_CENTERTEXT;
  GSREQB_HIGHLIGHTTEXT = GLREQB_HIGHLIGHTTEXT;
  GSREQF_HIGHLIGHTTEXT = GLREQF_HIGHLIGHTTEXT;

{*****************************************
* (V38) flags for RTFI_VolumeRequest tag *
*****************************************}
  VREQB_NOASSIGNS=0;
  VREQF_NOASSIGNS=1;
  VREQB_NODISKS=1;
  VREQF_NODISKS=2;
  VREQB_ALLDISKS=2;
  VREQF_ALLDISKS=4;

{*
   Following things are obsolete in ReqTools V38.
   DON'T USE THESE IN NEW CODE!
*}
  REQHOOK_WILDFILE=0;
  REQHOOK_WILDFONT=1;
  FREQB_DOWILDFUNC=11;
  FREQF_DOWILDFUNC=2048;


{************
* Functions *
************}

TYPE p_long = ^long;

VAR RTBase  : ptr;
    libtest : text;

Library RTBase:
  -30  : function rtAllocRequestA(d0:long,a0:p_TagItem):ptr;
  -36  : procedure rtFreeRequest(a1:ptr);
  -42  : procedure rtFreeReqBuffer(a1:ptr);
  -48  : function rtChangeReqAttr(a1:ptr,a0:p_TagItem):long;
  -54  : function rtFileRequestA(a1:p_rtFileRequester,a2:str,a3:str,a0:p_TagItem):long;
  -60  : procedure rtFreeFileList(a0:p_rtFileList);
  -66  : function rtEZRequestA(a1:str,a2:str,a3:p_rtReqInfo,a4:ptr,a0:p_TagItem):long;
  -72  : function rtGetStringA(a1:str,d0:long,a2:str,a3:p_rtReqInfo,a0:p_TagItem):long;
  -78  : function rtGetLongA(a1:p_long,a2:str,a3:p_rtReqInfo,a0:p_TagItem):long;
 {-84  : function rtInternalGetPasswordA (...) ;
  -90  : function rtInternalEnterPasswordA (...) ;  private Functions !!! }
  -96  : function rtFontRequestA(a1:p_rtFontRequester,a3:str,a0:p_TagItem):boolean;
  -102 : function rtPaletteRequestA(a2:str,a3:p_rtReqInfo,a0:p_TagItem):long;
  -108 : function rtReqHandlerA(a1:p_rtHandlerInfo,d0:long,a0:p_TagItem):long;
  -114 : procedure rtSetWaitPointer(a0:p_Window);
  -120 : function rtGetVScreenSize(a0:p_Screen,a1:p_long,a2:p_long):long;
  -126 : procedure rtSetReqPosition(d0:long,a0:p_NewWindow,a1:p_Screen,a2:p_Window);
  -132 : procedure rtSpread(a0:p_long,a1:p_long,d0:long,d1:long,d2:long,d3:long);
  -138 : procedure rtScreenToFrontSafely(a0:p_Screen);
  -144 : function rtScreenModeRequestA(a1:p_rtScreenModeRequester,a3:str,a0:p_TagItem):boolean;
  -150 : procedure rtCloseWindowSafely(a0:p_Window);
  -156 : function rtLockWindow(a0:p_Window):ptr;
  -162 : procedure rtUnlockWindow(a0:p_Window,a1:ptr);
 {-168 : procedure rtLockPrefs (...) ;
  -174 : procedure rtUnLockPrefs (...) ;  Private Functions !!!  }
END;

FUNCTION  V37:boolean;
PROCEDURE ErrorReq(Tx,Tx2:string;Fenster:p_window);
FUNCTION  OpenReqtools:boolean;

IMPLEMENTATION

FUNCTION V37;
VAR  lib: p_library;
BEGIN
 lib:=sysbase;
 V37:=(lib^.lib_version>=37);
END;

PROCEDURE ErrorReq;
VAR AutoTx1,Autotx2 : IntuiText;
    Autohelp        : boolean;
BEGIN
 Autotx1:=IntuiText(2,0,0,20,10,nil,Tx,NIL);
 Autotx2:=IntuiText(2,0,0,2,3,nil,Tx2,NIL);
 Autohelp:=AutoRequest(Fenster,^AutoTx1,NIL,^Autotx2,0,0,330,80);
END;

FUNCTION OpenReqtools;
BEGIN
 RTBase:=OpenLibrary(REQTOOLSNAME,REQTOOLSVERSION);
 IF RTBase=NIL
  THEN
   BEGIN
    ErrorReq('Can`t find: ReqTools.library (V38)','Sorry',nil);
    OpenReqtools:=false;
   END
  ELSE
   OpenReqtools:=true;
END;

END.


