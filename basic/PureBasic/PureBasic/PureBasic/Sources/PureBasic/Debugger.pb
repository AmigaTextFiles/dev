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

#DebugGadget_0=0
#DebugGadget_1=1
#DebugGadget_2=2
#DebugGadget_3=3
#DebugGadget_4=4


Macro DebugBox(String, Title="DebugBox")
  EasyRequester("DebugBox", String, "Ok")
EndMacro


*TagList = InitTagList(100) 

InitGadget(4)                    
InitScreen(1)                     
OpenExecLibrary_(36)       
OpenIntuitionLibrary_(36)
OpenDosLibrary_(36)     

#IDCMP_PBFAULT = 111

#Test = 0

Define.Message MyMess
Define.Node    *FirstElem, *CurElem

Define.l

Structure TextStruct
  Text.s
EndStructure

Structure NewMessage
  Mess.Message
 *DebuggerStruct.l
 *Source.l
EndStructure

Structure Debug
  Command.l
  ActLine.l
  PAD.l
 *Text.l
EndStructure

Define.Debug *Debugger
Define.NewMessage *Mess

; --------------------------------------------------------------------------------------
; Set up globally used variables...

*DebuggerPort.MsgPort =0
*CompilerPort.MsgPort =0
Res$=""

ActLine.l=0
FontSize.w=0
FontWidth.w=0
DisplayTop.w=0
NbLines.l=0
HStatus.w=0

CompilerIf #Test = 1
  NewList Source.TextStruct()

  Restore SourceCode_DATA

  For k=0 To 10
    If AddElement(Source())
      Read Source()\Text
      ; Source()\Text = "Hello"+str(k)
    EndIf
  Next

  FirstElement(Source())

  *FirstElem = @Source() - 8
CompilerEndIf


Global Dim ReadResult.l(2)

; --------------------------------------------------------------------------------------

Procedure.l  GetCliArguments()
  Shared   *DebuggerPort, *CompilerPort

  a$="PORT/K/N,COMPILERPORT/K/N"

  *rdargs = ReadArgs_(@a$, @ReadResult(), 0)

  If *rdargs           ; is some args ?
    If ReadResult(0)
      *DebuggerPort = PeekL(ReadResult(0))
    EndIf

    If ReadResult(1)
      *CompilerPort = PeekL(ReadResult(1))
    EndIf

    FreeArgs_ (*rdargs)
  EndIf

  ProcedureReturn *rdargs
EndProcedure

; --------------------------------------------------------------------------------------

Procedure.l FirstElem()
  Shared  *CurElem, *FirstElem

  *CurElem = *FirstElem
EndProcedure

; --------------------------------------------------------------------------------------

Procedure.l NextElem()
  Shared *CurElem
  
  If *CurElem
    *CurElem = *CurElem\ln_Succ ; Last one is terminated with NULL
  EndIf

  ProcedureReturn *CurElem
EndProcedure

; --------------------------------------------------------------------------------------

Procedure ListText()
  Shared *CurElem, Res$

  if *CurElem
    Res$ = PeekS(PeekL(*CurElem+8))
  Else
    Res$ = ""
  EndIf

EndProcedure

; --------------------------------------------------------------------------------------

Procedure.l NbListElem()
  FirstElem()

  While NextElem()
    NbElems+1
  Wend

  ProcedureReturn NbElems
EndProcedure

; --------------------------------------------------------------------------------------

Procedure DisplayText()
  Shared  ActLine.l, FontSize.w, DisplayTop.w, NbLines.l, FontWidth.w, Res$

  FirstElem()
  
  YD.w = DisplayTop
  
  HDisplay.w = (WindowInnerHeight()-YD)/(FontSize+1)+2
  
  FrontColour(0)
  
  HLine.w = HDisplay/2
  
  NbWindowCars.w = WindowInnerWidth()/FontWidth-1

  For k.w=1 To ActLine-HLine
    a = NextElem()
  Next
  
  SkipedLines.w = k-1
  
  If NbLines < HDisplay
    HDisplay.w = NbLines
  EndIf
  
  FrontColour(0)

  If HDisplay>0
    BoxFill (10, YD, WindowInnerWidth()-11+WindowBorderLeft(), WindowInnerHeight()-YD+WindowBorderTop()-1)
  EndIf
  
  FrontColour(1)
  
  a.l=1
  For k.w=1 To HDisplay
  
    If a
      Locate(4+FontWidth, YD)
  
      If k+SkipedLines = ActLine
        BackColour(3) : FrontColour(2)
        ListText()
        PrintText (Left(Res$,NbWindowCars))
        BackColour(0) : FrontColour(1)
      Else
        ListText()
        PrintText (Left(Res$,NbWindowCars))
      EndIf
  
      a = NextElem()
    EndIf
  
    YD+FontSize+1
  Next

EndProcedure

; --------------------------------------------------------------------------------------

Procedure DisplayStatus(Text$)
  Shared  ActStatus.s, HStatus.w, FontSize.w, FontWidth.w
  Shared  YG2.w,YG.w

  If Text$ = ""
    Text$ = ActStatus
  EndIf

  NbWindowChars.w = (WindowInnerWidth()/FontWidth)-1

  ActStatus = Text$

  FrontColour(0)
  BoxFill(10,YG, WindowInnerWidth()-7,FontSize)
         
  FrontColour(2)
  Locate(10,YG)
  PrintText(Left(">> "+ActStatus+" <<",NbWindowChars))
EndProcedure

; --------------------------------------------------------------------------------------
; Start of main program

NbLines = NbListElem()

CompilerIf #Test = 0

  If GetCliArguments()
    If *DebuggerPort = 0 Or *CompilerPort = 0
      PrintN ("Can't find the message ports")
      End
    EndIf
  Else
    End
  EndIf

CompilerEndIf


*MyScreen.Screen = FindScreen(0,"")

*MyWin.Window = OpenWindow(0, 1, 1, 1, 1, #WFLG_DRAGBAR, "")
  FontSize  = *MyWin\IFont\tf_YSize
  FontWidth = *MyWin\IFont\tf_XSize
CloseWindow(0)

Xen = 0

XG.w = 0
YG.w = *MyScreen\WBorTop+ScreenFontHeight()+1-Xen
YG2.w = YG
HG.w = ScreenFontHeight()+6
YG+HG   
MainWindow.s = "PureBasic Debugger V4.00"

#MOREFLAGS = #WFLG_CLOSEGADGET | #WFLG_DRAGBAR | #WFLG_DEPTHGADGET | #WFLG_SIZEBBOTTOM | #WFLG_SIZEGADGET

ChangeIDCMP (#IDCMP_CLOSEWINDOW | #IDCMP_GADGETUP | #IDCMP_GADGETDOWN | #IDCMP_NEWSIZE)

WinWidth.w  = (5*50)
WinHeight.w = YG+(HG*2)-YG2

If OpenWindow(1,20,150,WinWidth,WinHeight,#MOREFLAGS|#WFLG_ACTIVATE,MainWindow.s)
 
  *MyWin.Window = WindowID()
  *Window_Main = *MyWin

  ScreenToFront_(*MyWin\WScreen)

  WindowLimits_ (*Window_Main, WindowWidth(), WindowHeight(), ScreenWidth(), ScreenHeight())

  If CreateGadgetList()
  
    ButtonGadget (#DebugGadget_0, XG, 0, 50, HG, "Stop")  : XG+50-Xen
    ButtonGadget (#DebugGadget_1, XG, 0, 50, HG, "Cont")  : XG+50-Xen
    ButtonGadget (#DebugGadget_2, XG, 0, 50, HG, "Step")  : XG+50-Xen
    ButtonGadget (#DebugGadget_3, XG, 0, 50, HG, "Trace") : XG+50-Xen
    ButtonGadget (#DebugGadget_4, XG, 0, 50, HG, "Exit")  : XG+50-Xen

   YG+HG
  EndIf


  
  For k = 0 To 4
    DisableGadget(k, 1)
  Next

  DrawingOutput(WindowRastPort())

  HStatus    = YG+4
  DisplayTop = YG+FontSize+10
  
  DisplayStatus("Waiting for program message")

CompilerIf #Test = 0

  ProgramPriority(10)

  MyMess\mn_Length = SizeOf(Message)
  PutMsg_ (*CompilerPort, @MyMess) ; Send to the compiler than we're ready
                                   
  Repeat
    VWait()

    IDCMP.l = WindowEvent()
    
    *Mess = GetMsg_(*DebuggerPort)  ; Wait the message of the compiled program !
                                    
    If *Mess
      *FirstElem      = *Mess\Source
      *Debugger.Debug = *Mess\DebuggerStruct

      NbLines = NbListElem()
      ReplyMsg_(*Mess)
    EndIf

  Until *Mess <> 0 Or IDCMP = #IDCMP_CLOSEWINDOW

  If IDCMP = #IDCMP_CLOSEWINDOW
    ; May be add msg check loop here?
    End
  EndIf
  
CompilerElse

  Dim Buffer.l(100)
  *Debugger.Debug = @Buffer()
  
CompilerEndIf
 

  For k = 0 To 4
    DisableGadget(k, 0)
  Next

  DisplayStatus("Running the program")
  
  Repeat
    Repeat

      VWait()

      IDCMP.l = WindowEvent()

      If *Debugger\Command = 8
        IDCMP = #IDCMP_PBFAULT
        *Debugger\Command = 5   ; Tell the program to quit
        Fault = 1
      EndIf


      If *Debugger\Command = 9  ; Used for a program 'STOP'
        Gosub ActionSTOP     ;
      EndIf                  ;

      If Fault = 0
        If *Debugger\Command = 258       ; The program now quit...
          IDCMP = #IDCMP_CLOSEWINDOW  ; Quit the debugger...
        EndIf
      EndIf
    Until IDCMP


    Select IDCMP

      Case #IDCMP_GADGETUP

        Select EventGadgetID()

          Case 0 ; STOP
            Gosub ActionSTOP


          Case 1 ; CONT
            DisplayStatus("Running the program")
            SizeWindow (0,0)
            *Debugger\Command = 4


          Case 2 ; STEP
            *Debugger\Command = 2
            DisplayStatus("'Step' mode activated")
            Gosub DisplayText


          Case 3 ; TRACE

            DisplayStatus("'Trace' mode activated")

            Repeat

              VWait()

              IDCMP = WindowEvent()
              *Debugger\Command = 2
              ActLine = *Debugger\ActLine+1

              Gosub DisplayText

            Until EventGadgetID() <> 3


          Case 4 ; Exit
            IDCMP = #IDCMP_CLOSEWINDOW
            *Debugger\Command = 5

        EndSelect


      Case #IDCMP_NEWSIZE

        DisplayText()
        DisplayStatus("")


      Case #IDCMP_CLOSEWINDOW
        *Debugger\Command = 5


      Case #IDCMP_PBFAULT
        DisplayStatus(PeekS(*Debugger\Text))

        For k=0 To 3
          DisableGadget (k,1)
        Next

        ActivateWindow()
        ShowScreen()
        WindowToFront_ (WindowID())

        Gosub DisplayText

        ;*Debugger\Command = 1

    EndSelect

  Until IDCMP = #IDCMP_CLOSEWINDOW

  CloseWindow(1)  
EndIf

; Inform the compiler it's time to quit as well
;
If *CompilerPort
  PutMsg_ (*CompilerPort, @MyMess) ; Send to the compiler than we're ready
EndIf                                   
  
End

; --------------------------------------------------------------------------------------

DisplayText:

  ActLine = *Debugger\ActLine+1

  ProgramPriority(0)

  If WindowHeight()<200 Or WindowWidth()<200
    SizeWindow (200,200)

    Repeat
      VWait()
      IDCMP.l = WindowEvent()
    Until IDCMP = #IDCMP_NEWSIZE
  EndIf

  DisplayText()

  ProgramPriority(50)
Return

; --------------------------------------------------------------------------------------

ActionSTOP:

  *Debugger\Command = 1
  DisplayStatus("Program execution stopped")
  Gosub DisplayText
Return

; --------------------------------------------------------------------------------------

CompilerIf #Test = 1

DataSection
  SourceCode_DATA:
  
    Data.s "Hello=10"
    Data.s ""
    Data.s "If Hello = 1"
    Data.s "  a=10"
    Data.s "EndIf"
    Data.s ""
    Data.s "For"
    Data.s "Next"
    Data.s ""
    Data.s "End"
EndDataSection

CompilerEndIf
