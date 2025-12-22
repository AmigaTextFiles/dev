/*
** NodeMaster_EGui.e
**
** (C)1996/97 Amiga Foundation Classes
**
** This code is placed in the Public Domain.
** It is intended FOR demostration of NodeMaster only.
**
** Feel free of examine, modify AND DO whatever you want!
**
*/

/*
** DESCRIPTION:
**
** NodeMaster can HANDLE Exec Lists of everything.
**
** Just TO show its power, you'll see a way of creating
** multiwindows application relying on Wouter's EasyGUI AND
** my NodeMaster. This application is quite complicated AND I'll try TO
** explain it in the better way I can. ;)
*/
OPT OSVERSION = 37

MODULE 'afc/nodemaster_oo',               -> This is OUR MODULE
       'tools/easygui'                    -> 'tools/easygui'... GUESS!

DEF nm:PTR TO nodemaster -> This is an hinstance of our NodeMaster

PROC main() HANDLE       -> Please, note: HANDLE keyword FOR EXCEPTIONS handling
  NEW nm.nodemaster()    -> Here we setup our OBJECT.

  dogui()                -> we MUST have at least one gui!

  REPEAT                 -> We will hear FOR GUI events
    multiwait()          -> (Of multiple windows ;) ...
  UNTIL FALSE

EXCEPT DO                -> In CASE of some problems... (OR just TO quit)
  IF exception<>"END!" THEN WriteF('Exception:\z\h[8]\n', exception)     -> Here there is a brief explanation
  closeall()
  END nm                 -> Remeber ALWAYS TO END a OBJECT!!!
  CleanUp(0)             -> Let's keep things clean...
ENDPROC

PROC dogui() HANDLE      -> This PROC creates a GUI on the WB screen
  DEF gh=NIL:PTR TO guihandle -> a guihandle (NOTE: It is LOCAL! ;)

  gh:=guiinit('NEW EasyGUI Window!',
              [EQROWS,
                [SBUTTON, {dogui}, 'Create!'],  -> This button just call dogui() again!
                [BAR],
                [SBUTTON, {do_quit},'Quit!']   -> This will quit ALL!
              ])

  nm.add(gh)     -> Here we add this GUI_handle TO our NodeMaster OBJECT
  Wait(gh.sig)   -> AND wait FOR this window's first signal

EXCEPT           -> In CASE of any error
  remgui(gh)     -> we remove THIS window from thje Windows LIST
  ReThrow()      -> AND rethrow() error one level up!
ENDPROC

PROC multiwait()  -> This is one of the most important PROCS!
  DEF gh:PTR TO guihandle -> Another LOCAL gui_handle var!
  DEF res                 -> Here we store Window event value...

  IF nm.first()   -> Let's start from the first GUI_handler we have stored...
    REPEAT
      gh:=nm.obj()  -> Here we set our gh TO original GUI_handler
      res:=guimessage(gh) -> We get one message
      IF res>=0           -> AND eventually close this GUI window
        remgui(gh)
      ENDIF
    UNTIL nm.succ() = FALSE  -> Now we JUMP TO the next one
  ENDIF
ENDPROC

PROC do_quit() IS Raise("END!")

PROC closeall() -> This PROC just close ALL opened windows

  IF nm.first() -> We start from the first
    REPEAT
      cleangui(nm.obj())    -> we clear things up
    UNTIL nm.succ() = FALSE  -> AND get the next
  ENDIF
ENDPROC

PROC remgui(gh:PTR TO guihandle) -> This PROC remove just one desired gui
  IF nm.first()                  -> Here we scan LIST from the first
    REPEAT
      IF gh = nm.obj()           -> IF the current item is exactly the one we want
        nm.del()                 -> We remove the item from the LIST
        cleangui(gh)             -> AND clear the interface
        RETURN                   -> THEN exit without ending the LOOP
      ENDIF
    UNTIL nm.succ() = FALSE      -> Here we look FOR the next item...
  ENDIF
ENDPROC
