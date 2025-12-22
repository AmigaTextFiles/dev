-> Cia_Interval.e - Demonstrate allocation and use of a cia interval timer

OPT PREPROCESS

-> E-Note: we need eCodeIntServer() in order to use an E PROC as a CIA interrupt
MODULE 'other/cia',
       'other/ecode',
       'exec/interrupts',
       'exec/libraries',
       'exec/nodes',
       'exec/tasks',
       'hardware/cia',
       'resources/cia'

ENUM ERR_NONE, ERR_ECODE, ERR_SIG, ERR_TIMER

CONST COUNTDOWN=20, HICOUNT=$FF, LOCOUNT=$FF

CONST STOPA_AND=CIACRAF_TODIN OR CIACRAF_PBON OR
                CIACRAF_OUTMODE OR CIACRAF_SPMODE
   ->
   -> AND mask for use with control register A
   -> (interval timer A on either CIA)
   ->
   -> STOP -
   ->       START bit 0 == 0 (STOP IMMEDIATELY)
   ->       PBON  bit 1 == same
   ->       OUT   bit 2 == same
   ->       RUN   bit 3 == 0 (SET CONTINUOUS MODE)
   ->       LOAD  bit 4 == 0 (NO FORCE LOAD)
   ->       IN    bit 5 == 0 (COUNTS 02 PULSES)
   ->       SP    bit 6 == same
   ->       TODIN bit 7 == same (unused on ciacra)

CONST STOPB_AND=CIACRBF_ALARM OR CIACRBF_PBON OR CIACRBF_OUTMODE
   ->
   -> AND mask for use with control register B
   -> (interval timer B on either CIA)
   ->
   -> STOP -
   ->       START bit 0 == 0 (STOP IMMEDIATELY)
   ->       PBON  bit 1 == same
   ->       OUT   bit 2 == same
   ->       RUN   bit 3 == 0 (SET CONTINUOUS MODE)
   ->       LOAD  bit 4 == 0 (NO FORCE LOAD)
   ->       IN0   bit 5 == 0 (COUNTS 02 PULSES)
   ->       IN1   bit 6 == 0 (COUNTS 02 PULSES)
   ->       ALARM bit 7 == same (TOD alarm control bit)

CONST STARTA_OR=CIACRAF_START
   ->
   -> OR mask for use with control register A
   -> (interval timer A on either CIA)
   ->
   -> START -
   ->
   ->       START bit 0 == 1 (START TIMER)
   ->
   ->       All other bits unaffected.

CONST STARTB_OR=CIACRBF_START
   ->
   -> OR mask for use with control register B
   -> (interval timer A on either CIA)
   ->
   -> START -
   ->
   ->       START bit 0 == 1 (START TIMER)
   ->
   ->       All other bits unaffected.

-> Structure which will be used to hold all relevant information about cia
-> timer we manage to allocate.
OBJECT freetimer
  ciabase            -> CIA Library Base
  timerbit           -> Timer bit allocated
  cia                -> Pointer to hardware
  ciacr:PTR TO CHAR  -> Pointer to control register
  cialo:PTR TO CHAR  -> Pointer to low byte of timer
  ciahi:PTR TO CHAR  -> Pointer to high byte of timer
  timerint:is        -> Interrupt structure
  stopmask:CHAR      -> Stop/set-up timer
  startmask:CHAR     -> Start timer
ENDOBJECT

-> Structure which will be used by the interrupt routine called when our
-> cia interval timer generates an interrupt.
OBJECT exampledata
  task    -> Task to signal
  signal  -> Signal bit to use
  counter
ENDOBJECT

DEF ciaa=CIAA_ADDR:PTR TO cia, ciab=CIAB_ADDR:PTR TO cia

-> This is the interrupt routine which will be called when our CIA interval
-> timer counts down.
->
-> This example decrements a counter each time the interrupt routine is called
-> until the counter reaches 0, at which time it signals our main task.
->
-> Note that interrupt handling code should be efficient, and will generally be
-> written in assembly code.  Signaling another task such as this example does
-> is also a useful way of handling interrupts in an expedient manner.
-> E-Note: thanks to eCodeIntServer() we get ft.timerint.data as an argument
PROC exampleInterrupt(ed:PTR TO exampledata)
  IF ed.counter
    ed.counter:=ed.counter-1  -> Decrement counter
  ELSE
    ed.counter:=COUNTDOWN     -> Reset counter
    Signal(ed.task, Shl(1, ed.signal))
  ENDIF
ENDPROC

PROC main() HANDLE
  DEF ft:freetimer, ed:exampledata

  -> Set up data which will be passed to interrupt
  ed.task:=FindTask(NIL)

  -> E-Note: C version doesn't check the return value properly
  ed.signal:=AllocSignal(-1)
  IF ed.signal=-1 THEN Raise(ERR_SIG)

  -> Prepare freetimer object: set-up interrupt
  ft.timerint.ln.type:=NT_INTERRUPT
  ft.timerint.ln.pri:=0
  ft.timerint.ln.name:='cia_example'

  ft.timerint.data:=ed
  -> E-Note: eCodeIntServer() wraps an E PROC for use as a CIA interrupt
  ft.timerint.code:=eCodeIntServer({exampleInterrupt})
  IF ft.timerint.code=NIL THEN Raise(ERR_ECODE)

  -> Call function to find a free CIA interval timer with flag indicating
  -> that we prefer a CIA-A timer.
  WriteF('Attempting to allocate a free timer\n')

  findFreeTimer(ft, TRUE)

  WriteF('CIA-\c timer ', IF ft.cia=ciaa THEN "A" ELSE "B")

  WriteF('\c allocated\n', IF ft.timerbit=CIAICRB_TA THEN "A" ELSE "B")

  -> We found a free interval timer.  Let's start it running.
  startTimer(ft, ed)

  -> Wait for a signal
  WriteF('Waiting for signal bit \d\n', ed.signal)

  Wait(Shl(1, ed.signal))

  WriteF('We woke up!\n')

  -> Release the interval timer
  remICRVector(ft.ciabase, ft.timerbit, ft.timerint)

EXCEPT DO
  IF ed.signal<>-1 THEN FreeSignal(ed.signal)
  SELECT exception
  CASE ERR_ECODE;  WriteF('Ran out of memory in eCodeIntServer()\n')
  CASE ERR_SIG;    WriteF('Could not allocate signal\n')
  CASE ERR_TIMER;  WriteF('No CIA interval timer available\n')
  ENDSELECT
ENDPROC

-> This routine sets up the interval timer we allocated with addICRVector().
-> Note that we may have already received one, or more interrupts from our
-> timer.  Make no assumptions about the initial state of any of the hardware
-> registers we will be using.
PROC startTimer(ft:PTR TO freetimer, ed:PTR TO exampledata)
  DEF cia:PTR TO cia
  cia:=ft.cia

  -> Note that there are differences between control register A, and B on
  -> each CIA (e.g., the TOD alarm bit, and INMODE bits).
  IF ft.timerbit=CIAICRB_TA
    -> E-Note: use offsets to get addresses of the CIA bytes
    ft.ciacr:=cia+CIACRA    -> Control register A
    ft.cialo:=cia+CIATALO   -> Low byte counter
    ft.ciahi:=cia+CIATAHI   -> High byte counter

    ft.stopmask:=STOPA_AND  -> Set-up mask values
    ft.startmask:=STARTA_OR
  ELSE
    ft.ciacr:=cia+CIACRB    -> Control register B
    ft.cialo:=cia+CIATBLO   -> Low byte counter
    ft.ciahi:=cia+CIATBHI   -> High byte counter

    ft.stopmask:=STOPB_AND  -> Set-up mask values
    ft.startmask:=STARTB_OR
  ENDIF

  -> Modify control register within Disable().  This is done to avoid race
  -> conditions since code like this will be generated:
  ->
  ->      value = Read hardware byte
  ->      AND  value with MASK
  ->      Write value to hardware byte
  ->
  -> If we take a task switch in the middle of this sequence, two tasks trying
  -> to modify the same register could trash each others' bits.
  ->
  -> Normally this code would be written in Assembly language using atomic
  -> instructions so that the Disable() would not be needed.

  Disable()
  -> STOP timer, set 02 pulse count-down mode, set continuous mode
  ft.ciacr[]:=ft.ciacr[] AND ft.stopmask
  Enable()

  -> Clear signal bit - interrupt will signal us later
  SetSignal(NIL, Shl(1, ed.signal))

  -> Count-down X number of times
  ed.counter:=COUNTDOWN

  -> Start the interval timer - we will start the counter after writing the
  -> low, and high byte counter values.
  ft.cialo[]:=LOCOUNT
  ft.ciahi[]:=HICOUNT

  -> Turn on start bit - same bit for both A, and B control regs
  Disable()
  ft.ciacr[]:=ft.ciacr[] OR ft.startmask
  Enable()
ENDPROC

-> A routine to find a free interval timer.
->
-> This routine makes no assumptions about which interval timers (if any) are
-> available for use.  Currently there are two interval timers per CIA chip.
->
-> Because CIA usage may change in the future, your code should use a routine
-> like this to find a free interval timer.
->
-> Note that the routine takes a preference flag (which is used to indicate
-> that you would prefer an interval timer on CIA-A).  If the flag is FALSE,
-> it means that you would prefer an interval timer on CIA-B.
PROC findFreeTimer(ft:PTR TO freetimer, preferA)
  DEF ciaabase, ciabbase

  -> Get pointers to both Resource bases
  ciaabase:=OpenResource(CIAANAME)
  ciabbase:=OpenResource(CIABNAME)

  -> Try for a CIA-A timer first?
  ft.ciabase:=IF preferA THEN ciaabase ELSE ciabbase  -> Library address
  ft.cia:=IF preferA THEN ciaa ELSE ciab              -> Hardware address

  IF tryTimer(ft) THEN RETURN

  -> Try for an interval timer on the other cia
  ft.ciabase:=IF preferA THEN ciabbase ELSE ciaabase  -> Library address
  ft.cia:=IF preferA THEN ciab ELSE ciaa              -> Hardware address

  IF tryTimer(ft)=FALSE THEN Raise(ERR_TIMER)
ENDPROC

-> Try to obtain a free interval timer on a CIA.
PROC tryTimer(ft:PTR TO freetimer)
  IF NIL=addICRVector(ft.ciabase, CIAICRB_TA, ft.timerint)
    ft.timerbit:=CIAICRB_TA
    RETURN TRUE
  ENDIF

  IF NIL=addICRVector(ft.ciabase, CIAICRB_TB, ft.timerint)
    ft.timerbit:=CIAICRB_TB
    RETURN TRUE
  ENDIF
ENDPROC FALSE
