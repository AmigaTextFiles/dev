/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: LocaleMenu.e                                        -- *
 * -- Author......: Daniel Kasmeroglu <raptor@cs.tu-berlin.de>          -- *
 * -- Description.: Port of an example by Henrik Isaksson               -- *
 * -- ----------------------------------------------------------------- -- *
 * -- Original header:                                                  -- *
 * --                                                                   -- *
 * -- $VER: LocaleMenu.c 1.0 (23.08.99)                                 -- *
 * --                                                                   -- *
 * -- Popup Menu example program                                        -- *
 * --                                                                   -- *
 * -- ©1996-1998 Henrik Isaksson                                        -- *
 * -- All Rights Reserved.                                              -- *
 * --                                                                   -- *
 * -- This example shows how to use the LocaleHook feature of           -- *
 * -- popupmenu.library.                                                -- *
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
 * --                            Constants                              -- *
 * -- ----------------------------------------------------------------- -- */

ENUM ID_QUIT = 1 ,   -> Use anything but 0 for the ID.
     ID_ITEM     ,
     ID_TITLE


/* -- ----------------------------------------------------------------- -- *
 * --                              Globals                              -- *
 * -- ----------------------------------------------------------------- -- */

DEF glo_strings : PTR TO LONG


/* -- ----------------------------------------------------------------- -- *
 * --                               Main                                -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC main
PROC main()
DEF ma_window    : PTR TO window
DEF ma_menu      : PTR TO popupmenu
DEF ma_imsg1     : PTR TO intuimessage
DEF ma_hook      : hook
DEF ma_imsg2     : intuimessage
DEF ma_result

  glo_strings   := [ 'Quit', 'Menu Item', 'Menu Title' ]

  ma_result     := TRUE

  inithook( ma_hook, {glo_GetStringFunc} )

  popupmenubase := OpenLibrary( 'popupmenu.library', 9 )
  IF popupmenubase <> NIL

    -> Declared at the end of this file.
    ma_menu := PMMenuID( ID_TITLE ),
                 PMItemID( ID_ITEM ), PMEnd,
                 PMBar, PMEnd,
                 PMItemID( ID_QUIT ), PM_USERDATA, 5, PMEnd,
               PMEnd

    IF ma_menu <> NIL

      -> Open a little window
      ma_window := OpenWindowTagList( NIL,
      [ WA_IDCMP       , IDCMP_CLOSEWINDOW OR IDCMP_MOUSEBUTTONS ,
        WA_RMBTRAP     , TRUE            ,
        WA_DRAGBAR     , TRUE            ,
        WA_WIDTH       , 150             ,
        WA_HEIGHT      , 100             ,
        WA_LEFT        , 0               ,
        WA_TOP         , 100             ,
        WA_TITLE       , 'LocaleHook'    ,
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

              ma_result := Pm_OpenPopupMenuA( ma_window, [ PM_MENU, ma_menu, PM_LOCALEHOOK, ma_hook, TAG_END ] )
              ma_result := ma_result <> 5

              -> Maybe a bit confusing... Well, PM_OpenPopupMenu
              -> returns 0 if no item was select, so we can't just
              -> assign the return value to ma_result.
              -> There is another (better?) way of handling the input;
              -> the PM_MenuHandler tag. 
                
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
 * --                           Hook-Functions                          -- *
 * -- ----------------------------------------------------------------- -- */

PROC glo_GetStringFunc( get_hook, get_popupmenu, get_idptr : PTR TO LONG )
        
-> You should call the locale.library function 
-> GetCatalogStr() (or similar) here. 
->
-> Example: 
->
-> RETURN GetCatalogStr(catalog, get_idptr[], strings[get_idptr[]-1]); 
->
-> (the last argument is the default string, which is 
-> returned if the ID was not fount in the catalog.) 
        
ENDPROC glo_strings[ get_idptr[] - 1 ]

