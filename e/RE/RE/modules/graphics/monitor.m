#ifndef	GRAPHICS_MONITOR_H
#define	GRAPHICS_MONITOR_H

#ifndef	EXEC_SEMAPHORES_H
MODULE 	'exec/semaphores'
#endif
#ifndef	GRAPHICS_GFXNODES_H
MODULE 	'graphics/gfxnodes'
#endif
#ifndef	GRAPHICS_GFX_H
MODULE 	'graphics/gfx'
#endif
OBJECT MonitorSpec

    		Node:ExtendedNode
    Flags:UWORD
    ratioh:LONG
    ratiov:LONG
    rows:UWORD
    colorclocks:UWORD
    DeniseMaxDisplayColumn:UWORD
    BeamCon0:UWORD
    row:UWORD
    		Special:PTR TO SpecialMonitor
    OpenCount:UWORD
    transform:LONG
    translate:LONG
    scale:LONG
    xoffset:UWORD
    yoffset:UWORD
    		LegalView:Rectangle
    maxoscan:LONG	
    videoscan:LONG	
    DeniseMinDisplayColumn:UWORD
    DisplayCompatible:LONG
    	 DisplayInfoDataBase:List
    	 DisplayInfoDataBaseSemaphore:SignalSemaphore
    MrgCop:LONG
    LoadView:LONG
    KillView:LONG
ENDOBJECT

#define	TO_MONITOR		0
#define	FROM_MONITOR		1
#define	STANDARD_XOFFSET	9
#define	STANDARD_YOFFSET	0
#define MSB_REQUEST_NTSC	0
#define MSB_REQUEST_PAL		1
#define MSB_REQUEST_SPECIAL	2
#define MSB_REQUEST_A2024	3
#define MSB_DOUBLE_SPRITES	4
#define	MSF_REQUEST_NTSC	(1 << MSB_REQUEST_NTSC)
#define	MSF_REQUEST_PAL		(1 << MSB_REQUEST_PAL)
#define	MSF_REQUEST_SPECIAL		(1 << MSB_REQUEST_SPECIAL)
#define	MSF_REQUEST_A2024		(1 << MSB_REQUEST_A2024)
#define MSF_DOUBLE_SPRITES		(1 << MSB_DOUBLE_SPRITES)

#define	REQUEST_NTSC		(1 << MSB_REQUEST_NTSC)
#define	REQUEST_PAL		(1 << MSB_REQUEST_PAL)
#define	REQUEST_SPECIAL		(1 << MSB_REQUEST_SPECIAL)
#define	REQUEST_A2024		(1 << MSB_REQUEST_A2024)
#define	DEFAULT_MONITOR_NAME	'default.monitor'
#define	NTSC_MONITOR_NAME	'ntsc.monitor'
#define	PAL_MONITOR_NAME	'pal.monitor'
#define	STANDARD_MONITOR_MASK	 ( REQUEST_NTSC OR REQUEST_PAL )
#define	STANDARD_NTSC_ROWS	262
#define	STANDARD_PAL_ROWS	312
#define	STANDARD_COLORCLOCKS	226
#define	STANDARD_DENISE_MAX	455
#define	STANDARD_DENISE_MIN	93
#define	STANDARD_NTSC_BEAMCON	 $( $0000 )
#define	STANDARD_PAL_BEAMCON	 ( DISPLAYPAL )
#define	SPECIAL_BEAMCON	 ( VARVBLANK OR LOLDIS OR VARVSYNC OR VARHSYNC OR VARBEAM OR CSBLANK OR VSYNCTRUE)
#define	MIN_NTSC_ROW	21
#define	MIN_PAL_ROW	29
#define	STANDARD_VIEW_X	$81
#define	STANDARD_VIEW_Y	$2C
#define	STANDARD_HBSTRT	$06
#define	STANDARD_HSSTRT	$0B
#define	STANDARD_HSSTOP	$1C
#define	STANDARD_HBSTOP	$2C
#define	STANDARD_VBSTRT	$0122
#define	STANDARD_VSSTRT	$02A6
#define	STANDARD_VSSTOP	$03AA
#define	STANDARD_VBSTOP	$1066
#define	VGA_COLORCLOCKS (STANDARD_COLORCLOCKS/2)
#define	VGA_TOTAL_ROWS	(STANDARD_NTSC_ROWS*2)
#define	VGA_DENISE_MIN	59
#define	MIN_VGA_ROW	29
#define	VGA_HBSTRT	$08
#define	VGA_HSSTRT	$0E
#define	VGA_HSSTOP	$1C
#define	VGA_HBSTOP	$1E
#define	VGA_VBSTRT	$0000
#define	VGA_VSSTRT	$0153
#define	VGA_VSSTOP	$0235
#define	VGA_VBSTOP	$0CCD
#define	VGA_MONITOR_NAME	'vga.monitor'

#define	VGA70_COLORCLOCKS (STANDARD_COLORCLOCKS/2)
#define	VGA70_TOTAL_ROWS 449
#define	VGA70_DENISE_MIN 59
#define	MIN_VGA70_ROW	35
#define	VGA70_HBSTRT	$08
#define	VGA70_HSSTRT	$0E
#define	VGA70_HSSTOP	$1C
#define	VGA70_HBSTOP	$1E
#define	VGA70_VBSTRT	$0000
#define	VGA70_VSSTRT	$02A6
#define	VGA70_VSSTOP	$0388
#define	VGA70_VBSTOP	$0F73
#define	VGA70_BEAMCON	(SPECIAL_BEAMCON ^ VSYNCTRUE)
#define	VGA70_MONITOR_NAME	'vga70.monitor'
#define	BROADCAST_HBSTRT	$01
#define	BROADCAST_HSSTRT	$06
#define	BROADCAST_HSSTOP	$17
#define	BROADCAST_HBSTOP	$27
#define	BROADCAST_VBSTRT	$0000
#define	BROADCAST_VSSTRT	$02A6
#define	BROADCAST_VSSTOP	$054C
#define	BROADCAST_VBSTOP	$1C40
#define	BROADCAST_BEAMCON	 ( LOLDIS OR CSBLANK )
#define	RATIO_FIXEDPART	4
#define	RATIO_UNITY	(1 << RATIO_FIXEDPART)
OBJECT AnalogSignalInterval

    Start:UWORD
    Stop:UWORD
ENDOBJECT

OBJECT SpecialMonitor

    		Node:ExtendedNode
    Flags:UWORD
    monitor:LONG
    reserved1:LONG
    reserved2:LONG
    reserved3:LONG
    		hblank:AnalogSignalInterval
    		vblank:AnalogSignalInterval
    		hsync:AnalogSignalInterval
    		vsync:AnalogSignalInterval
ENDOBJECT

#endif	
