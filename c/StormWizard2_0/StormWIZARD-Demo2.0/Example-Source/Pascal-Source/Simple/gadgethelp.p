{ Auslesen und Anzeigen eines Hilfe-Strings. (Gadgethelp.p)

  $VER:             1.0 (01.09.96)

  Autor
  Pascal-Version:   Falk Zühlsdorff  (EMail: ai036@rz.tu-ilmenau.de)
                    CDproV3.x, APrintV3.x,...,
                    P.U.R.I.T.Y.-Pascal-FD, Amiga Zentrum Thüringen e.V.

  ACHTUNG: in den Original OS3.0 Includes fehlt der Eintrag für die
           IDCMP_GADGETHELP (include/intuition/intuition.h). Wie folgt
           die Konstante ergänzen:

           IDCMP_GADGETHELP = $04000000;

}

Program Gadgethelp;

USES Exec,Intuition,Utility;
{$incl 'dos.lib','workbench/startup.h','icon.lib','wb.lib','wizard.lib'};

CONST WIZARDFILE               = "gadgethelp.wizard";
      WINDOW_MAIN              = 1;
      WINDOW_MAIN_GADGETS      = 4;

VAR   surface                  : Ptr;
      screen                   : p_Screen;
      newwin                   : p_NewWindow;
      window                   : p_Window;
      winhandle,helpwinhandle  : p_WizardWindowHandle;
      helpiaddress             : PTR;

      gads                     : array[0..WINDOW_MAIN_GADGETS] of p_gadget;
      msg                      : p_IntuiMessage;

      tags                     : array[0..2] of tagitem;
      tags2                    : array[0..1] of tagitem;
      flag                     : boolean;




      { folgende Variablen dienen dazu den Startpfad des unseres
        Programmes zu ermitteln (dort muß sich das WIZARDFILE befinden) }

      WBmsg                    : p_WBStartup;
      hlp                      : integer;
      StartName                : String[108]; {Pfad+Name des Wizardfiles ablegen}

PROCEDURE CleanUp; {sauber aufräumen... }
BEGIN
 IF window<>NIL        THEN WZ_CloseWindow(winhandle);
 IF winhandle<>NIL     THEN WZ_FreeWindowHandle(winhandle);
 IF surface<>NIL       THEN WZ_CloseSurface(surface);
 IF screen<>NIL        THEN UnlockPubScreen(NIL,screen);
 IF WizardBase<>NIL    THEN CloseLibrary(WizardBase);
 IF UtilityBase<>NIL   THEN CloseLibrary(UtilityBase);
 IF IntuitionBase<>NIL THEN CloseLibrary(IntuitionBase);
END;

BEGIN
 IF NOT FROMWB THEN exit;

 {-- besagten Startpfad ermitteln... --}

 StartName:='';
 WBmsg:=StartupMessage;

 IF WBmsg^.sm_NumArgs>=1
  THEN
   BEGIN
    hlp:=NameFromLock(WBmsg^.sm_ArgList^[1].wa_lock,^StartName,107);
    IF (StartName[Length(StartName)])<>':'
     THEN StartName:=StartName+'/'+WIZARDFILE
     ELSE StartName:=StartName+WIZARDFILE;;
   END
  ELSE exit;

 {--  Initialisierung --}

 surface:=NIL;winhandle:=NIL;newwin:=NIL;window:=NIL;screen:=NIL;

 {-- Library öffnen --}

 WizardBase:=OpenLibrary('wizard.library',0);
 IF WizardBase = NIL THEN exit;

 {-- Oberflächenbeschreibung laden --}

 surface:=WZ_OpenSurfaceA(StartName,NIL,NIL);
 IF surface<>NIL
  THEN
   BEGIN
    {-- Natürlich brauchen wir auch noch einen Screen --}

    screen:=LockPubScreen(NIL);
    IF screen<>NIL
     THEN
      BEGIN

       {-- windowhandle reservieren, mit dem die Objekte durch die
       wizard.library verwaltet werden                             --}

       winhandle:=WZ_AllocWindowHandleA(screen,0,surface,NIL);
       IF surface<>NIL
        THEN
         BEGIN
          Tags[0]:=TagItem(WWH_GadgetArray,Long(^gads));
          Tags[1]:=TagItem(WWH_GadgetArraySize,sizeof(gads));
          Tags[2].ti_tag:=tag_done;

          tags2[0]:=TagItem(WA_AutoAdjust,1);
          tags2[1].ti_tag:=tag_done;


          {-- Objekte anlegen --}

          newwin:=WZ_CreateWindowObjA(winhandle,1,^Tags);
          IF newwin<>NIL
           THEN
            BEGIN

             {Fenster mi allen Objekten öffnen }

             window:=WZ_OpenWindowA(winhandle,newwin,^tags2);
             IF window<>NIL
              THEN
               BEGIN

                {-- IDCMP_GADGETHELP-Intuition-Messages zuschalten --}

                HelpControl(window,HC_GADGETHELP);

                {-- Intuition-Message abfangen ... --}

                flag:=false;
                REPEAT
                 Msg:=Wait_Port(window^.UserPort);
                 Msg:=Get_Msg(window^.Userport);
                 IF Msg<>NIL
                    THEN
                     BEGIN
                      Reply_Msg(Msg);
                      CASE Msg^.Class OF
                       IDCMP_CLOSEWINDOW: flag:=true;
                       IDCMP_GADGETHELP:
                        IF msg^.iaddress<>NIL
                         THEN
                          SetWindowTitles(window,WZ_GadgetHelp(winhandle,msg^.iaddress),STR(-1))
                         ELSE
                          SetWindowTitles(window,'Außerhalb',STR(-1));

                       { IDCMP_GADGETHELP gibt es erst mit V39, vorher wie folgt emulieren...}

                       IDCMP_MOUSEMOVE:
                        IF WZ_GadgetHelpMsg(winhandle,PTR(helpwinhandle),PTR(helpiaddress),msg^.mouseX,msg^.mouseY,0)
                         THEN
                          IF msg^.iaddress<>NIL
                           THEN
                            SetWindowTitles(window,WZ_GadgetHelp(helpwinhandle,helpiaddress),STR(-1))
                           ELSE
                            SetWindowTitles(window,'Außerhalb',STR(-1));
                      ELSE;END;
                     END;

                UNTIL flag;
               END;
            END;
         END;
      END;
   END;

 CleanUp;
END.










