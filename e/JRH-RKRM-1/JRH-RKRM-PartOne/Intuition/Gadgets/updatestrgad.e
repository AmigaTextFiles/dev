-> updatestrgad.e - Show the use of a string gadget.  Shows both the use of
-> ActivateGadget() and how to properly modify the contents of a string gadget.

MODULE 'graphics/rastport',
       'intuition/intuition'

ENUM ERR_NONE, ERR_KICK, ERR_WIN

RAISE ERR_WIN IF OpenWindowTagList()=NIL

-> NOTE that the use of constant size and positioning values are not
-> recommended; it just makes it easy to show what is going on.  The position
-> of the gadget should be dynamically adjusted depending on the height of the
-> font in the title bar of the window.  This example adapts the gadget height
-> to the screen font. Alternatively, you could specify your font under V37
-> with the StringExtend structure.
CONST BUFSIZE=100, MYSTRGADWIDTH=200, MYSTRGADHEIGHT=8

DEF strBuffer[BUFSIZE]:STRING, strUndoBuffer[BUFSIZE]:STRING,
    strGad:PTR TO gadget, ansnum=0, answers:PTR TO LONG

-> Show the use of a string gadget.
PROC main() HANDLE
  DEF win=NIL:PTR TO window
  -> Make sure to get version 37, for OpenWindowTags()
  IF KickVersion(37)=FALSE THEN Raise(ERR_KICK)
  -> Load a value into the string gadget buffer.
  -> This will be displayed when the gadget is first created.
  StrCopy(strBuffer, 'START')

  -> E-Note: set-up the two globals...
  answers:=['Try Again','Sorry','Perhaps','A Winner']
  strGad:=[NIL, 20, 20, MYSTRGADWIDTH, MYSTRGADHEIGHT,
           GFLG_GADGHCOMP, GACT_RELVERIFY OR GACT_STRINGCENTER,
           GTYP_STRGADGET,
            [-2, -2, 1, 0, RP_JAM1, 5,
              [0, 0,
               MYSTRGADWIDTH + 3, 0,
               MYSTRGADWIDTH + 3, MYSTRGADHEIGHT + 3,
               0, MYSTRGADHEIGHT + 3,
               0, 0]:INT,
             NIL]:border,
           NIL, NIL, 0,
           -> E-Note: use NEW so remaining fields are allocated (and set to 0)
           NEW [strBuffer, strUndoBuffer, 0, BUFSIZE]:stringinfo,
           0, NIL]:gadget

  win:=OpenWindowTagList(NIL,
                        [WA_WIDTH, 400,
                         WA_HEIGHT, 100,
                         WA_TITLE, 'Activate Window, Enter Text',
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

  -> Add the gadget back, placing it at the end of the list (-1) and refresh
  -> its imagery.
  AddGList(win, gad, -1, 1, NIL)
  RefreshGList(gad, win, NIL, 1)

  -> Activate the string gadget
  ActivateGadget(gad, win, NIL)
ENDPROC