OPT MORPHOS, PREPROCESS

-> plugin_flame.e

LIBRARY 'fract_flame.plugin', 1, 0, 'fract_flame.plugin by LS 2009' IS
fractCreateGUIClass

-> ignite_flame.e

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

MODULE 'muimaster'
MODULE 'utility'

MODULE 'colorwheel'
MODULE 'gadgets/colorwheel'

MODULE 'exec/tasks'
MODULE 'exec/memory'

MODULE 'morphos/exec'

MODULE 'other/ecode'

MODULE '*//fractmisc'

MODULE '*//mystring'

MODULE '*///jobdev/jobdefs'

#ifdef DEBUG
   #define DEBUGF(str,...) DebugF(str,...)
#else
   #define DEBUGF(str,...)
#endif

OBJECT point
   x:INT, y:INT, z:INT
   count:LONG
   hnext:PTR TO point
ENDOBJECT

#define CALLHOOKA(hook,obj,msg) callHookA(hook,obj,msg)
#define DOMETHODA(obj,msg) doMethodA(obj,msg)

PROC xget(obj, attr)
   DEF x=NIL
   GetAttr(attr,obj,{x})
ENDPROC x

CONST RESOLUTION = 16000


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

CONST RANDOMSIZE=6

OBJECT recursedata
   x:DOUBLE, y:DOUBLE, z:DOUBLE
   level
ENDOBJECT

OBJECT flame
   PRIVATE
   selfobj:PTR TO object
   rm:PTR TO rendermsg
   pointsDone:LONG
   -> statistics
   maxCount:LONG
   maxLeft:DOUBLE, maxRight:DOUBLE, maxTop:DOUBLE, maxBot:DOUBLE
   -> data

   -> misc
   pointMem:PTR TO point
   pointMemSize:LONG -> buffersize in points
   calcStack, calcStackSize
   colorwheelbase:LONG
   pointHash:PTR TO LONG -> 16384 (3FFF+1) * 4 bytes, clear before use
   zoneLeft:DOUBLE, zoneRight:DOUBLE, zoneTop:DOUBLE, zoneBot:DOUBLE
   zoneXMult:DOUBLE, zoneYMult:DOUBLE
   -> gadgets
   flameLevelGad
   maxPointsGad
   functionGad
   feedbackGad
   alternateGad
   bgColPopPen
   fgColPopPen
   squareCheck
   rColCycle, gColCycle, bColCycle
   gammaGad
   inputGads1[6]:ARRAY OF LONG
   inputGads2[6]:ARRAY OF LONG
   maxCountGad, maxLeftGad, maxRightGad, maxTopGad, maxBotGad
   renderfunc
ENDOBJECT

OBJECT params
   maxPoints:LONG
   flameLevel:LONG
   flameVals1[RANDOMSIZE]:ARRAY OF DOUBLE
   flameVals2[RANDOMSIZE]:ARRAY OF DOUBLE
   function:CHAR -> 0=user, 1= first predefined function
   feedback:CHAR -> 0=no feedback, 1 = first feedback function
   alternate:CHAR -> 0=no alternate, 1= first alternate function
   bgColour:LONG -> ARGB
   fgColour:LONG -> ARGB
   squarePix:INT -> bool, not used yet
   gamma:LONG -> float
ENDOBJECT

CONST HASHSIZE= 16384, HASHMASK = $3FFF

ENUM MUIM_Fract_Private_Randomize_Input = MUI_Fract_PRIVATE

PROC main() HANDLE
   muimasterbase := OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN)
   IFN muimasterbase THEN RETURN NIL
   utilitybase := OpenLibrary('utility.library', 39)
   IFN utilitybase THEN Raise(1)
EXCEPT
   CloseLibrary(muimasterbase)
   RETURN NIL
ENDPROC TRUE

PROC close()
   CloseLibrary(muimasterbase)
   CloseLibrary(utilitybase)
ENDPROC

PROC fractCreateGUIClass()
ENDPROC eMui_CreateCustomClass(librarybase,MUIC_Group,NIL,SIZEOF flame,{flameDispatcher})

PROC flameDispatcher(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)

   SELECT msg.methodid
   CASE MUIM_Fract_GetParams;  RETURN     flameGetParams(cl, obj, msg)
   CASE MUIM_Fract_SetParams;  RETURN     flameSetParams(cl, obj, msg)
   CASE MUIM_Fract_RenderDone ; RETURN flameRenderDone(cl, obj, msg)
   CASE MUIM_Fract_Private_Randomize_Input ; RETURN flameRandomizeInput(cl, obj, msg)
   CASE OM_GET           ;  RETURN        flameGet(cl, obj, msg)
   CASE OM_NEW           ;  RETURN         flameNew(cl, obj, msg)
   CASE OM_DISPOSE       ;  RETURN     flameDispose(cl, obj, msg)
   ENDSELECT

ENDPROC doSuperMethodA(cl, obj, msg)


PROC flameGet(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO opget)
   DEF data:PTR TO flame

   data := INST_DATA(cl, obj)

   SELECT msg.attrid
   CASE MUIA_Fract_ParameterSize ; PutLong(msg.storage, SIZEOF params) ; RETURN TRUE
   CASE MUIA_Fract_Name          ; PutLong(msg.storage, 'Cosmic Flame example') ; RETURN TRUE
   CASE MUIA_Fract_RenderFunc    ; PutLong(msg.storage, data.renderfunc) ; RETURN TRUE
   ENDSELECT

ENDPROC doSuperMethodA(cl, obj, msg)


PROC flameNew(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO opset) HANDLE
   DEF data:PTR TO flame

   DEBUGF('flameNew()\n')

   IFN (obj := doSuperMethodA(cl, obj, msg)) THEN RETURN 0

   data := INST_DATA(cl, obj)
   data.selfobj := obj

   data.colorwheelbase := OpenLibrary('gadgets/colorwheel.gadget', 0)
   IFN data.colorwheelbase THEN Raise("LIB")

   data.pointHash := AllocVec(HASHSIZE*4, NIL)

   IFN data.pointHash THEN Raise("MEM")

   DEBUGF('flameNew() HALF DONE\n')

   IFN flameGUI(cl, obj, data) THEN Raise("GUI")

   data.renderfunc := eCodePPC({renderFunc})
   IFN data.renderfunc THEN Raise("ECOD")

   DEBUGF('flameNew() DONE\n')

EXCEPT

   coerceMethodA(cl, obj, [OM_DISPOSE])
   RETURN NIL

ENDPROC obj


PROC flameDispose(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
    DEF data:PTR TO flame

   data := INST_DATA(cl, obj)

   IF data.colorwheelbase THEN CloseLibrary(data.colorwheelbase)

   IF data.pointHash THEN FreeVec(data.pointHash)

   IF data.pointMem THEN FreeVec(data.pointMem)

   IF data.renderfunc THEN eCodeDispose(data.renderfunc)

ENDPROC doSuperMethodA(cl, obj, msg)

PROC flameRandomizeInput(cl, obj:PTR TO object, msg)
   DEF data:PTR TO flame, lib:PTR TO intuitionbase, r:DOUBLE, a, str[50]:STRING

   data := INST_DATA(cl, obj)

   lib := intuitionbase
   a := lib.micros * lib.seconds
   Rnd(a OR $80000000)

   FOR a := 0 TO RANDOMSIZE-1
      setStringFloat(data.inputGads1[a], Rnd(32768)!/16384.0-1.0)
   ENDFOR

   FOR a := 0 TO RANDOMSIZE-1
      setStringFloat(data.inputGads2[a], Rnd(32768)!/16384.0-1.0)
   ENDFOR

ENDPROC

PROC flameRenderDone(cl, obj:PTR TO object, msg)
   DEF data:PTR TO flame, str[50]:STRING
   data := INST_DATA(cl, obj)

   -> here we may update som status in our flame-gui..

   set(data.maxCountGad, MUIA_Text_Contents, StringF(str, '\d', data.maxCount))

   setTextFloat(data.maxLeftGad, data.maxLeft)
   setTextFloat(data.maxRightGad, data.maxRight)
   setTextFloat(data.maxTopGad, data.maxTop)
   setTextFloat(data.maxBotGad, data.maxBot)

ENDPROC

PROC flameGetParams(cl, obj:PTR TO object, msg:PTR TO LONG)
   DEF data:PTR TO flame, v, r, t, params:PTR TO params

   data := INST_DATA(cl, obj)

   params := msg[1]

      params.feedback := xget(data.feedbackGad, MUIA_Cycle_Active)

      params.alternate := xget(data.alternateGad, MUIA_Cycle_Active)

      v := xget(data.flameLevelGad, MUIA_Slider_Level)
      params.flameLevel := v

      v := xget(data.maxPointsGad, MUIA_String_Integer)
      IF v < 1 THEN RETURN 'Invalid "Maxpoints"'
      IF v > data.pointMemSize
         FreeVec(data.pointMem)
         data.pointMem := AllocVec(SIZEOF point * v, MEMF_PUBLIC)
         params.maxPoints := 0
         data.pointMemSize := v
         IF data.pointMem = NIL THEN RETURN 'Not enough memory.'
      ENDIF
      params.maxPoints := v

      IF data.calcStackSize < (params.flameLevel * 200 + 16000)
         IF data.calcStack THEN FreeVec(data.calcStack)
         data.calcStackSize := params.flameLevel * 200 + 16000 AND -16
         data.calcStack := AllocVec(data.calcStackSize, MEMF_PUBLIC)
         IF data.calcStack = NIL THEN RETURN 'Not enough memory.'
      ENDIF


   t := xget(data.bgColPopPen, MUIA_Pendisplay_RGBcolor)
   params.bgColour := Long(t) SHR 8

   t := xget(data.fgColPopPen, MUIA_Pendisplay_RGBcolor)
   params.fgColour := Long(t) SHR 8

   params.squarePix := xget(data.squareCheck, MUIA_Selected)

   t := xget(data.gammaGad, MUIA_String_Contents)
   t := RealVal(t)
   params.gamma := t


   params.flameVals1[0] := getStringFloat(data.inputGads1[0])
   params.flameVals1[1] := getStringFloat(data.inputGads1[1])
   params.flameVals1[2] := getStringFloat(data.inputGads1[2])
   params.flameVals1[3] := getStringFloat(data.inputGads1[3])
   params.flameVals1[4] := getStringFloat(data.inputGads1[4])
   params.flameVals1[5] := getStringFloat(data.inputGads1[5])
   params.flameVals2[0] := getStringFloat(data.inputGads2[0])
   params.flameVals2[1] := getStringFloat(data.inputGads2[1])
   params.flameVals2[2] := getStringFloat(data.inputGads2[2])
   params.flameVals2[3] := getStringFloat(data.inputGads2[3])
   params.flameVals2[4] := getStringFloat(data.inputGads2[4])
   params.flameVals2[5] := getStringFloat(data.inputGads2[5])


ENDPROC NIL

PROC flameSetParams(cl, obj, msg) IS NIL

-> invoked by subtask !
PROC renderFunc(rm:PTR TO rendermsg)
   DEF data:PTR TO flame
   DEF sss:stackswapstruct, r, rd:recursedata
   DEF params:PTR TO params
   DEF oldtop, oldleft, oldwidth, oldheight
   DEF miscfunc(PTR, LONG, LONG,LONG,LONG)

   DEBUGF('renderFunc($\h) FLAME\n', rm)

   data := INST_DATA(rm.object[-1].class, rm.object)

   miscfunc := rm.miscfunc

   IF data.pointMem = NIL THEN RETURN ->

   data.rm := rm

   data.pointsDone := 0
   sss.lower := data.calcStack
   sss.upper := data.calcStack + data.calcStackSize
   sss.pointer := data.calcStack + data.calcStackSize

   FOR r := 0 TO HASHSIZE-1 DO data.pointHash[r] := NIL

   rd.x := 0.0
   rd.y := 0.0
   rd.level := 0

   -> precalculate some

   data.zoneLeft := !data.rm.zone.x - (!data.rm.zone.r * IF data.rm.display.width>data.rm.display.height THEN data.rm.display.width!/(data.rm.display.height!) ELSE 1.0)
   data.zoneRight := !data.rm.zone.x + (!data.rm.zone.r * IF data.rm.display.width>data.rm.display.height THEN data.rm.display.width!/(data.rm.display.height!) ELSE 1.0)
   data.zoneTop := !data.rm.zone.y - (!data.rm.zone.r * IF data.rm.display.height>data.rm.display.width THEN data.rm.display.height!/(data.rm.display.width!) ELSE 1.0)
   data.zoneBot := !data.rm.zone.y + (!data.rm.zone.r * IF data.rm.display.height>data.rm.display.width THEN data.rm.display.height!/(data.rm.display.width!) ELSE 1.0)

   data.zoneXMult := Min(data.rm.display.width, data.rm.display.height)! / (!data.rm.zone.r*2.0)
   data.zoneYMult := Min(data.rm.display.width, data.rm.display.height)! / (!data.rm.zone.r*2.0)

   data.maxCount := 0 -> stats
   data.maxLeft := 0.0
   data.maxRight := 0.0
   data.maxTop := 0.0
   data.maxBot := 0.0


   IF data.rm.redraw.next -> scattered render ?
      -> it makes no sense trying this with this type of fractal
      -> so we just render it all by fooling the routines its a
      -> single redraw-all message
      oldleft := data.rm.redraw.left
      oldtop := data.rm.redraw.top
      oldwidth := data.rm.redraw.width
      oldheight := data.rm.redraw.height
      data.rm.redraw.left := 0
      data.rm.redraw.top := 0
      data.rm.redraw.width := data.rm.display.width
      data.rm.redraw.height := data.rm.display.height
   ENDIF

   ->WriteF('calling recurse..\n')

   r := NewPPCStackSwap(sss, {recurse}, [data,rd,data.rm.redraw,0,0,0,0,0])

   SELECT r
   CASE "ABOR"  ; JUMP flame_rend_end
   CASE "STOP"  ; PushStatusTxt(data.rm, STATUSTXT_STOPPED)
   CASE "STCK"  ; PushStatusTxt(data.rm, 'Out of stack!')
   CASE "DONE"  ;
   CASE NIL     ; PushStatusTxt(data.rm, 'Too low flame level.')
   DEFAULT      ; PushStatusTxt(data.rm, '???')
   ENDSELECT

   IF r <> "DONE" THEN JUMP flame_rend_end

   PushGauge(data.rm, Percent(data.rm.parameters::params.maxPoints, data.pointsDone))
   PushStatusTxt(data.rm, 'Rendering 2/2..')

   r := render(data)

   SELECT r
   CASE "ABOR" ; JUMP flame_rend_end
   CASE "STOP" ; PushStatusTxt(data.rm, STATUSTXT_STOPPED)
   CASE "DONE" ; PushStatusTxt(data.rm, STATUSTXT_DONE)
               ; PushRenderDone(data.rm)
   DEFAULT     ; PushStatusTxt(data.rm, '???')
   ENDSELECT

   PushRedraw(data.rm)

flame_rend_end:

   IF data.rm.redraw.next  -> see above
      data.rm.redraw.left := oldleft
      data.rm.redraw.top := oldtop
      data.rm.redraw.width:= oldwidth
      data.rm.redraw.height := oldheight
   ENDIF


ENDPROC


#define HASHXY(x,y) (x + y AND HASHMASK)

PROC findPoint(point:REG PTR TO point, x:REG,y:REG)
   WHILE point
      IF point.x = x
         IF point.y = y
            RETURN point
         ENDIF
      ENDIF
      point := point.hnext
   ENDWHILE
ENDPROC NIL

#define CheckStack IF R1 < (data.calcStack + 4000) THEN RETURN "STCK"
#define FloatMin(x,y) (IF ! (x) < (y) THEN x ELSE y)
#define FloatMax(x,y) (IF ! (x) > (y) THEN x ELSE y)

PROC recurse(data:PTR TO flame, old:PTR TO recursedata, redraw:PTR TO redrawmsg)
   DEF v, i, f:PTR TO DOUBLE, oldpoint:PTR TO point
   DEF new:recursedata,point:PTR TO point, mw, p:PTR TO params
   DEF miscfunc(PTR, LONG, LONG,LONG,LONG)

   p := data.rm.parameters

   IF data.rm.job.break
      IF data.rm.job.break AND JMBREAKF_ABORT
         RETURN "ABOR"
      ELSEIF data.rm.job.break AND JMBREAKF_STOP
         RETURN "STOP"
      ENDIF
   ENDIF

   miscfunc := data.rm.miscfunc

   CheckStack

   IF data.pointsDone >= p.maxPoints THEN RETURN "DONE"

   IF old.level >= p.flameLevel

      IF Mod(data.pointsDone, p.maxPoints/100) = NIL
         PushGauge(data.rm, Percent(p.maxPoints, data.pointsDone))
      ENDIF
      point := data.pointMem[data.pointsDone]

      data.maxLeft := FloatMin(data.maxLeft, old.x)
      data.maxRight := FloatMax(data.maxRight, old.x)
      data.maxTop := FloatMin(data.maxTop, old.y)
      data.maxBot := FloatMax(data.maxBot, old.y)

      IF ! old.x >= data.zoneLeft->-1.0
         IF ! old.x <= data.zoneRight->1.0
            IF ! old.y >= data.zoneTop->-1.0
               IF ! old.y <= data.zoneBot->1.0

                  point.x := ! old.x - data.zoneLeft * data.zoneXMult !
                  point.y := ! old.y - data.zoneTop * data.zoneYMult !

                  IF point.x >= redraw.left
                     IF point.x <= (redraw.left+redraw.width)
                        IF point.y >= redraw.top
                           IF point.y <= (redraw.top+redraw.height)
                              point.z := ! old.z * 4000.0 + 4000.0 ! -> 0-8000
                              i := HASHXY(point.x, point.y)
                              oldpoint := findPoint(data.pointHash[i], point.x, point.y)
                              IF oldpoint
                                 oldpoint.count++
                                 oldpoint.z := oldpoint.z + point.z / 2
                                 data.maxCount := Max(data.maxCount, oldpoint.count)
                              ELSE
                                 point.hnext := data.pointHash[i]
                                 data.pointHash[i] := point
                                 point.count := 1
                              ENDIF
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF

      data.pointsDone++

   ELSE

      new.level := old.level + 1
      f := p.flameVals1
      new.x:=!(!f[]++*old.x)+(!f[]++*old.y)+ f[]++
      new.y:=!(!f[]++*old.x)+(!f[]++*old.y)+ f[]++

      new.z := !new.x - new.y


      v := recurse(data,new,redraw)
      IF v THEN RETURN v

      f := p.flameVals2
      new.x:=!(!f[]++*old.x)+(!f[]++*old.y)+ f[]++
      new.y:=!(!f[]++*old.x)+(!f[]++*old.y)+ f[]++


      new.z := !new.x - new.y

      v := recurse(data,new,redraw)
      IF v THEN RETURN v

   ENDIF

ENDPROC NIL



PROC feedbackFunc(p:PTR TO params, old:PTR TO recursedata,new:PTR TO recursedata)
   DEF num
   num := p.feedback
   IF num = NIL THEN RETURN
   old.x := doFB(old.x,new.x,num)
   old.y := doFB(old.y,new.y,num)
ENDPROC

PROC doFB(a,b,num)
   SELECT num
   CASE 0 ; RETURN a
   CASE 1 ; RETURN ! a + a + a + a + a + a + a + a + a + a +
                     a + a + a + a + a + a + a + a + a + b / 20.0 -> 5 %
   CASE 2 ; RETURN ! a + a + a + a + a + a + a + a + a + b / 10.0 -> 10 %
   CASE 3 ; RETURN ! a + a + a + a + a + a + a + a + a + a + a + a + a + a +
                     a + a + a + b + b + b / 20.0 -> 15 %
   CASE 4 ; RETURN ! a + a + a + b / 4.0 -> 25 %
   CASE 5 ; RETURN ! a + a + b / 3.0     -> 33 %
   CASE 6 ; RETURN ! a + b / 2.0         -> 50 %
   CASE 7 ; RETURN ! a + b + b / 3.0     -> 66 %
   CASE 8 ; RETURN ! a + b + b + b / 4.0 -> 75 %
   ENDSELECT
ENDPROC a

PROC alternateFunc(p:PTR TO params, old:PTR TO recursedata, new:PTR TO recursedata)
   DEF t, nx, ny, nz, nr, ng, nb, num
   num := p.alternate
   nx := new.x
   ny := new.y
   SELECT num
   CASE 0
   CASE 1  ; t := ! (!nx*nx) + (!ny*ny)  -> spherical
           ; nx := ! nx / t
           ; ny := ! ny / t
   ENDSELECT
   new.x := nx
   new.y := ny
ENDPROC


PROC render(data:PTR TO flame)
   DEF light:REAL
   DEF a, x:DOUBLE, y:DOUBLE, z:DOUBLE, point:REG PTR TO point
   DEF r:REAL, g:REAL, b:REAL
   DEF plotrgbfunc(PTR, LONG, LONG, REAL, REAL, REAL)
   DEF setredrawareafunc(PTR, PTR, REAL, REAL, REAL)
   DEF miscfunc(PTR, LONG, LONG,LONG,LONG)

   plotrgbfunc := data.rm.plotrgbfunc
   setredrawareafunc := data.rm.setredrawareafunc
   miscfunc := data.rm.miscfunc

   setredrawareafunc(data.rm, data.rm.redraw, 0.0, 0.0, 0.0)

   data.pointsDone := 0

   x := data.maxCount!
   y := !1.0 / x


   FOR a := 0 TO (HASHSIZE-1)
      IF data.rm.job.break
         IF data.rm.job.break AND JMBREAKF_ABORT
            RETURN "ABOR"
         ELSEIF data.rm.job.break AND JMBREAKF_STOP
            RETURN "STOP"
         ENDIF
      ENDIF
      point := data.pointHash[a]
      WHILE point

         light := !x - (point.count!) * y

         r := light
         g := light
         b := light

         plotrgbfunc(data.rm, point.x, point.y, r, g, b)

         point := point.hnext

      ENDWHILE
      IF Mod(a, 400) = NIL
         PushGauge(data.rm, Percent(HASHSIZE-1, a))
      ENDIF
   ENDFOR

   ->WriteF('r=\d, g=\d, b=\d, x=\d, y=\d, z=\d\n', r, g, b, point.x, point.y, point.z)
   PushGauge(data.rm, 100)


ENDPROC "DONE"



#define CycleID(entries,id) CycleObject, MUIA_ObjectID, id, MUIA_Font, MUIV_Font_Button, MUIA_Cycle_Entries, entries, End

#define ISlider(min,max,level,id)\
   SliderObject,\
      MUIA_Numeric_Min  , min,\
      MUIA_Numeric_Max  , max,\
      MUIA_Numeric_Value, level,\
      MUIA_ObjectID, id,\
      End

PROC flameGUI(cl, obj:PTR TO object, data:PTR TO flame) HANDLE
   DEF group=NIL, g0=NIL, g1=NIL, g2=NIL, g3=NIL, rg=NIL

   g0 := VGroup,
      Child, HGroup,
         Child, Label1('FL:'),
         Child, data.flameLevelGad:= ISlider(16,1000,200,"FL"),->IString_('0', 256, "FL"),
         Child, Label1('MP:'),
         Child, data.maxPointsGad := IString_('0', 256, "MP"),
         Child, RectangleObject, MUIA_Weight, 0,End,
      End,
      Child, HGroup,
         Child, Label1('Feedback:'),
         Child, data.feedbackGad := Cycle(['None', '5%', '10%', '15%', '25%', '33%', '50%', '66%', '75%', NIL]),
         Child, Label1('Alteration:'),
         Child, data.alternateGad := Cycle(['None', 'Spherical', 'NoName1', NIL]),
         Child, RectangleObject, MUIA_Weight, 0,End,
      End,
   End

   IF g0 = NIL THEN Raise("G0")


   g1 := VGroup,
      Child, HGroup,
         Child, Label1('Background:'),
         Child, data.bgColPopPen := PoppenObject, End,
         Child, Label1('Foreground:'),
         Child, data.fgColPopPen := PoppenObject, End,
         ->Child, RectangleObject, MUIA_Weight, 0,End,
      End,
      Child, HGroup,
         Child, Label('Gamma:'),
         Child, data.gammaGad := String_('1.0', 5, "RGAM"),
         ->Child, RectangleObject, MUIA_Weight, 0, End,
      End,
      Child, HGroup,
         Child, Label1('Correct Aspect Ratio:'),
         Child, data.squareCheck := CheckMark(0),
         ->Child, RectangleObject, MUIA_Weight, 0, End,
      End,
   End

   IF g1 = NIL THEN Raise("G1")

   g2 := VGroup,
      Child, rg := KeyButton('Randomize', "q"),
      Child, HGroup,
         Child, Label1('X1:'),
         Child, data.inputGads1[0] := floatStringObject(.0, "AX1"),
         Child, data.inputGads1[1] := floatStringObject(.0, "BY1"),
         Child, data.inputGads1[2] := floatStringObject(.0, "C1"),
         Child, RectangleObject, MUIA_Weight, 0,End,
      End,
      Child, HGroup,
         Child, Label1('Y1:'),
         Child, data.inputGads1[3] := floatStringObject(.0, "DX1"),
         Child, data.inputGads1[4] := floatStringObject(.0, "EY1"),
         Child, data.inputGads1[5] := floatStringObject(.0, "D1"),
         Child, RectangleObject, MUIA_Weight, 0,End,
      End,
      Child, HGroup,
         Child, Label1('X2:'),
         Child, data.inputGads2[0] := floatStringObject(.0, "AX2"),
         Child, data.inputGads2[1] := floatStringObject(.0, "BY2"),
         Child, data.inputGads2[2] := floatStringObject(.0, "C2"),
         Child, RectangleObject, MUIA_Weight, 0,End,
      End,
      Child, HGroup,
         Child, Label1('Y2:'),
         Child, data.inputGads2[3] := floatStringObject(.0, "DX2"),
         Child, data.inputGads2[4] := floatStringObject(.0, "EY2"),
         Child, data.inputGads2[5] := floatStringObject(.0, "D2"),
         Child, RectangleObject, MUIA_Weight, 0,End,
      End,
   End

   IF g2 = NIL THEN Raise("G2")

   g3 := ColGroup(2),
         Child, Label1('Max Count:'),
         Child, data.maxCountGad := TextObject,
            MUIA_Text_Contents, '--',
            TextFrame,
         End,
         Child, Label1('Max Left:'),
         Child, data.maxLeftGad := TextObject,
            MUIA_Text_Contents, '--',
            TextFrame,
         End,
         Child, Label1('Max Right:'),
         Child, data.maxRightGad := TextObject,
            MUIA_Text_Contents, '--',
            TextFrame,
         End,
         Child, Label1('Max Top:'),
         Child, data.maxTopGad := TextObject,
            MUIA_Text_Contents, '--',
            TextFrame,
         End,
         Child, Label1('Max Bot:'),
         Child, data.maxBotGad := TextObject,
            MUIA_Text_Contents, '--',
            TextFrame,
         End,
   End

   group := RegisterGroup(['1','2','3','4',NIL]),
     ->GroupFrameT('Flame fractal plugin (built-in)'),
     MUIA_Weight, 1,
      Child, g0,
      Child, g1,
      Child, g2,
      Child, g3,
   End

   IF group = NIL THEN Raise("GRP")

   DOMETHODA(obj, [OM_ADDMEMBER, group])


   DOMETHODA(rg, [MUIM_Notify, MUIA_Selected, FALSE,
                 obj, 1, MUIM_Fract_Private_Randomize_Input])

EXCEPT
   IF g0 THEN Mui_DisposeObject(g0)
   IF g1 THEN Mui_DisposeObject(g1)
   IF g2 THEN Mui_DisposeObject(g2)
   IF g3 THEN Mui_DisposeObject(g3)

   RETURN NIL

ENDPROC obj

