;
; ** $VER: gfxbase.h 39.21 (21.4.93)
; ** Includes Release 40.15
; **
; ** graphics base definitions
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/lists.pb"
XIncludeFile "exec/libraries.pb"
XIncludeFile "exec/interrupts.pb"
XIncludeFile "graphics/monitor.pb"
XIncludeFile "graphics/view.pb"
XIncludeFile "graphics/text.pb"
XIncludeFile "hardware/blit.pb"

Structure GfxBase

 LibNode.Library
 *ActiView.View
 *copinit.copinit ;  ptr to copper start up list
 *cia.l   ;  for 8520 resource use
 *blitter.l  ;  for future blitter resource use
 *LOFlist.w
 *SHFlist.w
 *blthd.bltnode
 *blttl.bltnode
 *bsblthd.bltnode
 *bsblttl.bltnode
 vbsrv.Interrupt
 timsrv.Interrupt
 bltsrv.Interrupt
 TextFonts.List
 *DefaultFont.TextFont
 Modes.w   ;  copy of current first bplcon0
 VBlank.b
 Debug.b
 BeamSync.w
 system_bplcon0.w  ;  it is ored into each bplcon0 for display
 SpriteReserved.b
 bytereserved.b
 Flags.w
 BlitLock.w
 BlitNest.w

 BlitWaitQ.List
 *BlitOwner.Task
 TOF_WaitQ.List
 DisplayFlags.w  ;  NTSC PAL GENLOC etc
     ;  flags initialized at power on
 *SimpleSprites.l ; was **SimpleSprite
 MaxDisplayRow.w  ;  hardware stuff, do not use
 MaxDisplayColumn.w ;  hardware stuff, do not use
 NormalDisplayRows.w
 NormalDisplayColumns.w
 ;  the following are for standard non interlace, 1/2 wb width
 NormalDPMX.w  ;  Dots per meter on display
 NormalDPMY.w  ;  Dots per meter on display
 *LastChanceMemory.SignalSemaphore
 *LCMptr.w
 MicrosPerLine.w  ;  256 time usec/line
 MinDisplayColumn.w
 ChipRevBits0.b
 MemType.b
 crb_reserved.b[4]
 monitor_id.w
 hedley.l[8]
 hedley_sprites.l[8] ;  sprite ptrs for intuition mouse
 hedley_sprites1.l[8] ;  sprite ptrs for intuition mouse
 hedley_count.w
 hedley_flags.w
 hedley_tmp.w
 *hash_table.l
 current_tot_rows.w
 current_tot_cclks.w
 hedley_hint.b
 hedley_hint2.b
 nreserved.l[4]
 *a2024_sync_raster.l
 control_delta_pal.w
 control_delta_ntsc.w
 *current_monitor.MonitorSpec
 MonitorList.List
 *default_monitor.MonitorSpec
 *MonitorListSemaphore.SignalSemaphore
 *DisplayInfoDataBase.l
 TopLine.w
 *ActiViewCprSemaphore.SignalSemaphore
 *UtilBase.l  ;  for hook and tag utilities. had to change because of name clash
 *ExecBase.l  ;  to link with rom.lib
 *bwshifts.b
 *StrtFetchMasks.w
 *StopFetchMasks.w
 *Overrun.w
 *RealStops.w
 SpriteWidth.w ;  current width (in words) of sprites
 SpriteFMode.w  ;  current sprite fmode bits
 SoftSprites.b ;  bit mask of size change knowledgeable sprites
 arraywidth.b
 DefaultSpriteWidth.w ;  what width intuition wants
 SprMoveDisable.b
 WantChips.b
 BoardMemType.b
 Bugs.b
 *gb_LayersBase.l
 ColorMask.l
 *IVector.l
 *IData.l
 SpecialCounter.l  ;  special for double buffering
 *DBList.l
 MonitorFlags.w
 ScanDoubledSprites.b
 BP3Bits.b
 MonitorVBlank.AnalogSignalInterval
 *natural_monitor.MonitorSpec
 *ProgData.l
 ExtSprites.b
 pad3.b
 GfxFlags.w
 VBCounter.l
 *HashTableSemaphore.SignalSemaphore
 *HWEmul.l[9]
EndStructure

;  Values for GfxBase->DisplayFlags
#NTSC  = 1
#GENLOC  = 2
#PAL  = 4
#TODA_SAFE = 8
#REALLY_PAL = 16 ;  what is actual crystal frequency
;      (as opposed to what bootmenu set the agnus to)?
;      (V39)
#LPEN_SWAP_FRAMES = 32
    ;  LightPen software could set this bit if the
;      * "lpen-with-interlace" fix put in for V39
;      * does not work. This is true of a number of
;      * Agnus chips.
;      * (V40).
;

#BLITMSG_FAULT = 4

;  bits defs for ChipRevBits
#GFXB_BIG_BLITS = 0
#GFXB_HR_AGNUS = 0
#GFXB_HR_DENISE = 1
#GFXB_AA_ALICE = 2
#GFXB_AA_LISA = 3
#GFXB_AA_MLISA = 4 ;  internal use only.

#GFXF_BIG_BLITS = 1
#GFXF_HR_AGNUS = 1
#GFXF_HR_DENISE = 2
#GFXF_AA_ALICE = 4
#GFXF_AA_LISA = 8
#GFXF_AA_MLISA = 16 ;  internal use only

;  Pass ONE of these to SetChipRev()
#SETCHIPREV_A = #GFXF_HR_AGNUS
#SETCHIPREV_ECS = (#GFXF_HR_AGNUS | #GFXF_HR_DENISE)
#SETCHIPREV_AA = (#GFXF_AA_ALICE | #GFXF_AA_LISA | #SETCHIPREV_ECS)
#SETCHIPREV_BEST = $ffffffff

;  memory type
#BUS_16  = 0
#NML_CAS  = 0
#BUS_32  = 1
#DBL_CAS  = 2
#BANDWIDTH_1X = (#BUS_16 | #NML_CAS)
#BANDWIDTH_2XNML = #BUS_32
#BANDWIDTH_2XDBL = #DBL_CAS
#BANDWIDTH_4X = (#BUS_32 | #DBL_CAS)

;  GfxFlags (private)
#NEW_DATABASE = 1

