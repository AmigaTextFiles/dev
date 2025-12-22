/* Einfache (aber schnelle) Pool-Verwaltung, im Moment nur Anhängen möglich */

MODULE 'exec/memory','sven/mempool'

PROC main() HANDLE
DEF poo:PTR TO pool,
    mem[5]:ARRAY OF LONG

  WriteF('Waiting for end of harddisk activity ...')
  Delay(50)
  WriteF('Ok\n\n')
  WriteF('Free Memory : \d\n',AvailMem(MEMF_ANY))

  poo:=__CreatePool()

  mem[0]:=__AllocPooled(poo,20)
  mem[1]:=__AllocPooled(poo,20000)
  mem[2]:=__AllocPooled(poo,12000000)
  mem[3]:=__AllocPooled(poo,19)
  mem[4]:=__AllocPooled(poo,1)

EXCEPT DO

  WriteF('Free Memory : \d\n',AvailMem(MEMF_ANY))
  __DeletePool(poo)
  WriteF('Free Memory : \d\n',AvailMem(MEMF_ANY))

  IF exception="MEMP"
    WriteF('Could not get enough memory !!\n')
  ENDIF
  
ENDPROC CleanUp(0)

