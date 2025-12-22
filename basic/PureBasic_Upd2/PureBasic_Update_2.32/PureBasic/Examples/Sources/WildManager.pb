;
;
; ---------->        <------
; Wild Manager      V1.01
; ------------>    <--------
;
; © 2001 - Fantaisie Software - Coded by AlphaSND
;       
;
; Description: Preference front-end for the WILD 3D package from 'Pyper'
;     
;
; NOTE:
; -----
;
; A String in a linked list must not be to NULL for the listview, else
; we got an enforcer hit (AmigaOS 'bug') !
;
;

WBStartup()

InitScreen(0)
InitGadget(30)
InitFile  (0)

If InitRequester() = 0
  End
EndIf

*TagList = InitTagList(10)  ; Note you can use TagListID() but using a variable is smaller/faster

Mode.s

Structure PBScreenInfo
  DisplayID.l     ; Display mode ID
  Width.l         ; Width of display in pixels
  Height.l        ; Height of display in pixels
  Depth.w         ; Number of bit-planes of display
  OverscanType.w  ; Type of overscan of display
  AutoScroll.b
EndStructure


Structure NLVList
  Pad.w
  Item.s
  Command.s
  Processors.b
  Rendering.b
  Warp3D.b
  Width.w
  Height.w
  ScreenID.l
  Changed.b
  AGA.b
EndStructure

NewList PL.NLVList()

;
; Read pref file..
;
;LoadPref

If ReadFile(0, "PROGDIR:WildManager.pref")

  a$ = ReadString()
  If a$ = "WildManagerPref1"
    NbProg = ReadWord()

    For k=0 To NbProg-1
      If AddElement(PL())
        PL()\Item       = ReadString()
        PL()\Command    = ReadString()
        PL()\Processors = ReadByte()
        PL()\Rendering  = ReadByte()
        PL()\Warp3D     = ReadByte()
        PL()\Width      = ReadWord()
        PL()\Height     = ReadWord()
        PL()\ScreenID   = ReadLong()
        PL()\AGA        = ReadByte()
      EndIf

      a$ = ReadString() ; "WAM_End_WAM"
    Next

  EndIf

  CloseFile(0)
Else
  NoPref = 1
EndIf

If NbProg<1 OR NoPref
  AddElement(PL())
  PL()\Item = "Program 1"
  NbProg = 1
EndIf

FirstElement(PL())

Dim Language.s(8)

*MyScreen = FindScreen(0,"Workbench")

;
; Open our window and attach gadgets & menus..
;

ScreenTitle$ = "Wild Manager - © 2001 Fantaisie Software"

HFont  = ScreenFontHeight()

ResetTagList (#WA_CustomScreen, ScreenID())
      AddTag (#WA_ScreenTitle, @ScreenTitle$)
SetWindowTagList(TagListID())

ChangeIDCMP(#IDCMP_MOUSEMOVE | #LISTVIEWIDCMP | #IDCMP_CLOSEWINDOW | #IDCMP_GADGETUP | #IDCMP_GADGETDOWN | #IDCMP_MOUSEBUTTONS |#IDCMP_VANILLAKEY|#IDCMP_MENUPICK)

HG=300
WHeight = HG+HFont+2
If OpenWindow(0, ScreenWidth()/2-210, HFont+20, 416, HFont*9+98, #WFLG_CLOSEGADGET | #WFLG_DRAGBAR | #WFLG_DEPTHGADGET | #WFLG_ACTIVATE | #WFLG_RMBTRAP, "Wild Manager V1.00")

  If CreateGadgetList()

  HG     = 6
  HFont3 = HFont+3
  HFont6 = HFont+6

  Top = HG

  StringGadget(1, 210, HG, 200, HFont6, "Name:"   , PL()\Item   ) : HG=HG+HFont6+2
  StringGadget(2, 210, HG, 180, HFont6, "Program:", PL()\Command)

  ButtonGadget(16,  390, HG, 20, HFont6, "?") : HG=HG+HFont6+10

  Dim WildProcessor.s(2)
  WildProcessor(0) = "680x0"
  WildProcessor(1) = "PowerPC"

  ResetTagList (#GTCY_Active, PL()\Processors)
  SetGadgetTagList(TagListID())
  CycleGadget  (7, 210, HG, 100, HFont6, "Amiga :", WildProcessor()) : HG=HG+HFont6+2

  Dim WildRender.s(4)
  WildRender(0) = "WireFrame"
  WildRender(1) = "Flat"
  WildRender(2) = "Gouraud"
  WildRender(3) = "Textured"

  ResetTagList (#GTCY_Active, PL()\Rendering)
  SetGadgetTagList(TagListID())
  CycleGadget  (8, 210, HG, 100, HFont6, "Rendering:", WildRender()) : HG=HG+HFont6+2
                                                                                                                              
  ResetTagList  (#GTCB_Scaled, 1)
        AddTag  (#GTCB_Checked, PL()\Warp3D)
  CheckBoxGadget(13, 210, HG, HFont6, HFont6, "Warp3D") : HG=HG+HFont6+2
  

  TextGadget(20,  330, HG,  80, HFont6, "","")

  Dim WildScreen.s(2)
  WildScreen(0) = "CGFX"
  WildScreen(1) = "AGA"

  ResetTagList (#GTCY_Active, PL()\AGA)
  CycleGadget  (21,  210, HG, 60, HFont6, "Screen :", WildScreen())
  ButtonGadget (10,  272, HG, 50, HFont6, "Set") : HG=HG+HFont6+HFont

  If PL()\Command = ""
    a=1
  Else
    a=0
  Endif

  ResetTagList (#GA_Disabled, a)
  ButtonGadget (17,  210, HG, 200, HFont6, "-> Launch IT ! <-")

  *RealList = ListBase(PL())

  ResetTagList   (#GTLV_ShowSelected, 0)
        AddTag   (#GTLV_Selected, 0)
  *a.Gadget = ListViewGadget(9, 12, Top+HFont+7, 100, HG-Top-(HFont+7), "Programs:", *RealList)
 
  real = Top+HFont+9+*a\Height

  ButtonGadget   (14,  12, real, 49, HFont6, "Add")
  ButtonGadget   (15,  63, real, 49, HFont6, "Del") : HG=HG+HFont6+16

  ButtonGadget   (4,  12, HG, 125, HFont6+2, "Save"  )
  ButtonGadget   (5, 148, HG, 125, HFont6+2, "Use"   )
  ButtonGadget   (6, 285, HG, 125, HFont6+2, "Cancel")

  RefreshGadget(-1)
  EndIf

  SetGadgetState(9, 0)  ; ListView
  Gosub RefreshWindow
  Gosub DisableWarp3D
  Gosub DisableDel

  Gosub RefreshScreenMode

MainLoop:
  Repeat

    IDCMP.l = WaitWindowEvent()

    ; Special for mouseclick when editing a String !
    ;
    ;
    If MustBeRefreshed
      If MustBeRefreshed = 1
        Gosub String1
      Else
        Gosub String2
      EndIf

      MustBeRefreshed = 0
    EndIf


    Gadget = EventGadgetID()
    Code   = EventCode()

    If IDCMP = #IDCMP_GADGETUP OR IDCMP = #IDCMP_GADGETDOWN ; A gadget has been pushed

      Select Gadget
        Case 1
          Gosub String1
          MustBeRefreshed = 1


        Case 2
          Gosub String2
          MustBeRefreshed = 2


        Case 4 ; 'Save'
          Gosub SavePrefs
          IDCMP = #IDCMP_CLOSEWINDOW


        Case 5 ; 'Use'
          IDCMP = #IDCMP_CLOSEWINDOW


        Case 6 ; 'Cancel'
          IDCMP = #IDCMP_CLOSEWINDOW


        Case 7
          PL()\Processors = Code
          PL()\Changed = 1


        Case 8
          PL()\Rendering = Code
          PL()\Changed = 1

          Gosub DisableWarp3D


        Case 9
          ResetList(PL())

          For k=0 To Code
            NextElement(PL())
          Next

          Gosub RefreshWindow


        Case 10

          ResetTagList (#ASLSM_DoWidth          , 1)
                AddTag (#ASLSM_DoHeight         , 1)
                AddTag (#ASLSM_DoOverscanType   , 1)
                AddTag (#ASLSM_InitialDisplayID , PL()\ScreenID)
                If PL()\Width
                  AddTag (#ASLSM_InitialDisplayWidth  , PL()\Width)
                  AddTag (#ASLSM_InitialDisplayHeight , PL()\Height)
                EndIf

          *sm.PBScreenInfo = ScreenRequester(*TagList)
          If *sm
            PL()\Width    = *sm\Width
            PL()\Height   = *sm\Height
            PL()\ScreenID = *sm\DisplayID
          EndIf

          Gosub RefreshScreenMode

          PL()\Changed = 1


        Case 13 ; 'Warp3D - On/Off'
          PL()\Warp3D = Code
          PL()\Changed = 1


        Case 14 ; 'Add'

          NbProg = NbProg+1
          AddElement(PL())
          PL()\Item = ""

          ResetTagList(#GTLV_Labels, *RealList)
          SetGadgetAttribute(9, TagListID())
          
          SetGadgetState(9, ListIndex(PL()))

          RefreshGadget(9)
          Gosub RefreshWindow

          ActivateGadget(1)


        Case 15 ; 'Del'
          KillElement(PL())

          NbProg = NbProg-1

          ResetTagList(#GTLV_Labels, *RealList)
          SetGadgetAttribute(9, TagListID())
          RefreshGadget(9)
          NextElement(PL())
          Gosub RefreshWindow


        Case 16

          b$ = PL()\Command

          file$ = GetFilePart(b$)
          path$ = GetPathPart(b$)

          ResetTagList (#ASLFR_InitialTopEdge , WindowY()+WindowBorderTop())
                AddTag (#ASLFR_InitialLeftEdge, WindowX())
                AddTag (#ASLFR_InitialHeight  , ScreenHeight()/2)
                AddTag (#ASLFR_InitialWidth   , 200)
                AddTag (#ASLFR_InitialFile    , file$)
                AddTag (#ASLFR_InitialDrawer  , path$)

          ; STOP

          a$ = FileRequester(*TagList)

          If a$ <> ""
            SetGadgetText(2, a$)
            ; RefreshGadget(2)
            Gosub String2
          EndIf


        Case 17 ; 'Launch IT !'
          Gosub SetPref
          PL()\Changed = 0

          b$ = GetPathPart(PL()\Command)

          RunProgram(b$, Chr(34)+PL()\Command+Chr(34), 1, 8192)

        Case 21 ; 'AGA - CGFX'
          PL()\AGA = Code
          PL()\Changed = 1


      EndSelect
    EndIf

  Until IDCMP = #IDCMP_CLOSEWINDOW

EndIf

End


RefreshWindow:

  Gosub DisableDel
  Gosub DisableWarp3D
  Gosub RefreshScreenMode

  SetGadgetText(1, PL()\Item)
  SetGadgetText(2, PL()\Command)

  If PL()\Command<>""
    DisableGadget(17, 0)
  Else
    DisableGadget(17, 1)
  Endif

  SetGadgetState(7 , PL()\Processors)
  SetGadgetState(8 , PL()\Rendering)
  SetGadgetState(21, PL()\AGA)

  SetGadgetState(13, PL()\Warp3D)
Return


SavePrefs:
  If CreateFile(0,"PROGDIR:WildManager.pref")

    WriteString("WildManagerPref1")
    WriteWord(NbProg)

    ResetList(PL())

    For k=0 To NbProg-1
      If NextElement(PL())
        WriteString(PL()\Item)
        WriteString(PL()\Command)

        WriteByte(PL()\Processors)
        WriteByte(PL()\Rendering)
        WriteByte(PL()\Warp3D)

        WriteWord(PL()\Width)
        WriteWord(PL()\Height)
        WriteLong(PL()\ScreenID)
        WriteByte(PL()\AGA)
      EndIf

      WriteString("WAM_End_WAM")
    Next

    CloseFile(0)
  EndIf

  ResetList(PL())

  For k=0 To NbProg-1
    If NextElement(PL())
      If PL()\Changed
        Gosub SetPref
      EndIf
    EndIf
  Next

Return


DisableDel:

  If CountList(PL()) = 1
    DisableGadget(15, 1)
  Else
    DisableGadget(15, 0)
  EndIf

Return


DisableWarp3D:

  If PL()\Rendering<>3
    DisableGadget(13, 1)
  Else
    DisableGadget(13, 0)
  EndIf

Return
                                                                                                                              


String1:
  PL()\Item = GetGadgetText(1)
    
  ResetTagList(#GTLV_Labels, *RealList)
  SetGadgetAttribute(9, TagListID())
  RefreshGadget(9)
Return


String2:
  PL()\Command = GetGadgetText(2)

  If PL()\Command<>""
    DisableGadget(17, 0)
  Else
    DisableGadget(17, 1)
  EndIf

  PL()\Changed = 1
Return


SetPref:

  If PL()\Processors = 0

    Param$ = "TD Monkey"

    If PL()\Rendering = 0 ; Special case for WireFrame
      Param$ = Param$ + " DI TryZkren"
    Else

      If PL()\AGA
        Param$ = Param$ + " DI TryPeJam+"
      Else
        Param$ = Param$ + " DI Cyborg"
      EndIf

    EndIf


    Select PL()\Rendering

      Case 0 ; 'Wire'
        Param$ = Param$ + " DW Wire BK no LI no"

      Case 1 ; 'Flat'
        Param$ = Param$ + " DW Flat BK NiX+ LI Flash"

      Case 2 ; 'Gouraud'
        Param$ = Param$ + " DW Fluff BK ShiX LI Torch"

      Case 3 ; 'Textured'
        Param$ = Param$ + " DW Candy+ BK TiX+ LI Torch"

    EndSelect

  Else

    Param$ = "TD Evolution"

    If PL()\Rendering = 0 ; Special case for WireFrame
      Param$ = Param$ + " DI TryZkren"
    Else

      If PL()\AGA
        Param$ = Param$ + " DI TryNoe8"
      Else
        Param$ = Param$ + " DI Cyborg"
      EndIf

    EndIf


    Select PL()\Rendering

      Case 0 ; 'Wire'
        Param$ = Param$ + " DW Wire BK no LI no"

      Case 1 ; 'Flat'
        Param$ = Param$ + " DW Flat BK NiX+ LI Flash"

      Case 2 ; 'Gouraud'
        Param$ = Param$ + " DW Fluff BK ShiX LI WTorch"

      Case 3 ; 'Textured'
        Param$ = Param$ + " DW PowerDragon BK WTiX LI WTorch"

    EndSelect

  EndIf


  If PL()\Warp3D
    If PL()\Processors = 0
      Param$ = "TD Monkey LI Torch"
    Else
      Param$ = "TD Evolution LI WTorch"
    EndIf

    Param$ = Param$ + " DW DrScott DI CyborgHi BK no"
  EndIf


  If PL()\Width
    Param$ = Param$+" WID "+Str(PL()\Width)+" HEI "+Str(PL()\Height);+" MODEID $";+Hex$(\ScreenID)
  EndIf

  c$ = GetFilePart(PL()\Command)

  If c$ <> ""
    RunProgram("WildPJ:Tools", "CloseWild", 0, 4096)
    RunProgram("WildPJ:Tools", "SetWildAppPrefs "+c$+" save "+Param$, 0, 4096)
  EndIf

Return


RefreshScreenMode:

  If PL()\Width
    Mode = Str(PL()\Width)+"x"+Str(PL()\Height)
  Else
    Mode = "Default"
  EndIf

  SetGadgetText(20, Mode)
Return

; MainProcessor=0
; Optimizations=0
; CommentedSource=1
; CreateIcon=0
; NoCliOutput=0
; Executable=Ram Disk:ess.exe
; Debugger=1
; EnableASM=0
