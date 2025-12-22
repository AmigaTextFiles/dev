/* -- --------------------------------------------------------------- -- *
 * -- Programname.......: UseNewFieldList.e                           -- *
 * -- Description.......: Simple demo-program for the boopsi-classes  -- *
 * --                     "NewFieldListClass" and "NewStrClass"       -- *
 * --                                                                 -- *
 * -- Author............: Daniel Kasmeroglu (alias Deekah)            -- *
 * -- E-Mail............: raptor@cs.tu-berlin.de                      -- *
 * -- Version...........: 0.1     (10.03.1997)                        -- *
 * -- --------------------------------------------------------------- -- */

     /* -- ------------------------------------------------- -- *
      * --                   Compiler-Option's               -- *
      * -- ------------------------------------------------- -- */

OPT REG = 5          -> register-optimisation activated
OPT PREPROCESS       -> enable preprocessor


     /* -- ------------------------------------------------- -- *
      * --                       E-Module                    -- *
      * -- ------------------------------------------------- -- */

MODULE 'intuition/classusr',
       'intuition/classes',
       'intuition/intuition',
       'intuition/gadgetclass',
       'utility/tagitem',
       'libraries/bguim',
       'libraries/bgui',
       'graphics/gfxbase',
       'graphics/text',
       'exec/nodes',
       'tools/boopsi'

MODULE 'utility', 
       'bgui'

MODULE '*newfieldlistclass',
       '*newstrclass'


     /* -- ------------------------------------------------- -- *
      * --                       Constant's                  -- *
      * -- ------------------------------------------------- -- */

ENUM GID_SOURCELIST = 1,    -> list on the left side
     GID_DESTLIST,          -> list on the right side
     GID_TEXTFIELD,         -> textfield below
     GID_INFORMATION,       -> an user-information at the top
     GID_QUIT               -> leave the program


     /* -- ------------------------------------------------- -- *
      * --                      Structure's                  -- *
      * -- ------------------------------------------------- -- */

OBJECT fieldlistgui
  owindow      : PTR TO object   -> pointer to the window-object
  window       : PTR TO window   -> pointer to the intuition-window
  gadgets[ 5 ] : ARRAY OF LONG   -> object-addresses
  entries      : PTR TO LONG     -> list of entrys
ENDOBJECT


     /* -- ------------------------------------------------- -- *
      * --                   Global Declaration's            -- *
      * -- ------------------------------------------------- -- */

DEF glo_flclass : PTR TO iclass   -> NewFieldListClass
DEF glo_nsclass : PTR TO iclass   -> NewStrClass


     /* -- ------------------------------------------------- -- *
      * --                        Method's                   -- *
      * -- ------------------------------------------------- -- */

PROC fie_Constructor() OF fieldlistgui
DEF con_tags : PTR TO LONG

  self.entries := [ 'CallAddr\t%c',
                        'Date\t%d',
                        'Hunk:Offset\t%h',
                        'Task ID\t%i',
                        'Segment Name\t%s',
                        'Time\t%t',
                        'Count\t%u',
                        'Process Name\t%p',
                        'Action\t%a',
                        'Target Name\t%n',
                        'Options\t%o',
                        'Res.\t%r',
                        NIL ]

  con_tags := [ LISTV_ColumnWeights,           {lab_Weights},
                LISTV_SortEntryArray,          TRUE,
                LISTV_Columns,                 2,
                FL_SortDrops,                  TRUE,
                PGA_NEWLOOK,                   TRUE,
                BT_DragObject,                 TRUE,
                BT_DropObject,                 TRUE,
                LAB_Place,                     PLACE_ABOVE,
                TAG_END ]

  self.gadgets[ GID_SOURCELIST - 1 ] := NewObjectA( glo_flclass, NIL,
  [ LAB_Label,                     'Sourcelist',
    GA_ID,                         GID_SOURCELIST,
    LISTV_EntryArray,              self.entries,
    TAG_MORE,                      con_tags,
    TAG_END ] )


  self.gadgets[ GID_DESTLIST   - 1 ] := NewObjectA( glo_flclass, NIL,
  [ LAB_Label,                     'Destinationlist',
    GA_ID,                         GID_DESTLIST,
    TAG_MORE,                      con_tags,
    TAG_END ] )


  self.gadgets[ GID_TEXTFIELD  - 1 ] := NewObjectA( glo_nsclass, NIL,
  [ LAB_Label,                     'Eingabe...:',
    STRINGA_MAXCHARS,              255,
    STRINGA_JUSTIFICATION,         GACT_STRINGCENTER,
    STRINGA_MinCharsVisible,       20,
    GA_ID,                         GID_TEXTFIELD,
    BT_DropObject,                 TRUE,
    TAG_END ] )

  self.gadgets[ GID_INFORMATION - 1 ] := InfoObject,
                                           ButtonFrame,
                                           ShineRaster,
                                           FRM_Flags,          FRF_RECESSED,
                                           INFO_TextFormat,    {lab_Text},
                                           INFO_MinLines,      6,
                                         EndObject
  
  self.gadgets[ GID_QUIT       - 1 ] := Button( '_Quit', GID_QUIT )

  self.owindow := WindowObject,
                    WINDOW_Title,          'Listview Drag-n-Drop',
                    WINDOW_ScreenTitle,    'Programmed by Daniel Kasmeroglu (10.03.1997)',
                    WINDOW_ScaleWidth,     25,
                    WINDOW_ScaleHeight,    15,
                    WINDOW_RMBTrap,        TRUE,
                    WINDOW_AutoAspect,     TRUE,
                    WINDOW_AutoKeyLabel,   TRUE,
                    WINDOW_CloseOnEsc,     TRUE,
                    WINDOW_MasterGroup,
                      VGroupObject,
                        FRM_Type,          FRTYPE_NONE,
                        HOffset(6),
                        VOffset(6),
                        Spacing(6),
                        FillRaster,
                        StartMember,
                          self.gadgets[ GID_INFORMATION - 1 ],
                          FixMinHeight,
                        EndMember,
                        StartMember,
                          HGroupObject,
                            Spacing(6),
                            StartMember,
                              self.gadgets[ GID_SOURCELIST - 1 ],
                            EndMember,
                            StartMember,
                              self.gadgets[ GID_DESTLIST - 1 ],
                            EndMember,
                          EndObject,
                        EndMember,
                        StartMember,
                          self.gadgets[ GID_TEXTFIELD - 1 ],
                          FixMinHeight,
                        EndMember,
                        StartMember,
                          HGroupObject,
                            VarSpace( DEFAULT_WEIGHT ),
                            StartMember,
                              self.gadgets[ GID_QUIT - 1 ],
                            EndMember,
                            VarSpace( DEFAULT_WEIGHT ),
                          EndObject,
                          FixMinHeight,
                        EndMember,
                      EndObject,
                  EndObject

  IF self.owindow <> NIL

    SetAttrsA( self.gadgets[ GID_SOURCELIST - 1 ],
    [ FL_AcceptLV,    [ self.gadgets[ GID_DESTLIST  - 1 ],  NIL ], 
      TAG_END ] )

    SetAttrsA( self.gadgets[ GID_DESTLIST - 1 ],
    [ FL_AcceptLV,    [ self.gadgets[ GID_SOURCELIST - 1 ], NIL ], 
      TAG_END ] )

    SetAttrsA( self.gadgets[ GID_TEXTFIELD - 1 ],
    [ FL_AcceptLV,    [ self.gadgets[ GID_SOURCELIST - 1 ], self.gadgets[ GID_DESTLIST - 1 ], NIL ],
    TAG_END ] )

  ENDIF

ENDPROC

PROC fie_StartInterface() OF fieldlistgui
DEF sta_rc,sta_running,sta_signal

  IF self.owindow <> NIL

    self.window := WindowOpen( self.owindow )
    IF self.window <> NIL

      GetAttr( WINDOW_SigMask, self.owindow, {sta_signal} )

      sta_running := TRUE
      WHILE sta_running = TRUE
 
        Wait( sta_signal ) 
 
        WHILE (sta_rc := HandleEvent( self.owindow )) <> WMHI_NOMORE

          SELECT sta_rc
          CASE WMHI_CLOSEWINDOW ; sta_running := FALSE
          CASE GID_QUIT         ; sta_running := FALSE
          ENDSELECT

        ENDWHILE

      ENDWHILE

      WindowClose( self.owindow )

    ENDIF

  ENDIF

ENDPROC

PROC end() OF fieldlistgui
DEF end_run

  IF self.owindow <> NIL
    DisposeObject( self.owindow )
  ELSE

    FOR end_run := 0 TO GID_QUIT - 1
      IF self.gadgets[ end_run ] <> NIL 
        DisposeObject( self.gadgets[ end_run ] )
      ENDIF
    ENDFOR

  ENDIF

ENDPROC


     /* -- ------------------------------------------------- -- *
      * --                          Main                     -- *
      * -- ------------------------------------------------- -- */

PROC main() HANDLE
DEF ma_object : PTR TO fieldlistgui
 
  ma_object := NIL
 

  bguibase  := OpenLibrary( 'bgui.library', 41 )
  IF bguibase <> NIL

    utilitybase := OpenLibrary( 'utility.library', 37 )
    IF utilitybase <> NIL

      glo_flclass := fil_InitFLClass()
      IF glo_flclass <> NIL

        glo_nsclass := new_InitNewStrClass()
        IF glo_nsclass <> NIL

          NEW ma_object.fie_Constructor()
          ma_object.fie_StartInterface()
 
        ENDIF

      ENDIF

    ENDIF

  ENDIF

EXCEPT DO

  IF ma_object   <> NIL THEN END ma_object
  IF glo_nsclass <> NIL THEN new_FreeNewStrClass( glo_nsclass )
  IF glo_flclass <> NIL THEN fil_FreeFLClass( glo_flclass )
  IF utilitybase <> NIL THEN CloseLibrary( utilitybase )
  IF bguibase    <> NIL THEN CloseLibrary( bguibase    )

ENDPROC


     /* -- ------------------------------------------------- -- *
      * --                       Daten                       -- *
      * -- ------------------------------------------------- -- */

lab_Weights:
LONG 30, 5

lab_Text:
CHAR '\ecYou can move an entry from the sourcelist\n',
     'to the destinationlist and reverse. Also\n',
     'you\ave got the possibility to move an entry\n',
     'into the textfield-gadget.\n',
     'The base version was programmed by:\n',
     'Jan van den Baard\n',0
