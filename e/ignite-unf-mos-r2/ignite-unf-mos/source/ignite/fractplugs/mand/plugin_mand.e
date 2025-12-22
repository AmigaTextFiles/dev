OPT MORPHOS, PREPROCESS

-> plugin_mand.e

LIBRARY 'fract_mand.plugin', 1, 0, 'fract_mand.plugin by LS 2009' IS
fractCreateGUIClass

#ifdef DEBUG
   #define DEBUGF(str,...) DebugF(str,...)
#else
   #define DEBUGF(str,...)
#endif

MODULE 'mui/muicustomclass'
MODULE 'tools/installhook'
MODULE 'amigalib/boopsi'
MODULE 'amigalib/lists'

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

MODULE 'libraries/asl'

MODULE 'muimaster'
MODULE 'morphos/exec'

MODULE 'dos/dos'

MODULE 'other/ecode'

MODULE '*//fractmisc'
MODULE '*//mystring'
MODULE '*///jobdev/jobdefs'

MODULE '*//libs/codecache'

MODULE '*mand'


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
      MUIA_ObjectID, oid,\
      MUIA_String_Integer, contents,\
      MUIA_String_Accept, '0123456789',\
      End

CONST MAXFUNCNAME = 1024

OBJECT mand
   PRIVATE
   selfobj:PTR TO object
   codecachebase:LONG
   -> gadgets
   iterGad, treshGad
   cxValGad, cyValGad
   pModeGad, functionGad
   funcstrGad
   renderfunc
ENDOBJECT

OBJECT params
   iters:LONG, tresh:DOUBLE
   cxValue:DOUBLE, cyValue:DOUBLE
   pMode:LONG -> 0:mandel, 1:julia
   funcname[MAXFUNCNAME]:ARRAY
ENDOBJECT


#define CALLHOOKA(hook,obj,msg) callHookA(hook,obj,msg)
#define DOMETHODA(obj,msg) doMethodA(obj,msg)

PROC xget(obj, attr)
   DEF x=NIL
   GetAttr(attr,obj,{x})
ENDPROC x

PROC fractCreateGUIClass()
ENDPROC eMui_CreateCustomClass(librarybase,MUIC_Group,NIL,SIZEOF mand,{mandDispatcher})

PROC main()
   muimasterbase := OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN)
ENDPROC muimasterbase

PROC close()
   CloseLibrary(muimasterbase)
ENDPROC

PROC mandDispatcher(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)

   SELECT msg.methodid
   CASE MUIM_Fract_GetParams;  RETURN     mandGetParams(cl, obj, msg)
   CASE MUIM_Fract_SetParams;  RETURN     mandSetParams(cl, obj, msg)
   CASE MUIM_Fract_RenderDone ; RETURN mandRenderDone(cl, obj, msg)
   CASE OM_GET           ;  RETURN        mandGet(cl, obj, msg)
   CASE OM_NEW           ;  RETURN         mandNew(cl, obj, msg)
   CASE OM_DISPOSE       ;  RETURN     mandDispose(cl, obj, msg)
   ENDSELECT

ENDPROC doSuperMethodA(cl, obj, msg)



PROC mandGet(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO opget)
   DEF data:PTR TO mand

   data := INST_DATA(cl, obj)

   SELECT msg.attrid
   CASE MUIA_Fract_ParameterSize ; PutLong(msg.storage, SIZEOF params) ; RETURN TRUE
   CASE MUIA_Fract_Name          ; PutLong(msg.storage, 'Mandel/Julia example') ; RETURN TRUE
   CASE MUIA_Fract_RenderFunc    ; PutLong(msg.storage, data.renderfunc) ; RETURN TRUE
   ENDSELECT

ENDPROC doSuperMethodA(cl, obj, msg)


PROC mandNew(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO opset) HANDLE
   DEF data:PTR TO mand

   IFN (obj := doSuperMethodA(cl, obj, msg)) THEN RETURN 0

   data := INST_DATA(cl, obj)
   data.selfobj := obj

   data.codecachebase := OpenLibrary('PROGDIR:libs/codecache.library', 1)
   IFN data.codecachebase THEN Raise("LIB")

   IFN mandGUI(cl, obj, data) THEN Raise("GUI")

   data.renderfunc := eCodePPC({renderFunc})
   IFN data.renderfunc THEN Raise("ECOD")

EXCEPT

   coerceMethodA(cl, obj, [OM_DISPOSE])
   RETURN NIL

ENDPROC obj

PROC mandDispose(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
    DEF data:PTR TO mand

   data := INST_DATA(cl, obj)

   CloseLibrary(data.codecachebase)
   IF data.renderfunc THEN eCodeDispose(data.renderfunc)

ENDPROC doSuperMethodA(cl, obj, msg)

PROC mandRenderDone(cl, obj:PTR TO object, msg)
   DEF data:PTR TO mand, str[50]:STRING
   data := INST_DATA(cl, obj)

   -> here we may update som status in our mand-gui..


ENDPROC

PROC mandGetParams(cl, obj:PTR TO object, msg:PTR TO LONG)
   DEF data:PTR TO mand, v, r, t, params:PTR TO params, codecachebase

   data := INST_DATA(cl, obj)

   params := msg[1]

   params.iters := xget(data.iterGad, MUIA_String_Integer)


   params.tresh := getStringFloat(data.treshGad)

   params.cxValue := getStringFloat(data.cxValGad)

   params.cyValue := getStringFloat(data.cyValGad)

   params.pMode := xget(data.pModeGad, MUIA_Cycle_Active)

   codecachebase := data.codecachebase
   t := xget(data.funcstrGad, MUIA_String_Contents)
   IF StrCmp(t, params.funcname) = FALSE
      AstrCopy(params.funcname, t, MAXFUNCNAME)
      t := OpenCode(params.funcname)
      IF t = NIL THEN RETURN 'Error: could not open function'
      CloseCode(t)
   ENDIF

ENDPROC NIL

-> not used for now
PROC readFile(name) HANDLE
   DEF fh=NIL, mem=NIL, fib:fileinfoblock
   fh := Open(name, OLDFILE)
   IF fh = NIL THEN Raise("OPEN")
   IF ExamineFH(fh, fib) = NIL THEN Raise("EXAM")
   mem := NewR(fib.size)
   IF Read(fh, mem, fib.size) <> fib.size THEN Raise("READ")
EXCEPT DO
   IF fh THEN Close(fh)
   IF exception
      IF mem THEN Dispose(mem)
      RETURN NIL, exception
   ENDIF
ENDPROC mem, NIL

PROC mandSetParams(cl, obj:PTR TO object, msg:PTR TO LONG)
   DEF data:PTR TO mand, v, r, t, params:PTR TO params

   data := INST_DATA(cl, obj)

   params := msg[1]

   set(data.iterGad, MUIA_String_Integer, params.iters)
   setStringFloat(data.treshGad, params.tresh)
   setStringFloat(data.cxValGad, params.cxValue)
   setStringFloat(data.cyValGad, params.cyValue)
   set(data.pModeGad, MUIA_Cycle_Active, params.pMode)
   set(data.funcstrGad, MUIA_String_Contents, params.funcname)

ENDPROC

-> invoked by subtask !
PROC renderFunc(rm:PTR TO rendermsg)
   DEF data:PTR TO mand
   DEF x, y, fx:REAL, fy:REAL, fxc:REAL, fyc:REAL
   DEF stat="DONE"
   DEF maxofwh:REAL
   DEF wmul:REAL, hmul:REAL
   DEF zoneCenterX:REAL, zoneCenterY:REAL, zoneRadius:REAL
   DEF params:PTR TO params
   DEF return:rgbstruct, redraw:PTR TO redrawmsg
   DEF yto, xto, _fdwidth_1:REAL, _fdheight_1:REAL
   DEF rgb:PTR TO CHAR
   DEF codecachebase
   DEF mandfunc(REAL,REAL,REAL,REAL,REAL,LONG,PTR)
   DEF plotrgbfunc(PTR,LONG,LONG,REAL,REAL,REAL)
   DEF miscfunc(PTR, LONG, LONG,LONG,LONG)

   DEBUGF('renderFunc($\h) MAND\n', rm)

   data := INST_DATA(rm.object[-1].class, rm.object)

   miscfunc := rm.miscfunc

   PushStatusTxt(rm, 'Rendering..')

   params := rm.parameters

   -> quicker access
   zoneCenterX := rm.zone.x
   zoneCenterY := rm.zone.y
   zoneRadius := rm.zone.r

   -> precalculate
   maxofwh := Max(rm.display.width, rm.display.height) !
   hmul := ! maxofwh / (rm.display.width!) * zoneRadius * 2.0
   wmul := ! maxofwh / (rm.display.height!) * zoneRadius * 2.0
   _fdwidth_1 :=  ! 1.0 / (rm.display.width-1!)
   _fdheight_1 := ! 1.0 / (rm.display.height-1!)

   plotrgbfunc := rm.plotrgbfunc

   codecachebase := data.codecachebase
   mandfunc := OpenCode(params.funcname)
   IFN mandfunc THEN RETURN NIL -> should not happen

   DEBUGF('renderFunc() opended code = $\h\n', rm, mandfunc)

   redraw := rm.redraw
   WHILE redraw -> we might have several areas to draw !
      DEBUGF('mandRender() redrawing agrea l:\d t:\d w:\d h:\d\n',
      redraw.left, redraw.top, redraw.width, redraw.height)

      -> precalculate
      yto := redraw.top + redraw.height-1
      xto := redraw.left + redraw.width-1

      FOR y := redraw.top TO yto
         fy := y!*_fdheight_1-0.5*hmul+zoneCenterY
         FOR x := redraw.left TO xto
            fx := x!*_fdwidth_1-0.5*wmul+zoneCenterX

            SELECT params.pMode
            CASE 0 -> mandel
               fxc := fx
               fyc := fy
            CASE 1 -> julia
               fxc := params.cxValue
               fyc := params.cyValue
            CASE 2 -> mandel Z0
               fxc := fx
               fyc := fy
               fx := 0.0
               fy := 0.0
            ENDSELECT

            mandfunc(fx,fy,fxc,fyc,params.tresh,params.iters,return)

            plotrgbfunc(rm, x, y, return.r, return.g, return.b)

         ENDFOR
         IF rm.job.break
            IF rm.job.break AND JMBREAKF_ABORT
               stat := "ABOR"
            ELSEIF rm.job.break AND JMBREAKF_STOP
               stat := "STOP"
            ENDIF
         ENDIF
         EXIT stat <> "DONE"
         IF Mod(y, redraw.height/100) = NIL
            PushGauge(rm, Percent(redraw.height, y))
         ENDIF
         PushRedrawRegion(rm, [NIL,redraw.left, y, redraw.width, 1,NIL])
      ENDFOR
      EXIT stat <> "DONE"
      redraw := redraw.next
   ENDWHILE

   SELECT stat
   CASE "ABOR"  ;
   CASE "STOP"  ; PushStatusTxt(rm, STATUSTXT_STOPPED)
                ; ->PushRedraw(rm)
   CASE "DONE"  ; PushRedraw(rm)
                ; PushStatusTxt(rm, STATUSTXT_DONE)
                ; PushGauge(rm, 100)
                ; PushRenderDone(rm)
   DEFAULT      ; PushStatusTxt(rm, '???')
   ENDSELECT

   CloseCode(mandfunc)

   DEBUGF('renderFunc() DONE\n')


ENDPROC



#define CycleID(entries,id) CycleObject, MUIA_ObjectID, id, MUIA_Font, MUIV_Font_Button, MUIA_Cycle_Entries, entries, End

PROC slimButton(name) IS
   TextObject,
      ButtonFrame,
      MUIA_Font, MUIV_Font_Button,
      MUIA_Text_Contents, name,
      MUIA_Text_PreParse, '\ec',
      MUIA_InputMode    , MUIV_InputMode_RelVerify,
      MUIA_Background   , MUII_ButtonBack,
      MUIA_Weight, 1,
      End

PROC mandGUI(cl, obj:PTR TO object, data:PTR TO mand) HANDLE
   DEF group=NIL

   group := VGroup,
      Child, ColGroup(2),
         Child, Label1('Iters:'),
         Child, data.iterGad := IString_(16,16,"ITER"),
         Child, Label1('Tresh:'),
         Child, data.treshGad := floatStringObject(6.0,"TRSH"),
         Child, Label1('Cx:'),
         Child, data.cxValGad := floatStringObject(3.5,"CxV"),
         Child, Label1('Cy:'),
         Child, data.cyValGad := floatStringObject(2.8,"CyV"),
         Child, Label1('PMode:'),
         Child, data.pModeGad := CycleID(['Mandel', 'Julia', 'Mandel Z0', NIL], "PMOD"),
         Child, Label1('Func:'),
         Child, PopaslObject,
                MUIA_Popasl_Type, ASL_FILEREQUEST,
                MUIA_Popstring_String, data.funcstrGad := StringObject,
                                    StringFrame,
                                    MUIA_String_MaxLen, 512,
                                    MUIA_String_Contents, 'fractplugs/mand/functions/',
                                    MUIA_ObjectID, "FUNC",
                                    MUIA_String_Format, MUIV_String_Format_Left,
                                    End,
                MUIA_Popstring_Button, PopButton(MUII_PopFile),
                ASLFR_TITLETEXT, 'Select function..',
         End,
      End,
   End

   IFN group THEN Raise("GRP")

   DOMETHODA(obj, [OM_ADDMEMBER, group])

EXCEPT

   RETURN NIL

ENDPROC obj



