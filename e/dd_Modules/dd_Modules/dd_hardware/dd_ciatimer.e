-> dd_ciatimer.e - © 1994-1995 by Digital Disturbance. Freeware.
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
MODULE 'timer'
MODULE 'devices/timer'
MODULE 'exec/ports','exec/io'

MODULE 'tools/debug'
-> MODULE '*dd_debugoff'
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

CONST CIAA=$bfe001,CIAB=$bfd000
-> ENDFOLD
-> FOLD OBJECTS
EXPORT OBJECT ciatimer PRIVATE
  -> base of used cia resource
  ciabase:PTR TO lib
  -> used cia hardware address
  cia:LONG
  -> ICR used timer bit
  timerbit:LONG
  -> cia int control reg
  ciacr:PTR TO CHAR
  -> low & high timer values
  cialo:PTR TO CHAR
  ciahi:PTR TO CHAR
  -> interrupt attached to a cia timer
  interrupt:PTR TO is
ENDOBJECT
-> ENDFOLD
-> FOLD DEFS
DEF ciaabase,ciabbase

-> private global librarybases
DEF utilitybase
-> ENDFOLD

-> FOLD new
EXPORT PROC new(tags:PTR TO tagitem) OF ciatimer
  DEF success=FALSE

  -> utility library opened?
  IF utilitybase:=OpenLibrary('utility.library',36)

    IF GetTagData(DDA_CIA_Interrupt,NIL,tags)

      -> open cia resources
      ciaabase:=OpenResource('ciaa.resource')
      ciabbase:=OpenResource('ciab.resource')

      -> allocated a CIA timer?
      IF success:=self.tryCIATimer(tags)

        -> set interrupt
        self.interrupt:=GetTagData(DDA_CIA_Interrupt,NIL,tags)

        -> set object attributes
        self.set(tags)

      ENDIF
    ENDIF
  ENDIF
ENDPROC success
-> ENDFOLD
-> FOLD tryCIATimer
PROC tryCIATimer(tags:PTR TO tagitem) OF ciatimer
  DEF success=FALSE

  KPUTSTR('trying cia ')

  -> cia a wanted?
  IF GetTagData(DDA_CIA_UseCIAA,TRUE,tags)

    KPUTSTR('a\n')
    self.ciabase:=ciaabase
    self.cia:=CIAA

  -> cia b wanted
  ELSE

    KPUTSTR('b\n')
    self.ciabase:=ciabbase
    self.cia:=CIAB

  ENDIF

  -> first allocation attempt
  success:=self.tryTimer(tags)

  -> first attempt failed and fallback activated?
  IF (success=FALSE) AND (GetTagData(DDA_CIA_FallBack,FALSE,tags)<>FALSE)
    KPUTSTR('trying cia ')

    -> timer a requested?
    IF GetTagData(DDA_CIA_UseCIAA,TRUE,tags)
      -> then try b now
      KPUTSTR('b\n')
      self.ciabase:=ciabbase
      self.cia:=CIAB
    -> timer b requested
    ELSE
      -> then try a now
      KPUTSTR('a\n')
      self.ciabase:=ciaabase
      self.cia:=CIAA
    ENDIF

    -> second allocation attempt
    success:=self.tryTimer(tags)

  ENDIF
ENDPROC success
-> ENDFOLD
-> FOLD tryTimer
PROC tryTimer(tags:PTR TO tagitem) OF ciatimer
  DEF otheruser:PTR TO is

  -> timer a requested?
  IF GetTagData(DDA_CIA_UseTimerA,TRUE,tags)
    -> timer a requested
    KPUTSTR('  trying timer a...')
    -> timer a allocated?
    IF (otheruser:=addICRVector(self.ciabase,CIAICRB_TA,GetTagData(DDA_CIA_Interrupt,NIL,tags)))=0
      KPUTSTR('got it\n')

      -> set timer to a
      self.timerbit:=CIAICRB_TA
      self.ciacr:=self.cia+CIACRA
      self.cialo:=self.cia+CIATALO
      self.ciahi:=self.cia+CIATAHI
      RETURN TRUE

    -> timer a in use
    ELSE

      KPUTFMT('in use by \s\n',[otheruser::ln.name])

      IF GetTagData(DDA_CIA_FallBack,FALSE,tags)=FALSE
        -> do not try other timer
        RETURN FALSE
      ENDIF

    ENDIF
  ENDIF
  -> timer b requested
  -> or timer a requested, but not available, so now trying timer b
  KPUTSTR('  timer b...')
  -> timer b allocated?
  IF (otheruser:=addICRVector(self.ciabase,CIAICRB_TB,GetTagData(DDA_CIA_Interrupt,NIL,tags)))=0
    KPUTSTR('got it\n')
    self.timerbit:=CIAICRB_TB
    self.ciacr:=self.cia+CIACRB
    self.cialo:=self.cia+CIATBLO
    self.ciahi:=self.cia+CIATBHI
    RETURN TRUE
  -> timer b not allocated
  ELSE
    KPUTFMT('in use by \s\n',[otheruser::ln.name])
    -> try other timer?
    IF GetTagData(DDA_CIA_FallBack,FALSE,tags)=FALSE
      -> do not try other timer
      RETURN FALSE
    ENDIF
  ENDIF
  -> timer b requested, but not available, and now trying timer a
  IF GetTagData(DDA_CIA_UseTimerA,TRUE,tags)=FALSE
    KPUTSTR('  timer a...')
    -> timer a allocated?
    IF (otheruser:=addICRVector(self.ciabase,CIAICRB_TA,GetTagData(DDA_CIA_Interrupt,NIL,tags)))=0
      self.timerbit:=CIAICRB_TA
      self.ciacr:=self.cia+CIACRA
      self.cialo:=self.cia+CIATALO
      self.ciahi:=self.cia+CIATAHI
      KPUTSTR('got it\n')
      RETURN TRUE
    ELSE
      KPUTFMT('in use by \s\n',[otheruser::ln.name])
    ENDIF
  ENDIF
ENDPROC FALSE
-> ENDFOLD
-> FOLD end
EXPORT PROC end() OF ciatimer
  -> valid interrupt attached?
  KPUTSTR('end() called\n')
  IF self.interrupt
    KPUTSTR('removing icr vector\n')
    -> remove interrupt
    remICRVector(self.ciabase,self.timerbit,self.interrupt)
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
EXPORT PROC set(tags:PTR TO LONG) OF ciatimer
  DEF microsecs,timerticks,eclockrate

  IF microsecs:=GetTagData(DDA_CIA_MicroSecs,0,tags)

    KPUTFMT('microsecs=\d\n',[microsecs])

    eclockrate:=eclock()

    -> calculate timer ticks
    timerticks:=microsecs!*(!(eclockrate!)/1000000.0)!

    -> hardcoded to PAL systems
    -> timerticks:=microsecs!*.709379!

    -> non floating point equivalent
    -> microsecs:=Div(Mul(7094,microsecs),10000)

    KPUTFMT('timer ticks=\d\n',[timerticks])

    -> put MSB of 16-bit value into timerhi
    PutChar(self.ciahi,Shr(microsecs AND $0000FF00,8))
    -> put LSB of 16-bit value into timerlo
    PutChar(self.cialo,microsecs AND $000000FF)

    KPUTFMT('timerhi=$\h\ntimerlo=$\h\n',[self.ciahi,self.cialo])
  ENDIF
ENDPROC
-> ENDFOLD
-> FOLD start
EXPORT PROC start() OF ciatimer
  DEF ciacr
  ciacr:=self.ciacr
  KPUTSTR('starting timer\n')

  -> move icr address into A0
  MOVE.L ciacr,A0

  -> set start bit (first bit on both timer a and b)
  BSET.B #CIACRAB_START,(A0)
ENDPROC
-> ENDFOLD
-> FOLD stop
EXPORT PROC stop() OF ciatimer
  DEF ciacr
  ciacr:=self.ciacr
  KPUTSTR('stopping timer\n')

  -> move icr address into A0
  MOVE.L ciacr,A0

  -> clear start bit (first bit on both timer a and b)
  BCLR.B #CIACRAB_START,(A0)

ENDPROC
-> ENDFOLD

-> FOLD addICRVector
PROC addICRVector(resource:PTR TO lib,icrbit,is:PTR TO is)
  MOVE.L resource,A6
  MOVE.L icrbit,D0
  MOVE.L is,A1
  JSR -6(A6)
ENDPROC D0
-> ENDFOLD
-> FOLD remICRVector
PROC remICRVector(resource:PTR TO lib,icrbit,is:PTR TO is)
  MOVE.L resource,A6
  MOVE.L icrbit,D0
  MOVE.L is,A1
  JSR -12(A6)
ENDPROC
-> ENDFOLD
-> FOLD eclock()
PROC eclock()
  DEF timerio=NIL:PTR TO timerequest
  DEF timermp=NIL:PTR TO mp
  DEF eclockval:eclockval
  DEF eclockrate=709379

  ->  create messageport for timer feedback
  IF timermp:=CreateMsgPort()

    ->  create iorequest message to issue commands
    IF timerio:=CreateIORequest(timermp,SIZEOF timerequest)

      ->  open the wanted unit of the timer device
      IF OpenDevice('timer.device',UNIT_MICROHZ,timerio,0)=NIL
        timerbase:=timerio.io::io.device

        eclockrate:=ReadEClock(eclockval)
        KPUTFMT('eclockrate=\d\n',[eclockrate])

        CloseDevice(timerio)
        timerbase:=NIL
      ENDIF
      DeleteIORequest(timerio)
      timerio:=NIL

    ENDIF
    DeleteMsgPort(timermp)
    timermp:=NIL
  ENDIF
ENDPROC eclockrate
-> ENDFOLD
