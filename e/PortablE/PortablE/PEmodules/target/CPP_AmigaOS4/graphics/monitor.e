/* $Id: monitor.h,v 1.17 2005/11/10 15:36:43 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/semaphores', 'target/graphics/gfxnodes', 'target/graphics/gfx'
MODULE 'target/hardware/custom', 'target/exec/lists', 'target/exec/types'
{#include <graphics/monitor.h>}
NATIVE {GRAPHICS_MONITOR_H} CONST

/* define structure names in this scope */
->NATIVE {GraphicsIFace} OBJECT graphicsiface
->ENDOBJECT

NATIVE {MonitorSpec} OBJECT monitorspec
    {ms_Node}	xln	:xln
    {ms_Flags}	flags	:UINT
    {ratioh}	ratioh	:VALUE
    {ratiov}	ratiov	:VALUE
    {total_rows}	total_rows	:UINT
    {total_colorclocks}	total_colorclocks	:UINT
    {DeniseMaxDisplayColumn}	denisemaxdisplaycolumn	:UINT
    {BeamCon0}	beamcon0	:UINT
    {min_row}	min_row	:UINT
    {ms_Special}	special	:PTR TO specialmonitor
    {ms_OpenCount}	opencount	:UINT
    {ms_transform}	transform	:NATIVE {VOID (*)(struct MonitorSpec *mspc,Point *src,UWORD type,Point *dst)} PTR
    {ms_translate}	translate	:NATIVE {VOID (*)(struct MonitorSpec *mspc,Point *src,UWORD type,Point *dst)} PTR
    {ms_scale}	scale	:NATIVE {VOID (*)    (struct MonitorSpec *mspc,Point *src,UWORD type,Point *dst)} PTR
    {ms_xoffset}	xoffset	:UINT
    {ms_yoffset}	yoffset	:UINT
    {ms_LegalView}	legalview	:rectangle
    {ms_maxoscan}	maxoscan	:NATIVE {LONG (*) (struct GraphicsIFace *,struct MonitorSpec *mspc,struct Rectangle *rect,UWORD mode)} PTR /* maximum legal overscan */
    {ms_videoscan}	videoscan	:NATIVE {LONG (*) (struct GraphicsIFace *,struct MonitorSpec *mspc,struct Rectangle *rect,UWORD mode)} PTR /* video display overscan */
    {DeniseMinDisplayColumn}	denisemindisplaycolumn	:UINT
    {DisplayCompatible}	displaycompatible	:ULONG
    {DisplayInfoDataBase}	displayinfodatabase	:lh
    {DisplayInfoDataBaseSemaphore}	didbsemaphore	:ss
    {ms_MrgCop}	mrgcop	:NATIVE {ULONG (*)  (struct GraphicsIFace *, struct View *)} PTR
    {ms_LoadView}	loadview	:NATIVE {VOID (*)(struct GraphicsIFace *, struct View *)} PTR
    {ms_KillView}	killview	:NATIVE {VOID (*)(struct GraphicsIFace *, struct MonitorSpec *)} PTR
ENDOBJECT

NATIVE {TO_MONITOR}          CONST TO_MONITOR          = 0
NATIVE {FROM_MONITOR}        CONST FROM_MONITOR        = 1
NATIVE {STANDARD_XOFFSET}    CONST STANDARD_XOFFSET    = 9
NATIVE {STANDARD_YOFFSET}    CONST STANDARD_YOFFSET    = 0

NATIVE {MSB_REQUEST_NTSC}    CONST MSB_REQUEST_NTSC    = 0
NATIVE {MSB_REQUEST_PAL}     CONST MSB_REQUEST_PAL     = 1
NATIVE {MSB_REQUEST_SPECIAL} CONST MSB_REQUEST_SPECIAL = 2
NATIVE {MSB_REQUEST_A2024}   CONST MSB_REQUEST_A2024   = 3
NATIVE {MSB_DOUBLE_SPRITES}  CONST MSB_DOUBLE_SPRITES  = 4
NATIVE {MSF_REQUEST_NTSC}    CONST MSF_REQUEST_NTSC    = $1
NATIVE {MSF_REQUEST_PAL}     CONST MSF_REQUEST_PAL     = $2
NATIVE {MSF_REQUEST_SPECIAL} CONST MSF_REQUEST_SPECIAL = $4
NATIVE {MSF_REQUEST_A2024}   CONST MSF_REQUEST_A2024   = $8
NATIVE {MSF_DOUBLE_SPRITES}  CONST MSF_DOUBLE_SPRITES  = $10


/* obsolete, v37 compatible definitions follow */
NATIVE {REQUEST_NTSC}        CONST REQUEST_NTSC        = $1
NATIVE {REQUEST_PAL}         CONST REQUEST_PAL         = $2
NATIVE {REQUEST_SPECIAL}     CONST REQUEST_SPECIAL     = $4
NATIVE {REQUEST_A2024}       CONST REQUEST_A2024       = $8

NATIVE {DEFAULT_MONITOR_NAME}  CONST
#define DEFAULT_MONITOR_NAME default_monitor_name
STATIC default_monitor_name  = 'default.monitor'
NATIVE {NTSC_MONITOR_NAME}     CONST
#define NTSC_MONITOR_NAME ntsc_monitor_name
STATIC ntsc_monitor_name     = 'ntsc.monitor'
NATIVE {PAL_MONITOR_NAME}      CONST
#define PAL_MONITOR_NAME pal_monitor_name
STATIC pal_monitor_name      = 'pal.monitor'
NATIVE {STANDARD_MONITOR_MASK} CONST STANDARD_MONITOR_MASK = ( REQUEST_NTSC OR REQUEST_PAL )

NATIVE {STANDARD_NTSC_ROWS}    CONST STANDARD_NTSC_ROWS    = 262
NATIVE {STANDARD_PAL_ROWS}     CONST STANDARD_PAL_ROWS     = 312
NATIVE {STANDARD_COLORCLOCKS}  CONST STANDARD_COLORCLOCKS  = 226
NATIVE {STANDARD_DENISE_MAX}   CONST STANDARD_DENISE_MAX   = 455
NATIVE {STANDARD_DENISE_MIN}   CONST STANDARD_DENISE_MIN   = 93
NATIVE {STANDARD_NTSC_BEAMCON} CONST STANDARD_NTSC_BEAMCON = ($0000 )
NATIVE {STANDARD_PAL_BEAMCON}  CONST STANDARD_PAL_BEAMCON  = ( DISPLAYPAL )

NATIVE {SPECIAL_BEAMCON} CONST SPECIAL_BEAMCON = ( VARVBLANK OR LOLDIS OR VARVSYNC OR VARHSYNC OR VARBEAM OR CSBLANK OR VSYNCTRUE)

NATIVE {MIN_NTSC_ROW}     CONST MIN_NTSC_ROW     = 21
NATIVE {MIN_PAL_ROW}      CONST MIN_PAL_ROW      = 29
NATIVE {STANDARD_VIEW_X}  CONST STANDARD_VIEW_X  = $81
NATIVE {STANDARD_VIEW_Y}  CONST STANDARD_VIEW_Y  = $2C
NATIVE {STANDARD_HBSTRT}  CONST STANDARD_HBSTRT  = $06
NATIVE {STANDARD_HSSTRT}  CONST STANDARD_HSSTRT  = $0B
NATIVE {STANDARD_HSSTOP}  CONST STANDARD_HSSTOP  = $1C
NATIVE {STANDARD_HBSTOP}  CONST STANDARD_HBSTOP  = $2C
NATIVE {STANDARD_VBSTRT}  CONST STANDARD_VBSTRT  = $0122
NATIVE {STANDARD_VSSTRT}  CONST STANDARD_VSSTRT  = $02A6
NATIVE {STANDARD_VSSTOP}  CONST STANDARD_VSSTOP  = $03AA
NATIVE {STANDARD_VBSTOP}  CONST STANDARD_VBSTOP  = $1066

NATIVE {VGA_COLORCLOCKS} CONST VGA_COLORCLOCKS = (STANDARD_COLORCLOCKS/2)
NATIVE {VGA_TOTAL_ROWS}  CONST VGA_TOTAL_ROWS  = (STANDARD_NTSC_ROWS*2)
NATIVE {VGA_DENISE_MIN}  CONST VGA_DENISE_MIN  = 59
NATIVE {MIN_VGA_ROW}     CONST MIN_VGA_ROW     = 29
NATIVE {VGA_HBSTRT}      CONST VGA_HBSTRT      = $08
NATIVE {VGA_HSSTRT}      CONST VGA_HSSTRT      = $0E
NATIVE {VGA_HSSTOP}      CONST VGA_HSSTOP      = $1C
NATIVE {VGA_HBSTOP}      CONST VGA_HBSTOP      = $1E
NATIVE {VGA_VBSTRT}      CONST VGA_VBSTRT      = $0000
NATIVE {VGA_VSSTRT}      CONST VGA_VSSTRT      = $0153
NATIVE {VGA_VSSTOP}      CONST VGA_VSSTOP      = $0235
NATIVE {VGA_VBSTOP}      CONST VGA_VBSTOP      = $0CCD

NATIVE {VGA_MONITOR_NAME} CONST
#define VGA_MONITOR_NAME vga_monitor_name
STATIC vga_monitor_name = 'vga.monitor'

/* NOTE: VGA70 definitions are obsolete - a VGA70 monitor has never been
 * implemented.
 */
NATIVE {VGA70_COLORCLOCKS} CONST VGA70_COLORCLOCKS = (STANDARD_COLORCLOCKS/2)
NATIVE {VGA70_TOTAL_ROWS}  CONST VGA70_TOTAL_ROWS  = 449
NATIVE {VGA70_DENISE_MIN}  CONST VGA70_DENISE_MIN  = 59
NATIVE {MIN_VGA70_ROW}     CONST MIN_VGA70_ROW     = 35
NATIVE {VGA70_HBSTRT}      CONST VGA70_HBSTRT      = $08
NATIVE {VGA70_HSSTRT}      CONST VGA70_HSSTRT      = $0E
NATIVE {VGA70_HSSTOP}      CONST VGA70_HSSTOP      = $1C
NATIVE {VGA70_HBSTOP}      CONST VGA70_HBSTOP      = $1E
NATIVE {VGA70_VBSTRT}      CONST VGA70_VBSTRT      = $0000
NATIVE {VGA70_VSSTRT}      CONST VGA70_VSSTRT      = $02A6
NATIVE {VGA70_VSSTOP}      CONST VGA70_VSSTOP      = $0388
NATIVE {VGA70_VBSTOP}      CONST VGA70_VBSTOP      = $0F73

NATIVE {VGA70_BEAMCON}     CONST ->#VGA70_BEAMCON     = (SPECIAL_BEAMCON XOR VSYNCTRUE)
NATIVE {VGA70_MONITOR_NAME} CONST
#define VGA70_MONITOR_NAME vga70_monitor_name
STATIC vga70_monitor_name = 'vga70.monitor'

NATIVE {BROADCAST_HBSTRT}   CONST BROADCAST_HBSTRT   = $01
NATIVE {BROADCAST_HSSTRT}   CONST BROADCAST_HSSTRT   = $06
NATIVE {BROADCAST_HSSTOP}   CONST BROADCAST_HSSTOP   = $17
NATIVE {BROADCAST_HBSTOP}   CONST BROADCAST_HBSTOP   = $27
NATIVE {BROADCAST_VBSTRT}   CONST BROADCAST_VBSTRT   = $0000
NATIVE {BROADCAST_VSSTRT}   CONST BROADCAST_VSSTRT   = $02A6
NATIVE {BROADCAST_VSSTOP}   CONST BROADCAST_VSSTOP   = $054C
NATIVE {BROADCAST_VBSTOP}   CONST BROADCAST_VBSTOP   = $1C40
NATIVE {BROADCAST_BEAMCON}  CONST BROADCAST_BEAMCON  = ( LOLDIS OR CSBLANK )
NATIVE {RATIO_FIXEDPART}    CONST RATIO_FIXEDPART    = 4
NATIVE {RATIO_UNITY}        CONST RATIO_UNITY        = $10

NATIVE {AnalogSignalInterval} OBJECT analogsignalinterval
    {asi_Start}	start	:UINT
    {asi_Stop}	stop	:UINT
ENDOBJECT

NATIVE {SpecialMonitor} OBJECT specialmonitor
    {spm_Node}	xln	:xln
    {spm_Flags}	flags	:UINT
    {do_monitor}	do_monitor	:NATIVE {VOID (*)(struct GraphicsIFace *,struct MonitorSpec *)} PTR
    {reserved1}	reserved1	:NATIVE {LONG                      (*)()} PTR
    {reserved2}	reserved2	:NATIVE {LONG                      (*)()} PTR
    {reserved3}	reserved3	:NATIVE {LONG                      (*)()} PTR
    {hblank}	hblank	:analogsignalinterval
    {vblank}	vblank	:analogsignalinterval
    {hsync}	hsync	:analogsignalinterval
    {vsync}	vsync	:analogsignalinterval
ENDOBJECT
