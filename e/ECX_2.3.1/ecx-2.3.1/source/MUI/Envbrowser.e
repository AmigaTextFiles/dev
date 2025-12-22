/*
**  Original C Code written by Stefan Stuntz
**
**  Translation into E by Klaus Becker
**
**  All comments are from the C-Source
*/

OPT PREPROCESS

/*
** Loading the needed MODULEs
*/


MODULE 'AmigaLib/boopsi'
MODULE 'dos/var'
MODULE 'muimaster', 'libraries/mui'
MODULE 'utility/tagitem', 'utility/hooks'
MODULE 'intuition/classes', 'intuition/classusr'
MODULE 'libraries/gadtools'

ENUM ER_NON, ER_MUILIB, ER_APP, ER_MUIIFACE         /* for the exception handling */
ENUM ID_DISPLAY=1,ID_EDIT,ID_DELETE,ID_SAVE

PROC main() HANDLE
  DEF app,bt_Edit,bt_Delete,bt_Save,wi_Browser,lv_Show,lv_Vars
  DEF buffer[2048]:STRING, var,running=TRUE,signal,result

  IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN Raise(ER_MUILIB)
  #ifdef __AMIGAOS4__
  IF (muimasteriface := GetInterface(muimasterbase, 'main', 1, NIL)) = NIL THEN Raise(ER_MUIIFACE)
  #endif
  app := ApplicationObject,
    MUIA_Application_Title      , 'EnvBrowser',
    MUIA_Application_Version    , '$VER: EnvBrowser 10.11 (23.12.94)',
    MUIA_Application_Copyright  , ' 1992/93, Stefan Stuntz',
    MUIA_Application_Author     , 'Stefan Stuntz & Klaus Becker',
    MUIA_Application_Description, 'View environment variables.',
    MUIA_Application_Base       , 'ENVBROWSER',
    SubWindow, wi_Browser:= WindowObject,
      MUIA_Window_ID, "MAIN",
      MUIA_Window_Title, 'Environment Browser',
      WindowContents, VGroup,
        Child, HGroup,
          Child, lv_Vars:= ListviewObject,
            MUIA_Listview_List, DirlistObject,
              InputListFrame,
              MUIA_Dirlist_Directory      , 'env:',
              MUIA_Dirlist_FilterDrawers, MUI_TRUE,
              MUIA_List_Format          , 'COL=0',
              End,
            End,
          Child, lv_Show:= ListviewObject,
            MUIA_Listview_List, FloattextObject,
              ReadListFrame,
              MUIA_Font, MUIV_Font_Fixed,
              End,
            End,
          End,
        Child, HGroup, MUIA_Group_SameSize, MUI_TRUE,
          Child, bt_Edit:=   SimpleButton('_Edit'  ),
          Child, bt_Delete:= SimpleButton('_Delete'),
          Child, bt_Save:=   SimpleButton('_Save'  ),
          End,
        End,
      End,
    End

  IF app=NIL THEN Raise(ER_APP)

  doMethodA(wi_Browser,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])
  doMethodA(lv_Vars   ,[MUIM_Notify,MUIA_List_Active,MUIV_EveryTime,app,2,MUIM_Application_ReturnID,ID_DISPLAY])
  doMethodA(lv_Vars   ,[MUIM_Notify,MUIA_Listview_DoubleClick,MUI_TRUE,app,2,MUIM_Application_ReturnID,ID_EDIT])
  doMethodA(bt_Delete ,[MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,ID_DELETE])
  doMethodA(bt_Save   ,[MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,ID_SAVE  ])
  doMethodA(bt_Edit   ,[MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,ID_EDIT  ])

  doMethodA(wi_Browser,[MUIM_Window_SetCycleChain,lv_Vars,lv_Show,bt_Edit,bt_Delete,bt_Save,NIL])

  set(wi_Browser,MUIA_Window_Open,MUI_TRUE)

    WHILE running
      result:= doMethodA(app,[MUIM_Application_Input,{signal}])
        SELECT result
               CASE MUIV_Application_ReturnID_Quit
                    running:=FALSE
               CASE ID_DISPLAY
                    get(lv_Vars,MUIA_Dirlist_Path,{var})
                    IF (var AND GetVar(var,buffer,StrMax(buffer),GVF_GLOBAL_ONLY OR GVF_BINARY_VAR)<>-1)
                      set(lv_Show,MUIA_Floattext_Text,buffer)
                    ELSE
                      DisplayBeep(0)
                    ENDIF
               CASE ID_DELETE
                    get(lv_Vars,MUIA_Dirlist_Path,{var})
                    IF var
                      set(lv_Show,MUIA_Floattext_Text,NIL)
                      DeleteFile(var)
                      doMethodA(lv_Vars,[MUIM_List_Remove,MUIV_List_Remove_Active])
                    ELSE
                      DisplayBeep(0)
                    ENDIF

               CASE ID_SAVE
                 get(lv_Vars,MUIA_Dirlist_Path,{var})
                 IF var
                   set(app,MUIA_Application_Sleep,MUI_TRUE)
                   StringF(buffer,'copy env:\s envarc:\s',FilePart(var),FilePart(var))
                   Execute(buffer,0,0)
                   set(app,MUIA_Application_Sleep,FALSE)
                 ELSE
                   DisplayBeep(0)
                 ENDIF

               CASE ID_EDIT
                 get(lv_Vars,MUIA_Dirlist_Path,{var})
                 IF var
                   set(app,MUIA_Application_Sleep,MUI_TRUE)
                   StringF(buffer,'ged -sticky "\s"',var)
                   Execute(buffer,0,0)
                   set(app,MUIA_Application_Sleep,FALSE)
                   doMethodA(wi_Browser,[MUIM_Window_ScreenToFront])
                 ELSE
                   DisplayBeep(0)
                 ENDIF
        ENDSELECT

      IF (running AND signal) THEN Wait(signal)
    ENDWHILE

EXCEPT DO
  IF app THEN Mui_DisposeObject(app)
  #ifdef __AMIGAOS4__
  DropInterface(muimasteriface)
  #endif
  IF muimasterbase THEN CloseLibrary(muimasterbase)

  SELECT exception
    CASE ER_MUILIB
      WriteF('Failed to open \s.\n',MUIMASTER_NAME)
      CleanUp(20)
    CASE ER_MUIIFACE
      WriteF('Failed to open \s interface.\n',MUIMASTER_NAME)
      CleanUp(20)

    CASE ER_APP
      WriteF('Failed to create application.\n')
      CleanUp(20)

  ENDSELECT
ENDPROC 0





