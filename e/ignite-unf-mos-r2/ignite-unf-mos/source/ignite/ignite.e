
-> IGNITE.e

OPT PREPROCESS


#ifdef DEBUG
   #define DEBUGF(str,...) DebugF(str,...)
#else
   #define DEBUGF(str,...)
#endif


MODULE 'exec/lists'
MODULE 'exec/nodes'
MODULE 'exec/ports'
MODULE 'exec/tasks'
MODULE 'exec/memory'
MODULE 'exec/io'

MODULE 'dos/dos'
MODULE 'dos/dosextens'
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
MODULE 'other/ecode'

MODULE '*mainmisc'
MODULE '*fractmisc'
MODULE '*dispwin'
->MODULE '*flame/plugin_flame'
->MODULE '*mand/plugin_mand'

MODULE '*fract_plugin'

MODULE '*mystring'

MODULE 'tools/exceptions'

MODULE '*/jobdev/jobdefs'

MODULE '*stuff/makepng2'

DEF cybergfxbase

CHAR '$VER: IGNITE by LS 2004-07',0


/********************************************************************/
/*********************** MAIN ***************************************/
/********************************************************************/

OBJECT ignitedata
   hook:hook
   appobj:PTR TO object
   selfobj:PTR TO object
   gaugeobj:PTR TO object
   statusobj:PTR TO object
   fractpage:PTR TO object
   replyport:PTR TO mp
   dispwinmcc:PTR TO mui_customclass
   ihnode:mui_inputhandlernode
   lastdispwinactive:LONG

   renderunit -> 20100619

   miscfunc -> protected with eCodePPC()

   /* here for now */
   invertGad
   brightGad
   expModGad
   invert
   brightness:LONG -> +-100
   expmod:LONG
ENDOBJECT


SET DUFLAGF_INUSE

ENUM MUIM_Ignite_SignalHandler = $88888500

#define CycleID(entries,id) CycleObject, MUIA_ObjectID, id, MUIA_Font, MUIV_Font_Button, MUIA_Cycle_Entries, entries, End

PROC igniteNew(cl:PTR TO iclass, obj:PTR TO object, msg) HANDLE
   DEF data:PTR TO ignitedata

   DEBUGF('igniteNew() backlink=$\h, backframe=$\h\n', Long(R1+356), Long(R1))

   IF (obj := doSuperMethodA(cl, obj, msg)) = NIL THEN RETURN 0

   DEBUGF('igniteNew() did doSuperMethod()\n')

   data := INST_DATA(cl, obj)

   data.replyport := CreateMsgPort()
   IF data.replyport = NIL THEN Raise("PORT")

   data.ihnode.ihn_object := obj
   data.ihnode.ihn_signals := Shl(1, data.replyport.sigbit)
   data.ihnode.ihn_flags := NIL
   data.ihnode.ihn_method := MUIM_Ignite_SignalHandler

   DEBUGF('igniteNew() HALFWAY backlink=$\h, backframe=$\h\n', Long(R1+356), Long(R1))

   DOMETHODA(obj, [MUIM_Application_AddInputHandler, data.ihnode])

   data.dispwinmcc := createDispWinClass()
   IF data.dispwinmcc = NIL THEN Throw("MCC", 'dispwin')

   installhook(data.hook, {igniteHandler})

   data.miscfunc := eCodePPC({miscFunc})
   IFN data.miscfunc THEN Raise("ECOD")

   data.renderunit := -1

   DEBUGF('igniteNew() DONE backlink=$\h, backframe=$\h\n', Long(R1+356), Long(R1))

EXCEPT

   SetIoErr(exception)

   coerceMethodA(cl, obj, [OM_DISPOSE])
   RETURN NIL

ENDPROC obj


PROC igniteDispose(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
   DEF data:PTR TO ignitedata
   DEF win, list:PTR TO mlh, node

   DEBUGF('igniteDispose()\n')

   data := INST_DATA(cl, obj)

   -> close remove and dispose windows
   -> must be done here
   list := XGET(obj, MUIA_Application_WindowList)
   node := list.head
   WHILE win := NextObject({node})
      IF XGET(win, MUIA_DispWin_IsDispWin)
         set(win, MUIA_Window_Open, FALSE)
         DOMETHODA(obj, [OM_REMMEMBER, win])
         Mui_DisposeObject(win)
      ENDIF
   ENDWHILE

   DOMETHODA(obj, [MUIM_Application_RemInputHandler, data.ihnode])

   IF data.replyport THEN DeleteMsgPort(data.replyport)

   IF data.dispwinmcc THEN Mui_DeleteCustomClass(data.dispwinmcc)

   IF data.miscfunc THEN eCodeDispose(data.miscfunc)

   DEBUGF('igniteDispose() DONE\n')

ENDPROC doSuperMethodA(cl, obj, msg)


PROC igniteSetup(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg) HANDLE
   DEF data:PTR TO ignitedata
   DEBUGF('igniteSetup()\n')
   data := INST_DATA(cl, obj)



EXCEPT

   coerceMethodA(cl, obj, [MUIM_Cleanup])
   RETURN NIL

ENDPROC MUI_TRUE


PROC igniteCleanup(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
   DEF data:PTR TO ignitedata
   DEBUGF('igniteCleanup()\n')
   data := INST_DATA(cl, obj)


ENDPROC doSuperMethodA(cl, obj, msg)


PROC igniteGet(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO opget)
   DEF data:PTR TO ignitedata, storage, attr
   DEBUGF('igniteGet()\n')
   data := INST_DATA(cl, obj)

   SELECT msg.attrid
   ENDSELECT

ENDPROC doSuperMethodA(cl, obj, msg)

PROC igniteSignalHandler(cl, obj:PTR TO object, msg:PTR TO LONG)
   DEF data:PTR TO ignitedata, rmsg:PTR TO rendermsg
   data := INST_DATA(cl, obj)
   IF rmsg := GetMsg(data.replyport)
      rmsg.job.io.mn.ln.succ := NIL
      rmsg.job.io.mn.ln.pred := NIL
      RETURN TRUE
   ENDIF
ENDPROC FALSE

#define InputError(err) RETURN set(data.statusobj, MUIA_Text_Contents, err)

PROC igniteDispatcher(cl:PTR TO iclass, obj:PTR TO object, msg:PTR TO msg)
   DEBUGF('igniteDispatcher() cl=$\h, obj=$\h, msg=$\h, mid=$\h\n', cl,obj,msg,msg.methodid)
   SELECT msg.methodid
   CASE MUIM_Ignite_SignalHandler ; RETURN igniteSignalHandler(cl, obj, msg)
   CASE OM_GET           ; RETURN        igniteGet(cl, obj, msg)
   CASE MUIM_Setup       ;  RETURN       igniteSetup(cl, obj, msg)
   CASE MUIM_Cleanup     ;  RETURN     igniteCleanup(cl, obj, msg)
   CASE OM_NEW           ;  RETURN         igniteNew(cl, obj, msg)
   CASE OM_DISPOSE       ;  RETURN     igniteDispose(cl, obj, msg)
   ENDSELECT
   DEBUGF('igniteDispatcher() $\h DONE\n', msg.methodid)
ENDPROC doSuperMethodA(cl, obj, msg)


ENUM ARG_BLA, NROFARGS

ENUM MNone,
     M_File,
        MSaveCurrView,
     M_Plugins,
        MFractPlugs,
     M_Windows,
        MViewWin,
     M_Help

PROC makeMenu()
   DEF menustrip
   #define MENU1(title, id) Child, MenuObject, MUIA_Menu_Title, title,\
      MUIA_UserData, id

   #define MENUITEM1(title, id, shortcut) Child, MenuitemObject, MUIA_Menuitem_Title, title,\
      MUIA_UserData, id, MUIA_Menuitem_Shortcut, shortcut, End

   menustrip := MenustripObject,
      MENU1('File', M_File),
         MENUITEM1('Save current view', MSaveCurrView, 0),
      End,
      MENU1('Fractals', M_Plugins),

      End,
      MENU1('Windows', M_Windows),
         MENUITEM1('New ZoneView', MViewWin, 0),
      End,
      MENU1('Help', M_Help),
      End,
   End

ENDPROC menustrip

PROC keyButton(name, key) IS TextObject,
                ButtonFrame,
               MUIA_Font,          MUIV_Font_Button,
                MUIA_Text_Contents, name,
                MUIA_Text_PreParse, '\ec',
                MUIA_ControlChar  , key,
                MUIA_InputMode    , MUIV_InputMode_RelVerify,
                MUIA_Background   , MUII_ButtonBack,
                MUIA_Weight, 0,
                End

PROC main() HANDLE
   DEF window=NIL
   DEF igniteobj=NIL, ignitemcc=NIL:PTR TO mui_customclass
   DEF sigs=0, rdargs=NIL, args:PTR TO LONG, x, data=NIL:PTR TO ignitedata
   DEF rendbut=NIL, stopbut=NIL
   DEF menu, item, menustrip, a, names, fractobj
   DEF str[256]:STRING

   NEW args[NROFARGS]

   rdargs := ReadArgs('BLA/S', args, NIL)
   IFN rdargs THEN Raise("ARGS")

   muimasterbase := OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN)
   IFN muimasterbase THEN Throw("LIB", 'muimaster.library')

   utilitybase := OpenLibrary('utility.library', 50)
   IFN utilitybase THEN Throw("LIB", 'utility.library')

   cybergfxbase := OpenLibrary('cybergraphics.library', 50)
   IFN cybergfxbase THEN Throw("LIB", 'cybergraphics.library')

   ignitemcc := eMui_CreateCustomClass(NIL,MUIC_Application,NIL,SIZEOF ignitedata,{igniteDispatcher})
   IFN ignitemcc THEN Throw("MCC", 'ignite')

   igniteobj:=NewObjectA(ignitemcc.mcc_class,NIL,[
      MUIA_Application_Title      , 'IGNITE (c) 2004-2009 Leif Salomonsson',
      MUIA_Application_Version    , '$VER: version',
      MUIA_Application_Copyright  , 'Copyright',
      MUIA_Application_Author     , 'Author',
      MUIA_Application_Description, 'Description',
      MUIA_Application_Base       , 'IGNITEBASE',
      MUIA_Application_Menustrip, menustrip := makeMenu(),
   End

   IFN igniteobj THEN Throw("NOBJ", 'application')

   ->WriteF('igniteobj OK\n')

   data := INST_DATA(ignitemcc.mcc_class, igniteobj)
   data.selfobj := igniteobj

   window := WindowObject,
      MUIA_Window_Title, 'IGNITE (c) Leif Salomonsson 2004-2007',
      MUIA_Window_ID   , "MAIN",
      WindowContents, VGroup,
         Child, data.fractpage := PageGroup,
         End,
         Child, RectangleObject, MUIA_Rectangle_HBar, TRUE, End,
         Child, HGroup,
            Child, Label1('Brightness:'),
            Child, data.brightGad := Slider(-100,100,0),
            Child, Label1('Inv. cols :'),
            Child, data.invertGad := CheckMark(FALSE),
         End,
         Child, HGroup,
            Child, Label1('Brightness modifier:'),
            Child, data.expModGad := CycleID(['None', 'Square', 'Qube', 'SRoot', 'Exp', 'Log', NIL], "BMOD"),
         End,
         Child, RectangleObject, MUIA_Rectangle_HBar, TRUE, End,
         Child, HGroup,
            Child, rendbut := keyButton('Render', "r"),
            Child, stopbut := keyButton('Stop', "s"),
            Child, data.gaugeobj := GaugeObject,
               MUIA_VertWeight, 10,
               MUIA_Gauge_Horiz, TRUE,
               MUIA_Background, MUII_BACKGROUND,
               MUIA_Gauge_Max, 100,
               MUIA_Gauge_Current, 0,
            End,
         End,
         Child, HGroup,
            Child, Label1('Status:'),
            Child, data.statusobj := TextObject,
                     MUIA_Frame, MUIV_Frame_Text,
                     MUIA_Background, MUII_TextBack,
                     MUIA_Text_PreParse, '\ec',
                     MUIA_Text_Contents, 'Welcome!',
                     MUIA_Weight, 100, End,
         End,
      End,
   End

   IFN window THEN Throw("NOBJ", 'win')

   ->WriteF('window OK\n')

   names := scanFractPlugNames('PROGDIR:fractplugs/')

   menu := DOMETHODA(menustrip, [MUIM_FindUData, M_Plugins])
   a := 0

   WHILE names
      fractobj := makeFractPlugName(names)
      IF fractobj
         DOMETHODA(data.fractpage, [OM_ADDMEMBER, fractobj])
         item := MenuitemObject, MUIA_Menuitem_Title, XGET(fractobj, MUIA_Fract_Name),
              MUIA_UserData, 1000+a, End
         DOMETHODA(menu, [MUIM_Family_AddTail, item])
      ENDIF
      names := Next(names)
      a++
   ENDWHILE


   DOMETHODA(igniteobj, [OM_ADDMEMBER, window])

   ->WriteF('window added OK\n')


   DOMETHODA(window, [MUIM_Notify,MUIA_Window_CloseRequest, MUI_TRUE,
      igniteobj, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit])

   DOMETHODA(igniteobj,[MUIM_Notify,MUIA_Application_MenuAction,MUIV_EveryTime,
      igniteobj, 4, MUIM_CallHook, data, IH_MENU, MUIV_TriggerValue])

   DOMETHODA(rendbut, [MUIM_Notify,MUIA_Selected, FALSE,
      igniteobj, 3, MUIM_CallHook, data, IH_RENDER])

   DOMETHODA(stopbut, [MUIM_Notify,MUIA_Selected, FALSE,
      igniteobj, 3, MUIM_CallHook, data, IH_STOP])


   DOMETHODA(data.brightGad, [MUIM_Notify, MUIA_Slider_Level, MUIV_EveryTime,
      data.brightGad, 3,
      MUIM_WriteLong, MUIV_TriggerValue, data + OFFSETOF ignitedata.brightness])

   DOMETHODA(data.invertGad, [MUIM_Notify, MUIA_Selected, MUIV_EveryTime,
      data.invertGad, 3,
      MUIM_WriteLong, MUIV_TriggerValue, data + OFFSETOF ignitedata.invert])

   DOMETHODA(data.expModGad, [MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
      data.expModGad, 3,
      MUIM_WriteLong, MUIV_TriggerValue, data + OFFSETOF ignitedata.expmod])



   DOMETHODA(igniteobj, [MUIM_Application_Load, MUIV_Application_Load_ENVARC])

   set(window, MUIA_Window_Open, MUI_TRUE)
   IF XGET(window, MUIA_Window_Open) = FALSE THEN Raise("OWIN")

   ->WriteF('window opended OK\n')

   inputLoop(igniteobj)

   DOMETHODA(igniteobj, [MUIM_Application_Save, MUIV_Application_Save_ENVARC])

   set(window, MUIA_Window_Open, FALSE)

EXCEPT DO

   SELECT exception
   CASE "ARGS"  ; WriteF('error: bad args\n')
   CASE "LIB"   ; WriteF('error: could not open library: \s\n', exceptioninfo)
   CASE "OWIN"  ; WriteF('error: could not open window\n')
   CASE "MCC"   ; WriteF('error: could not create custom class: \s\n', exceptioninfo)
   CASE "LOBJ"  ; WriteF('debug error: low object pointer\n')
   CASE "LHOK"  ; WriteF('debug error: low hook pointer\n')
   CASE "NIL"   ; WriteF('debug error: nil pointer at line \d\n', exceptioninfo)
   CASE "MEM"   ; WriteF('error: not enough memory\n')
   CASE "NOBJ"  ; WriteF('error: could not create object \s\n', exceptioninfo)
   DEFAULT
      IF exception > 0
         ->WriteF('error: unknown, $\h\n', exception)
         report_exception()
      ENDIF
   ENDSELECT

   IF IoErr() THEN WriteF('error: IoErr() code: \d\n', IoErr())


   IF igniteobj THEN Mui_DisposeObject(igniteobj)
   IF ignitemcc THEN Mui_DeleteCustomClass(ignitemcc)
   ->IF flamemcc THEN Mui_DeleteCustomClass(flamemcc)
   ->IF mandmcc THEN Mui_DeleteCustomClass(mandmcc)
   IF muimasterbase THEN CloseLibrary(muimasterbase)
   IF utilitybase THEN CloseLibrary(utilitybase)
   IF cybergfxbase THEN CloseLibrary(cybergfxbase)
   IF rdargs THEN FreeArgs(rdargs)

ENDPROC

PROC inputLoop(app)
   DEF sigs=NIL
   WHILE DOMETHODA(app,
      [MUIM_Application_NewInput,
      {sigs}]) <> MUIV_Application_ReturnID_Quit
      IF sigs THEN sigs := Wait(sigs OR SIGBREAKF_CTRL_C)
      EXIT sigs AND SIGBREAKF_CTRL_C
   ENDWHILE
ENDPROC

PROC openDisplayWin(data:PTR TO ignitedata) HANDLE
   DEF win=NIL, fractobj, rendermsg=NIL:PTR TO rendermsg
   DEF list:PTR TO mlh, head, dev=NIL, x

   DEBUGF('newDisplayWin()\n')
   x := XGET(data.fractpage, MUIA_Group_ActivePage)
   fractobj := findPageNum(data.fractpage, x)

   DEBUGF('   fractobj=$\h\n', fractobj)

   rendermsg := CreateIORequest(data.replyport, SIZEOF rendermsg)
   IF rendermsg = NIL THEN Raise("IOR")

   DEBUGF('   rendermsg=$\h\n', rendermsg)

   rendermsg.hook := data.hook
   rendermsg.igniteobj := data.selfobj
   rendermsg.object := fractobj
   rendermsg.parameters := AllocVec(XGET(fractobj, MUIA_Fract_ParameterSize), MEMF_PUBLIC OR MEMF_CLEAR)
   IF rendermsg.parameters = NIL THEN Raise("MEM")
   rendermsg.job.priority := -1
   rendermsg.job.jobfunc := XGET(fractobj, MUIA_Fract_RenderFunc)
   rendermsg.plotrgbfunc := {plotRGB}
   rendermsg.setredrawareafunc := {setRedrawArea}
   rendermsg.miscfunc := data.miscfunc

   DEBUGF('newdisplayWin() / internalDevOpen()\n')
   IF OpenDevice('job.device', data.renderunit, rendermsg, NIL) <> NIL THEN Raise("ODEV")

   data.renderunit := rendermsg.job.io.unit -> ! 20100619

   DOMETHODA(fractobj, [MUIM_Fract_GetParams, rendermsg.parameters])

   DEBUGF('newdisplayWin() / NewObjectA()\n')
   win := NewObjectA(data.dispwinmcc.mcc_class,
                           NIL,
                           [MUIA_DispWin_IgniteHook, data.hook,
                            MUIA_DispWin_RenderMsg, rendermsg,
                            MUIA_Window_Title, XGET(fractobj, MUIA_Fract_Name),
                            NIL])
   DEBUGF('newdisplayWin() / NewObjectA() DONE win=$\h\n', win)

   IF win = NIL THEN Raise("WIN")

   DOMETHODA(win, [MUIM_Notify, MUIA_Window_Activate, MUIV_EveryTime,
         win, 4, MUIM_CallHook, data, IH_WINACTIVE, MUIV_TriggerValue])


   DOMETHODA(data.selfobj, [OM_ADDMEMBER, win])

   set(win, MUIA_Window_Open, MUI_TRUE)

   set(win, MUIA_Window_Activate, MUI_TRUE)

   DEBUGF('newDisplayWin() ok\n')

EXCEPT

   SetIoErr(exception)

   DEBUGF('newDisplayWin() failed\n')

   IF rendermsg
      CloseDevice(rendermsg)
      IF rendermsg.parameters THEN FreeVec(rendermsg.parameters)
      DeleteIORequest(rendermsg)
   ENDIF

   RETURN NIL

ENDPROC win

PROC openFractPlugsWin(data:PTR TO ignitedata) IS NIL

PROC miscFunc(rm:PTR TO rendermsg, mfid, p1, p2, p3)
   DEF redrawmsg:PTR TO redrawmsg, data:PTR TO ignitedata
   DEF msg[10]:ARRAY OF LONG

   SELECT mfid
   CASE MF_PUSHREDRAW     /* typically called from fractal custom class (subtask) */

       DEBUGF('MF_PUSHREDRAW\n')
        redrawmsg := p1
        -> in the exrtemely nlikely event that the redrawmessage
        -> has not been handled by main-task yet, busywait until done.
        -> should not happen because subtaks runs at pri -1.
        WHILE redrawmsg.flags AND RDF_BUSY DO NOP
        msg[0] := MUIM_Application_PushMethod
        msg[1] := rm.zoneviewobj
        msg[2] := 2
        msg[3] := MUIM_Zoneview_Redraw_Msg
        msg[4] := redrawmsg
        DOMETHODA(rm.igniteobj, msg)

   CASE MF_PUSHSTATUSTXT  /* typically called from fractal custom class (subtask) */

      DEBUGF('MF_PUSHSTATUSTXT\n')

      data := INST_DATA(rm.igniteobj[-1].class, rm.igniteobj)

      msg[0] := MUIM_Application_PushMethod
      msg[1] := data.statusobj
      msg[2] := 3
      msg[3] := MUIM_Set
      msg[4] := MUIA_Text_Contents
      msg[5] := p1
      DOMETHODA(data.selfobj, msg)

   CASE MF_PUSHGAUGE   /* typically called from fractal custom class (subtask) */

      DEBUGF('MF_PUSHGAUGE\n')

      data := INST_DATA(rm.igniteobj[-1].class, rm.igniteobj)

       -> p1 = 0-100 %
      msg[0] := MUIM_Application_PushMethod
      msg[1] := data.gaugeobj
      msg[2] := 3
      msg[3] := MUIM_Set
      msg[4] := MUIA_Gauge_Current
      msg[5] := p1
      DOMETHODA(data.selfobj, msg)

   CASE MF_PUSHRENDERDONE   /* typically called from fractal custom class (subtask) */

      DEBUGF('MF_PUSHRENDERDONE\n')

      msg[0] := MUIM_Application_PushMethod
      msg[1] := rm.object
      msg[2] := 1
      msg[3] := MUIM_Fract_RenderDone
      DOMETHODA(rm.igniteobj, msg)

   ENDSELECT

ENDPROC

PROC igniteHandler(data:PTR TO ignitedata, obj:PTR TO object, msg:PTR TO LONG)
   DEF r:PTR TO rendermsg, err, fract
   DEF list:PTR TO lh, head, win, count, node, a, size
   DEF str[300]:STRING

   DEBUGF('igniteHandler() \d\n', msg[])


   SELECT msg[]

     /* private */

   CASE IH_WINACTIVE

      IF msg[1] -> activated ?

         IF XGET(obj, MUIA_DispWin_IsDispWin)

            win := existsDispWin(data.selfobj, data.lastdispwinactive)
            IF win
               -> read gui of current plugin and set the last active
               -> dispwin with theese, before it all gets overwritten ..
               r := XGET(win, MUIA_DispWin_RenderMsg)
               DOMETHODA(r.object, [MUIM_Fract_GetParams, r.parameters])
            ENDIF

            data.lastdispwinactive := obj

            r := XGET(obj, MUIA_DispWin_RenderMsg)
            DOMETHODA(r.object, [MUIM_Fract_SetParams, r.parameters])

            fract := r.object
            list := XGET(data.fractpage, MUIA_Group_ChildList)
            head := list.head
            count := 0
            WHILE node := NextObject({head})
               EXIT node = fract
               count++
            ENDWHILE
            nnset(data.fractpage, MUIA_Group_ActivePage, count)

        ELSEIF XGET(obj, MUIA_ObjectID) = "MAIN"

            -> lets make some dispwin "active"
            list := XGET(data.selfobj, MUIA_Application_WindowList)
            head := list.head
            WHILE node := NextObject({head})
               IF XGET(node, MUIA_DispWin_IsDispWin)
                  data.lastdispwinactive := node
                  RETURN
               ENDIF
            ENDWHILE

        ENDIF


     ENDIF

   /* call this one (threw pushmethod) to remove and delete your own win */

   CASE IH_DELETEWIN
         DEBUGF('IH_DELETEWIN\n')

         DOMETHODA(data.selfobj, [OM_REMMEMBER, obj])
         Mui_DisposeObject(obj)

   /* main gui */

   CASE IH_RENDER

      win := existsDispWin(data.selfobj, data.lastdispwinactive)

      IF win
         a := DOMETHODA(win, [MUIM_DispWin_Render])
         IF a THEN set(data.statusobj, MUIA_Text_Contents, a)
      ELSE
         set(data.statusobj, MUIA_Text_Contents, 'No zone window !')
      ENDIF

   CASE IH_STOP

      win := existsDispWin(data.selfobj, data.lastdispwinactive)

      IF win
         DOMETHODA(win, [MUIM_DispWin_StopRender])
      ELSE
         set(data.statusobj, MUIA_Text_Contents, 'No zone window !')
      ENDIF

   CASE IH_MENU

      SELECT msg[1]
      CASE MViewWin
         IF openDisplayWin(data) = NIL
            set(data.statusobj, MUIA_Text_Contents, 'Failed to open zone window !')
         ENDIF
      CASE MSaveCurrView
         win := existsDispWin(data.selfobj, data.lastdispwinactive)
         IF win
             r := XGET(win, MUIA_DispWin_RenderMsg)
             a, size := makePNG32(r.display.width,
                                  r.display.height,
                                  r.display.rendbuf,
                                  r.display.rendbuf + 1,
                                  r.display.rendbuf + 2,
                                  NIL, -> no alpha
                                  3,
                                  5)
            IF a
               IF writeNewFile(a,size,'t:test.png') = NIL
                  set(data.statusobj, MUIA_Text_Contents, 'Failed to write file !')
               ELSE
                  StringF(str, 'Wrote \d bytes !\n', size)
                  set(data.statusobj, MUIA_Text_Contents, str)
               ENDIF
               freePNG(a)
            ELSE
               set(data.statusobj, MUIA_Text_Contents, 'Failed to create save image !')
            ENDIF
         ELSE
            set(data.statusobj, MUIA_Text_Contents, 'No zone window !')
         ENDIF
      DEFAULT
         IF msg[1] >= 1000 -> fractal plugin change
            set(data.fractpage, MUIA_Group_ActivePage, msg[1]-1000)
            win := existsDispWin(data.selfobj, data.lastdispwinactive)
            IF win
               r := XGET(win, MUIA_DispWin_RenderMsg)
               node := findPageNum(data.fractpage, msg[1]-1000)
               ABORTRMSG(r)
               WAITRMSG(r)
               r.object := node
               FreeVec(r.parameters)
               a := XGET(node, MUIA_Fract_ParameterSize)
               r.parameters := AllocVec(a, MEMF_CLEAR OR MEMF_PUBLIC)
               r.job.jobfunc := XGET(node, MUIA_Fract_RenderFunc)
               a := DOMETHODA(win, [MUIM_DispWin_Render])
               set(win, MUIA_Window_Title, XGET(node, MUIA_Fract_Name))
               IF a THEN set(data.statusobj, MUIA_Text_Contents, a)
            ENDIF
         ENDIF
      ENDSELECT

   ENDSELECT
ENDPROC

PROC writeNewFile(buf,size, name)
   DEF fh
   fh := Open(name, NEWFILE)
   IF fh = NIL THEN RETURN NIL
   IF Write(fh, buf, size) <> size THEN RETURN NIL
   Close(fh)
ENDPROC size

PROC findPageNum(pagegroup, index)
   DEF list:PTR TO mlh, head, count=0, obj
   list := XGET(pagegroup, MUIA_Group_ChildList)
   head := list.head
   WHILE obj := NextObject({head})
      EXIT count = index
      count++
   ENDWHILE
ENDPROC obj

PROC existsDispWin(app, win)
   DEF list:PTR TO mlh, head, obj
   list := XGET(app, MUIA_Application_WindowList)
   head := list.head
   WHILE obj := NextObject({head})
      IF obj = win
         IF XGET(obj, MUIA_DispWin_IsDispWin) THEN RETURN win
      ENDIF
   ENDWHILE
ENDPROC NIL

PROC plotRGB(rm:PTR TO rendermsg, x, y, r:REAL, g:REAL, b:REAL)
   DEF data:PTR TO ignitedata, rgb:PTR TO CHAR

   data := INST_DATA(rm.igniteobj[-1].class, rm.igniteobj)

            IF !r >1.0 THEN r := 1.0
            IF !g >1.0 THEN g := 1.0
            IF !b >1.0 THEN b := 1.0

            SELECT data.expmod
            CASE 0 -> none
            CASE 1 -> square
               r := !r * r
               g := !g * g
               b := !b * b
            CASE 1 -> qube
               r := !r * r * r
               g := !g * g * g
               b := !b * b * b
            CASE 3 -> Square Root
               r := !Fsqrt(r)
               g := !Fsqrt(g)
               b := !Fsqrt(b)
            CASE 4 -> exp
               r := !Fexp(r) - 1.0 * (!1.0 / 1.71828)
               g := !Fexp(g) - 1.0 * (!1.0 / 1.71828)
               b := !Fexp(b) - 1.0 * (!1.0 / 1.71828)
            CASE 5 -> log
               r := !Flog(!r+1.0)
               g := !Flog(!g+1.0)
               b := !Flog(!b+1.0)
            ENDSELECT

            r := ! r * (100 + data.brightness!*0.01)
            g := ! g * (100 + data.brightness!*0.01)
            b := ! b * (100 + data.brightness!*0.01)

            IF !r >1.0 THEN r := 1.0
            IF !g >1.0 THEN g := 1.0
            IF !b >1.0 THEN b := 1.0

            IF data.invert
               r := !1.0 - r
               g := !1.0 - g
               b := !1.0 - b
            ENDIF


   rgb := rm.display.rendbuf + (y*rm.display.width+x*3)
   rgb[]++ := ! r * 255.0 !
   rgb[]++ := ! g * 255.0 !
   rgb[]++ := ! b * 255.0 !

ENDPROC

PROC setRedrawArea(rm:PTR TO rendermsg, rdm:PTR TO redrawmsg, r:REAL, g:REAL, b:REAL)
   DEF ptr, xlen, ir, ig, ib, skip, numlines
   DEF data:PTR TO ignitedata

   data := INST_DATA(rm.igniteobj[-1].class, rm.igniteobj)

   ir := !r*256.0!
   ig := !g*256.0!
   ib := !b*256.0!
   IF data.invert
      ir := 255 - ir
      ig := 255 - ig
      ib := 255 - ib
   ENDIF
   ptr := rm.display.rendbuf + (rdm.top*rm.display.width+rdm.left*3)
   skip := rm.display.width - rdm.width * 3
   numlines := rdm.height
   WHILE numlines
      numlines--
      xlen := rdm.width
      WHILE xlen
         xlen--
         ptr[]++ := ir
         ptr[]++ := ig
         ptr[]++ := ib
      ENDWHILE
      ptr := ptr + skip
   ENDWHILE
ENDPROC

PROC scanFractPlugNames(dir) HANDLE
   DEF lock=NIL, info:fileinfoblock, str, strlist=NIL
   IF (lock := Lock(dir, SHARED_LOCK)) = NIL THEN Raise("LOCK")
   IF Examine(lock,info) = NIL THEN Raise("EXAM")
   IF info.direntrytype >= 0
      WHILE ExNext(lock,info)
         IF info.direntrytype = ST_FILE
            IF StrLen(info.filename) > 13
               IF StrCmp(info.filename, 'fract_', STRLEN)
                  IF StrCmp(info.filename+StrLen(info.filename)-7, '.plugin')
                     str := String(StrLen(info.filename))
                     IF str
                        StrCopy(str, info.filename)
                        Link(str, strlist)
                        strlist := str
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDWHILE
   ENDIF

EXCEPT DO
   IF lock THEN UnLock(lock)
   SELECT exception
   CASE NIL
   CASE "LOCK" ; WriteF('could not lock dir "\s"', dir)
   CASE "EXAM" ; WriteF('could not examine dir "\s"', dir)
   DEFAULT     ; WriteF('unknown error scanning dir "\s"', dir)
   ENDSELECT

ENDPROC strlist

PROC makeFractPlugName(name)
   DEF str[256]:STRING, item=NIL
   DEF fractmcc=NIL:PTR TO mui_customclass, fractobj=NIL
   DEF fract_pluginbase=NIL

   StringF(str, 'PROGDIR:fractplugs/\s', name)
   fract_pluginbase := OpenLibrary(str, 0)
   IFN fract_pluginbase THEN RETURN NIL

   fractmcc := FractCreateGUIClass()
   IFN fractmcc
      CloseLibrary(fract_pluginbase)
      RETURN NIL
   ENDIF

   fractobj := NewObjectA(fractmcc.mcc_class, NIL, [NIL])
   IFN fractobj
      Mui_DeleteCustomClass(fractmcc)
      CloseLibrary(fract_pluginbase)
      RETURN NIL
   ENDIF

ENDPROC fractobj
