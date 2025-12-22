{ Fenster "locken" (Fenster "gesperrt") (Lock.p)

  $VER:             1.0 (01.09.96)

  Autor
  Pascal-Version:   Falk Zühlsdorff  (EMail: ai036@rz.tu-ilmenau.de)
                    CDproV3.x, APrintV3.x,...,
                    P.U.R.I.T.Y.-Pascal-FD, Amiga Zentrum Thüringen e.V.
}

Program LockWindow;

USES Exec,Intuition;
{$incl 'dos.lib','workbench/startup.h','icon.lib','wb.lib','wizard.lib',
       'asl.lib'};

CONST WIZARDFILE          = "lock.wizard";
      WINDOW_MAIN         = 1;
      WINDOW_MAIN_GADGETS = 3;
      MAIN_BUTTON_OPEN    = 2;

VAR   surface             : Ptr;
      screen              : p_Screen;
      newwin              : p_NewWindow;
      window              : p_Window;
      winhandle           : p_WizardWindowHandle;

      gads                : array[0..WINDOW_MAIN_GADGETS] of p_gadget;
      msg                 : p_IntuiMessage;

      tags                : array[0..2] of tagitem;
      tags2               : array[0..1] of tagitem;
      flag,dummy          : boolean;
      dummylong           : long;

      filereq             : Ptr;

      { folgende Variablen dienen dazu den Startpfad des unseres
        Programmes zu ermitteln (dort muß sich das WIZARDFILE befinden) }

      WBmsg               : p_WBStartup;
      hlp                 : integer;
      StartName           : String[108]; {Pfad+Name des Wizardfiles ablegen}

PROCEDURE CleanUp; {sauber aufräumen... }
BEGIN
 IF window<>NIL        THEN WZ_CloseWindow(winhandle);
 IF winhandle<>NIL     THEN WZ_FreeWindowHandle(winhandle);
 IF surface<>NIL       THEN WZ_CloseSurface(surface);
 IF screen<>NIL        THEN UnlockPubScreen(NIL,screen);
 IF WizardBase<>NIL    THEN CloseLibrary(WizardBase);
 IF IntuitionBase<>NIL THEN CloseLibrary(IntuitionBase);
 IF AslBase<>NIL       THEN CloseLibrary(AslBase);
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

 surface:=NIL;winhandle:=NIL;newwin:=NIL;window:=NIL;screen:=NIL;filereq:=NIL;

 {-- Libraries öffnen --}

 WizardBase:=OpenLibrary('wizard.library',0);
 IF WizardBase = NIL THEN exit;

 AslBase:=OpenLibrary('asl.library',0);
 IF AslBase = NIL THEN exit;

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

       tags2[0]:=TagItem(ASLFR_Screen,long(screen));
       tags2[1].ti_tag:=tag_done;

       filereq:=AllocAslRequest(ASL_FileRequest,^tags2);

       IF filereq<>NIL
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
                          IDCMP_IDCMPUPDATE:
                           BEGIN
                            WZ_LockWindow(winhandle);
                            dummy:=AslRequest(filereq,NIL); {...}
                            dummyLong:=WZ_UnlockWindow(winhandle);
                           END;
                         ELSE;END;
                        END;

                   UNTIL flag;
                  END;
               END;
            END;
          FreeAslRequest(filereq);
         END;
      END;
   END;

 CleanUp;
END.










