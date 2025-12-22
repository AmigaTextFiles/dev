/* -- --------------------------------------------------------------- -- *
 * -- Programname.........: NewAreaTest.e                             -- *
 * -- Description.........: Simple demonstration of my NewAreaClass   -- *
 * --                       with a shitty drawn image but I've got    -- *
 * --                       nothing more original 8(                  -- *
 * --                                                                 -- *
 * -- Author..............: Daniel Kasmeroglu (alias Deekah)          -- *
 * -- Version.............: 0.1     (14.03.1997)                      -- *
 * -- --------------------------------------------------------------- -- */
 
     /* -- ------------------------------------------------- -- *
      * --                   Compiler-Option's               -- *
      * -- ------------------------------------------------- -- */

OPT REG = 5                -> activate register-optimisation
OPT PREPROCESS             -> enable preprocessor


     /* -- ------------------------------------------------- -- *
      * --                       E-Module's                  -- *
      * -- ------------------------------------------------- -- */

MODULE 'libraries/bguim',
       'libraries/bgui',
       'utility/tagitem',
       'utility/hooks',
       'exec/memory',
       'exec/lists',
       'exec/nodes',
       'graphics/gfx',
       'graphics/text',
       'graphics/rastport',
       'devices/inputevent',
       'intuition/icclass',
       'intuition/cghooks',
       'intuition/classusr',
       'intuition/screens',
       'intuition/classes',
       'intuition/gadgetclass',
       'intuition/intuition',
       'tools/installhook',
       'tools/boopsi'

MODULE 'utility',
       'bgui'

MODULE '*newareaclass'


     /* -- ------------------------------------------------- -- *
      * --                       Constant's                  -- *
      * -- ------------------------------------------------- -- */

ENUM GID_AREA = 1,        -> // my display-area
     GID_VERTPROP,        -> // the props
     GID_HORIZPROP,
     GID_QUIT             -> // you should know it's function

CONST ERR_LIBRARY = 1


     /* -- ------------------------------------------------- -- *
      * --                       Exception's                 -- *
      * -- ------------------------------------------------- -- */

RAISE ERR_LIBRARY IF OpenLibrary() = NIL

 
     /* -- ------------------------------------------------- -- *
      * --                       Structure's                 -- *
      * -- ------------------------------------------------- -- */

OBJECT demogui
  owindow      : PTR TO object
  window       : PTR TO window
  gadgets[ 4 ] : ARRAY OF LONG
ENDOBJECT


     /* -- ------------------------------------------------- -- *
      * --                  Global Declaration's             -- *
      * -- ------------------------------------------------- -- */

DEF glo_class : PTR TO iclass     -> // my "newareaclass"


     /* -- ------------------------------------------------- -- *
      * --                       Method's                    -- *
      * -- ------------------------------------------------- -- */

PROC dem_Constructor() OF demogui
DEF con_rport

  self.gadgets[ GID_QUIT      - 1 ] := Button( '_Quit', GID_QUIT )   

  self.gadgets[ GID_VERTPROP  - 1 ] := PropObject,
                                         PGA_FREEDOM,        FREEVERT,
                                         PGA_NEWLOOK,        TRUE,
                                         PGA_Arrows,         TRUE,
                                       EndObject

  self.gadgets[ GID_HORIZPROP - 1 ] := PropObject,
                                         PGA_FREEDOM,        FREEHORIZ,
                                         PGA_NEWLOOK,        TRUE,
                                         PGA_Arrows,         TRUE,
                                       EndObject

  self.gadgets[ GID_AREA      - 1 ] := NewObjectA( glo_class, NIL,
                                       [ ButtonFrame,
                                         AREA_MinVWidth,       100,
                                         AREA_MinVHeight,      50,
                                         AREA_Width,           600,
                                         AREA_Height,          400,
                                         AREA_HProp,           self.gadgets[ GID_HORIZPROP - 1 ],
                                         AREA_VProp,           self.gadgets[ GID_VERTPROP  - 1 ],
                                         TAG_END ] )

  GetAttr( AREA_RastPort, self.gadgets[ GID_AREA - 1 ], {con_rport} )
  glo_DrawBullshit( con_rport, 200, 600 )  

  self.owindow := WindowObject,
                    WINDOW_Title,           'NewAreaClass demo',
                    WINDOW_CloseOnEsc,      TRUE,
                    WINDOW_AutoAspect,      TRUE,
                    WINDOW_SmartRefresh,    TRUE,
                    WINDOW_AutoKeyLabel,    TRUE,
                    WINDOW_MasterGroup,
                      VGroupObject,
                        ShineRaster,
                        NoFrame,
                        HOffset(16),
                        VOffset(8),
                        Spacing(4),
                        StartMember,
                          HGroupObject,
                            StartMember,
                              VGroupObject,
                                StartMember,
                                  self.gadgets[ GID_AREA - 1 ],
                                EndMember,
                                StartMember,
                                  self.gadgets[ GID_HORIZPROP - 1 ],
                                  FixMinHeight,
                                EndMember,
                              EndObject,
                            EndMember,
                            StartMember,
                              self.gadgets[ GID_VERTPROP - 1 ],
                              FixMinWidth,
                            EndMember,
                          EndObject,
                        EndMember,
                        StartMember,
                          self.gadgets[ GID_QUIT - 1 ],
                          FixMinHeight,
                        EndMember,
                      EndObject,
                  EndObject


ENDPROC


PROC dem_StartInterface() OF demogui
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


PROC end() OF demogui
DEF end_run
 
  IF self.owindow <> NIL
    DisposeObject( self.owindow )
  ELSE
  
    FOR end_run := GID_AREA TO GID_QUIT
      IF self.gadgets[ end_run - 1 ] <> NIL THEN DisposeObject( self.gadgets[ end_run - 1 ] )  
    ENDFOR

  ENDIF

ENDPROC


     /* -- ------------------------------------------------- -- *
      * --                     Procedure's                   -- *
      * -- ------------------------------------------------- -- */

PROC glo_DrawBullshit( dra_rport : PTR TO rastport, dra_w, dra_h )
DEF dra_cols,dra_x,dra_y

  dra_cols := Shl( 1, dra_rport.bitmap.depth )
  dra_w    := dra_w - 1
  dra_h    := dra_h - 1

  FOR dra_y := 0 TO dra_h
    FOR dra_x := 0 TO dra_w
      SetAPen( dra_rport, Mod( (dra_x + dra_y) * (dra_w - dra_y), dra_cols ) )
      WritePixel( dra_rport, dra_x, dra_y )
    ENDFOR
  ENDFOR

ENDPROC


     /* -- ------------------------------------------------- -- *
      * --                          Main                     -- *
      * -- ------------------------------------------------- -- */

PROC main() HANDLE
DEF ma_object : PTR TO demogui

  ma_object   := NIL
  utilitybase := OpenLibrary( 'utility.library', 37 )
  bguibase    := OpenLibrary( 'bgui.library', 41 )
  glo_class   := nar_InitNewAreaClass()
  IF glo_class <> NIL

    PrintF( 'Please wait, while calculating...\n' )
    NEW ma_object.dem_Constructor()
    ma_object.dem_StartInterface()

  ENDIF

EXCEPT DO

  IF ma_object   <> NIL THEN END ma_object
  IF glo_class   <> NIL THEN nar_FreeNewAreaClass( glo_class )
  IF bguibase    <> NIL THEN CloseLibrary( bguibase )
  IF utilitybase <> NIL THEN CloseLibrary( utilitybase )

ENDPROC
