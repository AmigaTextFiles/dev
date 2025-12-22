-> RememberTest - Illustrates the use of AllocRemember() and FreeRemember().
-> E-Note: E's New() family of memory allocators are usually adequate...

MODULE 'dos/dos',
       'exec/memory'

RAISE "MEM" IF AllocRemember()=NIL

-> Random sizes to demonstrate the Remember functions. */
CONST SIZE_A=100, SIZE_B=200

PROC main()
  methodOne()
  methodTwo()
ENDPROC RETURN_OK

-> MethodOne
-> Illustrates using AllocRemember() to allocate all memory and FreeRemember()
-> to free it all.
PROC methodOne() HANDLE
  DEF memBlockA=NIL, memBlockB=NIL, rememberKey=NIL

  memBlockA:=AllocRemember({rememberKey}, SIZE_A, MEMF_CLEAR OR MEMF_PUBLIC)
  memBlockB:=AllocRemember({rememberKey}, SIZE_B, MEMF_CLEAR OR MEMF_PUBLIC)

  -> Both memory allocations succeeded.
  -> The program may now use this memory.

EXCEPT DO
  -> It is not necessary to keep track of the status of each allocation.
  -> Intuition has kept track of all successful allocations by updating its
  -> linked list of Remember nodes.  The following call to FreeRemember() will
  -> deallocate any and all of the memory that was successfully allocated.
  -> The memory blocks as well as the link nodes will be deallocated because
  -> the "ReallyForget" parameter is TRUE.
  ->
  -> It is possible to have reached the call to FreeRemember() in one of three
  -> states.  Here they are, along with their results.
  ->
  -> 1. Both memory allocations failed.
  ->       RememberKey is still NIL.  FreeRemember() will do nothing.
  -> 2. The memBlockA allocation succeeded but the memBlockB allocation failed.
  ->       FreeRemember() will free the memory block pointed to by memBlockA.
  -> 3. Both memory allocations were successful.
  ->       FreeRemember() will free the memory blocks pointed to by
  ->       memBlockA and memBlockB.
  FreeRemember({rememberKey}, TRUE)
  ReThrow()  -> E-Note: pass on exception if an error
ENDPROC

-> MethodTwo
-> Illustrates using AllocRemember() to allocate all memory, FreeRemember() to
-> free the link nodes, and FreeMem() to free the actual memory blocks.
PROC methodTwo() HANDLE
  DEF memBlockA=NIL, memBlockB=NIL, rememberKey=NIL

  memBlockA:=AllocRemember({rememberKey}, SIZE_A, MEMF_CLEAR OR MEMF_PUBLIC)
  memBlockB:=AllocRemember({rememberKey}, SIZE_B, MEMF_CLEAR OR MEMF_PUBLIC)

  -> Both memory allocations succeeded.
  -> For the purpose of illustration, FreeRemember() is called at this point,
  -> but only to free the link nodes.  The memory pointed to by memBlockA and
  -> memBlockB is retained.
  FreeRemember({rememberKey}, FALSE)

  -> Individually free the two memory blocks. The Exec FreeMem() call must be
  -> used, as the link nodes are no longer available.
  FreeMem(memBlockA, SIZE_A)
  FreeMem(memBlockB, SIZE_B)

EXCEPT DO
  -> It is possible to have reached the call to FreeRemember() in one of three
  -> states.  Here they are, along with their results.
  ->
  -> 1. Both memory allocations failed.
  ->    RememberKey is still NIL.  FreeRemember() will do nothing.
  -> 2. The memBlockA allocation succeeded but the memBlockB allocation failed.
  ->    FreeRemember() will free the memory block pointed to by memBlockA.
  -> 3. Both memory allocations were successful.
  ->    If this is the case, the program has already freed the link nodes with
  ->    FreeRemember() and the memory blocks with FreeMem().  When
  ->    FreeRemember() freed the link nodes, it reset RememberKey to NIL.
  ->    This (second) call to FreeRemember() will do nothing.
  FreeRemember({rememberKey}, TRUE)
ENDPROC
