/*
    $Id: show_mailtext.c,v 1.7 1997/01/29 21:31:09 olf Exp olf $

    Mailtext.mcc/.mcp (c) by Olaf Peters

    Example for Mailtext.mcc

    show_mailtext.e (E version by William Newton <wnewton@zetnet.co.uk>)
*/

OPT PREPROCESS
OPT OSVERSION=37

ENUM ID_ACTIONURL=1, ID_ACTIONEMAIL

MODULE 'exec/memory'

MODULE 'mui/Mailtext_mcc'
MODULE 'mui/NList_mcc'
MODULE 'mui/NListview_mcc'
MODULE 'muimaster', 'libraries/mui'
MODULE 'utility/tagitem', 'utility/hooks'
MODULE 'intuition/classes', 'intuition/classusr'


MODULE 'dos/rdargs', 'dos/dos', 'dos/var'

ENUM ER_NONE, ER_MUILIB, ER_APP

PROC main() HANDLE
DEF len,file,result,app, window, mt,signals, running = TRUE, testTextUsed = TRUE,text:PTR TO CHAR,  str:PTR TO CHAR

    IF (muimasterbase := OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN Raise(ER_MUILIB)

    IF (file:=Open(arg, OLDFILE))
        IF ((len:=FileLength(arg))>0)
            text:=New(len)
            IF (Read(file, text, len) = len)
                testTextUsed:=FALSE
                text[len]:='\0'
            ENDIF
        ENDIF
        Close(file)
    ENDIF

    IF (testTextUsed)
        text:='Testtext for Mailtext CustomClass\n\n*Bold* /Italics/ _Underline_ #Coloured# _Combination_\n\n\nQuoted Text:\n\n1>2>3>4>5> *Bold* /Italics/ _Underline_ #Coloured#\n\nURLs: http://home.pages.de/~Mailtext/\n\nTo clear things up a bit: (let + be *, /, _ or #)\n\n   +Text+\n   ^    ^\n   |    |\n   |    +- the terminating char\n   |\n   +- the introducing char\n\n-- \nolf@informatik.uni-bremen.de\n\n Also E version by William Newton :)'
    ENDIF

    app:=ApplicationObject,
              MUIA_Application_Title,       'Show_MailtextClass',
              MUIA_Application_Version,     'v1.0',
              MUIA_Application_Copyright,   '©1996 by Olaf Peters',
              MUIA_Application_Author,      'Olaf Peters (E Version by William Newton)',
              MUIA_Application_Description, 'Demonstrates the mailtext class.',
              MUIA_Application_Base,        'SHOWMAILTEXT',
              SubWindow, window:=WindowObject,
                                      MUIA_Window_Title, 'MailtextClass',
                                      MUIA_Window_ID,    'MAIL',
                                      WindowContents, VGroup,
                                         Child, NListviewObject,
                                             MUIA_NListview_NList, mt:=MailtextObject,
                                               MUIA_Mailtext_Text,              text,
                                               MUIA_Mailtext_ForbidContextMenu, FALSE,
                                               MUIA_Font,                       MUIV_Font_Fixed,
                                               MUIA_Frame,                      MUIV_Frame_InputList,
                                               MUIA_NList_Input,                TRUE,
                                               MUIA_NList_MultiSelect,          FALSE,
                                             End,
                                      End,
              End,
      End,
  End

    IF (app = NIL) THEN Raise(ER_APP)

    doMethod(window, [MUIM_Notify, MUIA_Window_CloseRequest, MUI_TRUE, app,
                               2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit])

    doMethod(mt, [MUIM_Notify, MUIA_Mailtext_ActionURL, MUIV_EveryTime, app,
                               2, MUIM_Application_ReturnID, ID_ACTIONURL])

/*    doMethod(mt, [MUIM_Notify, MUIA_Mailtext_ActionEMail, MUIV_EveryTime, app,
                               2, MUIM_Application_ReturnID, ID_ActionEMail])   */

    set(window,MUIA_Window_Open,TRUE)

    WHILE (running)
        result:=doMethod(app,[MUIM_Application_Input,{signals}])
        SELECT result

             CASE MUIV_Application_ReturnID_Quit
                 running:=FALSE
             CASE ID_ACTIONURL
                 get(mt, MUIA_Mailtext_ActionURL, {str})
                 WriteF('URL: \s\n', str)
        ENDSELECT

        IF (running AND signals)
            Wait(signals)
        ENDIF
    ENDWHILE

    set(window, MUIA_Window_Open, FALSE)

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

ENDPROC

/*
** doMethod (written by Wouter van Oortmerssen)
*/

PROC doMethod( obj:PTR TO object, msg:PTR TO msg )

        DEF h:PTR TO hook, o:PTR TO object, dispatcher

        IF obj
                o := obj-SIZEOF object  /* instance data is to negative offset */
                h := o.class
                dispatcher := h.entry   /* get dispatcher from hook in iclass */
                MOVEA.L h,A0
                MOVEA.L msg,A1
                MOVEA.L obj,A2          /* probably should use CallHookPkt, but the */
                MOVEA.L dispatcher,A3   /*   original code (doMethodA()) doesn't. */
                JSR (A3)                /* call classDispatcher() */
                MOVE.L D0,o
                RETURN o
        ENDIF
ENDPROC NIL
