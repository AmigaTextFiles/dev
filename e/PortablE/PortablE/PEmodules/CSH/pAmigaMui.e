/* pAmigaMui.e 08-10-2022
	A collection of useful procedures/wrappers for MUI.
	Copyright (c) 2010,2011,2012,2013,2015,2016,2020,2022 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/

OPT NATIVE
OPT PREPROCESS, POINTER
PUBLIC MODULE 'muimaster', 'utility/tagitem', 'mui/muicustomclass'
MODULE 'mui/NList_mcc'
MODULE 'exec', 'intuition'
MODULE 'amigalib/boopsi'
MODULE 'intuition/classusr', 'libraries/asl', 'utility/hooks'
MODULE 'intuition/classes', 'graphics'

->work-around difference between AmiDevCpp & official includes for libraries/mui
#ifdef pe_TargetOS_MorphOS
{
#ifdef MUIA_Dtpic_Name
	#undef MUIA_Dtpic_Name
#endif
#ifdef MUIA_Group_Forward
	#undef MUIA_Group_Forward
#endif
}
#endif

->work-around OS4 SDK not using MUI4+ by default
#ifdef pe_TargetOS_AmigaOS4
{
#ifdef MUIA_Dtpic_Name
	#undef MUIA_Dtpic_Name
#endif
}
#endif

PROC new()
	muimasterbase := OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN)
	IF muimasterbase=NIL THEN Throw("ERR", 'Failed to open muimaster.library')
ENDPROC

PROC end()
	CloseLibrary(muimasterbase)
ENDPROC

/*****************************/

TYPE PTIO IS PTR TO INTUIOBJECT

CONST MUI_FALSE = 0

/*****************************/

#define FreeHoriz TextObject, MUIA_InnerLeft,0, MUIA_InnerRight,0, End

#define FreeVert  ImageObject, MUIA_InnerTop,0, MUIA_InnerBottom,0, MUIA_Image_FreeVert,TRUE, End

#define FreeHV    RectangleObject, MUIA_InnerLeft,0, MUIA_InnerRight,0, MUIA_InnerTop,0, MUIA_InnerBottom,0, End

/*****************************/

#define DtpicObjectA Mui_NewObjectA(MUIC_Dtpic,[TAG_IGNORE,0

#ifndef pe_TargetOS_AROS
CONST MUIA_Dtpic_Name = $80423d72 /* V18 isg STRPTR */
#endif

#ifndef pe_TargetOS_AmigaOS4
#ifndef pe_TargetOS_AROS
CONST MUIA_Group_Forward = $80421422
#endif
#endif

/*****************************/

PROC muim_Notify(watchObject:PTIO, triggerAttr, triggerValue=MUIV_EveryTime, destObject=MUIV_Notify_Application, destParams1=NILL:ILIST, destParams2=NILL:ILIST)
	DEF list:ILIST, head:ILIST, destParams1Len, destParams2Len, combined:OWNS LIST
	
	destParams1Len := IF destParams1 THEN ListLen(destParams1) ELSE 0
	destParams2Len := IF destParams2 THEN ListLen(destParams2) ELSE 0
	head := [MUIM_Notify, triggerAttr, triggerValue, destObject, destParams1Len + destParams2Len]
	IF destParams1Len + destParams2Len = 0
		list := head
	ELSE
		NEW combined[ListLen(head) + destParams1Len + destParams2Len]
		ListCopy(combined, head)
		IF destParams1 THEN ListAdd(combined, destParams1)
		IF destParams2 THEN ListAdd(combined, destParams2)
		list := combined
	ENDIF
	
	doMethodA(watchObject, list)
FINALLY
	END combined
ENDPROC

PROC muim_Notify_action(watchObject:PTIO, triggerAttr, triggerValue, actionHook:PTR TO hook, param=NILL:ILIST) IS muim_Notify(watchObject, triggerAttr, triggerValue, watchObject /*MUIV_Notify_Self*/, [MUIM_CallHook, actionHook], param)

PROC muim_Notify_action_button(watchObject:PTIO, actionHook:PTR TO hook, param=NILL:ILIST) IS muim_Notify_action(watchObject, MUIA_Pressed,               MUI_FALSE,      actionHook, param)

PROC muim_Notify_action_cycle( watchObject:PTIO, actionHook:PTR TO hook, param=NILL:ILIST) IS muim_Notify_action(watchObject, MUIA_Cycle_Active,          MUIV_EveryTime, actionHook, param)

PROC muim_Notify_action_radio( watchObject:PTIO, actionHook:PTR TO hook, param=NILL:ILIST) IS muim_Notify_action(watchObject, MUIA_Radio_Active,          MUIV_EveryTime, actionHook, param)

PROC muim_Notify_action_string(watchObject:PTIO, actionHook:PTR TO hook, param=NILL:ILIST) IS muim_Notify_action(watchObject, MUIA_String_Acknowledge,    MUIV_EveryTime, actionHook, param)

PROC muim_Notify_action_tick(  watchObject:PTIO, actionHook:PTR TO hook, param=NILL:ILIST) IS muim_Notify_action(watchObject, MUIA_Selected,              MUIV_EveryTime, actionHook, param)

PROC muim_Notify_action_slider(watchObject:PTIO, actionHook:PTR TO hook, param=NILL:ILIST) IS muim_Notify_action(watchObject, MUIA_Numeric_Value,         MUIV_EveryTime, actionHook, param)

PROC muim_Notify_action_list(  watchObject:PTIO, actionHook:PTR TO hook, param=NILL:ILIST)
	muim_Notify_action(watchObject, MUIA_Listview_SelectChange, MUI_TRUE,       actionHook, param)
	muim_Notify_action(watchObject, MUIA_List_Active,           MUIV_EveryTime, actionHook, param)
ENDPROC

/*
PROC muim_Notify_action_nlist( watchObject:PTIO, actionHook:PTR TO hook, param=NILL:ILIST)
	muim_Notify_action(watchObject, MUIA_NList_Active,       MUIV_EveryTime, actionHook, param)
	muim_Notify_action(watchObject, MUIA_NList_SelectChange, MUI_TRUE,       actionHook, param)		->this can cause spurious events at cGUI creation
ENDPROC
*/
->experimental work-around for cGUI issue
PROC muim_Notify_action_nlist(watchObject:PTIO, actionHook:PTR TO hook, param=NILL:ILIST, multiselect=MUIV_NList_MultiSelect_None)
	muim_Notify_action(    watchObject, MUIA_NList_Active,       MUIV_EveryTime, actionHook, param)
	
	IF multiselect <> MUIV_NList_MultiSelect_Shifted
		muim_Notify_action(watchObject, MUIA_NList_SelectChange, MUI_TRUE,       actionHook, param)
	ENDIF
ENDPROC
/*
->problematic work-around (WHY?)
PROC muim_Notify_action_nlist(watchObject:PTIO, actionHook:PTR TO hook, param=NILL:ILIST)
	DEF value
	value := MUIV_NList_MultiSelect_None
	get(watchObject, MUIA_NList_MultiSelect, ADDRESSOF value)
	IF value = MUIV_NList_MultiSelect_None
		muim_Notify_action(watchObject, MUIA_NList_Active,       MUIV_EveryTime, actionHook, param)
	ELSE
		muim_Notify_action(watchObject, MUIA_NList_SelectChange, MUI_TRUE,       actionHook, param)
	ENDIF
ENDPROC
*/

PROC muim_Notify_action_popasl(watchObject:PTIO, actionHook:PTR TO hook, param=NILL:ILIST)
	DEF stringObject:PTIO
	
	get(watchObject, MUIA_Popstring_String, ADDRESSOF stringObject)
	muim_Notify_action_string(stringObject, actionHook, param)
ENDPROC


PROC muiSetString(stringObject:PTIO, string:ARRAY OF CHAR)
	DEF oldString:ARRAY OF CHAR
	
	get(stringObject, MUIA_String_Contents, ADDRESSOF oldString)
	IF StrCmp(oldString, string) = FALSE
		set(stringObject, MUIA_String_Contents, string)
		
		get(stringObject, MUIA_String_Contents, ADDRESSOF string)
		set(stringObject, MUIA_String_Acknowledge, string)
	ENDIF
ENDPROC

PROC muiSetStringInteger(stringObject:PTIO, number)
	DEF string:ARRAY OF CHAR
	DEF oldNumber
	
	get(stringObject, MUIA_String_Integer, ADDRESSOF oldNumber)
	IF oldNumber <> number
		set(stringObject, MUIA_String_Integer, number)
		
		get(stringObject, MUIA_String_Contents, ADDRESSOF string)
		set(stringObject, MUIA_String_Acknowledge, string)
	ENDIF
ENDPROC

/*****************************/

PROC newPopaslObject(aslType=ASL_FILEREQUEST, button=0, startHook=NIL:PTR TO hook, stopHook=NIL:PTR TO hook, initialPath=NILA:ARRAY OF CHAR) IS PopaslObject, 
		MUIA_Popstring_String, StringMUI(initialPath, 256),
		MUIA_Popstring_Button, PopButton(IF button THEN button ELSE MUII_PopFile),
		MUIA_Popasl_Type, aslType,
		IF startHook THEN MUIA_Popasl_StartHook ELSE TAG_IGNORE, startHook,
		IF  stopHook THEN MUIA_Popasl_StopHook  ELSE TAG_IGNORE,  stopHook,
	End

PROC newNumberString(default) IS StringObject,
		StringFrame,
		MUIA_String_Accept , '0123456879-',
		MUIA_String_Integer, default,
	End

#define newCheckMark(bool, variable) HGroup,\
		Child, variable := CheckMark(bool),\
		Child, HSpace(0),\
	End

#define newRadio(options, default, variable) HGroup,\
		Child, variable := RadioObject, MUIA_Radio_Entries, options, MUIA_Radio_Active, default, End,\
		Child, HSpace(0),\
	End

/*****************************/

CLASS muiClass PRIVATE
	object:PTR TO muiObject
ENDCLASS

PROC new(cl:PTR TO iclass, obj:PTIO, msg:PTR TO opset, attrlist=NILA:ARRAY OF tagitem) OF muiClass RETURNS success IS MUI_TRUE

PROC dispose(cl:PTR TO iclass, obj:PTIO, msg:PTR TO msg) OF muiClass IS EMPTY

PROC set(cl:PTR TO iclass, obj:PTIO, msg:PTR TO opset, attrlist:ARRAY OF tagitem) OF muiClass IS EMPTY

PROC get(cl:PTR TO iclass, obj:PTIO, msg:PTR TO opget, storage:ARRAY OF ULONG) OF muiClass RETURNS ret IS doSuperMethodA(cl, obj, msg)

PROC askMinMax(cl:PTR TO iclass, obj:PTIO, msg:PTR TO muip_askminmax) OF muiClass IS EMPTY

PROC setup(cl:PTR TO iclass, obj:PTIO, msg:PTR TO msg) OF muiClass RETURNS success IS MUI_TRUE

PROC cleanup(cl:PTR TO iclass, obj:PTIO, msg:PTR TO msg) OF muiClass IS EMPTY

PROC draw(cl:PTR TO iclass, obj:PTIO, msg:PTR TO muip_draw) OF muiClass IS EMPTY

PROC handleInput(cl:PTR TO iclass, obj:PTIO, msg:PTR TO muip_handleinput, muikey=0, imsg=NIL:PTR TO intuimessage) OF muiClass IS EMPTY

PROC show(cl:PTR TO iclass, obj:PTIO, msg:PTR TO muip_show) OF muiClass IS EMPTY

PROC hide(cl:PTR TO iclass, obj:PTIO, msg:PTR TO muip_hide) OF muiClass IS EMPTY

/*---------------------------*/

PROC muiClass_createClass(supername:ARRAY OF CHAR, supermcc:PTR TO mui_customclass) RETURNS mcc:PTR TO mui_customclass
	mcc := eMui_CreateCustomClass(NIL, supername, supermcc, SIZEOF muiObject, CALLBACK muiObject_dispatcher())
ENDPROC

#define MuiClassMacro(object, proc) PROC proc(mcc:PTR TO mui_customclass, tags=NILA:ARRAY OF tagitem) RETURNS obj:PTIO\
	DEF newClass:OWNS PTR TO object\
	NEW newClass\
	obj := muiClass_newObjectA(mcc, PASS newClass, tags)\
ENDPROC

PROC muiClassOfObject(obj:PTIO, mcc:PTR TO mui_customclass) RETURNS class:PTR TO muiClass IS INST_DATA(mcc.mcc_class, obj)::muiObject.class


PROC muiClass_newObjectA(mcc:PTR TO mui_customclass, newClass:OWNS PTR TO muiClass, tags=NILA:ARRAY OF tagitem) RETURNS obj:PTIO
	DEF cl:PTR TO iclass
	cl  := mcc.mcc_class
	obj := NewObjectA(cl, NILA, [TAG_USER OR $987,PASS newClass, TAG_MORE,tags]:tagitem)
ENDPROC

PRIVATE

OBJECT muiObject
	class:OWNS PTR TO muiClass
ENDOBJECT

PROC muiObject_dispatcher(cl:PTR TO iclass, obj:PTIO, msg:PTR TO msg) RETURNS ret
	SELECT msg.methodid
	CASE OM_NEW           ; RETURN muiObject_new        (cl, obj, msg!!PTR)
	CASE OM_DISPOSE       ; RETURN muiObject_dispose    (cl, obj, msg!!PTR)
	CASE OM_SET           ; RETURN muiObject_set        (cl, obj, msg!!PTR)
	CASE OM_GET           ; RETURN muiObject_get        (cl, obj, msg!!PTR)
	CASE MUIM_AskMinMax   ; RETURN muiObject_askMinMax  (cl, obj, msg!!PTR)
	CASE MUIM_Setup       ; RETURN muiObject_setup      (cl, obj, msg!!PTR)
	CASE MUIM_Cleanup     ; RETURN muiObject_cleanup    (cl, obj, msg!!PTR)
	CASE MUIM_Draw        ; RETURN muiObject_draw       (cl, obj, msg!!PTR)
	CASE MUIM_HandleInput ; RETURN muiObject_handleInput(cl, obj, msg!!PTR)
	CASE MUIM_Show        ; RETURN muiObject_show       (cl, obj, msg!!PTR)
	CASE MUIM_Hide        ; RETURN muiObject_hide       (cl, obj, msg!!PTR)
	DEFAULT               ; RETURN doSuperMethodA       (cl, obj, msg)
	ENDSELECT
ENDPROC

PROC muiObject_new(cl:PTR TO iclass, obj:PTIO, msg:PTR TO opset)
	DEF object:PTR TO muiObject, tags:ARRAY OF tagitem, tag:PTR TO tagitem, newClass:OWNS PTR TO muiClass
	
	IF tags := msg.attrlist
		->parse & strip parameter added by muiClass_newObjectA()
		tag := tags[0] ; tags++
		IF tag.tag = (TAG_USER OR $987)
			newClass := /*OWNS*/ tag.data !!PTR
			msg.attrlist := tags
		ENDIF
		/*
		->original implementation, which requires utility.library to be opened
		tag := NextTagItem(ADDRESSOF tags)
		IF tag.tag = (TAG_USER OR $987)
			newClass := /*OWNS*/ tag.data !!PTR
			msg.attrlist := tags
		ENDIF
		*/
	ENDIF
	IF newClass = NIL THEN RETURN NIL		->fail if we were not called by muiClass_newObjectA()
	
	obj := doSuperMethodA(cl, obj, msg) !!PTIO
	IF obj = NIL THEN RETURN
	
	object := INST_DATA(cl, obj)::muiObject
	object.class := PASS newClass
	object.class.object := object
	
	IF object.class.new(cl, obj, msg, tags) = FALSE
		coerceMethodA(cl, obj, [OM_DISPOSE]:msg)	->invoke OM_DISPOSE on *our* class
		RETURN NIL
	ENDIF
ENDPROC obj

PROC muiObject_dispose(cl:PTR TO iclass, obj:PTIO, msg:PTR TO msg) RETURNS ret
	DEF object:PTR TO muiObject
	object := INST_DATA(cl, obj)::muiObject
	END object.class
	ret := doSuperMethodA(cl, obj, msg)
ENDPROC

PROC muiObject_set(cl:PTR TO iclass, obj:PTIO, msg:PTR TO opset) RETURNS ret
	DEF object:PTR TO muiObject
	object := INST_DATA(cl, obj)::muiObject
	IF object.class THEN object.class.set(cl, obj, msg, msg.attrlist)
	ret := doSuperMethodA(cl, obj, msg)
ENDPROC

PROC muiObject_get(cl:PTR TO iclass, obj:PTIO, msg:PTR TO opget) RETURNS ret
	DEF object:PTR TO muiObject
	object := INST_DATA(cl, obj)::muiObject
	ret := IF object.class THEN object.class.get(cl, obj, msg, msg.storage) ELSE doSuperMethodA(cl, obj, msg)
ENDPROC

PROC muiObject_askMinMax(cl:PTR TO iclass, obj:PTIO, msg:PTR TO muip_askminmax)
	DEF object:PTR TO muiObject
	doSuperMethodA(cl, obj, msg)
	object := INST_DATA(cl, obj)::muiObject
	object.class.askMinMax(cl, obj, msg)
ENDPROC 0

PROC muiObject_setup(cl:PTR TO iclass, obj:PTIO, msg:PTR TO msg) RETURNS success
	DEF object:PTR TO muiObject
	
	success := doSuperMethodA(cl, obj, msg)
	IF success = MUI_FALSE THEN RETURN
	
	object := INST_DATA(cl, obj)::muiObject
	success := object.class.setup(cl, obj, msg)
	
	IF success = FALSE THEN coerceMethodA(cl, obj, [MUIM_Cleanup]:msg)	->invoke MUIM_Cleanup for our super-class
ENDPROC

PROC muiObject_cleanup(cl:PTR TO iclass, obj:PTIO, msg:PTR TO msg) RETURNS ret
	DEF object:PTR TO muiObject
	object := INST_DATA(cl, obj)::muiObject
	object.class.cleanup(cl, obj, msg)
	ret := doSuperMethodA(cl, obj, msg)
ENDPROC

PROC muiObject_draw(cl:PTR TO iclass, obj:PTIO, msg:PTR TO muip_draw)
	DEF object:PTR TO muiObject
	
	doSuperMethodA(cl, obj, msg)
	IF (msg.flags AND (MADF_DRAWOBJECT OR MADF_DRAWUPDATE))=0 THEN RETURN 0
	
	object := INST_DATA(cl, obj)::muiObject
	object.class.draw(cl, obj, msg)
ENDPROC 0

PROC muiObject_handleInput(cl:PTR TO iclass, obj:PTIO, msg:PTR TO muip_handleinput) RETURNS ret
	DEF object:PTR TO muiObject
	object := INST_DATA(cl, obj)::muiObject
	object.class.handleInput(cl, obj, msg, msg.muikey, msg.imsg)
	ret := doSuperMethodA(cl, obj, msg)
ENDPROC

PROC muiObject_show(cl:PTR TO iclass, obj:PTIO, msg:PTR TO muip_show) RETURNS ret	-># I'm not sure if "ret" is needed
	DEF object:PTR TO muiObject
	object := INST_DATA(cl, obj)::muiObject
	object.class.show(cl, obj, msg)
	ret := doSuperMethodA(cl, obj, msg)
ENDPROC

PROC muiObject_hide(cl:PTR TO iclass, obj:PTIO, msg:PTR TO muip_hide) RETURNS ret	-># I'm not sure if "ret" is needed
	DEF object:PTR TO muiObject
	object := INST_DATA(cl, obj)::muiObject
	object.class.hide(cl, obj, msg)
	ret := doSuperMethodA(cl, obj, msg)
ENDPROC

PUBLIC

/*****************************/
