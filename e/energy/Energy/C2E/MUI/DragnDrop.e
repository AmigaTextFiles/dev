/*
** The Settings Demo shows how to load and save object contents.
*/
OPT OSVERSION=37
OPT PREPROCESS

MODULE	'libraries/mui',
	'libraries/muip',
	'muimaster',
	'dos/dos',
	'mod/boopsi',
	'intuition/classes',
	'intuition/classusr',
	'utility/hooks',
	'utility/tagitem'

OBJECT fieldsList_Data

	dummy:LONG
ENDOBJECT

OBJECT chooseFields_Data

	dummy:LONG
ENDOBJECT

#define MAKE_ID(a,b,c,d) ( Shl(a,24) OR Shl(b,16) OR Shl(c,8) OR d )

DEF	cl_fieldsList:PTR TO mui_customclass,
	cl_chooseFields:PTR TO mui_customclass


/****************************************************************************/
/* FieldsList class                                                         */
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

PROC fieldsList_DragQuery(cl:PTR TO iclass,obj,msg:PTR TO muip_dragdrop)

	IF msg.obj=obj

		/*
		** If somebody tried to drag ourselves onto ourselves, we let our superclass
		** (the list class) handle the necessary actions. Depending on the state of
		** its MUIA_List_DragSortable attribute, it will either accept or refuse to become
		** the destination object.
		*/

		RETURN doSuperMethodA(cl,obj,msg)
/*
	ELSEIF msg.obj=muiUserData(obj)

		/*
		** If our predefined source object wants us to become active,
		** we politely accept it.
		*/

		RETURN MUIV_DragQuery_Accept*/
	ENDIF
		/*
		** Otherwise, someone tried to feed us with something we don't like
		** very much. Just refuse it.
		*/

ENDPROC MUIV_DragQuery_Refuse


PROC fieldsList_DragDrop(cl:PTR TO iclass ,obj, msg:PTR TO muip_dragdrop)

DEF entry,dropmark,sortable

	IF msg.obj=obj

		/*
		** user wants to move entries within our object, these kinds of actions
		** can get quite complicated, but fortunately, everything is automatically
		** handled by list class. We just need to pass through the method.
		*/

		RETURN doSuperMethodA(cl,obj,msg)
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
		doMethod(msg.obj,[MUIM_List_GetEntry,MUIV_List_GetEntry_Active,{entry}])

		/* remove source entry */
		doMethod(msg.obj,[MUIM_List_Remove,MUIV_List_Remove_Active])

		get(obj,MUIA_List_DragSortable,{sortable})
		IF sortable

			/*
			** if we are in a sortable list (in our case the visible fields),
			** we need to make sure to insert the new entry at the correct
			** position. The MUIA_List_DropMark attribute is maintained
			** by list class and shows us where we shall go after a drop.
			*/

			get(obj,MUIA_List_DropMark,{dropmark})
			doMethod(obj,[MUIM_List_InsertSingle,entry,dropmark])
		ELSE
			/*
			** we are about to return something to the available fields
			** listview which is always sorted.
			*/

			doMethod(obj,[MUIM_List_InsertSingle,entry,MUIV_List_Insert_Sorted])
		ENDIF

		/*
		** make the insterted object the active and make the source listviews
		** active object inactive to give some more visual feedback to the user.
		*/

		get(obj,MUIA_List_InsertPosition,{dropmark})
		set(obj,MUIA_List_Active,dropmark)
		set(msg.obj,MUIA_List_Active,MUIV_List_Active_Off)

	ENDIF
ENDPROC


PROC fieldsList_Dispatcher(cl:PTR TO iclass,obj,msg:PTR TO msg)

MOVE.L cl,A0
MOVE.L obj,A2
MOVE.L msg,A1

	IF msg.methodid=MUIM_DragQuery THEN RETURN fieldsList_DragQuery(cl,obj,msg)
	IF msg.methodid=MUIM_DragDrop THEN RETURN fieldsList_DragDrop(cl,obj,msg)

ENDPROC doSuperMethodA(cl,obj,msg)

PROC chooseFields_New(cl:PTR TO iclass,obj,msg:PTR TO opset)

DEF	available, visible

	obj := doSuperMethodA(cl,obj,[OM_NEW,NIL,NIL])
		/*[MUIA_Group_Columns, 2,
		MUIA_Group_VertSpacing, 1,
		Child, TextObject, MUIA_Text_Contents, '\ecAvailable Fields\n(alpha sorted)', End,
		Child, TextObject, MUIA_Text_Contents, '\ecVisible Fields\n(sortable)', End,
		Child, ListviewObject,
			MUIA_Listview_DragType, 1,
			MUIA_Listview_List, available := Mui_NewObjectA(cl_fieldsList.mcc_class,[NIL,InputListFrame,MUIA_List_SourceArray, fields,MUIA_List_ShowDropMarks, FALSE,TAG_DONE]),
			End,
		Child, ListviewObject,
			MUIA_Listview_DragType, 1,
			MUIA_Listview_List, visible := Mui_NewObjectA(cl_fieldsList.mcc_class,[NIL,InputListFrame,MUIA_List_DragSortable, TRUE,TAG_DONE]),
			End,
		End]*/

	IF obj

		/*
		** tell available object to accept items from visible object.
		** the use of MUIA_UserData is just to make the FieldsList
		** subclass more simple.
		*/

		set(available,MUIA_UserData,visible)

		/*
		** the other way round...
		*/

		set(visible,MUIA_UserData,available)
	ENDIF

ENDPROC obj

PROC chooseFields_Dispatcher(cl:PTR TO iclass,obj,msg:PTR TO msg)

MOVE.L cl,A0
MOVE.L obj,A2
MOVE.L msg,A1

	IF msg.methodid=OM_NEW THEN RETURN chooseFields_New(cl,obj,msg)

ENDPROC doSuperMethodA(cl,obj,msg)



/****************************************************************************/
/* Main Program                                                             */
/****************************************************************************/


PROC exitClasses()
	IF cl_fieldsList THEN Mui_DeleteCustomClass(cl_fieldsList  )
	IF cl_chooseFields THEN Mui_DeleteCustomClass(cl_chooseFields)
ENDPROC


PROC initClasses()

	cl_fieldsList    := Mui_CreateCustomClass(NIL,MUIC_List ,NIL,SIZEOF fieldsList_Data,{fieldsList_Dispatcher})
	cl_chooseFields  := Mui_CreateCustomClass(NIL,MUIC_Group,NIL,SIZEOF chooseFields_Data,{chooseFields_Dispatcher})

	IF cl_fieldsList AND cl_chooseFields THEN RETURN TRUE

	exitClasses()

ENDPROC FALSE


PROC main()

DEF	app,window,sigs = 0,
	fields:PTR TO CHAR,
	nase:PTR TO CHAR

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

nase:=[	'Line  1',
	'Line  2',
	'Line  3',
	'Line  4',
	'Line  5',
	'Line  6',
	'Line  7',
	'Line  8',
	'Line  9',
	'Line 10',
	'Line 11',
	'Line 12',
	'Line 13',
	'Line 14',
	'Line 15',
	'Line 16',
	'Line 17',
	'Line 18',
	'Line 19',
	'Line 20',
	'Line 21',
	'Line 22',
	'Line 23',
	'Line 24',
	'Line 25',
	'Line 26',
	'Line 27',
	'Line 28',
	'Line 29',
	'Line 30',
	'Line 31',
	'Line 32',
	'Line 33',
	'Line 34',
	'Line 35',
	'Line 36',
	'Line 37',
	'Line 38',
	'Line 39',
	'Line 40',
	'Line 41',
	'Line 42',
	'Line 43',
	'Line 44',
	'Line 45',
	'Line 46',
	'Line 47',
	'Line 48',
	'Line 49',
	'Line 50',
	 NIL]

IF muimasterbase := OpenLibrary('muimaster.library',MUIMASTER_VMIN)

	IF initClasses()=NIL THEN fail(NIL,'failed to init classes.\n')

	app := ApplicationObject,
		MUIA_Application_Title      , 'DragnDrop',
		MUIA_Application_Version    , '$VER: DragnDrop 12.9 (21.11.95)',
		MUIA_Application_Copyright  , '©1992-95, Stefan Stuntz',
		MUIA_Application_Author     , 'Stefan Stuntz',
		MUIA_Application_Description, 'Demonstrate Drag & Drop capabilities',
		MUIA_Application_Base       , 'DRAGNDROP',

		SubWindow, window := WindowObject,
			MUIA_Window_Title, 'Drag&Drop Demo',
			MUIA_Window_ID   , MAKE_ID("D","R","A","G"),
			WindowContents, VGroup,

				->Child, Mui_NewObjectA(cl_chooseFields.mcc_class,[NIL,NIL,TAG_DONE]),

				Child, ColGroup(2),
					Child, TextObject, TextFrame, MUIA_Background, MUII_TextBack, MUIA_Text_Contents, '\ecListview without\nmultiple selection.', End,
					Child, TextObject, TextFrame, MUIA_Background, MUII_TextBack, MUIA_Text_Contents, '\ecListview with\nmultiple selection.', End,
					Child, ListviewObject,
						MUIA_Listview_DragType, 1,
						MUIA_Dropable, FALSE,
						MUIA_Listview_List, ListObject,
							InputListFrame,
							MUIA_List_SourceArray, nase,
							MUIA_List_DragSortable, TRUE,
							End,
						End,
					Child, ListviewObject,
						MUIA_Dropable, TRUE,
						MUIA_Listview_DragType, 1,
						MUIA_Listview_MultiSelect, TRUE,
						MUIA_Listview_List, ListObject,
							InputListFrame,
							MUIA_List_SourceArray, nase,
							MUIA_List_DragSortable, TRUE,
							End,
						End,
					End,
				End,
			End,
		End

	IF app=NIL THEN fail(app,'Failed to create Application.\n')


	doMethod(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,
		app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

	/*
	** This is the ideal input loop for an object oriented MUI application.
	** Everything is encapsulated in classes, no return ids need to be used,
	** we just check if the program shall terminate.
	** Note that MUIM_Application_NewInput expects sigs to contain the result
	** from Wait() (or 0). This makes the input loop significantly faster.
	*/

	set(window,MUIA_Window_Open,TRUE)

		WHILE doMethod(app,[MUIM_Application_NewInput,{sigs}]) <> MUIV_Application_ReturnID_Quit

			IF sigs
				sigs := Wait(sigs OR SIGBREAKF_CTRL_C)
				IF (sigs AND SIGBREAKF_CTRL_C)
					set(window,MUIA_Window_Open,FALSE)
					fail(app,NIL)
				ENDIF
			ENDIF
		ENDWHILE

	set(window,MUIA_Window_Open,FALSE)

	Mui_DisposeObject(app)
	exitClasses()         /* *before* deleting the classes! */
	CloseLibrary(muimasterbase)

ENDIF
ENDPROC

PROC fail(app,str)

 IF app THEN Mui_DisposeObject(app)

 IF muimasterbase THEN CloseLibrary(muimasterbase)

    IF str
      WriteF(str)
      CleanUp(20)
    ENDIF

ENDPROC

PROC doMethod( obj:PTR TO object, msg:PTR TO msg )

	DEF h:PTR TO hook, o:PTR TO object, dispatcher

	IF obj
		o := obj-SIZEOF object	/* instance data is to negative offset */
		h := o.class
		dispatcher := h.entry	/* get dispatcher from hook in iclass */
		MOVEA.L h,A0
		MOVEA.L msg,A1
		MOVEA.L obj,A2		/* probably should use CallHookPkt, but the */
		MOVEA.L dispatcher,A3	/*   original code (DoMethodA()) doesn't. */
		JSR (A3)		/* call classDispatcher() */
		MOVE.L D0,o
		RETURN o
	ENDIF
ENDPROC NIL
