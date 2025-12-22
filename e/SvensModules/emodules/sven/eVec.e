/* These module contains functions similar to exec's xxxVec()-functions
** but these one use E's memory allocation functions. Means the memory
** is freed automatical when program terminates.
*/

OPT MODULE



/* allocates memory of size 'size'.
** May raise "MEM"-exceptions.
**
** You may not free the memory yourself. Use eFreeVec()!
*/
EXPORT PROC eAllocVec(size)
DEF mem:PTR TO LONG

  /* Allocating an memory-block of size zero is somewhat strange, isn't it?
  */
  IF size<=0 THEN Raise("MEM")

  /* allocate memory + one long to hold the length
  */
  mem:=FastNew(size+4)
  /* store the length of memoryblock
  */
  mem[]++:=size

ENDPROC mem


/* Frees an memory-block allocated by eAllocVec()
** It's safe to pass NIL.
** Returns NIL (eq.: mem:=eFreeVec(mem)).
*/
EXPORT PROC eFreeVec(mem:PTR TO LONG)

  IF mem
    /* calculate the real start of memory-block
    */
    mem:=mem-4
    /* Dispose the memory
    */
    FastDispose(mem,mem[]+4)
  ENDIF

ENDPROC NIL


/* returns the size of a memory-block allocated by eAllocVec()
** It's safe to pass NIL.
*/
EXPORT PROC eVecSize(mem:PTR TO LONG) IS
  IF mem THEN mem[-1] ELSE 0

