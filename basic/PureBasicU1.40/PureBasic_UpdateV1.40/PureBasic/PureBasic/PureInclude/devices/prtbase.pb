;
; ** $VER: prtbase.h 1.10 (2.11.90)
; ** Includes Release 40.15
; **
; ** printer.device base structure definitions
; **
; ** (C) Copyright 1987-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"

;XIncludeFile "dos/all.pb"
;XIncludeFile "intuition/all.pb"

XIncludeFile "exec/types.pb"
XIncludeFile "exec/nodes.pb"
XIncludeFile "exec/lists.pb"
XIncludeFile "exec/ports.pb"
XIncludeFile "exec/libraries.pb"
XIncludeFile "exec/tasks.pb"

XIncludeFile "devices/parallel.pb"
XIncludeFile "devices/serial.pb"
XIncludeFile "devices/timer.pb"
;XIncludeFile "dos/dosextens.pb"
;XIncludeFile "intuition/intuition.pb"


Structure DeviceData
    dd_Device.Library ;  standard library node
    *dd_Segment.l       ;  A0 when initialized
    *dd_ExecBase.l       ;  A6 for exec
    *dd_CmdVectors.l       ;  command table for device commands
    *dd_CmdBytes.l       ;  bytes describing which command queue
    dd_NumCommands.w   ;  the number of commands supported
EndStructure

#P_OLDSTKSIZE = $0800 ;  stack size for child task (OBSOLETE)
#P_STKSIZE = $1000 ;  stack size for child task
#P_BUFSIZE = 256 ;  size of internal buffers for text i/o
#P_SAFESIZE = 128 ;  safety margin for text output buffer

;
; Here are the Union emulation under PureBasic. Enjoy the tricks :)
;
Structure pd_Union1
  StructureUnion
    pd_p0.IOExtPar
    pd_s0.IOExtSer
  EndStructureUnion
EndStructure

Structure pd_Union2
  StructureUnion
    pd_p1.IOExtPar
    pd_s1.IOExtSer
  EndStructureUnion
EndStructure


Structure  PrinterData
 pd_Device.DeviceData
 pd_Unit.MsgPort ;  the one and only unit
 *pd_PrinterSegment.l ;  the printer specific segment
 pd_PrinterType.w ;  the segment printer type
    ;  the segment data structure
 *pd_SegmentData.PrinterSegment
 *pd_PrintBuf.b ;  the raster print buffer
 *pd_PWrite.l ;  the write function
 *pd_PBothReady.l ;  write function's done
 
  pd_ior0.pd_Union1 ; See the structures above

;# pd_PIOR0 = pd_ior0\pd_p0
;# pd_SIOR0 = pd_ior0\pd_s0

  pd_ior1.pd_Union2 ; See the structures above

;# pd_PIOR1 = pd_ior1\pd_p1
;# pd_SIOR1 = pd_ior1\pd_s1

 pd_TIOR.timerequest ;  timer I/O request
 pd_IORPort.MsgPort ;  and message reply port
 pd_TC.Task  ;  write task
 pd_OldStk.b[#P_OLDSTKSIZE] ;  and stack space (OBSOLETE)
 pd_Flags.b   ;  device flags
 pd_pad.b   ;  padding
 pd_Preferences.Preferences ;  the latest preferences
 pd_PWaitEnabled.b  ;  wait function switch
 ;  new fields for V2.0
 pd_Flags1.b  ;  padding
 pd_Stk.b[#P_STKSIZE] ;  stack space
EndStructure

;  Printer Class
#PPCB_GFX = 0 ;  graphics (bit position)
#PPCF_GFX = $1 ;  graphics (and/or flag)
#PPCB_COLOR = 1 ;  color (bit position)
#PPCF_COLOR = $2 ;  color (and/or flag)

#PPC_BWALPHA = $00 ;  black&white alphanumerics
#PPC_BWGFX = $01 ;  black&white graphics
#PPC_COLORALPHA = $02 ;  color alphanumerics
#PPC_COLORGFX = $03 ;  color graphics

;  Color Class
#PCC_BW  = $01 ;  black&white only
#PCC_YMC  = $02 ;  yellow/magenta/cyan only
#PCC_YMC_BW = $03 ;  yellow/magenta/cyan or black&white
#PCC_YMCB = $04 ;  yellow/magenta/cyan/black
#PCC_4COLOR = $04 ;  a flag for YMCB and BGRW
#PCC_ADDITIVE = $08 ;  not ymcb but blue/green/red/white
#PCC_WB  = $09 ;  black&white only, 0 == BLACK
#PCC_BGR  = $0A ;  blue/green/red
#PCC_BGR_WB = $0B ;  blue/green/red or black&white
#PCC_BGRW = $0C ;  blue/green/red/white
;
;  The picture must be scanned once for each color component, as the
;  printer can only define one color at a time.  ie. If 'PCC_YMC' then
;  first pass sends all 'Y' info to printer, second pass sends all 'M'
;  info, and third pass sends all C info to printer.  The CalComp
;  PlotMaster is an example of this type of printer.
;
#PCC_MULTI_PASS = $10 ;  see explanation above

Structure PrinterExtendedData
 *ped_PrinterName.b    ;  printer name, null terminated
 *ped_Init.l      ;  called after LoadSeg
 *ped_Expunge.l    ;  called before UnLoadSeg
 *ped_Open.l      ;  called at OpenDevice
 *ped_Close.l      ;  called at CloseDevice
 ped_PrinterClass.b    ;  printer class
 ped_ColorClass.b      ;  color class
 ped_MaxColumns.b      ;  number of print columns available
 ped_NumCharSets.b     ;  number of character sets
 ped_NumRows.w      ;  number of 'pins' in print head
 ped_MaxXDots.l      ;  number of dots max in a raster dump
 ped_MaxYDots.l      ;  number of dots max in a raster dump
 ped_XDotsInch.w      ;  horizontal dot density
 ped_YDotsInch.w      ;  vertical dot density
 *ped_Commands.l     ;  printer text command table
 *ped_DoSpecial.l  ;  special command handler
 *ped_Render.l     ;  raster render function
 ped_TimeoutSecs.l     ;  good write timeout
 ;  the following only exists if the segment version is >= 33
 *ped_8BitChars.l     ;  conv. strings for the extended font
 ped_PrintMode.l      ;  set if text printed, otherwise 0
 ;  the following only exists if the segment version is >= 34
 ;  ptr to conversion function for all chars
 *ped_ConvFunc.l
EndStructure

Structure PrinterSegment
    ps_NextSegment.l  ;  (actually a BPTR)
    ps_runAlert.l  ;  MOVEQ #0,D0 : RTS
    ps_Version.w  ;  segment version
    ps_Revision.w  ;  segment revision
    ps_PED.PrinterExtendedData   ;  printer extended data
EndStructure
