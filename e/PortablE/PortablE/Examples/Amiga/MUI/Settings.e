/* An old E example converted to PortablE.
   From http://aminet.net/package/dev/e/mui36dev-E */

/*
**  Original C Code written by Stefan Stuntz
**
**  Translation into E by Klaus Becker
**
**  All comments are from the C-Source
*/

/*
** The Settings Demo shows how to load and save object contents.
*/

OPT PREPROCESS, POINTER

MODULE 'exec'
MODULE 'tools/domethod'
MODULE 'muimaster', 'libraries/mui'
MODULE 'utility/tagitem', 'utility/hooks','tools/installhook'
MODULE 'intuition/classes', 'intuition/classusr'
MODULE 'libraries/gadtools'

TYPE PTIO IS PTR TO INTUIOBJECT
 
ENUM ID_CANCEL=1, ID_SAVE, ID_USE
ENUM ER_NONE, ER_MUILIB, ER_APP          /* for the exception handling */

DEF helpHook:hook

PROC helpFunc(hook, help:ARRAY, objptr:ARRAY OF ARRAY)
  DEF udata
  udata:=NIL
  IF objptr[0] THEN get(objptr[0],MUIA_UserData,ADDRESSOF udata)
  set(help, MUIA_Text_Contents, udata)
  hook:=0	->dummy
ENDPROC

PROC main()

  DEF app:PTIO, window:PTIO, str[4]:ARRAY OF PTIO, sl1:PTIO, cy1:PTIO, help:PTIO, btsave:PTIO, btuse:PTIO, btcancel:PTIO
  DEF signals, result
  DEF running:BOOL
  DEF sex
  running := TRUE

  IF (muimasterbase := OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN Raise(ER_MUILIB)
    
  sex := ['male','female',NIL]

  installhook(helpHook, CALLBACK helpFunc())

  app := ApplicationObject,
    MUIA_Application_Title      , 'Settings',
    MUIA_Application_Version    , '$VER: Settings 10.12 (23.12.94)',
    MUIA_Application_Copyright  , ' 1992/93, Stefan Stuntz',
    MUIA_Application_Author     , 'Stefan Stuntz & Klaus Becker',
    MUIA_Application_Description, 'Show saving AND loading of settings',
    MUIA_Application_Base       , 'SETTINGS',
    SubWindow, window := WindowObject,
      MUIA_Window_Title, 'Save/use me AND start me again!',
      MUIA_Window_ID   , "SETT",
      MUIA_Window_NeedsMouseObject, MUI_TRUE,
        WindowContents, VGroup,
          Child, ColGroup(2), GroupFrameT('User Identification'),
            Child, Label2('Name:'),
            Child, str[1] := StringObject, StringFrame,
              MUIA_ExportID, 1,
              MUIA_UserData, 'First AND last name of user.',
            End,
            Child, Label2('Address:'),
            Child, str[2] := StringObject, StringFrame,
              MUIA_ExportID, 2,
              MUIA_UserData, 'Street, city AND ZIP code.' ,
            End,
            Child, Label1('Password:'),
            Child, str[3] := StringObject, StringFrame,
              MUIA_ExportID, 4,
              MUIA_UserData, 'Global access password (invisible).',
              MUIA_String_Secret, MUI_TRUE,
            End,
            Child, Label1('Sex:'),
            Child, cy1 := CycleObject,
              MUIA_ExportID, 6,
              MUIA_Cycle_Entries, sex,
              MUIA_UserData, 'Guess what this means...',
            End,
            Child, Label('Age:'),
            Child, sl1 := SliderObject,
              MUIA_ExportID, 5,
              MUIA_Slider_Min, 9,
              MUIA_Slider_Max, 99,
              MUIA_UserData, 'Several areas require a minimum age.',
            End,
            Child, Label1('Info:'),
            Child, help := TextObject, TextFrame,
              MUIA_UserData, 'This is the info gadget.',
            End,
          End,
          Child, VSpace(2),
          Child, HGroup, MUIA_Group_SameSize, MUI_TRUE,
            Child, btsave := SimpleButton('_Save'),
            Child, HSpace(0),
            Child, btuse := SimpleButton('_Use'),
            Child, HSpace(0),
            Child, btcancel := SimpleButton('_Cancel'),
         End,
       End,
     End,
   End

 IF app=NIL THEN Raise(ER_APP)

/*
** Set Mouse Move Help Strings
*/

  doMethod(window, [MUIM_Notify, MUIA_Window_MouseObject,MUIV_EveryTime,
    help,3,MUIM_CallHook,helpHook,MUIV_TriggerValue])


/*
** Install notification events...
*/

  doMethod(window, [MUIM_Notify, MUIA_Window_CloseRequest,MUI_TRUE,
                   app,2,MUIM_Application_ReturnID,ID_CANCEL])

  doMethod(btcancel, [MUIM_Notify, MUIA_Pressed,FALSE,
                     app,2,MUIM_Application_ReturnID,ID_CANCEL])

  doMethod(btsave, [MUIM_Notify, MUIA_Pressed,FALSE,
                   app,2,MUIM_Application_ReturnID,ID_SAVE])

  doMethod(btuse, [MUIM_Notify, MUIA_Pressed,FALSE,
                  app,2,MUIM_Application_ReturnID,ID_USE])


/*
** Cycle chain for keyboard control
*/

  doMethod(window, [MUIM_Window_SetCycleChain,
                   str[1],str[2],str[3],cy1,sl1,btsave,btuse,btcancel,NIL])


/*
** Concatenate strings, <return> will activate the next one
*/

  doMethod(str[1], [MUIM_Notify, MUIA_String_Acknowledge,MUIV_EveryTime,
    window,3,MUIM_Set,MUIA_Window_ActiveObject,str[2]])

  doMethod(str[2], [MUIM_Notify, MUIA_String_Acknowledge,MUIV_EveryTime,
    window,3,MUIM_Set,MUIA_Window_ActiveObject,str[3]])

  doMethod(str[3], [MUIM_Notify, MUIA_String_Acknowledge,MUIV_EveryTime,
    window,3,MUIM_Set,MUIA_Window_ActiveObject,str[1]])


/*
** The application is set up, now load
** a previously saved configuration from env:
*/

  doMethod(app, [MUIM_Application_Load, MUIV_Application_Load_ENV])

/*
** Input loop...
*/

  set(window, MUIA_Window_Open,MUI_TRUE)
  set(window, MUIA_Window_ActiveObject,str[1])

  WHILE running

    result := doMethod(app, [MUIM_Application_Input, ADDRESSOF signals])

    SELECT result

      CASE MUIV_Application_ReturnID_Quit
           running := FALSE
      CASE ID_CANCEL
           running := FALSE

      CASE ID_SAVE
        doMethod(app, [MUIM_Application_Save, MUIV_Application_Save_ENVARC])
        doMethod(app, [MUIM_Application_Save, MUIV_Application_Save_ENV])
        running := FALSE
      CASE ID_USE
        doMethod(app, [MUIM_Application_Save, MUIV_Application_Save_ENV])
        running := FALSE
    ENDSELECT

    IF (running OR signals) THEN Wait(signals)
  ENDWHILE

  set(window, MUIA_Window_Open,FALSE)
  Raise (ER_NONE)

FINALLY
  IF app THEN Mui_DisposeObject(app)
  IF muimasterbase THEN CloseLibrary(muimasterbase)

  SELECT exception
    CASE ER_MUILIB
      Print('Failed to open \s.\n',MUIMASTER_NAME)
      CleanUp(20)

    CASE ER_APP
      Print('Failed to create application.\n')
      CleanUp(20)

  ENDSELECT

ENDPROC 0
