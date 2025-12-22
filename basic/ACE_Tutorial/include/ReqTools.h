{Date: Wed, 9 Mar 1994 09:18:02 +1100
From: Nils_Sjoholm@augs.se (Nils Sjoholm)
To: Multiple recipients of list <ace@appcomp.utas.edu.au>
Subject: reqtools.h }

{*** reqtools.h FOR ACE 2.0 ***}

CONST REQTOOLSVERSION = 38&

CONST RTPREF_FILEREQ=0&
CONST RTPREF_FONTREQ=1&
CONST RTPREF_PALETTEREQ=2&
CONST RTPREF_SCREENMODEREQ=3&
CONST RTPREF_VOLUMEREQ=4&
CONST RTPREF_OTHERREQ=5&
CONST RTPREF_NR_OF_REQ=6&

STRUCT ReqDefaults
    LONGINT     rtSize
    LONGINT     ReqPos
    SHORTINT    LeftOffset
    SHORTINT    TopOffset
    SHORTINT    MinEntries
    SHORTINT    MaxEntries
END STRUCT

STRUCT ReqToolsPrefs
    LONGINT     PrefsSize
    STRING      PrefsSemaphore SIZE 46
    LONGINT     Flags
    STRING      ReqDefaults SIZE RTPREF_NR_OF_REQ
END STRUCT

CONST RTPREFS_SIZE=10
CONST RTPRB_DIRSFIRST = 0&
CONST RTPRF_DIRSFIRST = 1&
CONST RTPRB_DIRSMIXED = 1&
CONST RTPRF_DIRSMIXED = 2&
CONST RTPRB_IMMSORT   = 2&
CONST RTPRF_IMMSORT   = 4&
CONST RTPRB_NOSCRTOFRONT = 3&
CONST RTPRF_NOSCRTOFRONT = 8&
CONST RTPRB_NOLED     = 4&
CONST RTPRF_NOLED     = 16&

STRUCT ReqToolsBase
    STRING      lib SIZE 34
    BYTE        RTFlags
    STRING      pad SIZE 3
    ADDRESS     SegList
    ADDRESS     IntuitionBase
    ADDRESS     GfxBase
    ADDRESS     GadToolsBase
    ADDRESS     UtilityBase
    SHORTINT    RealOpenCnt
    SHORTINT    AvailFontsLock
    STRING      AvailFontsHeader SIZE 5
    LONGINT     FontAssignType
    ADDRESS     FontAssignLock      '.. OR LONGINT?
    STRING      AssignList  SIZE 4
    STRING      ReqToolsPrefs SIZE 60
    SHORTINT    prefspad
END STRUCT

CONST RT_FILEREQ=0&
CONST RT_REQINFO=1&
CONST RT_FONTREQ=2&
CONST RT_SCREENMODEREQ=3&

struct rtFileRequester
    LONGINT     ReqPos
    SHORTINT     LeftOffset
    SHORTINT     TopOffset
    LONGINT     Flags
    LONGINT     Private
    LONGINT     Dir                 '..ADDRESS ?
    LONGINT     MatchPat            '..ADDRESS ?
    ADDRESS     DeafaultFont
    LONGINT     WaitPointer
    LONGINT     LockWindow
    LONGINT     ShareIDCMP
    ADDRESS     IntuiMsgFunc
    SHORTINT    Reserved1
    SHORTINT    Reserved2
    SHORTINT    Reserved3
    SHORTINT    ReqHeight
end struct

STRUCT rtFileList
    ADDRESS     rtNext          '..?
    LONGINT     StrLen
    LONGINT     rtName            '..ADDRESS ?
END STRUCT

STRUCT rtVolumeEntry
    LONGINT     Type
    LONGINT     rtName            '..ADDRESS ?
END STRUCT

STRUCT rtFontRequester
    LONGINT     ReqPos
    SHORTINT    LeftOffset
    SHORTINT    TopOffset
    LONGINT     Flags
    ADDRESS     Hook     '.. don't use
    STRING      Attr SIZE 8
    ADDRESS     DefaultFont        '..?
    LONGINT     WaitPointer
    LONGINT     LockWindow
    LONGINT     ShareIDCMP
    ADDRESS     IntuiMsgFunc
    SHORTINT    reserved1
    SHORTINT    reserved2
    SHORTINT    reserved3
    SHORTINT    ReqHeight
END STRUCT

STRUCT rtScreenModeRequester
    LONGINT     ReqPos
    SHORTINT    LeftOffste
    SHORTINT    TopOffset
    LONGINT     Flags
    LONGINT     private1
    LONGINT     DisplayId
    SHORTINT    DisplayWidth
    SHORTINT    DisplayHeight
    ADDRESS     DefaultFont       '..?
    LONGINT     WaitPointer
    LONGINT     LockWindow
    LONGINT     ShareIDCMP
    ADDRESS     IntuiMsgFunc
    SHORTINT    reserved1
    SHORTINT    reserved2
    SHORTINT    reserved3
    SHORTINT    ReqHeight
    SHORTINT    DisplatDepth
    SHORTINT    OverscanType
    LONGINT     AutoScroll
END STRUCT

struct rtReqInfo
    LONGINT     ReqPos
    SHORTINT    LeftOffset
    SHORTINT    TopOffset
    LONGINT     ReqWidth
    ADDRESS     ReqTitle          '..LONGINT ?
    LONGINT     Flags
    ADDRESS     DefaultFont        '..?
    LONGINT     WaitPointer
    LONGINT     LockWindow
    LONGINT     ShareIDCMP
    ADDRESS     IntuiMsgFunc
end struct

STRUCT rtHandlerInfo
    LONGINT     private1
    LONGINT     WaitMask
    LONGINT     DoNotWait
END STRUCT

{*** tags understood by most requester functions ***}
CONST CALL_HANDLER=&H80000000
CONST RT_TagBase = &H80000000
CONST RT_Window = &H80000001
CONST RT_IDCMPFlags = &H80000002
CONST RT_ReqPos = &H80000003
CONST RT_LeftOffset = &H80000004
CONST RT_TopOffset = &H80000005
CONST RT_PubScrName = &H80000006
CONST RT_Screen = &H80000007
CONST RT_ReqHandler = &H80000008
CONST RT_DefaultFont = &H80000009
CONST RT_WaitPointer = &H8000000A
CONST RT_Underscore = &H8000000B
CONST RT_ShareIDCMP = &H8000000C
CONST RT_LockWindow = &H8000000D
CONST RT_ScreenToFront = &H8000000E
CONST RT_TextAttr = &H8000000F
CONST RT_IntuiMsgFunc = &H80000010
CONST RT_Locale = &H80000011
