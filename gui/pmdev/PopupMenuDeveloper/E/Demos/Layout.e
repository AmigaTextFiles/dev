/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: Layout.e                                            -- *
 * -- Author......: Daniel Kasmeroglu <raptor@cs.tu-berlin.de>          -- *
 * -- Description.: Port of an example by Henrik Isaksson               -- *
 * -- ----------------------------------------------------------------- -- *
 * -- Original header:                                                  -- *
 * --                                                                   -- *
 * -- $VER: Layout.c 1.0 (16.07.99)                                     -- *
 * --                                                                   -- *
 * -- Popup Menu example program                                        -- *
 * --                                                                   -- *
 * -- ©1996-1998 Henrik Isaksson                                        -- *
 * -- All Rights Reserved.                                              -- *
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
       'utility/tagitem'     ,
       'utility/hooks'       ,
       'tools/inithook'      

MODULE 'popupmenu'


/* -- ----------------------------------------------------------------- -- *
 * --                               Main                                -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC main
PROC main()
DEF ma_window    : PTR TO window
DEF ma_menu      : PTR TO popupmenu
DEF ma_imsg1     : PTR TO intuimessage
DEF ma_imsg2     : intuimessage
DEF ma_result

  ma_result     := TRUE

  popupmenubase := OpenLibrary( 'popupmenu.library', 9 )
  IF popupmenubase <> NIL

    -> Declared at the end of this file.
    ma_menu := glo_MakeTestMenu()
    IF ma_menu <> NIL

      -> Open a little window
      ma_window := OpenWindowTagList( NIL,
      [ WA_IDCMP       , IDCMP_CLOSEWINDOW OR IDCMP_MOUSEBUTTONS OR IDCMP_VANILLAKEY ,
        WA_RMBTRAP     , TRUE            ,
        WA_DRAGBAR     , TRUE            ,
        WA_WIDTH       , 150             ,
        WA_HEIGHT      , 100             ,
        WA_LEFT        , 0               ,
        WA_TOP         , 100             ,
        WA_TITLE       , 'Layout' ,
        WA_CLOSEGADGET , TRUE            ,
        TAG_END ] )

      IF ma_window <> NIL

        WHILE ma_result <> FALSE

          -> Wait for a message
          WaitPort( ma_window.userport )

          -> Get the message
          WHILE (ma_imsg1 := GetMsg( ma_window.userport )) <> NIL

            -> Copy the contents of it
            CopyMem( ma_imsg1, ma_imsg2, SIZEOF intuimessage )

            -> Reply the message
            ReplyMsg( ma_imsg1 )

            IF ma_imsg2.class = IDCMP_MOUSEBUTTONS
              Pm_OpenPopupMenuA( ma_window, [ PM_MENU, ma_menu, TAG_END ] )
            ELSEIF ma_imsg2.class = IDCMP_CLOSEWINDOW
              -> See if the user wants to quit
              ma_result := FALSE
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


/* -- ----------------------------------------------------------------- -- *
 * --                             Functions                             -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC glo_MakeTestMenu
PROC glo_MakeTestMenu()
DEF mak_menu : PTR TO popupmenu

  mak_menu := PMMenu( 'Group Layout' ),
              PMHoriz,
                PMMembers,
                  PMItem( 'Left' ), 
                    PM_CENTER, TRUE, 
                  PMEnd,
                  PMVert,
                    PMMembers,
                      PMItem( 'Item 1' ), PM_CENTER, TRUE, PMEnd,
                      PMItem( 'Item 2' ), PM_CENTER, TRUE, PMEnd,
                      PMItem( 'Item 3' ), PM_CENTER, TRUE, PMEnd,
                      PMItem( 'Item 4' ), PM_CENTER, TRUE, PMEnd,
                      PMItem( 'Item 5' ), PM_CENTER, TRUE, PMEnd,
                      PMItem( 'Item 6' ), PM_CENTER, TRUE, PMEnd,
                    PMEnd,
                  PMEnd,
                  PMItem( 'Right' ), 
                    PM_CENTER, TRUE, 
                  PMEnd,
                PMEnd,
              PMEnd,
              PMBar, PMEnd,
              PMVert,
                PMMembers,
                  PMHoriz,
                    PMMembers,
                      PMColBox(1), PMEnd,
                      PMColBox(2), PMEnd,
                      PMColBox(3), PMEnd,
                      PMColBox(4), PMEnd,
                      PMColBox(5), PMEnd,
                      PMColBox(6), PMEnd,
                      PMColBox(7), PMEnd,
                      PMColBox(8), PMEnd,
                      PMColBox(9), PMEnd,
                      PMColBox(0), PMEnd,
                    PMEnd,
                  PMEnd,
                  PMHoriz,
                    PMMembers,
                      PMColBox(11), PMEnd,
                      PMColBox(12), PMEnd,
                      PMColBox(13), PMEnd,                    
                      PMColBox(14), PMEnd,
                      PMColBox(15), PMEnd,
                      PMColBox(16), PMEnd,
                      PMColBox(17), PMEnd,
                      PMColBox(18), PMEnd,
                      PMColBox(19), PMEnd,
                      PMColBox(10), PMEnd,
                    PMEnd,
                  PMEnd,
                  PMHoriz,
                    PMMembers,
                      PMColBox(21), PMEnd,
                      PMColBox(22), PMEnd,
                      PMColBox(23), PMEnd,
                      PMColBox(24), PMEnd,
                      PMColBox(25), PMEnd,
                      PMColBox(26), PMEnd,
                      PMColBox(27), PMEnd,
                      PMColBox(28), PMEnd,
                      PMColBox(29), PMEnd,
                      PMColBox(20), PMEnd,
                    PMEnd,
                  PMEnd,
                  PMHoriz,
                    PMMembers,
                      PMColBox(31), PMEnd,
                      PMColBox(32), PMEnd,
                      PMColBox(33), PMEnd,
                      PMColBox(34), PMEnd,
                      PMColBox(35), PMEnd,
                      PMColBox(36), PMEnd,
                      PMColBox(37), PMEnd,
                      PMColBox(38), PMEnd,
                      PMColBox(39), PMEnd,
                      PMColBox(30), PMEnd,
                    PMEnd,
                  PMEnd,
                  PMHoriz,
                    PMMembers,
                      PMColBox(41), PMEnd,
                      PMColBox(42), PMEnd,
                      PMColBox(43), PMEnd,
                      PMColBox(44), PMEnd,
                      PMColBox(45), PMEnd,
                      PMColBox(46), PMEnd,
                      PMColBox(47), PMEnd,
                      PMColBox(48), PMEnd,
                      PMColBox(49), PMEnd,
                      PMColBox(40), PMEnd,
                    PMEnd,
                  PMEnd,
                PMEnd,
              PMEnd,
              PMBar, PMEnd,
              PMItem( 'Quit' ), PMEnd,
	    PMEnd
	
ENDPROC mak_menu
->»»>
