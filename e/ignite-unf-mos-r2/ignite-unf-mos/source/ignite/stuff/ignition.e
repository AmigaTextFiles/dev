
-> FlameThrower.e
-> requires MorphOS + ECX

OPT POWERPC

OPT PREPROCESS

OPT NODEFMODS

MODULE 'morphos/exec', 'morphos/dos', 'morphos/graphics', 'morphos/intuition'

MODULE 'muimaster'
MODULE 'libraries/mui'
MODULE 'libraries/muip'
MODULE 'muiabox/muicustomclass'
MODULE 'intuition/classes'
MODULE 'intuition/classusr'
MODULE 'intuition/screens'
MODULE 'intuition/intuition'
MODULE 'utility'
MODULE 'utility/tagitem'
MODULE 'utility/hooks'
MODULE 'aboxlib/boopsi'
MODULE 'aboxlib/lists'
MODULE 'exec/lists'
MODULE 'exec/nodes'
MODULE 'exec/ports'
MODULE 'exec/tasks'
MODULE 'exec/memory'
MODULE 'dos/dos'
MODULE 'toolsabox/installhook'
MODULE 'toolsabox/thread'
MODULE 'graphics/gfx'

MODULE 'graphics/rastport'

->MODULE '*macros'

->MODULE 'graphics/modeid'
MODULE 'intuition/intuitionbase'->,'intuition/intuition','intuition/screens'
MODULE 'utility/tagitem'

MODULE 'morphos/cybergfx'

OBJECT point
   x:INT, y:INT, z:INT -> +-32000. >+-32000 is out of range
ENDOBJECT

OBJECT flamedata
   application:PTR TO object
   self:PTR TO object
   gauge:PTR TO object
   status:PTR TO object
   replyPort:PTR TO mp
   subPort:PTR TO mp
   rastPort:rastport
   width:INT, height:INT
   prevX:LONG     -> float
   prevY:LONG     -> float
   maxPoints:LONG     -> maximum # of points to plot
   calcPointsDone:LONG
   rendPointsDone:LONG
   flameLevel:LONG -> iterate atleast this # of times
   flameVals[24]:ARRAY OF LONG
   bgColour:LONG -> ARGB
   stopCalculating:INT -> calculation polls this.
   stopRendering:INT -> renderer polls this
   isCalculating:INT -> TRUE/FALSE
   isRendering:INT -> TRUE / FALSE
   calcStack:LONG, calcStackSize:LONG
   pointsBuf:PTR TO point
   doZ:LONG -> bool, not used yet
   alternate:LONG ->
ENDOBJECT

OBJECT calcdata
   appobj:PTR TO object
   selfobj:PTR TO object
   flameobj:PTR TO object
   maxPoints:LONG
   pointsDone:LONG
   flameLevel:LONG
   flameVals[24]:ARRAY OF LONG
   stopCalc:INT
   isCalculating:INT
   doZangle:INT
   doAlternate:INT
   pointsBuf:PTR TO point
   calcStack, calcStackSize
   inputGads[24]:ARRAY OF LONG
   flameLevelGad:PTR TO object
   maxPointsGad:PTR TO object
   -> MUIA_Calc_IsBusy
   -> MUIM_Calc_Calculate
   -> MUIA_Calc_PointData
   -> MUIA_Calc_DataSize
   -> MUIM_Calc_Stop
ENDOBJECT

OBJECT renddata
   appobj:PTR TO object
   selfobj:PTR TO object
   flameobj:PTR TO object
   rastPort:PTR TO rastport
   pointsDone:LONG
   bgColour:LONG
   stopRend:INT
   isRendering:INT
   -> MUIA_Rend_IsBusy
   -> MUIM_Rend_Render
   -> MUIM_Rend_Stop
ENDOBJECT


OBJECT subMsg OF mn
   action
ENDOBJECT

->DEF alternate

DEF inputGads[12]:ARRAY OF LONG
DEF flameLevelGad, maxPointsGad
DEF poppenColBack, rColCycle, gColCycle, bColCycle

ENUM MUIM_Flame_Redraw = $88880000,
     MUIM_Flame_PushGauge,
     MUIM_Flame_PushStatusTxt

#define appMethod(obj,...) doMethodA(data.application, [MUIM_Application_PushMethod, obj,...])

#define Percent(max,val) (100.0 / ((max) ! / (val!)) !)

PROC recurse(data:PTR TO flamedata, x,y,z, level)
   DEF f:PTR TO LONG, v
   DEF nx,ny,nz, point:PTR TO point

   IF data.stopCalculating
      data.stopCalculating := FALSE
      RETURN "STOP"
   ENDIF

   IF R1 < (data.calcStack + 4000) THEN RETURN "STCK"

   f := data.flameVals

   IF data.calcPointsDone >= data.maxPoints THEN RETURN "DONE"

   IF level >= data.flameLevel

      IF Mod(data.calcPointsDone, data.maxPoints/100) = NIL
         doMethodA(data.self, [MUIM_Flame_PushGauge,
          Percent(data.maxPoints, data.calcPointsDone)])
      ENDIF

      point := data.pointsBuf[data.calcPointsDone++]

      point.x := ! x * 32000.0 !
      IF point.x < -32000
         point.x := -32001
      ELSEIF point.x > 32000
         point.x := 32001
      ENDIF
      point.y := ! y * 32000.0 !
      IF point.y < -32000
         point.y := -32001
      ELSEIF point.y > 32000
         point.y := 32001
      ENDIF
      point.z := ! z * 32000.0 !
      IF point.z < -32000
         point.z := -32001
      ELSEIF point.z > 32000
         point.z := 32001
      ENDIF

   ELSE

      IF data.doZ
         nx:=!(!f[]++*x)+(!f[]++*y)+(!f[]++*z)+f[]++
         ny:=!(!f[]++*x)+(!f[]++*y)+(!f[]++*z)+f[]++
         nz:=!(!f[]++*x)+(!f[]++*y)+(!f[]++*z)+f[]++
      ELSE
         nx:=!(!f[]++*x)+(!f[]++*y)+f[]++
         ny:=!(!f[]++*x)+(!f[]++*y)+f[]++
      ENDIF

      IF data.alternate
         nx:=Fsin(nx)
         ny:=Fsin(ny)
      ENDIF

      v := recurse(data,nx,ny,nz,level+1)
      IF v THEN RETURN v

      IF data.doZ
         nx:=!(!f[]++*x)+(!f[]++*y)+(!f[]++*z)+f[]++
         ny:=!(!f[]++*x)+(!f[]++*y)+(!f[]++*z)+f[]++
         nz:=!(!f[]++*x)+(!f[]++*y)+(!f[]++*z)+f[]++
      ELSE
         nx:=!(!f[]++*x)+(!f[]++*y)+f[]++
         ny:=!(!f[]++*x)+(!f[]++*y)+f[]++
      ENDIF

      IF data.alternate
         nx:=Fsin(nx)
         ny:=Fsin(ny)
      ENDIF

      v := recurse(data,nx,ny,nz,level+1)
      IF v THEN RETURN v

   ENDIF

ENDPROC NIL

-> render flamefractal into offscreen rastport/bitmap
-> colouring todo
PROC render(data:PTR TO flamedata)
   DEF point:REG PTR TO point, num:REG
   DEF midx:REG, midy:REG, halfw, halfh, divx:REG, divy:REG

   FillPixelArray(data.rastPort, 0, 0, data.width, data.height, data.bgColour)

   halfw := data.width / 2
   halfh := data.height / 2

   midx := halfw + 1
   midy := halfh + 1

   divx := 32000 / halfw
   divy := 32000 / halfh

   point := data.pointsBuf
   num := data.calcPointsDone + 1
   data.rendPointsDone := 0

   WHILE num--
      ->IF point.x >= -32000
      ->   IF point.x <= 32000
      ->      IF point.y >= -32000
      ->         IF point.y <= 32000
                  WriteRGBPixel(data.rastPort,
                                point.x / divx + midx,
                                point.y / divy + midy,
                                $FFFFFFFF)
      ->         ENDIF
      ->      ENDIF
      ->   ENDIF
      ->ENDIF
      data.rendPointsDone++
      point++
      IF Mod(data.rendPointsDone, data.maxPoints/100) = NIL
         doMethodA(data.self, [MUIM_Flame_PushGauge,
         Percent(data.maxPoints, data.rendPointsDone)])
      ENDIF
      IF data.stopRendering
         data.stopRendering := FALSE
         RETURN "STOP"
      ENDIF
   ENDWHILE

ENDPROC "DONE"

ENUM SUBMSG_NONE, SUBMSG_CALCULATE, SUBMSG_RENDER, SUBMSG_SYNC, SUBMSG_DIE

PROC doSubMessage(data:PTR TO flamedata, command)
   DEF msg:subMsg
   msg.ln.succ := NIL
   msg.ln.pred := NIL
   msg.ln.type := NT_MESSAGE
   msg.ln.pri := 0
   msg.ln.name := ''
   msg.replyport := data.replyPort
   msg.length := SIZEOF subMsg
   msg.action := command
   PutMsg(data.subPort, msg)
   WaitPort(data.replyPort)
   GetMsg(data.replyPort)
ENDPROC

PROC calcCalculate(data:PTR TO flamedata, msg)
   DEF sss:stackswapstruct, r
   data.stopCalculating := FALSE
   data.calcPointsDone := 0
   data.isCalculating := TRUE
   ReplyMsg(msg)
   sss.lower := data.calcStack
   sss.upper := data.calcStack + data.calcStackSize
   sss.pointer := data.calcStack + data.calcStackSize
   r := NewPPCStackSwap(sss, {recurse}, [data,0.0,0.0,0,0,0,0,0])
   SELECT r
   CASE "STOP"  ; doMethodA(data.self, [MUIM_Flame_PushStatusTxt, 'Stopped.'])
   CASE "STCK"  ; doMethodA(data.self, [MUIM_Flame_PushStatusTxt, 'Out of stack!'])
   CASE "DONE"  ; doMethodA(data.self, [MUIM_Flame_PushStatusTxt, 'Done.'])
   CASE NIL     ; doMethodA(data.self, [MUIM_Flame_PushStatusTxt, 'Too low flame level.'])
   DEFAULT      ; doMethodA(data.self, [MUIM_Flame_PushStatusTxt, '???'])
   ENDSELECT
   doMethodA(data.self, [MUIM_Flame_PushGauge, Percent(data.maxPoints, data.calcPointsDone)])
   data.isCalculating := FALSE
ENDPROC

PROC rendRender(data:PTR TO flamedata, msg)
   DEF r
   data.isRendering := TRUE
   data.stopRendering := FALSE
   ReplyMsg(msg)
   r := render(data)
   SELECT r
   CASE "STOP" ; doMethodA(data.self, [MUIM_Flame_PushStatusTxt, 'Stopped.'])
   CASE "DONE" ; doMethodA(data.self, [MUIM_Flame_PushStatusTxt, 'Done.'])
   DEFAULT     ; doMethodA(data.self, [MUIM_Flame_PushStatusTxt, '???'])
   ENDSELECT
   appMethod(data.self, 2, MUIM_Flame_Redraw, NIL)
   doMethodA(data.self, [MUIM_Flame_PushGauge, Percent(data.maxPoints, data.rendPointsDone)])
   data.isRendering := FALSE
ENDPROC

PROC subtask(private, data:PTR TO flamedata)
   DEF msg:PTR TO subMsg, cmnd, r

   ->WriteF('subtask init!\n')

   data.subPort := CreateMsgPort()

   IF data.subPort = NIL THEN RETURN "PORT"

   releaseSuccess(private)

   SetTaskPri(FindTask(NIL), -1)

   ->WriteF('subtask running!\n')

   LOOP
      WaitPort(data.subPort)
      WHILE (msg := GetMsg(data.subPort))
         cmnd := msg.action
         SELECT cmnd
         CASE SUBMSG_CALCULATE
            ->WriteF('SUBMSG_CALCULATE received!\n')
            doMethodA(data.self, [MUIM_Flame_PushStatusTxt, 'Calculating..'])
            doMethodA(data.self, [MUIM_Flame_PushGauge, 0])
            calcCalculate(data, msg)
         CASE SUBMSG_RENDER
            doMethodA(data.self, [MUIM_Flame_PushStatusTxt, 'Rendering..'])
            doMethodA(data.self, [MUIM_Flame_PushGauge, 0])
            rendRender(data, msg)
         CASE SUBMSG_SYNC
            ReplyMsg(msg)
         CASE SUBMSG_DIE
            ->WriteF('SUBMSG_DIE received!\n')
            DeleteMsgPort(data.subPort)
            data.subPort := NIL
            Forbid()
            ReplyMsg(msg)
            RETURN NIL
         ENDSELECT
      ENDWHILE
   ENDLOOP

ENDPROC NIL

->----------------------------------------------------------------------------<-

PROC flameAskMinMax(cl:PTR TO iclass,obj,msg:PTR TO muip_askminmax)

   ->->PutStr('mAskMinMax()\n')

   doSuperMethodA(cl,obj,msg)

   msg.minmaxinfo.minwidth := msg.minmaxinfo.minwidth + 100
   msg.minmaxinfo.defwidth := msg.minmaxinfo.defwidth + 600
   msg.minmaxinfo.maxwidth := msg.minmaxinfo.maxwidth + 1280

   msg.minmaxinfo.minheight := msg.minmaxinfo.minheight + 100
   msg.minmaxinfo.defheight := msg.minmaxinfo.defheight + 400
   msg.minmaxinfo.maxheight := msg.minmaxinfo.maxheight + 1024

ENDPROC 0


PROC flameNew(cl:PTR TO iclass, obj:PTR TO object, msg)
   DEF data:PTR TO flamedata, a

   IF (obj := doSuperMethodA(cl, obj, msg)) = NIL THEN RETURN 0

   data := INST_DATA(cl, obj)

   data.replyPort := CreateMsgPort()
   IF data.replyPort = NIL THEN RETURN NIL

   newProcess({subtask}, 0, 'subtask', data, NIL)
   IF data.subPort = NIL THEN RETURN NIL

   InitRastPort(data.rastPort)

ENDPROC obj


PROC flameDispose(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
   DEF data:PTR TO flamedata

   data := INST_DATA(cl, obj)

   data.stopCalculating := TRUE
   data.stopRendering := TRUE

   IF data.subPort
      doSubMessage(data, SUBMSG_DIE)
   ENDIF

   IF data.replyPort THEN DeleteMsgPort(data.replyPort)
   data.replyPort := NIL

   IF data.calcStack THEN FreeVec(data.calcStack)
   data.calcStack := NIL

   IF data.rastPort.bitmap THEN FreeBitMap(data.rastPort.bitmap)
   data.rastPort.bitmap := NIL

ENDPROC doSuperMethodA(cl, obj, msg)


PROC flameSetup(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
   DEF data:PTR TO flamedata

   ->PutStr('mSetup()\n')


ENDPROC MUI_TRUE


PROC flameCleanup(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
   DEF data:PTR TO flamedata

   ->PutStr('mCleanup()\n')

   data := INST_DATA(cl, obj)



ENDPROC doSuperMethodA(cl, obj, msg)


PROC flameShow(cl:PTR TO iclass, obj:PTR TO object, msg)
   DEF data:PTR TO flamedata, oldw, oldh

   ->PutStr('mShow()\n')

   data := INST_DATA(cl, obj)

   oldw := data.width
   oldh := data.height

   data.width := _mwidth(obj)
   data.height := _mheight(obj)

   IF data.rastPort.bitmap = NIL
      data.rastPort.bitmap := AllocBitMap(_mwidth(obj) + 2,_mheight(obj) + 2,24,BMF_CLEAR,_rp(obj).bitmap)
      IF data.rastPort.bitmap = NIL THEN RETURN NIL
   ELSEIF (data.width > oldw) OR (data.height > oldh)
      FreeBitMap(data.rastPort.bitmap)
      data.rastPort.bitmap := AllocBitMap(_mwidth(obj) + 2,_mheight(obj) + 2,24,BMF_CLEAR,_rp(obj).bitmap)
      IF data.rastPort.bitmap = NIL THEN RETURN NIL
      IF data.isRendering = FALSE THEN doSubMessage(data, SUBMSG_RENDER)
   ELSEIF (data.width < oldw) OR (data.height < oldh)
      IF data.isRendering = FALSE THEN doSubMessage(data, SUBMSG_RENDER)
   ENDIF

ENDPROC MUI_TRUE


PROC flameHide(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO muip_hide)
   DEF data:PTR TO flamedata

   ->PutStr('mHide()\n')

   data := INST_DATA(cl, obj)


ENDPROC MUI_TRUE


PROC flameDraw(cl:PTR TO iclass,obj:PTR TO flamedata,msg:PTR TO muip_draw)
   DEF data:PTR TO flamedata
   DEF rp, point:REG PTR TO point, num:REG
   DEF left, top, width, height
   DEF halfwidth:REG, halfheight:REG, xdiv:REG, ydiv:REG

   doSuperMethodA(cl, obj, msg)

   data := INST_DATA(cl, obj)


   IF msg.flags AND MADF_DRAWOBJECT

      BltBitMapRastPort(data.rastPort.bitmap,
                        1,
                        1,
                        _rp(obj),
                        _mleft(obj),
                        _mtop(obj),
                        _mwidth(obj),
                        _mheight(obj),
                        $C0)

   ELSEIF msg.flags AND MADF_DRAWUPDATE

      -> not used yet

   ENDIF




ENDPROC 0
-> msg[1] unused for now, keep NIL
PROC flameRedraw(cl, obj:PTR TO object, msg:PTR TO LONG)

   Mui_Redraw(obj, MADF_DRAWOBJECT)

ENDPROC

PROC flamePushGauge(cl, obj:PTR TO object, msg:PTR TO LONG)
   DEF data:PTR TO flamedata

   data := INST_DATA(cl, obj)

    -> msg[1] = 0-100 %
   doMethodA(data.application, [MUIM_Application_PushMethod, data.gauge, 3,
   MUIM_Set, MUIA_Gauge_Current, msg[1]])


ENDPROC

PROC flamePushStatusTxt(cl, obj:PTR TO object, msg:PTR TO LONG)
   DEF data:PTR TO flamedata

   data := INST_DATA(cl, obj)

   doMethodA(data.application, [MUIM_Application_PushMethod, data.status, 3,
   MUIM_Set, MUIA_Text_Contents, msg[1]])

ENDPROC


PROC flameDispatcher(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
   DEF mid

   ->PutStr('myDispatcher()\n')

   mid:=msg.methodid
   SELECT mid
   CASE MUIM_Flame_Redraw;  RETURN        flameRedraw(cl, obj, msg)
   CASE MUIM_Flame_PushGauge;  RETURN  flamePushGauge(cl, obj, msg)
   CASE MUIM_Flame_PushStatusTxt; RETURN  flamePushStatusTxt(cl, obj, msg)
   CASE MUIM_Draw        ;  RETURN        flameDraw(cl, obj, msg)
   CASE MUIM_Show        ;  RETURN        flameShow(cl, obj, msg)
   CASE MUIM_Hide        ;  RETURN        flameHide(cl, obj, msg)
   CASE MUIM_AskMinMax   ;  RETURN   flameAskMinMax(cl, obj, msg)
   CASE MUIM_Setup       ;  RETURN       flameSetup(cl, obj, msg)
   CASE MUIM_Cleanup     ;  RETURN     flameCleanup(cl, obj, msg)
   CASE OM_NEW           ;  RETURN         flameNew(cl, obj, msg)
   CASE OM_DISPOSE       ;  RETURN     flameDispose(cl, obj, msg)
   ENDSELECT

ENDPROC doSuperMethodA(cl, obj, msg)


ENUM ARG_BLA, NROFARGS

#define String_(contents,maxlen,oid)\
   StringObject,\
      StringFrame,\
      MUIA_String_MaxLen  , maxlen,\
      MUIA_String_Contents, contents,\
      MUIA_ObjectID, oid,\
      End

#define IString_(contents,maxlen,oid)\
   StringObject,\
      StringFrame,\
      MUIA_String_MaxLen  , maxlen,\
      MUIA_String_Contents, contents,\
      MUIA_ObjectID, oid,\
      MUIA_String_Integer, 0,\
      MUIA_String_Accept, '0123456789',\
      End

PROC main() HANDLE
   DEF window=NIL, application=NIL, flameobj, flamemcc=NIL:PTR TO mui_customclass
   DEF sigs=0, result, exit=FALSE, rdargs=NIL, args:PTR TO LONG, x, data:PTR TO flamedata
   DEF rendbut, stopbut, itstr, mpstr, rcycle, gauge
   DEF mhook:hook, status, calcbut

   NEW args[NROFARGS]

   rdargs := ReadArgs('BLA/S', args, NIL)
   IF rdargs = NIL THEN Raise("ARGS")

   muimasterbase := OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN)
   IF muimasterbase = NIL THEN Throw("LIB", 'muimaster.library')

   cybergfxbase := OpenLibrary('cybergraphics.library',41)
   IF cybergfxbase = NIL THEN Throw("LIB", 'cybergraphics.library')

   flamemcc := eMui_CreateCustomClass(NIL,MUIC_Area,NIL,SIZEOF flamedata,{flameDispatcher})
   IF flamemcc = NIL THEN Throw("MCC", 'flame')

   installhook(mhook, {mainHandler})

   application:=ApplicationObject,
      MUIA_Application_Title      , 'Ignition',
      MUIA_Application_Version    , '$VER: version',
      MUIA_Application_Copyright  , 'Copyright',
      MUIA_Application_Author     , 'Author',
      MUIA_Application_Description, 'Description',
      MUIA_Application_Base       , 'IGNITIONBASE',
   End

   IF application=NIL THEN Raise("APP")


   window := WindowObject,
      MUIA_Window_Title, 'IGNITION',
      MUIA_Window_ID   , "MAIN",
      WindowContents, VGroup,
         Child, VGroup,
            Child, flameobj := NewObjectA(flamemcc.mcc_class,NIL,
                             [MUIA_FillArea, FALSE,
                              MUIA_Frame, MUIV_Frame_Virtual,
                              NIL]),

            Child, BalanceObject, End,
            Child, RegisterObject,
               MUIA_Register_Titles, ['Calculate', 'Render', NIL],
               MUIA_Background, MUII_RegisterBack,
               MUIA_Weight, 10,
               Child, maingroup(),
               Child, coloursgroup(),
            End,
         End,
         Child, gauge := GaugeObject,
                  MUIA_VertWeight, 1,
                  MUIA_Gauge_Horiz, TRUE,
                  MUIA_Background, MUII_BACKGROUND,
                  MUIA_Gauge_Max, 100,
                  MUIA_Gauge_Current, 0,
         End,
         Child, HGroup,
            Child, Label1('Status:'),
            Child, status := TextObject,
                     MUIA_Frame, MUIV_Frame_Text,
                     MUIA_Background, MUII_TextBack,
                     MUIA_Text_PreParse, '\ec',
                     MUIA_Text_Contents, 'Welcome!',
                     MUIA_Weight, 200, End,
            Child, calcbut := SimpleButton('Calculate'),
            Child, rendbut := SimpleButton('Render'),
            Child, stopbut := SimpleButton('Stop'),
         End,
      End,
   End



   IF window = NIL THEN Raise("WIN")

   doMethodA(application, [OM_ADDMEMBER, window])

   doMethodA(window, [MUIM_Notify,MUIA_Window_CloseRequest, MUI_TRUE,
      application, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit])


   data := INST_DATA(flamemcc.mcc_class, flameobj)
   data.application := application
   data.self := flameobj
   data.gauge := gauge
   data.status := status

   ->doMethodA(flameobj, [MUIM_Notify,MUIA_Width, MUIV_EveryTime,
   ->   MUIV_Notify_Self, 1, MUIM_Flame_UpdateBitmap])

   ->doMethodA(flameobj, [MUIM_Notify,MUIA_Height, MUIV_EveryTime,
   ->   MUIV_Notify_Self, 1, MUIM_Flame_UpdateBitmap])


   doMethodA(calcbut, [MUIM_Notify,MUIA_Selected, FALSE,
      flameobj, 4, MUIM_CallHook, mhook, "CALC", data])

   doMethodA(rendbut, [MUIM_Notify,MUIA_Selected, FALSE,
      flameobj, 4, MUIM_CallHook, mhook, "REND", data])

   doMethodA(stopbut, [MUIM_Notify,MUIA_Selected, FALSE,
      flameobj, 4, MUIM_CallHook, mhook, "STOP", data])

   doMethodA(application, [MUIM_Application_Load, MUIV_Application_Load_ENVARC])

    ->WriteF('hejhej!\n')

   set(window, MUIA_Window_Open, MUI_TRUE)
   get(window, MUIA_Window_Open, {x})
   IF x = FALSE THEN Raise("OWIN")

   ->WriteF('hejhej2!\n')

   inputLoop(application)

   doMethodA(application, [MUIM_Application_Save, MUIV_Application_Save_ENVARC])

   set(window, MUIA_Window_Open, FALSE)

EXCEPT DO

   IF application THEN Mui_DisposeObject(application)
   IF flamemcc THEN Mui_DeleteCustomClass(flamemcc)
   IF muimasterbase THEN CloseLibrary(muimasterbase)
   IF cybergfxbase THEN CloseLibrary(cybergfxbase)
   IF rdargs THEN FreeArgs(rdargs)

   SELECT exception
   CASE "ARGS"  ; WriteF('error: args\n')
   CASE "LIB"   ; WriteF('error: open library: \s\n', exceptioninfo)
   CASE "WIN"   ; WriteF('error: create window\n')
   CASE "OWIN"  ; WriteF('error: open window\n')
   CASE "APP"   ; WriteF('error: create application\n')
   CASE "MCC"   ; WriteF('error: create custom class: \s\n', exceptioninfo)
   ENDSELECT

ENDPROC



PROC maingroup() IS
   ->ScrollgroupObject,
   VGroup,->   MUIA_ScrollGroup_Contents, VirtGroupObject,
         Child, HGroup,
            Child, Label1('A'), Child, inputGads[0] := String_('0.0', 256, "IPa"),
            Child, Label1('B'), Child, inputGads[1] := String_('0.0', 256, "IPb"),
            Child, Label1('C'), Child, inputGads[2] := String_('0.0', 256, "IPc"),
            Child, Label1('D'), Child, inputGads[3] := String_('0.0', 256, "IPd"),
            Child, Label1('E'), Child, inputGads[4] := String_('0.0', 256, "IPe"),
            Child, Label1('F'), Child, inputGads[5] := String_('0.0', 256, "IPf"),
         End,
         Child, HGroup,
            Child, Label1('G'), Child, inputGads[6] := String_('0.0', 256, "IPg"),
            Child, Label1('H'), Child, inputGads[7] := String_('0.0', 256, "IPh"),
            Child, Label1('I'), Child, inputGads[8] := String_('0.0', 256, "IPi"),
            Child, Label1('J'), Child, inputGads[9] := String_('0.0', 256, "IPj"),
            Child, Label1('K'), Child, inputGads[10] := String_('0.0', 256, "IPk"),
            Child, Label1('L'), Child, inputGads[11] := String_('0.0', 256, "IPl"),
         End,
         Child, HGroup,
            Child, Label1('FL:'),
            Child, flameLevelGad:= IString_('0', 256, "FL"),
            Child, Label1('MP:'),
            Child, maxPointsGad := IString_('0', 256, "MP"),
            Child, Label1('Alt:'),
            Child, Cycle(['None', 'Sin', 'Cos', 'Tan', NIL]),
         End,
      ->End,
   End



PROC coloursgroup() IS
   ->ScrollgroupObject,
   VGroup,->   MUIA_ScrollGroup_Contents, VirtGroupObject,
         Child, HGroup,
            Child, Label1('Background:'),
            Child, poppenColBack := PoppenObject, End,
            Child, RectangleObject, End,
            Child, Label1('Correct Aspect Ratio:'),
            Child, CheckMark(0),
         End,
         Child, HGroup,
            Child, Label1('R:'),
            Child, rColCycle := Cycle(['Random', 'X Speed', 'Y Speed', 'X-Y Speed', 'X+Y Speed', NIL]),
            Child, Label1('G:'),
            Child, gColCycle := Cycle(['Random', 'X Speed', 'Y Speed', 'X-Y Speed', 'X+Y Speed', NIL]),
            Child, Label1('B:'),
            Child, bColCycle := Cycle(['Random', 'X Speed', 'Y Speed', 'X-Y Speed', 'X+Y Speed', NIL]),
         End,
      ->End,
   End




PROC inputLoop(app)
   DEF sigs=NIL
   WHILE doMethodA(app,
      [MUIM_Application_NewInput,
      {sigs}]) <> MUIV_Application_ReturnID_Quit
      IF sigs THEN sigs := Wait(sigs OR SIGBREAKF_CTRL_C)
      EXIT sigs AND SIGBREAKF_CTRL_C
   ENDWHILE
ENDPROC

#define InputError(err) RETURN set(data.status, MUIA_Text_Contents, err)

PROC mainHandler(hook, obj:PTR TO object, msg:PTR TO LONG)
   DEF t, v, r, data:PTR TO flamedata
   t := msg[]
   data := msg[1]
   SELECT t
   CASE "CALC"

      data.stopCalculating := TRUE
      data.stopRendering := TRUE
      doSubMessage(data, SUBMSG_SYNC)

      v := xget(inputGads[0], MUIA_String_Contents)
      v, r := RealVal(v) ; IF r = NIL THEN InputError('Invalid "A" value')
      data.flameVals[0] := v
      v := xget(inputGads[1], MUIA_String_Contents)
      v, r := RealVal(v) ; IF r = NIL THEN InputError('Invalid "B" value')
      data.flameVals[1] := v
      v := xget(inputGads[2], MUIA_String_Contents)
      v, r := RealVal(v) ; IF r = NIL THEN InputError('Invalid "C" value')
      data.flameVals[2] := v
      v := xget(inputGads[3], MUIA_String_Contents)
      v, r := RealVal(v) ; IF r = NIL THEN InputError('Invalid "D" value')
      data.flameVals[3] := v
      v := xget(inputGads[4], MUIA_String_Contents)
      v, r := RealVal(v) ; IF r = NIL THEN InputError('Invalid "E" value')
      data.flameVals[4] := v
      v := xget(inputGads[5], MUIA_String_Contents)
      v, r := RealVal(v) ; IF r = NIL THEN InputError('Invalid "F" value')
      data.flameVals[5] := v
      v := xget(inputGads[6], MUIA_String_Contents)
      v, r := RealVal(v) ; IF r = NIL THEN InputError('Invalid "G" value')
      data.flameVals[6] := v
      v := xget(inputGads[7], MUIA_String_Contents)
      v, r := RealVal(v) ; IF r = NIL THEN InputError('Invalid "H" value')
      data.flameVals[7] := v
      v := xget(inputGads[8], MUIA_String_Contents)
      v, r := RealVal(v) ; IF r = NIL THEN InputError('Invalid "I" value')
      data.flameVals[8] := v
      v := xget(inputGads[9], MUIA_String_Contents)
      v, r := RealVal(v) ; IF r = NIL THEN InputError('Invalid "J" value')
      data.flameVals[9] := v
      v := xget(inputGads[10], MUIA_String_Contents)
      v, r := RealVal(v) ; IF r = NIL THEN InputError('Invalid "K" value')
      data.flameVals[10] := v
      v := xget(inputGads[11], MUIA_String_Contents)
      v, r := RealVal(v) ; IF r = NIL THEN InputError('Invalid "L" value')
      data.flameVals[11] := v


      v := xget(flameLevelGad, MUIA_String_Integer)
      IF v < 10 THEN InputError('Invalid "Flame level"')
      data.flameLevel := v

      v := xget(maxPointsGad, MUIA_String_Integer)
      IF v < 10 THEN InputError('Invalid "Max points"')
      IF v > data.maxPoints
         FreeVec(data.pointsBuf)
         data.pointsBuf := AllocVec(SIZEOF point * v, MEMF_PUBLIC)
         data.maxPoints := 0
         IF data.pointsBuf = NIL THEN InputError('Not enough memory.')
      ENDIF
      data.maxPoints := v

      IF data.calcStackSize < (data.flameLevel * 200 + 16000)
         IF data.calcStack THEN FreeVec(data.calcStack)
         data.calcStackSize := data.flameLevel * 200 + 16000 AND -16
         data.calcStack := AllocVec(data.calcStackSize, MEMF_PUBLIC)
         IF data.calcStack = NIL THEN InputError('Not enough memory.')
      ENDIF

      set(data.gauge, MUIA_Gauge_Current, 0)

      doSubMessage(data, SUBMSG_CALCULATE)

      doSubMessage(data, SUBMSG_RENDER)

   CASE "REND"

      IF data.isRendering THEN data.stopRendering := TRUE

      doSubMessage(data, SUBMSG_RENDER)

   CASE "STOP"

      IF data.isCalculating THEN data.stopCalculating := TRUE

      Mui_Redraw(obj, MADF_DRAWOBJECT)

   ENDSELECT

ENDPROC

PROC xget(obj,attr)
   DEF x
   get(obj,attr,{x})
ENDPROC x





