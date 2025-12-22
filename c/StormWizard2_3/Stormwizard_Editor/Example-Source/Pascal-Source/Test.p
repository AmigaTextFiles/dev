{ Testprogramm für die Anbindung von "StormWizard" an "MaxonPascal" /
  "KickPascal" (geschrieben unter KP2.12 (mit OS3-Includes))

  $VER:              1.2 (02.06.96)

  Autor:             Falk Zühlsdorff (ai036@rz.tu-ilmenau.de)
                     P.U.R.I.T.Y.-Pascal-FD, Amiga Zentrum Thüringen e.V.
}

Program WizardTest;
USES Exec,Intuition;
{$incl 'dos.lib','workbench/startup.h','icon.lib','wb.lib','wizard.lib'};

VAR MySurface      : Ptr;
    WBScreen       : p_Screen;
    MyWinHandle    : p_WizardWindowHandle;
    Tags           : array[0..2] of tagitem;

    MyNewWindow    : p_NewWindow;
    MyWindow       : p_Window;
    MyGadgets      : array[0..2] of p_gadget;

    Msg            : p_IntuiMessage;
    ex             : boolean;
    WBMsg          : p_WBStartup;
    hlp            : integer;
    StartPath      : String[108];

PROCEDURE CleanUp;
BEGIN
 IF MyWindow<>NIL      THEN WZ_CloseWindow(MyWinHandle);
 IF MyWinHandle<>NIL   THEN WZ_FreeWindowHandle(MyWinHandle);
 IF MySurface<>NIL     THEN WZ_CloseSurface(MySurface);
 IF WBScreen<>NIL      THEN UnlockPubScreen(NIL,WBScreen);
 IF WizardBase<>NIL    THEN CloseLibrary(WizardBase);
 IF IntuitionBase<>NIL THEN CloseLibrary(IntuitionBase);
END;

BEGIN
 IF NOT FROMWB THEN exit;

 {-- Folgende Routine dient dazu den Startpfad des Testprogrammes zu
     sichern. "Test.wizard" muß sich im Verzeichnis des Testprogrammes
     befinden --}

 StartPath:='';
 WBMsg:=StartupMessage;

 IF WBMsg^.sm_NumArgs>=1
  THEN
   BEGIN
    hlp:=NameFromLock(WBMsg^.sm_ArgList^[1].wa_lock,^StartPath,107);
    IF (StartPath[Length(StartPath)])<>':'
     THEN StartPath:=StartPath+'/'+"Test.wizard"
     ELSE StartPath:=StartPath+"Test.wizard";
   END
  ELSE exit;

 {--- Die eigentliche Einbindung von StormWizard-Dateien... -----------------}

 MySurface:=NIL;MyWinHandle:=NIL;MyNewWindow:=NIL;MyWindow:=NIL;WBScreen:=NIL;

 WizardBase:=OpenLibrary('wizard.library',0);
 IF WizardBase = NIL THEN exit;
 WBScreen:=LockPubScreen('Workbench');
 IF WBScreen<>NIL
  THEN
   BEGIN
     MySurface:=WZ_OpenSurfaceA(StartPath,NIL,NIL);
     IF MySurface=NIL THEN BEGIN CleanUp;exit;END;

     MyWinHandle:=WZ_AllocWindowHandleA(WBScreen,0,MySurface,NIL);
     IF MySurface=NIL THEN BEGIN CleanUp;exit;exit;END;

     Tags[0]:=TagItem(WWH_GadgetArray,Long(^MyGadgets));
     Tags[1].ti_tag:=tag_done;

     MyNewWindow:=WZ_CreateWindowObjA(MyWinHandle,1,^Tags);
     IF MyNewWindow=NIL THEN BEGIN CleanUp;exit;END;

     MyWindow:=WZ_OpenWindowA(MyWinHandle,MyNewWindow,NIL);
     IF MyWindow=NIL THEN BEGIN CleanUp;exit;END;

     ex:=false;
     REPEAT
      Msg:=Wait_Port(MyWindow^.UserPort);
      Msg:=Get_Msg(MyWindow^.Userport);
      IF Msg<>NIL
         THEN
          BEGIN
           Reply_Msg(Msg);
           IF  Msg^.Class=IDCMP_CLOSEWINDOW THEN ex:=true;
          END;

     UNTIL ex;
   END;

 CleanUp;
END.









