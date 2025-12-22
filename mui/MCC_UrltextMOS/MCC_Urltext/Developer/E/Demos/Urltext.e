-> converted to E by Jean Holzammer (Development@Holzammer.net) 13.07.2001

OPT PREPROCESS

MODULE 'muimaster','libraries/mui','mui/urltext_mcc','tools/boopsi','utility/tagitem','utility/hooks'

OBJECT app_obj
  app      :   PTR TO LONG
ENDOBJECT

DEF app:PTR TO app_obj,running=TRUE,signals,dummy
DEF mwin,u0,u1,u2,u3,t0

PROC main()
  IF muimasterbase:=OpenLibrary('muimaster.library',MUIMASTER_VMIN)
    NEW app.create()
    IF app.app
      app.init_notifications()
      WHILE running
        signals:=0
        dummy:=domethod(app.app,[MUIM_Application_Input,{signals}])
        SELECT dummy
        CASE MUIV_Application_ReturnID_Quit
          running:=FALSE
        ENDSELECT
        IF running=TRUE AND signals<>0 THEN Wait(signals)
      ENDWHILE
      app.dispose()
    ELSE
      PrintF('Can''t create the Application object\n')
    ENDIF
    CloseLibrary(muimasterbase)
  ELSE
    PrintF('Can''t open muimaster.library\n')
  ENDIF
ENDPROC

PROC urlTextObject(url,text,font) IS UrltextObject,
                                       MUIA_Font,font,
                                       MUIA_Urltext_Text,text,
                                       MUIA_Urltext_Url,url,
                                     End


PROC create() OF app_obj

  self.app:=ApplicationObject,
    MUIA_Application_Title , 'Urltext' ,
    MUIA_Application_Version , '$VER: Urltext 1.0 (10.7.2001)' ,
    MUIA_Application_Copyright , 'Copyright 2001 by Alfonso Ranieri' ,
    MUIA_Application_Author , 'Alfonso Ranieri' ,
    MUIA_Application_Description , 'Urltext example' ,
    MUIA_Application_Base , 'URLTEXT' ,
    SubWindow,mwin:=WindowObject,
                        MUIA_Window_Title,'Urltext example',
                        MUIA_Window_ID,"MWIN",

                        WindowContents, VGroup,
                          Child, VSpace(0),
                          Child, HGroup,
                            Child, HSpace(0),
                            Child, ColGroup(3),
                              Child, u0:=urlTextObject('http://web.tiscalinet.it/amiga/','Alfie\as home page',MUIV_Font_Big),
                              Child, HSpace(8),
                              Child, u1:=urlTextObject('http://web.tiscalinet.it/amiga/rxmui','RxMUI home page',MUIV_Font_Normal),
                              Child, u2:=urlTextObject('http://www.egroups.co/group/rxmui','RxMUi mail list',MUIV_Font_Normal),
                              Child, HSpace(8),
                              Child, u3:=urlTextObject('mailto:alforan@tin.it','Alfonso Ranieri',MUIV_Font_Normal),
                            End,
                            Child, HSpace(0),
                          End,
                          Child, VSpace(0),
                          Child, t0:=TextObject,
                            MUIA_Frame,         MUIV_Frame_Text,
                            MUIA_Background,    MUII_TextBack,
                            MUIA_Text_PreParse, '\\33c',
                        End,
              End,
    End,
  End
ENDPROC self.app

PROC dispose() OF app_obj IS Mui_DisposeObject(self.app)

PROC init_notifications() OF app_obj
  domethod(mwin,[MUIM_Notify, MUIA_Window_CloseRequest,MUI_TRUE,self.app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

  domethod(u0,[MUIM_Notify,MUIA_Urltext_Url,MUIV_EveryTime,t0,3,MUIM_Set,MUIA_Text_Contents,MUIV_TriggerValue])
  domethod(u1,[MUIM_Notify,MUIA_Urltext_Url,MUIV_EveryTime,t0,3,MUIM_Set,MUIA_Text_Contents,MUIV_TriggerValue])
  domethod(u2,[MUIM_Notify,MUIA_Urltext_Url,MUIV_EveryTime,t0,3,MUIM_Set,MUIA_Text_Contents,MUIV_TriggerValue])
  domethod(u3,[MUIM_Notify,MUIA_Urltext_Url,MUIV_EveryTime,t0,3,MUIM_Set,MUIA_Text_Contents,MUIV_TriggerValue])

  set(mwin,MUIA_Window_Open,MUI_TRUE)
ENDPROC

