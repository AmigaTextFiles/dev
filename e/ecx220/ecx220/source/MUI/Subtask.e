/*
**  Original C Code written by Stefan Stuntz
**
**  Translation into E by Klaus Becker
**
**  All comments are from the C-Source
*/

/* Remember the following note from Wouter:
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"[note: v3.1 (v40) of the amiga operating system is known to contain
 a bug in the IEEE code. Be sure to run a SetPatch that fixes this]"
*/

/*

This little demo show how to write classes which need a long
time to render their contents. In this case, we take a little
fractal algorithm as example. The actual calculations are
done in a separate task, the display is updated from time
to time.

*/

-> ECX Note: Replaced some "BRA label" with EXIT
-> ECX Note: Removed storea4(),geta4() stuff.
-> ECX Note: Uses new functions NewProcess() and ReleaseSuccess()
-> ECX Note: askMinMax now uses += feature
-> ECX Note: requires ECX 1.5.4+.

OPT PREPROCESS


MODULE 'mui/muicustomclass',
       'tools/thread',
       'amigalib/boopsi'
MODULE 'muimaster','libraries/mui','libraries/muip',
       'graphics/gfx', 'intuition/classes','intuition/classusr',
       'intuition/screens','intuition/intuition',
       'dos/dostags','dos/dosextens','exec/memory','exec/semaphores',
       'graphics/rastport','exec/ports',
       'utility/tagitem','exec/tasks'


/* Pixel dimensions of our fractal */

CONST FRACTALWIDTH  = 300
CONST FRACTALHEIGHT = 300

/* Fractal Description */

OBJECT fractaldesc
  left:LONG
  right:LONG
  top:LONG
  bottom:LONG
ENDOBJECT


CONST MaxIterations = 60

/* Attributes and methods for the custom class */

CONST MUISERIALNR_STUNTZI = 1
CONST TAGBASE_STUNTZI = TAG_USER OR (MUISERIALNR_STUNTZI SHL 16)

CONST MUIM_Class4_Update = TAGBASE_STUNTZI OR 1

OBJECT muip_class4_update
  id,percent
ENDOBJECT

CONST MUIM_Class4_Calc = TAGBASE_STUNTZI OR 2

OBJECT muip_class4_calc
  id
  fd:PTR TO fractaldesc
ENDOBJECT

CONST MUIA_Class4_Percent = TAGBASE_STUNTZI OR 3

CONST STC_START = 0
CONST STC_STOP = 1

/* Instance Data for the fractal class */

OBJECT data
  sema:ss                 /* data item protection      */
  app                     /* pointer to application    */
  self                    /* pointer to ourselves      */
  subtask:PTR TO subtask  /* our sub task              */
  rp:rastport             /* rastport FOR the sub task */
  udlines:PTR TO CHAR     /* line update flags ARRAY   */
ENDOBJECT

/**************************************************************/
/* Functions for easy and secure spawning/killing of subtasks */
/**************************************************************/

ENUM STERR_NONE, STERR_PORT

OBJECT subtaskmsg
   stm_Message:mn
   stm_Command:INT
   stm_Parameter:LONG
   stm_Result:LONG
ENDOBJECT

OBJECT subtask
  st_Task:PTR TO tc      /* sub task pointer */
  st_Port:PTR TO mp      /* allocated by sub task */
  st_Reply:PTR TO mp     /* allocated by main task */
  st_Data:LONG           /* more initial data to pass to the sub task */
  st_Message:subtaskmsg  /* Message buffer */
ENDOBJECT

CONST STC_SHUTDOWN = -1

PROC sendsubtaskmsg(st:PTR TO subtask,command,params)

  st.st_Message.stm_Message.replyport:= st.st_Reply
  st.st_Message.stm_Message.length   := SIZEOF subtaskmsg
  st.st_Message.stm_Command          := command
  st.st_Message.stm_Parameter        := params
  st.st_Message.stm_Result           := 0

  PutMsg(st.st_Port,st.st_Message)
  WaitPort(st.st_Reply)
  GetMsg(st.st_Reply)
ENDPROC (st.st_Message.stm_Result)

PROC spawnsubtask(name,func,data:PTR TO data)
  DEF st=NIL:PTR TO subtask, t, err


  IF st := New(SIZEOF subtask)
    st.st_Reply := CreateMsgPort()
    IF (st.st_Reply)
      st.st_Data:=data
      t, err := newProcess(func, -1, name, st)
      IF t
        st.st_Task := t
        RETURN st
      ENDIF
      DeleteMsgPort(st.st_Reply)
    ENDIF
    Dispose(st)
  ENDIF

ENDPROC NIL

PROC killsubtask(st:PTR TO subtask)
  sendsubtaskmsg(st,STC_SHUTDOWN,st)
  DeleteMsgPort(st.st_Reply)
  Dispose(st)
ENDPROC

PROC exitsubtask(st:PTR TO subtask,stm:PTR TO subtaskmsg)
  /*
  ** We reply after a Forbid() to make sure we're really gone
  ** when the main task continues.
  */
  IF (st.st_Port) THEN DeleteMsgPort(st.st_Port)
  Forbid()
  stm.stm_Result:= FALSE
  ReplyMsg(stm)
ENDPROC


/*******************************************************/
/* Subtask which does all the time-consuming rendering */
/*******************************************************/

PROC renderfunc(private, st:PTR TO subtask)
  DEF data=NIL:PTR TO data
  DEF running=TRUE,worktodo=FALSE,x,y
  DEF stm=NIL:PTR TO subtaskmsg
  DEF left,top,right,bottom
  DEF zr,zi,cr,ci,rr,ii
  DEF counter
  DEF command,i
  DEF float[20]:STRING

  -> ECX Note: make initialisations
  st.st_Port := CreateMsgPort()
  IF st.st_Port = NIL THEN RETURN STERR_PORT

  -> all okey, tell mother to continiue
  releaseSuccess(private)

      data:= st.st_Data
      LOOP
        /*
        ** after the sub task is up and running, we go into
        ** a loop and process the messages from the main task.
        */
        WHILE (stm:= GetMsg(st.st_Port))
          command:=stm.stm_Command
          SELECT command
            CASE STC_SHUTDOWN
              /*
              ** This is the shutdown message from KillSubTask().
              */
              running:= FALSE
            CASE STC_START
              /*
              ** we received a start message with a fractal description.
              ** clear the rastport and the line update array and start
              ** rendering.
              */
              SetRast(data.rp,1)
              FOR i:=0 TO FRACTALHEIGHT-1 DO data.udlines[i]:=0
              left   := stm.stm_Parameter::fractaldesc.left
              top    := stm.stm_Parameter::fractaldesc.top
              right  := stm.stm_Parameter::fractaldesc.right
              bottom := stm.stm_Parameter::fractaldesc.bottom
              y:=0
              worktodo:= TRUE
            CASE STC_STOP
              /* this message is not used in this example */
              worktodo:= FALSE
          ENDSELECT
          /*
          ** If we received a shutdown message, we do not reply it
          ** immediately. First, we need to free our resources.
          */
          EXIT running = FALSE
          ReplyMsg(stm.stm_Message)
        ENDWHILE
        EXIT running = FALSE
        IF (worktodo)
          /* if there is work to do, i.e. if the fractal is not
          ** finished yet, we calculate the next line and draw
          ** it to the offscreen rastport.
          */
          FOR x:=0 TO (FRACTALWIDTH-1)
            zr:= 0.0
            zi:= 0.0
            cr:= !left+(!x*(!right - left)/FRACTALWIDTH )
            ci:= !top+ (!y*(!bottom - top)/FRACTALHEIGHT )
            rr:= !zr*zr
            ii:= !zi*zi
            FOR counter:=0 TO MaxIterations-1
              zi:=!ci + (!zr*zi*2.0)
              zr:=!cr + rr - ii
              rr:=!zr*zr
              ii:=!zi*zi
              IF (!rr+ii>4.0)
                /*
                ** set the pixel in the offscreen rastport.
                ** this demo is kind of dirty, as it does no
                ** nice color allocation and palette stuff.
                ** dont be so dirty in your own programs! :-)
                */
                SetAPen(data.rp,1+counter)
                WritePixel(data.rp,x,y)
                JUMP next->BRA next
              ENDIF
              INC counter
              EXIT (counter=MaxIterations)
            ENDFOR
next:
          ENDFOR
          /*
          ** after the line is finished, we set the corresponding
          ** flag in the line update array to FALSE. This shows the
          ** main task that this line needs to be redrawn the next
          ** time it gets the chance.
          */

          ObtainSemaphore(data.sema)
          data.udlines[y]:= FALSE
          IF (data.app)
            /*
            ** if our class is attached to an application, we send ourselves
            ** an update method. Note that because we are in a separate task,
            ** we cannot send this method directly but instead have to use
            ** the MUIM_Application_PushMethod call. This is the only method
            ** that you may send to a MUI object from a separate task. What it
            ** does is to copy the method to a private buffer and wait until
            ** the next time the main task calls the input method. Then, our
            ** update method will be executed under the main tasks context.
            **
            ** If our class is not attached to an application
            ** (i.e. we are outside of MUIM_Setup/MUIM_Cleanup), there is
            ** nobody who could render something anyway so we just skip
            ** the update method and continue to render in our private
            ** buffer.
            */
            -> Gauge
            doMethodA(data.app,[ MUIM_Application_PushMethod,
                  data.self,2,MUIM_Class4_Update,(100*(y+1)/FRACTALHEIGHT)])
          ENDIF
          ReleaseSemaphore(data.sema)
          y++
          IF (y=FRACTALHEIGHT)
            /* check if we are finished to draw our fractal */
            worktodo:= FALSE
          ENDIF
          /* Since we are very busy working, we do not Wait() for signals. */
        ELSE
          /* We have nothing to do, just sit quietly and wait for something to happen */
          WaitPort(st.st_Port)
        ENDIF
      ENDLOOP
      exitsubtask(st,stm)

ENDPROC STERR_NONE -> important !

PROC mNew(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
  DEF data=NIL:PTR TO data

  IF (obj:=doSuperMethodA(cl,obj,msg))=NIL THEN RETURN 0

  data:= INST_DATA(cl,obj)

  /* store a pointer to ourselves so the subtask knows about us */
  data.self:= obj

  /*
  ** initialization and allocation of data structures.
  ** note that if something fails here, we *must* do a
  ** CoerceMethod(cl,obj,OM_DISPOSE) to give ourselves
  ** (and MUI!) a chance to clean up.
  */

  InitSemaphore(data.sema)
  InitRastPort(data.rp)

  data.udlines:= AllocVec(FRACTALHEIGHT,MEMF_CLEAR)
  IF (data.udlines)
    data.rp.bitmap:= AllocBitMap(FRACTALWIDTH,FRACTALHEIGHT,8,BMF_CLEAR,NIL)
    IF (data.rp.bitmap)
      SetRast(data.rp,1)

      /* the following call starts the sub task */

      data.subtask:= spawnsubtask('Class4-Render-Task',{renderfunc},data)
      IF data.subtask
        RETURN obj
      ENDIF
    ENDIF
  ENDIF
  coerceMethodA(cl,obj,OM_DISPOSE)
ENDPROC NIL

PROC mDispose(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
  DEF data:PTR TO data
  data:=INST_DATA(cl,obj)
  IF data.subtask THEN killsubtask(data.subtask)
  IF data.rp.bitmap THEN FreeBitMap(data.rp.bitmap)
  IF data.udlines THEN FreeVec(data.udlines)
ENDPROC doSuperMethodA(cl,obj,msg)

/*
** AskMinMax method will be called before the window is opened
** and before layout takes place. We need to tell MUI the
** minimum, maximum and default size of our object.
*/

PROC mAskMinMax(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_askminmax)
  /*
  ** let our superclass first fill in what it thinks about sizes.
  ** this will e.g. add the size of frame and inner spacing.
  */

  doSuperMethodA(cl,obj,msg)

  /*
  ** now add the values specific to our object. note that we
  ** indeed need to *add* these values, not just set them!
  */

  msg.minmaxinfo.minwidth += 10
  msg.minmaxinfo.defwidth += 100
  msg.minmaxinfo.maxwidth += FRACTALWIDTH

  msg.minmaxinfo.minheight += 10
  msg.minmaxinfo.defheight += 100
  msg.minmaxinfo.maxheight += FRACTALHEIGHT
ENDPROC NIL

/*
** Draw method is called whenever MUI feels we should render
** our object. This usually happens after layout is finished
** or when we need to refresh in a simplerefresh window.
** Note: You may only render within the rectangle
**       _mleft(obj), _mtop(obj), _mwidth(obj), _mheight(obj).
*/

PROC mDraw(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_draw)
  DEF data:PTR TO data
  DEF l

  data:=INST_DATA(cl,obj)

  /*
  ** let our superclass draw itself first, area class would
  ** e.g. draw the frame and clear the whole region. What
  ** it does exactly depends on msg.flags.
  **
  ** Note: You *must* call the super method prior to do
  ** anything else, otherwise msg.flags will not be set
  ** properly !!!
  */

  doSuperMethodA(cl,obj,msg)

  IF (msg.flags AND MADF_DRAWUPDATE)
    /*
    ** This flag indicates that we were called from our
    ** update method. We needn't render the complete
    ** image, we only need to update the lines that
    ** were changed. So what we do is to browse through
    ** the line flag array and blit each changed line
    ** from the offscreen buffer into the display.
    ** We could do a better and more efficient job
    ** by collecting subsequent changed lines to blit
    ** larger rectangles, but hey... this is only a demo! :-)
    */

    /*
    ** note the usage of semaphores to protect access
    ** to variables use by both tasks.
    */

    ObtainSemaphore(data.sema)
    FOR l:=0 TO _mheight(obj)-1
      IF (data.udlines[l])=NIL
        /*
        ** once we copied the line, we set the corresponding line flag
        ** to indicate that this line is uptodate and does not need
        ** to be redrawn the next time. When our sub task gets the message
        ** to calculate a new fractal, it will reset the flag to FALSE again.
        */

        BltBitMapRastPort(data.rp.bitmap,0,l,_rp(obj),_mleft(obj),_mtop(obj)+l,_mwidth(obj),1,$c0)
        data.udlines[l]:= TRUE
      ENDIF
    ENDFOR
    ReleaseSemaphore(data.sema)
  ELSEIF (msg.flags AND MADF_DRAWOBJECT)
    /*
    ** we were called directly from MUI because the window needs refresh.
    ** no need to care about our line array here, we just copy the complete
    ** offscreen buffer to our display.
    */
    ObtainSemaphore(data.sema)
    BltBitMapRastPort(data.rp.bitmap,0,0,_rp(obj),_mleft(obj),_mtop(obj),_mwidth(obj),_mheight(obj),$c0)
    ReleaseSemaphore(data.sema)
  ENDIF
ENDPROC NIL

PROC mSetup(cl:PTR TO iclass,obj,msg:PTR TO muip_handleinput)
  DEF data:PTR TO data
  DEF app
  data:=INST_DATA(cl,obj)
  IF (doSuperMethodA(cl,obj,msg))=NIL THEN RETURN FALSE

  /*
  ** set a pointer to our application in our instance data.
  ** this indicates the sub task that we should be notified
  ** when a new line is calculated.
  */

  ObtainSemaphore(data.sema)
  get(obj,MUIA_ApplicationObject,{app})
  data.app:=app
  ReleaseSemaphore(data.sema)
ENDPROC TRUE

PROC mCleanup(cl:PTR TO iclass,obj,msg:PTR TO muip_handleinput)
  DEF data:PTR TO data
  data:=INST_DATA(cl,obj)
  ObtainSemaphore(data.sema)
  data.app:=NIL
  ReleaseSemaphore(data.sema)
ENDPROC doSuperMethodA(cl,obj,msg)

/*
** a simple method that sends a START msg with
** fractal description packet to the sub task.
*/

PROC mCalc(cl:PTR TO iclass,obj,msg:PTR TO muip_class4_calc)
  DEF data:PTR TO data
  data:=INST_DATA(cl,obj)
  sendsubtaskmsg(data.subtask,STC_START,msg.fd)
ENDPROC NIL

/*
** thats the method that is called through MUIM_Application_PushMethod
** from the subtask.
*/

PROC mUpdate(cl:PTR TO iclass,obj,msg:PTR TO muip_class4_update)

  /* Tell MUI to redraw our object. Set the update flag
  ** so we know that only the changed lines are subject
  ** to render.
  */

  Mui_Redraw(obj,MADF_DRAWUPDATE)

  /*
  ** Also the the percentage attribute. The class itself doesnt
  ** have any use for this, but if we set it, its possible
  ** for other objects (e.g. a gauge) to receive notifications
  */

  set(obj,MUIA_Class4_Percent,msg.percent)

ENDPROC NIL

/*
** Here comes the dispatcher for our custom class.
** Unknown/unused methods are passed to the superclass immediately.
*/

PROC mydispatcher(cl:PTR TO iclass,obj,msg:PTR TO msg)
  DEF methodid
  methodid:=msg.methodid

  SELECT methodid
    CASE OM_NEW             ; RETURN mNew      (cl,obj,msg)
    CASE OM_DISPOSE         ; RETURN mDispose  (cl,obj,msg)
    CASE MUIM_AskMinMax     ; RETURN mAskMinMax(cl,obj,msg)
    CASE MUIM_Draw          ; RETURN mDraw     (cl,obj,msg)
    CASE MUIM_Setup         ; RETURN mSetup    (cl,obj,msg)
    CASE MUIM_Cleanup       ; RETURN mCleanup  (cl,obj,msg)
    CASE MUIM_Class4_Update ; RETURN mUpdate   (cl,obj,msg)
    CASE MUIM_Class4_Calc   ; RETURN mCalc     (cl,obj,msg)
  ENDSELECT

ENDPROC doSuperMethodA(cl,obj,msg)

/****************************************************************************/
/* Misc Help Functions                                                      */
/****************************************************************************/

PROC xget(obj,attribute)
  DEF x
  get(obj,attribute,{x})
ENDPROC x

PROC getstr(obj) IS xget(obj,MUIA_String_Contents)

/***************************************************************************/
/* Thats all there is about it. Now lets see how things are used...        */
/***************************************************************************/

PROC main() HANDLE
  DEF app,window,myObj
  DEF strleft,strtop,strright,strbottom,start,gauge
  DEF mcc=NIL:PTR TO mui_customclass
  DEF signals,running=TRUE,result
  DEF fd:fractaldesc

  IF (KickVersion(39)=FALSE) THEN
    Raise('runs only with V39 and up')
  IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN
    Raise('Failed to open muimasterlibrary')

   #ifdef __AMIGAOS4__
      IF (muimasteriface := GetInterface(muimasterbase, 'main', 1, NIL)) = NIL THEN
      Raise('failed to open muimaster.interface')
   #endif

  /* Create the new custom class with a call to eMui_CreateCustomClass(). */
  /* Caution: This function returns not a struct IClass, but a            */
  /* struct MUI_CustomClass which contains a struct IClass to be          */
  /* used with NewObjectA() calls.                                         */
  /* Note well: MUI creates the dispatcher hook for you, you may          */
  /* *not* use its h_Data field! If you need custom data, use the         */
  /* cl_UserData of the IClass structure!                                 */

  IF (mcc:= eMui_CreateCustomClass(NIL,MUIC_Area,NIL,SIZEOF data,{mydispatcher}))=NIL THEN
    Raise('Could not create custom class.')

  app:= ApplicationObject,
    MUIA_Application_Title      , 'Class4',
    MUIA_Application_Version    , '$VER: Class4 12.10 (21.11.95)',
    MUIA_Application_Copyright  , 'c1993, Stefan Stuntz',
    MUIA_Application_Author     , 'Stefan Stuntz & Klaus Becker',
    MUIA_Application_Description, 'Demonstrate rendering from sub tasks.',
    MUIA_Application_Base       , 'Class4',
    SubWindow, window:= WindowObject,
      MUIA_Window_Title, 'Subtask rendering',
      MUIA_Window_ID   , "CLS4",
      WindowContents, VGroup,
        Child, HGroup, GroupSpacing(8),
          Child, ColGroup(2),
            Child, Label2('_Left:'  ), Child, strleft   := Mui_MakeObjectA(MUIO_String,['_L',30]),
            Child, Label2('_Right:' ), Child, strright  := Mui_MakeObjectA(MUIO_String,['_R',30]),
          End,
          Child, ColGroup(2),
            Child, Label2('_Top:'   ), Child, strtop    := Mui_MakeObjectA(MUIO_String,['_T',30]),
            Child, Label2('_Bottom:'), Child, strbottom := Mui_MakeObjectA(MUIO_String,['_B',30]),
          End,
          Child, Mui_MakeObjectA(MUIO_VBar,[2]),
          Child, start := VGroup,
            GroupSpacing(0),
            MUIA_Weight, 0,
            ButtonFrame,
            MUIA_InputMode , MUIV_InputMode_RelVerify,
            MUIA_Background, MUII_ButtonBack,
            Child, VSpace(0),
            Child, TextObject, MUIA_Text_Contents, '\ec  Start  ', End,
            Child, VSpace(0),
          End,
        End,
        Child, gauge := GaugeObject,
          GaugeFrame,
          MUIA_Gauge_Horiz, MUI_TRUE,
          MUIA_Gauge_Max, 100,
          MUIA_FixHeight, 8,
        End,
        Child, myObj := NewObjectA(mcc.mcc_class,NIL,
          [TextFrame,
          MUIA_Background, MUII_BACKGROUND,
          TAG_DONE]),
      End,
    End,
  End

  IF (app=NIL) THEN Raise('Failed to create Application.')

  set(window,MUIA_Window_DefaultObject, myObj)

  doMethodA(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,
    app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

  doMethodA(start,[MUIM_Notify,MUIA_Pressed,FALSE,
    app,2,MUIM_Application_ReturnID,1])

  doMethodA(myObj,[MUIM_Notify,MUIA_Class4_Percent,MUIV_EveryTime,
    gauge,3,MUIM_Set,MUIA_Gauge_Current,MUIV_TriggerValue])

  set(strleft  ,MUIA_String_Contents,'-2.0')
  set(strright ,MUIA_String_Contents,'1.0')
  set(strtop   ,MUIA_String_Contents,'1.5')
  set(strbottom,MUIA_String_Contents,'-1.5')

/*
** Input loop...
*/

  set(window,MUIA_Window_Open,MUI_TRUE)

  WHILE running
    result:=doMethodA(app,[MUIM_Application_Input,{signals}])
    SELECT result
      CASE MUIV_Application_ReturnID_Quit
        running:= FALSE
      CASE 1  -> Start-Button
        fd.left   := RealVal(getstr(strleft  ))
        fd.right  := RealVal(getstr(strright ))
        fd.top    := RealVal(getstr(strtop   ))
        fd.bottom := RealVal(getstr(strbottom))
        IF (!fd.right > fd.left) AND (!fd.top > fd.bottom)
          doMethodA(myObj,[MUIM_Class4_Calc,fd])
        ELSE
          DisplayBeep(0)
        ENDIF
    ENDSELECT

    IF (running AND signals) THEN Wait(signals)
   ENDWHILE
   set(window,MUIA_Window_Open,FALSE)

/*
** Shut down...
*/
EXCEPT DO
  IF app THEN Mui_DisposeObject(app)     /* dispose all objects. */
  IF mcc THEN Mui_DeleteCustomClass(mcc) /* delete the custom class. */
  #ifdef __AMIGAOS4__
  IF muimasteriface THEN DropInterface(muimasteriface)
  #endif
  IF muimasterbase THEN CloseLibrary(muimasterbase)
  IF exception THEN WriteF('\s\n',exception)
ENDPROC



