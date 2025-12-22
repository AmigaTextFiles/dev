->
->  Original C Code by Chris Page
->
->  Translation into E by Andrew Cashmore
->

OPT PREPROCESS

MODULE 'amigalib/boopsi',
       'dos/var',
       'muimaster', 
       'libraries/mui',
       'utility/tagitem', 
       'utility/hooks',
       'intuition/classes', 
       'intuition/classusr',
       'libraries/gadtools',
       'mui/twfmultiled_mcc'

ENUM ER_NON, ER_MUILIB, ER_APP
ENUM ID_DISPLAY=1,ID_EDIT,ID_DELETE,ID_SAVE 

PROC main() HANDLE

  DEF app,wi_Browser,ml_led,bt_off,bt_on,bt_ok,bt_work,bt_wait,bt_load,bt_can,bt_stop,bt_error,bt_panic
  DEF bt_typec5,bt_typec11,bt_types5,bt_types11,bt_typer11,bt_typer15,sl_time,bt_done
  DEF running=TRUE,signal,result

  IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN Raise(ER_MUILIB)

  app := ApplicationObject,
    MUIA_Application_Title      , 'TWFmultiLED-Demo',
    MUIA_Application_Version    , '$VER: TWFmultiLED-Demo v1.0 (23-Nov-1998)',
    MUIA_Application_Copyright  , '(C)1998 Chris Page, The World Foundry',
    MUIA_Application_Author     , 'Chris Page (E conversion by Andrew Cashmore)',
    MUIA_Application_Description, 'TWFmultiLED.mcc demo program',
    MUIA_Application_Base       , 'TWFLEDDEMO',
    SubWindow, wi_Browser:= WindowObject,
      MUIA_Window_ID, "MAIN",
      MUIA_Window_Title, 'TWFmultiLED Demo',
      WindowContents, VGroup,
        Child, ColGroup(5),
          MUIA_Group_SameSize, TRUE,
            GroupFrameT('Indicator Colour'),
              Child, bt_off:=SimpleButton('Off'),
              Child, bt_on:=SimpleButton('On'),
              Child, bt_ok:=SimpleButton('Ok'),
              Child, bt_work:=SimpleButton('Working'),
              Child, bt_wait:=SimpleButton('Waiting'),
              Child, bt_load:=SimpleButton('Loading'),
              Child, bt_can:=SimpleButton('Cancelled'),
              Child, bt_stop:=SimpleButton('Stopped'),
              Child, bt_error:=SimpleButton('Error'),
              Child, bt_panic:=SimpleButton('Panic'),
            End,
            Child, ColGroup(4),
              MUIA_Group_SameSize, TRUE,
                GroupFrameT('Indicator Shape'),
                  Child, bt_typec5:=SimpleButton('Round 5'),
                  Child, bt_typec11:=SimpleButton('Round 11'),
                  Child, bt_types5:=SimpleButton('Square 5'),
                  Child, bt_types11:=SimpleButton('Square 11'),
                    Child, HSpace(0),
                      Child, bt_typer11:=SimpleButton('Rect 11'),
                      Child, bt_typer15:=SimpleButton('Rect 15'),
                        Child, HSpace(0),
                      End,
                      Child, HGroup,
                        Child, Label('Time Delay (Seconds)'),
                        Child, sl_time:=SliderObject,
                          MUIA_Numeric_Min  , 0,
                          MUIA_Numeric_Max  , 300,
                          MUIA_Numeric_Value, 0,
                        End,
                      End,
                      Child, VGroup,
                        Child, VSpace(0),
                          Child, HGroup,
                            Child, HSpace(0),
                              Child, ml_led:= TWFmultiLEDObject, End,
                                Child, HSpace(0),
                                End,
                              Child, VSpace(0),
                            End,
           Child,bt_done:=SimpleButton('Done'),
        End,
      End,
    End

  IF app=NIL THEN Raise(ER_APP)

  doMethodA(wi_Browser,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])
  doMethodA(bt_done,[MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])
  
  doMethodA(bt_off,     [MUIM_Notify,MUIA_Pressed,FALSE,ml_led,3,MUIM_Set,MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Off])
  doMethodA(bt_on,      [MUIM_Notify, MUIA_Pressed, FALSE, ml_led, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_On])
  doMethodA(bt_ok,      [MUIM_Notify, MUIA_Pressed, FALSE, ml_led, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Ok])
  doMethodA(bt_work,    [MUIM_Notify, MUIA_Pressed, FALSE, ml_led, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Working])
  doMethodA(bt_wait,    [MUIM_Notify, MUIA_Pressed, FALSE, ml_led, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Waiting])
  doMethodA(bt_load,    [MUIM_Notify, MUIA_Pressed, FALSE, ml_led, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Load])
  doMethodA(bt_can,     [MUIM_Notify, MUIA_Pressed, FALSE, ml_led, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Cancelled])
  doMethodA(bt_stop,    [MUIM_Notify, MUIA_Pressed, FALSE, ml_led, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Stopped])
  doMethodA(bt_error,   [MUIM_Notify, MUIA_Pressed, FALSE, ml_led, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Error])
  doMethodA(bt_panic,   [MUIM_Notify, MUIA_Pressed, FALSE, ml_led, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Panic])

  doMethodA(bt_typec5,  [MUIM_Notify, MUIA_Pressed, FALSE, ml_led, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Round5])
  doMethodA(bt_typec11, [MUIM_Notify, MUIA_Pressed, FALSE, ml_led, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Round11])
  doMethodA(bt_types5,  [MUIM_Notify, MUIA_Pressed, FALSE, ml_led, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Square5])
  doMethodA(bt_types11, [MUIM_Notify, MUIA_Pressed, FALSE, ml_led, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Square11])
  doMethodA(bt_typer11, [MUIM_Notify, MUIA_Pressed, FALSE, ml_led, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Rect11])
  doMethodA(bt_typer15, [MUIM_Notify, MUIA_Pressed, FALSE, ml_led, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Rect15])

  doMethodA(sl_time,    [MUIM_Notify, MUIA_Numeric_Value, MUIV_EveryTime, ml_led, 3, MUIM_Set, MUIA_TWFmultiLED_TimeDelay, MUIV_TriggerValue])

  set(wi_Browser,MUIA_Window_Open,MUI_TRUE)

    WHILE running
      result:= doMethodA(app,[MUIM_Application_Input,{signal}])
        SELECT result
               CASE MUIV_Application_ReturnID_Quit
                    running:=FALSE
         ENDSELECT

      IF (running AND signal) THEN Wait(signal)
    ENDWHILE

EXCEPT DO
  IF app THEN Mui_DisposeObject(app)
  IF muimasterbase THEN CloseLibrary(muimasterbase)
  
  SELECT exception
    CASE ER_MUILIB
      WriteF('Failed to open \s.\n',MUIMASTER_NAME)
      CleanUp(20)

    CASE ER_APP
      WriteF('Failed to create application.\n')
      CleanUp(20)
      
  ENDSELECT
ENDPROC 0
