->
->  Original C Code by Maik Schreiber
->
->  Translation into E by Andrew Cashmore
->

OPT PREPROCESS

MODULE 'amigalib/boopsi',
       'muimaster', 
       'libraries/mui',
       'utility/tagitem', 
       'mui/betterbalance_mcc'

ENUM ER_NON, ER_MUILIB, ER_APP
ENUM ID_DISPLAY=1,ID_EDIT,ID_DELETE,ID_SAVE 

PROC main() HANDLE

DEF bt_Save

  DEF app,wi_Browser,ml_led,nu_colour,nu_type
  DEF running=TRUE,signal,result

  IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN Raise(ER_MUILIB)

  app := ApplicationObject,
    MUIA_Application_Title      , 'BetterBalance-Demo',
    MUIA_Application_Version    , '$VER: BetterBalance-Demo v1.0 (8.6.98) © by Maik \qbZ!\q Schreiber',
    MUIA_Application_Copyright  , 'Copyright © 08-Jun-1998 by Maik Schreiber <bZ@iq-computing.de>',
    MUIA_Application_Author     , 'Maik Schreiber <bZ@iq-computing.de> (E conversion by Andrew Cashmore)',
    MUIA_Application_Description, 'Demonstrates BetterBalance.mcc\as features',
    MUIA_Application_Base       , 'BETTERBALANCEDEMO',
    SubWindow, wi_Browser:= WindowObject,
      MUIA_Window_Title, 'BetterBalance-Demo 1.0',
      MUIA_Window_Width,MUIV_Window_Width_Visible(75),
      MUIA_Window_Height,MUIV_Window_Height_Visible(75),
      WindowContents, VGroup,
        Child,HGroup,
          Child, RectangleObject,
            TextFrame,
          End,
          Child, BetterBalanceObject,
            MUIA_ObjectID, 1,
          End,
          Child, RectangleObject,
            TextFrame,
          End,
          Child, BetterBalanceObject,
            MUIA_ObjectID, 2,
          End,
          Child, RectangleObject,
            TextFrame,
          End,
          Child, BetterBalanceObject,
            MUIA_ObjectID, 3,
          End,
          Child, RectangleObject,
            TextFrame,
          End,
        End,
        Child, BetterBalanceObject,
          MUIA_ObjectID, 4,
        End,
        Child, HGroup,
          Child, RectangleObject,
            TextFrame,
          End,
          Child, BetterBalanceObject,
            MUIA_ObjectID, 5,
          End,
          Child, RectangleObject,
            TextFrame,
          End,
          Child, BetterBalanceObject,
            MUIA_ObjectID, 6,
          End,
          Child, RectangleObject,
            TextFrame,
          End,
          Child, BetterBalanceObject,
            MUIA_ObjectID, 7,
          End,
          Child, RectangleObject,
            TextFrame,
          End,
        End,
        Child, BetterBalanceObject,
          MUIA_ObjectID, 8,
        End,
        Child, HGroup,
          Child, RectangleObject,
            TextFrame,
          End,
          Child, BetterBalanceObject,
            MUIA_ObjectID, 9,
          End,
          Child, RectangleObject,
            TextFrame,
          End,
          Child, BetterBalanceObject,
            MUIA_ObjectID, 10,
          End,
          Child, RectangleObject,
            TextFrame,
          End,
          Child, BetterBalanceObject,
            MUIA_ObjectID, 11,
          End,
          Child, RectangleObject,
            TextFrame,
          End,
        End,
        Child, Mui_MakeObjectA(MUIO_HBar,[10]),
        Child, bt_Save:= SimpleButton('Save balance settings to ENV:'),

    End,End,End

  IF app=NIL THEN Raise(ER_APP)

  doMethodA(wi_Browser,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])
  doMethodA(bt_Save,[MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_Save,MUIV_Application_Save_ENV])

->  DoMethod(apMain, MUIM_Application_Load, MUIV_Application_Load_ENV);
  doMethodA(app,[MUIM_Application_Load,MUIV_Application_Load_ENV])

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
