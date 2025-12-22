/* $Id: monitor.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/semaphores', 'target/graphics/gfx', 'target/graphics/gfxnodes'
MODULE 'target/hardware/custom', 'target/exec/lists', 'target/exec/types'
{#include <graphics/monitor.h>}
NATIVE {GRAPHICS_MONITOR_H} CONST

NATIVE {DEFAULT_MONITOR_NAME} CONST
#define DEFAULT_MONITOR_NAME default_monitor_name
STATIC default_monitor_name = 'default.monitor'
NATIVE {NTSC_MONITOR_NAME}    CONST
#define NTSC_MONITOR_NAME ntsc_monitor_name
STATIC ntsc_monitor_name    = 'ntsc.monitor'
NATIVE {PAL_MONITOR_NAME}     CONST
#define PAL_MONITOR_NAME pal_monitor_name
STATIC pal_monitor_name     = 'pal.monitor'
NATIVE {VGA_MONITOR_NAME}     CONST
#define VGA_MONITOR_NAME vga_monitor_name
STATIC vga_monitor_name     = 'vga.monitor'

NATIVE {MonitorSpec} OBJECT monitorspec
    {ms_Node}	xln	:xln

    {ms_Flags}	flags	:UINT /* see below */

    {ratioh}	ratioh	:VALUE
    {ratiov}	ratiov	:VALUE
    {total_rows}	total_rows	:UINT
    {total_colorclocks}	total_colorclocks	:UINT
    {DeniseMaxDisplayColumn}	denisemaxdisplaycolumn	:UINT
    {BeamCon0}	beamcon0	:UINT
    {min_row}	min_row	:UINT

    {ms_Special}	special	:PTR TO specialmonitor

    {ms_OpenCount}	opencount	:UINT
    {ms_transform}	transform	:NATIVE {LONG  (*)()} PTR
    {ms_translate}	translate	:NATIVE {LONG  (*)()} PTR
    {ms_scale}	scale	:NATIVE {LONG  (*)()} PTR
    {ms_xoffset}	xoffset	:UINT
    {ms_yoffset}	yoffset	:UINT

    {ms_LegalView}	legalview	:rectangle

    {ms_maxoscan}	maxoscan	:NATIVE {LONG  (*)()} PTR
    {ms_videoscan}	videoscan	:NATIVE {LONG  (*)()} PTR
    {DeniseMinDisplayColumn}	denisemindisplaycolumn	:UINT
    {DisplayCompatible}	displaycompatible	:ULONG

    {DisplayInfoDataBase}	displayinfodatabase	:lh
    {DisplayInfoDataBaseSemaphore}	didbsemaphore	:ss

    {ms_MrgCop}	mrgcop	:NATIVE {LONG (*)()} PTR
    {ms_LoadView}	loadview	:NATIVE {LONG (*)()} PTR
    {ms_KillView}	killview	:NATIVE {LONG (*)()} PTR
ENDOBJECT

/* ms_Flags */
NATIVE {MSB_REQUEST_NTSC}        CONST MSB_REQUEST_NTSC        = 0
NATIVE {MSF_REQUEST_NTSC}    CONST MSF_REQUEST_NTSC    = $1
NATIVE {MSB_REQUEST_PAL}         CONST MSB_REQUEST_PAL         = 1
NATIVE {MSF_REQUEST_PAL}     CONST MSF_REQUEST_PAL     = $2
NATIVE {MSB_REQUEST_SPECIAL}     CONST MSB_REQUEST_SPECIAL     = 2
NATIVE {MSF_REQUEST_SPECIAL} CONST MSF_REQUEST_SPECIAL = $4
NATIVE {MSB_REQUEST_A2024}       CONST MSB_REQUEST_A2024       = 3
NATIVE {MSF_REQUEST_A2024}   CONST MSF_REQUEST_A2024   = $8
NATIVE {MSB_DOUBLE_SPRITES}      CONST MSB_DOUBLE_SPRITES      = 4
NATIVE {MSF_DOUBLE_SPRITES}  CONST MSF_DOUBLE_SPRITES  = $10

NATIVE {STANDARD_MONITOR_MASK} CONST STANDARD_MONITOR_MASK = (MSF_REQUEST_NTSC OR MSF_REQUEST_PAL)

NATIVE {TO_MONITOR}   CONST TO_MONITOR   = 0
NATIVE {FROM_MONITOR} CONST FROM_MONITOR = 1

NATIVE {STANDARD_XOFFSET} CONST STANDARD_XOFFSET = 9
NATIVE {STANDARD_YOFFSET} CONST STANDARD_YOFFSET = 0

NATIVE {STANDARD_NTSC_ROWS}    CONST STANDARD_NTSC_ROWS    = 262
NATIVE {MIN_NTSC_ROW}          CONST MIN_NTSC_ROW          = 21
NATIVE {STANDARD_PAL_ROWS}     CONST STANDARD_PAL_ROWS     = 312
NATIVE {MIN_PAL_ROW}           CONST MIN_PAL_ROW           = 29
NATIVE {STANDARD_NTSC_BEAMCON} CONST STANDARD_NTSC_BEAMCON = $0000
NATIVE {STANDARD_PAL_BEAMCON}  CONST STANDARD_PAL_BEAMCON  = $0020
NATIVE {SPECIAL_BEAMCON}       CONST SPECIAL_BEAMCON       = (VARVBLANK OR VARHSYNC OR VARVSYNC OR VARBEAM OR VSYNCTRUE OR LOLDIS OR CSBLANK)
NATIVE {STANDARD_DENISE_MIN}   CONST STANDARD_DENISE_MIN   = 93
NATIVE {STANDARD_DENISE_MAX}   CONST STANDARD_DENISE_MAX   = 455
NATIVE {STANDARD_COLORCLOCKS}  CONST STANDARD_COLORCLOCKS  = 226
NATIVE {STANDARD_VIEW_X}       CONST STANDARD_VIEW_X       = $81
NATIVE {STANDARD_VIEW_Y}       CONST STANDARD_VIEW_Y       = $2C
NATIVE {STANDARD_HBSTRT}       CONST STANDARD_HBSTRT       = $06
NATIVE {STANDARD_HBSTOP}       CONST STANDARD_HBSTOP       = $2C
NATIVE {STANDARD_HSSTRT}       CONST STANDARD_HSSTRT       = $0B
NATIVE {STANDARD_HSSTOP}       CONST STANDARD_HSSTOP       = $1C
NATIVE {STANDARD_VBSTRT}       CONST STANDARD_VBSTRT       = $0122
NATIVE {STANDARD_VBSTOP}       CONST STANDARD_VBSTOP       = $1066
NATIVE {STANDARD_VSSTRT}       CONST STANDARD_VSSTRT       = $02A6
NATIVE {STANDARD_VSSTOP}       CONST STANDARD_VSSTOP       = $03AA

NATIVE {VGA_COLORCLOCKS} CONST VGA_COLORCLOCKS = (STANDARD_COLORCLOCKS / 2)
NATIVE {VGA_TOTAL_ROWS}  CONST VGA_TOTAL_ROWS  = (STANDARD_NTSC_ROWS * 2)
NATIVE {VGA_DENISE_MIN}  CONST VGA_DENISE_MIN  = 59
NATIVE {MIN_VGA_ROW}     CONST MIN_VGA_ROW     = 29
NATIVE {VGA_HBSTRT}      CONST VGA_HBSTRT      = $08
NATIVE {VGA_HBSTOP}      CONST VGA_HBSTOP      = $1E
NATIVE {VGA_HSSTRT}      CONST VGA_HSSTRT      = $0E
NATIVE {VGA_HSSTOP}      CONST VGA_HSSTOP      = $1C
NATIVE {VGA_VBSTRT}      CONST VGA_VBSTRT      = $0000
NATIVE {VGA_VBSTOP}      CONST VGA_VBSTOP      = $0CCD
NATIVE {VGA_VSSTRT}      CONST VGA_VSSTRT      = $0153
NATIVE {VGA_VSSTOP}      CONST VGA_VSSTOP      = $0235

NATIVE {BROADCAST_BEAMCON} CONST BROADCAST_BEAMCON = (LOLDIS OR CSBLANK)
NATIVE {BROADCAST_HBSTRT}  CONST BROADCAST_HBSTRT  = $01
NATIVE {BROADCAST_HBSTOP}  CONST BROADCAST_HBSTOP  = $27
NATIVE {BROADCAST_HSSTRT}  CONST BROADCAST_HSSTRT  = $06
NATIVE {BROADCAST_HSSTOP}  CONST BROADCAST_HSSTOP  = $17
NATIVE {BROADCAST_VBSTRT}  CONST BROADCAST_VBSTRT  = $0000
NATIVE {BROADCAST_VBSTOP}  CONST BROADCAST_VBSTOP  = $1C40
NATIVE {BROADCAST_VSSTRT}  CONST BROADCAST_VSSTRT  = $02A6
NATIVE {BROADCAST_VSSTOP}  CONST BROADCAST_VSSTOP  = $054C

NATIVE {RATIO_FIXEDPART}     CONST RATIO_FIXEDPART     = 4
NATIVE {RATIO_UNITY}     CONST RATIO_UNITY     = $10

NATIVE {AnalogSignalInterval} OBJECT analogsignalinterval
    {asi_Start}	start	:UINT
    {asi_Stop}	stop	:UINT
ENDOBJECT

NATIVE {SpecialMonitor} OBJECT specialmonitor
    {spm_Node}	xln	:xln

    {spm_Flags}	flags	:UINT
    {do_monitor}	do_monitor	:NATIVE {LONG  (*)()} PTR
    {reserved1}	reserved1	:NATIVE {LONG  (*)()} PTR
    {reserved2}	reserved2	:NATIVE {LONG  (*)()} PTR
    {reserved3}	reserved3	:NATIVE {LONG  (*)()} PTR

    {hblank}	hblank	:analogsignalinterval
    {vblank}	vblank	:analogsignalinterval
    {hsync}	hsync	:analogsignalinterval
    {vsync}	vsync	:analogsignalinterval
ENDOBJECT
