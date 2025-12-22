OPT MODULE, PREPROCESS

->MODULE '*modules'

MODULE 'utility/tagitem'
MODULE 'utility/hooks'
MODULE 'graphics/gfx'
MODULE 'graphics/rastport'
MODULE 'intuition/classes'
MODULE 'intuition/classusr'
MODULE 'intuition/screens'
MODULE 'intuition/intuition'
MODULE 'intuition/intuitionbase'
MODULE 'libraries/mui'
MODULE 'libraries/muip'

MODULE 'muimaster'
MODULE 'utility'

MODULE 'mui/muicustomclass'
MODULE 'tools/installhook'
MODULE 'tools/thread'
MODULE 'amigalib/boopsi'
MODULE 'amigalib/lists'

MODULE 'exec/memory'

MODULE '*ignite_defs'

MODULE '*mystring'

MODULE 'exec/memory'

                /****** RENDWIN **************************/

OBJECT rendwindata
   hook:hook
   selfobj:PTR TO object
   rm:PTR TO rendermsg
   width:INT, height:INT, rastport:PTR TO rastport
   zoneR:DOUBLE, zoneX:DOUBLE, zoneY:DOUBLE
   widthGad, heightGad, rendBut, stopBut
ENDOBJECT

-> the only exported item
EXPORT PROC createRendWinClass()
ENDPROC eMui_CreateCustomClass(NIL,MUIC_Window,NIL,SIZEOF rendwindata,{rendWinDispatcher})


PROC rendWinDispatcher(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)

   SELECT msg.methodid
   CASE OM_NEW            ; RETURN rendWinNew(cl, obj, msg)
   CASE OM_DISPOSE        ; RETURN rendWinDispose(cl, obj, msg)
   CASE OM_SET            ; RETURN rendWinSet(cl, obj, msg)
   CASE OM_GET            ; RETURN rendWinGet(cl, obj, msg)
   ENDSELECT

ENDPROC doSuperMethodA(cl, obj, msg)

PROC rendWinNew(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO opset) HANDLE
   DEF data:PTR TO rendwindata, gr=NIL, gr2=NIL, tags:PTR TO tagitem, tag:PTR TO tagitem
   DEF fractmcc:PTR TO mui_customclass

   IF (obj := doSuperMethodA(cl, obj, [OM_NEW, [MUIA_Window_RootObject,
   gr := VGroup, End, NIL]])) = NIL THEN (IF gr THEN Mui_DisposeObject(gr)) BUT RETURN NIL

   data := INST_DATA(cl, obj)
   data.selfobj := obj

   installhook(data, {rendWinHookHandler})

   replyport := CreateMsgPort()
   IF replyport = NIL THEN Raise("PORT")

   tags := msg.attrlist

   WHILE tag := NextTagItem({tags})
      SELECT tag.tag
      CASE MUIA_RendWin_FractMCC
         fractmcc := tag.data
      CASE MUIA_RendWin_RenderMsg
         data.rm := tag.data
      ENDSELECT
   ENDWHILE

   data.rm.replyport := replyport

   data.fractobj := NewObjectA(fractmcc.mcc_class, NIL, [NIL])
   IF data.fractobj = NIL THEN Raise("FOBJ")

   gr2 := VGroup,
      Child, HGroup,
         Child, data.widthGad :=  IString(800, NIL),
         Child, data.heightGad := IString(600, NIL),
      End,
      Child, HGroup,
         Child, data.rendBut := KeyButton(' Render ', "r"),
         Child, data.stopBut := KeyButton(' Stop ', "s"),
      End,
   End

   doMethodA(obj, [OM_ADDMEMBER, gr2])

   doMethodA(obj, [OM_ADDMEMBER, data.fractobj])

   DOMETHODA(obj, [MUIM_Notify, MUIA_Window_CloseRequest, MUI_TRUE,
      obj, 3, MUIM_CallHook, data, RH_CLOSEREQUEST])

EXCEPT

   coerceMethodA(cl, obj, [OM_DISPOSE])
   RETURN NIL

ENDPROC obj




PROC rendWinDispose(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
   DEF data:PTR TO rendwindata

   data := INST_DATA(cl,obj)


   IF data.rm
      AbortIO(data.rm)
      WaitIO(data.rm)
      CloseDevice(data.rm)
      FreeVec(data.rm.parameters)
      DeleteMsgPort(data.rm.replyport)
      DeleteIORequest(data.rm)
   ENDIF



ENDPROC doSuperMethodA(cl, obj, msg)


PROC rendWinSet(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO opset)
   DEF data:PTR TO rendwindata, tags:PTR TO tagitem, tag:PTR TO tagitem

   data := INST_DATA(cl,obj)

   tags := msg.attrlist
   WHILE tag := NextTagItem({tags})
      SELECT tag.tag

      ENDSELECT
   ENDWHILE

ENDPROC doSuperMethodA(cl, obj, msg)


PROC rendWinGet(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO opget)
   DEF data:PTR TO rendwindata

   data := INST_DATA(cl, obj)

   SELECT msg.attrid
   CASE MUIA_RendWin_IsRendWin ; PutLong(msg.storage, TRUE) ; RETURN MUI_TRUE
   ENDSELECT

ENDPROC doSuperMethodA(cl, obj, msg)

