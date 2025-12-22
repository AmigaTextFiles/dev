/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: SimpleMenu.e                                        -- *
 * -- Author......: Daniel Kasmeroglu <raptor@cs.tu-berlin.de>          -- *
 * -- Description.: Port from the example written by Henrik Isaksson.   -- *
 * -- ----------------------------------------------------------------- -- *
 * -- Original header:                                                  -- *
 * --                                                                   -- *
 * --   $VER: SimpleMenu.c 2.1 (05.09.98)                               -- *
 * --                                                                   -- *
 * --   Popup Menu example program                                      -- *
 * --                                                                   -- *
 * --   ©1996-1997 Henrik Isaksson                                      -- *
 * --   All Rights Reserved.                                            -- *
 * --                                                                   -- *
 * --   Run and click the mouse in the window!                          -- *
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
       'utility/tagitem'     

MODULE 'popupmenu'


/* -- ----------------------------------------------------------------- -- *
 * --                               Main                                -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC main
PROC main()
DEF ma_window : PTR TO window
DEF ma_imsg1  : PTR TO intuimessage
DEF ma_imsg2  : intuimessage
DEF ma_menu   : PTR TO popupmenu
DEF ma_result

  ma_result := TRUE

  -> open library
  popupmenubase := OpenLibrary( 'popupmenu.library', 9 )
  IF popupmenubase <> NIL

    ma_menu := PMMenu( 'Trashcan' ),
                 PMItem( 'Open' ), PMEnd,
                 PMItem( 'Submenu' ),
                   PMSimpleSub,
                     PMItem( 'Testing...' ), PMEnd,
                     PMItem( '...gnitseT' ), PMEnd,
                   PMEnd,
                 PMEnd,
                 PMBar, PMEnd,
                 PMItem( 'Snapshot'   ), PMEnd,
                 PMItem( 'UnSnapshot' ), PMEnd,
                 PMBar, PMEnd,
                 PMItem( 'Leave out' ), PMEnd,
                 PMItem( 'Rename...' ), PMEnd,
                 PMItem( 'Delete'    ), PMEnd,
                 PMBar, PMEnd,
                 PMItem( 'Empty' ), PM_USERDATA, 5, PMEnd,
                 PMItem( 'Copy to'),
                   PMSimpleSub,
                     PMItem( 'RAM:' ), PMEnd,
                     PMItem( 'DH0:' ), PMEnd,
                     PMItem( 'DH1:' ), PMEnd,
                     PMItem( 'DH2:' ), PMEnd,
                     PMItem( 'DF0:' ), PMEnd,
                   PMEnd,
                 PMEnd,
                 PMItem( 'Copy to'),
                   PMSimpleSub,
                     PMItem( 'RAM:'    ), PMEnd,
                     PMItem( 'DH0:'    ), PMEnd,
                     PMItem( 'DH1:'    ), PMEnd,
                     PMItem( 'DH2:'    ), PMEnd,
                     PMItem( 'DH3:'    ), PMEnd,
                     PMItem( 'DH4:'    ), PMEnd,
                     PMItem( 'DH5:'    ), PMEnd,
                     PMItem( 'RAD:'    ), PMEnd,
                     PMItem( 'DF0:'    ), PMEnd,
                     PMItem( 'DF1:'    ), PMEnd,
                     PMItem( 'DF2:'    ), PMEnd,
                     PMItem( 'DF3:'    ), PMEnd,
                     PMItem( 'PC0:'    ), PMEnd,
                     PMItem( 'PC1:'    ), PMEnd,
                     PMItem( 'TAPE:'   ), PMEnd,
                     PMItem( 'MAC:'    ), PMEnd,
                     PMItem( 'CD0: :)' ), PMEnd,
                   PMEnd,
                 PMEnd,
                 PMItem( 'Copy to' ),
                   PMSimpleSub,
                     PMItem( 'RAM:Clipboards/'         ), PMEnd,
                     PMItem( 'DH0:Storage/DOSDrivers/' ), PMEnd,
                   PMEnd,
                 PMEnd,
                 PMItem( 'Copy to' ),
                   PMSimpleSub,
                     PMItem( 'RAM:' ), PMEnd,
                     PMItem( 'DH0:' ), PMEnd,
                   PMEnd,
                 PMEnd,
               End

    IF ma_menu <> NIL

      ma_window := OpenWindowTagList( NIL,
      [ WA_IDCMP       , IDCMP_CLOSEWINDOW OR IDCMP_MOUSEBUTTONS , -> Open a little window
        WA_RMBTRAP     , TRUE                                    ,
        WA_DRAGBAR     , TRUE                                    ,
        WA_WIDTH       , 150                                     ,
        WA_HEIGHT      , 100                                     ,
        WA_LEFT        , 150                                     ,
        WA_TOP         , 0                                       ,
        WA_TITLE       , 'SimpleMenu'                            ,
        WA_CLOSEGADGET , TRUE                                    ,
        TAG_END ] )

      IF ma_window <> NIL

        WHILE ma_result <> FALSE

          WaitPort( ma_window.userport )

          WHILE (ma_imsg1 := GetMsg( ma_window.userport ) ) <> NIL   -> get the message

            CopyMem( ma_imsg1, ma_imsg2, SIZEOF intuimessage )
            ReplyMsg( ma_imsg1 )


            IF ma_imsg2.class = IDCMP_CLOSEWINDOW
              ma_result := FALSE
            ELSEIF ma_imsg2.class = IDCMP_MOUSEBUTTONS

              -> The user has hit a mousebutton - time to open the menu!
              ma_result := Pm_OpenPopupMenuA( ma_window,
              [ PM_MENU , ma_menu       ,
                PM_CODE , ma_imsg2.code ,   -> must always be there
                TAG_END ] ) - 5

            ENDIF

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
