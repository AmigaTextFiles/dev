->
->  Original C Code by Russell Leighton
->
->  Translation into E by Andrew Cashmore
->

OPT PREPROCESS

MODULE 'amigalib/boopsi',
       'muimaster', 
       'libraries/mui',
       'utility/tagitem', 
       'mui/icon_mcc'

ENUM ER_NON, ER_MUILIB, ER_APP
ENUM ID_DISPLAY=1,ID_EDIT,ID_DELETE,ID_SAVE 

DEF iconname[40]:STRING
DEF x

PROC main() HANDLE

  DEF app,wi_Browser
  DEF running=TRUE,signal,result

  IF arg[]<1
    WriteF('no icon specified\n')
    RETURN
  ENDIF

-> The icon name needs to be passed as 'icon', not 'icon.info', so this bit strips it
-> if necessary.

  x:=InStr(arg,'.info',0)

  IF x=-1
    StrCopy(iconname,arg,ALL)
  ELSE
    StrCopy(iconname,arg,x)
  ENDIF

  IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN Raise(ER_MUILIB)

  app := ApplicationObject,
    MUIA_Application_Title      , 'Icon Demo',
    MUIA_Application_Version    , '$VER: Icon-Demo v1.0',
    MUIA_Application_Copyright  , 'Written by Russell Leighton, 1996',
    MUIA_Application_Author     , 'Russell Leighton (E conversion by Andrew Cashmore)',
    MUIA_Application_Description, 'Icon-Demo',
    MUIA_Application_Base       , 'ICONDEMO',
    SubWindow, wi_Browser:= WindowObject,
      MUIA_Window_ID, "MAIN",
      MUIA_Window_Title, 'Icon-Demo 1996',
      WindowContents, VGroup,
         Child, IconObject,
                    MUIA_InputMode, MUIV_InputMode_Toggle,
                    MUIA_Frame, MUIV_Frame_Button,
                    MUIA_Icon_Name, iconname,
                End,
          End,
      End,
    End

  IF app=NIL THEN Raise(ER_APP)

  doMethodA(wi_Browser,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

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
      WriteF('Failed to create application.\nMaybe you forgot to add .info to the icon name.\n')
      CleanUp(20)
      
  ENDSELECT
ENDPROC 0
