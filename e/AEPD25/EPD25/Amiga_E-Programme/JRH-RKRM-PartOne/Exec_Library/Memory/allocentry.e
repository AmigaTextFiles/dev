-> allocentry.e - Example of allocating several memory areas.

MODULE 'exec/memory'

CONST ALLOCERROR=$80000000

-> E-Note: like the Assembly version, a ml does not contain a me, so body[4]
OBJECT memBlocks
  head:ml              -> One entry in the header, additional entries follow
  body[4]:ARRAY OF me  -> directly as part of the same data structure
ENDOBJECT

DEF memlist:PTR TO ml,  -> Pointer to a ml object
    memblocks:memBlocks

PROC main()
  memblocks.head.numentries:=4  -> E-Note: The ml does not contain another me!

  -> Describe the first piece of memory we want.
  -> E-Note: every me is in the body, unlike the C version
  memblocks.body[0].reqs:=MEMF_CLEAR
  memblocks.body[0].length:=4000

  -> Describe the other pieces of memory we want.  Additional me's are
  -> initialised this way.  If we wanted even more entries, we would need to
  -> declare a larger me array in our memBlocks object.
  memblocks.body[1].reqs:=MEMF_CHIP OR MEMF_CLEAR
  memblocks.body[1].length:=100000
  memblocks.body[2].reqs:=MEMF_PUBLIC OR MEMF_CLEAR
  memblocks.body[2].length:=200000
  memblocks.body[3].reqs:=MEMF_PUBLIC
  memblocks.body[3].length:=25000

  memlist:=AllocEntry(memblocks)

  IF memlist AND ALLOCERROR  -> 'error' bit 31 is set (see below).
    WriteF('AllocEntry FAILED\n')
  ENDIF

  -> We got all memory we wanted.  Use it and call FreeEntry() to free it
  WriteF('AllocEntry succeeded - now freeing all allocated blocks\n')
  FreeEntry(memlist)
ENDPROC
