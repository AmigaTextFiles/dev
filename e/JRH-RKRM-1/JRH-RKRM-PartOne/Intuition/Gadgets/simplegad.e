-> simplegad.e - show the use of a button gadget.

MODULE 'graphics/rastport',   -> RastPort and other structures
       'intuition/intuition'  -> Intuition data structures and tags

CONST BUTTON_GAD_NUM=3, MYBUTTONGADWIDTH=100, MYBUTTONGADHEIGHT=50

-> NOTE that the use of constant size and positioning values are not
-> recommended; it just makes it easy to show what is going on. The position
-> of the gadget should be dynamically adjusted depending on the height of the
-> font in the title bar of the window.

ENUM ERR_NONE, ERR_WIN, ERR_KICK

RAISE ERR_WIN IF OpenWindowTagList()=NIL

-> Routine to show the use of a button (boolean) gadget.
PROC main() HANDLE
  DEF win=NIL:PTR TO window, class, gad:PTR TO gadget
  -> Make sure to get version 37, for OpenWindowTags() */
  IF KickVersion(37)=FALSE THEN Raise(ERR_KICK)

  -> E-Note: E automatically opens the Intuition library
  -> E-Note: automatically error-checked (automatic exception)
  win:=OpenWindowTagList(NIL,
                        [WA_WIDTH, 400,
                         WA_HEIGHT, 100,
                         WA_GADGETS,  -> E-Note: use typed lists for gadget
			     [NIL, 20, 20, MYBUTTONGADWIDTH, MYBUTTONGADHEIGHT,
			      GFLG_GADGHCOMP, GACT_RELVERIFY OR GACT_IMMEDIATE,
			      GTYP_BOOLGADGET,
			        [-1, -1, 1, 0, RP_JAM1, 5, -> E-Note: Border
				   [0, 0,      -> E-Note: 5 co-ords (INTs)
				    MYBUTTONGADWIDTH+1, 0,
				    MYBUTTONGADWIDTH+1, MYBUTTONGADHEIGHT+1,
				    0, MYBUTTONGADHEIGHT+1,
				    0,0]:INT,
			         NIL]:border,
			      NIL, NIL, 0, NIL, BUTTON_GAD_NUM, NIL]:gadget,
                         WA_ACTIVATE, TRUE,
                         WA_CLOSEGADGET, TRUE,
                         WA_IDCMP, IDCMP_GADGETDOWN OR IDCMP_GADGETUP OR
                                   IDCMP_CLOSEWINDOW,
                         NIL])
  REPEAT
    class:=WaitIMessage(win)
    -> SELECT on the type of the event
    SELECT class
    CASE IDCMP_GADGETUP
      -> Caused by GACT_RELVERIFY
      gad:=MsgIaddr()
      WriteF('Received an IDCMP_GADGETUP , gadget number \d\n', gad.gadgetid)
    CASE IDCMP_GADGETDOWN
      -> Caused by GACT_IMMEDIATE
      gad:=MsgIaddr()
      WriteF('Received an IDCMP_GADGETDOWN , gadget number \d\n', gad.gadgetid)
    ENDSELECT
  UNTIL class=IDCMP_CLOSEWINDOW
  WriteF('Received an IDCMP_CLOSEWINDOW\n')

  -> E-Note: exit and clean up via handler
EXCEPT DO
  IF win THEN CloseWindow(win)
  -> E-Note: we can print a minimal error message
  SELECT exception
  CASE ERR_WIN;  WriteF('Error: Failed to open window\n')
  CASE ERR_KICK; WriteF('Error: Needs Kickstart V37+\n')
  CASE "MEM";    WriteF('Error: Ran out of memory\n')
  ENDSELECT
ENDPROC