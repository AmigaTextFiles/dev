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
** The ShowHide demo shows how to hide and show objects.
*/

OPT PREPROCESS, POINTER

MODULE 'exec'
MODULE 'utility/tagitem'
MODULE 'libraries/gadtools'
MODULE 'muimaster', 'libraries/mui', 'libraries/muip',
       /*'mui/muicustomclass',*/ 'amigalib/boopsi',
       'intuition/classes', 'intuition/classusr',
       'intuition/screens', 'intuition/intuition'

TYPE PTIO IS PTR TO INTUIOBJECT

PROC main()
  DEF app:PTIO, window:PTIO, sigs, cm[6]:ARRAY OF PTIO, bt[6]:ARRAY OF PTIO
 
  IF (muimasterbase := OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN)) = NIL THEN Throw("ERR", 'Failed to open muimaster.library')

  app := ApplicationObject,
    MUIA_Application_Title      , 'ShowHide',
    MUIA_Application_Version    , '$VER: ShowHide 13.56 (30.01.96)',
    MUIA_Application_Copyright  , 'c1992/93, Stefan Stuntz',
    MUIA_Application_Author     , 'Stefan Stuntz & Klaus Becker',
    MUIA_Application_Description, 'Show object hiding.',
    MUIA_Application_Base       , 'SHOWHIDE',
    SubWindow, window := WindowObject,
      MUIA_Window_Title, 'Show & Hide',
      MUIA_Window_ID   , "SHHD",
      WindowContents, HGroup, 
        Child, VGroup, GroupFrame,
          Child, HGroup, MUIA_Weight, 0,
            Child, cm[1] := CheckMark(MUI_TRUE),
            Child, cm[2] := CheckMark(MUI_TRUE),
            Child, cm[3] := CheckMark(MUI_TRUE),
            Child, cm[4] := CheckMark(MUI_TRUE),
            Child, cm[5] := CheckMark(MUI_TRUE),
          End,
          Child, VGroup, 
            Child, bt[1] := SimpleButton('Button 1'),
            Child, bt[2] := SimpleButton('Button 2'),
            Child, bt[3] := SimpleButton('Button 3'),
            Child, bt[4] := SimpleButton('Button 4'),
            Child, bt[5] := SimpleButton('Button 5'),
            Child, VSpace(0),
          End,
        End,
      End,
    End,
  End

  IF app = NIL THEN Throw("ERR", 'Failed to create Application.')

/*
** Install notification events...
*/

  doMethodA(window, [MUIM_Notify, MUIA_Window_CloseRequest,MUI_TRUE,
    app,2, MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

  doMethodA(cm[1], [MUIM_Notify, MUIA_Selected,MUIV_EveryTime,bt[1],3,MUIM_Set,MUIA_ShowMe,MUIV_TriggerValue])
  doMethodA(cm[2], [MUIM_Notify, MUIA_Selected,MUIV_EveryTime,bt[2],3,MUIM_Set,MUIA_ShowMe,MUIV_TriggerValue])
  doMethodA(cm[3], [MUIM_Notify, MUIA_Selected,MUIV_EveryTime,bt[3],3,MUIM_Set,MUIA_ShowMe,MUIV_TriggerValue])
  doMethodA(cm[4], [MUIM_Notify, MUIA_Selected,MUIV_EveryTime,bt[4],3,MUIM_Set,MUIA_ShowMe,MUIV_TriggerValue])
  doMethodA(cm[5], [MUIM_Notify, MUIA_Selected,MUIV_EveryTime,bt[5],3,MUIM_Set,MUIA_ShowMe,MUIV_TriggerValue])

  set(cm[3],MUIA_Selected,FALSE)

/*
** This is the ideal input loop for an object oriented MUI application.
** Everything is encapsulated in classes, no return ids need to be used,
** we just check if the program shall terminate.
** Note that MUIM_Application_NewInput expects sigs to contain the result
** from Wait() (or 0). This makes the input loop significantly faster.
*/

  set(window, MUIA_Window_Open,MUI_TRUE)

  sigs := 0
  WHILE doMethodA(app, [MUIM_Application_NewInput,ADDRESSOF sigs]) <> MUIV_Application_ReturnID_Quit
    IF sigs THEN sigs := Wait(sigs)
  ENDWHILE

  set(window, MUIA_Window_Open,FALSE)

/*
** Shut down...
*/

FINALLY
  IF app THEN Mui_DisposeObject(app)
  IF muimasterbase THEN CloseLibrary(muimasterbase)
  IF exceptionInfo THEN Print('\s\n',exceptionInfo)
ENDPROC
