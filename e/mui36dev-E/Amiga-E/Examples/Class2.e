/*
** Demosource on how to use customclasses in E.
** Based on the C example 'Class2.c' by Stafan Stuntz.
** Translated TO E by Sven Steiniger
**
** Sorry FOR some uppercase words in the comments. This IS because OF
** my AutoCase-dictionary
*/

OPT PREPROCESS

MODULE 'muimaster','libraries/mui','libraries/muip',
       'intuition/classes','intuition/classusr','intuition/screens','intuition/intuition',
       'utility','utility/tagitem',
       'amigalib/boopsi',
       'mui/muicustomclass'

/***************************************************************************/
/* Here is the beginning of our simple new class...                        */
/***************************************************************************/

/*
** This class is the same as within Class1.c except that it features
** a pen attribute.
*/
 
OBJECT mydata
    penspec:mui_penspec
    pen:LONG
    penchange
ENDOBJECT

CONST MYATTR_PEN=$8022   /* tag value for the new attribute.            */
 

PROC mNew(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO opset)
DEF data:PTR TO mydata,
    tags:PTR TO tagitem,
    tag:PTR TO tagitem

  IF (obj:=doSuperMethodA(cl,obj,msg))=NIL THEN RETURN 0

  data:=INST_DATA(cl,obj)

  /* parse initial taglist */
  tags:=msg.attrlist
  WHILE tag:=NextTagItem({tags})
    IF tag.tag=MYATTR_PEN THEN
      IF tag.data THEN CopyMem(tag.data,data.penspec,SIZEOF mui_penspec)
  ENDWHILE

ENDPROC obj


/* OM_NEW didnt allocates something, just DO nothing here... */

PROC mDispose(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg) IS
  doSuperMethodA(cl,obj,msg)


PROC mSet(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO opset)
DEF data:PTR TO mydata,
    tags:PTR TO tagitem,
    tag:PTR TO tagitem

  data:=INST_DATA(cl,obj)
  tags:=msg.attrlist
  WHILE tag:=NextTagItem({tags})
    IF tag.tag=MYATTR_PEN THEN
      IF tag.data
        CopyMem(tag.data,data.penspec,SIZEOF mui_penspec)
        data.penchange:=TRUE
        Mui_Redraw(obj,MADF_DRAWOBJECT)  /* redraw ourselves completely */
      ENDIF
  ENDWHILE

ENDPROC doSuperMethodA(cl,obj,msg)


/*
** OM_GET method, see if someone wants to read the color.
*/

PROC mGet(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO opget)
DEF data:PTR TO mydata,storage

  IF msg.attrid=MYATTR_PEN
    data:=INST_DATA(cl,obj)
    storage:=msg.storage
    ^storage:=data.penspec
    RETURN MUI_TRUE
  ENDIF

ENDPROC doSuperMethodA(cl,obj,msg)


PROC mSetup(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
DEF data:PTR TO mydata

  IF doSuperMethodA(cl,obj,msg)=FALSE THEN RETURN FALSE
  data:=INST_DATA(cl,obj)
  data.pen:=Mui_ObtainPen(muiRenderInfo(obj),data.penspec,0)

ENDPROC MUI_TRUE


PROC mCleanup(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
DEF data:PTR TO mydata

  data:=INST_DATA(cl,obj)
  Mui_ReleasePen(muiRenderInfo(obj),data.pen)

ENDPROC doSuperMethodA(cl,obj,msg)

 
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
DEF data:PTR TO mydata,
    i

  data:=INST_DATA(cl,obj)

  /*
  ** let our superclass draw itself first, area class would
  ** e.g. draw the frame and clear the whole region. What
  ** it does exactly depends on msg.flags.
  */

  doSuperMethodA(cl,obj,msg)

  /*
  ** IF MADF_DRAWOBJECT isn't set, we shouldn't draw anything.
  ** MUI just wanted TO update the frame OR something like that.
  */

  IF (msg.flags AND MADF_DRAWOBJECT)=0 THEN RETURN 0

  /*
  ** test IF someone changed our pen
  */

  IF data.penchange
    data.penchange:=FALSE
    Mui_ReleasePen(muiRenderInfo(obj),data.pen)
    data.pen:=Mui_ObtainPen(muiRenderInfo(obj),data.penspec,0)
  ENDIF


  /*
  ** ok, everything ready TO render...
  ** Note that we *must* use the MUIPEN() macro before actually
  ** using pens from MUI_ObtainPen() in rendering calls.
  */

  SetAPen(_rp(obj),MUIPEN(data.pen))

  FOR i:=_mleft(obj) TO _mright(obj) STEP 5
    Move(_rp(obj),_mleft(obj),_mbottom(obj))
    Draw(_rp(obj),i,_mtop(obj))
    Move(_rp(obj),_mright(obj),_mbottom(obj))
    Draw(_rp(obj),i,_mtop(obj))
  ENDFOR

ENDPROC 0


/*
** Here comes the dispatcher FOR our custom class.
** Unknown/unused methods are passed to the superclass immediately.
*/

PROC myDispatcher(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
DEF methodID

  methodID:=msg.methodid
  SELECT methodID
    CASE OM_NEW          ;  RETURN mNew      (cl,obj,msg)
    CASE OM_DISPOSE      ;  RETURN mDispose  (cl,obj,msg)
    CASE OM_SET          ;  RETURN mSet      (cl,obj,msg)
    CASE OM_GET          ;  RETURN mGet      (cl,obj,msg)
    CASE MUIM_AskMinMax  ;  RETURN mAskMinMax(cl,obj,msg)
    CASE MUIM_Setup      ;  RETURN mSetup    (cl,obj,msg)
    CASE MUIM_Cleanup    ;  RETURN mCleanup  (cl,obj,msg)
    CASE MUIM_Draw       ;  RETURN mDraw     (cl,obj,msg)
  ENDSELECT

ENDPROC doSuperMethodA(cl,obj,msg)



/***************************************************************************/
/* Thats all there is about it. Now lets see how things are used...        */
/***************************************************************************/

PROC main() HANDLE
DEF app=NIL,window,myobj,pen,
    mcc=NIL:PTR TO mui_customclass,
    startpen:PTR TO mui_penspec,
    sigs=0

  IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN))=NIL THEN
     Raise('Failed TO open muimaster.library')

  /*
  ** open utility.library, because we need function NextTagItem()
  */
  IF (utilitybase:=OpenLibrary('utility.library',36))=NIL THEN
     Raise('Failed TO open utility.library')


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
      MUIA_Application_Title      , 'Class2',
      MUIA_Application_Version    , '$VER: Class2 12.9 (21.11.95)',
      MUIA_Application_Copyright  , '©1995, Stefan Stuntz',
      MUIA_Application_Author     , 'Stefan Stuntz',
      MUIA_Application_Description, 'Demonstrate the use OF custom classes.',
      MUIA_Application_Base       , 'CLASS2',

      SubWindow, window:=WindowObject,
          MUIA_Window_Title, 'Another Custom Class',
          MUIA_Window_ID   , "CLS2",
          WindowContents, VGroup,

              Child, TextObject,
                  TextFrame,
                  MUIA_Background, MUII_TextBack,
                  -> E-note : center this text means inserting a <ESC c> which IS usually \ec
                  MUIA_Text_Contents, '\ecThis IS a custom class with attributes.\nClick on the button at the bottom of\nthe window TO adjust the color.',
                 End,

              Child, myobj:=NewObjectA(mcc.mcc_class,NIL,
                                [TextFrame,
                                 MUIA_Background, MUII_BACKGROUND,
                                 TAG_DONE,0]),

              Child, HGroup, MUIA_Weight, 10,
                  Child, FreeLabel('Custom Class Color:'),
                  Child, pen:=PoppenObject,
                      MUIA_CycleChain, 1,
                      MUIA_Window_Title, 'Custom Class Color',
                     End,
              End,

          End,

      End,
  End
 
  IF app=NIL THEN Raise('Failed to create Application.')

  doMethodA(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,
            app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

  doMethodA(pen,[MUIM_Notify,MUIA_Pendisplay_Spec,MUIV_EveryTime,
            myobj,3,MUIM_Set,MYATTR_PEN,MUIV_TriggerValue])

  get(pen,MUIA_Pendisplay_Spec,{startpen})
  set(myobj,MYATTR_PEN,startpen)

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
    IF utilitybase THEN CloseLibrary(utilitybase)
    IF muimasterbase THEN CloseLibrary(muimasterbase) /* close library */
    IF exception THEN WriteF('\s\n',exception)
ENDPROC

