;
; ** $VER: copper.h 39.10 (31.5.93)
; ** Includes Release 40.15
; **
; ** graphics copper list intstruction definitions
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;
; 27/03/1999
;   Fixed Union Stuffs..
;

IncludePath   "PureInclude:"
;XIncludeFile "graphics/view.pb"

#COPPER_MOVE = 0     ;  pseude opcode for move #XXXX,dir
#COPPER_WAIT = 1     ;  pseudo opcode for wait y,x
#CPRNXTBUF   = 2     ;  continue processing with next buffer
#CPR_NT_LOF  = $8000  ;  copper instruction only for short frames
#CPR_NT_SHT  = $4000  ;  copper instruction only for long frames
#CPR_NT_SYS  = $2000  ;  copper user instruction only

Structure CopIns

  OpCode.w ;  0 = move, 1 = wait

  ; Double UNION here..
 *nxtlist.CopList[0]
VWaitPos.w[0] ; vertical beam wait
  HWaitPos.w       ;  horizontal beam wait position
  DestAddr.w[0]    ;  destination address of copper move
  DestData.w       ;  destination immediate data to send
EndStructure

;  shorthand for above
;#NXTLIST     = u3\nxtlist
;#VWAITPOS    = u3\u4\u1\VWaitPos
;#DESTADDR    = u3\u4\u1\DestAddr
;#HWAITPOS    = u3\u4\u2\HWaitPos
;#DESTDATA    = u3\u4\u2\DestData


;  structure of cprlist that points to list that hardware actually executes
Structure cprlist
     *Next.cprlist
    *start.w     ;  start of copper list
    MaxCount.w    ;  number of long instructions
EndStructure


Structure CopList
     *Next.CopList  ;  next block for this copper list
    *CopList.CopList ;  system use
    *ViewPort.ViewPort    ;  system use
    *CopIns.CopIns ;  start of this block
    *CopPtr.CopIns ;  intermediate ptr
    *CopLStart.w     ;  mrgcop fills this in for Long Frame
    *CopSStart.w     ;  mrgcop fills this in for Short Frame
    Count.w    ;  intermediate counter
    MaxCount.w    ;  max # of copins for this block
    DyOffset.w    ;  offset this copper list vertical waits
    *Cop2Start.w
    *Cop3Start.w
    *Cop4Start.w
    *Cop5Start.w
    SLRepeat.w
    Flags.w
EndStructure

;  These CopList->Flags are private
#EXACT_LINE = 1
#HALF_LINE = 2


Structure UCopList
   *Next.UCopList
  *FirstCopList.CopList ;  head node of this copper list
  *CopList.CopList    ;  node in use
EndStructure

;  Private graphics data structure. This structure has changed in the past,
;  * and will continue to change in the future. Do Not Touch!
;

Structure copinit
  vsync_hblank.w[2]
  diagstrt.w[12]     ;  copper list for first bitplane
  fm0.w[2]
  diwstart.w[10]
  bplcon2.w[2]
  sprfix.w[16]
  sprstrtup.w[32]
  wait14.w[2]
  norm_hblank.w[2]
  jump.w[2]
  wait_forever.w[6]
  sprstop.w[8]
EndStructure
