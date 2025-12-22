/*
**  Original C Code written by Stefan Stuntz
**
**  Translation into E by Klaus Becker
**
**  All comments are from the C-Source
*/

OPT PREPROCESS

MODULE 'muimaster','libraries/mui','libraries/muip',
       'mui/muicustomclass','amigalib/boopsi',
       'intuition/classes','intuition/classusr',
       'intuition/screens','intuition/intuition',
       'utility/tagitem','utility/hooks','tools/installhook',
       'wb','workbench/startup','workbench/workbench'

/*
** App message callback hook. Note that the object given here
** is the object that called the hook, i.e. the one that got
** the icon(s) dropped on it.
*/

PROC appMsgFunc(obj,x:PTR TO LONG)
  DEF ap:PTR TO wbarg,
      amsg:PTR TO appmessage,
      i,
      buf[256]:STRING,b
  amsg:=x[]
  b:=buf;i:=0
  ap:=amsg.arglist
  WHILE (i<amsg.numargs)
    NameFromLock(ap.lock,buf,StrMax(buf))
    AddPart(buf,ap.name,StrMax(buf))
    doMethodA(obj,[MUIM_List_Insert,{b},1,MUIV_List_Insert_Bottom])
    ap++
    i++
  ENDWHILE
ENDPROC 0
  
/*
** Having a function instead of a macro saves some code.
*/

PROC makeLV() IS
  ListviewObject,
    MUIA_Listview_Input, FALSE,
    MUIA_Listview_List , ListObject,
      ReadListFrame,
      MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
      MUIA_List_DestructHook , MUIV_List_DestructHook_String ,
    End,
  End

PROC main() HANDLE
  DEF app,window,sigs=0,
      lv1,lv2,lv3,
      appMsgHook:hook

  IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN
    Raise('Failed to open muimaster.library')

  installhook(appMsgHook,{appMsgFunc})

  app:=ApplicationObject,
    MUIA_Application_Title      , 'AppWindowDemo',
    MUIA_Application_Version    , '$VER: AppWindowDemo 12.9 (21.11.95)',
    MUIA_Application_Copyright  , 'c1992/93, Stefan Stuntz',
    MUIA_Application_Author     , 'Stefan Stuntz & Klaus Becker',
    MUIA_Application_Description, 'Show AppWindow Handling',
    MUIA_Application_Base       , 'APPWINDOWDEMO',
    SubWindow, window:= WindowObject,
      MUIA_Window_Title    , 'Drop icons on me!',
      MUIA_Window_ID       , "APPW",
      MUIA_Window_AppWindow, MUI_TRUE,
      WindowContents, VGroup,
        Child, HGroup,
          Child, lv1:= makeLV(),
          Child, lv2:= makeLV(),
        End,
        Child, lv3:= makeLV(),
      End,
    End,
  End

  IF (app=NIL) THEN Raise('Failed to create Application.')

  doMethodA(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,
    app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

/*
** Call the AppMsgHook when an icon is dropped on a listview.
*/

  doMethodA(lv1,[MUIM_Notify,MUIA_AppMessage,MUIV_EveryTime,
    lv1,3,MUIM_CallHook,appMsgHook,MUIV_TriggerValue])

  doMethodA(lv2,[MUIM_Notify,MUIA_AppMessage,MUIV_EveryTime,
    lv2,3,MUIM_CallHook,appMsgHook,MUIV_TriggerValue])

  doMethodA(lv3,[MUIM_Notify,MUIA_AppMessage,MUIV_EveryTime,
    lv3,3,MUIM_CallHook,appMsgHook,MUIV_TriggerValue])

/*
** When we're iconified, the object lv3 shall receive the
** messages from icons dropped on our app icon.
*/

  set(app,MUIA_Application_DropObject,lv3)

/*
** This is the ideal input loop for an object oriented MUI application.
** Everything is encapsulated in classes, no return ids need to be used,
** we just check if the program shall terminate.
** Note that MUIM_Application_NewInput expects sigs to contain the result
** from Wait() (or 0). This makes the input loop significantly faster.
*/

  set(window,MUIA_Window_Open,MUI_TRUE)

  WHILE doMethodA(app,[MUIM_Application_NewInput,{sigs}]) <> MUIV_Application_ReturnID_Quit
    IF sigs THEN sigs:=Wait(sigs)
  ENDWHILE

  set(window,MUIA_Window_Open,FALSE)

/*
** Shut down...
*/

EXCEPT DO
  IF app THEN Mui_DisposeObject(app)
  IF muimasterbase THEN CloseLibrary(muimasterbase)
  IF exception THEN WriteF('\s\n',exception)
ENDPROC
