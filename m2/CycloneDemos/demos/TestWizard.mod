MODULE TestWizard;

(* Very simple example with use of STORMwizard by Marcel Timmermans
** 
** Using Cyclone Modula-2 by Marcel Timmermans
** 12.12.96 
*)


FROM SYSTEM IMPORT ADDRESS,ADR;
IMPORT ml:ModulaLib,id:IntuitionD,il:IntuitionL,wl:WizardL,wd:WizardD,
       el:ExecL,ed:ExecD;

VAR
 wbScreen:id.ScreenPtr;
 surface:ADDRESS;
 gadgets:ARRAY[1..25] OF id.Gadget;
 wizhandle:wd.WizardWindowHandlePtr;
 newwin:id.NewWindowPtr;
 win:id.WindowPtr;
 msg:id.IntuiMessagePtr;
 class:id.IDCMPFlagSet;

BEGIN
 wbScreen:=il.LockPubScreen(NIL);
 surface:=wl.WZ_OpenSurfaceA(ADR("PROGDIR:Test.wizard"),NIL,NIL);
 ml.Assert(surface#NIL,ADR("Cannot open surface"));
 wizhandle:=wl.WZ_AllocWindowHandleA(wbScreen,0,surface,NIL);
 ml.Assert(wizhandle#NIL,ADR("Cannot allocate windowhandler"));
 newwin:=wl.WZ_CreateWindowObjA(wizhandle,1,[wd.WWH_GadgetArray,ADR(gadgets),0]);
 ml.Assert(newwin#NIL,ADR("Cannot create window"));
 win:=wl.WZ_OpenWindowA(wizhandle,newwin,NIL);
 ml.Assert(win#NIL,ADR("Cannot open window"));

// main loop

 LOOP
  el.WaitPort(win^.userPort);
  msg:=el.GetMsg(win^.userPort);
  IF msg#NIL THEN
     class:=msg^.class;
     el.ReplyMsg(msg);
     IF (id.closeWindow IN class) THEN EXIT END;
  END;
 END;

// Close part 

CLOSE 
 IF win#NIL       THEN wl.WZ_CloseWindow(wizhandle (* !! *) ); END;
 IF wizhandle#NIL THEN wl.WZ_FreeWindowHandle(wizhandle); END;
 IF surface#NIL   THEN wl.WZ_CloseSurface(surface); END;
 IF wbScreen#NIL  THEN il.UnlockPubScreen(NIL,wbScreen); END;
END TestWizard.


