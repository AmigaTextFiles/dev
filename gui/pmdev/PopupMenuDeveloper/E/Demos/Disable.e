/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: Disable.e                                           -- *
 * -- Author......: Daniel Kasmeroglu <raptor@cs.tu-berlin.de>          -- *
 * -- Description.: Port of an example by Henrik Isaksson.              -- *
 * -- ----------------------------------------------------------------- -- *
 * -- Original header:                                                  -- *
 * --                                                                   -- *
 * --   $VER: Disable.c 2.0 (05.09.98)                                  -- *
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
       'utility/tagitem'

MODULE 'popupmenu'


/* -- ----------------------------------------------------------------- -- *
 * --                               Main                                -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC main
PROC main()
DEF ma_window : PTR TO window
DEF ma_menu   : PTR TO popupmenu
DEF ma_imsg1  : PTR TO intuimessage
DEF ma_imsg2  : intuimessage
DEF ma_result

  ma_result := TRUE

  popupmenubase := OpenLibrary( 'popupmenu.library', 9 )
  IF popupmenubase <> NIL

    -> Create a very simple menu...
    ma_menu := PMMenu( 'Plain Simple Menu !' ),
                 PMCheckItem( 'Enable quit?', 10 ), PMEnd,
                 PMBar, PMEnd,
                 PMItem( 'Quit' ),
                   PMSimpleSub,
                     PMItem( 'Quit' ), PM_DISABLED,TRUE, PM_USERDATA, 5, PM_ID, 15, PMEnd,
                   PMEnd,
                 PMEnd,
               End

    IF ma_menu <> NIL

      -> Open a little window
      ma_window := OpenWindowTagList( NIL,
      [ WA_IDCMP       , IDCMP_CLOSEWINDOW OR IDCMP_MOUSEBUTTONS ,
        WA_RMBTRAP     , TRUE               ,
        WA_DRAGBAR     , TRUE               ,
        WA_WIDTH       , 150                ,
        WA_HEIGHT      , 100                ,
        WA_LEFT        , 0                  ,
        WA_TOP         , 0                  ,
        WA_TITLE       , 'Disable & Enable' ,
        WA_CLOSEGADGET , TRUE               ,
        TAG_END ] )

      IF ma_window <> NIL

        WHILE ma_result <> FALSE

          -> Wait for a message
          WaitPort( ma_window.userport )

          -> Get the message
          WHILE (ma_imsg1 := GetMsg( ma_window.userport )) <> NIL

            CopyMem( ma_imsg1, ma_imsg2, SIZEOF intuimessage )
            ReplyMsg( ma_imsg1 )

            IF ma_imsg2.class = IDCMP_CLOSEWINDOW
              ma_result := FALSE
            ELSEIF ma_imsg2.class = IDCMP_MOUSEBUTTONS

              ma_result := Pm_OpenPopupMenuA( ma_window,
              [ PM_MENU,   ma_menu       ,
                PM_CODE,   ma_imsg2.code ,
                TAG_END ] ) - 5
                                                                                
              -> See if "Enable quit?" is checked
              IF Pm_ItemChecked( ma_menu, 10 ) <> FALSE
                -> Find the item and enable it
                Pm_SetItemAttrsA( Pm_FindItem( ma_menu, 15 ), [ PM_DISABLED, FALSE, TAG_END ] )
              ELSE
                -> Find the item and disable it
                Pm_SetItemAttrsA( Pm_FindItem( ma_menu, 15 ), [ PM_DISABLED, TRUE, TAG_END ] )
              ENDIF

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
