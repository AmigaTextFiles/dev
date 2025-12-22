
; ***************************************
;
;  PopupMenu example file for PureBasic
;
;      © 2000 - Fantaisie Software -
;
; ***************************************


#Menu=0
#WINDOW_FLAGS=#WFLG_DRAGBAR|#WFLG_CLOSEGADGET|#WFLG_RMBTRAP|#WFLG_ACTIVATE
#IDCMP_FLAGS=#IDCMP_MOUSEBUTTONS|#IDCMP_CLOSEWINDOW|#IDCMP_VANILLAKEY


 If InitWindow(0) AND InitPopupMenu(#Menu) AND InitTagList(20)         

   Title.s = "PopupMenu with Pure Basic."

   ResetTagList(#WA_Title , @Title)
   AddTag(#WA_IDCMP, #IDCMP_FLAGS)


   *w.Window = OpenWindow(0, 200, 12, 215, 40, #WINDOW_FLAGS, TagListID())

   If *w

     PopupMenuTitle("PopupMenu")

       PopupMenuCheckItem  (1, "Check1", "A")
       PopupMenuItem       (2, "Item1",  "B")
       PopupMenuSubMenuItem("SubMenu1")

         PopupMenuSubItem     (3, "SubItem1" , "C")
         PopupMenuCheckSubItem(4, "SubCheck1", "")
         PopupMenuSubBar()
         PopupMenuSubInfo("SubInfo1")
         PopupMenuSubBar()
         PopupMenuSubItem(5, "SubItem2", "")

       PopupMenuBar()
       PopupMenuInfo("Info1")
       PopupMenuBar()
       PopupMenuItem(6, "Quit", "")

     Error.w=AttachPopupMenu(#Menu, *w)

     If Error.w = 0

       loop.w=1

       Repeat

         PM_Event.l=WaitPopupMenuEvent(#Menu)

         Select PM_Event.l

          Case 1
           If PopupMenuChecked(#Menu,1)
             PrintN("Quit was Enabled.")
           Else
             PrintN("Quit was Disabled.")
           EndIf

           s.w=1-s.w
           If DisablePopupMenuItem(#Menu,6,s.w)
             If s.w
               PrintN("Quit is Disabled.")
              Else
               PrintN("Quit is Enabled.")
              EndIf
           EndIf

          Case 6
           loop=0

          Case #IDCMP_CLOSEWINDOW
           loop=0

          Default
           Print("MenuItem=") : PrintNumberN(PM_Event.l)

         EndSelect

       Until loop = 0

       FreePopupMenu(#Menu)
     EndIf

   EndIf

 EndIf

 PrintN("End of Program.")
 End

