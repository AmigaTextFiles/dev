-> pubscreenbeep.e
->
-> Simple example of how to find a public screen to work with in Release 2.

-> E-Note: no need for modules, since we don't use anything that isn't built-in,
-> but module 'intuition/screens' would be needed if we actually needed to know
-> that "my_wbscreen_ptr" was a "PTR TO screen" rather than just a pointer...
PROC main()
  DEF my_wbscreen_ptr  -> Pointer to the Workbench screen

  IF KickVersion(36)
    -> OK, we have the right version of the OS so we can use the new public
    -> screen functions of Release 2 (V36)
    IF my_wbscreen_ptr:=LockPubScreen('Workbench')
      -> OK found the Workbench screen.  Normally the program would be here.
      -> A window could be opened or the attributes of the screen copied
      DisplayBeep(my_wbscreen_ptr)

      UnlockPubScreen(NIL, my_wbscreen_ptr)
    ENDIF
  ELSE
    -> Prior to Release 2 (V36), there were no public screens, just Workbench.
    -> In those older systems, windows can be opened on Workbench without
    -> locking or a pointer by setting the Type=WBENCHSCREEN in object "nw".
    -> Attributes can be obtained by setting the Type argument to WBENCHSCREEN
    -> in the call to GetScreenData().
  ENDIF
ENDPROC
