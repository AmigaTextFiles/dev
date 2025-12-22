/*

      AudioSTREAM Professional
      (c) 1997-98 Immortal SYSTEMS

      Source codes for version 1.0
      
      =================================================

      Source:     customclasses.e
      Description:    definitions of all custom classes
      Version:    1.0
 --------------------------------------------------------------------
*/



OPT MODULE
OPT PREPROCESS



MODULE 'muimaster' , 'libraries/mui','*gui_declarations','*common'
MODULE 'utility','utility/tagitem' , 'amigalib/boopsi','tools/boopsi'
MODULE 'intuition/classes','*global'
MODULE 'intuition/classusr','*declarations'
MODULE 'libraries/muip','mui/muicustomclass','intuition/intuition'


/* ###################### MYEATER CLASS ######################### */

/*  MYEATER OBJECT CREATION  */


EXPORT DEF hooks:PTR TO obj_hooks,eatflag,eatflag2,eatflag3

PROC myeater_setup(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
DEF data:PTR TO mui_eventhandlernode

IF doSuperMethodA(cl,obj,msg)=NIL THEN RETURN FALSE
      data:=INST_DATA(cl,obj)
      data.ehn_object:=obj
      data.ehn_class:=cl
      data.ehn_events:=IDCMP_RAWKEY
      data.ehn_priority:=1
      domethod(_win(obj),[MUIM_Window_AddEventHandler,data])

ENDPROC MUI_TRUE

PROC myeater_cleanup(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
DEF data:PTR TO mui_eventhandlernode

      data:=INST_DATA(cl,obj)
      domethod(_win(obj),[MUIM_Window_RemEventHandler,data])

ENDPROC doSuperMethodA(cl,obj,msg)

PROC myeater_handleevent(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_handleevent)
DEF hovno:PTR TO intuimessage 

      IF (hovno:=msg.imsg)=NIL THEN RETURN
      eatflag:=0

      IF hovno.class=IDCMP_RAWKEY
            domethod(obj,[MUIM_CallHook,hooks.s_keyboard,hovno.code,hovno.qualifier])
      ENDIF

ENDPROC eatflag

/* set eatflag to 1 to eat the event */
      


PROC myeater_dispatcher(cl:PTR TO iclass,obj,msg:PTR TO msg)
DEF methodID
methodID:=msg.methodid

    SELECT methodID
        CASE MUIM_Setup; RETURN myeater_setup(cl,obj,msg)
        CASE MUIM_Cleanup ; RETURN myeater_cleanup(cl,obj,msg)
      CASE MUIM_HandleEvent ; RETURN myeater_handleevent(cl,obj,msg)
    ENDSELECT


    RETURN doSuperMethodA(cl,obj,msg)
ENDPROC

EXPORT PROC init_eater() 
DEF temp:PTR TO mui_customclass
temp:=eMui_CreateCustomClass(NIL,MUIC_Area,NIL,SIZEOF mui_eventhandlernode,{myeater_dispatcher})
IF temp THEN temp:=temp.mcc_class
ENDPROC temp









/* ###################### CHANNEL CLASS ######################### */

/*  CHANNEL OBJECT CREATION  */




PROC channel_setup(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
DEF data:PTR TO mui_eventhandlernode

IF doSuperMethodA(cl,obj,msg)=NIL THEN RETURN FALSE
      data:=INST_DATA(cl,obj)
      data.ehn_object:=obj
      data.ehn_class:=cl
      data.ehn_events:=IDCMP_RAWKEY
      domethod(_win(obj),[MUIM_Window_AddEventHandler,data])

ENDPROC MUI_TRUE

PROC channel_cleanup(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
DEF data:PTR TO mui_eventhandlernode

      data:=INST_DATA(cl,obj)
      domethod(_win(obj),[MUIM_Window_RemEventHandler,data])

ENDPROC doSuperMethodA(cl,obj,msg)

PROC channel_handleevent(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_handleevent)
DEF hovno:PTR TO intuimessage 
DEF kokot

hovno:=msg.imsg
eatflag2:=0
kokot:=doSuperMethodA(cl,obj,msg)

IF hovno
      IF hovno.class=IDCMP_RAWKEY
            domethod(obj,[MUIM_CallHook,hooks.ted_editorevent,hovno.code,hovno.qualifier])
      ENDIF
ENDIF

kokot:=kokot OR eatflag2

ENDPROC eatflag2



PROC channel_dispatcher(cl:PTR TO iclass,obj,msg:PTR TO msg)
DEF methodID
methodID:=msg.methodid

    SELECT methodID
        CASE MUIM_Setup; RETURN channel_setup(cl,obj,msg)
        CASE MUIM_Cleanup ; RETURN channel_cleanup(cl,obj,msg)
      CASE MUIM_HandleEvent ; RETURN channel_handleevent(cl,obj,msg)
    ENDSELECT


    RETURN doSuperMethodA(cl,obj,msg)
ENDPROC

EXPORT PROC init_channel() 
DEF temp:PTR TO mui_customclass
temp:=eMui_CreateCustomClass(NIL,MUIC_Listview,NIL,SIZEOF mui_eventhandlernode,{channel_dispatcher})
IF temp THEN temp:=temp.mcc_class
ENDPROC temp




/* ###################### EFFECT CLASS ######################### */

/*  EFFECT STRING OBJECT CREATION  */

PROC effect_setup(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
DEF data:PTR TO mui_eventhandlernode

IF doSuperMethodA(cl,obj,msg)=NIL THEN RETURN FALSE
      data:=INST_DATA(cl,obj)
      data.ehn_object:=obj
      data.ehn_class:=cl
      data.ehn_events:=IDCMP_RAWKEY
      data.ehn_priority:=127
      domethod(_win(obj),[MUIM_Window_AddEventHandler,data])

ENDPROC MUI_TRUE

PROC effect_cleanup(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
DEF data:PTR TO mui_eventhandlernode

      data:=INST_DATA(cl,obj)
      domethod(_win(obj),[MUIM_Window_RemEventHandler,data])

ENDPROC doSuperMethodA(cl,obj,msg)

PROC effect_handleevent(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_handleevent)
DEF hovno:PTR TO intuimessage 
DEF kokot

hovno:=msg.imsg
eatflag3:=0
kokot:=doSuperMethodA(cl,obj,msg)

IF hovno
      IF hovno.class=IDCMP_RAWKEY
            IF hovno.code=0
                  ->domethod(obj,[MUIM_CallHook,hooks.f_ted_ack])
            ELSE
                  ->domethod(obj,[MUIM_CallHook,hooks.ted_stringevent,hovno.code,hovno.qualifier])
            ENDIF
      ENDIF
ENDIF


ENDPROC eatflag3



PROC effect_dispatcher(cl:PTR TO iclass,obj,msg:PTR TO msg)
DEF methodID
methodID:=msg.methodid

    /*SELECT methodID      -not yet used -
        CASE MUIM_Setup; RETURN effect_setup(cl,obj,msg)
        CASE MUIM_Cleanup ; RETURN effect_cleanup(cl,obj,msg)
      CASE MUIM_HandleEvent ; RETURN effect_handleevent(cl,obj,msg)
    ENDSELECT  */


    RETURN doSuperMethodA(cl,obj,msg)
ENDPROC

EXPORT PROC init_effect() 
DEF temp:PTR TO mui_customclass
temp:=eMui_CreateCustomClass(NIL,MUIC_String,NIL,SIZEOF mui_eventhandlernode,{effect_dispatcher})
IF temp THEN temp:=temp.mcc_class
ENDPROC temp







      /*    DragSortable list creation */
      /*    "DSList                 */

                  
      /*  will call the hook set in MUIA_Userdata (if exists)
          each time when the dragdrop is performed.
          param1 = source index, param2 = dropmark  */






OBJECT obj_dslistdata
dummy
ENDOBJECT


PROC dslist_dragdrop(cl:PTR TO iclass,obj:PTR TO object ,msg:PTR TO muip_dragdrop)
DEF source,dest,h

      
      get(msg.obj,MUIA_List_Active,{source})
      get(obj,MUIA_List_DropMark,{dest})  
      h:=muiUserData(obj)
      IF h
            domethod(obj,[MUIM_CallHook,h,source,dest])
      ENDIF
ENDPROC doSuperMethodA(cl,obj,msg)        
      


PROC dslist_dispatcher(cl:PTR TO iclass,obj,msg:PTR TO msg)
DEF methodID
methodID:=msg.methodid

    SELECT methodID      
        CASE MUIM_DragDrop; RETURN dslist_dragdrop(cl,obj,msg)
    ENDSELECT 


    RETURN doSuperMethodA(cl,obj,msg)
ENDPROC


EXPORT PROC init_dslist() 
DEF temp:PTR TO mui_customclass
temp:=eMui_CreateCustomClass(NIL,MUIC_List,NIL,SIZEOF obj_dslistdata,{dslist_dispatcher})
IF temp THEN temp:=temp.mcc_class
ENDPROC temp      







