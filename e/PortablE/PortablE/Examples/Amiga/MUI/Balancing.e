/* An old E example converted to PortablE.
   From http://aminet.net/package/dev/e/mui36dev-E */

/*
** MUI-Demosource in E.
** Based on the C example 'Balancing.c' by Stefan Stuntz.
** Translated TO E by Sven Steiniger
**
** Sorry FOR some uppercase words in the comments. This IS because OF
** my AutoCase-dictionary
*/

OPT PREPROCESS, POINTER

MODULE 'exec'
MODULE 'muimaster','libraries/mui',
       'intuition/classes','intuition/classusr',
       'dos/dos',
       'utility/tagitem','utility/hooks',
       'amigalib/boopsi'

TYPE PTIO IS PTR TO INTUIOBJECT

PROC main()
DEF app:PTIO, window:PTIO, sigs
  app := NIL
  
  IF (muimasterbase := OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN Throw("ERR", 'Couldn\'t open muimaster.library')

        app := ApplicationObject,
                MUIA_Application_Title      , 'BalanceDemo',
                MUIA_Application_Version    , '$VER: BalanceDemo 12.10 (21.11.95)',
                MUIA_Application_Copyright  , '©1995, Stefan Stuntz',
                MUIA_Application_Author     , 'Stefan Stuntz',
                MUIA_Application_Description, 'Show balancing groups',
                MUIA_Application_Base       , 'BALANCEDEMO',

                SubWindow, window := WindowObject,
                        MUIA_Window_Title, 'Balancing Groups',
                        MUIA_Window_ID   , "BALA",
                        MUIA_Window_Width , MUIV_Window_Width_Screen(50),
                        MUIA_Window_Height, MUIV_Window_Height_Screen(50),

                        WindowContents, HGroup,

                                Child, VGroup, GroupFrame, MUIA_Weight, 15,
                                        Child, RectangleObject, TextFrame, MUIA_Weight,  50, End,
                                        Child, RectangleObject, TextFrame, MUIA_Weight, 100, End,
                                        Child, BalanceObject, End,
                                        Child, RectangleObject, TextFrame, MUIA_Weight, 200, End,
                                        End,

                                Child, BalanceObject, End,

                                Child, VGroup,
                                        Child, HGroup, GroupFrame,
                                                Child, RectangleObject, TextFrame, MUIA_ObjectID, 123, End,
                                                Child, BalanceObject, End,
                                                Child, RectangleObject, TextFrame, MUIA_ObjectID, 456, End,
                                                End,
                                        Child, HGroup, GroupFrame,
                                                Child, RectangleObject, TextFrame, End,
                                                Child, BalanceObject, End,
                                                Child, RectangleObject, TextFrame, End,
                                                Child, BalanceObject, End,
                                                Child, RectangleObject, TextFrame, End,
                                                Child, BalanceObject, End,
                                                Child, RectangleObject, TextFrame, End,
                                                Child, BalanceObject, End,
                                                Child, RectangleObject, TextFrame, End,
                                                End,
                                        Child, HGroup, GroupFrame,
                                                Child, HGroup,
                                                        Child, RectangleObject, TextFrame, End,
                                                        Child, BalanceObject, End,
                                                        Child, RectangleObject, TextFrame, End,
                                                        End,
                                                Child, BalanceObject, End,
                                                Child, HGroup,
                                                        Child, RectangleObject, TextFrame, End,
                                                        Child, BalanceObject, End,
                                                        Child, RectangleObject, TextFrame, End,
                                                        End,
                                                End,
                                        Child, HGroup, GroupFrame,
                                                Child, RectangleObject, TextFrame, MUIA_Weight,  50, End,
                                                Child, RectangleObject, TextFrame, MUIA_Weight, 100, End,
                                                Child, BalanceObject, End,
                                                Child, RectangleObject, TextFrame, MUIA_Weight, 200, End,
                                                End,
                                        Child, HGroup, GroupFrame,
                                                Child, SimpleButton('Also'),
                                                Child, BalanceObject, End,
                                                Child, SimpleButton('Try'),
                                                Child, BalanceObject, End,
                                                Child, SimpleButton('Sizing'),
                                                Child, BalanceObject, End,
                                                Child, SimpleButton('With'),
                                                Child, BalanceObject, End,
                                                Child, SimpleButton('Shift'),
                                                End,
                                        End,
                                End,
                        End,

                End;

        IF app=NIL THEN Throw("ERR", 'Failed TO create Application.')

        doMethodA(window,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,
                  app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit]);


/*
** This is the ideal input loop for an object oriented MUI application.
** Everything is encapsulated in classes, no return ids need to be used,
** we just check if the program shall terminate.
** Note that MUIM_Application_NewInput expects sigs to contain the result
** from Wait() (or 0). This makes the input loop significantly faster.
*/

        set(window, MUIA_Window_Open,MUI_TRUE);

        sigs := 0
        WHILE doMethodA(app, [MUIM_Application_NewInput, ADDRESSOF sigs]) <> MUIV_Application_ReturnID_Quit
          IF sigs THEN sigs := Wait(sigs)
        ENDWHILE

        set(window, MUIA_Window_Open,FALSE);


/*
** Shut down...
*/

FINALLY
   IF app THEN Mui_DisposeObject(app)
   IF muimasterbase THEN CloseLibrary(muimasterbase)
   IF exception THEN Print('\s\n', exception)
ENDPROC

