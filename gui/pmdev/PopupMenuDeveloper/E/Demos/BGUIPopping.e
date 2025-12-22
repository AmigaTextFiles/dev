/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: BGUIPopping.e                                       -- *
 * -- Author......: Daniel Kasmeroglu <raptor@cs.tu-berlin.de>          -- *
 * -- Description.: "popupmenu.library" together with "bgui.library".   -- *
 * -- ----------------------------------------------------------------- -- */

/* -- ----------------------------------------------------------------- -- *
 * --                              Options                              -- *
 * -- ----------------------------------------------------------------- -- */

OPT REG = 5          -> register-optimisation
OPT PREPROCESS       -> enable preprocessor


/* -- ----------------------------------------------------------------- -- *
 * --                              Modules                              -- *
 * -- ----------------------------------------------------------------- -- */

->»» LIST OF MODULES
MODULE 'libraries/popupmenu'   ,
       'libraries/gadtools'    ,
       'libraries/bguim'       ,
       'libraries/bgui'        ,
       'bgui/bgui_image'       ,
       'utility/tagitem'       ,
       'utility/hooks'         ,
       'intuition/classes'     ,
       'intuition/gadgetclass' ,
       'intuition/intuition'   ,
       'tools/inithook'        ,
       'tools/boopsi'

MODULE 'popupmenu' ,
       'bgui'

->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                             Constants                             -- *
 * -- ----------------------------------------------------------------- -- */

CONST GID_QUIT     = 1 ,
      GROUP_MAIN   = 2 ,
      NUMBER       = 3 ,
      MENUID_PEXIT = 4 ,  -> Exit-ID for popupmenu.library
      MENUID_BEXIT = 5    -> Exit-ID for bgui.library


/* -- ----------------------------------------------------------------- -- *
 * --                            Structures                             -- *
 * -- ----------------------------------------------------------------- -- */

->»» OBJECT testgui
OBJECT testgui
  tes_ObjectWindow      : PTR TO object     -> bgui-object window
  tes_Window            : PTR TO window     -> intuition window
  tes_Gadgets[ NUMBER ] : ARRAY OF LONG     -> addresses of objects
  tes_Menu              : PTR TO popupmenu  -> popupmenu-structure
  tes_NewMenu           : PTR TO newmenu    -> newmenu-structure
  tes_Hook              : hook              -> a simple hook-structure
ENDOBJECT
->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                              Methods                              -- *
 * -- ----------------------------------------------------------------- -- */

->»» METHOD tes_Constructor
PROC tes_Constructor() OF testgui

  self.tes_Menu := PMMenu( 'Read Me' ),
                     PMInfo( 'This little example'   ), PMEnd,
                     PMInfo( 'shows you how to use'  ), PMEnd,
                     PMInfo( 'the popupmenu.library' ), PMEnd,
                     PMInfo( 'together with a bgui-' ), PMEnd,
                     PMInfo( 'based application.'    ), PMEnd,
                     PMInfo( 'It shows that you can' ), PMEnd,
                     PMInfo( 'mix up "bgui" and'     ), PMEnd,
                     PMInfo( 'popup-menus :)'        ), PMEnd,
                     PMBar, PMEnd,
                     PMItem( 'Click me to exit !' ), PM_USERDATA, MENUID_PEXIT, PMEnd,
                   PMEnd

  IF self.tes_Menu = NIL THEN Raise( "MEM" )

  inithook( self.tes_Hook, {hoo_IDCMPHook}, self )

  self.tes_NewMenu := StartMenu,
                        Title( 'Read Me' ),
                          Item( 'This menu was made'   , NIL, 1000 ),
                          Item( 'with the help of'     , NIL, 1000 ),
                          Item( 'the "bgui.library" !' , NIL, 1000 ),
                          ItemBar,
                          Item( 'Click ME to exit !', 'Q', MENUID_BEXIT ),
                      End


  self.tes_Gadgets[ GID_QUIT ] := KeyButton( 'Quit', GID_QUIT )

  self.tes_Gadgets[ GROUP_MAIN ] := VGroupObject,
                                      ShineRaster,
                                      FRM_Type,        FRTYPE_NONE,
                                      HOffset(16),
                                      VOffset(8),
                                      StartMember,
                                        self.tes_Gadgets[ GID_QUIT ],
                                        FixMinHeight,
                                      EndMember,
                                    EndObject

  self.tes_ObjectWindow := WindowObject,
                             WINDOW_Title         , 'PopupMenu Demo',
                             WINDOW_AutoAspect    , TRUE,
                             WINDOW_SmartRefresh  , TRUE,
                             WINDOW_AutoKeyLabel  , TRUE,
                             WINDOW_IDCMPHook     , self.tes_Hook,
                             WINDOW_IDCMPHookBits , IDCMP_MOUSEBUTTONS,
                             WINDOW_MenuStrip     , self.tes_NewMenu,
                             WINDOW_MasterGroup   , self.tes_Gadgets[ GROUP_MAIN ],
                           EndObject

  IF self.tes_ObjectWindow = NIL THEN Raise( "MEM" )

ENDPROC
->»»>

->»» METHOD tes_StartInterface
PROC tes_StartInterface() OF testgui
DEF sta_signal,sta_rc,sta_wait

  self.tes_Window := WindowOpen( self.tes_ObjectWindow )
  IF self.tes_Window <> NIL

    GetAttr( WINDOW_SigMask, self.tes_ObjectWindow, {sta_signal} )

    sta_wait := TRUE
    WHILE sta_wait <> FALSE

      Wait( sta_signal )

      WHILE (sta_rc := HandleEvent( self.tes_ObjectWindow )) <> WMHI_NOMORE

        SELECT sta_rc
        CASE WMHI_CLOSEWINDOW ; sta_wait := FALSE
        CASE GID_QUIT         ; sta_wait := FALSE
        CASE MENUID_PEXIT
          PrintF( 'You\ave used the "popupmenu.library" to quit this app !\n' )
          sta_wait := FALSE
        CASE MENUID_BEXIT
          PrintF( 'You\ave used the "bgui.library" to quit this app !\n' )
          sta_wait := FALSE
        ENDSELECT

      ENDWHILE

    ENDWHILE

    WindowClose( self.tes_ObjectWindow )

  ENDIF

ENDPROC
->»»>

->»» METHOD end
PROC end() OF testgui
  IF self.tes_ObjectWindow <> NIL
    DisposeObject( self.tes_ObjectWindow )
  ELSEIF self.tes_Gadgets[ GROUP_MAIN ] <> NIL
    DisposeObject( self.tes_Gadgets[ GROUP_MAIN ] )
  ENDIF
  IF self.tes_Menu <> NIL THEN Pm_FreePopupMenu( self.tes_Menu )
ENDPROC
->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                               Main                                -- *
 * -- ----------------------------------------------------------------- -- */

->»» PROC main
PROC main() HANDLE
DEF ma_object : PTR TO testgui

  ma_object := NIL
  bguibase  := OpenLibrary( 'bgui.library', 41 )
  IF bguibase = NIL THEN Raise( "LIB" )

  popupmenubase := OpenLibrary( 'popupmenu.library', 9 )
  IF popupmenubase = NIL THEN Raise( "LIB" )

  NEW ma_object.tes_Constructor()
  ma_object.tes_StartInterface()

EXCEPT DO
  IF ma_object     <> NIL THEN END ma_object
  IF popupmenubase <> NIL THEN CloseLibrary( popupmenubase )
  IF bguibase      <> NIL THEN CloseLibrary( bguibase      )
ENDPROC
->»»>


/* -- ----------------------------------------------------------------- -- *
 * --                          Hook-Functions                           -- *
 * -- ----------------------------------------------------------------- -- */

->»» HOOK hoo_IDCMPHook
PROC hoo_IDCMPHook( idc_hook : PTR TO hook, idc_object, idc_msg : PTR TO intuimessage )
DEF idc_data : PTR TO testgui
DEF idc_result

  IF idc_msg.class = IDCMP_MOUSEBUTTONS

    idc_data   := idc_hook.data
    idc_result := Pm_OpenPopupMenuA( idc_msg.idcmpwindow,
    [ PM_MENU     , idc_data.tes_Menu  ,
      PM_CODE     , idc_msg.code       ,
      TAG_END ] )

    IF idc_result <> 0
      -> Here you can do a lot other stuff. Saving the id as the userdata
      -> will always help you a lot !
      domethod( idc_object, [ WM_REPORT_ID, idc_result, TAG_END ] )
    ENDIF

  ENDIF

  -> No return code specified
ENDPROC NIL
->»»>

