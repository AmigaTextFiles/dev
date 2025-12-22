/* An old E example converted to PortablE.
   From http://aminet.net/package/dev/e/mui36dev-E */

/*
**  Original C Code written by Stefan Stuntz
**
**  Translation into E by Klaus Becker
**
**  All comments are from the C-Source
*/

OPT PREPROCESS, POINTER

MODULE 'exec', 'intuition'
MODULE 'muimaster', 'libraries/mui', 'libraries/muip',
       'mui/muicustomclass', 'amigalib/boopsi',
       'intuition/classes', 'intuition/classusr',
       'intuition/screens', 'intuition/intuition',
       'utility/tagitem'

TYPE PTIO IS PTR TO INTUIOBJECT

DEF nase, fields

DEF cl_fieldslist   =NIL: PTR TO mui_customclass
DEF cl_choosefields =NIL: PTR TO mui_customclass

OBJECT fieldslist_data
  dummy
ENDOBJECT

OBJECT choosefields_data
  dummy
ENDOBJECT

PROC doSuperNew(cl:PTR TO iclass, obj:PTIO, tag1:ARRAY OF tagitem) IS doSuperMethodA(cl, obj, [OM_NEW, tag1, NIL]) !!PTIO

/****************************************************************************/
/* FieldsList class                                                         */
/****************************************************************************/

/*
** FieldsList list class creates a list that accepts D&D items
** from exactly one other listview, the one which is stored in
** the objects userdata. You could also store the allowed source
** object in another private attribute, I was just too lazy to add
** the get/set methods in this case. :-)
**
** This class is designed to be used for both, the list of the
** available fields and the list of the visible fields.
**
** Note: Stop being afraid of custom classes. This one here takes
** just a few lines of code, 90% of the stuff below is comments. :-)
*/

PROC fieldslist_dragquery(cl:PTR TO iclass, obj:PTIO, msg:PTR TO muip_dragdrop) RETURNS ret

  IF msg.obj=obj
    /*
    ** If somebody tried to drag ourselves onto ourselves, we let our superclass
    ** (the list class) handle the necessary actions. Depending on the state of
    ** its MUIA_List_DragSortable attribute, it will either accept or refuse to become
    ** the destination object.
    */
    RETURN doSuperMethodA(cl, obj, msg)
  ELSE IF msg.obj= muiUserData(obj)
    /*
    ** If our predefined source object wants us to become active,
    ** we politely accept it.
    */
    RETURN MUIV_DragQuery_Accept
  ELSE
    /*
    ** Otherwise, someone tried to feed us with something we don't like
    ** very much. Just refuse it.
    */
    RETURN MUIV_DragQuery_Refuse
  ENDIF
ENDPROC

PROC fieldslist_dragdrop(cl:PTR TO iclass, obj:PTIO, msg:PTR TO muip_dragdrop) RETURNS ret
  DEF entry, dropmark, sortable

  IF msg.obj=obj
    /*
    ** user wants to move entries within our object, these kinds of actions
    ** can get quite complicated, but fortunately, everything is automatically
    ** handled by list class. We just need to pass through the method.
    */
    RETURN doSuperMethodA(cl, obj, msg)
  ELSE
    /*
    ** we can be sure that msg->obj is our predefined source object
    ** since we wouldnt have accepted the MUIM_DragQuery and wouldnt
    ** have become an active destination object otherwise.
    */

    /*
    ** get the current entry from the source object, remove it there, and insert
    ** it to ourselves. You would have to do a little more action if the source
    ** listview would support multi select, but this one doesnt, so things get
    ** quite easy. Note that this direct removing/adding of list entries is only
    ** possible if both contain lists simple pointers to static items. If they would
    ** feature custom construct/destruct hooks, we'd need to create a copy of
    ** the entries instead of simply moving pointers.
    */

    /* get source entry */
    doMethodA(msg.obj, [MUIM_List_GetEntry, MUIV_List_GetEntry_Active,ADDRESSOF entry])

    /* remove source entry */
    doMethodA(msg.obj, [MUIM_List_Remove, MUIV_List_Remove_Active])

    get(obj, MUIA_List_DragSortable, ADDRESSOF sortable)
    IF sortable
      /*
      ** if we are in a sortable list (in our case the visible fields),
      ** we need to make sure to insert the new entry at the correct
      ** position. The MUIA_List_DropMark attribute is maintained
      ** by list class and shows us where we shall go after a drop.
      */

      get(obj, MUIA_List_DropMark, ADDRESSOF dropmark)
      doMethodA(obj, [MUIM_List_InsertSingle, entry,dropmark])
    ELSE
      /*
      ** we are about to return something to the available fields
      ** listview which is always sorted.
      */
      doMethodA(obj, [MUIM_List_InsertSingle, entry,MUIV_List_Insert_Sorted])
    ENDIF
 
    /*
    ** make the insterted object the active and make the source listviews
    ** active object inactive to give some more visual feedback to the user.
    */

    get(obj, MUIA_List_InsertPosition, ADDRESSOF dropmark)
    set(obj, MUIA_List_Active, dropmark)
    set(msg.obj, MUIA_List_Active, MUIV_List_Active_Off)
  ENDIF
  RETURN 0
ENDPROC

PROC fieldslist_dispatcher(cl:PTR TO iclass, obj:PTIO, msg:PTR TO msg)
  DEF methodid
  methodid := msg.methodid
  SELECT methodid
    CASE MUIM_DragQuery; RETURN fieldslist_dragquery(cl, obj, msg!!PTR)
    CASE MUIM_DragDrop ; RETURN fieldslist_dragdrop (cl, obj, msg!!PTR)
   ENDSELECT
ENDPROC doSuperMethodA(cl, obj, msg)

/****************************************************************************/
/* ChooseFields class                                                       */
/****************************************************************************/

/*
** This class creates two listviews, one contains all available fields,
** the other one contains the visible fields. You can control this
** stuff completely with D&D. This thing could e.g. be useful to
** configure the display of an address utility.
*/

PROC choosefields_new(cl:PTR TO iclass, obj:PTIO, msg:PTR TO opset)
  DEF available:PTIO, visible:PTIO
  obj := doSuperNew(cl, obj,
    [MUIA_Group_Columns, 2,
    MUIA_Group_VertSpacing, 1,
    Child, TextObject, MUIA_Text_Contents, '\ecAvailable Fields\n(alpha sorted)', End,
    Child, TextObject, MUIA_Text_Contents, '\ecVisible Fields\n(sortable)', End,
    Child, ListviewObject,
      MUIA_Listview_DragType, 1,
      MUIA_Listview_List, available := NewObjectA(cl_fieldslist.mcc_class,NILA,
        [InputListFrame,
        MUIA_List_SourceArray, fields,
        MUIA_List_ShowDropMarks, FALSE,
        TAG_DONE]:tagitem),
    End,
    Child, ListviewObject,
      MUIA_Listview_DragType, 1,
      MUIA_Listview_List, visible := NewObjectA(cl_fieldslist.mcc_class, NILA,
        [InputListFrame,
        MUIA_List_DragSortable, MUI_TRUE,
        TAG_DONE]:tagitem),
    End,
    TAG_DONE]:tagitem)

  IF obj
    /*
    ** tell available object to accept items from visible object.
    ** the use of MUIA_UserData is just to make the FieldsList
    ** subclass more simple.
    */

    set(available, MUIA_UserData, visible)

    /*
    ** the other way round...
    */

    set(visible, MUIA_UserData, available)
  ENDIF
  msg := NIL	->dummy
  
ENDPROC obj

PROC choosefields_dispatcher(cl:PTR TO iclass, obj:PTIO, msg:PTR TO msg)
  DEF methodid
  methodid := msg.methodid
  SELECT methodid
    CASE OM_NEW; RETURN choosefields_new(cl, obj, msg!!PTR)
  ENDSELECT
ENDPROC doSuperMethodA(cl, obj, msg)

/****************************************************************************/
/* Main Program                                                             */
/****************************************************************************/

PROC exitclasses()
  IF cl_fieldslist   THEN Mui_DeleteCustomClass(cl_fieldslist  )
  IF cl_choosefields THEN Mui_DeleteCustomClass(cl_choosefields)
ENDPROC

PROC initclasses()
  cl_fieldslist    := eMui_CreateCustomClass(NIL, MUIC_List , NIL, SIZEOF   fieldslist_data, CALLBACK   fieldslist_dispatcher())
  cl_choosefields  := eMui_CreateCustomClass(NIL, MUIC_Group, NIL, SIZEOF choosefields_data, CALLBACK choosefields_dispatcher())

  IF (cl_fieldslist<>NIL) AND (cl_choosefields<>NIL) THEN RETURN TRUE
  exitclasses()
ENDPROC FALSE

PROC main()
  DEF app:PTIO, window:PTIO, sigs

  nase:=['Line 1','Line 2','Line 3','Line 4','Line 5',
         'Line 6','Line 7','Line 8','Line 9','Line 10',
         'Line 11','Line 12','Line 13','Line 14','Line 15',
         'Line 16','Line 17','Line 18','Line 19','Line 20',
         'Line 21','Line 22','Line 23','Line 24','Line 25',
         'Line 26','Line 27','Line 28','Line 29','Line 30',
         'Line 31','Line 32','Line 33','Line 34','Line 35',
         'Line 36','Line 37','Line 38','Line 39','Line 40',
         'Line 41','Line 42','Line 43','Line 44','Line 45',
         'Line 46','Line 47','Line 48','Line 49','Line 50',NIL]

  fields:=['Age',
           'Birthday',
           'c/o',
           'City',
           'Comment',
           'Country',
           'EMail',
           'Fax',
           'First name',
           'Job',
           'Name',
           'Phone',
           'Projects',
           'Salutation',
           'State',
           'Street',
           'ZIP',
           NIL]
  
  IF (muimasterbase := OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN))=NIL THEN Throw("ERR", 'Failed to open muimaster.library')

  IF initclasses()=NIL THEN Throw("ERR", 'failed to init classes.')

  app := ApplicationObject,
    MUIA_Application_Title      , 'DragnDrop',
    MUIA_Application_Version    , '$VER: DragnDrop 12.9 (21.11.95)',
    MUIA_Application_Copyright  , 'c1992-95, Stefan Stuntz',
    MUIA_Application_Author     , 'Stefan Stuntz & Klaus Becker',
    MUIA_Application_Description, 'Demonstrate Drag & Drop capabilities',
    MUIA_Application_Base       , 'DRAGNDROP',
    SubWindow, window := WindowObject,
      MUIA_Window_Title, 'Drag&Drop Demo',
      MUIA_Window_ID   , "DRAG",
      WindowContents, VGroup,
        Child, NewObjectA(cl_choosefields.mcc_class, NILA, [TAG_DONE]:tagitem),
        Child, ColGroup(2),
          Child, TextObject, TextFrame, MUIA_Background, MUII_TextBack, MUIA_Text_Contents, '\ecListview without\nmultiple selection.', End,
          Child, TextObject, TextFrame, MUIA_Background, MUII_TextBack, MUIA_Text_Contents, '\ecListview with\nmultiple selection.', End,
          Child, ListviewObject,
            MUIA_Listview_DragType, 1,
            MUIA_Dropable, FALSE,
            MUIA_Listview_List, ListObject,
              InputListFrame,
              MUIA_List_SourceArray, nase,
              MUIA_List_DragSortable, MUI_TRUE,
            End,
          End,
          Child, ListviewObject,
            MUIA_Dropable, MUI_TRUE,
            MUIA_Listview_DragType, 1,
            MUIA_Listview_MultiSelect, MUI_TRUE,
            MUIA_Listview_List, ListObject,
              InputListFrame,
              MUIA_List_SourceArray, nase,
              MUIA_List_DragSortable, MUI_TRUE,
            End,
          End,
        End,
      End,
    End,
  End

  IF app=NIL THEN Throw("ERR", 'Failed to create Application.')

  doMethodA(window, [MUIM_Notify, MUIA_Window_CloseRequest,MUI_TRUE,
    app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

  /*
  ** This is the ideal input loop for an object oriented MUI application.
  ** Everything is encapsulated in classes, no return ids need to be used,
  ** we just check if the program shall terminate.
  ** Note that MUIM_Application_NewInput expects sigs to contain the result
  ** from Wait() (or 0). This makes the input loop significantly faster.
  */

  set(window, MUIA_Window_Open, MUI_TRUE)
  
  sigs := 0
  WHILE (doMethodA(app, [MUIM_Application_NewInput, ADDRESSOF sigs]) <> MUIV_Application_ReturnID_Quit)
    IF sigs THEN sigs := Wait(sigs)
  ENDWHILE

  set(window, MUIA_Window_Open, FALSE)

FINALLY

  IF app THEN Mui_DisposeObject(app) -> note that you must first dispose all objects 
  exitclasses()                      -> *before* deleting the classes! 
  IF muimasterbase THEN CloseLibrary(muimasterbase)
  IF exceptionInfo THEN Print('\s\n', exceptionInfo)
ENDPROC
