/* ////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////// External modules /////
//////////////////////////////////////////////////////////////////////////// */
MODULE 'muimaster' , 'libraries/mui'
MODULE 'intuition/classes', 'intuition/classusr'
MODULE 'utility/tagitem' , 'utility/hooks'


/* ////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////// Object definitions /////
//////////////////////////////////////////////////////////////////////////// */
OBJECT app_arexx
	commands :	LONG
	error    :	hook
ENDOBJECT

OBJECT app_display
	button_pressed          :	hook
ENDOBJECT

OBJECT app_obj
	app                     :	LONG
	wi_the_window           :	LONG
	bt_put_constant_string  :	LONG
	bt_put_variable         :	LONG
	bt_return_id            :	LONG
	bt_call_hook            :	LONG
	tx_result               :	LONG
	bt_quit                 :	LONG
	stR_TX_result           :	LONG
ENDOBJECT


/* ////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////// Constant definitions /////
//////////////////////////////////////////////////////////////////////////// */
ENUM ID_BUTTON_PRESSED = 1


/* ////////////////////////////////////////////////////////////////////////////
///////////// Creates one instance of one object or the whole application /////
//////////////////////////////////////////////////////////////////////////// */
PROC create_app( display : PTR TO app_display ,
             icon ,
             arexx : PTR TO app_arexx ,
             menu )

	DEF grOUP_ROOT_0C , gr_grp_0 , gr_grp_1 , la_result , gr_grp_2
	DEF tmp_object : PTR TO app_obj

	IF ( tmp_object := New( SIZEOF app_obj ) ) = NIL THEN RETURN NIL

	tmp_object.stR_TX_result           := get_DemoGenCodeE_string( msg_TX_result )

	tmp_object.bt_put_constant_string := SimpleButton( getMBstring( msg_BT_put_constant_string ) )

	tmp_object.bt_put_variable := SimpleButton( getMBstring( msg_BT_put_variable ) )

	tmp_object.bt_return_id := SimpleButton( getMBstring( msg_BT_return_id ) )

	tmp_object.bt_call_hook := SimpleButton( getMBstring( msg_BT_call_hook ) )

	la_result := Label( getMBstring( msg_LA_result ) )

	tmp_object.tx_result := TextObject ,
		MUIA_HelpNode , 'TX_result' ,
		MUIA_Background , MUII_TextBack ,
		MUIA_Frame , MUIV_Frame_Text ,
		MUIA_Text_Contents , tmp_object.stR_TX_result ,
		MUIA_Text_PreParse , '\el' ,
		MUIA_Text_SetMin , MUI_TRUE ,
	End

	gr_grp_1 := GroupObject ,
		MUIA_Group_Horiz , MUI_TRUE ,
		Child , la_result ,
		Child , tmp_object.tx_result ,
	End

	gr_grp_0 := GroupObject ,
		MUIA_Frame , MUIV_Frame_Group ,
		MUIA_FrameTitle , getMBstring( msg_GR_grp_0Title ) ,
		Child , tmp_object.bt_put_constant_string ,
		Child , tmp_object.bt_put_variable ,
		Child , tmp_object.bt_return_id ,
		Child , tmp_object.bt_call_hook ,
		Child , gr_grp_1 ,
	End

	tmp_object.bt_quit := SimpleButton( getMBstring( msg_BT_quit ) )

	gr_grp_2 := GroupObject ,
		Child , tmp_object.bt_quit ,
	End

	grOUP_ROOT_0C := GroupObject ,
		Child , gr_grp_0 ,
		Child , gr_grp_2 ,
	End

	tmp_object.wi_the_window := WindowObject ,
		MUIA_Window_Title , getMBstring( msg_WI_the_window ) ,
		MUIA_HelpNode , 'WI_the_window' ,
		MUIA_Window_ID , "0WIN" ,
		WindowContents , grOUP_ROOT_0C ,
	End

	tmp_object.app := ApplicationObject ,
		( IF icon THEN MUIA_Application_DiskObject ELSE TAG_IGNORE ) , icon ,
		( IF arexx THEN MUIA_Application_Commands ELSE TAG_IGNORE ) , ( IF arexx THEN arexx.commands ELSE NIL ) ,
		( IF arexx THEN MUIA_Application_RexxHook ELSE TAG_IGNORE ) , ( IF arexx THEN arexx.error ELSE NIL ) ,
		( IF menu THEN MUIA_Application_Menu ELSE TAG_IGNORE ) , menu ,
		MUIA_Application_Author , 'Lionel Vintenat' ,
		MUIA_Application_Base , 'DEMOGENCODEE' ,
		MUIA_Application_Title , 'DemoGenCodeE' ,
		MUIA_Application_Version , '$VER: DemoGenCodeE 1.0 (01.09.94)' ,
		MUIA_Application_Copyright , getMBstring( msg_AppCopyright ) ,
		MUIA_Application_Description , getMBstring( msg_AppDescription ) ,
		SubWindow , tmp_object.wi_the_window ,
	End

	IF tmp_object.app = NIL
		Dispose( tmp_object )
		tmp_object := NIL
	ENDIF

ENDPROC tmp_object


/* ////////////////////////////////////////////////////////////////////////////
//////////////////////////// Disposes the object or the whole application /////
//////////////////////////////////////////////////////////////////////////// */
PROC dispose_app( tmp_object : PTR TO app_obj )

	IF tmp_object.app THEN Mui_DisposeObject( tmp_object.app )
	Dispose( tmp_object )

ENDPROC


/* ////////////////////////////////////////////////////////////////////////////
///////////////////////// Initializes all the notifications of one object /////
///////////////////////////////////////////// or of the whole application /////
//////////////////////////////////////////////////////////////////////////// */
PROC init_notifications_app( tmp_object : PTR TO app_obj , display : PTR TO app_display )

	domethod( tmp_object.bt_put_constant_string ,
		[ MUIM_Notify , MUIA_Pressed , FALSE ,
		tmp_object.tx_result ,
		3 ,
		MUIM_Set , MUIA_Text_Contents , getMBstring( msg_BT_put_constant_stringNotify0 ) ] )

	domethod( tmp_object.bt_put_variable ,
		[ MUIM_Notify , MUIA_Pressed , FALSE ,
		tmp_object.tx_result ,
		3 ,
		MUIM_Set , MUIA_Text_Contents , string_var ] )

	domethod( tmp_object.bt_return_id ,
		[ MUIM_Notify , MUIA_Pressed , FALSE ,
		tmp_object.app ,
		2 ,
		MUIM_Application_ReturnID , ID_BUTTON_PRESSED ] )

	domethod( tmp_object.bt_call_hook ,
		[ MUIM_Notify , MUIA_Pressed , FALSE ,
		tmp_object.app ,
		2 ,
		MUIM_CallHook , display.button_pressed ] )

	domethod( tmp_object.bt_quit ,
		[ MUIM_Notify , MUIA_Pressed , FALSE ,
		tmp_object.app ,
		2 ,
		MUIM_Application_ReturnID , MUIV_Application_ReturnID_Quit ] )

	domethod( tmp_object.wi_the_window ,
		[ MUIM_Window_SetCycleChain , tmp_object.bt_put_constant_string ,
		tmp_object.bt_put_variable ,
		tmp_object.bt_return_id ,
		tmp_object.bt_call_hook ,
		tmp_object.bt_quit ,
		0 ] )

	set( tmp_object.wi_the_window ,
		MUIA_Window_Open , MUI_TRUE )

ENDPROC


/* ////////////////////////////////////////////////////////////////////////////
////////////// Special GetString() function for MUIBuilder generated code /////
//////////////////////////////////////////////////////////////////////////// */
PROC getMBstring( string_reference )

	DEF local_string

	local_string := get_DemoGenCodeE_string( string_reference )

ENDPROC ( IF local_string[ 1 ] = 0 THEN ( local_string + 2 ) ELSE local_string )


/* ////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////// domethod function /////
//////////////////////////////////////////////////////////////////////////// */
PROC domethod( obj : PTR TO object , msg : PTR TO msg )

	DEF h : PTR TO hook , o : PTR TO object , dispatcher

	IF obj
		o := obj-SIZEOF object		/* instance data is to negative offset */
		h := o.class
		dispatcher := h.entry		/* get dispatcher from hook in iclass */
		MOVEA.L h,A0
		MOVEA.L msg,A1
		MOVEA.L obj,A2			/* probably should use CallHookPkt, but the */
		MOVEA.L dispatcher,A3		/*   original code (DoMethodA()) doesn't. */
		JSR (A3)			/* call classDispatcher() */
		MOVE.L D0,o
		RETURN o
	ENDIF

ENDPROC NIL
