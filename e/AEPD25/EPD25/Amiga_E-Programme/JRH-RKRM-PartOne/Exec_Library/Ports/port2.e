w, Enter Text',
                         WA_GADGETS, strGad,
                         WA_CLOSEGADGET, TRUE,
                         WA_IDCMP, IDCMP_ACTIVEWINDOW OR
                                   IDCMP_CLOSEWINDOW OR IDCMP_GADGETUP,
                         NIL])

  handleWindow(win, strGad)

  -> E-Note: exit and clean up via handler
EXCEPT DO
  IF win THEN CloseWindow(win)
  -> E-Note: we can print a minimal error message
  SELECT exception
  CASE ERR_KICK; WriteF('Error: Needs Kickstart V37+\n')
  CASE ERR_WIN;  WriteF('Error: Failed to open window\n')
  CASE "MEM";    WriteF('Error: Ran out of memory\n')
  ENDSELECT
ENDPROC

-> Process messages received by the window.  Quit when the close gadget
-> is selected, activate the gadget when the window becomes active.
-> E-Note: E version is simpler, since we use WaitIMessage
PROC handleWindow(win, gad)
  DEF class
  REPEAT
    class:=WaitIMessage(win)
    SELECT class
    CASE IDCMP_ACTIVEWINDOW
      -> Activate the string gadget.  This is how to activate a string gadget
      -> in a new window--wait for the window to become active by waiting for
      -> the IDCMP_ACTIVEWINDOW event, then activate the gadget.  Here we
      -> report on the success or failure.
      IF ActivateGadget(gad, win, NIL)
        updateStrGad(win, gad, 'Activated')
      ENDIF
    CASE IDCMP_GADGETUP
      -> If it's a gadget message, IAddress points to Gadget.  If user hit
      -> RETURN in our string gadget for demonstration, we will change what he
      -> entered.  We only have 1 gadget, so we don't have to check which one.
      updateStrGad(win, strGad, answers[ansnum])
      INC ansnum  -> Point to next answer
      -> E-Note: we know the lengths of lists, so no need for ANSCNT
      IF ansnum>=ListLen(answers) THEN ansnum:=0
    ENDSELECT
  UNTIL class=IDCMP_CLOSEWINDOW
ENDPROC

-> Routine to update the value in the string gadget's buffer, then activate
-> the gadget.
PROC updateStrGad(win, gad:PTR TO gadget, newstr)
  -> First, remove the gadget from the window.  This must be done before
  -> modifying any part of the gadget!!!
  RemoveGList(win, gad, 1)

  -> For fun, change the value in the buffer, as well as the cursor and initial
  -> display position.
  StrCopy(gad.specialinfo::stringinfo.buffer, newstr)
  gad.specialinfo::stringinfo.bufferpos:=0
  gad.specialinfo::stringinfo.disppos:=0

  -> Add the gadget back, placing it at the