/* with this you can allocate memory-blocks with an special alignment.
** Useful for allocating eq. anchorpath-structures.
*/

OPT MODULE

EXPORT CONST ALIGNED_Int=2,
             ALIGNED_Long=4,
             ALIGNED_Double=8


/* allocates an aligned memory-block
**   'align' - alignment of the block. Must be an power of two.
**
** may raise "MEM"-exception.
*/
EXPORT PROC allocAlignedMemory(size,align=ALIGNED_Long)
DEF mem,
    dummy:PTR TO LONG

  /* allocate memory.
  ** 4Bytes to store real memory address and ('align'-1) bytes for making the
  ** structure 'align'-aligned.
  **
  */

  DEC align
  mem:=NewR(size+align+4)

  /* aligned it
  */
  dummy:=(mem+align) AND Not(align)

  /* store real memory address at first four bytes
  */
  dummy[]++:=mem

ENDPROC dummy


/* frees an aligned memory-block created with allocAlignedMemory()!
** returns NIL.
*/
EXPORT PROC freeAlignedMemory(mem:PTR TO LONG)

  /* The real address of allocated memoryblock is stored at first
  ** 4 bytes before the structure.
  */
  IF mem THEN Dispose(mem[-1])

ENDPROC NIL

