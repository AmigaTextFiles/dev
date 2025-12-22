/*
** Demosource on how to use customclasses in E.
** Based on the C example 'Slidorama.c' by Stafan Stuntz.
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

CONST MUIA_Mousepower_Direction=TAG_USER+$10001   -> was: ((TAG_USER | ( 1 << 16)) | 0x0001)

OBJECT mousepowerData
  decrease:INT
  mousex:INT
  mousey:INT
  direction:INT
ENDOBJECT

OBJECT ratingData
  buf:PTR TO CHAR
ENDOBJECT

OBJECT timeData
  buf:PTR TO CHAR
ENDOBJECT

DEF mousepowerClass=NIL:PTR TO mui_customclass,
    ratingClass=NIL:PTR TO mui_customclass,
    timebuttonClass=NIL:PTR TO mui_customclass,
    timesliderClass=NIL:PTR TO mui_customclass


/*****************************************************************************
** This is the Mousepower custom class, a sub class of Levelmeter.mui.
** It is quite simple and does nothing but add some input capabilities
** to its super class by implementing MUIM_HandleInput.
** Don't be afraid of writing sub classes!
******************************************************************************/
 
PROC mousepowerDispatcher(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
DEF methodid,
    data:PTR TO mousepowerData,
    m:PTR TO muip_handleinput,
    delta

   methodid:=msg.methodid
   SELECT methodid
     CASE OM_NEW
       IF obj:=doSuperMethodA(cl,obj,msg)
         data:=INST_DATA(cl,obj)
         data.mousex    :=-1
         data.direction := GetTagData(MUIA_Mousepower_Direction,0,msg::opset.attrlist)
         set(obj,MUIA_Numeric_Max,1000)
       ENDIF
       RETURN obj

     CASE MUIM_Setup
       data:=INST_DATA(cl,obj)
       IF doSuperMethodA(cl,obj,msg)=FALSE THEN RETURN FALSE
       data.mousex  :=-1;
       set(obj,MUIA_Numeric_Max,1000)
       Mui_RequestIDCMP(obj,IDCMP_MOUSEMOVE OR IDCMP_INTUITICKS OR IDCMP_INACTIVEWINDOW)
       RETURN MUI_TRUE

     CASE MUIM_Cleanup
       Mui_RejectIDCMP(obj,IDCMP_MOUSEMOVE OR IDCMP_INTUITICKS OR IDCMP_INACTIVEWINDOW)
       RETURN doSuperMethodA(cl,obj,msg)

     CASE MUIM_HandleInput
       m:=msg
       data:=INST_DATA(cl,obj)
       IF m.imsg
         IF m.imsg.class=IDCMP_MOUSEMOVE
           IF data.mousex<>-1
             IF data.direction=1
               delta := Abs(data.mousex - m.imsg.mousex)*2
             ELSEIF data.direction=2
               delta := Abs(data.mousey - m.imsg.mousey)*2
             ELSE
               delta := Abs(data.mousex - m.imsg.mousex)+
                        Abs(data.mousey - m.imsg.mousey)
             ENDIF
             IF data.decrease>0 THEN data.decrease:=data.decrease-1
             doMethodA(obj,[MUIM_Numeric_Increase,delta/10])
           ENDIF
           data.mousex:=m.imsg.mousex
           data.mousey:=m.imsg.mousey
         ELSEIF m.imsg.class=IDCMP_INTUITICKS
           doMethodA(obj,[MUIM_Numeric_Decrease,data.decrease*data.decrease])
           IF data.decrease<50 THEN data.decrease:=data.decrease+1
         ELSEIF m.imsg.class=IDCMP_INACTIVEWINDOW
           set(obj,MUIA_Numeric_Value,0)
         ENDIF
       ENDIF
       RETURN 0
  ENDSELECT
ENDPROC doSuperMethodA(cl,obj,msg)


/*****************************************************************************
** This is the Rating custom class, a sub class of Slider.mui.
** It shows how to override the MUIM_Numeric_Stringify method
** to implement custom displays in a slider gadget. Nothing
** easier than that... :-)
******************************************************************************/

PROC ratingDispatcher(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
DEF methodid,
    data:PTR TO ratingData,
    m:PTR TO muip_numeric_stringify,
    r

  methodid:=msg.methodid
  SELECT methodid

    CASE OM_NEW
      /* E-Note: because you could not use STRING-type as member OF an object,
      ** so we have TO allocate it. This IS done during OM_NEW
      */
      IF (obj:=doSuperMethodA(cl,obj,msg))=NIL THEN RETURN 0
      data:=INST_DATA(cl,obj)
      data.buf:=String(20)
      IF data.buf THEN RETURN obj

      ->Allocating failed therefore invoke OM_DISPOSE on *our* class
      coerceMethodA(cl,obj,[OM_DISPOSE])
      RETURN 0

    CASE OM_DISPOSE
      /* E-Note: Lets dispose our String
      */
      data:=INST_DATA(cl,obj)
      IF data.buf THEN DisposeLink(data.buf)
      data.buf:=NIL

    CASE MUIM_Numeric_Stringify
      data:=INST_DATA(cl,obj)
      m:=msg
      IF m.value=0
        StrCopy(data.buf,'You''re kidding!',STRLEN)
      ELSEIF m.value=100
        StrCopy(data.buf,'It''s magic!',STRLEN)
      ELSE
        r:=doMethodA(obj,[MUIM_Numeric_ValueToScale,0,4 /*5 States, 0..4*/])
        StringF(data.buf,
                '\d[3] points. \s',
                m.value,ListItem([':-((',':-(',':-|',':-)',':-))'],r))
      ENDIF
      RETURN data.buf
  ENDSELECT
ENDPROC doSuperMethodA(cl,obj,msg)


/*****************************************************************************
** A time slider custom class. Just like with the Rating class, we override
** the MUIM_Numeric_Stringify method. Wow... our classes get smaller and 
** smaller. This one only has about 10 lines of C code. :-)
** Note that we can use this TimeDispatcher as subclass of any of
** MUI's numeric classes. In Slidorama, we create a Timebutton class
** from MUIC_Numericbutton and Timeslider class for MUIC_Slider with
** the same dispatcher function.
******************************************************************************/

PROC timeDispatcher(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
DEF methodid,
    data:PTR TO timeData,
    m:PTR TO muip_numeric_stringify

  methodid:=msg.methodid
  SELECT methodid
    CASE OM_NEW
      /* E-Note: because you could not use STRING-type as member OF an object,
      ** so we have TO allocate it. This IS done during OM_NEW
      */
      IF (obj:=doSuperMethodA(cl,obj,msg))=NIL THEN RETURN 0
      data:=INST_DATA(cl,obj)
      data.buf:=String(16)
      IF data.buf THEN RETURN obj

      ->Allocating failed therefore invoke OM_DISPOSE on *our* class
      coerceMethodA(cl,obj,[OM_DISPOSE])
      RETURN 0

    CASE OM_DISPOSE
      /* E-Note: Lets dispose our String
      */
      data:=INST_DATA(cl,obj)
      IF data.buf THEN DisposeLink(data.buf)
      data.buf:=NIL

    CASE MUIM_Numeric_Stringify
      data:=INST_DATA(cl,obj)
      m:=msg
      StringF(data.buf,'\z\d[2]:\z\d[2]',m.value/60,Mod(m.value,60))
      RETURN data.buf
  ENDSELECT
ENDPROC doSuperMethodA(cl,obj,msg)


/*****************************************************************************
** Main Program
******************************************************************************/

PROC cleanupClasses()
  IF mousepowerClass THEN Mui_DeleteCustomClass(mousepowerClass)
  IF ratingClass     THEN Mui_DeleteCustomClass(ratingClass)
  IF timebuttonClass THEN Mui_DeleteCustomClass(timebuttonClass)
  IF timesliderClass THEN Mui_DeleteCustomClass(timesliderClass)
ENDPROC

PROC createCustomClass(father,datasize,dispatcher)
DEF mcc
  mcc:=eMui_CreateCustomClass(NIL,father,NIL,datasize,dispatcher)
  IF mcc=NIL THEN Raise('Could not create custom class.')
ENDPROC mcc

PROC setupClasses()
  mousepowerClass := createCustomClass(MUIC_Levelmeter,SIZEOF mousepowerData,{mousepowerDispatcher})
  ratingClass     := createCustomClass(MUIC_Slider,SIZEOF ratingData,{ratingDispatcher})
  timesliderClass := createCustomClass(MUIC_Slider,SIZEOF timeData,{timeDispatcher})
  timebuttonClass := createCustomClass(MUIC_Numericbutton,SIZEOF timeData,{timeDispatcher})
ENDPROC

PROC main() HANDLE
DEF app=NIL,window,
    sigs=0

  IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN))=NIL THEN
     Raise('Failed TO open muimaster.library')
 
  IF (utilitybase:=OpenLibrary('utility.library',0))=NIL THEN
     Raise('Failed TO open utility.library')

  setupClasses()

  app := ApplicationObject,
      MUIA_Application_Title      , 'Slidorama',
      MUIA_Application_Version    , '$VER: Slidorama 12.10 (21.11.95)',
      MUIA_Application_Copyright  , '©1992-95, Stefan Stuntz',
      MUIA_Application_Author     , 'Stefan Stuntz',
      MUIA_Application_Description, 'Show different kinds OF sliders',
      MUIA_Application_Base       , 'SLIDORAMA',

      SubWindow, window := WindowObject,
          MUIA_Window_Title, 'Slidorama',
          MUIA_Window_ID   , "SLID",

          WindowContents, VGroup,

              Child, HGroup,

                  Child, VGroup, GroupSpacing(0), GroupFrameT('Knobs'),
                      Child, VSpace(0),
                      Child, ColGroup(6),
                          GroupSpacing(0),
                          Child, VSpace(0),
                          Child, HSpace(4),
                          Child, CLabel('1'),
                          Child, CLabel('2'),
                          Child, CLabel('3'),
                          Child, CLabel('4'),
                          Child, VSpace(2),
                          Child, VSpace(2),
                          Child, VSpace(2),
                          Child, VSpace(2),
                          Child, VSpace(2),
                          Child, VSpace(2),
                          Child, Label('Volume:'),
                          Child, HSpace(4),
                          Child, newKnobObject1(64,64),
                          Child, newKnobObject1(64,64),
                          Child, newKnobObject1(64,64),
                          Child, newKnobObject1(64,64),
                          Child, Label('Bass:'),
                          Child, HSpace(4),
                          Child, newKnobObject2(-100,100),
                          Child, newKnobObject2(-100,100),
                          Child, newKnobObject2(-100,100),
                          Child, newKnobObject2(-100,100),
                          Child, Label('Treble:'),
                          Child, HSpace(4),
                          Child, newKnobObject2(-100,100),
                          Child, newKnobObject2(-100,100),
                          Child, newKnobObject2(-100,100),
                          Child, newKnobObject2(-100,100),
                      End,
                      Child, VSpace(0),
                  End,

                  Child, VGroup,
                      Child, VGroup, GroupFrameT('Levelmeter Displays'),
                          Child, VSpace(0),
                          Child, HGroup,
                              Child, HSpace(0),
                              Child, NewObjectA(mousepowerClass.mcc_class,0,
                                                [MUIA_Mousepower_Direction,1,
                                                 MUIA_Levelmeter_Label,'Horizontal',
                                                 TAG_DONE]),
                              Child, HSpace(0),
                              Child, NewObjectA(mousepowerClass.mcc_class,0,
                                                [MUIA_Mousepower_Direction,2,
                                                 MUIA_Levelmeter_Label,'Vertical',
                                                 TAG_DONE]),
                              Child, HSpace(0),
                              Child, NewObjectA(mousepowerClass.mcc_class,0,
                                                [MUIA_Mousepower_Direction,0,
                                                 MUIA_Levelmeter_Label,'Total',
                                                 TAG_DONE]),
                              Child, HSpace(0),
                          End,
                          Child, VSpace(0),
                      End,
                      Child, VGroup, GroupFrameT('Numeric Buttons'),
                          Child, VSpace(0),
                          Child, HGroup, GroupSpacing(0),
                              Child, HSpace(0),
                              Child, ColGroup(4), MUIA_Group_VertSpacing, 1,
                                  Child, VSpace(0),
                                  Child, CLabel('Left'),
                                  Child, CLabel('Right'),
                                  Child, CLabel('SPL'),
                                  Child, Label1('Low:'),
                                  Child, Mui_MakeObjectA(MUIO_NumericButton,[NIL,0,100,'%3ld %%']),
                                  Child, Mui_MakeObjectA(MUIO_NumericButton,[NIL,0,100,'%3ld %%']),
                                  Child, Mui_MakeObjectA(MUIO_NumericButton,[NIL,30,99,'%2ld dB']),
                                  Child, Label1('Mid:'),
                                  Child, Mui_MakeObjectA(MUIO_NumericButton,[NIL,0,100,'%3ld %%']),
                                  Child, Mui_MakeObjectA(MUIO_NumericButton,[NIL,0,100,'%3ld %%']),
                                  Child, Mui_MakeObjectA(MUIO_NumericButton,[NIL,30,99,'%2ld dB']),
                                  Child, Label1('High:'),
                                  Child, Mui_MakeObjectA(MUIO_NumericButton,[NIL,0,100,'%3ld %%']),
                                  Child, Mui_MakeObjectA(MUIO_NumericButton,[NIL,0,100,'%3ld %%']),
                                  Child, Mui_MakeObjectA(MUIO_NumericButton,[NIL,30,99,'%2ld dB']),
                              End,
                              Child, HSpace(0),
                          End,
                          Child, VSpace(0),
                      End,
                  End,
              End,

              Child, VSpace(4),

              Child, ColGroup(2),
                  Child, Label('Slidorama Rating:'),
                  Child, NewObjectA(ratingClass.mcc_class,0,
                                    [MUIA_Numeric_Value,50,
                                     TAG_DONE]),
              End,
          End,
      End,
  End

  IF app=NIL THEN Raise('Failed TO create Application')
 
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
  IF app THEN Mui_DisposeObject(app)                /* dispose ALL objects. */
  cleanupClasses()
  IF utilitybase THEN CloseLibrary(utilitybase)     /* close library */
  IF muimasterbase THEN CloseLibrary(muimasterbase) /* close library */
  IF exception THEN WriteF('\s\n',exception)
ENDPROC

PROC newKnobObject1(max,defi) IS
  KnobObject,
      MUIA_Numeric_Max, max,
      MUIA_Numeric_Default, defi,
      MUIA_CycleChain,1,
  End

PROC newKnobObject2(min,max) IS
  KnobObject,
      MUIA_Numeric_Max, max,
      MUIA_Numeric_Min, min,
      MUIA_CycleChain,1,
  End

