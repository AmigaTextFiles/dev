-> allocate.e - Example of allocating and using a private memory pool.

MODULE 'exec/memory',
       'exec/nodes'

CONST BLOCKSIZE=4000  -> Or whatever you need

PROC main() HANDLE
  DEF mh=NIL:PTR TO mh, mc=NIL:PTR TO mc, block1, block2

  -> Get the MemHeader needed to keep track of our new block.
  NEW mh

  -> Get the actual block the above MemHeader will manage.
  mc:=NewR(BLOCKSIZE)

  mh.ln.type:=NT_MEMORY
  mh.first:=mc
  mh.lower:=mc
  mh.upper:=mc+BLOCKSIZE
  mh.free:=BLOCKSIZE

  mc.next:=NIL  -> Set up first chunk in the freelist
  mc.bytes:=BLOCKSIZE

  block1:=Allocate(mh, 20)
  block2:=Allocate(mh, 314)

  WriteF('Our mh object at $\h.  Our block of memory at $\h\n'