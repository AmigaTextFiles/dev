OPT MODULE, PREPROCESS

MODULE '*mainmisc'
MODULE '*fractmisc'
MODULE 'muimaster'
MODULE 'libraries/mui'

->MODULE '*modules'

MODULE 'libraries/muip'
MODULE 'utility'
MODULE 'graphics/gfx'
MODULE 'graphics/rastport'
MODULE 'mui/muicustomclass'
MODULE 'tools/installhook'
MODULE 'amigalib/boopsi'
MODULE 'amigalib/lists'
MODULE 'intuition/classes'

MODULE 'intuition/classusr'
MODULE 'utility/tagitem'
MODULE 'exec/memory'
MODULE 'intuition/intuition'
MODULE 'utility/hooks'

MODULE 'morphos/cybergraphics'
MODULE 'libraries/cybergraphics'

#ifdef DEBUG
   #define DEBUGF(str,...) DebugF(str,...)
#else
   #define DEBUGF(str,...)
#endif

-> New zoneview class

OBJECT zoneviewdata
   disp:display
   selfobj:PTR TO object
   selectX
   selectY
   mousePressed
   mouseOp
   mouseX
   mouseY
   ehn:mui_eventhandlernode
   actionhook:PTR TO hook
   redrawmsg:PTR TO redrawmsg
ENDOBJECT

EXPORT PROC createZoneviewClass()
ENDPROC eMui_CreateCustomClass(NIL,MUIC_Area,NIL,SIZEOF zoneviewdata,{zoneviewDispatcher})

PROC zoneviewDispatcher(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
   ->DEBUGF('zoneviewDispatcher() mid=$\h\n', msg.methodid)
   SELECT msg.methodid
   CASE MUIM_Zoneview_Redraw_Msg;   RETURN        zoneviewRedrawMsg(cl, obj, msg)
   CASE MUIM_HandleEvent          ;  RETURN       zoneviewHandleEvent(cl,obj,msg)
   CASE OM_GET           ; RETURN        zoneviewGet(cl, obj, msg)
   CASE MUIM_Draw        ;  RETURN        zoneviewDraw(cl, obj, msg)
   CASE MUIM_Show        ;  RETURN        zoneviewShow(cl, obj, msg)
   CASE MUIM_Hide        ;  RETURN        zoneviewHide(cl, obj, msg)
   CASE MUIM_AskMinMax   ;  RETURN   zoneviewAskMinMax(cl, obj, msg)
   CASE MUIM_Setup       ;  RETURN       zoneviewSetup(cl, obj, msg)
   CASE MUIM_Cleanup     ;  RETURN     zoneviewCleanup(cl, obj, msg)
   CASE OM_NEW           ;  RETURN         zoneviewNew(cl, obj, msg)
   CASE OM_DISPOSE       ;  RETURN     zoneviewDispose(cl, obj, msg)
   ENDSELECT

ENDPROC doSuperMethodA(cl, obj, msg)

PROC zoneviewAskMinMax(cl:PTR TO iclass,obj,msg:PTR TO muip_askminmax)

   doSuperMethodA(cl,obj,msg)

   msg.minmaxinfo.minwidth := msg.minmaxinfo.minwidth + 100
   msg.minmaxinfo.defwidth := msg.minmaxinfo.defwidth + 600
   msg.minmaxinfo.maxwidth := msg.minmaxinfo.maxwidth + 2048

   msg.minmaxinfo.minheight := msg.minmaxinfo.minheight + 100
   msg.minmaxinfo.defheight := msg.minmaxinfo.defheight + 400
   msg.minmaxinfo.maxheight := msg.minmaxinfo.maxheight + 2048

ENDPROC 0


PROC zoneviewNew(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO opset) HANDLE
   DEF data:PTR TO zoneviewdata, a, tag:PTR TO tagitem, tags
   DEBUGF('zoneviewNew()\n')
   IFN (obj := doSuperMethodA(cl, obj, msg)) THEN RETURN 0

   data := INST_DATA(cl, obj)
   data.selfobj := obj

   tags := msg.attrlist
   data.actionhook := GetTagData(MUIA_Zoneview_ActionHook, NIL, tags)
   IFN data.actionhook THEN Raise("TAGS")

EXCEPT

   SetIoErr(exception)
   coerceMethodA(cl, obj, [OM_DISPOSE])
   RETURN NIL

ENDPROC obj


PROC zoneviewDispose(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
   DEF data:PTR TO zoneviewdata

   data := INST_DATA(cl, obj)

   DEBUGF('zoneviewDispose()\n')

   IF data.disp.rendbuf THEN FreeVec(data.disp.rendbuf)


ENDPROC doSuperMethodA(cl, obj, msg)

PROC zoneviewSetup(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg) HANDLE
   DEF data:PTR TO zoneviewdata

  IF doSuperMethodA(cl, obj, msg) = FALSE THEN RETURN FALSE

  data := INST_DATA(cl, obj)

  DEBUGF('zoneviewSetup()\n')

  data.ehn.ehn_priority := 0
  data.ehn.ehn_flags := 0
  data.ehn.ehn_events := IDCMP_MOUSEBUTTONS ->OR IDCMP_MOUSEMOVE
  data.ehn.ehn_object := obj
  data.ehn.ehn_class := cl

  DOMETHODA(_win(obj), [MUIM_Window_AddEventHandler, data.ehn])

EXCEPT

   SetIoErr(exception)
   coerceMethodA(cl, obj, [MUIM_Cleanup])
   RETURN NIL

ENDPROC MUI_TRUE


PROC zoneviewCleanup(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
   DEF data:PTR TO zoneviewdata

   data := INST_DATA(cl, obj)

   DEBUGF('zoneviewCleanup()\n')

   DOMETHODA(_win(obj), [MUIM_Window_RemEventHandler, data.ehn])

ENDPROC doSuperMethodA(cl, obj, msg)


PROC zoneviewShow(cl:PTR TO iclass, obj:PTR TO object, msg)
   DEF data:PTR TO zoneviewdata, oldw, oldh

   data := INST_DATA(cl, obj)

   oldw := data.disp.width
   oldh := data.disp.height

   DEBUGF('zoneviewShow() oldw=\d, oldh=\d\n', oldw, oldh)

   data.disp.width := _mwidth(obj)
   data.disp.height := _mheight(obj)

   DEBUGF('   _mwidth=\d, _mheight=\d\n', data.disp.width, data.disp.height)

      ->DebugF('zoneviewShow() bitmap\n')

   ->DEBUGF('zoneviewShow() HALFWAY\n')


   IF data.disp.rendbuf = NIL
      data.disp.rendbuf := AllocVec(data.disp.width*data.disp.height*3, MEMF_CLEAR OR MEMF_PUBLIC)
      IF data.disp.rendbuf = NIL THEN RETURN NIL
   ELSEIF (data.disp.width > oldw) OR (data.disp.height > oldh)
      CALLHOOKA(data.actionhook, obj, [AH_ABORTRENDER])  -> abort possible render
      FreeVec(data.disp.rendbuf)
      data.disp.rendbuf := AllocVec(data.disp.width*data.disp.height*3, MEMF_CLEAR OR MEMF_PUBLIC)
      IF data.disp.rendbuf = NIL THEN RETURN NIL
      CALLHOOKA(data.actionhook, obj, [AH_RENDER, data])
   ELSEIF (data.disp.width < oldw) OR (data.disp.height < oldh)
      CALLHOOKA(data.actionhook, obj, [AH_RENDER, data])
   ENDIF

   DEBUGF('zoneviewShow() DONE\n')

ENDPROC MUI_TRUE


PROC zoneviewHide(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO muip_hide)
   DEF data:PTR TO zoneviewdata

   data := INST_DATA(cl, obj)

   DEBUGF('zoneviewHide()\n')

ENDPROC MUI_TRUE

ENUM MOUSEOP_NONE, MOUSEOP_MOVE, MOUSEOP_ZOOM, MOUSEOP_DONE

PROC zoneviewDraw(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_draw)
   DEF data:PTR TO zoneviewdata, redraw:PTR TO redrawmsg

   DEBUGF('zoneviewDraw()\n')

   doSuperMethodA(cl, obj, msg)

   data := INST_DATA(cl, obj)

   IF msg.flags AND MADF_DRAWOBJECT
      DEBUGF('   DRAWOBJECT\n')

      WritePixelArray(data.disp.rendbuf,
                      0,
                      0,
                      data.disp.width*3,
                      _rp(obj),
                      _mleft(obj),
                      _mtop(obj),
                      _mwidth(obj),
                      _mheight(obj),
                      RECTFMT_RGB)

   ELSEIF msg.flags AND MADF_DRAWUPDATE
      DEBUGF('   DRAWOBJECT\n')
      redraw := data.redrawmsg
      DEBUGF('   redraw = $\h\n', redraw)
      IF redraw THEN redraw.flags := redraw.flags OR RDF_BUSY

      WHILE redraw

         WritePixelArray(data.disp.rendbuf,
                      redraw.left,
                      redraw.top,
                      data.disp.width*3,
                      _rp(obj),
                      _mleft(obj) + redraw.left,
                      _mtop(obj) + redraw.top,
                      redraw.width,
                      redraw.height,
                      RECTFMT_RGB)

         redraw := redraw.next
      ENDWHILE

      IF data.redrawmsg
         data.redrawmsg.flags := data.redrawmsg.flags AND Not(RDF_BUSY)
         data.redrawmsg := NIL
      ENDIF

      IF data.mouseOp = MOUSEOP_MOVE
          DEBUGF('      drawing MOUSEOP_MOVE\n')

          WritePixelArray(data.disp.rendbuf,
                      Min(Max(data.selectX-data.mouseX, 0), data.disp.width-1),
                      Min(Max(data.selectY-data.mouseY, 0), data.disp.height-1),
                      data.disp.width*3,
                      _rp(obj),
                      _mleft(obj) + Min(Max(data.mouseX-data.selectX, 0), data.disp.width-1),
                      _mtop(obj) + Min(Max(data.mouseY-data.selectY, 0), data.disp.height-1),
                      data.disp.width - Min(Abs(data.mouseX-data.selectX), data.disp.width),
                      data.disp.height - Min(Abs(data.mouseY-data.selectY), data.disp.height),
                      RECTFMT_RGB)


      ELSEIF data.mouseOp = MOUSEOP_ZOOM

         DEBUGF('      drawing MOUSEOP_ZOOM\n')

          -> draw box
          SetAPen(_rp(obj), 3)
          Move(_rp(obj), _mleft(obj) + data.selectX, _mtop(obj) + data.selectY)
          PolyDraw(_rp(obj), 4, [_mleft(obj) + data.mouseX, _mtop(obj) + data.selectY,
                                 _mleft(obj) + data.mouseX, _mtop(obj) + data.mouseY,
                                 _mleft(obj) + data.selectX, _mtop(obj) + data.mouseY,
                                 _mleft(obj) + data.selectX, _mtop(obj) + data.selectY]:INT)

      ENDIF

   ENDIF

ENDPROC 0


PROC zoneviewGet(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO opget)
   DEF data:PTR TO zoneviewdata

   data := INST_DATA(cl, obj)

   DEBUGF('zoneviewGet()\n')

   SELECT msg.attrid
   CASE MUIA_Zoneview_Display ; PutLong(msg.storage, data.disp) ; RETURN MUI_TRUE
   ENDSELECT

ENDPROC doSuperMethodA(cl, obj, msg)


PROC zoneviewRedrawMsg(cl, obj, msg:PTR TO LONG)
   DEF data:PTR TO zoneviewdata
   data := INST_DATA(cl, obj)
   data.redrawmsg := msg[1]
   Mui_Redraw(obj, MADF_DRAWUPDATE)
ENDPROC

#define _between(a,x,b) ((x>=a) AND (x<=b))
#define _isinobject(x,y) (_between(_mleft(obj),x,_mright(obj)) AND _between(_mtop(obj),y,_bottom(obj)))

PROC zoneviewHandleEvent(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_handleevent)
   DEF class, code
   DEF r=NIL, data:PTR TO zoneviewdata
   DEF rc=NIL

   data := INST_DATA(cl, obj)

   IF msg.imsg

      class := msg.imsg.class
      code := msg.imsg.code
      SELECT class
      CASE IDCMP_RAWKEY

      CASE IDCMP_MOUSEBUTTONS
         ->->DebugF('MOUSEBUTTON: \d ', code)
         IF _isinobject(msg.imsg.mousex, msg.imsg.mousey)
            IF code = SELECTDOWN
               ->->DebugF('DOWN\n', code)
               IF data.mouseOp = MOUSEOP_ZOOM
                  CALLHOOKA(data.actionhook, obj,
                            [AH_ZOOM,
                             data,
                             data.selectX,
                             data.selectY,
                             data.mouseX,
                             data.mouseY
                            ]
                           )
                  data.selectX := NIL
                  data.selectY := NIL
                  data.mouseOp := MOUSEOP_DONE
               ELSE
                  data.mousePressed := TRUE
                  data.selectX := msg.imsg.mousex - _mleft(obj)
                  data.selectY := msg.imsg.mousey - _mtop(obj)
                  setIDCMP(data, data.ehn.ehn_events OR IDCMP_MOUSEMOVE)
               ENDIF
            ELSEIF code = SELECTUP
               ->->DebugF('UP\n', code)
               data.mousePressed := FALSE
               IF data.mouseOp = MOUSEOP_MOVE
                  ReadPixelArray(data.disp.rendbuf,
                                 0,
                                 0,
                                 data.disp.width*3,
                                 _rp(obj),
                                 _mleft(obj),
                                 _mtop(obj),
                                 data.disp.width,
                                 data.disp.height,
                                 RECTFMT_RGB)
                  CALLHOOKA(data.actionhook, obj,
                              [AH_MOVE,
                               data,
                               data.selectX,
                               data.selectY,
                               data.mouseX,
                               data.mouseY
                              ])
                  data.selectX := NIL
                  data.selectY := NIL
                  data.mouseX := NIL
                  data.mouseY := NIL
                  setIDCMP(data, data.ehn.ehn_events AND Not(IDCMP_MOUSEMOVE))
                  data.mouseOp := MOUSEOP_DONE
               ELSEIF data.mouseOp = MOUSEOP_DONE
                  data.mouseOp := MOUSEOP_NONE
               ELSEIF data.mouseOp = MOUSEOP_NONE
                  data.mouseOp := MOUSEOP_ZOOM
               ENDIF
            ENDIF
         ELSE
            data.mousePressed := FALSE
            IF data.mouseOp
               data.mouseOp := MOUSEOP_NONE
               data.selectX := NIL
               data.selectY := NIL
               Mui_Redraw(obj, MADF_DRAWOBJECT)
            ENDIF
            setIDCMP(data, data.ehn.ehn_events AND Not(IDCMP_MOUSEMOVE))
         ENDIF
         rc := NIL
      CASE IDCMP_MOUSEMOVE
         ->->DebugF('MOUSEMOVE: \d, \d\n', msg.imsg.mousex, msg.imsg.mousey)
         IF _isinobject(msg.imsg.mousex, msg.imsg.mousey)
            IF data.mousePressed
               data.mouseOp := MOUSEOP_MOVE
            ELSEIF data.mouseOp = MOUSEOP_ZOOM
               data.redrawmsg := [NIL,
                               Min(data.selectX, data.mouseX),
                               Min(data.selectY, data.mouseY),
                               Abs(data.selectX - data.mouseX),
                               Abs(data.selectY - data.mouseY),
                               NIL]:redrawmsg
            ENDIF
            IF data.mouseOp
               data.mouseX := msg.imsg.mousex - _mleft(obj)
               data.mouseY := msg.imsg.mousey - _mtop(obj)
               Mui_Redraw(obj, MADF_DRAWUPDATE)
            ENDIF
         ELSE
            data.mousePressed := FALSE
            data.mouseOp := MOUSEOP_NONE
            data.selectX := NIL
            data.selectY := NIL
            setIDCMP(data, data.ehn.ehn_events AND Not(IDCMP_MOUSEMOVE))
            Mui_Redraw(obj, MADF_DRAWOBJECT)
         ENDIF
      ENDSELECT

   ENDIF



ENDPROC rc

PROC setIDCMP(data:PTR TO zoneviewdata, idcmp)
  DEF oldidcmp
  DOMETHODA(_win(data.selfobj), [MUIM_Window_RemEventHandler, data.ehn])
  oldidcmp := data.ehn.ehn_events
  data.ehn.ehn_events := idcmp
  DOMETHODA(_win(data.selfobj), [MUIM_Window_AddEventHandler, data.ehn])
ENDPROC oldidcmp





