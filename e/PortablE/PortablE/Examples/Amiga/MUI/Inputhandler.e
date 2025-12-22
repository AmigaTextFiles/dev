/* An old E example converted to PortablE.
   From http://aminet.net/package/dev/e/mui36dev-E */

/*
**  Original C Code written by Stefan Stuntz
**
**  All comments taken from the c-source
**
**  Translation into E by Klaus Becker
**  
*/

OPT PREPROCESS, POINTER

MODULE 'exec', 'intuition'
MODULE 'amigalib/boopsi'
MODULE 'devices/timer'
MODULE 'exec/ports','exec/io'
MODULE 'intuition/classes', 'intuition/classusr'
MODULE 'muimaster', 'libraries/mui'
MODULE 'mui/muicustomclass'
MODULE 'utility/tagitem', 'utility/hooks'

TYPE PTIO IS PTR TO INTUIOBJECT

/* Instance Data */

OBJECT mydata
  port:PTR TO mp
  req:PTR TO timerequest
  ihnode:mui_inputhandlernode_timer
  index
ENDOBJECT

/* Attributes and methods for the custom class */

#define MUISERIALNR_STUNTZI 1
#define TAGBASE_STUNTZI (TAG_USER OR Shl(MUISERIALNR_STUNTZI,16))
#define MUIM_Class5_Trigger (TAGBASE_STUNTZI OR 1)

/* IO macros */

#define IO_SIGBIT(req)  (req::io.mn.replyport.sigbit)
#define IO_SIGMASK(req) (1 SHL IO_SIGBIT(req))

/* Some strings to display */

DEF lifeOfBrian:ILIST

/***************************************************************************/
/* Here is the beginning of our new class...                               */
/***************************************************************************/

PROC mNew(cl:PTR TO iclass, obj:PTIO, msg:PTR TO msg)
  DEF data:PTR TO mydata, port:PTR TO mp, req:PTR TO timerequest
  IF (obj := doSuperMethodA(cl, obj, msg) !!PTIO)=NIL THEN RETURN
  data := INST_DATA(cl, obj) ::mydata
  IF port := CreateMsgPort()
    data.port:=port
    IF req := CreateIORequest(data.port, SIZEOF timerequest)
      data.req:=req
      IF OpenDevice(TIMERNAME, UNIT_VBLANK, data.req.io, 0)=NIL
        data.ihnode.ihn_object  := obj
        data.ihnode.ihn_millis  := 1000
        data.ihnode.ihn_method  := MUIM_Class5_Trigger
        data.ihnode.ihn_flags   := MUIIHNF_TIMER

        data.index := 0
        RETURN
      ENDIF
    ENDIF
  ENDIF
  coerceMethodA(cl, obj, OM_DISPOSE)
ENDPROC obj

PROC mDispose(cl:PTR TO iclass, obj:PTIO, msg:PTR TO msg)
  DEF data:PTR TO mydata
  data := INST_DATA(cl, obj) ::mydata

  IF data.req
    IF data.req.io.device THEN CloseDevice(data.req.io)
    DeleteIORequest(data.req)
  ENDIF

  IF data.port THEN DeleteMsgPort(data.port)
ENDPROC doSuperMethodA(cl, obj, msg)

PROC mSetup(cl:PTR TO iclass, obj:PTIO, msg:PTR TO msg)
  DEF data:PTR TO mydata
  data := INST_DATA(cl, obj) ::mydata

  IF doSuperMethodA(cl, obj, msg)=NIL THEN RETURN FALSE
  data.req.io.command := TR_ADDREQUEST
  data.req.time.secs    := 1
  data.req.time.micro   := 0
  SendIO(data.req.io)
  doMethodA(_app(obj), [MUIM_Application_AddInputHandler, data.ihnode])
ENDPROC TRUE

PROC mCleanup(cl:PTR TO iclass, obj:PTIO, msg:PTR TO msg)
  DEF data:PTR TO mydata
  data := INST_DATA(cl, obj) ::mydata
  doMethodA(_app(obj), [MUIM_Application_RemInputHandler, data.ihnode])
  IF CheckIO(data.req.io)=NIL THEN AbortIO(data.req.io)
  WaitIO(data.req.io)
ENDPROC doSuperMethodA(cl, obj, msg)

PROC mTrigger(cl:PTR TO iclass, obj:PTIO, msg:PTR TO msg)
  DEF data:PTR TO mydata
  data := INST_DATA(cl, obj) ::mydata

  set(obj, MUIA_Text_Contents, lifeOfBrian[data.index])
  data.index := data.index+1
  IF lifeOfBrian[data.index]=NIL
    data.index := 0
    RETURN FALSE
  ENDIF
  msg := NIL	->dummy
ENDPROC FALSE

/*
** Here comes the dispatcher for our custom class.
*/

PROC myDispatcher(cl:PTR TO iclass, obj:PTIO, msg:PTR TO msg)
  DEF methodid
  methodid := msg.methodid
  SELECT methodid
    CASE OM_NEW             ; RETURN mNew    (cl, obj, msg)
    CASE OM_DISPOSE         ; RETURN mDispose(cl, obj, msg)
    CASE MUIM_Setup         ; RETURN mSetup  (cl, obj, msg)
    CASE MUIM_Cleanup       ; RETURN mCleanup(cl, obj, msg)
    CASE MUIM_Class5_Trigger; RETURN mTrigger(cl, obj, msg)
  ENDSELECT
ENDPROC doSuperMethodA(cl, obj, msg)

/***************************************************************************/
/* Thats all there is about it. Now lets see how things are used...        */
/***************************************************************************/

PROC main()
  DEF app:PTIO, window:PTIO, myObj:PTIO, sigs
  DEF mcc:PTR TO mui_customclass
  app := NIL ; mcc := NIL

  IF (muimasterbase := OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN))=NIL THEN Throw("ERR", 'Failed to open muimaster.library')

  lifeOfBrian := ['Cheer up, Brian. You know what they say.',
                'Some things in life are bad,',
                'They can really make you mad.',
                'Other things just make you swear and curse.',
                'When you\are chewing on life\as grissle,',
                'Don\at grumble, give a whistle.',
                'And this\all help things turn out for the best,',
                'And...',
                'Always look on the bright side of life',
                'Always look on the light side of life',
                'If life seems jolly rotten,',
                'There\as something you\ave forgotten,',
                'And that\as to laugh, and smile, and dance, and sing.',
                'When you\are feeling in the dumps,',
                'Don\at be silly chumps,',
                'Just purse your lips and whistle, that\as the thing.',
                'And...',
                'Always look on the bright side of life, come on!',
                'Always look on the right side of life',
                'For life is quite absurd,',
                'And death\as the final word.',
                'You must always face the curtain with a bow.',
                'Forget about your sin,',
                'Give the audience a grin.',
                'Enjoy it, it\as your last chance anyhow,',
                'So...',
                'Always look on the bright side of death',
                'Just before you draw your terminal breath.',
                'Life\as a piece of shit,',
                'When you look at it.',
                'Life\as a laugh, and death\as a joke, it\as true.',
                'You\all see it\as all a show,',
                'Keep \aem laughing as you go,',
                'Just remember that the last laugh is on you.',
                'And...',
                'Always look on the bright side of life !',  
                '...',
                '*** THE END ***',
                '',
                NIL]

  /* Create the new custom class with a call to eMui_CreateCustomClass(). */
  /* Caution: This function returns not a struct iclass, but a            */
  /* struct mui_customclass which contains a struct iclass to be          */
  /* used with NewObjectA() calls.                                        */
  /* Note well: MUI creates the dispatcher hook for you, you may          */
  /* *not* use its h_Data field! If you need custom data, use the         */
  /* cl_UserData of the iclass structure!                                 */

  IF (mcc := eMui_CreateCustomClass(NIL, MUIC_Text, NIL, SIZEOF mydata, CALLBACK myDispatcher()))=NIL THEN Throw("ERR", 'Could not create custom class.')
  app := ApplicationObject,
    MUIA_Application_Title      , 'Class5',
    MUIA_Application_Version    , '$VER: Class5 13.57 (30.01.96)',
    MUIA_Application_Copyright  , 'c1993, Stefan Stuntz',
    MUIA_Application_Author     , 'Stefan Stuntz & Klaus Becker',
    MUIA_Application_Description, 'Demonstrate the use of custom classes.',
    MUIA_Application_Base       , 'Class5',
    SubWindow, window := WindowObject,
      MUIA_Window_Title, 'Input Handler Class',
      MUIA_Window_ID   , "CLS5",
      WindowContents, VGroup,
        Child, TextObject,
          TextFrame,
          MUIA_Background, MUII_TextBack,
          MUIA_Text_Contents, '\ecDemonstration of a class that reacts on\nevents (here: timer signals) automatically.',
        End,
        Child, myObj := NewObjectA(mcc.mcc_class,NILA,
          [TextFrame,
          MUIA_Background, MUII_BACKGROUND,
          MUIA_Text_PreParse, '\ec',
          TAG_END]:tagitem),
      End,
    End,
  End

  IF app=NIL THEN Throw("ERR", 'Failed to create Application.')

  doMethodA(window, [MUIM_Notify, MUIA_Window_CloseRequest,MUI_TRUE,
    app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

/*
** This is the ideal input loop for an object oriented MUI application.
** Everything is encapsulated in classes, no return ids need to be used,
** we just check if the program shall terminate.
** Note that MUIM_Application_NewInput expects sigs to contain the result
** from Wait() (or 0). This makes the input loop significantly faster.
*/

  set(window, MUIA_Window_Open,MUI_TRUE)
  
  sigs := 0
  WHILE doMethodA(app, [MUIM_Application_NewInput, ADDRESSOF sigs]) <> MUIV_Application_ReturnID_Quit
    IF sigs THEN sigs := Wait(sigs)
  ENDWHILE
  set(window, MUIA_Window_Open,FALSE)

/*
** Shut down...
*/

FINALLY
  IF app THEN Mui_DisposeObject(app)     /* dispose all objects. */
  IF mcc THEN Mui_DeleteCustomClass(mcc) /* delete the custom class. */
  IF exceptionInfo THEN Print('\s\n', exceptionInfo)
ENDPROC
