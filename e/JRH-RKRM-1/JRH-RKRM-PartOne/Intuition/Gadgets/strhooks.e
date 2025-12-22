-> strhooks.e - string gadget hooks demo
-> E-Note: this uses several of the 'tools' modules, notably 'installhook'

MODULE 'utility',
       'graphics/rastport',
       'intuition/intuition',
       'intuition/screens',
       'intuition/sghooks',
       'utility/hooks',
       'tools/ctype',
       'tools/installhook'

ENUM ERR_NONE, ERR_DRAW, ERR_KICK, ERR_LIB, ERR_PUB, ERR_WIN

RAISE ERR_DRAW IF GetScreenDrawInfo()=NIL,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_PUB  IF LockPubScreen()=NIL,
      ERR_WIN  IF OpenWindowTagList()=NIL

CONST SG_STRLEN=44, MYSTRGADWIDTH=200

-> We'll dynamically allocate/clear most structures, buffers
OBJECT vars
  sgg_Window:PTR TO window
  sgg_Gadget:gadget
  sgg_StrInfo:stringinfo
  sgg_Extend:stringextend
  sgg_Hook:hook
  sgg_Buff[SG_STRLEN]:ARRAY
  sgg_WBuff[SG_STRLEN]:ARRAY
  sgg_UBuff[SG_STRLEN]:ARRAY
ENDOBJECT

-> Open all required libraries, set-up the string gadget.
-> Prepare the hook, open the sgg_Window and go...
PROC main() HANDLE
  -> E-Note: subtle name changes needed...
  DEF vars=NIL:PTR TO vars, screen=NIL:PTR TO screen,
      drawinfo=NIL:PTR TO drawinfo

  IF KickVersion(37)=FALSE THEN Raise(ERR_KICK)

  utilitybase:=OpenLibrary('utility.library', 37)

  -> Get the correct pens for the screen
  screen:=LockPubScreen(NIL)

  drawinfo:=GetScreenDrawInfo(screen)

  NEW vars  -> E-Note: raises an exception if it fails
  vars.sgg_Extend.pens[0]:=drawinfo.pens[FILLTEXTPEN]
  vars.sgg_Extend.pens[1]:=drawinfo.pens[FILLPEN]
  vars.sgg_Extend.activepens[0]:=drawinfo.pens[FILLTEXTPEN]
  vars.sgg_Extend.activepens[1]:=drawinfo.pens[FILLPEN]
  vars.sgg_Extend.edithook:=vars.sgg_Hook
  vars.sgg_Extend.workbuffer:=vars.sgg_WBuff

  vars.sgg_StrInfo.buffer:=vars.sgg_Buff
  vars.sgg_StrInfo.undobuffer:=vars.sgg_UBuff
  vars.sgg_StrInfo.maxchars:=SG_STRLEN
  vars.sgg_StrInfo.extension:=vars.sgg_Extend

  -> There should probably be a border around the string gadget.
  -> As is, it is hard to locate when disabled.
  vars.sgg_Gadget.leftedge:=20
  vars.sgg_Gadget.topedge:=30
  vars.sgg_Gadget.width:=MYSTRGADWIDTH
  vars.sgg_Gadget.height:=screen.rastport.txheight
  vars.sgg_Gadget.flags:=GFLG_GADGHCOMP OR GFLG_STRINGEXTEND
  vars.sgg_Gadget.activation:=GACT_RELVERIFY
  vars.sgg_Gadget.gadgettype:=GTYP_STRGADGET
  vars.sgg_Gadget.specialinfo:=vars.sgg_StrInfo
  -> E-Note: use typed lists for border and its data
  -> E-Note: because we're using E we don't need stupid INIT_LATER
  vars.sgg_Gadget.gadgetrender:=[-2,-2,1,0,RP_JAM1,5,
                                  [0, 0,
                                   MYSTRGADWIDTH+3, 0,
                                   MYSTRGADWIDTH+3, screen.rastport.txheight+3,
                                   0, screen.rastport.txheight+3,
                                   0, 0]:INT,
                                 NIL]:border

  -> E-Note: use Wouter's installhook
  installhook(vars.sgg_Hook, {str_hookRoutine})

  vars.sgg_Window:=OpenWindowTagList(NIL,
                        [WA_PUBSCREEN, screen,
                         WA_LEFT,      21, WA_TOP,        20,
                         WA_WIDTH,    500, WA_HEIGHT,    150,
                         WA_MINWIDTH,  50, WA_MAXWIDTH,   -1,
                         WA_MINHEIGHT, 30, WA_MAXHEIGHT,  -1,
                         WA_SIMPLEREFRESH, TRUE,
                         WA_NOCAREREFRESH, TRUE,
                         WA_RMBTRAP,       TRUE,
                         WA_IDCMP,   IDCMP_GADGETUP OR IDCMP_CLOSEWINDOW,
                         WA_FLAGS,   WFLG_CLOSEGADGET OR WFLG_NOCAREREFRESH OR
                                     WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR
                                     WFLG_SIMPLE_REFRESH,
                         WA_TITLE,   'String Hook Accepts HEX Digits Only',
                         WA_GADGETS, vars.sgg_Gadget,
                         NIL])
  handleWindow(vars)
  -> E-Note: exit and clean up via handler
EXCEPT DO
  IF (vars<>NIL) AND vars.sgg_Window THEN CloseWindow(vars.sgg_Window)
  -> E-Note: vars automatically freed
  IF drawinfo THEN FreeScreenDrawInfo(screen, drawinfo)
  IF screen THEN UnlockPubScreen(NIL, screen)
  IF utilitybase THEN CloseLibrary(utilitybase)
  -> E-Note: we can print a minimal error message
  SELECT exception
  CASE ERR_DRAW; WriteF('Error: Failed to get drawinfo from screen\n')
  CASE ERR_KICK; WriteF('Error: Needs Kickstart V37+\n')
  CASE ERR_LIB;  WriteF('Error: Failed to open utility.library\n')
  CASE ERR_PUB;  WriteF('Error: Failed to lock public screen\n')
  CASE ERR_WIN;  WriteF('Error: Failed to open window\n')
  CASE "MEM";    WriteF('Error: Ran out of memory\n')
  ENDSELECT
ENDPROC

-> This is an example string editing hook, which shows the basics of creating
-> a string editing function.  This hook restricts entry to hexadecimal digits
-> (0-9, A-F, a-f) and converts them to upper case.  To demonstrate processing
-> of mouse-clicks, this hook also detects clicking on a character, and
-> converts it to a zero.
->
-> NOTE String editing hooks are called on Intuition's task context, so the
-> hook may not use DOS and may not cause Wait() to be called.
PROC str_hookRoutine(hook, sgw:PTR TO sgwork, msg:PTR TO LONG)
  DEF work_ptr, return_code

  -> Hook must return non-zero if command is supported.
  -> This will be changed to zero if the command is unsupported.
  return_code:=-1

  IF msg[]=SGH_KEY
    -> Key hit -- could be any key (Shift, repeat, character, etc.)

    -> Allow only upper case characters to be entered.
    -> Act only on modes that add or update characters in the buffer.
    IF (sgw.editop=EO_REPLACECHAR) OR (sgw.editop=EO_INSERTCHAR)
      -> Code contains the ASCII representation of the character entered, if
      -> it maps to a single byte.  We could also look into the work buffer to
      -> find the new character.
      ->
      ->     sgw.code = sgw.workbuffer[sgw.bufferpos-1]
      ->
      -> If the character is not a legal hex digit, don't use the work buffer
      -> and beep the screen.
      -> E-Note: use isxdigit from 'tools/ctype'
      IF isxdigit(sgw.code)=FALSE
        sgw.actions:=sgw.actions OR SGA_BEEP
        sgw.actions:=sgw.actions AND Not(SGA_USE)
      ELSE
        -> And make it upper-case, for nicety
        work_ptr:=sgw.workbuffer
        work_ptr[sgw.bufferpos-1]:=toupper(sgw.code)
      ENDIF
    ENDIF
  ELSEIF msg[]=SGH_CLICK
    -> Mouse click
    -> Zero the digit clicked on
    IF sgw.bufferpos < sgw.numchars
      work_ptr:=sgw.workbuffer+sgw.bufferpos
      work_ptr[]:="0"
    ENDIF
  ELSE
    -> UNKNOWN COMMAND
    -> Hook should return zero if the command is not supported
    return_code:=0
  ENDIF
ENDPROC return_code

-> E-Note: we don't need the hookEntry stuff, installhook does it all

-> Process messages received by the sgg_Window.  Quit when the close gadget
-> is selected.
-> E-Note: E version is simpler, since we use WaitIMessage
PROC handleWindow(vars:PTR TO vars)
  DEF class
  REPEAT
    class:=WaitIMessage(vars.sgg_Window)
    -> If a code is set in the hook after an SGH_KEY command, where SGA_END is
    -> set on return from the hook, the code will be returned in the Code field
    -> of the IDCMP_GADGETUP message.
    -> E-Note: ...so use MsgCode() to get at it
  UNTIL class=IDCMP_CLOSEWINDOW
ENDPROC
