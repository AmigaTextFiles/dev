OPT OSVERSION=37,PREPROCESS

MODULE 'tools/easygui', 'plugins/ticker', '*rexxstate'

DEF rxs=NIL:PTR TO rexxstate, tick=NIL:PTR TO ticker,
    or, os, ot, oc, tg, cg


PROC main() HANDLE
  NEW rxs.new()
  NEW tick
  easygui_fallbackA('ARexx state', gui(), [EG_WTYPE, WTYPE_NOSIZE, 0])
EXCEPT DO
  END tick
  END rxs
ENDPROC

#define RUNNING_NAME IF or := rxs.running() THEN \
  '_Shutdown ARexx' ELSE '_Start ARexx'
#define SUSPEND_NAME IF os := rxs.suspended() THEN \
  'Res_ume ARexx programs' ELSE 'S_uspend ARexx programs'

PROC gui() IS [EQROWS,
  [BUTTON, {running}, RUNNING_NAME,        0, "s"],
  [BUTTON, {suspend}, SUSPEND_NAME,        0, "u"],
  [BUTTON, {halt}, '_Halt Arexx programs', 0, "h"],
  [PLUGIN, {update}, tick],

  [BAR],

tg := [CHECK, {trace}, '_Trace mode',    ot := rxs.tracing(),      0, 0, "t"],
cg := [CHECK, {cons},  'Trace _console', oc := rxs.console_open(), 0, 0, "c"]
]


-> action procedures

PROC update(gh, x)
  -> called 10 times a second (when the window is activated) by the ticker
  -> this will update the GUI if someone else changes the state of ARexx,
  -> with another command or such.
  -> the old states (or, os, ot & oc) are updated when calling gui()
  IF (rxs.running() <> or) OR (rxs.suspended() <> os) OR
  (rxs.tracing() <> ot) OR (rxs.console_open() <> oc) THEN
    changegui(gh, gui())
ENDPROC

PROC running(gh)
  IF rxs.running() THEN rxs.shutdown() ELSE rxs.start()
  update(gh, 0) -> will need to redraw GUI if button name changed
ENDPROC

PROC suspend(gh)
  IF rxs.suspended() THEN rxs.resume() ELSE rxs.suspend()
  update(gh, 0) -> will need to redraw GUI if button name changed
ENDPROC

PROC halt() IS rxs.halt()

PROC trace(gh)
  IF rxs.tracing() THEN rxs.trace_off() ELSE rxs.trace_on()
  setcheck(gh, tg, ot := rxs.tracing())
ENDPROC

PROC cons(gh)
  IF rxs.console_open() THEN rxs.close_console() ELSE rxs.open_console()
  setcheck(gh, tg, oc := rxs.console_open())
ENDPROC
