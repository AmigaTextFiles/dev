/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: Demo.e                                              -- *
 * -- Author......: Daniel Kasmeroglu <raptor@cs.tu-berlin.de>          -- *
 * -- Description.: Port of an example by Henrik Isaksson.              -- *
 * -- ----------------------------------------------------------------- -- *
 * -- Original header:                                                  -- *
 * --                                                                   -- *
 * --   $VER: Demo.c 2.1 (05.09.98)                                     -- *
 * --                                                                   -- *
 * --   Popup Menu example program                                      -- *
 * --                                                                   -- *
 * --   ©1996-1997 Henrik Isaksson                                      -- *
 * --   All Rights Reserved.                                            -- *
 * --                                                                   -- *
 * --   Run and click the mouse in the window and over the dragbar!     -- *
 * --   (two different menus)                                           -- *
 * --                                                                   -- *
 * -- ----------------------------------------------------------------- -- */

/* -- ----------------------------------------------------------------- -- *
 * --                              Options                              -- *
 * -- ----------------------------------------------------------------- -- */

OPT PREPROCESS       -> enable preprocessor


/* -- ----------------------------------------------------------------- -- *
 * --                              Modules                              -- *
 * -- ----------------------------------------------------------------- -- */

MODULE 'libraries/popupmenu'  ,
       'intuition/intuition'  ,
       'utility/tagitem'      ,
       'utility/hooks'        ,
       'tools/inithook'       

MODULE 'popupmenu'


/* -- ----------------------------------------------------------------- -- *
 * --                               Main                                -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC main
PROC main()
DEF ma_window  : PTR TO window
DEF ma_menu1   : PTR TO popupmenu
DEF ma_menu2   : PTR TO popupmenu
DEF ma_imsg1   : PTR TO intuimessage
DEF ma_imsg2   : intuimessage
DEF ma_handler : hook
DEF ma_result

  ma_result := TRUE

  inithook( ma_handler, {hoo_MenuHandlerFunc}, {ma_result} )

  popupmenubase := OpenLibrary( 'popupmenu.library', 9 )
  IF popupmenubase <> NIL

    ma_menu1 := PMMenu( 'Run Demos' ),
                  PMItem( 'Disable' ),
                    PMSimpleSub,
                      PMInfo( 'This demo shows how to read the' ), PMEnd,
                      PMInfo( 'state of a checkmark, and'       ), PMEnd,
                      PMInfo( 'how to disable & enable an item' ), PMEnd,
                      PMInfo( 'and its submenu.'                ), PMEnd,
                      PMBar, PMEnd,
                      PMItem( 'Run the demo !' ), PM_USERDATA, 'Disable', PMEnd,
                    PMEnd,
                  PMEnd,
                  PMItem( 'PullDownMenu' ),
                    PMSimpleSub,
                      PMInfo( 'The PullDownMenu demo shows how'   ), PMEnd,
                      PMInfo( 'you can use the popupmenu.library' ), PMEnd,
                      PMInfo( 'for pulldown menus !'              ), PMEnd,
                      PMBar, PMEnd,
                      PMItem( 'Run the demo !' ), PM_USERDATA, 'PullDownMenu', PMEnd,
                    PMEnd,
                  PMEnd,
                  PMItem( 'MenuVerify' ),
                    PMSimpleSub,
                      PMInfo(' This example uses the'      ), PMEnd,
                      PMInfo( 'IDCMP_MENUVERIFY flag to'   ), PMEnd,
                      PMInfo( 'combine standard intuition' ), PMEnd,
                      PMInfo( 'menus with popupmenus int'  ), PMEnd,
                      PMInfo( 'the same window !'          ), PMEnd,
                      PMBar, PMEnd,
                      PMItem( 'Run the demo !' ), PM_USERDATA, 'MenuVerify', PMEnd,
                    PMEnd,
                  PMEnd,
                  PMItem( 'StartMenu' ),
                    PMSimpleSub,
                      PMInfo( 'This demo shows how to put'   ), PMEnd,
                      PMInfo( 'images in you menus.'         ), PMEnd,
                      PMInfo( 'You can find the menu at the' ), PMEnd,
                      PMInfo( 'bottom of the screen.'        ), PMEnd,
                      PMBar, PMEnd,
                      PMItem( 'Run the demo !' ), PM_USERDATA, 'StartMenu', PMEnd,
                    PMEnd,
                  PMEnd,
                  PMItem( 'Palette' ),
                    PMSimpleSub,
                      PMInfo( 'Popup menus can be used to' ), PMEnd,
                      PMInfo( 'choose colours from too...' ), PMEnd,
                      PMBar, PMEnd,
                      PMItem( 'Colours' ),
                        PMSimpleSub,
                          PMCheckItem( 'Background' , 1 ), PM_COLOURBOX, 0, End,
                          PMCheckItem( 'Shadow'     , 1 ), PM_COLOURBOX, 1, End,
                          PMCheckItem( 'Shine'      , 1 ), PM_COLOURBOX, 2, End,
                          PMCheckItem( 'Fill'       , 1 ), PM_COLOURBOX, 3, End,
                          PMCheckItem( 'Halfshadow' , 1 ), PM_COLOURBOX, 4, End,
                          PMCheckItem( 'Halfshine'  , 1 ), PM_COLOURBOX, 5, End,
                          PMBar, PMEnd,
                          PMItem( 'Use colour 1' ), PM_COLOURBOX, 9,  End,
                          PMItem( 'Use colour 2' ), PM_COLOURBOX, 10, End,
                          PMItem( 'Use colour 3' ), PM_COLOURBOX, 11, End,
                        PMEnd,
                      PMEnd,
                    PMEnd,
                  PMEnd,
                End

    ma_menu2 := PMMenu( 'PopupMenu Demo' ),
                  PMItem( 'About...' ), PMEnd,
                  PMBar, PMEnd,
                  PMItem( 'Quit' ), PM_ID, 5, PMEnd,
                End

    IF (ma_menu1 <> NIL) AND (ma_menu2 <> NIL)

      -> Open a little window
      ma_window := OpenWindowTagList( NIL,
      [ WA_IDCMP       , IDCMP_CLOSEWINDOW OR IDCMP_MOUSEBUTTONS ,
        WA_RMBTRAP     , TRUE              ,
        WA_DRAGBAR     , TRUE              ,
        WA_LEFT        , 150               ,
        WA_TOP         , 100               ,
        WA_WIDTH       , 150               ,
        WA_HEIGHT      , 100               ,
        WA_SIZEGADGET  , TRUE              ,
        WA_DEPTHGADGET , TRUE              ,
        WA_MINWIDTH    , 150               ,
        WA_MAXWIDTH    , 1280              ,
        WA_MINHEIGHT   , 100               ,
        WA_MAXHEIGHT   , 1024              ,
        WA_TITLE       , 'Popup Menu Demo' ,
        WA_CLOSEGADGET , TRUE              ,
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

              IF (ma_imsg2.code = MENUDOWN) OR (ma_imsg2.code = MENUUP)

                IF ma_window.mousey > ma_window.bordertop
                  Pm_OpenPopupMenuA( ma_window,
                  [ PM_MENU        , ma_menu1      ,
                    PM_CODE        , ma_imsg2.code ,
                    PM_MENUHANDLER , ma_handler    ,
                    TAG_END ] )
                ELSE
                  Pm_OpenPopupMenuA( ma_window,
                  [ PM_MENU        , ma_menu2      ,
                    PM_CODE        , ma_imsg2.code ,
                    PM_MENUHANDLER , ma_handler    ,
                    TAG_END ] )
                ENDIF

              ENDIF

            ENDIF

          ENDWHILE

        ENDWHILE

        CloseWindow( ma_window )

      ELSE
        PrintF( 'Window error !\n' )
      ENDIF

    ELSE
      PrintF( 'Menu error !\n' )
    ENDIF

    IF ma_menu1 <> NIL THEN Pm_FreePopupMenu( ma_menu1 )
    IF ma_menu2 <> NIL THEN Pm_FreePopupMenu( ma_menu2 )

    CloseLibrary( popupmenubase )

  ELSE
    PrintF( 'Cannot open "popupmenu.library" v9+ !\n' )
  ENDIF

ENDPROC
->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                          Hook-Functions                           -- *
 * -- ----------------------------------------------------------------- -- */

->»» HOOK hoo_MenuHandlerFunc
PROC hoo_MenuHandlerFunc( men_hook : PTR TO hook, men_object, men_msg )
DEF men_menu        : PTR TO popupmenu
DEF men_bfr [ 128 ] : STRING

  men_menu := men_object
  IF men_menu.ppm_UserData <> NIL

    StringF( men_bfr, 'RUN <>NIL: \s', men_menu.ppm_UserData )
    IF FileLength( men_menu.ppm_UserData ) > 0 THEN Execute( men_bfr, NIL, NIL )

  ENDIF

  -> ID 5 means quit
  IF men_menu.ppm_ID = 5 THEN PutLong( men_hook.data, FALSE )

ENDPROC
->»»>

