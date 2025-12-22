/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: MenuVerify.e                                        -- *
 * -- Author......: Daniel Kasmeroglu <raptor@cs.tu-berlin.de>          -- *
 * -- Description.: Port of an example by Henrik Isaksson.              -- *
 * -- ----------------------------------------------------------------- -- *
 * -- Original header:                                                  -- *
 * --                                                                   -- *
 * --   $VER: MenuVerify.c 1.1 (05.09.98)                               -- *
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

MODULE 'libraries/popupmenu'  ,
       'intuition/intuition'  ,
       'utility/tagitem'      

MODULE 'popupmenu'


/* -- ----------------------------------------------------------------- -- *
 * --                               Main                                -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC main
PROC main()
DEF ma_window : PTR TO window
DEF ma_pmenu  : PTR TO popupmenu
DEF ma_text1  : PTR TO intuitext
DEF ma_text2  : PTR TO intuitext
DEF ma_item1  : PTR TO menuitem
DEF ma_item2  : PTR TO menuitem
DEF ma_imenu  : PTR TO menu
DEF ma_imsg1  : PTR TO intuimessage
DEF ma_imsg2  : intuimessage
DEF ma_result,ma_menu

  ma_result := TRUE
  ma_menu   := FALSE

  -> Just a badly coded intuition menu....
  ma_text1  := [ 2, 1, 1, 1, 1, 0, 'First Item' , NIL ]:intuitext
  ma_text2  := [ 2, 1, 1, 1, 1, 0, 'Last Item'  , NIL ]:intuitext

  ma_item1  := [ NIL      , 0, 15 , 100, 10, ITEMENABLED OR ITEMTEXT OR HIGHCOMP, 0, ma_text2, NIL, 0, NIL, 0 ]:menuitem
  ma_item2  := [ ma_item1 , 0, 0  , 100, 10, ITEMENABLED OR ITEMTEXT OR HIGHCOMP, 0, ma_text1, NIL, 0, NIL, 0 ]:menuitem

  ma_imenu  := [ NIL, 0, 0, 100, 12, MENUENABLED, 'Project', ma_item2, 0, 0, 0, 0 ]:menu

  popupmenubase := OpenLibrary( 'popupmenu.library', 9 )
  IF popupmenubase <> NIL

    -> Create a very simple menu...
    ma_pmenu := PMMenu( 'Inside the window !' ),
                  PMItem( 'This example shows'  ), PM_NOSELECT, TRUE, PMEnd,
                  PMItem( 'how to use popup'    ), PM_NOSELECT, TRUE, PMEnd,
                  PMItem( 'menus and intuition' ), PM_NOSELECT, TRUE, PMEnd,
                  PMItem( 'menus in the same'   ), PM_NOSELECT, TRUE, PMEnd,
                  PMItem( 'window!'             ), PM_NOSELECT, TRUE, PMEnd,
                  PMBar, PMEnd,
                  PMItem( 'Quit' ), PM_USERDATA, 5, PMEnd,
                PMEnd

    IF ma_pmenu <> NIL

      ma_window := OpenWindowTagList( NIL,
      [ WA_IDCMP       , IDCMP_CLOSEWINDOW OR IDCMP_MOUSEBUTTONS OR IDCMP_MENUVERIFY ,
        WA_DRAGBAR     , TRUE              ,
        WA_WIDTH       , 150               ,
        WA_HEIGHT      , 100               ,
        WA_LEFT        , 150               ,
        WA_TOP         , 0                 ,
        WA_TITLE       , 'MenuVerify Demo' ,
        WA_CLOSEGADGET , TRUE              ,
        TAG_END ] )

      IF ma_window <> NIL

        SetMenuStrip( ma_window, ma_imenu )

        WHILE ma_result <> FALSE

          -> Wait for a message
          WaitPort( ma_window.userport )

          -> Get the message
          WHILE (ma_imsg1 := GetMsg( ma_window.userport )) <> NIL

            -> Copy the contents of it
            CopyMem( ma_imsg1, ma_imsg2, SIZEOF intuimessage )

            -> Check if the user wants to see the menu
            IF ma_imsg1.class = IDCMP_MENUVERIFY

              -> Check if the mouse in our window
              IF (ma_imsg1.mousey > 0) AND (ma_imsg1.mousey < ma_window.height) AND
                 (ma_imsg1.mousex > 0) AND (ma_imsg1.mousex < ma_window.width)
                                                           
                -> Cancel the intuition menu
                ma_imsg1.code  := MENUCANCEL
                -> Make sure the menu gets opened...
                ma_imsg1.class := IDCMP_MOUSEBUTTONS
                -> (we fake a IDCMP_MOUSEBUTTONS message)
                ma_imsg1.code  := MENUDOWN

              ENDIF

            ENDIF

            -> Reply the message
            ReplyMsg( ma_imsg1 )

            IF ma_imsg1.class = IDCMP_CLOSEWINDOW
              ma_result := FALSE
            ELSEIF ma_imsg1.class = IDCMP_MOUSEBUTTONS

               -> Open only if the right (that is the
               -> right button, in this case :) ) button was hit
               IF (ma_imsg1.code = MENUUP) OR (ma_imsg1.code = MENUDOWN)

                  ma_result := Pm_OpenPopupMenuA( ma_window,
                  [ PM_MENU, ma_pmenu      ,
                    PM_CODE, ma_imsg1.code ,  -> This will ensure that the user can change
                    TAG_END ] ) - 5           -> the time of apperance for the menu.

               ENDIF

            ENDIF

          ENDWHILE

        ENDWHILE

        ClearMenuStrip( ma_window )
        CloseWindow( ma_window )

      ELSE
        PrintF( 'Window error !\n' )
      ENDIF

      Pm_FreePopupMenu( ma_pmenu )

    ELSE
      PrintF( 'Menu error !\n' )
    ENDIF
    CloseLibrary( popupmenubase )

  ELSE
    PrintF( 'Cannot open "popupmenu.library" v9+ !\n' )
  ENDIF

ENDPROC
->»»>
