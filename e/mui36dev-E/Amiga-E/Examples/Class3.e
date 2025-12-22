/*
** Demosource on how to use customclasses in E.
** Based on the C example 'Class3.c' by Stafan Stuntz.
** Translated TO E by Sven Steiniger
**
** Sorry FOR some uppercase words in the comments. This IS because OF
** my AutoCase-dictionary
*/

OPT PREPROCESS

MODULE 'muimaster','libraries/mui','libraries/muip',
       'intuition/classes','intuition/classusr','intuition/screens','intuition/intuition',
       'utility/tagitem',
       'amigalib/boopsi',
       'mui/muicustomclass'

/***************************************************************************/
/* Here is the beginning of our simple new class...                        */
/***************************************************************************/

/*
** This is the instance data for our custom class.
*/
 
OBJECT mydata
  x,y,sx,sy
ENDOBJECT


/*
** AskMinMax method will be called before the window is opened
** and before layout takes place. We need to tell MUI the
** minimum, maximum and default size of our object.
*/

PROC mAskMinMax(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_askminmax)

  /*
  ** let our superclass first fill in what it thinks about sizes.
  ** this will e.g. add the size OF frame and inner spacing.
  */

  doSuperMethodA(cl,obj,msg)

  /*
  ** now add the values specific TO our object. note that we
  ** indeed need TO *add* these values, not just set them!
  */

  msg.minmaxinfo.minwidth := msg.minmaxinfo.minwidth + 100
  msg.minmaxinfo.defwidth := msg.minmaxinfo.defwidth + 120
  msg.minmaxinfo.maxwidth := msg.minmaxinfo.maxwidth + 500

  msg.minmaxinfo.minheight := msg.minmaxinfo.minheight + 40
  msg.minmaxinfo.defheight := msg.minmaxinfo.defheight + 90
  msg.minmaxinfo.maxheight := msg.minmaxinfo.maxheight + 300

ENDPROC 0


/*
** Draw method is called whenever MUI feels we should render
** our object. This usually happens after layout is finished
** or when we need to refresh in a simplerefresh window.
** Note: You may only render within the rectangle
**       _mleft(obj), _mtop(obj), _mwidth(obj), _mheight(obj).
*/

PROC mDraw(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_draw)
DEF data:PTR TO mydata

  data:=INST_DATA(cl,obj)

  /*
  ** let our superclass draw itself first, area class would
  ** e.g. draw the frame and clear the whole region. What
  ** it does exactly depends on msg.flags.
  **
  ** Note: You *must* call the super method prior TO DO
  ** anything ELSE, otherwise msg.flags will not be set
  ** properly !!!
  */

  doSuperMethodA(cl,obj,msg)

  /*
  ** IF MADF_DRAWOBJECT isn't set, we shouldn't draw anything.
  ** MUI just wanted TO update the frame OR something like that.
  */

  IF (msg.flags AND MADF_DRAWUPDATE)  /* called from our input method */
    IF data.sx OR data.sy
      SetBPen(_rp(obj),_dri(obj).pens[SHINEPEN])
      ScrollRaster(_rp(obj),data.sx,data.sy,_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj))
      SetBPen(_rp(obj),0)
      data.sx:=0
      data.sy:=0
    ELSE
      SetAPen(_rp(obj),_dri(obj).pens[SHADOWPEN])
      WritePixel(_rp(obj),data.x,data.y)
    ENDIF
  ELSEIF (msg.flags AND MADF_DRAWOBJECT)
    SetAPen(_rp(obj),_dri(obj).pens[SHINEPEN])
    RectFill(_rp(obj),_mleft(obj),_mtop(obj),_mright(obj),_mbottom(obj))
  ENDIF
ENDPROC 0


PROC mSetup(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_handleinput)

  IF doSuperMethodA(cl,obj,msg)=NIL THEN RETURN FALSE
  Mui_RequestIDCMP(obj,IDCMP_MOUSEBUTTONS OR IDCMP_RAWKEY)

ENDPROC MUI_TRUE


PROC mCleanup(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_handleinput)

  Mui_RejectIDCMP(obj,IDCMP_MOUSEBUTTONS OR IDCMP_RAWKEY)

ENDPROC doSuperMethodA(cl,obj,msg)
 

/* in mSetup() we said that we want get a message IF mousebuttons OR keys pressed
** so we have TO define the input-handler
** Note : this IS really a good example, because it shows how TO use critical events
**        carefully:
**        IDCMP_MOUSEMOVE IS only needed when left-mousebutton IS pressed, so
**        we dont request this UNTIL we get a SELECTDOWN-message and we reject
**        IDCMP_MOUSEMOVE immeditly after we get a SELECTUP-message
*/

PROC mHandleInput(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO muip_handleinput)
#define _between(a,x,b) (((x)>=(a)) AND ((x)<=(b)))
#define _isinobject(x,y) (_between(_mleft(obj),(x),_mright(obj)) AND _between(_mtop(obj),(y),_bottom(obj)))

DEF data:PTR TO mydata,
    selectdummy

  data:=INST_DATA(cl,obj)

  IF selectdummy:=msg.muikey
    SELECT selectdummy
      CASE MUIKEY_LEFT   ; data.sx:=-1; Mui_Redraw(obj,MADF_DRAWUPDATE)
      CASE MUIKEY_RIGHT  ; data.sx:= 1; Mui_Redraw(obj,MADF_DRAWUPDATE)
      CASE MUIKEY_UP     ; data.sy:=-1; Mui_Redraw(obj,MADF_DRAWUPDATE)
      CASE MUIKEY_DOWN   ; data.sy:= 1; Mui_Redraw(obj,MADF_DRAWUPDATE)
    ENDSELECT
  ENDIF

  IF msg.imsg
    selectdummy:=msg.imsg.class
    SELECT selectdummy
      CASE IDCMP_MOUSEBUTTONS
        IF msg.imsg.code=SELECTDOWN
          IF _isinobject(msg.imsg.mousex,msg.imsg.mousey)
            data.x:=msg.imsg.mousex
            data.y:=msg.imsg.mousey
            Mui_Redraw(obj,MADF_DRAWUPDATE)

            -> only request IDCMP_MOUSEMOVE IF we realy need it
            Mui_RequestIDCMP(obj,IDCMP_MOUSEMOVE)
          ENDIF
        ELSE

          -> reject IDCMP_MOUSEMOVE because THEN lmb IS no longer pressed
          Mui_RejectIDCMP(obj,IDCMP_MOUSEMOVE)
        ENDIF
      CASE IDCMP_MOUSEMOVE
        IF _isinobject(msg.imsg.mousex,msg.imsg.mousey)
          data.x:=msg.imsg.mousex
          data.y:=msg.imsg.mousey
          Mui_Redraw(obj,MADF_DRAWUPDATE)
        ENDIF
    ENDSELECT
  ENDIF

ENDPROC doSuperMethodA(cl,obj,msg)

/*
** Here comes the dispatcher FOR our custom class.
** Unknown/unused methods are passed to the superclass immediately.
*/

PROC myDispatcher(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
DEF methodID

  methodID:=msg.methodid
  SELECT methodID
    CASE MUIM_AskMinMax    ;  RETURN mAskMinMax  (cl,obj,msg)
    CASE MUIM_Draw         ;  RETURN mDraw       (cl,obj,msg)
    CASE MUIM_HandleInput  ;  RETURN mHandleInput(cl,obj,msg)
    CASE MUIM_Setup        ;  RETURN mSetup      (cl,obj,msg)
    CASE MUIM_Cleanup      ;  RETURN mCleanup    (cl,obj,msg)
  ENDSELECT

ENDPROC doSuperMethodA(cl,obj,msg)



/***************************************************************************/
/* Thats all there is about it. Now lets see how things are used...        */
/***************************************************************************/

PROC main() HANDLE
DEF app=NIL,window,myobj,
    mcc=NIL:PTR TO mui_customclass,
    sigs=0

  IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN))=NIL THEN
     Raise('Failed TO open muimaster.library')


  /* Create the NEW custom class with a call TO MUI_CreateCustomClass(). */
  /* Caution: This function returns not a struct IClass, BUT a           */
  /* struct MUI_CustomClass which contains a struct IClass TO be         */
  /* used with NewObject() calls.                                        */
  /* Note well: MUI creates the dispatcher hook FOR you, you may         */
  /* *not* use its h_Data field! IF you need custom data, use the        */
  /* cl_UserData OF the IClass structure!                                */
 
  /* E-note: Create the NEW custom class with a call TO eMui_CreateCustomClass().*/
  /* Big thanks TO Jan Hendrik Schulz FOR creating eMui_CreateCustomClass()      */

  IF (mcc:=eMui_CreateCustomClass(NIL,MUIC_Area,NIL,SIZEOF mydata,{myDispatcher}))=NIL THEN
      Raise('Could not create custom class.')

  app:=ApplicationObject,
      MUIA_Application_Title      , 'Class3',
      MUIA_Application_Version    , '$VER: Class3 12.9 (21.11.95)',
      MUIA_Application_Copyright  , '©1995, Stefan Stuntz',
      MUIA_Application_Author     , 'Stefan Stuntz',
      MUIA_Application_Description, 'Demonstrate the use OF custom classes.',
      MUIA_Application_Base       , 'CLASS3',

      SubWindow, window:=WindowObject,
          MUIA_Window_Title, 'A rather complex custom class',
          MUIA_Window_ID   , "CLS3",
          WindowContents, VGroup,

              Child, TextObject,
                  TextFrame,
                  MUIA_Background, MUII_TextBack,
                  -> E-note : center this text means inserting a <ESC c> which IS usually \ec
                  MUIA_Text_Contents, '\ecPaint with mouse,\nscroll with cursor keys.',
                 End,

              Child, myobj:=NewObjectA(mcc.mcc_class,NIL,
                                [TextFrame,
                                 TAG_DONE,0]),


          End,

      End,
  End

  IF app=NIL THEN Raise('Failed TO create Application')

  set(window,MUIA_Window_DefaultObject,myobj)

  doMethodA(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,
            app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])


/*
** This is the ideal input loop for an object oriented MUI application.
** Everything is encapsulated in classes, no return ids need to be used,
** we just check if the program shall terminate.
** Note that MUIM_Application_NewInput expects sigs to contain the result
** from Wait() (or 0). This makes the input loop significantly faster.
*/

    set(window,MUIA_Window_Open,MUI_TRUE)

    WHILE Not(doMethodA(app,[MUIM_Application_NewInput,{sigs}]) = MUIV_Application_ReturnID_Quit)
      IF sigs THEN sigs := Wait(sigs)
    ENDWHILE

    set(window,MUIA_Window_Open,FALSE)

/*
** Shut down...
*/

EXCEPT DO
    IF app THEN Mui_DisposeObject(app)                /* dispose all objects. */
    IF mcc THEN Mui_DeleteCustomClass(mcc)            /* delete the custom class. */
    IF muimasterbase THEN CloseLibrary(muimasterbase) /* close library */
    IF exception THEN WriteF('\s\n',exception)
ENDPROC

