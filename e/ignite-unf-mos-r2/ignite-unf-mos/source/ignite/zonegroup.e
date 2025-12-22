
OPT MODULE, PREPROCESS

-> zonegroup, a mui group of gadgets to control zone parameters

-> TODO: make use of mathstring

MODULE '*mainmisc'
MODULE '*mystring'
MODULE '*fractmisc'

->MODULE '*modules'

MODULE 'muimaster'
MODULE 'libraries/mui'
MODULE 'libraries/muip'
MODULE 'utility'
MODULE 'utility/tagitem'
MODULE 'utility/hooks'
MODULE 'mui/muicustomclass'
MODULE 'tools/installhook'
MODULE 'amigalib/boopsi'
MODULE 'amigalib/lists'
MODULE 'intuition/classes'
MODULE 'intuition/classusr'
MODULE 'intuition/intuition'

#ifdef DEBUG
   #define DEBUGF(str,...) DebugF(str,...)
#else
   #define DEBUGF(str,...)
#endif


OBJECT zonegroupdata
   actionhook:PTR TO hook
   backGad, forwGad, zoneXGad, zoneYGad, zoneRGad
   ehn:mui_eventhandlernode
ENDOBJECT

EXPORT PROC createZonegroupClass()
ENDPROC eMui_CreateCustomClass(NIL,MUIC_Group,NIL,SIZEOF zonegroupdata,{zonegroupDispatcher})

#define MiniKeyButton(name,key)\
        TextObject,\
                ButtonFrame,\
            MUIA_Font,          MUIV_Font_Button,\
                MUIA_Text_Contents, name,\
                MUIA_Text_PreParse, '\ec',\
                MUIA_ControlChar  , key,\
                MUIA_InputMode    , MUIV_InputMode_RelVerify,\
                MUIA_Background   , MUII_ButtonBack,\
                MUIA_Weight, 0,\
                End

PROC zonegroupDispatcher(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
   DEF mid

   mid:=msg.methodid
   SELECT mid
   CASE MUIM_HandleEvent  ; RETURN zonegroupHandleEvent(cl, obj, msg)
   CASE OM_NEW           ;  RETURN            zonegroupNew(cl, obj, msg)
   CASE OM_DISPOSE       ;  RETURN        zonegroupDispose(cl, obj, msg)
   CASE MUIM_Zonegroup_Set_Zone ; RETURN  zonegroupSetZone(cl, obj, msg)
   CASE MUIM_Zonegroup_Get_Zone ; RETURN  zonegroupGetZone(cl, obj, msg)
   CASE MUIM_Setup        ; RETURN zonegroupSetup(cl, obj, msg)
   CASE MUIM_Cleanup      ; RETURN zonegroupCleanup(cl, obj, msg)
   ENDSELECT

ENDPROC doSuperMethodA(cl, obj, msg)

PROC zonegroupNew(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO opnew)  HANDLE
   DEF data:PTR TO zonegroupdata, gr=NIL, tags:PTR TO tagitem, tag:PTR TO tagitem

   IF (obj := doSuperMethodA(cl, obj, msg)) = NIL THEN RETURN 0

   data := INST_DATA(cl, obj)

   tags := msg.attrlist

   data.actionhook := GetTagData(MUIA_Zonegroup_ActionHook, NIL, tags)
   IF data.actionhook = NIL THEN Raise("ITAG")

   gr := HGroup,
         Child, Label1('X'),
         Child, data.zoneXGad := floatStringObject(0.0,"ZCX"),
         Child, Label1('Y'),
         Child, data.zoneYGad := floatStringObject(0.0,"ZCY"),
         Child, Label1('R'),
         Child, data.zoneRGad := floatStringObject(1.5,"ZCR"),
         Child, HGroup, MUIA_Group_Spacing, 0,
            Child, data.backGad := MiniKeyButton('U', "u"),
            Child, data.forwGad := MiniKeyButton('R', "r"),
         End,
   End

   IF gr = FALSE THEN Raise("GR")

   DOMETHODA(obj, [OM_ADDMEMBER, gr])

   DOMETHODA(data.zoneXGad, [MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
      obj, 3, MUIM_CallHook, data.actionhook, AH_NEWZONE])
   DOMETHODA(data.zoneYGad, [MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
      obj, 3, MUIM_CallHook, data.actionhook, AH_NEWZONE])
   DOMETHODA(data.zoneRGad, [MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
      obj, 3, MUIM_CallHook, data.actionhook, AH_NEWZONE])

   DOMETHODA(data.backGad, [MUIM_Notify, MUIA_Pressed, FALSE,
      obj, 3, MUIM_CallHook, data.actionhook, AH_PREVZONE])

   DOMETHODA(data.forwGad, [MUIM_Notify, MUIA_Pressed, FALSE,
      obj, 3, MUIM_CallHook, data.actionhook, AH_NEXTZONE])

EXCEPT

   SetIoErr(exception)
   coerceMethodA(cl, obj, [OM_DISPOSE])
   RETURN NIL

ENDPROC obj


PROC zonegroupDispose(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)

ENDPROC doSuperMethodA(cl, obj, msg)


PROC zonegroupSetup(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
   DEF data:PTR TO zonegroupdata

   IF doSuperMethodA(cl, obj, msg) = FALSE THEN RETURN FALSE

  data := INST_DATA(cl, obj)

  DEBUGF('zonegroupSetup()\n')

  data.ehn.ehn_priority := 0
  data.ehn.ehn_flags := 0
  data.ehn.ehn_events := IDCMP_RAWKEY
  data.ehn.ehn_object := obj
  data.ehn.ehn_class := cl

  DOMETHODA(_win(obj), [MUIM_Window_AddEventHandler, data.ehn])

ENDPROC MUI_TRUE

PROC zonegroupCleanup(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
   DEF data:PTR TO zonegroupdata

   data := INST_DATA(cl, obj)

   DEBUGF('zonegroupCleanup()\n')

   DOMETHODA(_win(obj), [MUIM_Window_RemEventHandler, data.ehn])

ENDPROC doSuperMethodA(cl, obj, msg)



PROC zonegroupSetZone(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO PTR)
   DEF data:PTR TO zonegroupdata, zone:PTR TO zone

   data := INST_DATA(cl, obj)
   zone := msg[1]

   setStringFloat(data.zoneXGad, zone.x)
   setStringFloat(data.zoneYGad, zone.y)
   setStringFloat(data.zoneRGad, zone.r)

ENDPROC TRUE

PROC zonegroupGetZone(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO PTR)
   DEF data:PTR TO zonegroupdata, zone:PTR TO zone

   data := INST_DATA(cl, obj)
   zone := msg[1]

   zone.x := getStringFloat(data.zoneXGad)
   zone.y := getStringFloat(data.zoneYGad)
   zone.r := getStringFloat(data.zoneRGad)

ENDPROC TRUE

CONST CURS_LEFT=79,
     CURS_UP=76,
     CURS_RIGHT=78,
     CURS_DOWN=77,
     CURS_UP_RELEASE=204,
     CURS_DOWN_RELEASE=205,
     CURS_RIGHT_RELEASE=206,
     CURS_LEFT_RELEASE=207,
     PAD_PLUS=94,
     PAD_MINUS=74

PROC zonegroupHandleEvent(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_handleevent)
   DEF class, code
   DEF data:PTR TO zonegroupdata
   DEF rc=NIL

   data := INST_DATA(cl, obj)

   IF msg.imsg
      class := msg.imsg.class
      code := msg.imsg.code
      SELECT class
      CASE IDCMP_RAWKEY
         DEBUGF('zonegroupHandleEvent() received rawkey \d\n', code)
         SELECT 256 OF code
         CASE CURS_LEFT   ; CALLHOOKA(data.actionhook, obj, [AH_SKIP_LEFT])
         CASE CURS_RIGHT  ; CALLHOOKA(data.actionhook, obj, [AH_SKIP_RIGHT])
         CASE CURS_UP     ; CALLHOOKA(data.actionhook, obj, [AH_SKIP_UP])
         CASE CURS_DOWN   ; CALLHOOKA(data.actionhook, obj, [AH_SKIP_DOWN])
         CASE PAD_PLUS    ; CALLHOOKA(data.actionhook, obj, [AH_SKIP_IN])
         CASE PAD_MINUS   ; CALLHOOKA(data.actionhook, obj, [AH_SKIP_OUT])
         ENDSELECT
      ENDSELECT

   ENDIF



ENDPROC rc







