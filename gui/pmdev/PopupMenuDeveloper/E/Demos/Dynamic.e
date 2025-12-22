/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: Dynamic.e                                           -- *
 * -- Author......: Daniel Kasmeroglu <raptor@cs.tu-berlin.de>          -- *
 * -- Description.: Port of an example by Henrik Isaksson               -- *
 * -- ----------------------------------------------------------------- -- *
 * -- Original header:                                                  -- *
 * --                                                                   -- *
 * --   $VER: Dynamic.c 1.1 (05.09.98)                                  -- *
 * --                                                                   -- *
 * --   Popup Menu example program                                      -- *
 * --                                                                   -- *
 * --   ©1996-1998 Henrik Isaksson                                      -- *
 * --   All Rights Reserved.                                            -- *
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
 * --                           Declarations                            -- *
 * -- ----------------------------------------------------------------- -- */

-> Just used to find out if the destructor is called.
DEF glo_wascalled


/* -- ----------------------------------------------------------------- -- *
 * --                               Main                                -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC main
PROC main()
DEF ma_window    : PTR TO window
DEF ma_menu      : PTR TO popupmenu
DEF ma_imsg1     : PTR TO intuimessage
DEF ma_imsg2     : intuimessage
DEF ma_construct : hook
DEF ma_destruct  : hook
DEF ma_result

  -> init the random number generator
  RndQ( 1928172 )

  glo_wascalled := FALSE
  ma_result     := TRUE

  -> User Data - you can put anything you like to here.
  inithook( ma_construct , {hoo_SubConstructFunc} )
  inithook( ma_destruct  , {hoo_SubDestructFunc}  )

  popupmenubase := OpenLibrary( 'popupmenu.library', 9 )
  IF popupmenubase <> NIL

    -> Declared at the end of this file.
    ma_menu := glo_MakeTestMenu( ma_construct, ma_destruct )
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
        WA_TITLE       , 'Dynamic Menus' ,
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

        PrintF( 'The destructor hook was \scalled !\n', IF glo_wascalled <> FALSE THEN '' ELSE 'NOT ' )

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
PROC glo_MakeTestMenu( mak_construct, mak_destruct )
DEF mak_menu : PTR TO popupmenu

  mak_menu := PMStartMenu,
                PMItem( 'Dynamic submenu' ),
                  PM_SUBCONSTRUCT , mak_construct ,
                  PM_SUBDESTRUCT  , mak_destruct  ,
                  PMSimpleSub,
                    PMInfo( 'This won\at work unless' ), PMEnd, -> this will be shown if the demo doesn't work
                    PMInfo( 'you get version 7.50 !'  ), PMEnd, -> (maybe an old version of the library)
                  PMEnd,
                PMEnd,
              PMEnd

ENDPROC mak_menu
->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                          Hook-Functions                           -- *
 * -- ----------------------------------------------------------------- -- */

->»» HOOK hoo_SubConstructFunc
PROC hoo_SubConstructFunc( sub_hook, sub_selected : PTR TO popupmenu, sub_handle )
DEF sub_newpm       : PTR TO popupmenu
DEF sub_bfr [ 128 ] : STRING

-> Don't try to open windows, requesters or print text from this
-> hook, wich is called while the menu is still open. (ofcourse)
-> The display might be locked!

  sub_selected := sub_selected.ppm_Sub

  -> A random number to prove that it works...
  StringF( sub_bfr, 'Random number: \d', Rnd( 1000 ) )

  sub_newpm := Pm_MenuA( [ PM_DUMMY, 0,
                 PMItem( sub_bfr ), PM_ID, 200, PMEnd,
               End

  IF sub_newpm <> NIL

    IF sub_selected.ppm_Sub <> NIL

      -> We don't have to worry about freeing the new menu,
      -> as it will be freed automatically. But we do have
      -> to take care of the old menu, since the library
      -> won't know it exists.
      Pm_FreePopupMenu( sub_selected.ppm_Sub )

    ENDIF

    sub_selected.ppm_Sub := sub_newpm

    ->
    -> We can also add items to a previous menu
    ->
    Pm_InsertMenuItemA( sub_newpm,
    [ PM_INSERT_LAST, TRUE,
      PM_INSERT_ITEM, Pm_ItemA( [ PM_TITLE, 'These items have been added'  , TAG_END ] ),
      PM_INSERT_ITEM, Pm_ItemA( [ PM_TITLE, 'to the end of the menu!'      , TAG_END ] ),
      PM_INSERT_ITEM, Pm_ItemA( [ PM_TITLE, 'This item will be removed...' , PM_ID, 100, TAG_END ] ),
      TAG_END ] )

    ->
    -> Let's remove an item too:
    ->
    Pm_RemoveMenuItem( sub_newpm, Pm_FindItem( sub_newpm, 100 ) )

    ->
    -> Let's add another one!
    ->
    Pm_InsertMenuItemA( sub_newpm,
    [ PM_INSERT_AFTERID , 200,
      PM_INSERT_ITEM    , Pm_ItemA( [ PM_TITLE, ',,^..^,,', TAG_END ] ),
      TAG_END ] )

  ENDIF

  -> If you return NULL, no menu will be opened.
ENDPROC sub_selected.ppm_Sub
->»»>

->»» HOOK hoo_SubDestructFunc
PROC hoo_SubDestructFunc( sub_hook, sub_parent : PTR TO popupmenu, sub_handle )

-> Don't try to open windows, requesters or print text from this
-> hook, wich is called while the menu is still open. (of course)
-> The display might be locked!

->
-> Here you can do something with your item's userdata...
->
->      sub_parent.ppm_Sub.ppm_UserData := 0
->
-> ...or free the submenu, if you want to. Otherwise it will be free'd
-> when you free the rest of the menu. If you decide to free the menu,
-> remember to set sub_parent.ppm_Sub to NIL.
->
->      Pm_FreePopupMenu( sub_parent.ppm_Sub )
->      sub_parent.ppm_Sub := NIL
->

  -> Only to find out if this works...
  glo_wascalled := TRUE

ENDPROC
->»»>

