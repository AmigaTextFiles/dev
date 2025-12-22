;
; ** $VER: asl.h 38.5 (5.1.93)
; ** Includes Release 40.15
; **
; ** ASL library structures and constants
; **
; ** (C) Copyright 1989-1993 Commodore-Amiga Inc.
; ** (C) Copyright 1989-1990 Charlie Heath
; ** All Rights Reserved
;

; ***************************************************************************


IncludePath   "PureInclude:"
XIncludeFile "exec/types.pb"
XIncludeFile "exec/nodes.pb"
XIncludeFile "utility/tagitem.pb"
XIncludeFile "workbench/startup.pb"
XIncludeFile "graphics/text.pb"
XIncludeFile "graphics/displayinfo.pb"

; ***************************************************************************


;#AslName = "asl\library"
#ASL_TB = (#TAG_USER+$80000)


; ***************************************************************************


;  Types of requesters known to ASL, used as arguments to AllocAslRequest()
#ASL_FileRequest       = 0
#ASL_FontRequest       = 1
#ASL_ScreenModeRequest = 2


; ****************************************************************************
;  *
;  * ASL File Requester data structures and constants
;  *
;  * This structure must only be allocated by asl.library amd is READ-ONLY!
;  * Control of the various fields is provided via tags when the requester
;  * is created with AllocAslRequest() and when it is displayed via
;  * AslRequest()
;
Structure FileRequester

    fr_Reserved0.b[4]
    *fr_File.b       ;  Contents of File gadget on exit
    *fr_Drawer.b       ;  Contents of Drawer gadget on exit
    fr_Reserved1.b[10]
    fr_LeftEdge.w       ;  Coordinates of requester on exit
    fr_TopEdge.w
    fr_Width.w
    fr_Height.w
    fr_Reserved2.b[2]
    fr_NumArgs.l       ;  Number of files selected
    *fr_ArgList.WBArg       ;  List of files selected
    *fr_UserData.l       ;  You can store your own data here
    fr_Reserved3.b[8]
    *fr_Pattern.b       ;  Contents of Pattern gadget on exit
EndStructure

;  File requester tag values, used by AllocAslRequest() and AslRequest()

;  Window control
#ASLFR_Window       = #ASL_TB+2  ;  Parent window
#ASLFR_Screen       = #ASL_TB+40  ;  Screen to open on if no window
#ASLFR_PubScreenName   = #ASL_TB+41  ;  Name of public screen
#ASLFR_PrivateIDCMP    = #ASL_TB+42  ;  Allocate private IDCMP?
#ASLFR_IntuiMsgFunc    = #ASL_TB+70  ;  Function to handle IntuiMessages
#ASLFR_SleepWindow     = #ASL_TB+43  ;  Block input in ASLFR_Window?
#ASLFR_UserData       = #ASL_TB+52  ;  What to put in fr_UserData

;  Text display
#ASLFR_TextAttr       = #ASL_TB+51  ;  Text font to use for gadget text
#ASLFR_Locale       = #ASL_TB+50  ;  Locale ASL should use for text
#ASLFR_TitleText       = #ASL_TB+1  ;  Title of requester
#ASLFR_PositiveText    = #ASL_TB+18  ;  Positive gadget text
#ASLFR_NegativeText    = #ASL_TB+19  ;  Negative gadget text

;  Initial settings
#ASLFR_InitialLeftEdge = #ASL_TB+3  ;  Initial requester coordinates
#ASLFR_InitialTopEdge  = #ASL_TB+4
#ASLFR_InitialWidth    = #ASL_TB+5  ;  Initial requester dimensions
#ASLFR_InitialHeight   = #ASL_TB+6
#ASLFR_InitialFile     = #ASL_TB+8  ;  Initial contents of File gadget
#ASLFR_InitialDrawer   = #ASL_TB+9  ;  Initial contents of Drawer gadg.
#ASLFR_InitialPattern  = #ASL_TB+10  ;  Initial contents of Pattern gadg.

;  Options
#ASLFR_Flags1       = #ASL_TB+20  ;  Option flags
#ASLFR_Flags2       = #ASL_TB+22  ;  Additional option flags
#ASLFR_DoSaveMode      = #ASL_TB+44  ;  Being used for saving?
#ASLFR_DoMultiSelect   = #ASL_TB+45  ;  Do multi-select?
#ASLFR_DoPatterns      = #ASL_TB+46  ;  Display a Pattern gadget?

;  Filtering
#ASLFR_DrawersOnly     = #ASL_TB+47  ;  Don't display files?
#ASLFR_FilterFunc      = #ASL_TB+49  ;  Function to filter files
#ASLFR_RejectIcons     = #ASL_TB+60  ;  Display .info files?
#ASLFR_RejectPattern   = #ASL_TB+61  ;  Don't display files matching pat
#ASLFR_AcceptPattern   = #ASL_TB+62  ;  Accept only files matching pat
#ASLFR_FilterDrawers   = #ASL_TB+63  ;  Also filter drawers with patterns
#ASLFR_HookFunc       = #ASL_TB+7  ;  Combined callback function

;  Flag bits for the ASLFR_Flags1 tag
#FRB_FILTERFUNC    = 7
#FRB_INTUIFUNC    = 6
#FRB_DOSAVEMODE    = 5
#FRB_PRIVATEIDCMP   = 4
#FRB_DOMULTISELECT  = 3
#FRB_DOPATTERNS    = 0

#FRF_FILTERFUNC    = (1  <<  #FRB_FILTERFUNC)
#FRF_INTUIFUNC    = (1  <<  #FRB_INTUIFUNC)
#FRF_DOSAVEMODE    = (1  <<  #FRB_DOSAVEMODE)
#FRF_PRIVATEIDCMP   = (1  <<  #FRB_PRIVATEIDCMP)
#FRF_DOMULTISELECT  = (1  <<  #FRB_DOMULTISELECT)
#FRF_DOPATTERNS    = (1  <<  #FRB_DOPATTERNS)

;  Flag bits for the ASLFR_Flags2 tag
#FRB_DRAWERSONLY    = 0
#FRB_FILTERDRAWERS  = 1
#FRB_REJECTICONS    = 2

#FRF_DRAWERSONLY    = (1  <<  #FRB_DRAWERSONLY)
#FRF_FILTERDRAWERS  = (1  <<  #FRB_FILTERDRAWERS)
#FRF_REJECTICONS    = (1  <<  #FRB_REJECTICONS)


; ****************************************************************************
;  *
;  * ASL Font Requester data structures and constants
;  *
;  * This structure must only be allocated by asl.library amd is READ-ONLY!
;  * Control of the various fields is provided via tags when the requester
;  * is created with AllocAslRequest() and when it is displayed via
;  * AslRequest()
;
Structure FontRequester

    fo_Reserved0.b[8]
    fo_Attr.TextAttr  ;  Returned TextAttr
    fo_FrontPen.b ;  Returned front pen
    fo_BackPen.b ;  Returned back pen
    fo_DrawMode.b ;  Returned drawing mode
    fo_Reserved1.b
    *fo_UserData.l ;  You can store your own data here
    fo_LeftEdge.w ;  Coordinates of requester on exit
    fo_TopEdge.w
    fo_Width.w
    fo_Height.w
    fo_TAttr.TTextAttr  ;  Returned TTextAttr
EndStructure

;  Font requester tag values, used by AllocAslRequest() and AslRequest()

;  Window control
#ASLFO_Window       = #ASL_TB+2  ;  Parent window
#ASLFO_Screen       = #ASL_TB+40  ;  Screen to open on if no window
#ASLFO_PubScreenName   = #ASL_TB+41  ;  Name of public screen
#ASLFO_PrivateIDCMP    = #ASL_TB+42  ;  Allocate private IDCMP?
#ASLFO_IntuiMsgFunc    = #ASL_TB+70  ;  Function to handle IntuiMessages
#ASLFO_SleepWindow     = #ASL_TB+43  ;  Block input in ASLFO_Window?
#ASLFO_UserData       = #ASL_TB+52  ;  What to put in fo_UserData

;  Text display
#ASLFO_TextAttr       = #ASL_TB+51  ;  Text font to use for gadget text
#ASLFO_Locale       = #ASL_TB+50  ;  Locale ASL should use for text
#ASLFO_TitleText       = #ASL_TB+1  ;  Title of requester
#ASLFO_PositiveText    = #ASL_TB+18  ;  Positive gadget text
#ASLFO_NegativeText    = #ASL_TB+19  ;  Negative gadget text

;  Initial settings
#ASLFO_InitialLeftEdge = #ASL_TB+3  ;  Initial requester coordinates
#ASLFO_InitialTopEdge  = #ASL_TB+4
#ASLFO_InitialWidth    = #ASL_TB+5  ;  Initial requester dimensions
#ASLFO_InitialHeight   = #ASL_TB+6
#ASLFO_InitialName     = #ASL_TB+10  ;  Initial contents of Name gadget
#ASLFO_InitialSize     = #ASL_TB+11  ;  Initial contents of Size gadget
#ASLFO_InitialStyle    = #ASL_TB+12  ;  Initial font style
#ASLFO_InitialFlags    = #ASL_TB+13  ;  Initial font flags for TextAttr
#ASLFO_InitialFrontPen = #ASL_TB+14  ;  Initial front pen
#ASLFO_InitialBackPen  = #ASL_TB+15  ;  Initial back pen
#ASLFO_InitialDrawMode = #ASL_TB+59  ;  Initial draw mode

;  Options
#ASLFO_Flags       = #ASL_TB+20  ;  Option flags
#ASLFO_DoFrontPen      = #ASL_TB+44  ;  Display Front color selector?
#ASLFO_DoBackPen       = #ASL_TB+45  ;  Display Back color selector?
#ASLFO_DoStyle       = #ASL_TB+46  ;  Display Style checkboxes?
#ASLFO_DoDrawMode      = #ASL_TB+47  ;  Display DrawMode cycle gadget?

;  Filtering
#ASLFO_FixedWidthOnly  = #ASL_TB+48  ;  Only allow fixed-width fonts?
#ASLFO_MinHeight       = #ASL_TB+16  ;  Minimum font height to display
#ASLFO_MaxHeight       = #ASL_TB+17  ;  Maximum font height to display
#ASLFO_FilterFunc      = #ASL_TB+49  ;  Function to filter fonts
#ASLFO_HookFunc       = #ASL_TB+7  ;  Combined callback function
#ASLFO_MaxFrontPen     = #ASL_TB+66  ;  Max # of colors in front palette
#ASLFO_MaxBackPen      = #ASL_TB+67  ;  Max # of colors in back palette

;  Custom additions
#ASLFO_ModeList       = #ASL_TB+21  ;  Substitute list for drawmodes
#ASLFO_FrontPens       = #ASL_TB+64  ;  Color table for front pen palette
#ASLFO_BackPens       = #ASL_TB+65  ;  Color table for back pen palette

;  Flag bits for ASLFO_Flags tag
#FOB_DOFRONTPEN    = 0
#FOB_DOBACKPEN    = 1
#FOB_DOSTYLE    = 2
#FOB_DODRAWMODE    = 3
#FOB_FIXEDWIDTHONLY = 4
#FOB_PRIVATEIDCMP   = 5
#FOB_INTUIFUNC    = 6
#FOB_FILTERFUNC    = 7

#FOF_DOFRONTPEN    = (1  <<  #FOB_DOFRONTPEN)
#FOF_DOBACKPEN    = (1  <<  #FOB_DOBACKPEN)
#FOF_DOSTYLE    = (1  <<  #FOB_DOSTYLE)
#FOF_DODRAWMODE    = (1  <<  #FOB_DODRAWMODE)
#FOF_FIXEDWIDTHONLY = (1  <<  #FOB_FIXEDWIDTHONLY)
#FOF_PRIVATEIDCMP   = (1  <<  #FOB_PRIVATEIDCMP)
#FOF_INTUIFUNC    = (1  <<  #FOB_INTUIFUNC)
#FOF_FILTERFUNC    = (1  <<  #FOB_FILTERFUNC)


; ****************************************************************************
;  *
;  * ASL Screen Mode Requester data structures and constants
;  *
;  * This structure must only be allocated by asl.library and is READ-ONLY!
;  * Control of the various fields is provided via tags when the requester
;  * is created with AllocAslRequest() and when it is displayed via
;  * AslRequest()
;
Structure ScreenModeRequester

    sm_DisplayID.l    ;  Display mode ID
    sm_DisplayWidth.l    ;  Width of display in pixels
    sm_DisplayHeight.l    ;  Height of display in pixels
    sm_DisplayDepth.w    ;  Number of bit-planes of display
    sm_OverscanType.w    ;  Type of overscan of display
    sm_AutoScroll.w    ;  Display should auto-scroll?

    sm_BitMapWidth.l    ;  Used to create your own BitMap
    sm_BitMapHeight.l

    sm_LeftEdge.w     ;  Coordinates of requester on exit
    sm_TopEdge.w
    sm_Width.w
    sm_Height.w

    sm_InfoOpened.w    ;  Info window opened on exit?
    sm_InfoLeftEdge.w    ;  Last coordinates of Info window
    sm_InfoTopEdge.w
    sm_InfoWidth.w
    sm_InfoHeight.w

    *sm_UserData.l     ;  You can store your own data here
EndStructure

;  An Exec list of custom modes can be added to the list of available modes.
;  * The DimensionInfo structure must be completely initialized, including the
;  * Header. See <graphics/displayinfo.h>. Custom mode ID's must be in the range
;  * 0xFFFF0000..0xFFFFFFFF. Regular properties which apply to your custom modes
;  * can be added in the dn_PropertyFlags field. Custom properties are not
;  * allowed.
;
Structure DisplayMode

    dm_Node.Node       ;  see ln_Name
    dm_DimensionInfo.DimensionInfo    ;  mode description
    dm_PropertyFlags.l    ;  applicable properties
EndStructure

;  ScreenMode requester tag values, used by AllocAslRequest() and AslRequest()

;  Window control
#ASLSM_Window       = #ASL_TB+2  ;  Parent window
#ASLSM_Screen       = #ASL_TB+40  ;  Screen to open on if no window
#ASLSM_PubScreenName   = #ASL_TB+41  ;  Name of public screen
#ASLSM_PrivateIDCMP    = #ASL_TB+42  ;  Allocate private IDCMP?
#ASLSM_IntuiMsgFunc    = #ASL_TB+70  ;  Function to handle IntuiMessages
#ASLSM_SleepWindow     = #ASL_TB+43  ;  Block input in ASLSM_Window?
#ASLSM_UserData       = #ASL_TB+52  ;  What to put in sm_UserData

;  Text display
#ASLSM_TextAttr       = #ASL_TB+51  ;  Text font to use for gadget text
#ASLSM_Locale       = #ASL_TB+50  ;  Locale ASL should use for text
#ASLSM_TitleText       = #ASL_TB+1  ;  Title of requester
#ASLSM_PositiveText    = #ASL_TB+18  ;  Positive gadget text
#ASLSM_NegativeText    = #ASL_TB+19  ;  Negative gadget text

;  Initial settings
#ASLSM_InitialLeftEdge = #ASL_TB+3  ;  Initial requester coordinates
#ASLSM_InitialTopEdge  = #ASL_TB+4
#ASLSM_InitialWidth    = #ASL_TB+5  ;  Initial requester dimensions
#ASLSM_InitialHeight   = #ASL_TB+6
#ASLSM_InitialDisplayID    = #ASL_TB+100 ;  Initial display mode id
#ASLSM_InitialDisplayWidth  = #ASL_TB+101 ;  Initial display width
#ASLSM_InitialDisplayHeight = #ASL_TB+102 ;  Initial display height
#ASLSM_InitialDisplayDepth  = #ASL_TB+103 ;  Initial display depth
#ASLSM_InitialOverscanType  = #ASL_TB+104 ;  Initial type of overscan
#ASLSM_InitialAutoScroll    = #ASL_TB+105 ;  Initial autoscroll setting
#ASLSM_InitialInfoOpened    = #ASL_TB+106 ;  Info wndw initially opened?
#ASLSM_InitialInfoLeftEdge  = #ASL_TB+107 ;  Initial Info window coords.
#ASLSM_InitialInfoTopEdge   = #ASL_TB+108

;  Options
#ASLSM_DoWidth       = #ASL_TB+109  ;  Display Width gadget?
#ASLSM_DoHeight       = #ASL_TB+110  ;  Display Height gadget?
#ASLSM_DoDepth       = #ASL_TB+111  ;  Display Depth gadget?
#ASLSM_DoOverscanType  = #ASL_TB+112  ;  Display Overscan Type gadget?
#ASLSM_DoAutoScroll    = #ASL_TB+113  ;  Display AutoScroll gadget?

;  Filtering
#ASLSM_PropertyFlags   = #ASL_TB+114  ;  Must have these Property flags
#ASLSM_PropertyMask    = #ASL_TB+115  ;  Only these should be looked at
#ASLSM_MinWidth       = #ASL_TB+116  ;  Minimum display width to allow
#ASLSM_MaxWidth       = #ASL_TB+117  ;  Maximum display width to allow
#ASLSM_MinHeight       = #ASL_TB+118  ;  Minimum display height to allow
#ASLSM_MaxHeight       = #ASL_TB+119  ;  Maximum display height to allow
#ASLSM_MinDepth       = #ASL_TB+120  ;  Minimum display depth
#ASLSM_MaxDepth       = #ASL_TB+121  ;  Maximum display depth
#ASLSM_FilterFunc      = #ASL_TB+122  ;  Function to filter mode id's

;  Custom additions
#ASLSM_CustomSMList    = #ASL_TB+123  ;  Exec list of struct DisplayMode
