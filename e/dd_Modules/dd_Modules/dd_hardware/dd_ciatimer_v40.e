-> dd_ciatimer_v40.e - © 1994-1995 by Digital Disturbance. Freeware.
-> Programmed by Leon Woestenberg (Email: leon@stack.urc.tue.nl)

-> FOLD OPTS
OPT MODULE
OPT PREPROCESS
-> ENDFOLD
-> FOLD MODULES
MODULE 'exec/nodes'
MODULE 'exec/libraries'
MODULE 'exec/interrupts'
MODULE 'hardware/cia'
MODULE 'utility'
MODULE 'utility/tagitem'
MODULE 'lowlevel'

MODULE 'tools/debug'
MODULE '*dd_debugon'
-> ENDFOLD
-> FOLD CONSTS
EXPORT ENUM
  DDA_CIA_Dummy=TAG_USER,
  DDA_CIA_UseCIAA,
  DDA_CIA_UseTimerA,
  DDA_CIA_FallBack,
  DDA_CIA_Interrupt,
  DDA_CIA_MicroSecs
-> ENDFOLD
-> FOLD OBJECTS
EXPORT OBJECT ciatimer PRIVATE
  -> Add/RemTimerInt handle
  inthandle
  -> timervalue
  counter
  -> interrupt attached to a cia timer
  interrupt:PTR TO is
ENDOBJECT
-> ENDFOLD
-> FOLD DEFS

-> private global librarybases
DEF lowlevelbase
DEF utilitybase

-> ENDFOLD

-> FOLD new
EXPORT PROC new(tags:PTR TO tagitem) OF ciatimer
  DEF success=FALSE,temp

  -> utility library opened?
  IF utilitybase:=OpenLibrary('utility.library',36)

    -> interrupt given?
    IF temp:=GetTagData(DDA_CIA_Interrupt,NIL,tags)
      self.interrupt:=temp

      -> lowlevel library opened?
      IF lowlevelbase:=OpenLibrary('lowlevel.library',0)

        -> add timer interrupt
        IF temp:=AddTimerInt(self.interrupt.code,self.interrupt.data)
          self.inthandle:=temp

          -> set attributes
          self.set(tags)

          success:=TRUE
        ENDIF
      ENDIF
    ENDIF
  ENDIF
ENDPROC success
-> ENDFOLD
-> FOLD end
EXPORT PROC end() OF ciatimer
  -> valid handle?
  KPUTSTR('end() called\n')

  -> interrupt added?
  IF self.inthandle
    KPUTSTR('removing icr vector\n')

    -> remove interrupt
    RemTimerInt(self.inthandle)
    self.inthandle:=NIL
  ENDIF

  -> lowlevel library open?
  IF lowlevelbase
    KPUTSTR('closing lowlevel library\n')

    -> close lowlevel library
    CloseLibrary(lowlevelbase)
    lowlevelbase:=NIL
  ENDIF

  -> utility library open?
  IF utilitybase
    KPUTSTR('closing utility library\n')

    -> close utility library
    CloseLibrary(utilitybase)
    utilitybase:=NIL
  ENDIF
ENDPROC
-> ENDFOLD
-> FOLD set
EXPORT PROC set(tags) OF ciatimer
  DEF microsecs
  IF microsecs:=GetTagData(DDA_CIA_MicroSecs,0,tags)
    self.counter:=microsecs

    KPUTFMT('timer counter now set to \d\n',[microsecs])
  ENDIF
ENDPROC
-> ENDFOLD
-> FOLD start
EXPORT PROC start() OF ciatimer
  KPUTSTR('start()\n')
  IF self.inthandle
    KPUTSTR('starting timer\n')
    StartTimerInt(self.inthandle,self.counter,TRUE)
  ENDIF
ENDPROC
-> ENDFOLD
-> FOLD stop
EXPORT PROC stop() OF ciatimer
  KPUTSTR('stop()\n')
  IF self.inthandle
    KPUTSTR('stopping timer\n')
    StopTimerInt(self.inthandle)
  ENDIF
ENDPROC
-> ENDFOLD


