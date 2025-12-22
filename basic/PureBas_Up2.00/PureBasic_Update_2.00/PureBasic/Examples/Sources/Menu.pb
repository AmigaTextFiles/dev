;
; *********************************
;
; Menus example file for PureBasic
;
;   © 2000 - Fantaisie Software -
;
; *********************************
;
;

InitScreen  (0)    ; We need 1 screen
InitWindow  (0)    ; 1 window
InitTagList (10)   ; a taglist upto 11 tags
InitMenu    (0,30) ; 1 menu with maximum 30 items

FindScreen (0,"")  ; Find the default screen

ShowScreen()       ; Bring it to front of the display

;
; Build the menus (note the indentation which is important for better read)
;

MenuTitle("Project")

  MenuItem (1, "Open", 0)
    MenuSubItem (2, "Brush", "B")
    MenuSubBar  ()
    MenuSubItem (3, "Picture", "I")

  MenuItem      (4, "Save As...", "")
  MenuCheckItem (5, "Compression ?", "C", 1)
  MenuBar       ()
  MenuItem      (6, "Quit", "Q")    ; Quit

MenuTitle("Preferences")
  MenuItem (7, "Save", 0)

CreateMenu(0, ScreenID())  ; Create our menu

WinTitle.s = "Menu example"

ResetTagList (#WA_Title, WinTitle)
     AddTag (#WA_SmartRefresh,1)
     AddTag (#WA_CustomScreen, ScreenID())
     AddTag (#WA_NewLookMenus, 1)

If OpenWindow(0, 100, 40, 300, 100, #WFLG_CLOSEGADGET | #WFLG_DRAGBAR | #WFLG_DEPTHGADGET | #WFLG_ACTIVATE, TagListID())

  AttachMenu(0,WindowID())  ; Attach our menu to the opened window

  Compression = 1

  Repeat
    VWait()
    IDCMP.l = WindowEvent()

    If IDCMP = #IDCMP_MENUPICK
      Select EventGadget()

        Case 2
          PrintN("Sub-Menu 'Brush'")

        Case 3
          PrintN("Sub-Menu 'Picture'")

        Case 4
          PrintN("Menu 'Save As...'")

        Case 5
          Print("Menu 'Compression=")

          Compression = 1-Compression

          If Compression
            PrintN("On")
          Else
            PrintN("Off")
          EndIf

        Case 6
          IDCMP = #IDCMP_CLOSEWINDOW

      EndSelect        

    EndIf

  Until IDCMP = #IDCMP_CLOSEWINDOW

EndIf

End
