OPT MODULE, PREPROCESS

->MODULE '*modules'

MODULE '*mainmisc'
MODULE '*fractmisc'
MODULE '*/jobdev/jobdefs'
MODULE '*zonegroup'
MODULE '*zoneview'

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
MODULE 'exec/io'
MODULE 'exec/nodes'
MODULE 'exec/ports'

MODULE 'muimaster'
MODULE 'utility'

MODULE 'mui/muicustomclass'
MODULE 'tools/installhook'
MODULE 'amigalib/boopsi'
MODULE 'amigalib/lists'

MODULE 'exec/memory'



#ifdef DEBUG
   #define DEBUGF(str,...) DebugF(str,...)
#else
   #define DEBUGF(str,...)
#endif

CONST ZONEBUFSIZE = 100

OBJECT dispwindata OF hook
   ignitehook:PTR TO hook
   selfobj:PTR TO object
   zoneviewmcc:PTR TO mui_customclass
   zoneviewobj:PTR TO object
   zonegroupmcc:PTR TO mui_customclass
   zonegroupobj:PTR TO object
   rm:PTR TO rendermsg
   zoneBuf[ZONEBUFSIZE]:ARRAY OF zone
   currZone:PTR TO zone
ENDOBJECT


-> the only exported item
EXPORT PROC createDispWinClass()
ENDPROC eMui_CreateCustomClass(NIL,MUIC_Window,NIL,SIZEOF dispwindata,{dispWinDispatcher})


PROC dispWinDispatcher(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)

   ->DEBUGF('dispWinDispatcher(): $\h\n', msg.methodid)

   SELECT msg.methodid
   CASE MUIM_DispWin_Render ; RETURN dispWinRender(cl, obj, msg)
   CASE MUIM_DispWin_StopRender ; RETURN dispWinStopRender(cl, obj, msg)
   CASE OM_NEW            ; RETURN dispWinNew(cl, obj, msg)
   CASE OM_DISPOSE        ; RETURN dispWinDispose(cl, obj, msg)
   CASE OM_SET            ; RETURN dispWinSet(cl, obj, msg)
   CASE OM_GET            ; RETURN dispWinGet(cl, obj, msg)
   CASE MUIM_Setup        ; RETURN dispwinSetup(cl, obj, msg)
   CASE MUIM_Cleanup      ; RETURN dispwinCleanup(cl, obj, msg)
   ENDSELECT

ENDPROC doSuperMethodA(cl, obj, msg)

-> called from ignite when user hits render button
PROC dispWinRender(cl, obj:PTR TO object, msg)
   DEF data:PTR TO dispwindata, err

   data := INST_DATA(cl, obj)

   DEBUGF('dispWinRender()\n')

   err := DOMETHODA(data.rm.object, [MUIM_Fract_GetParams, data.rm.parameters])
   IF err THEN RETURN err

   ABORTRMSG(data.rm)
   WAITRMSG(data.rm)
   data.rm.redraw := [NIL,0,0,data.rm.display.width,data.rm.display.height,NIL]:redrawmsg
   data.rm.zone := data.currZone
   SENDRMSG(data.rm)

ENDPROC NIL

PROC dispWinStopRender(cl, obj, msg)
   DEF data:PTR TO dispwindata

   DEBUGF('dispWinStopRender()\n')

   data := INST_DATA(cl, obj)

   STOPRMSG(data.rm)

ENDPROC

PROC initZoneBuffer(data:PTR TO dispwindata)
   DEF a, zone:PTR TO zone

   zone := data.zoneBuf
   FOR a := 0 TO ZONEBUFSIZE-2 DO zone[a].next :=  zone[a] + SIZEOF zone
   zone := data.zoneBuf
   FOR a := 1 TO ZONEBUFSIZE-1 DO zone[a].prev :=  zone[a] - SIZEOF zone

   zone := data.zoneBuf
   zone.prev := zone[ZONEBUFSIZE-1]

   zone := zone.prev
   zone.next := zone[0-ZONEBUFSIZE+1]

   data.currZone := data.zoneBuf

ENDPROC

PROC doSuperNewA(cl, obj, tags) IS doSuperMethodA(cl, obj, [OM_NEW, tags, NIL])

PROC dispWinNew(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO opnew) HANDLE
   DEF data:PTR TO dispwindata, gr=NIL, gr2=NIL, tags:PTR TO tagitem, tag:PTR TO tagitem


   DEBUGF('dispWinNew doSuperMethodA()\n')

   IF (obj := doSuperNewA(cl, obj,
   [MUIA_Window_RootObject, gr := VGroup, End,
    TAG_MORE, msg.attrlist,
    NIL])) = NIL THEN (IF gr THEN Mui_DisposeObject(gr)) BUT RETURN NIL

   DEBUGF('dispWinNew doSuperMethodA() DONE\n')

   data := INST_DATA(cl, obj)
   data.selfobj := obj

   data.zonegroupmcc := createZonegroupClass()
   IF data.zonegroupmcc = NIL THEN Raise("ZGMC")

   data.zoneviewmcc := createZoneviewClass()
   IF data.zoneviewmcc = NIL THEN Raise("ZVMC")

   installhook(data, {dispWinActionHandler})

   tags := msg.attrlist

   DEBUGF('dispWinNew getting args..tags=$\h\nitem0=[$\h,$\h], item1=[$\h,$\h]\n',
      tags, tags.tag, tags.data, tags[1].tag, tags[1].data)
   DEBUGF('utilitybase=$\h, tags=$\h\n', utilitybase, tags)

   data.ignitehook :=   GetTagData(MUIA_DispWin_IgniteHook, NIL, tags)
   DEBUGF('data.ignitehook=$\h\n', data.ignitehook)

   data.rm :=           GetTagData(MUIA_DispWin_RenderMsg, NIL, tags)
   DEBUGF('data.rm=$\h\n', data.rm)

   IF data.ignitehook = NIL THEN Raise("TAGS")
   IF data.rm = NIL THEN Raise("TAGS")

   DEBUGF('dispWinNew() got args, now to group\n')


   data.zonegroupobj := NewObjectA(data.zonegroupmcc.mcc_class,
                                       NIL,
                                       [MUIA_Zonegroup_ActionHook, data,
                                        NIL])

   IF data.zonegroupobj = NIL THEN Raise("ZGOB")

   data.zoneviewobj := NewObjectA(data.zoneviewmcc.mcc_class,
                                       NIL,
                                       [MUIA_Zoneview_ActionHook, data,
                                        MUIA_Frame, MUIV_Frame_InputList,
                                        MUIA_FillArea, FALSE,
                                        NIL])

   IF data.zoneviewobj = NIL THEN Mui_DisposeObject(data.zonegroupobj) BUT Raise("ZVOB")

   initZoneBuffer(data)

   DOMETHODA(data.zonegroupobj, [MUIM_Zonegroup_Get_Zone, data.currZone])

   DOMETHODA(gr, [OM_ADDMEMBER, data.zonegroupobj])
   DOMETHODA(gr, [OM_ADDMEMBER, data.zoneviewobj])

   DEBUGF('dispWinNew() group done, now to notifications\n')

   DOMETHODA(obj, [MUIM_Notify, MUIA_Window_CloseRequest, MUI_TRUE,
      obj, 3, MUIM_CallHook, data, AH_CLOSEREQUEST])

   data.rm.zoneviewobj := data.zoneviewobj
   data.rm.display := XGET(data.zoneviewobj, MUIA_Zoneview_Display)

   DEBUGF('dispWinNew() exiting\n')

EXCEPT

   SetIoErr(exception)
   coerceMethodA(cl, obj, [OM_DISPOSE])
   RETURN NIL

ENDPROC obj

PROC dispWinDispose(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
   DEF data:PTR TO dispwindata

   DEBUGF('dispWinDispose()\n')

   data := INST_DATA(cl,obj)

   IF data.rm
      ABORTRMSG(data.rm)
      WAITRMSG(data.rm)
      CloseDevice(data.rm)
      IF data.rm.parameters THEN FreeVec(data.rm.parameters)
      DeleteIORequest(data.rm)
   ENDIF

   IF data.zonegroupmcc THEN Mui_DeleteCustomClass(data.zonegroupmcc)
   IF data.zoneviewmcc THEN Mui_DeleteCustomClass(data.zoneviewmcc)

ENDPROC doSuperMethodA(cl, obj, msg)

PROC dispwinSetup(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg) HANDLE
   DEF data:PTR TO dispwindata

  IF doSuperMethodA(cl, obj, msg) = FALSE THEN RETURN FALSE

  data := INST_DATA(cl, obj)

  DEBUGF('dispwinSetup()\n')

EXCEPT

   SetIoErr(exception)
   coerceMethodA(cl, obj, [MUIM_Cleanup])
   RETURN NIL

ENDPROC MUI_TRUE

PROC dispwinCleanup(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
   DEF data:PTR TO dispwindata

   data := INST_DATA(cl, obj)

   DEBUGF('dispwinCleanup()\n')

ENDPROC doSuperMethodA(cl, obj, msg)

PROC dispWinSet(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO opset)
   DEF data:PTR TO dispwindata, tags:PTR TO tagitem, tag:PTR TO tagitem

   data := INST_DATA(cl,obj)

   DEBUGF('dispwinSet()\n')

   tags := msg.attrlist
   WHILE tag := NextTagItem({tags})
      SELECT tag.tag
      ENDSELECT
   ENDWHILE

ENDPROC doSuperMethodA(cl, obj, msg)


PROC dispWinGet(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO opget)
   DEF data:PTR TO dispwindata

   data := INST_DATA(cl, obj)

   DEBUGF('dispwinGet()\n')

   SELECT msg.attrid
   CASE MUIA_DispWin_IsDispWin ; PutLong(msg.storage, TRUE) ; RETURN MUI_TRUE
   CASE MUIA_DispWin_RenderMsg ; PutLong(msg.storage, data.rm) ; RETURN MUI_TRUE
   ENDSELECT

ENDPROC doSuperMethodA(cl, obj, msg)


PROC dispWinZoom(data:PTR TO dispwindata, disp:PTR TO display, selectX, selectY, mouseX, mouseY)
   DEF fpixel:DOUBLE, minDispRad, maxZoomRad
   DEF zoomCentX, zoomCentY
   DEF dispCentX, dispCentY
   DEF zone:PTR TO zone

   DEBUGF('dispWinZoom($\h, $\h, \d, \d, \d, \d)\n',
   data, disp, selectX, selectY, mouseX, mouseY)

   zone := data.currZone
   data.currZone := data.currZone.next

   fpixel := ! zone.r / (Min(disp.width, disp.height)!) * 2.0
   dispCentX := disp.width / 2
   dispCentY := disp.height / 2
   zoomCentX := selectX + mouseX / 2
   zoomCentY := selectY + mouseY / 2

   data.currZone.x := ! zone.x + (!fpixel * (zoomCentX-dispCentX!))
   data.currZone.y := ! zone.y + (!fpixel * (zoomCentY-dispCentY!))
   minDispRad := Min(disp.width, disp.height) / 2
   maxZoomRad := Max(Abs(mouseX-selectX), Abs(mouseY-selectY)) / 2
   data.currZone.r := ! zone.r * (maxZoomRad! / (minDispRad!))
   DOMETHODA(data.zonegroupobj, [MUIM_Zonegroup_Set_Zone, data.currZone])
   DOMETHODA(data.selfobj, [MUIM_DispWin_Render])
ENDPROC

PROC dispWinMove(data:PTR TO dispwindata, disp:PTR TO display, selectX, selectY, mouseX, mouseY)
   DEF fpixel:DOUBLE, zone:PTR TO zone

   DEBUGF('dispWinMove($\h, $\h, \d, \d, \d, \d)\n',
   data, disp, selectX, selectY, mouseX, mouseY)

   ABORTRMSG(data.rm)
   WAITRMSG(data.rm)

   zone := data.currZone
   data.currZone := data.currZone.next

   fpixel := ! zone.r / (Min(disp.width, disp.height)!) * 2.0

   data.currZone.x := ! zone.x - (!fpixel * (mouseX-selectX!))
   data.currZone.y := ! zone.y - (!fpixel * (mouseY-selectY!))
   data.currZone.r := zone.r

   DOMETHODA(data.zonegroupobj, [MUIM_Zonegroup_Set_Zone, data.currZone])
   DOMETHODA(data.rm.object, [MUIM_Fract_GetParams, data.rm.parameters])

   data.rm.zoneviewobj := data.zoneviewobj
   data.rm.display := disp

   -> under cxonstruction
   IF mouseX > selectX
      IF mouseY > selectY
         -> down-right
         data.rm.redraw := [NIL,
            0,
            0,
            mouseX-selectX,
            disp.height,
            [NIL,
            mouseX-selectX,
            0,
            disp.width-(mouseX-selectX),
            mouseY-selectY,
            NIL]]
      ELSE
         -> up-right
         data.rm.redraw := [NIL,
            0,
            0,
            mouseX-selectX,
            disp.height,
            [NIL,
            mouseX-selectX,
            disp.height-1-(selectY-mouseY),
            disp.width-(mouseX-selectX),
            selectY-mouseY,
            NIL]]
      ENDIF
   ELSE
      IF mouseY > selectY
         -> down-left
         data.rm.redraw := [NIL,
            0,
            0,
            disp.width,
            mouseY-selectY,
            [NIL,
            disp.width-1-(selectX-mouseX),
            mouseY-selectY,
            selectX-mouseX,
            disp.height-(mouseY-selectY),
            NIL]]
      ELSE
         -> up-left
         data.rm.redraw := [NIL,
            disp.width-1-(selectX-mouseX),
            0,
            selectX-mouseX,
            disp.height,
            [NIL,
            0,
            disp.height-1-(selectY-mouseY),
            disp.width-(selectX-mouseX),
            selectY-mouseY,
            NIL]]
      ENDIF
   ENDIF

   data.rm.zone := data.currZone
   SENDRMSG(data.rm)

ENDPROC



PROC dispWinActionHandler(data:PTR TO dispwindata, obj, msg:PTR TO LONG)
   DEF display:PTR TO display, oldzone:PTR TO zone

   DEBUGF('dispWinActionHandler() act=\d\n', msg[])

   SELECT msg[]++
   CASE AH_RENDER
      ABORTRMSG(data.rm)
      WAITRMSG(data.rm)
      data.rm.zoneviewobj := data.zoneviewobj
      display := msg[]
      data.rm.display := display
      data.rm.zone := data.currZone
      data.rm.redraw := [NIL,0,0,display.width,display.height,NIL]
      SENDRMSG(data.rm)
   CASE AH_ABORTRENDER
      ABORTRMSG(data.rm)
      WAITRMSG(data.rm)
   CASE AH_ZOOM
      dispWinZoom(data, msg[]++, msg[]++, msg[]++, msg[]++, msg[]++)
   CASE AH_MOVE
      dispWinMove(data, msg[]++, msg[]++, msg[]++, msg[]++, msg[]++)
   CASE AH_CLOSEREQUEST /* we call this ourselves threw notification */
      DEBUGF('AH_CLOSEREQUEST\n', msg[])
      ABORTRMSG(data.rm)
      WAITRMSG(data.rm)
      set(data.selfobj, MUIA_Window_Open, FALSE)
      DOMETHODA(_app(data.selfobj), [MUIM_Application_PushMethod, data.selfobj,
         3, MUIM_CallHook, data.ignitehook, IH_DELETEWIN])
   CASE AH_NEWZONE  /* zoneview,zonegroup calls these */
      data.currZone := data.currZone.next
      DOMETHODA(data.zonegroupobj, [MUIM_Zonegroup_Get_Zone, data.currZone])
      DOMETHODA(data.selfobj, [MUIM_DispWin_Render])
   CASE AH_PREVZONE
      data.currZone := data.currZone.prev
      DOMETHODA(data.zonegroupobj, [MUIM_Zonegroup_Set_Zone, data.currZone])
      DOMETHODA(data.selfobj, [MUIM_DispWin_Render])
   CASE AH_NEXTZONE
      data.currZone := data.currZone.next
      DOMETHODA(data.zonegroupobj, [MUIM_Zonegroup_Set_Zone, data.currZone])
      DOMETHODA(data.selfobj, [MUIM_DispWin_Render])
   CASE AH_SKIP_LEFT
      oldzone := data.currZone
      data.currZone := data.currZone.next
      data.currZone.x := ! oldzone.x - oldzone.r
      data.currZone.y := oldzone.y
      data.currZone.r := oldzone.r
      DOMETHODA(data.zonegroupobj, [MUIM_Zonegroup_Set_Zone, data.currZone])
      DOMETHODA(data.selfobj, [MUIM_DispWin_Render])
   CASE AH_SKIP_RIGHT
      oldzone := data.currZone
      data.currZone := data.currZone.next
      data.currZone.x := ! oldzone.x + oldzone.r
      data.currZone.y := oldzone.y
      data.currZone.r := oldzone.r
      DOMETHODA(data.zonegroupobj, [MUIM_Zonegroup_Set_Zone, data.currZone])
      DOMETHODA(data.selfobj, [MUIM_DispWin_Render])
   CASE AH_SKIP_UP
      oldzone := data.currZone
      data.currZone := data.currZone.next
      data.currZone.y := ! oldzone.y - oldzone.r
      data.currZone.x := oldzone.x
      data.currZone.r := oldzone.r
      DOMETHODA(data.zonegroupobj, [MUIM_Zonegroup_Set_Zone, data.currZone])
      DOMETHODA(data.selfobj, [MUIM_DispWin_Render])
   CASE AH_SKIP_DOWN
      oldzone := data.currZone
      data.currZone := data.currZone.next
      data.currZone.y := ! oldzone.y + oldzone.r
      data.currZone.x := oldzone.x
      data.currZone.r := oldzone.r
      DOMETHODA(data.zonegroupobj, [MUIM_Zonegroup_Set_Zone, data.currZone])
      DOMETHODA(data.selfobj, [MUIM_DispWin_Render])
   CASE AH_SKIP_IN
      oldzone := data.currZone
      data.currZone := data.currZone.next
      data.currZone.x := ! oldzone.x
      data.currZone.y := oldzone.y
      data.currZone.r := ! oldzone.r * 0.5
      DOMETHODA(data.zonegroupobj, [MUIM_Zonegroup_Set_Zone, data.currZone])
      DOMETHODA(data.selfobj, [MUIM_DispWin_Render])
   CASE AH_SKIP_OUT
      oldzone := data.currZone
      data.currZone := data.currZone.next
      data.currZone.x := ! oldzone.x
      data.currZone.y := oldzone.y
      data.currZone.r := ! oldzone.r * 2.0
      DOMETHODA(data.zonegroupobj, [MUIM_Zonegroup_Set_Zone, data.currZone])
      DOMETHODA(data.selfobj, [MUIM_DispWin_Render])
   ENDSELECT
   DEBUGF('dispWinActionHandler() DONE\n')
ENDPROC












