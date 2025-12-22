/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: PullDownMenu.e                                      -- *
 * -- Author......: Daniel Kasmeroglu <raptor@cs.tu-berlin.de>          -- *
 * -- Description.: Port of an example by Henrik Isaksson.              -- *
 * -- ----------------------------------------------------------------- -- *
 * -- Original header:                                                  -- *
 * --                                                                   -- *
 * --   $VER: PullDownMenu.c 2.1 (05.09.98)                             -- *
 * --                                                                   -- *
 * --   Popup Menu example program                                      -- *
 * --                                                                   -- *
 * --   ©1996-1997 Henrik Isaksson                                      -- *
 * --   All Rights Reserved.                                            -- *
 * --                                                                   -- *
 * --   Run and click the mouse in the window!                          -- *
 * --                                                                   -- *
 * -- ----------------------------------------------------------------- -- */

/* -- ----------------------------------------------------------------- -- *
 * --                              Options                              -- *
 * -- ----------------------------------------------------------------- -- */

OPT PREPROCESS       -> enable preprocessor


/* -- ----------------------------------------------------------------- -- *
 * --                              Modules                              -- *
 * -- ----------------------------------------------------------------- -- */

MODULE 'libraries/popupmenu' ,
       'intuition/intuition' ,
       'tools/inithook'      ,
       'utility/tagitem'     ,
       'utility/hooks'       

MODULE 'popupmenu'


/* -- ----------------------------------------------------------------- -- *
 * --                               Main                                -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC main
PROC main()
DEF ma_window  : PTR TO window
DEF ma_menu    : PTR TO popupmenu
DEF ma_imsg1   : PTR TO intuimessage
DEF ma_imsg2   : intuimessage
DEF ma_handler : hook
DEF ma_result

  ma_result := TRUE
  inithook( ma_handler, {hoo_MenuHandlerFunc}, {ma_result} )

  popupmenubase := OpenLibrary( 'popupmenu.library', 9 )
  IF popupmenubase <> NIL

    ma_menu := glo_MakeTestMenu()
    IF ma_menu <> NIL

      -> Open a little window
      ma_window := OpenWindowTagList( NIL,
      [ WA_IDCMP       , IDCMP_CLOSEWINDOW OR IDCMP_MOUSEBUTTONS OR IDCMP_VANILLAKEY ,
        WA_RMBTRAP     , TRUE             ,
        WA_DRAGBAR     , TRUE             ,
        WA_WIDTH       , 150              ,
        WA_HEIGHT      , 100              ,
        WA_LEFT        , 0                ,
        WA_TOP         , 100              ,
        WA_TITLE       , 'PullDown Menus' ,
        WA_CLOSEGADGET , TRUE             ,
        TAG_END ] )

      IF ma_window <> NIL

        WHILE ma_result <> FALSE

          -> Wait for a message
          WaitPort( ma_window.userport )

          WHILE (ma_imsg1 := GetMsg( ma_window.userport )) <> NIL

            -> Copy the contents of it
            CopyMem( ma_imsg1, ma_imsg2, SIZEOF intuimessage )
            ReplyMsg( ma_imsg1 )

            -> Send the message to pmlib
            Pm_FilterIMsgA( ma_window, ma_menu, ma_imsg1,
            [ PM_AUTOPULLDOWN ,  TRUE       , -> We want the menu to open automatically
              PM_MENUHANDLER  ,  ma_handler , -> Our menuhandler function
              TAG_END ] )

            -> See if the user wants to quit
            IF ma_imsg1.class = IDCMP_CLOSEWINDOW THEN ma_result := FALSE

          ENDWHILE

        ENDWHILE

        CloseWindow( ma_window )

      ELSE
        PrintF( 'Window error !\n' )
      ENDIF

      Pm_FreePopupMenu( ma_menu )

    ELSE
      PrintF( 'Menu error !\n' )
    ENDIF
    CloseLibrary( popupmenubase )

  ELSE
    PrintF( 'Cannot open "popupmenu.library" v9+ !\n' )
  ENDIF

ENDPROC
->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                             Functions                             -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC glo_MakeTestMenu
PROC glo_MakeTestMenu()
DEF mak_menu : PTR TO popupmenu

  mak_menu := PMStartMenu,
                PMItem( 'Workbench' ),
                  PMSimpleSub,
                    PMCheckItem( 'Backdrop?', 1  ), PM_COMMKEY, 'B', PMEnd,
                    PMItem( 'Execute Command...' ), PM_COMMKEY, 'E', PMEnd,
                    PMItem( 'Redraw All'         ), PMEnd,
                    PMItem( 'Update All'         ), PMEnd,
                    PMItem( 'Last Message'       ), PMEnd,
                    PMItem( 'About...'           ), PM_COMMKEY,  '?', PMEnd,
                    PMItem( 'Quit'               ), PM_USERDATA, 5,   PM_COMMKEY, 'Q', PMEnd,
                  PMEnd,
                End,
                PMItem( 'Window' ),
                  PMSimpleSub,
                    PMItem( 'New Drawer'      ), PM_COMMKEY,  'N',  PM_DISABLED, TRUE, PMEnd,
                    PMItem( 'Open Parent'     ), PM_DISABLED, TRUE, PMEnd,
                    PMItem( 'Close'           ), PM_COMMKEY,  'K',  PM_DISABLED, TRUE, PMEnd,
                    PMItem( 'Update'          ), PM_DISABLED, TRUE, PMEnd,
                    PMItem( 'Select Contents' ), PM_COMMKEY,  'A',  PMEnd,
                    PMItem( 'Clean Up'        ), PM_COMMKEY,  '.',  PMEnd,
                    PMItem( 'Snapshot'        ),
                      PMSimpleSub,
                        PMItem( 'Window' ), PMEnd,
                        PMItem( 'All'    ), PMEnd,
                      PMEnd,
                    PMEnd,
                    PMItem( 'Show' ),
                      PMSimpleSub,
                        PMCheckItem( 'Only Icons' , 2 ), PM_EXCLUDE, Pm_ExLstA( [ 3, 0 ] ), PM_CHECKED, TRUE, PMEnd,
                        PMCheckItem( 'All Files'  , 3 ), PM_EXCLUDE, Pm_ExLstA( [ 2, 0 ] ), PMEnd,
                      PMEnd,
                      PM_DISABLED, TRUE,
                      -> PM_BuiltInIcon,       PMIMG_SHOW,
                    PMEnd,
                    PMItem( 'View By' ),
                      PMSimpleSub,
                        PMCheckItem( 'Icon', 4 ), PM_EXCLUDE, Pm_ExLstA( [ 5, 6, 7, 0 ] ), PM_CHECKED, TRUE, PMEnd,
                        PMCheckItem( 'Name', 5 ), PM_EXCLUDE, Pm_ExLstA( [ 4, 6, 7, 0 ] ), PMEnd,
                        PMCheckItem( 'Date', 6 ), PM_EXCLUDE, Pm_ExLstA( [ 4, 5, 7, 0 ] ), PMEnd,
                        PMCheckItem( 'Size', 7 ), PM_EXCLUDE, Pm_ExLstA( [ 4, 5, 6, 0 ] ), PMEnd,
                      PMEnd,
                      PM_DISABLED, FALSE,
                    PMEnd,
                  PMEnd,
                PMEnd,
                PMItem( 'Icons' ),
                  PMSimpleSub,
                    PMItem( 'Open'           ), PM_COMMKEY, 'O', PMEnd,
                    PMItem( 'Copy'           ), PM_COMMKEY, 'C', PMEnd,
                    PMItem( 'Rename...'      ), PM_COMMKEY, 'R', PMEnd,
                    PMItem( 'Information...' ), PM_COMMKEY, 'I', PMEnd,
                    PMItem( 'Snapshot'       ), PM_COMMKEY, 'S', PMEnd,
                    PMItem( 'UnSnapshot'     ), PM_COMMKEY, 'U', PMEnd,
                    PMItem( 'Leave Out'      ), PM_COMMKEY, 'L', PMEnd,
                    PMItem( 'Put Away'       ), PM_COMMKEY, 'P', PMEnd,
                    PMBar, PMEnd,
                    PMItem( 'Delete...'      ), PM_DISABLED, TRUE, PMEnd,
                    PMItem( 'Format Disk...' ), PMEnd,
                    PMItem( 'Empty Trash'    ), PM_DISABLED, TRUE, PMEnd,
                  PMEnd,
                PMEnd,
                PMItem( 'Tools' ),
                  PMSimpleSub,
                    PMItem( 'ResetWB' ), PMEnd,
                  PMEnd,
                PMEnd,
              PMEnd

ENDPROC mak_menu
->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                          Hook-Functions                           -- *
 * -- ----------------------------------------------------------------- -- */

->»» HOOK hoo_MenuHandlerFunc
PROC hoo_MenuHandlerFunc( men_hook : PTR TO hook, men_object, men_msg )
DEF men_menu : PTR TO popupmenu

  men_menu := men_object

  PrintF( '---\n' )
  PrintF( 'Title:    "\s"\n' , men_menu.ppm_Title )
  PrintF( 'UserData: $\h\n'  , men_menu.ppm_UserData )
  PrintF( 'ID:       $\h\n'  , men_menu.ppm_ID )

  -> This is one (the fastest) way of finding out if the item is checked or not:
  -> 0x40000000 = CHECKIT
  -> 0x80000000 = CHECKED
  IF (men_menu.ppm_Flags AND $40000000)
    PrintF( 'Checked?  \s\n', IF men_menu.ppm_Flags AND $80000000 THEN 'Yes' ELSE 'No' )
  ENDIF

  IF men_menu.ppm_UserData = 5 THEN PutLong( men_hook.data, FALSE )

ENDPROC
->»»>

