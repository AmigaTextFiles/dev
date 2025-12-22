;
; ** $VER: monitor.h 39.7 (9.6.92)
; ** Includes Release 40.15
; **
; ** graphics monitorspec definintions
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/semaphores.pb"
XIncludeFile "graphics/gfxnodes.pb"
XIncludeFile "graphics/gfx.pb"

Structure MonitorSpec
    ms_Node.ExtendedNode
    ms_Flags.w
    ratioh.l
    ratiov.l
    total_rows.w
    total_colorclocks.w
    DeniseMaxDisplayColumn.w
    BeamCon0.w
    min_row.w
    *ms_Special.SpecialMonitor
    ms_OpenCount.w
    *ms_transform.l
    *ms_translate.l
    *ms_scale.l
    ms_xoffset.w
    ms_yoffset.w
    ms_LegalView.Rectangle
    *ms_maxoscan.l ;  maximum legal overscan
    *ms_videoscan.l ;  video display overscan
    DeniseMinDisplayColumn.w
    DisplayCompatible.l
    DisplayInfoDataBase.List
    DisplayInfoDataBaseSemaphore.SignalSemaphore
    *ms_MrgCop.l
    *ms_LoadView.l
    *ms_KillView.l
EndStructure

#TO_MONITOR  = 0
#FROM_MONITOR  = 1
#STANDARD_XOFFSET = 9
#STANDARD_YOFFSET = 0

#MSB_REQUEST_NTSC = 0
#MSB_REQUEST_PAL  = 1
#MSB_REQUEST_SPECIAL = 2
#MSB_REQUEST_A2024 = 3
#MSB_DOUBLE_SPRITES = 4
#MSF_REQUEST_NTSC = (1  <<  #MSB_REQUEST_NTSC)
#MSF_REQUEST_PAL  = (1  <<  #MSB_REQUEST_PAL)
#MSF_REQUEST_SPECIAL  = (1  <<  #MSB_REQUEST_SPECIAL)
#MSF_REQUEST_A2024  = (1  <<  #MSB_REQUEST_A2024)
#MSF_DOUBLE_SPRITES  = (1  <<  #MSB_DOUBLE_SPRITES)


;  obsolete, v37 compatible definitions follow
#REQUEST_NTSC  = (1  <<  #MSB_REQUEST_NTSC)
#REQUEST_PAL  = (1  <<  #MSB_REQUEST_PAL)
#REQUEST_SPECIAL  = (1  <<  #MSB_REQUEST_SPECIAL)
#REQUEST_A2024  = (1  <<  #MSB_REQUEST_A2024)

#STANDARD_MONITOR_MASK = ( #REQUEST_NTSC | #REQUEST_PAL )

#STANDARD_NTSC_ROWS = 262
#STANDARD_PAL_ROWS = 312
#STANDARD_COLORCLOCKS = 226
#STANDARD_DENISE_MAX = 455
#STANDARD_DENISE_MIN = 93
#STANDARD_NTSC_BEAMCON = ( $0000 )
;#STANDARD_PAL_BEAMCON = ( DISPLAYPAL )

;#SPECIAL_BEAMCON = ( VARVBLANK | LOLDIS | VARVSYNC | VARHSYNC | VARBEAM | CSBLANK | VSYNCTRUE)

#MIN_NTSC_ROW = 21
#MIN_PAL_ROW = 29
#STANDARD_VIEW_X = $81
#STANDARD_VIEW_Y = $2C
#STANDARD_HBSTRT = $06
#STANDARD_HSSTRT = $0B
#STANDARD_HSSTOP = $1C
#STANDARD_HBSTOP = $2C
#STANDARD_VBSTRT = $0122
#STANDARD_VSSTRT = $02A6
#STANDARD_VSSTOP = $03AA
#STANDARD_VBSTOP = $1066

#VGA_COLORCLOCKS = (#STANDARD_COLORCLOCKS/2)
#VGA_TOTAL_ROWS = (#STANDARD_NTSC_ROWS*2)
#VGA_DENISE_MIN = 59
#MIN_VGA_ROW = 29
#VGA_HBSTRT = $08
#VGA_HSSTRT = $0E
#VGA_HSSTOP = $1C
#VGA_HBSTOP = $1E
#VGA_VBSTRT = $0000
#VGA_VSSTRT = $0153
#VGA_VSSTOP = $0235
#VGA_VBSTOP = $0CCD

;  NOTE: VGA70 definitions are obsolete - a VGA70 monitor has never been
;  * implemented.
;
#VGA70_COLORCLOCKS = (#STANDARD_COLORCLOCKS/2)
#VGA70_TOTAL_ROWS = 449
#VGA70_DENISE_MIN = 59
#MIN_VGA70_ROW = 35
#VGA70_HBSTRT = $08
#VGA70_HSSTRT = $0E
#VGA70_HSSTOP = $1C
#VGA70_HBSTOP = $1E
#VGA70_VBSTRT = $0000
#VGA70_VSSTRT = $02A6
#VGA70_VSSTOP = $0388
#VGA70_VBSTOP = $0F73

;#VGA70_BEAMCON = (#SPECIAL_BEAMCON ^ VSYNCTRUE)

#BROADCAST_HBSTRT = $01
#BROADCAST_HSSTRT = $06
#BROADCAST_HSSTOP = $17
#BROADCAST_HBSTOP = $27
#BROADCAST_VBSTRT = $0000
#BROADCAST_VSSTRT = $02A6
#BROADCAST_VSSTOP = $054C
#BROADCAST_VBSTOP = $1C40
;#BROADCAST_BEAMCON = ( LOLDIS | CSBLANK )
#RATIO_FIXEDPART = 4
#RATIO_UNITY = (1  <<  #RATIO_FIXEDPART)

Structure AnalogSignalInterval
    asi_Start.w
    asi_Stop.w
EndStructure

Structure SpecialMonitor
    spm_Node.ExtendedNode
    spm_Flags.w
    *do_monitor.l
    *reserved1.l
    *reserved2.l
    *reserved3.l
    hblank.AnalogSignalInterval
    vblank.AnalogSignalInterval
    hsync.AnalogSignalInterval
    vsync.AnalogSignalInterval
EndStructure

