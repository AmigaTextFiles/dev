OPT MODULE
OPT PREPROCESS


->/////////////////////////////////////////////////////////////////////////////
->//////////////////////////////////////////////////////////// MODULE ... /////
->/////////////////////////////////////////////////////////////////////////////
MODULE 'muimaster' , 'libraries/mui'
MODULE 'tools/boopsi' , 'libraries/gadtools'
MODULE 'utility/tagitem' , 'utility/hooks'


->/////////////////////////////////////////////////////////////////////////////
->//////////////////////////////////////////////////////////// OBJECT ... /////
->/////////////////////////////////////////////////////////////////////////////
EXPORT OBJECT app_arexx
	commands :	PTR TO mui_command
	error    :	hook
ENDOBJECT

EXPORT OBJECT app_display
	button_pressed          :	hook
ENDOBJECT

EXPORT OBJECT app_obj
	app                     :	PTR TO LONG
	wi_the_window           :	PTR TO LONG
	bt_put_constant_string  :	PTR TO LONG
	bt_put_variable         :	PTR TO LONG
	bt_return_id            :	PTR TO LONG
	bt_call_hook            :	PTR TO LONG
	tx_result               :	PTR TO LONG
	bt_quit                 :	PTR TO LONG
	stR_TX_result           :	PTR TO CHAR
ENDOBJECT


->/////////////////////////////////////////////////////////////////////////////
->/////////////////////////////////////////////////////// CONST ... = ... /////
->/////////////////////////////////////////////////////////////////////////////
EXPORT ENUM
	ID_BUTTON_PRESSED = 1


->/////////////////////////////////////////////////////////////////////////////
->///////////////////////////////////////////////////////// DEF ... = ... /////
->/////////////////////////////////////////////////////////////////////////////
EXPORT DEF string_var


->/////////////////////////////////////////////////////////////////////////////
->/////////////////////////////////////////////////////////// PROC create /////
->/////////////////////////////////////////////////////////////////////////////
PROC create( display : PTR TO app_display ,
             icon  = NIL ,
             arexx = NIL : PTR TO app_arexx ,
             menu  = NIL ) OF app_obj

	DEF grOUP_ROOT_0C , gr_grp_0 , gr_grp_1 , la_result , gr_grp_2

	self.stR_TX_result           := 'Zzzzzzzzzzzzz'

	self.bt_put_constant_string := TextObject ,
		ButtonFrame ,
		MUIA_Background , MUII_ButtonBack ,
		MUIA_ControlChar , "c" ,
		MUIA_Text_Contents , 'Put Constant String' ,
		MUIA_Text_PreParse , '\ec' ,
		MUIA_Text_HiChar , "c" ,
		MUIA_HelpNode , 'BT_put_constant_string' ,
		MUIA_InputMode , MUIV_InputMode_RelVerify ,
	End

	self.bt_put_variable := TextObject ,
		ButtonFrame ,
		MUIA_Background , MUII_ButtonBack ,
		MUIA_ControlChar , "v" ,
		MUIA_Text_Contents , 'Put Variable' ,
		MUIA_Text_PreParse , '\ec' ,
		MUIA_Text_HiChar , "v" ,
		MUIA_HelpNode , 'BT_put_variable' ,
		MUIA_InputMode , MUIV_InputMode_RelVerify ,
	End

	self.bt_return_id := SimpleButton( '_Return ID' )

	self.bt_call_hook := TextObject ,
		ButtonFrame ,
		MUIA_Background , MUII_ButtonBack ,
		MUIA_ControlChar , "h" ,
		MUIA_Text_Contents , 'Call Hook' ,
		MUIA_Text_PreParse , '\ec' ,
		MUIA_Text_HiChar , "h" ,
		MUIA_HelpNode , 'BT_call_hook' ,
		MUIA_InputMode , MUIV_InputMode_RelVerify ,
	End

	la_result := Label( 'Result' )

	self.tx_result := TextObject ,
		MUIA_HelpNode , 'TX_result' ,
		MUIA_Background , MUII_TextBack ,
		MUIA_Frame , MUIV_Frame_Text ,
		MUIA_Text_Contents , self.stR_TX_result ,
		MUIA_Text_PreParse , '\el' ,
		MUIA_Text_SetMin , MUI_TRUE ,
	End

	gr_grp_1 := GroupObject ,
		MUIA_Group_Horiz , MUI_TRUE ,
		Child , la_result ,
		Child , self.tx_result ,
	End

	gr_grp_0 := GroupObject ,
		MUIA_Frame , MUIV_Frame_Group ,
		MUIA_FrameTitle , 'Click !' ,
		Child , self.bt_put_constant_string ,
		Child , self.bt_put_variable ,
		Child , self.bt_return_id ,
		Child , self.bt_call_hook ,
		Child , gr_grp_1 ,
	End

	self.bt_quit := TextObject ,
		ButtonFrame ,
		MUIA_Background , MUII_ButtonBack ,
		MUIA_ControlChar , "q" ,
		MUIA_Text_Contents , 'Quit' ,
		MUIA_Text_PreParse , '\ec' ,
		MUIA_Text_HiChar , "q" ,
		MUIA_HelpNode , 'BT_quit' ,
		MUIA_InputMode , MUIV_InputMode_RelVerify ,
	End

	gr_grp_2 := GroupObject ,
		Child , self.bt_quit ,
	End

	grOUP_ROOT_0C := GroupObject ,
		Child , gr_grp_0 ,
		Child , gr_grp_2 ,
	End

	self.wi_the_window := WindowObject ,
		MUIA_Window_Title , 'The window !' ,
		MUIA_HelpNode , 'WI_the_window' ,
		MUIA_Window_ID , "0WIN" ,
		WindowContents , grOUP_ROOT_0C ,
	End

	self.app := ApplicationObject ,
		( IF icon THEN MUIA_Application_DiskObject ELSE TAG_IGNORE ) , icon ,
		( IF arexx THEN MUIA_Application_Commands ELSE TAG_IGNORE ) , ( IF arexx THEN arexx.commands ELSE NIL ) ,
		( IF arexx THEN MUIA_Application_RexxHook ELSE TAG_IGNORE ) , ( IF arexx THEN arexx.error ELSE NIL ) ,
		( IF menu THEN MUIA_Application_Menu ELSE TAG_IGNORE ) , menu ,
		MUIA_Application_Author , 'Lionel Vintenat' ,
		MUIA_Application_Base , 'DEMOGENCODEE' ,
		MUIA_Application_Title , 'DemoGenCodeE' ,
		MUIA_Application_Version , '$VER: DemoGenCodeE 1.0 (01.09.94)' ,
		MUIA_Application_Copyright , 'Public Domain !' ,
		MUIA_Application_Description , 'Application example for GenCodeE' ,
		SubWindow , self.wi_the_window ,
	End

ENDPROC self.app


->/////////////////////////////////////////////////////////////////////////////
->////////////////////////////////////////////////////////// PROC dispose /////
->/////////////////////////////////////////////////////////////////////////////
PROC dispose() OF app_obj IS ( IF self.app THEN Mui_DisposeObject( self.app ) ELSE NIL )


->/////////////////////////////////////////////////////////////////////////////
->/////////////////////////////////////////////// PROC init_notifications /////
->/////////////////////////////////////////////////////////////////////////////
PROC init_notifications( display : PTR TO app_display ) OF app_obj

	domethod( self.bt_put_constant_string , [
		MUIM_Notify , MUIA_Pressed , FALSE ,
		self.tx_result ,
		3 ,
		MUIM_Set , MUIA_Text_Contents , 'Constant string put !' ] )

	domethod( self.bt_put_variable , [
		MUIM_Notify , MUIA_Pressed , FALSE ,
		self.tx_result ,
		3 ,
		MUIM_Set , MUIA_Text_Contents , string_var ] )

	domethod( self.bt_return_id , [
		MUIM_Notify , MUIA_Pressed , FALSE ,
		self.app ,
		2 ,
		MUIM_Application_ReturnID , ID_BUTTON_PRESSED ] )

	domethod( self.bt_call_hook , [
		MUIM_Notify , MUIA_Pressed , FALSE ,
		self.app ,
		2 ,
		MUIM_CallHook , display.button_pressed ] )

	domethod( self.bt_quit , [
		MUIM_Notify , MUIA_Pressed , FALSE ,
		self.app ,
		2 ,
		MUIM_Application_ReturnID , MUIV_Application_ReturnID_Quit ] )

	domethod( self.wi_the_window , [
		MUIM_Window_SetCycleChain , self.bt_put_constant_string ,
		self.bt_put_variable ,
		self.bt_return_id ,
		self.bt_call_hook ,
		self.bt_quit ,
		0 ] )

	set( self.wi_the_window ,MUIA_Window_Open , MUI_TRUE )

ENDPROC


