-> trap.e - E example of sample integer divide-by-zero trap

MODULE 'exec/tasks'

DEF oldTrapCode, countdiv0

PROC main()
  DEF thistask:PTR TO tc, k, j, z

  thistask:=FindTask(NIL)

  -> Save our task's current trap code pointer
  oldTrapCode:=thistask.trapcode

  -> Point task to our assembler trap handler code.  Ours will just count
  -> divide-by-zero traps, and pass other traps on to the normal TrapCode.
  thistask.trapcode:={trapa}

  countdiv0:=0

  z:=0  -> E-Note: the E compiler will not allow an explicit "k/0"!
  FOR k:=0 TO 3  -> Let's divide by zero a few times
    WriteF('dividing \d by zero... ', k)
    j:=k/z
    WriteF('did it\n')
  ENDFOR
  WriteF('\nDivide by zero happened \d times\n', countdiv0)

  thistask.trapcode:=oldTrapCode  -> Restore old trap code
ENDPROC

trapa:                       -> Our trap handler entry
  CMPI.L #5, (A7)            -> Is this a divide by zero ?
  BNE.S notdiv0              -> No
  ADD.L #1, countdiv0        -> Yes, increment our div0 count
endtrap:
  ADDQ #4, A7                -> Remove exception number from SSP
  RTE                        -> Return from exception
notdiv0:
  TST.L oldTrapCode          -> Is there another trap handler ?
  BEQ.S endtrap              -> No, so we'll exit
  MOVE.L oldTrapCode, -(A7)  -> Yes, go on to old TrapCode
  RTS                        -> Jumps to old TrapCode
