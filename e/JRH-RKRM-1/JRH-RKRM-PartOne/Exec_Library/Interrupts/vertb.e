-> vertb.e - Vertical blank interrupt server example.

-> E-Note: we need eCodeSoftInt() in order to execute E code as an interrupt
->         (this wouldn't be needed if we just used Assembly, see below)
MODULE 'other/ecode',
       'dos/dos',
       'exec/interrupts',
       'exec/memory',
       'exec/nodes',
       'hardware/intbits'

ENUM ERR_NONE, ERR_ECODE

PROC main() HANDLE
  DEF vbint:PTR TO is, counter=0, endcount

  -> Allocate memory for interrupt node.
  vbint:=NewM(SIZEOF is, MEMF_PUBLIC OR MEMF_CLEAR)
  vbint.ln.type:=NT_INTERRUPT  -> Initialise the node.
  vbint.ln.pri:=-60
  vbint.ln.name:='VertB-Example'
  vbint.data:={counter}
  vbint.code:=eCodeIntServer({vertBServer})
  IF vbint.code=NIL THEN Raise(ERR_ECODE)

  AddIntServer(INTB_VERTB, vbint)  -> Kick this interrupt server into life.

  WriteF('VBlank server will increment a counter every frame.\n')
  WriteF('counter started at zero, CTRL-C to remove server\n')

  Wait(SIGBREAKF_CTRL_C)
  endcount:=counter
  WriteF('\d vertical blanks occurred\nRemoving server\n', endcount)

  RemIntServer(INTB_VERTB, vbint)

EXCEPT DO
  -> E-Note: not really necessary...
  IF vbint THEN Dispose(vbint)
  SELECT exception
  CASE ERR_ECODE;  WriteF('Error: Ran out of memory in eCodeIntServer()\n')
  CASE "MEM";      WriteF('Error: Ran out of memory\n')
  ENDSELECT
ENDPROC

-> Entered with:       A0 == scratch (execpt for highest pri vertb server)
->  D0 == scratch      A1 == is_Data
->  D1 == scratch      A5 == vector to interrupt code (scratch)
->                     A6 == scratch
->
-> E-Note: we could use this Assembly, but we'll show how to use a PROC instead
->         (so we needed eCodeIntServer() above)
->
-> vertBServer:
->   ADDI.L #1, (A1)  -> Increments counter is_Data points to
->   MOVEQ.L #0, D0   -> Set Z flag to continue to process other vb-servers
->   RTS              -> Return to exec

-> E-Note: we get vbint.data as an argument, and the PROC result should be
->         zero to continue with other servers in this chain (the default),
->         or non-zero (e.g., RETURN TRUE) to skip them
PROC vertBServer(data:PTR TO LONG)
  data[]:=data[]+1
ENDPROC