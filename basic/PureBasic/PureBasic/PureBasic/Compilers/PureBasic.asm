; 
; PureBasic 680x0 v4.00 (AmigaOS - 680x0) Generated Code
; 
; © 2006 Fantaisie Software
; 
PB_NeedString = 1
PB_StringBankSize = 5000
PB_NeedFastAllocateString = 1
PB_NeedStringEqual = 1
PB_NeedStringSup = 0
PB_NeedStringInf = 0
PB_NeedFreeStructureStrings = 0
PB_NeedFastAllocateStringFree = 0
; 
  INCLUDE  "PureBasic:Compilers/StringRoutines.asm"
; 
  INCLUDE  "PureBasic:Compilers/Misc.asm"
  InitProgram
; 
; OpenAmigaLibs()
; 
  MOVE.l   a6,244(a4)
  LEA.l   _GraphicsName(pc),a1
  MOVEQ    #0,d0
  JSR      -552(a6)
  MOVE.l   d0,248(a4)
  LEA.l   _IntuitionName(pc),a1
  MOVEQ    #0,d0
  JSR      -552(a6)
  MOVE.l   d0,252(a4)
  LEA.l   _DosName(pc),a1
  MOVEQ    #0,d0
  JSR      -552(a6)
  MOVE.l   d0,256(a4)
  BRA     _ALib_Suite
_IntuitionName:
  Dc.b     "intuition.library",0
_DosName:
  Dc.b     "dos.library",0
_GraphicsName:
  Dc.b     "graphics.library",0,0
_ALib_Suite:
PB_UtilityBase=260
; 
; InitPBLibBank()
; 
  LEA.l   _PBLibBank,a0
  MOVE.l   a0,d1
  LEA.l   _PBLibBankOffset(pc),a0
  MOVE.l   #7,d0
  MOVE.l   a4,a1
  ADD.l    #264,a1
_PBLibLoop:
  MOVE.l   (a0)+,(a1)
  ADD.l    d1,(a1)+
  SUBQ     #1,d0
  BNE     _PBLibLoop
  BRA     _PBLibNext
_PBLibBankOffset:
  Dc.l     98
  Dc.l     184
  Dc.l     352
  Dc.l     436
  Dc.l     464
  Dc.l     1112
  Dc.l     1678
_PBLibNext:
  PB_InitString
PB_NeedAllocateMultiArray = 0
PB_NeedAllocateArray = 1
PB_Debugger = 0
PB_GlobalBankSize = 292
PB_GraphicsOffset = 248
PB_DosOffset = 256
PB_DebuggerPort = 268495848
PB_SourceAddr = 0
; 
; CallInitFunctions()
; 
  MOVE.l   244(a4),a6
  MOVE.l   284(a4),a5
  JSR      -558(a5)  
; :
; --------------------------------------------------------------------------------------
;
; This source file is part of PureBasic
; For the latest info, see http://www.purebasic.com/
; 
; Copyright (c) 1998-2006 Fantaisie Software
;
; This program is free software; you can redistribute it and/or modify it under
; the terms of the GNU Lesser General Public License as published by the Free Software
; Foundation; either version 2 of the License, or (at your option) any later
; version.
;
; This program is distributed in the hope that it will be useful, but WITHOUT
; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
; FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
;
; You should have received a copy of the GNU Lesser General Public License along with
; this program; if not, write to the Free Software Foundation, Inc., 59 Temple
; Place - Suite 330, Boston, MA 02111-1307, USA, or go to
; http://www.gnu.org/copyleft/lesser.txt.
;
; Note: As PureBasic is a compiler, the programs created with PureBasic are not
; covered by the LGPL license, but are fully free, license free and royality free
; software.
;
; --------------------------------------------------------------------------------------
;
;      PureBasic Debugger
;      Coded by AlphaSND
; © 1999 - Fantaisie Software
;
; --------------------------------------------------------------------------------------
;
; NOTES: Bug in the TRACE mode (when a program quit in TRACE
;        mode, the debugger willn't quit itself)
;
; -Doobrey-
; Just minor changes to make it compile with PB 2.90
;
; 04/06/2000
;   Added ScreenToFront_() and initial position is modified (to be visible..)
;
; 08/12/1999
;   Removed the enforcer hits (DisableGadgets() and NextItem()) 
;
; 14/12/1999
;   Corrected the last few bugs.. Now works fawlessly, but has decrease
;   in size a lot (6kb instead of 16kb with Blitz2 !!). PureBasic rulez...
;
; 13/12/1999
;   Finished the conversion :*). Fixed lot of PureBasic bugs BTW...
;
; 12/12/1999
;   Started the adaptation under PureBasic
;
; 25/11/1999
;   Window is put to front when an error occur
;   Reworked all messages handlers... Really bull shit !
;
; 14/11/1999
;   Changed the MessagePort handler.
;   Possible 'illimited lock' bug removed.
;
; 13/11/1999
;   Fixed a little Display bug..
;
; 12/11/1999
;   Fixed Display (NWInnerWidth/Height & more lines than normal)
;   Added Clipped Text routine
;   Removed the external font loading, now it use the default font
;   Removed 'PowerBasic' strings
;
; 03/08/1999
;   Added some features
;
; 02/08/1999
;   Finished the work !! A full debugger in 2 days :-). Yeah.
;
; 01/08/1999
;   First version
;
; --------------------------------------------------------------------------------------
; 
; #DebugGadget_0=0
; #DebugGadget_1=1
; #DebugGadget_2=2
; #DebugGadget_3=3
; #DebugGadget_4=4
; 
; 
; Macro DebugBox(String, Title="DebugBox")
; 
; 
; *TagList = InitTagList(100) 
  MOVEQ.l  #100,d0
  MOVE.l   244(a4),a6
  MOVE.l   280(a4),a5
  JSR      -20(a5)                       
  MOVE.l   d0,108(a4)
; 
; InitGadget(4)                    
  MOVEQ.l  #4,d2
  MOVE.l   244(a4),a6
  MOVE.l   252(a4),d7
  MOVE.l   288(a4),a5
  JSR      -70(a5)                           
; InitScreen(1)                     
  MOVEQ.l  #1,d0
  MOVE.l   244(a4),a6
  MOVE.l   272(a4),a5
  JSR      -64(a5)                       
; OpenExecLibrary_(36)       
  MOVEQ.l  #36,d0
  MOVE.l   $4,a6
  LEA.l   _PB_OpenExecLibrary(pc),a1
  JSR      -552(a6)
  MOVE.l   d0,112(a4)
  BRA     _PB_OpenExecLibrary_Next
_PB_OpenExecLibrary:
  Dc.b     "exec.library",0
  Even
_PB_OpenExecLibrary_Next:
; OpenIntuitionLibrary_(36)
  MOVEQ.l  #36,d0
  MOVE.l   $4,a6
  LEA.l   _PB_OpenIntuitionLibrary(pc),a1
  JSR      -552(a6)
  MOVE.l   d0,116(a4)
  BRA     _PB_OpenIntuitionLibrary_Next
_PB_OpenIntuitionLibrary:
  Dc.b     "intuition.library",0
  Even
_PB_OpenIntuitionLibrary_Next:
; OpenDosLibrary_(36)     
  MOVEQ.l  #36,d0
  MOVE.l   $4,a6
  LEA.l   _PB_OpenDosLibrary(pc),a1
  JSR      -552(a6)
  MOVE.l   d0,120(a4)
  BRA     _PB_OpenDosLibrary_Next
_PB_OpenDosLibrary:
  Dc.b     "dos.library",0
  Even
_PB_OpenDosLibrary_Next:
; 
; #IDCMP_PBFAULT = 111
; 
; #Test = 0
; 
; Define.Message MyMess
; Define.Node    *FirstElem, *CurElem
; 
; Define.l
; 
; Structure TextStruct
; Text.s
; EndStructure
; 
; Structure NewMessage
; Mess.Message
; *DebuggerStruct.l
; *Source.l
; EndStructure
; 
; Structure Debug
; Command.l
; ActLine.l
; PAD.l
; *Text.l
; EndStructure
; 
; Define.Debug *Debugger
; Define.NewMessage *Mess
; 
; --------------------------------------------------------------------------------------
; Set up globally used variables...
; 
; *DebuggerPort.MsgPort =0
  MOVE.l   #0,160(a4)
; *CompilerPort.MsgPort =0
  MOVE.l   #0,164(a4)
; Res$=""
  LEA.l   _S1,a0
  LEA.l   _S1,a0
  MOVE.l   a0,d2
  LEA.l    168(a4),a5
  JSR      SYS_FastAllocateString
; 
; ActLine.l=0
  MOVE.l   #0,172(a4)
; FontSize.w=0
  MOVE.w   #0,176(a4)
; FontWidth.w=0
  MOVE.w   #0,178(a4)
; DisplayTop.w=0
  MOVE.w   #0,180(a4)
; NbLines.l=0
  MOVE.l   #0,182(a4)
; HStatus.w=0
  MOVE.w   #0,186(a4)
; 
; CompilerIf #Test = 1
; 
; 
; Global Dim ReadResult.l(2)
  MOVE.l   #3,d0
  MOVE.l   #4,d1
  JSR      PB_AllocateArray
  MOVE.w   #5,(a0)+
  MOVE.l   a0,188(a4)
; 
; --------------------------------------------------------------------------------------
; 
; Procedure.l  GetCliArguments()
  JMP     _EndProcedure0
_Procedure0:
PS0=12
  MOVE.l   a7,a1
  SUB.l    #8,a7
  MOVE.l   a7,a0
_ClearLoop0:
  CLR.l    (a0)+
  CMP.l    a0,a1
  BNE     _ClearLoop0                                                                                                                                                   
; Shared   *DebuggerPort, *CompilerPort
; 
; a$="PORT/K/N,COMPILERPORT/K/N"
  LEA.l   _S2,a0
  LEA.l   _S2,a0
  MOVE.l   a0,d2
  LEA.l    (a7),a5
  JSR      SYS_FastAllocateString
; 
; *rdargs = ReadArgs_(@a$, @ReadResult(), 0)
  MOVE.l   (a7),d0
  MOVE.l   d0,-(a7)
  MOVE.l   188(a4),-(a7)
  MOVEQ.l  #0,d3
  MOVE.l   (a7)+,d2
  MOVE.l   (a7)+,d1
  MOVE.l   120(a4),a6
  JSR      -798(a6)
  MOVE.l   d0,4(a7)
; 
; If *rdargs           ; is some args ?
  TST.l    4(a7)
  BEQ     _EndIf2
; If ReadResult(0)
  MOVE.l   188(a4),a5
  TST.l    (a5)
  BEQ     _EndIf4
; *DebuggerPort = PeekL(ReadResult(0))
  MOVE.l   188(a4),a5
  MOVE.l   (a5),a0
  MOVE.l   268(a4),a5
  JSR      -70(a5)                   
  MOVE.l   d0,160(a4)
; EndIf
_EndIf4:
; 
; If ReadResult(1)
  MOVE.l   188(a4),a5
  TST.l    4(a5)
  BEQ     _EndIf6
; *CompilerPort = PeekL(ReadResult(1))
  MOVE.l   188(a4),a5
  MOVE.l   4(a5),a0
  MOVE.l   268(a4),a5
  JSR      -70(a5)                   
  MOVE.l   d0,164(a4)
; EndIf
_EndIf6:
; 
; FreeArgs_ (*rdargs)
  MOVE.l   4(a7),d1
  MOVE.l   120(a4),a6
  JSR      -858(a6)
; EndIf
_EndIf2:
; 
; ProcedureReturn *rdargs
  MOVE.l   4(a7),d0
  JMP     _EndProcedure1
; EndProcedure
  MOVEQ.l  #0,d0
_EndProcedure1:
  MOVE.l   (a7),a0
  JSR      SYS_FreeString
  ADDQ.l   #8,a7
  RTS
_EndProcedure0:
; 
; --------------------------------------------------------------------------------------
; 
; Procedure.l FirstElem()
  JMP     _EndProcedure2
_Procedure2:
PS2=4                                                                                                                                                                                                                                                     
; Shared  *CurElem, *FirstElem
; 
; *CurElem = *FirstElem
  MOVE.l   144(a4),-(a7)
  MOVE.l   (a7)+,d0
  MOVE.l   d0,148(a4)
; EndProcedure
  MOVEQ.l  #0,d0
_EndProcedure3:
  RTS
_EndProcedure2:
; 
; --------------------------------------------------------------------------------------
; 
; Procedure.l NextElem()
  JMP     _EndProcedure4
_Procedure4:
PS4=4                                                                                                                                                                                                                                                     
; Shared *CurElem
; 
; If *CurElem
  TST.l    148(a4)
  BEQ     _EndIf8
; *CurElem = *CurElem\ln_Succ ; Last one is terminated with NULL
  MOVE.l   148(a4),a5
  MOVE.l   0(a5),-(a7)
  MOVE.l   (a7)+,d0
  MOVE.l   d0,148(a4)
; EndIf
_EndIf8:
; 
; ProcedureReturn *CurElem
  MOVE.l   148(a4),d0
  JMP     _EndProcedure5
; EndProcedure
  MOVEQ.l  #0,d0
_EndProcedure5:
  RTS
_EndProcedure4:
; 
; --------------------------------------------------------------------------------------
; 
; Procedure ListText()
  JMP     _EndProcedure6
_Procedure6:
PS6=4                                                                                                                                                                                                                                                     
; Shared *CurElem, Res$
; 
; if *CurElem
  TST.l    148(a4)
  BEQ     _EndIf10
; Res$ = PeekS(PeekL(*CurElem+8))
  MOVE.l   a3,-(a7)
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   148(a4),d7
  ADDQ.l   #8,d7
  MOVE.l   d7,a0
  MOVE.l   268(a4),a5
  JSR      -70(a5)                   
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   d0,a0
  MOVE.l   268(a4),a5
  JSR      -64(a5)                   
  LEA.l    168(a4),a5
  MOVE.l   (a7)+,a0
  JSR      SYS_AllocateString
; Else
  JMP     _EndIf9
_EndIf10:
; Res$ = ""
  LEA.l   _S1,a0
  LEA.l   _S1,a0
  MOVE.l   a0,d2
  LEA.l    168(a4),a5
  JSR      SYS_FastAllocateString
; EndIf
_EndIf9:
; 
; EndProcedure
  MOVEQ.l  #0,d0
_EndProcedure7:
  RTS
_EndProcedure6:
; 
; --------------------------------------------------------------------------------------
; 
; Procedure.l NbListElem()
  JMP     _EndProcedure8
_Procedure8:
PS8=8
  MOVE.l   a7,a1
  SUB.l    #4,a7
  MOVE.l   a7,a0
_ClearLoop8:
  CLR.l    (a0)+
  CMP.l    a0,a1
  BNE     _ClearLoop8                                                                                                                                                    
; FirstElem()
  JSR     _Procedure2
; 
; While NextElem()
_While12:
  MOVEM.l  d1-d7/a0-a2,-(a7)
  JSR     _Procedure4
  MOVEM.l  (a7)+,d1-d7/a0-a2
  TST.l    d0
  BEQ     _Wend12
; NbElems+1
  MOVE.l   (a7),d7
  ADDQ.l   #1,d7
  MOVE.l   d7,(a7)
; Wend
  JMP     _While12
_Wend12:
;jfhsdkfhkjk:
; 
; ProcedureReturn NbElems
  MOVE.l   (a7),d0
  JMP     _EndProcedure9
; EndProcedure
  MOVEQ.l  #0,d0
_EndProcedure9:
  ADDQ.l   #4,a7
  RTS
_EndProcedure8:
; 
; --------------------------------------------------------------------------------------
; 
; Procedure DisplayText()
  JMP     _EndProcedure10
_Procedure10:
PS10=32
  MOVE.l   a7,a1
  SUB.l    #28,a7
  MOVE.l   a7,a0
_ClearLoop10:
  CLR.l    (a0)+
  CMP.l    a0,a1
  BNE     _ClearLoop10                                                                                                                                               
; Shared  ActLine.l, FontSize.w, DisplayTop.w, NbLines.l, FontWidth.w, Res$
; 
; FirstElem()
  JSR     _Procedure2
; 
; YD.w = DisplayTop
  MOVE.w   180(a4),d0
  EXT.l    d0
  MOVE.l   d0,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,(a7)
; 
; HDisplay.w = (WindowInnerHeight()-YD)/(FontSize+1)+2
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   284(a4),a5
  JSR      -68(a5)                   
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   d0,d7
  MOVE.w   (a7),d6
  EXT.l    d6
  SUB.l    d6,d7
  MOVE.w   176(a4),d6
  EXT.l    d6
  ADDQ.l   #1,d6
  PB_DIVSL d6,d7
  ADDQ.l   #2,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,4(a7)
; 
; FrontColour(0)
  MOVEQ.l  #0,d0
  MOVE.l   248(a4),a6
  MOVE.l   264(a4),a5
  JSR      -56(a5)                       
; 
; HLine.w = HDisplay/2
  MOVE.w   4(a7),d7
  EXT.l    d7
  PB_DIVSL #2,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,8(a7)
; 
; NbWindowCars.w = WindowInnerWidth()/FontWidth-1
  MOVE.l   284(a4),a5
  JSR      -44(a5)                   
  MOVE.l   d0,d7
  MOVE.w   178(a4),d6
  EXT.l    d6
  PB_DIVSL d6,d7
  ADD.l    #-1,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,12(a7)
; 
; For k.w=1 To ActLine-HLine
  MOVE.w   #1,16(a7)
_For13:
  MOVE.l   172(a4),d7
  MOVE.w   8(a7),d6
  EXT.l    d6
  SUB.l    d6,d7
  MOVE.l   d7,d0
  CMP.w    16(a7),d0
  BLT     _Next14
; a = NextElem()
  JSR     _Procedure4
  MOVE.l   d0,20(a7)
; Next
_NextContinue14:
  ADD.w    #1,16(a7)
  JMP     _For13
_Next14:
; 
; SkipedLines.w = k-1
  MOVE.w   16(a7),d7
  EXT.l    d7
  ADD.l    #-1,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,24(a7)
; 
; If NbLines < HDisplay
  MOVE.l   182(a4),d7
  CMP.w    4(a7),d7
  BGE     _EndIf16
; HDisplay.w = NbLines
  MOVE.l   182(a4),-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,4(a7)
; EndIf
_EndIf16:
; 
; FrontColour(0)
  MOVEQ.l  #0,d0
  MOVE.l   248(a4),a6
  MOVE.l   264(a4),a5
  JSR      -56(a5)                       
; 
; If HDisplay>0
  MOVE.w   4(a7),d7
  EXT.l    d7
  CMP.l    #0,d7
  BLE     _EndIf18
; BoxFill (10, YD, WindowInnerWidth()-11+WindowBorderLeft(), WindowInnerHeight()-YD+WindowBorderTop()-1)
  MOVE.w   (a7),d1
  EXT.l    d1
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   284(a4),a5
  JSR      -44(a5)                   
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   d0,d7
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   284(a4),a5
  JSR      -272(a5)                  
  MOVEM.l  (a7)+,d1-d7/a0-a2
  ADD.l    d0,d7
  ADD.l    #-11,d7
  MOVE.l   d7,d2
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   284(a4),a5
  JSR      -68(a5)                   
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   d0,d7
  MOVE.w   (a7),d6
  EXT.l    d6
  SUB.l    d6,d7
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   284(a4),a5
  JSR      -262(a5)                  
  MOVEM.l  (a7)+,d1-d7/a0-a2
  ADD.l    d0,d7
  ADD.l    #-1,d7
  MOVE.l   d7,d3
  MOVEQ.l  #10,d0
  MOVE.l   248(a4),a6
  MOVE.l   264(a4),a5
  JSR      -92(a5)                       
; EndIf
_EndIf18:
; 
; FrontColour(1)
  MOVEQ.l  #1,d0
  MOVE.l   248(a4),a6
  MOVE.l   264(a4),a5
  JSR      -56(a5)                       
; 
; a.l=1
  MOVE.l   #1,20(a7)
; For k.w=1 To HDisplay
  MOVE.w   #1,16(a7)
_For19:
  MOVE.w   4(a7),d0
  EXT.l    d0
  CMP.w    16(a7),d0
  BLT     _Next20
; 
; If a
  TST.l    20(a7)
  BEQ     _EndIf22
; Locate(4+FontWidth, YD)
  MOVE.w   (a7),d1
  EXT.l    d1
  MOVE.w   178(a4),d7
  EXT.l    d7
  ADDQ.l   #4,d7
  MOVE.l   d7,d0
  MOVE.l   264(a4),a5
  JSR      -48(a5)                   
; 
; If k+SkipedLines = ActLine
  MOVE.w   16(a7),d7
  EXT.l    d7
  MOVE.w   24(a7),d6
  EXT.l    d6
  ADD.l    d6,d7
  CMP.l    172(a4),d7
  BNE     _EndIf24
; BackColour(3) : FrontColour(2)
  MOVEQ.l  #3,d0
  MOVE.l   248(a4),a6
  MOVE.l   264(a4),a5
  JSR      -98(a5)                       
  MOVEQ.l  #2,d0
  MOVE.l   248(a4),a6
  MOVE.l   264(a4),a5
  JSR      -56(a5)                       
; ListText()
  JSR     _Procedure6
; PrintText (Left(Res$,NbWindowCars))
  MOVE.l   a3,-(a7)
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   a3,-(a7)
  MOVE.l   168(a4),a0
  MOVE.w   60(a7),d0
  EXT.l    d0
  MOVE.l   276(a4),a5
  JSR      -24(a5)                   
  ADDQ.l   #4,a7
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   -44(a7),-(a7)
  MOVE.l   (a7)+,a0
  MOVE.l   248(a4),a6
  MOVE.l   264(a4),a5
  JSR      -28(a5)                       
  MOVE.l   (a7)+,a3
; BackColour(0) : FrontColour(1)
  MOVEQ.l  #0,d0
  MOVE.l   248(a4),a6
  MOVE.l   264(a4),a5
  JSR      -98(a5)                       
  MOVEQ.l  #1,d0
  MOVE.l   248(a4),a6
  MOVE.l   264(a4),a5
  JSR      -56(a5)                       
; Else
  JMP     _EndIf23
_EndIf24:
; ListText()
  JSR     _Procedure6
; PrintText (Left(Res$,NbWindowCars))
  MOVE.l   a3,-(a7)
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   a3,-(a7)
  MOVE.l   168(a4),a0
  MOVE.w   60(a7),d0
  EXT.l    d0
  MOVE.l   276(a4),a5
  JSR      -24(a5)                   
  ADDQ.l   #4,a7
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   -44(a7),-(a7)
  MOVE.l   (a7)+,a0
  MOVE.l   248(a4),a6
  MOVE.l   264(a4),a5
  JSR      -28(a5)                       
  MOVE.l   (a7)+,a3
; EndIf
_EndIf23:
; 
; a = NextElem()
  JSR     _Procedure4
  MOVE.l   d0,20(a7)
; EndIf
_EndIf22:
; 
; YD+FontSize+1
  MOVE.w   (a7),d7
  EXT.l    d7
  MOVE.w   176(a4),d6
  EXT.l    d6
  ADD.l    d6,d7
  ADDQ.l   #1,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,(a7)
; Next
_NextContinue20:
  ADD.w    #1,16(a7)
  JMP     _For19
_Next20:
; 
; EndProcedure
  MOVEQ.l  #0,d0
_EndProcedure11:
  ADD.l    #28,a7
  RTS
_EndProcedure10:
; 
; --------------------------------------------------------------------------------------
; 
; Procedure DisplayStatus(Text$)
  JMP     _EndProcedure12
_Procedure12:
PS12=12
  MOVE.l   a7,a1
  SUB.l    #8,a7
  MOVE.l   a7,a0
_ClearLoop12:
  CLR.l    (a0)+
  CMP.l    a0,a1
  BNE     _ClearLoop12                                                                                                                                                
  MOVE.l   4(a1),d2
  LEA      0(a7),a5
  JSR      SYS_FastAllocateString
; Shared  ActStatus.s, HStatus.w, FontSize.w, FontWidth.w
; Shared  YG2.w,YG.w
; 
; If Text$ = ""
  MOVE.l   (a7),-(a7)
  LEA.l   _S1,a0
  MOVE.l   (a7)+,a1
  JSR      SYS_StringEqual
  BEQ     _EndIf27
; Text$ = ActStatus
  MOVE.l   196(a4),a0
  MOVE.l   a3,-(a7)
  JSR      SYS_CopyString
  LEA.l    4(a7),a5
  MOVE.l   (a7)+,a0
  JSR      SYS_AllocateString
; EndIf
_EndIf27:
; 
; NbWindowChars.w = (WindowInnerWidth()/FontWidth)-1
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   284(a4),a5
  JSR      -44(a5)                   
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   d0,d7
  MOVE.w   178(a4),d6
  EXT.l    d6
  PB_DIVSL d6,d7
  ADD.l    #-1,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,4(a7)
; 
; ActStatus = Text$
  MOVE.l   (a7),a0
  MOVE.l   a3,-(a7)
  JSR      SYS_CopyString
  LEA.l    196(a4),a5
  MOVE.l   (a7)+,a0
  JSR      SYS_AllocateString
; 
; FrontColour(0)
  MOVEQ.l  #0,d0
  MOVE.l   248(a4),a6
  MOVE.l   264(a4),a5
  JSR      -56(a5)                       
; BoxFill(10,YG, WindowInnerWidth()-7,FontSize)
  MOVE.w   202(a4),d1
  EXT.l    d1
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   284(a4),a5
  JSR      -44(a5)                   
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   d0,d7
  ADD.l    #-7,d7
  MOVE.l   d7,d2
  MOVE.w   176(a4),d3
  EXT.l    d3
  MOVEQ.l  #10,d0
  MOVE.l   248(a4),a6
  MOVE.l   264(a4),a5
  JSR      -92(a5)                       
; 
; FrontColour(2)
  MOVEQ.l  #2,d0
  MOVE.l   248(a4),a6
  MOVE.l   264(a4),a5
  JSR      -56(a5)                       
; Locate(10,YG)
  MOVE.w   202(a4),d1
  EXT.l    d1
  MOVEQ.l  #10,d0
  MOVE.l   264(a4),a5
  JSR      -48(a5)                   
; PrintText(Left(">> "+ActStatus+" <<",NbWindowChars))
  MOVE.l   a3,-(a7)
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   a3,-(a7)
  MOVE.l   a3,-(a7)
  LEA.l   _S3,a0
  JSR      SYS_CopyString
  MOVE.l   196(a4),a0
  JSR      SYS_CopyString
  LEA.l   _S4,a0
  LEA.l   _S4,a0
  JSR      SYS_CopyString
  MOVE.l   (a7)+,a0
  ADDQ.l   #1,a3
  MOVE.w   52(a7),d0
  EXT.l    d0
  MOVE.l   276(a4),a5
  JSR      -24(a5)                   
  ADDQ.l   #4,a7
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   -44(a7),-(a7)
  MOVE.l   (a7)+,a0
  MOVE.l   248(a4),a6
  MOVE.l   264(a4),a5
  JSR      -28(a5)                       
  MOVE.l   (a7)+,a3
; EndProcedure
  MOVEQ.l  #0,d0
_EndProcedure13:
  MOVE.l   (a7),a0
  JSR      SYS_FreeString
  ADDQ.l   #8,a7
  MOVE.l   (a7)+, d1
  ADD.l    #4,a7
  MOVE.l   d1,-(a7)
  RTS      
_EndProcedure12:
; 
; --------------------------------------------------------------------------------------
; Start of main program
; 
; NbLines = NbListElem()
  JSR     _Procedure8
  MOVE.l   d0,182(a4)
; 
; CompilerIf #Test = 0
; 
; If GetCliArguments()
  MOVEM.l  d1-d7/a0-a2,-(a7)
  JSR     _Procedure0
  MOVEM.l  (a7)+,d1-d7/a0-a2
  TST.l    d0
  BEQ     _EndIf29
; If *DebuggerPort = 0 Or *CompilerPort = 0
  MOVE.l   160(a4),d7
  CMP.l    #0,d7
  BEQ      Ok0
  MOVE.l   164(a4),d7
  CMP.l    #0,d7
  BEQ      Ok0
  JMP      No0
Ok0:
  MOVE.l   #1,d0
  JMP      End0
No0:
  MOVEQ.l  #0,d0
End0:
  TST.l    d0
  BEQ     _EndIf31
; PrintN ("Can't find the message ports")
  LEA.l   _S5,a0
  MOVE.l   a0,d1
  MOVE.l   256(a4),a6
  MOVE.l   268(a4),a5
  JSR      -54(a5)                       
; End
  JMP     _PB_EOP_NoValue
; EndIf
_EndIf31:
; Else
  JMP     _EndIf28
_EndIf29:
; End
  JMP     _PB_EOP_NoValue
; EndIf
_EndIf28:
; 
; CompilerEndIf
; 
; 
; *MyScreen.Screen = FindScreen(0,"")
  LEA.l   _S1,a0
  MOVEQ.l  #0,d0
  MOVE.l   252(a4),a6
  MOVE.l   272(a4),a5
  JSR      -152(a5)                      
  MOVE.l   d0,204(a4)
; 
; *MyWin.Window = OpenWindow(0, 1, 1, 1, 1, #WFLG_DRAGBAR, "")
  MOVEQ.l  #1,d1
  MOVEQ.l  #1,d2
  MOVEQ.l  #1,d3
  MOVEQ.l  #1,d4
  MOVEQ.l  #2,d5
  LEA.l   _S1,a0
  MOVE.l   a0,d6
  MOVEQ.l  #0,d0
  MOVE.l   252(a4),a6
  MOVE.l   284(a4),a5
  JSR      -508(a5)                      
  MOVE.l   d0,208(a4)
; FontSize  = *MyWin\IFont\tf_YSize
  MOVE.l   208(a4),a5
  MOVE.l   128(a5),a5
  MOVE.w   20(a5),d0
  EXT.l    d0
  MOVE.l   d0,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,176(a4)
; FontWidth = *MyWin\IFont\tf_XSize
  MOVE.l   208(a4),a5
  MOVE.l   128(a5),a5
  MOVE.w   24(a5),d0
  EXT.l    d0
  MOVE.l   d0,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,178(a4)
; CloseWindow(0)
  MOVEQ.l  #0,d0
  MOVE.l   244(a4),d3
  MOVE.l   252(a4),a6
  MOVE.l   284(a4),a5
  JSR      -626(a5)                          
; 
; Xen = 0
  MOVE.l   #0,212(a4)
; 
; XG.w = 0
  MOVE.w   #0,216(a4)
; YG.w = *MyScreen\WBorTop+ScreenFontHeight()+1-Xen
  MOVE.l   204(a4),a5
  MOVE.b   35(a5),d7
  EXT.w    d7
  EXT.l    d7
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   272(a4),a5
  JSR      -40(a5)                   
  MOVEM.l  (a7)+,d1-d7/a0-a2
  ADD.l    d0,d7
  SUB.l    212(a4),d7
  ADDQ.l   #1,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,202(a4)
; YG2.w = YG
  MOVE.w   202(a4),d0
  EXT.l    d0
  MOVE.l   d0,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,200(a4)
; HG.w = ScreenFontHeight()+6
  MOVE.l   272(a4),a5
  JSR      -40(a5)                   
  MOVE.l   d0,d7
  ADDQ.l   #6,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,218(a4)
; YG+HG   
  MOVE.w   202(a4),d7
  EXT.l    d7
  MOVE.w   218(a4),d6
  EXT.l    d6
  ADD.l    d6,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,202(a4)
; MainWindow.s = "PureBasic Debugger V4.00"
  LEA.l   _S6,a0
  LEA.l   _S6,a0
  MOVE.l   a0,d2
  LEA.l    220(a4),a5
  JSR      SYS_FastAllocateString
; 
; #MOREFLAGS = #WFLG_CLOSEGADGET | #WFLG_DRAGBAR | #WFLG_DEPTHGADGET | #WFLG_SIZEBBOTTOM | #WFLG_SIZEGADGET
; 
; ChangeIDCMP (#IDCMP_CLOSEWINDOW | #IDCMP_GADGETUP | #IDCMP_GADGETDOWN | #IDCMP_NEWSIZE)
  MOVE.l   #610,d0
  MOVE.l   284(a4),a5
  JSR      -634(a5)                  
; 
; WinWidth.w  = (5*50)
  MOVE.w   #250,224(a4)
; WinHeight.w = YG+(HG*2)-YG2
  MOVE.w   202(a4),d7
  EXT.l    d7
  MOVE.w   218(a4),d6
  EXT.l    d6
  LSL.l    #1,d6
  ADD.l    d6,d7
  MOVE.w   200(a4),d6
  EXT.l    d6
  SUB.l    d6,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,226(a4)
; 
; If OpenWindow(1,20,150,WinWidth,WinHeight,#MOREFLAGS|#WFLG_ACTIVATE,MainWindow.s)
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVEQ.l  #20,d1
  MOVE.l   #150,d2
  MOVE.w   224(a4),d3
  EXT.l    d3
  MOVE.w   226(a4),d4
  EXT.l    d4
  MOVE.l   #4143,d5
  MOVE.l   220(a4),d6
  MOVEQ.l  #1,d0
  MOVE.l   252(a4),a6
  MOVE.l   284(a4),a5
  JSR      -508(a5)                      
  MOVEM.l  (a7)+,d1-d7/a0-a2
  TST.l    d0
  BEQ     _EndIf34
; 
; *MyWin.Window = WindowID()
  MOVE.l   284(a4),a5
  JSR      -74(a5)                   
  MOVE.l   d0,208(a4)
; *Window_Main = *MyWin
  MOVE.l   208(a4),-(a7)
  MOVE.l   (a7)+,228(a4)
; 
; ScreenToFront_(*MyWin\WScreen)
  MOVE.l   208(a4),a5
  MOVE.l   46(a5),a0
  MOVE.l   116(a4),a6
  JSR      -252(a6)
; 
; WindowLimits_ (*Window_Main, WindowWidth(), WindowHeight(), ScreenWidth(), ScreenHeight())
  MOVE.l   228(a4),-(a7)
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   284(a4),a5
  JSR      -10(a5)                   
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   d0,-(a7)
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   284(a4),a5
  JSR      -84(a5)                   
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   d0,-(a7)
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   272(a4),a5
  JSR      -16(a5)                   
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   d0,-(a7)
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   272(a4),a5
  JSR      -26(a5)                   
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   d0,d3
  MOVE.l   (a7)+,d2
  MOVE.l   (a7)+,d1
  MOVE.l   (a7)+,d0
  MOVE.l   (a7)+,a0
  MOVE.l   116(a4),a6
  JSR      -318(a6)
; 
; If CreateGadgetList()
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   244(a4),d7
  MOVE.l   252(a4),d6
  MOVE.l   288(a4),a5
  JSR      -368(a5)                          
  MOVEM.l  (a7)+,d1-d7/a0-a2
  TST.l    d0
  BEQ     _EndIf36
; 
; ButtonGadget (#DebugGadget_0, XG, 0, 50, HG, "Stop")  : XG+50-Xen
  MOVE.w   216(a4),d1
  EXT.l    d1
  MOVEQ.l  #0,d2
  MOVEQ.l  #50,d3
  MOVE.w   218(a4),d4
  EXT.l    d4
  LEA.l   _S7,a0
  MOVE.l   a0,d5
  MOVEQ.l  #0,d0
  MOVE.l   288(a4),a5
  JSR      -382(a5)                  
  MOVE.w   216(a4),d7
  EXT.l    d7
  SUB.l    212(a4),d7
  ADD.l    #50,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,216(a4)
; ButtonGadget (#DebugGadget_1, XG, 0, 50, HG, "Cont")  : XG+50-Xen
  MOVE.w   216(a4),d1
  EXT.l    d1
  MOVEQ.l  #0,d2
  MOVEQ.l  #50,d3
  MOVE.w   218(a4),d4
  EXT.l    d4
  LEA.l   _S8,a0
  MOVE.l   a0,d5
  MOVEQ.l  #1,d0
  MOVE.l   288(a4),a5
  JSR      -382(a5)                  
  MOVE.w   216(a4),d7
  EXT.l    d7
  SUB.l    212(a4),d7
  ADD.l    #50,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,216(a4)
; ButtonGadget (#DebugGadget_2, XG, 0, 50, HG, "Step")  : XG+50-Xen
  MOVE.w   216(a4),d1
  EXT.l    d1
  MOVEQ.l  #0,d2
  MOVEQ.l  #50,d3
  MOVE.w   218(a4),d4
  EXT.l    d4
  LEA.l   _S9,a0
  MOVE.l   a0,d5
  MOVEQ.l  #2,d0
  MOVE.l   288(a4),a5
  JSR      -382(a5)                  
  MOVE.w   216(a4),d7
  EXT.l    d7
  SUB.l    212(a4),d7
  ADD.l    #50,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,216(a4)
; ButtonGadget (#DebugGadget_3, XG, 0, 50, HG, "Trace") : XG+50-Xen
  MOVE.w   216(a4),d1
  EXT.l    d1
  MOVEQ.l  #0,d2
  MOVEQ.l  #50,d3
  MOVE.w   218(a4),d4
  EXT.l    d4
  LEA.l   _S10,a0
  MOVE.l   a0,d5
  MOVEQ.l  #3,d0
  MOVE.l   288(a4),a5
  JSR      -382(a5)                  
  MOVE.w   216(a4),d7
  EXT.l    d7
  SUB.l    212(a4),d7
  ADD.l    #50,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,216(a4)
; ButtonGadget (#DebugGadget_4, XG, 0, 50, HG, "Exit")  : XG+50-Xen
  MOVE.w   216(a4),d1
  EXT.l    d1
  MOVEQ.l  #0,d2
  MOVEQ.l  #50,d3
  MOVE.w   218(a4),d4
  EXT.l    d4
  LEA.l   _S11,a0
  MOVE.l   a0,d5
  MOVEQ.l  #4,d0
  MOVE.l   288(a4),a5
  JSR      -382(a5)                  
  MOVE.w   216(a4),d7
  EXT.l    d7
  SUB.l    212(a4),d7
  ADD.l    #50,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,216(a4)
; 
; YG+HG
  MOVE.w   202(a4),d7
  EXT.l    d7
  MOVE.w   218(a4),d6
  EXT.l    d6
  ADD.l    d6,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,202(a4)
; EndIf
_EndIf36:
; 
; 
; 
; For k = 0 To 4
  MOVE.l   #0,232(a4)
_For37:
  MOVEQ.l  #4,d0
  CMP.l    232(a4),d0
  BLT     _Next38
; DisableGadget(k, 1)
  MOVEQ.l  #1,d1
  MOVE.l   232(a4),d0
  MOVE.l   288(a4),a5
  JSR      -190(a5)                  
; Next
_NextContinue38:
  ADD.l    #1,232(a4)
  JMP     _For37
_Next38:
; 
; DrawingOutput(WindowRastPort())
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   284(a4),a5
  JSR      -18(a5)                   
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   264(a4),a5
  JSR      -60(a5)                   
; 
; HStatus    = YG+4
  MOVE.w   202(a4),d7
  EXT.l    d7
  ADDQ.l   #4,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,186(a4)
; DisplayTop = YG+FontSize+10
  MOVE.w   202(a4),d7
  EXT.l    d7
  MOVE.w   176(a4),d6
  EXT.l    d6
  ADD.l    d6,d7
  ADD.l    #10,d7
  MOVE.l   d7,-(a7)
  MOVE.l   (a7)+,d0
  MOVE.w   d0,180(a4)
; 
; DisplayStatus("Waiting for program message")
  LEA.l   _S12,a0
  MOVE.l   a0,-(a7)
  JSR     _Procedure12
; 
; CompilerIf #Test = 0
; 
; ProgramPriority(10)
  MOVEQ.l  #10,d2
  MOVE.l   244(a4),a6
  MOVE.l   268(a4),a5
  JSR      -20(a5)                       
; 
; MyMess\mn_Length = SizeOf(Message)
  LEA.l    124(a4),a5
  MOVE.w   #20,18(a5)
; PutMsg_ (*CompilerPort, @MyMess) ; Send to the compiler than we're ready
  MOVE.l   164(a4),-(a7)
  LEA.l    124(a4),a0
  MOVE.l   a0,a1
  MOVE.l   (a7)+,a0
  MOVE.l   112(a4),a6
  JSR      -366(a6)
; 
; Repeat
_Repeat39:
; VWait()
  MOVE.l   248(a4),a6
  MOVE.l   268(a4),a5
  JSR      -6(a5)                        
; 
; IDCMP.l = WindowEvent()
  MOVE.l   252(a4),d5
  MOVE.l   284(a4),a5
  JSR      -252(a5)                      
  MOVE.l   d0,236(a4)
; 
; *Mess = GetMsg_(*DebuggerPort)  ; Wait the message of the compiled program !
  MOVE.l   160(a4),a0
  MOVE.l   112(a4),a6
  JSR      -372(a6)
  MOVE.l   d0,156(a4)
; 
; If *Mess
  TST.l    156(a4)
  BEQ     _EndIf41
; *FirstElem      = *Mess\Source
  MOVE.l   156(a4),a5
  MOVE.l   24(a5),-(a7)
  MOVE.l   (a7)+,144(a4)
; *Debugger.Debug = *Mess\DebuggerStruct
  MOVE.l   156(a4),a5
  MOVE.l   20(a5),-(a7)
  MOVE.l   (a7)+,152(a4)
; 
; NbLines = NbListElem()
  JSR     _Procedure8
  MOVE.l   d0,182(a4)
; ReplyMsg_(*Mess)
  MOVE.l   156(a4),a1
  MOVE.l   112(a4),a6
  JSR      -378(a6)
; EndIf
_EndIf41:
; 
; Until *Mess <> 0 Or IDCMP = #IDCMP_CLOSEWINDOW
  MOVE.l   156(a4),d7
  CMP.l    #0,d7
  BNE      Ok1
  MOVE.l   236(a4),d7
  CMP.l    #512,d7
  BEQ      Ok1
  JMP      No1
Ok1:
  MOVE.l   #1,d0
  JMP      End1
No1:
  MOVEQ.l  #0,d0
End1:
  TST.l    d0
  BEQ     _Repeat39
_Until39:
; 
; If IDCMP = #IDCMP_CLOSEWINDOW
  MOVE.l   236(a4),d7
  CMP.l    #512,d7
  BNE     _EndIf43
; May be add msg check loop here?
; End
  JMP     _PB_EOP_NoValue
; EndIf
_EndIf43:
; 
; CompilerElse
; 
; 
; For k = 0 To 4
  MOVE.l   #0,232(a4)
_For44:
  MOVEQ.l  #4,d0
  CMP.l    232(a4),d0
  BLT     _Next45
; DisableGadget(k, 0)
  MOVEQ.l  #0,d1
  MOVE.l   232(a4),d0
  MOVE.l   288(a4),a5
  JSR      -190(a5)                  
; Next
_NextContinue45:
  ADD.l    #1,232(a4)
  JMP     _For44
_Next45:
; 
; DisplayStatus("Running the program")
  LEA.l   _S13,a0
  MOVE.l   a0,-(a7)
  JSR     _Procedure12
; 
; Repeat
_Repeat46:
; Repeat
_Repeat47:
; 
; VWait()
  MOVE.l   248(a4),a6
  MOVE.l   268(a4),a5
  JSR      -6(a5)                        
; 
; IDCMP.l = WindowEvent()
  MOVE.l   252(a4),d5
  MOVE.l   284(a4),a5
  JSR      -252(a5)                      
  MOVE.l   d0,236(a4)
; 
; If *Debugger\Command = 8
  MOVE.l   152(a4),a5
  MOVE.l   0(a5),d7
  CMP.l    #8,d7
  BNE     _EndIf49
; IDCMP = #IDCMP_PBFAULT
  MOVE.l   #111,236(a4)
; *Debugger\Command = 5   ; Tell the program to quit
  MOVE.l   152(a4),a5
  MOVE.l   #5,0(a5)
; Fault = 1
  MOVE.l   #1,240(a4)
; EndIf
_EndIf49:
; 
; 
; If *Debugger\Command = 9  ; Used for a program 'STOP'
  MOVE.l   152(a4),a5
  MOVE.l   0(a5),d7
  CMP.l    #9,d7
  BNE     _EndIf51
; Gosub ActionSTOP     ;
  JSR      l_actionstop
; EndIf                  ;
_EndIf51:
; 
; If Fault = 0
  MOVE.l   240(a4),d7
  CMP.l    #0,d7
  BNE     _EndIf53
; If *Debugger\Command = 258       ; The program now quit...
  MOVE.l   152(a4),a5
  MOVE.l   0(a5),d7
  CMP.l    #258,d7
  BNE     _EndIf55
; IDCMP = #IDCMP_CLOSEWINDOW  ; Quit the debugger...
  MOVE.l   #512,236(a4)
; EndIf
_EndIf55:
; EndIf
_EndIf53:
; Until IDCMP
  TST.l    236(a4)
  BEQ     _Repeat47
_Until47:
; 
; 
; Select IDCMP
  MOVE.l   236(a4),-(a7)
; 
; Case #IDCMP_GADGETUP
  MOVEQ.l  #64,d7
  CMP.l    (a7),d7
  BNE     _Case1
; 
; Select EventGadgetID()
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   284(a4),a5
  JSR      -620(a5)                  
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   d0,-(a7)
; 
; Case 0 ; STOP
  MOVEQ.l  #0,d7
  CMP.l    (a7),d7
  BNE     _Case2
; Gosub ActionSTOP
  JSR      l_actionstop
; 
; 
; Case 1 ; CONT
  JMP     _EndSelect2
_Case2:
  MOVEQ.l  #1,d7
  CMP.l    (a7),d7
  BNE     _Case3
; DisplayStatus("Running the program")
  LEA.l   _S13,a0
  MOVE.l   a0,-(a7)
  JSR     _Procedure12
; SizeWindow (0,0)
  MOVEQ.l  #0,d1
  MOVEQ.l  #0,d0
  MOVE.l   252(a4),a6
  MOVE.l   284(a4),a5
  JSR      -286(a5)                      
; *Debugger\Command = 4
  MOVE.l   152(a4),a5
  MOVE.l   #4,0(a5)
; 
; 
; Case 2 ; STEP
  JMP     _EndSelect2
_Case3:
  MOVEQ.l  #2,d7
  CMP.l    (a7),d7
  BNE     _Case4
; *Debugger\Command = 2
  MOVE.l   152(a4),a5
  MOVE.l   #2,0(a5)
; DisplayStatus("'Step' mode activated")
  LEA.l   _S14,a0
  MOVE.l   a0,-(a7)
  JSR     _Procedure12
; Gosub DisplayText
  JSR      l_displaytext
; 
; 
; Case 3 ; TRACE
  JMP     _EndSelect2
_Case4:
  MOVEQ.l  #3,d7
  CMP.l    (a7),d7
  BNE     _Case5
; 
; DisplayStatus("'Trace' mode activated")
  LEA.l   _S15,a0
  MOVE.l   a0,-(a7)
  JSR     _Procedure12
; 
; Repeat
_Repeat56:
; 
; VWait()
  MOVE.l   248(a4),a6
  MOVE.l   268(a4),a5
  JSR      -6(a5)                        
; 
; IDCMP = WindowEvent()
  MOVE.l   252(a4),d5
  MOVE.l   284(a4),a5
  JSR      -252(a5)                      
  MOVE.l   d0,236(a4)
; *Debugger\Command = 2
  MOVE.l   152(a4),a5
  MOVE.l   #2,0(a5)
; ActLine = *Debugger\ActLine+1
  MOVE.l   152(a4),a5
  MOVE.l   4(a5),d7
  ADDQ.l   #1,d7
  MOVE.l   d7,172(a4)
; 
; Gosub DisplayText
  JSR      l_displaytext
; 
; Until EventGadgetID() <> 3
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   284(a4),a5
  JSR      -620(a5)                  
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   d0,d7
  CMP.l    #3,d7
  BEQ     _Repeat56
_Until56:
; 
; 
; Case 4 ; Exit
  JMP     _EndSelect2
_Case5:
  MOVEQ.l  #4,d7
  CMP.l    (a7),d7
  BNE     _Case6
; IDCMP = #IDCMP_CLOSEWINDOW
  MOVE.l   #512,236(a4)
; *Debugger\Command = 5
  MOVE.l   152(a4),a5
  MOVE.l   #5,0(a5)
; 
; EndSelect
_Case6:
_EndSelect2:
  MOVE.l   (a7)+,d0
; 
; 
; Case #IDCMP_NEWSIZE
  JMP     _EndSelect1
_Case1:
  MOVEQ.l  #2,d7
  CMP.l    (a7),d7
  BNE     _Case7
; 
; DisplayText()
  JSR     _Procedure10
; DisplayStatus("")
  LEA.l   _S1,a0
  MOVE.l   a0,-(a7)
  JSR     _Procedure12
; 
; 
; Case #IDCMP_CLOSEWINDOW
  JMP     _EndSelect1
_Case7:
  MOVE.l   #512,d7
  CMP.l    (a7),d7
  BNE     _Case8
; *Debugger\Command = 5
  MOVE.l   152(a4),a5
  MOVE.l   #5,0(a5)
; 
; 
; Case #IDCMP_PBFAULT
  JMP     _EndSelect1
_Case8:
  MOVEQ.l  #111,d7
  CMP.l    (a7),d7
  BNE     _Case9
; DisplayStatus(PeekS(*Debugger\Text))
  MOVE.l   a3,-(a7)
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   a3,-(a7)
  MOVE.l   152(a4),a5
  MOVE.l   12(a5),a0
  MOVE.l   268(a4),a5
  JSR      -64(a5)                   
  ADDQ.l   #4,a7
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   -44(a7),-(a7)
  JSR     _Procedure12
  MOVE.l   (a7)+,a3
; 
; For k=0 To 3
  MOVE.l   #0,232(a4)
_For57:
  MOVEQ.l  #3,d0
  CMP.l    232(a4),d0
  BLT     _Next58
; DisableGadget (k,1)
  MOVEQ.l  #1,d1
  MOVE.l   232(a4),d0
  MOVE.l   288(a4),a5
  JSR      -190(a5)                  
; Next
_NextContinue58:
  ADD.l    #1,232(a4)
  JMP     _For57
_Next58:
; 
; ActivateWindow()
  MOVE.l   252(a4),a6
  MOVE.l   284(a4),a5
  JSR      -640(a5)                      
; ShowScreen()
  MOVE.l   252(a4),a6
  MOVE.l   272(a4),a5
  JSR      -6(a5)                        
; WindowToFront_ (WindowID())
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   284(a4),a5
  JSR      -74(a5)                   
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   d0,a0
  MOVE.l   116(a4),a6
  JSR      -312(a6)
; 
; Gosub DisplayText
  JSR      l_displaytext
; 
;*Debugger\Command = 1
; 
; EndSelect
_Case9:
_EndSelect1:
  MOVE.l   (a7)+,d0
; 
; Until IDCMP = #IDCMP_CLOSEWINDOW
  MOVE.l   236(a4),d7
  CMP.l    #512,d7
  BNE     _Repeat46
_Until46:
; 
; CloseWindow(1)  
  MOVEQ.l  #1,d0
  MOVE.l   244(a4),d3
  MOVE.l   252(a4),a6
  MOVE.l   284(a4),a5
  JSR      -626(a5)                          
; EndIf
_EndIf34:
; 
; Inform the compiler it's time to quit as well
;
; If *CompilerPort
  TST.l    164(a4)
  BEQ     _EndIf60
; PutMsg_ (*CompilerPort, @MyMess) ; Send to the compiler than we're ready
  MOVE.l   164(a4),-(a7)
  LEA.l    124(a4),a0
  MOVE.l   a0,a1
  MOVE.l   (a7)+,a0
  MOVE.l   112(a4),a6
  JSR      -366(a6)
; EndIf                                   
_EndIf60:
; 
; End
  JMP     _PB_EOP_NoValue
; 
; --------------------------------------------------------------------------------------
; 
; DisplayText:
l_displaytext:
; 
; ActLine = *Debugger\ActLine+1
  MOVE.l   152(a4),a5
  MOVE.l   4(a5),d7
  ADDQ.l   #1,d7
  MOVE.l   d7,172(a4)
; 
; ProgramPriority(0)
  MOVEQ.l  #0,d2
  MOVE.l   244(a4),a6
  MOVE.l   268(a4),a5
  JSR      -20(a5)                       
; 
; If WindowHeight()<200 Or WindowWidth()<200
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   284(a4),a5
  JSR      -84(a5)                   
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   d0,d7
  CMP.l    #200,d7
  BLT      Ok2
  MOVEM.l  d1-d7/a0-a2,-(a7)
  MOVE.l   284(a4),a5
  JSR      -10(a5)                   
  MOVEM.l  (a7)+,d1-d7/a0-a2
  MOVE.l   d0,d7
  CMP.l    #200,d7
  BLT      Ok2
  JMP      No2
Ok2:
  MOVE.l   #1,d0
  JMP      End2
No2:
  MOVEQ.l  #0,d0
End2:
  TST.l    d0
  BEQ     _EndIf62
; SizeWindow (200,200)
  MOVE.l   #200,d1
  MOVE.l   #200,d0
  MOVE.l   252(a4),a6
  MOVE.l   284(a4),a5
  JSR      -286(a5)                      
; 
; Repeat
_Repeat63:
; VWait()
  MOVE.l   248(a4),a6
  MOVE.l   268(a4),a5
  JSR      -6(a5)                        
; IDCMP.l = WindowEvent()
  MOVE.l   252(a4),d5
  MOVE.l   284(a4),a5
  JSR      -252(a5)                      
  MOVE.l   d0,236(a4)
; Until IDCMP = #IDCMP_NEWSIZE
  MOVE.l   236(a4),d7
  CMP.l    #2,d7
  BNE     _Repeat63
_Until63:
; EndIf
_EndIf62:
; 
; DisplayText()
  JSR     _Procedure10
; 
; ProgramPriority(50)
  MOVEQ.l  #50,d2
  MOVE.l   244(a4),a6
  MOVE.l   268(a4),a5
  JSR      -20(a5)                       
; Return
  RTS
; 
; --------------------------------------------------------------------------------------
; 
; ActionSTOP:
l_actionstop:
; 
; *Debugger\Command = 1
  MOVE.l   152(a4),a5
  MOVE.l   #1,0(a5)
; DisplayStatus("Program execution stopped")
  LEA.l   _S16,a0
  MOVE.l   a0,-(a7)
  JSR     _Procedure12
; Gosub DisplayText
  JSR      l_displaytext
; Return
  RTS
; 
; --------------------------------------------------------------------------------------
; 
; CompilerIf #Test = 1
; 
_PB_EOP_NoValue:
_PB_EOP:
; 
; CallEndFunctions()
; 
  MOVE.l   244(a4),d3
  MOVE.l   252(a4),a6
  MOVE.l   284(a4),a5
  JSR      -612(a5)  
  MOVE.l   244(a4),d7
  MOVE.l   288(a4),a5
  JSR      -132(a5)  
  MOVE.l   244(a4),d5
  MOVE.l   252(a4),a6
  MOVE.l   272(a4),a5
  JSR      -106(a5)  
  MOVE.l   256(a4),a6
  MOVE.l   268(a4),a5
  JSR      -82(a5)  
  MOVE.l   244(a4),a6
  MOVE.l   280(a4),a5
  JSR      -28(a5)  
  PB_FreeString
; 
; CloseAmigaLibs()
; 
  MOVE.l   244(a4),a6
  MOVE.l   248(a4),a1
  JSR      -414(a6)
  MOVE.l   252(a4),a1
  JSR      -414(a6)
  MOVE.l   256(a4),a1
  JSR      -414(a6)
; 
; CloseOSLibraries()
; 
  MOVE.l   112(a4),a1
  JSR      -414(a6)
  MOVE.l   120(a4),a1
  JSR      -414(a6)
  MOVE.l   116(a4),a1
  JSR      -414(a6)
; 
; End Of Program
; 
  QuitProgram
  SubRoutines
  PB_StringSubRoutines
Even
s_s:
  DC.l     0
  DC.l     -1
_S1: Dc.b 0
_S2: Dc.b "PORT/K/N,COMPILERPORT/K/N",0
_S3: Dc.b ">> ",0
_S4: Dc.b " <<",0
_S5: Dc.b "Can't find the message ports",0
_S6: Dc.b "PureBasic Debugger V4.00",0
_S7: Dc.b "Stop",0
_S8: Dc.b "Cont",0
_S9: Dc.b "Step",0
_S10: Dc.b "Trace",0
_S11: Dc.b "Exit",0
_S12: Dc.b "Waiting for program message",0
_S13: Dc.b "Running the program",0
_S14: Dc.b "'Step' mode activated",0
_S15: Dc.b "'Trace' mode activated",0
_S16: Dc.b "Program execution stopped",0
PB_NullString: Dc.b 0
; 
  Even
_PBLibBank:
  INCBIN   "PureBasic:Compilers/ExecutableLib"
; TODO: DataSEG2
