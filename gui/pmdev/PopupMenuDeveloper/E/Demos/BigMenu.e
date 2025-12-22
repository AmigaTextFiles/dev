/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: BigMenu.e                                           -- *
 * -- Author......: Daniel Kasmeroglu <raptor@cs.tu-berlin.de>          -- *
 * -- Description.: Port of an example bby Henrik Isaksson.             -- *
 * -- ----------------------------------------------------------------- -- *
 * -- Original header:                                                  -- *
 * --                                                                   -- *
 * --   $VER: BigMenu.c 1.6 (05.09.98)                                  -- *
 * --                                                                   -- *
 * --   Popup Menu library test program                                 -- *
 * --                                                                   -- *
 * --   ©1996-1997 Henrik Isaksson                                      -- *
 * --   All Rights Reserved.                                            -- *
 * --                                                                   -- *
 * --   Run and click the mouse in the window!                          -- *
 * --   This little hack is intended to test the submenus.              -- *
 * --                                                                   -- *
 * --   WARNING! When the menu runs out of stack, it will end           -- *
 * --   in a crash!                                                     -- *
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

->»» PROC main
PROC main()
DEF ma_window      : PTR TO window
DEF ma_menu        : PTR TO popupmenu
DEF ma_prev        : PTR TO popupmenu
DEF ma_imsg1       : PTR TO intuimessage
DEF ma_imsg2       : intuimessage
DEF ma_bfr [ 50 ]  : STRING
DEF ma_result,ma_i

  ma_result := TRUE
  ma_prev   := NIL

  popupmenubase := OpenLibrary( 'popupmenu.library', 9 )
  IF popupmenubase <> NIL

    ma_prev := PMStartMenu,
                 PMInfo( 'Congratulations!!'     ), PMEnd,
                 PMInfo( 'You\ave shown a great' ), PMEnd,
                 PMInfo( 'deal of patience'      ), PMEnd,
                 PMInfo( 'working your way'      ), PMEnd,
                 PMInfo( 'through all theese'    ), PMEnd,
                 PMInfo( 'menus!'                ), PMEnd,
                 PMInfo( 'You will now be'       ), PMEnd,
                 PMInfo( 'rewarded with a'       ), PMEnd,
                 PMInfo( 'menu option that'      ), PMEnd,
                 PMInfo( 'lets you stop'         ), PMEnd,
                 PMInfo( 'browsing through'      ), PMEnd,
                 PMInfo( 'the menus...'          ), PMEnd,
                 PMBar, PMEnd,
                 PMItem( 'Quit' ), PM_USERDATA, 5, PMEnd,
               End

    FOR ma_i := 0 TO 19

      StringF( ma_bfr, 'SubMenu #\d', 20 - ma_i )
      ma_prev := PMStartMenu,
                   PMInfo( ma_bfr ), PMEnd,
                   PMItem( 'Next Submenu' ), PM_SUB, ma_prev, PMEnd,
                 End

    ENDFOR

    -> Create a big menu...
    ma_menu := PMMenu( 'Big Menu' ),
                 PMInfo( 'WARNING: Before you open all' ), PMEnd,
                 PMInfo( 'the submenus, make sure you'  ), PMEnd,
                 PMInfo( 'have enough stack!'           ), PMEnd,
                 PMInfo( 'Set it to at least 10k.'      ), PMEnd,
                 PMBar, PMEnd,
                 PMItem( 'Submenu' ), PM_SUB, ma_prev, PMEnd,
                 PMBar,  End,
                 PMItem( 'Quit'    ), PM_USERDATA, 5, PMEnd,
               End

    IF ma_menu <> NIL

      -> Open a little window
      ma_window := OpenWindowTagList( NIL,
      [ WA_IDCMP       , IDCMP_CLOSEWINDOW OR IDCMP_MOUSEBUTTONS ,
        WA_RMBTRAP     , TRUE      ,
        WA_DRAGBAR     , TRUE      ,
        WA_WIDTH       , 150       ,
        WA_HEIGHT      , 100       ,
        WA_LEFT        , 150       ,
        WA_TOP         , 0         ,
        WA_TITLE       , 'BigMenu' ,
        WA_CLOSEGADGET , TRUE      ,
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
              [ PM_MENU, ma_menu       ,
                PM_CODE, ma_imsg2.code , -> Must always be there!
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

