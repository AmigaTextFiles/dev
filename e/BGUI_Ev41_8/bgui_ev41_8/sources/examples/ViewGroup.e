/* -- --------------------------------------------------------------- -- *
 * -- Programname..........: ViewGroup.e                              -- *
 * -- Description..........: Simple translation from the existing     -- *
 * --                        C-Version.                               -- *
 * --                                                                 -- *
 * -- Author...............: Daniel Kasmeroglu (alias Deekah)         -- *
 * -- Version..............: 0.1     (22.02.1997)                     -- *
 * -- --                                                           -- -- *
 * -- History..............:                                          -- *
 * --                                                                 -- *
 * --         0.1          - Die erste Version ;-)                    -- *
 * --                        (22.02.1997)                             -- *
 * -- --------------------------------------------------------------- -- */


     /* -- ------------------------------------------------- -- *
      * --                     Compiler-Options              -- *
      * -- ------------------------------------------------- -- */

OPT REG = 5                -> activate register-optimization
OPT PREPROCESS             -> enable preprocessor


     /* -- ------------------------------------------------- -- *
      * --                          Macros                   -- *
      * -- ------------------------------------------------- -- */

#define PageLab  [ 'Information', 'Buttons', 'Strings', 'CheckBoxes', 'Radio-Buttons', NIL ]
#define MxLab    [ 'MX #1', 'MX #2', 'MX #3', 'MX #4', NIL ]

#define MyCheckBox( label, id )\
  CheckBoxObject,\
    LAB_Label,         label,\
    GA_ID,             id,\
  EndObject


     /* -- ------------------------------------------------- -- *
      * --                         E-Modules                 -- *
      * -- ------------------------------------------------- -- */

MODULE 'libraries/bguim',
       'libraries/bgui',
       'devices/inputevent',
       'devices/input',
       'utility/tagitem',
       'utility/hooks',
       'tools/installhook',
       'tools/inithook',
       'tools/boopsi',
       'intuition/gadgetclass',
       'intuition/intuition',
       'intuition/classusr',
       'intuition/classes',
       'intuition/imageclass'


MODULE 'bgui'

 
     /* -- ------------------------------------------------- -- *
      * --                        Constants                  -- *
      * -- ------------------------------------------------- -- */

CONST BOTH_SHIFT = IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT

ENUM GID_TABS = 1,        -> Gadget-IDs
     GID_DEPTH,
     GID_HELP,
     GID_PROPHORIZ,
     GID_PROPVERT,
     GID_INFO,
     GID_QUIT,
     GID_BUTTON1,
     GID_BUTTON2,
     GID_BUTTON3,
     GID_STRING1,
     GID_STRING2,
     GID_STRING3,
     GID_CHECK1,
     GID_CHECK2,
     GID_CHECK3,
     GID_RADIO,
     GRID_PAGE,           -> GRoup-IDs
     GRID_VIEW


     /* -- ------------------------------------------------- -- *
      * --                        Structures                 -- *
      * -- ------------------------------------------------- -- */

OBJECT ehook OF hook      -> the data field is used by `installhook'
  privatedata : LONG
ENDOBJECT


OBJECT viewgui
  owindow       : PTR TO object
  window        : PTR TO window
  gadgets[ 19 ] : ARRAY OF LONG
  ehook         : ehook
ENDOBJECT


     /* -- ------------------------------------------------- -- *
      * --                        Methoden                   -- *
      * -- ------------------------------------------------- -- */

PROC vie_Constructor() OF viewgui

  -> installation of the hook (I don't know what `inithook' does
  -> but this combination works in all my examples )
  installhook( self.ehook, {glo_TabHookFunc} )
  inithook(    self.ehook, {glo_TabHookFunc} )

  -> initializing simple objects
  self.vie_InitGadgets()

  -> if the GRID_VIEW-Object exists all went ok !
  IF self.gadgets[ GRID_VIEW - 1 ] <> NIL

    -> setup the window-object
    self.owindow := WindowObject,
                      WINDOW_Title,              'Border gadgets',
                      WINDOW_AutoKeyLabel,       TRUE,
                      WINDOW_AutoAspect,         TRUE,
                      WINDOW_CloseOnEsc,         TRUE,
                      WINDOW_IDCMPHookBits,      IDCMP_RAWKEY,
                      WINDOW_IDCMPHook,          self.ehook,
                      WINDOW_TBorderGroup, 
                        HGroupObject,
                          StartMember,
                            self.gadgets[ GID_DEPTH - 1 ],
                          EndMember,
                          StartMember,
                            self.gadgets[ GID_HELP - 1 ],
                          EndMember,
                        EndObject,
                      WINDOW_BBorderGroup,
                        HGroupObject,
                          StartMember,
                            self.gadgets[ GID_PROPHORIZ - 1 ],
                          EndMember,
                        EndObject,
                      WINDOW_RBorderGroup,
                        VGroupObject,
                          StartMember,
                            self.gadgets[ GID_PROPVERT - 1 ],
                          EndMember,
                        EndObject,
                      WINDOW_MasterGroup,
                        VGroupObject,
                          StartMember,
                            self.gadgets[ GRID_VIEW - 1 ],
                          EndMember,
                        EndObject,
                    EndObject
             

    -> if the creation was successful 
    IF self.owindow <> NIL

      -> store the address of the TABS-Object
      self.ehook.privatedata := self.gadgets[ GID_TABS - 1 ]

      -> add a simple map
      AddMap( self.gadgets[ GID_TABS - 1 ], self.gadgets[ GRID_PAGE - 1 ], {lab_Cyc2Page} )

      -> setup the TabCycling-Order
      domethod( self.owindow, [ WM_TABCYCLE_ORDER,
                                self.gadgets[ GID_STRING1 - 1 ],
                                self.gadgets[ GID_STRING2 - 1 ],
                                self.gadgets[ GID_STRING3 - 1 ], NIL ] )
     
      -> attach some objects to the VIEW-Object
      SetAttrsA( self.gadgets[ GRID_VIEW - 1 ], [ VIEW_HScroller, self.gadgets[ GID_PROPHORIZ - 1 ], TAG_END ] )
      SetAttrsA( self.gadgets[ GRID_VIEW - 1 ], [ VIEW_VScroller, self.gadgets[ GID_PROPVERT  - 1 ], TAG_END ] )

    ENDIF

  ENDIF

ENDPROC


PROC vie_InitGadgets() OF viewgui
DEF vie_run,vie_ok

  -> initialize all objects
  self.gadgets[ GID_TABS  - 1 ] := MxObject,
                                     MX_TabsObject,         TRUE,
                                     MX_Labels,             PageLab, 
                                     GA_ID,                 GID_TABS,
                                   EndObject

  self.gadgets[ GID_DEPTH - 1 ] := ButtonObject,
                                     SYSIA_WHICH,           DEPTHIMAGE, 
                                     GA_ID,                 GID_DEPTH,
                                   EndObject

  self.gadgets[ GID_HELP  - 1 ] := ButtonObject,
                                     FRM_Type,              FRTYPE_BORDER,
                                     FRM_InnerOffsetTop,    -1,
                                     LAB_Label,             'Help...',
                                     BUTTON_EncloseImage,   TRUE,
                                     GA_ID,                 GID_HELP,
                                   EndObject

  self.gadgets[ GID_PROPHORIZ - 1 ] := PropObject,
                                         PGA_TOP,           15,
                                         PGA_TOTAL,         20,
                                         PGA_VISIBLE,       10,
                                         PGA_FREEDOM,       FREEHORIZ,
                                         PGA_NEWLOOK,       TRUE,
                                         PGA_Arrows,        TRUE,
                                         GA_ID,             GID_PROPHORIZ,
                                       EndObject


  self.gadgets[ GID_PROPVERT  - 1 ] := PropObject,
                                         PGA_TOP,           15,
                                         PGA_TOTAL,         20,
                                         PGA_VISIBLE,       10,
                                         PGA_FREEDOM,       FREEVERT,
                                         PGA_NEWLOOK,       TRUE,
                                         PGA_Arrows,        TRUE,
                                         GA_ID,             GID_PROPVERT,
                                       EndObject

  
  self.gadgets[ GID_INFO -  1 ] := InfoObject,
                                     ButtonFrame,
                                     FRM_Flags,             FRF_RECESSED,
                                     INFO_TextFormat,       {lab_Text},
                                     INFO_FixTextWidth,     TRUE,
                                     INFO_MinLines,         14,
                                     GA_ID,                 GID_INFO,
                                   EndObject

  self.gadgets[ GID_QUIT - 1 ] := ButtonObject,
                                    GA_ID,                  GID_QUIT,
                                    LAB_Label,              '_Quit',
                                    LAB_Underscore,         "_",
                                  EndObject

  self.gadgets[ GID_BUTTON1 - 1 ] := PrefButton( 'Button #_1', GID_BUTTON1 )
  self.gadgets[ GID_BUTTON2 - 1 ] := PrefButton( 'Button #_2', GID_BUTTON2 )
  self.gadgets[ GID_BUTTON3 - 1 ] := PrefButton( 'Button #_3', GID_BUTTON3 )
  
  self.gadgets[ GID_STRING1 - 1 ] := PrefString( 'String #_1', NIL, 256, GID_STRING1 )
  self.gadgets[ GID_STRING2 - 1 ] := PrefString( 'String #_2', NIL, 256, GID_STRING2 )
  self.gadgets[ GID_STRING3 - 1 ] := PrefString( 'String #_3', NIL, 256, GID_STRING3 )

  self.gadgets[ GID_CHECK1  - 1 ] := MyCheckBox( 'CheckBox #_1', GID_CHECK1 )
  self.gadgets[ GID_CHECK2  - 1 ] := MyCheckBox( 'CheckBox #_2', GID_CHECK2 )
  self.gadgets[ GID_CHECK3  - 1 ] := MyCheckBox( 'CheckBox #_3', GID_CHECK3 )

  self.gadgets[ GID_RADIO   - 1 ] := MxObject,
                                       GROUP_Style,              GRSTYLE_VERTICAL,
                                       LAB_Label,                '_Mx Object',
                                       LAB_Place,                PLACE_ABOVE,
                                       MX_Labels,                MxLab,
                                       GA_ID,                    GID_RADIO,
                                     EndObject



  -> check if all went ok
  vie_ok := TRUE
  FOR vie_run := GID_TABS TO GID_RADIO
    IF self.gadgets[ vie_run - 1 ] = NIL THEN vie_ok := FALSE
  ENDFOR

  -> if there was a fault, then dispose all successful
  -> created objects
  IF vie_ok = FALSE
    FOR vie_run := GID_TABS TO GID_RADIO
      IF self.gadgets[ vie_run - 1 ] <> NIL
        DisposeObject( self.gadgets[ vie_run - 1 ] )
        self.gadgets[ vie_run - 1 ] := NIL
      ENDIF
    ENDFOR
  ELSE

    -> setup the PAGE-Object
    self.gadgets[ GRID_PAGE - 1 ] := PageObject,
                                       PageMember,
                                         VGroupObject,
                                           NormalSpacing,
                                           StartMember,
                                             self.gadgets[ GID_INFO - 1 ],   
                                           EndMember,
                                           StartMember,
                                             HGroupObject,
                                               VarSpace(50),
                                               StartMember,
                                                 self.gadgets[ GID_QUIT - 1 ],
                                               EndMember,
                                               VarSpace(50),
                                             EndObject,
                                             FixMinHeight,
                                           EndMember,
                                         EndObject,
                                       PageMember,
                                         VGroupObject,
                                           NormalSpacing,
                                           VarSpace(DEFAULT_WEIGHT),
                                           StartMember,
                                             self.gadgets[ GID_BUTTON1 - 1 ],
                                             FixMinHeight,
                                           EndMember,
                                           StartMember,
                                             self.gadgets[ GID_BUTTON2 - 1 ],
                                             FixMinHeight,
                                           EndMember,
                                           StartMember, 
                                             self.gadgets[ GID_BUTTON3 - 1 ],
                                             FixMinHeight,
                                           EndMember,
                                           VarSpace(DEFAULT_WEIGHT),
                                         EndObject,
                                       PageMember,
                                         VGroupObject,
                                           NormalSpacing,
                                           VarSpace(DEFAULT_WEIGHT),
                                           StartMember, 
                                             self.gadgets[ GID_STRING1 - 1 ],
                                             FixMinHeight,
                                           EndMember,
                                           StartMember, 
                                             self.gadgets[ GID_STRING2 - 1 ],
                                             FixMinHeight,
                                           EndMember,
                                           StartMember, 
                                             self.gadgets[ GID_STRING3 - 1 ],
                                             FixMinHeight,
                                           EndMember,
                                           VarSpace(DEFAULT_WEIGHT),
                                         EndObject,
                                       PageMember,
                                         VGroupObject,
                                           NormalSpacing,
                                           VarSpace(DEFAULT_WEIGHT),
                                           StartMember,
                                             HGroupObject,
                                               VarSpace(DEFAULT_WEIGHT),
                                               StartMember,
                                                 VGroupObject, 
                                                   NormalSpacing,
                                                   StartMember, self.gadgets[ GID_CHECK1 - 1 ], EndMember,
                                                   StartMember, self.gadgets[ GID_CHECK2 - 1 ], EndMember,
                                                   StartMember, self.gadgets[ GID_CHECK3 - 1 ], EndMember,
                                                 EndObject, 
                                                 FixMinWidth,
                                               EndMember,
                                               VarSpace(DEFAULT_WEIGHT),
                                             EndObject,
                                           EndMember, 
                                           VarSpace(DEFAULT_WEIGHT),
                                         EndObject,
                                       PageMember,
                                         VGroupObject,
                                           VarSpace(DEFAULT_WEIGHT),
                                           StartMember,
                                             HGroupObject,
                                               VarSpace( DEFAULT_WEIGHT ),
                                               StartMember, self.gadgets[ GID_RADIO - 1 ], EndMember,
                                               VarSpace( DEFAULT_WEIGHT ),
                                             EndObject, 
                                             FixMinHeight,
                                           EndMember,
                                           VarSpace(DEFAULT_WEIGHT),
                                         EndObject,
                                     EndObject


    -> if PAGE-Object was successfully created then create
    -> the VIEW-Object
    IF self.gadgets[ GRID_PAGE - 1 ] <> NIL

      self.gadgets[ GRID_VIEW - 1 ] := ViewObject,
                                         FRM_Type,                  FRTYPE_NONE,
                                         VIEW_ScaleMinWidth,        25,
                                         VIEW_ScaleMinHeight,       25,
                                         VIEW_Object,
                                           VGroupObject,
                                             NormalOffset,
                                             NormalSpacing,
                                             StartMember,
                                               self.gadgets[ GID_TABS - 1 ],
                                               FixMinHeight,
                                             EndMember,
                                             StartMember,
                                               self.gadgets[ GRID_PAGE - 1 ],
                                             EndMember,
                                           EndObject,
                                       EndObject

    ENDIF

  ENDIF
  
ENDPROC


PROC vie_StartInterface() OF viewgui
DEF sta_rc,sta_running,sta_signal

  -> the window-object should be available
  IF self.owindow <> NIL

    -> open the window to make it visible
    self.window := WindowOpen( self.owindow )
    IF self.window <> NIL

      -> get the signal-mask
      GetAttr( WINDOW_SigMask, self.owindow, {sta_signal} )

      sta_running := TRUE
      WHILE sta_running = TRUE

        -> wait until an event arrives
        Wait( sta_signal )

        WHILE (sta_rc := HandleEvent( self.owindow )) <> WMHI_NOMORE

          -> wow, what a great program or not 8)
          SELECT sta_rc
          CASE WMHI_CLOSEWINDOW ; sta_running := FALSE
          CASE GID_QUIT         ; sta_running := FALSE
          ENDSELECT

        ENDWHILE
 
      ENDWHILE

      -> this call is not necessary if the window should
      -> be opened only for one time because `DisposeObject'
      -> would close it, too
      WindowClose( self.owindow )

    ENDIF

  ENDIF

ENDPROC


PROC end() OF viewgui
  IF self.owindow <> NIL 
    DisposeObject( self.owindow )
  ELSEIF self.gadgets[ GRID_VIEW - 1 ] <> NIL
    DisposeObject( self.gadgets[ GRID_VIEW     - 1 ] )
    DisposeObject( self.gadgets[ GRID_PAGE     - 1 ] )
    DisposeObject( self.gadgets[ GID_DEPTH     - 1 ] )
    DisposeObject( self.gadgets[ GID_HELP      - 1 ] )
    DisposeObject( self.gadgets[ GID_PROPVERT  - 1 ] )
    DisposeObject( self.gadgets[ GID_PROPHORIZ - 1 ] )
  ENDIF
ENDPROC


     /* -- ------------------------------------------------- -- *
      * --                      Hook-Functions               -- *
      * -- ------------------------------------------------- -- */

PROC glo_TabHookFunc( tab_ehook : PTR TO ehook, tab_obj : PTR TO object, tab_msg : PTR TO intuimessage )
DEF tab_window : PTR TO window
DEF tab_mxobj  : PTR TO object
DEF tab_pos

  tab_mxobj := tab_ehook.privatedata

  GetAttr( WINDOW_Window, tab_obj,   {tab_window} )
  GetAttr( MX_Active,     tab_mxobj, {tab_pos}    )

  -> 66
  IF tab_msg.code = $42

    IF (tab_msg.qualifier AND BOTH_SHIFT) <> NIL
      tab_pos--
    ELSE
      tab_pos++
    ENDIF

    SetGadgetAttrsA( tab_mxobj, tab_window, NIL,
    [ MX_Active, tab_pos, TAG_END ] )

  ENDIF

ENDPROC


     /* -- ------------------------------------------------- -- *
      * --                          Main                     -- *
      * -- ------------------------------------------------- -- */

PROC main() HANDLE
DEF ma_viewgui : PTR TO viewgui

  ma_viewgui := NIL
  bguibase   := OpenLibrary( 'bgui.library', 41 )
  IF bguibase <> NIL
    
    NEW ma_viewgui.vie_Constructor()
    ma_viewgui.vie_StartInterface()

  ENDIF

EXCEPT DO

  IF ma_viewgui <> NIL THEN END ma_viewgui
  IF bguibase   <> NIL THEN CloseLibrary( bguibase )
   
ENDPROC exception


     /* -- ------------------------------------------------- -- *
      * --                          Data                     -- *
      * -- ------------------------------------------------- -- */

lab_Cyc2Page:
LONG MX_Active,        PAGE_Active,
     TAG_END


lab_Text:
CHAR 'This is also an updated example of how to manage border gadgets\n',
     'with BGUI.\n\n',
     '1. It is not necessary (or recommended) to add GA_#?Border\n',
     'tags anymore, BGUI now handles this automatically.\n\n',
     '2. You may use FRTYPE_BORDER for gadgets to get the proper\n',
     'fill colors.\n\n',
     '3. You do not need to specify any frames for prop gadgets,\n',
     'these are done automatically.\n\n',
     '4. Prop gadgets that are in borders now use sysiclass images\n',
     'for their arrows for a more conforming look.\n',0
