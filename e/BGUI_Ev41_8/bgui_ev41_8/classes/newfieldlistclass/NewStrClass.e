/* -- --------------------------------------------------------------- -- *
 * -- Programname......: NewStrClass.e                                -- *
 * -- Description......: A simple boopsi-class which is able to       -- *
 * --                    insert a listview-item in it's textfield.    -- *
 * --                                                                 -- *
 * -- Author...........: Daniel Kasmeroglu (alias Deekah)             -- *
 * -- E-Mail...........: raptor@cs.tu-berlin.de                       -- *
 * -- Version..........: 0.1     (10.03.1997)                         -- *
 * -- --------------------------------------------------------------- -- */

     /* -- ------------------------------------------------- -- *
      * --                   Compiler-Option's               -- *
      * -- ------------------------------------------------- -- */

OPT REG = 5                -> activate register-optimisation
OPT PREPROCESS             -> enable preprocessor
OPT MODULE                 -> generate e-module


     /* -- ------------------------------------------------- -- *
      * --                        E-Module                   -- *
      * -- ------------------------------------------------- -- */

MODULE 'libraries/bgui',
       'libraries/bguim',
       'utility/tagitem',
       'utility/hooks',
       'exec/memory',
       'exec/lists',
       'exec/nodes',
       'graphics/text',
       'graphics/rastport',
       'devices/inputevent',
       'intuition/cghooks',
       'intuition/classusr',
       'intuition/screens',
       'intuition/classes',
       'intuition/gadgetclass',
       'intuition/intuition',
       'tools/installhook',
       'tools/boopsi',
       'amigalib/boopsi',
       'amigalib/lists'

MODULE 'utility',
       'bgui'

MODULE '*newfieldlistclass'


     /* -- ------------------------------------------------- -- *
      * --                      Structure's                  -- *
      * -- ------------------------------------------------- -- */

OBJECT newstrdata
  ns_ListViews : PTR TO LONG    -> list of listview-objects
ENDOBJECT


     /* -- ------------------------------------------------- -- *
      * --                      Procedure's                  -- *
      * -- ------------------------------------------------- -- */

EXPORT PROC new_InitNewStrClass()
DEF ini_super : PTR TO iclass
DEF ini_class : PTR TO iclass

  ini_class := NIL

  IF (bguibase <> NIL) AND (utilitybase <> NIL)

    ini_super := BgUI_GetClassPtr( BGUI_STRING_GADGET )
    IF ini_super <> NIL

      ini_class := MakeClass( NIL, NIL, ini_super, SIZEOF newstrdata, 0 )
      IF ini_class <> NIL THEN installhook( ini_class.dispatcher, {intern_Dispatcher} )

    ENDIF
 
  ENDIF 

ENDPROC ini_class


-> use this version instead of the direct call
EXPORT PROC new_FreeNewStrClass( fre_cl ) IS FreeClass( fre_cl )


     /* -- ------------------------------------------------- -- *
      * --                       Dispatcher                  -- *
      * -- ------------------------------------------------- -- */

PROC intern_Dispatcher( dis_cl, dis_obj, dis_msg : PTR TO msg )
DEF dis_mid

  dis_mid := dis_msg.methodid

  SELECT dis_mid
  CASE OM_NEW         ; RETURN intern_Method_NEW(       dis_cl, dis_obj, dis_msg )
  CASE OM_SET         ; RETURN intern_Method_SET(       dis_cl, dis_obj, dis_msg )
  CASE BASE_DROPPED   ; RETURN intern_Method_DROPPED(   dis_cl, dis_obj, dis_msg )
  DEFAULT             ; RETURN doSuperMethodA(          dis_cl, dis_obj, dis_msg )
  ENDSELECT

ENDPROC


     /* -- ------------------------------------------------- -- *
      * --                        Method's                   -- *
      * -- ------------------------------------------------- -- */

PROC intern_Method_NEW( new_cl : PTR TO iclass, new_obj, new_msg : PTR TO opnew )
DEF new_data : PTR TO newstrdata
DEF new_retval

  new_retval := doSuperMethodA( new_cl, new_obj, new_msg )
  IF new_retval <> NIL

    new_data              := INST_DATA( new_cl, new_retval )
    new_data.ns_ListViews := GetTagData( FL_AcceptLV,    NIL, new_msg.attrlist )

  ENDIF

ENDPROC new_retval


PROC intern_Method_SET( set_cl : PTR TO iclass, set_obj, set_msg : PTR TO opset )
DEF set_data : PTR TO newstrdata
DEF set_retval

  set_retval            := doSuperMethodA( set_cl, set_obj, set_msg )
  set_data              := INST_DATA( set_cl, set_obj )
  set_data.ns_ListViews := GetTagData( FL_AcceptLV,    set_data.ns_ListViews, set_msg.attrlist )

ENDPROC set_retval


PROC intern_Method_DROPPED( dro_cl : PTR TO iclass, dro_obj, dro_msg : PTR TO bmDropped )
DEF dro_data          : PTR TO newstrdata
DEF dro_buffer[ 100 ] : STRING
DEF dro_entry

  dro_data := INST_DATA( dro_cl, dro_obj )

  -> if the dropped source was one of the listview-objects...
  IF (dro_data.ns_ListViews <> NIL) AND (hel_IsInList_HELP( dro_msg.source, dro_data.ns_ListViews ) = TRUE)

    -> get the first selected
    dro_entry := FirstSelected( dro_msg.source )
    IF dro_entry <> NIL

      -> add this object without the rest after the first TAB-Character 
      StringF( dro_buffer, '\s', dro_entry )
 
      dro_entry := InStr( dro_buffer, '\t', 0 )
      IF dro_entry >= 0 THEN dro_buffer[ dro_entry ] := 0

      -> set attribute
      SetAttrsA( dro_obj, [ STRINGA_TEXTVAL, dro_buffer, TAG_END ] )

      -> refresh display
      BgUI_DoGadgetMethodA( dro_obj, dro_msg.sourceWin, dro_msg.sourceReq,
      [ LVM_REFRESH, NIL ] )

    ENDIF

  ENDIF

ENDPROC TRUE
