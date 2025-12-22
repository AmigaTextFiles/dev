
OPT PREPROCESS

MODULE  'muimaster','libraries/mui','utility/tagitem','intuition/classes',
        'intuition/classusr','utility/hooks','htmltext_mcc','amigalib/boopsi',
        'mui/htmltext_mcc'

DEF ap_Test=NIL,wi_Test=NIL,running,result,signal,html,string

ENUM NONE,NOMUI,BADGUI

PROC main() HANDLE

    IF (muimasterbase:=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN Raise(NOMUI)

    ap_Test:=   ApplicationObject,
                    MUIA_Application_Base,'HTMLTEXTDEMO',
                    MUIA_Application_Title,'HTMLtext-DEMO',
                    SubWindow, wi_Test:=WindowObject,
                        MUIA_Window_Title,'HTMLtext-DEMO',
                        MUIA_Window_ID,123456,
                       
                        WindowContents,VGroup,                                            
                            Child,html:=HTMLtextObject, /* create the object */
                                TextFrame,
                                End,
                            Child,string:=StringObject,
                                StringFrame,
                                End,
                            End,
                        End,
                    End

    IF ap_Test=NIL THEN Raise(BADGUI)

    /* we want to show changes by the HTMLtextObject so we put a notification on
       the string gadget which will then update the HTML display */

    doMethodA(string, [MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,html,3,MUIM_Set,MUIA_HTMLtext_Contents,MUIV_TriggerValue])
    doMethodA(wi_Test,[MUIM_Notify,MUIA_Window_CloseRequest,MUIV_EveryTime,ap_Test,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

    set(string,MUIA_String_Contents,'<hr>This <i>is a <small>small</small> <big>Demo</big></i> of he <b>HTMLtext class</b>.<hr>')

    set(wi_Test,MUIA_Window_Open,MUI_TRUE)

    running:=1

    /* the ideal input loop... */

    WHILE running
        IF CtrlC() THEN running:=FALSE
        result:=doMethodA(ap_Test,[MUIM_Application_Input,{signal}])
        SELECT result
            CASE MUIV_Application_ReturnID_Quit
                running:=FALSE
        ENDSELECT
        IF signal THEN Wait(signal)
    ENDWHILE
    Raise(NONE)
EXCEPT
    IF ap_Test THEN Mui_DisposeObject(ap_Test)
    IF muimasterbase THEN CloseLibrary(muimasterbase)
ENDPROC
        
