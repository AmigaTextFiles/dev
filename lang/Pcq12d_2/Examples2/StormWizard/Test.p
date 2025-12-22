PROGRAM test;

{ Testprogramm für die Anbindung von "StormWizard" an "MaxonPascal" /
  "KickPascal" (geschrieben unter KP2.12 (mit OS3-Includes))

  $VER:              1.2 (02.06.96)

  Autor:             Falk Zühlsdorff (ai036@rz.tu-ilmenau.de)
                     P.U.R.I.T.Y.-Pascal-FD, Amiga Zentrum Thüringen e.V.

                     PCQ Pascal version Nils Sjoholm (nils.sjoholm@mailbox.swipnet.se)

}
{$I "Include:Exec/Ports.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Libraries/wizard.i"}

CONST
    StartPath = "ram:Test.wizard";
{
    This is just a quick hack to see if it works.
    Remember to put Test.wizard in ram: or change the
    path above.
}

VAR MySurface      : Address;
    WBScreen       : ScreenPtr;
    MyWinHandle    : WizardWindowHandlePtr;
    Tags           : ARRAY[0..2] OF TagItem;

    MyNewWindow    : NewWindowPtr;
    MyWindow       : WindowPtr;
    MyGadgets      : ARRAY[0..2] OF GadgetPtr;

    Msg            : IntuiMessagePtr;
    ex             : boolean;
    hlp            : integer;

PROCEDURE CleanUp;
BEGIN
 IF MyWindow<>NIL      THEN WZ_CloseWindow(MyWinHandle);
 IF MyWinHandle<>NIL   THEN WZ_FreeWindowHandle(MyWinHandle);
 IF MySurface<>NIL     THEN WZ_CloseSurface(MySurface);
 IF WBScreen<>NIL      THEN UnlockPubScreen(NIL,WBScreen);
 IF WizardBase<>NIL    THEN CloseLibrary(WizardBase);
 exit(0);
END;

BEGIN
 

 MySurface:=NIL;MyWinHandle:=NIL;MyNewWindow:=NIL;MyWindow:=NIL;WBScreen:=NIL;

 WizardBase:=OpenLibrary("wizard.library",0);
 IF WizardBase = NIL THEN CleanUp;
 WBScreen:=LockPubScreen("Workbench");
 IF WBScreen<>NIL
  THEN
   BEGIN
     MySurface:=WZ_OpenSurfaceA(StartPath,NIL,NIL);
     IF MySurface=NIL THEN BEGIN CleanUp;END;

     MyWinHandle:=WZ_AllocWindowHandleA(WBScreen,0,MySurface,NIL);
     IF MySurface=NIL THEN BEGIN CleanUp;END;

     Tags[0].ti_tag:=WWH_GadgetArray;
     Tags[0].ti_Data:=Integer(MyGadgets);
     Tags[1].ti_tag:=TAG_DONE;

     MyNewWindow:=WZ_CreateWindowObjA(MyWinHandle,1,@Tags);
     IF MyNewWindow=NIL THEN BEGIN CleanUp;END;

     MyWindow:=WZ_OpenWindowA(MyWinHandle,MyNewWindow,NIL);
     IF MyWindow=NIL THEN BEGIN CleanUp;END;

     ex:=false;
     REPEAT
      Msg:=IntuiMessagePtr(WaitPort(MyWindow^.UserPort));
      Msg:=IntuiMessagePtr(GetMsg(MyWindow^.Userport));
      IF Msg<>NIL
         THEN
          BEGIN
           ReplyMsg(MessagePtr(Msg));
           IF  Msg^.Class=IDCMP_CLOSEWINDOW THEN ex:=true;
          END;

     UNTIL ex;
   END;

 CleanUp;
END.









