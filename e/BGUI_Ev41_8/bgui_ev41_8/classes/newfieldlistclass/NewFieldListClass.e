/* -- --------------------------------------------------------------- -- *
 * -- Programname......: NewFieldListClass.e                          -- *
 * -- Description......: First this should be a simple conversion     -- *
 * --                    from the c-example but I've changed some     -- *
 * --                    things that I've found useful to demonstrate -- *
 * --                    the DragNDrop-features of the "bgui.library" -- *
 * --                                                                 -- *
 * -- Author...........: Daniel Kasmeroglu (alias Deekah)             -- *
 * -- E-Mail...........: raptor@cs.tu-berlin.de                       -- *
 * -- Version..........: 1.0     (10.03.1997)                         -- *
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


     /* -- ------------------------------------------------- -- *
      * --                      Constant's                   -- *
      * -- ------------------------------------------------- -- */

EXPORT CONST FL_AcceptLV   = TAG_USER + $2000,      -> IS---
             FL_SortDrops  = TAG_USER + $2001       -> IS---


     /* -- ------------------------------------------------- -- *
      * --                      Structure's                  -- *
      * -- ------------------------------------------------- -- */

OBJECT fieldlistdata
  fl_ListViews  : PTR TO LONG     -> list of listview-objects
  fl_SortDrops  : LONG            -> auto-sort drops
ENDOBJECT


     /* -- ------------------------------------------------- -- *
      * --                      Procedure's                  -- *
      * -- ------------------------------------------------- -- */

EXPORT PROC fil_InitFLClass()
DEF ini_super : PTR TO iclass
DEF ini_class : PTR TO iclass

  ini_class := NIL

  -> check if needed librarys are available
  IF (bguibase <> NIL) AND (utilitybase <> NIL)

    -> subclass from the LISTVIEW_GADGET
    ini_super := BgUI_GetClassPtr( BGUI_LISTVIEW_GADGET )
    IF ini_super <> NIL

      -> normal installation stuff
      ini_class := MakeClass( NIL, NIL, ini_super, SIZEOF fieldlistdata, 0 )
      IF ini_class <> NIL THEN installhook( ini_class.dispatcher, {intern_Dispatcher} )
 
    ENDIF 

  ENDIF

ENDPROC ini_class


-> use this version instead of the direct "FreeClass()" call
EXPORT PROC fil_FreeFLClass( fre_cl ) IS FreeClass( fre_cl )


-> a simple procedure for the public
EXPORT PROC hel_IsInList_HELP( isi_object, isi_list : PTR TO LONG )
  WHILE (isi_object <> isi_list[]) AND (isi_list[] <> NIL) DO isi_list++
ENDPROC IF isi_list[] = isi_object THEN TRUE ELSE FALSE


     /* -- ------------------------------------------------- -- *
      * --                       Dispatcher                  -- *
      * -- ------------------------------------------------- -- */

PROC intern_Dispatcher( dis_cl, dis_obj, dis_msg : PTR TO msg )
DEF dis_mid

  dis_mid := dis_msg.methodid

  SELECT dis_mid
  CASE OM_NEW         ; RETURN intern_Method_NEW(       dis_cl, dis_obj, dis_msg )
  CASE OM_SET         ; RETURN intern_Method_SET(       dis_cl, dis_obj, dis_msg )
  CASE BASE_DRAGQUERY ; RETURN intern_Method_DRAGQUERY( dis_cl, dis_obj, dis_msg )
  CASE BASE_DROPPED   ; RETURN intern_Method_DROPPED(   dis_cl, dis_obj, dis_msg )
  DEFAULT             ; RETURN doSuperMethodA(          dis_cl, dis_obj, dis_msg )
  ENDSELECT

ENDPROC


     /* -- ------------------------------------------------- -- *
      * --                        Method's                   -- *
      * -- ------------------------------------------------- -- */

PROC intern_Method_NEW( new_cl : PTR TO iclass, new_obj, new_msg : PTR TO opnew )
DEF new_data : PTR TO fieldlistdata
DEF new_retval

  -> let the superclasses create all instances
  new_retval := doSuperMethodA( new_cl, new_obj, new_msg )
  IF new_retval <> NIL

    -> get instance and initialise
    new_data               := INST_DATA( new_cl, new_retval )
    new_data.fl_ListViews  := NIL
    new_data.fl_SortDrops  := FALSE

    -> set attributes 
    intern_SetFLAttrs_HELP( new_data, new_msg.attrlist )

  ENDIF

ENDPROC new_retval


PROC intern_Method_SET( set_cl : PTR TO iclass, set_obj, set_msg : PTR TO opset )
DEF set_data : PTR TO fieldlistdata
DEF set_retval

  -> let the superclass work
  set_retval := doSuperMethodA( set_cl, set_obj, set_msg )
  set_data   := INST_DATA( set_cl, set_obj )

  -> set attributes
  intern_SetFLAttrs_HELP( set_data, set_msg.attrlist )

ENDPROC set_retval


PROC intern_Method_DRAGQUERY( dra_cl : PTR TO iclass, dra_obj, dra_msg : PTR TO bmDragPoint )
DEF dra_data : PTR TO fieldlistdata
DEF dra_ibox : ibox

  -> let the superclass work
  IF dra_msg.source = dra_obj THEN RETURN doSuperMethodA( dra_cl, dra_obj, dra_msg )

  -> get the instance-data
  dra_data   := INST_DATA( dra_cl, dra_obj )

  IF (dra_data.fl_ListViews <> NIL) AND (hel_IsInList_HELP( dra_msg.source, dra_data.fl_ListViews ) = TRUE)

    GetAttr( LISTV_ViewBounds, dra_obj, {dra_ibox} )
    IF dra_msg.mouseX < dra_ibox.width THEN RETURN BQR_ACCEPT

  ENDIF

ENDPROC BQR_REJECT


PROC intern_Method_DROPPED( dro_cl : PTR TO iclass, dro_obj, dro_msg : PTR TO bmDropped )
DEF dro_data : PTR TO fieldlistdata
DEF dro_spot,dro_entry

  IF dro_msg.source = dro_obj THEN RETURN doSuperMethodA( dro_cl, dro_obj, dro_msg )

  dro_data := INST_DATA( dro_cl, dro_obj )

  IF (dro_data.fl_ListViews <> NIL) AND (hel_IsInList_HELP( dro_msg.source, dro_data.fl_ListViews ) = TRUE)

    -> // the dropped object was a listview-gadget

    -> get entry where the object were dropped
    GetAttr( LISTV_DropSpot, dro_obj, {dro_spot} )

    -> run thru the whole list
    WHILE (dro_entry := FirstSelected( dro_msg.source )) <> NIL

      -> insert it directly after the dropspot-entry or insert it
      -> and sort the whole list
      IF dro_data.fl_SortDrops = FALSE
        doMethodA( dro_obj, [ LVM_INSERTSINGLE, NIL, dro_spot, dro_entry, LVASF_SELECT ]:lvmInsertSingle )
      ELSE
        doMethodA( dro_obj, [ LVM_ADDSINGLE, NIL, dro_entry, LVAP_SORTED, LVASF_SELECT ]:lvmAddSingle )
      ENDIF

      -> remove the entry from the source list
      RemoveEntry( dro_msg.source, dro_entry )

    ENDWHILE

  ENDIF

  -> refresh the source and the destination
  RefreshList( dro_msg.sourceWin, dro_obj        )
  RefreshList( dro_msg.sourceWin, dro_msg.source )

ENDPROC TRUE


     /* -- ------------------------------------------------- -- *
      * --                 Helping procedure's               -- *
      * -- ------------------------------------------------- -- */

PROC intern_SetFLAttrs_HELP( set_data : PTR TO fieldlistdata, set_attrs : PTR TO tagitem )

  set_data.fl_ListViews  := GetTagData( FL_AcceptLV,  set_data.fl_ListViews,  set_attrs )
  set_data.fl_SortDrops  := GetTagData( FL_SortDrops, set_data.fl_SortDrops,  set_attrs )

ENDPROC
