/* Simple (but fast and effecient) memorypool-handling.
** Only allocating of memory possible. You can only deallocate the whole
** memory pool.
**
** Throws exception "MEMP". The exceptioninfo contains the reason of failure
** (MEM_xxx).
**
** Also, on low memory situations, the user is asked about what to do.
** So he may close other applications.
*/

OPT MODULE

MODULE 'intuition/intuition','exec/memory'


EXPORT ENUM MEM_Ok,MEM_NoMem

EXPORT OBJECT pool
  liststart:PTR TO puddleheader
  flags
  regionsize
  newsize
ENDOBJECT

/* every puddle consists of such an header
*/
OBJECT puddleheader
  next:PTR TO puddleheader
  size:LONG
  freesize:LONG     -> free memory in this puddle
  freestart:LONG    -> start of free memory
ENDOBJECT

/* Allocates and initialiazes an new memory pool.
** 'flags' is the memory type.
** 'regionsize' is the size of one puddle.
** 'newsize' is the largest allocation that goes into the normal puddles.
**           larger allocations are taken directly from new memory block.
**           Must be less or equal than 'regionsize'.
**
** Returns the pool.
*/
EXPORT PROC __CreatePool(flags=MEMF_ANY,regionsize=40000,newsize=30000)
DEF poo=NIL:PTR TO pool

  flags:=flags OR MEMF_CLEAR
  IF poo:=AllocMem(SIZEOF pool,flags)
    poo.flags:=flags
    poo.regionsize:=regionsize
    poo.newsize:=newsize
  ELSE
    Throw("MEMP",MEM_NoMem)
  ENDIF

ENDPROC poo


/* Deletes a pool allocated with __CreatePool(). Frees all the memory.
*/
EXPORT PROC __DeletePool(poo:PTR TO pool)
DEF pd1:PTR TO puddleheader,
    pd2:PTR TO puddleheader

  IF poo
    pd1:=poo.liststart
    WHILE pd1
      pd2:=pd1.next
      FreeMem(pd1,pd1.size)
      pd1:=pd2
    ENDWHILE
    FreeMem(poo,SIZEOF pool)
  ENDIF
ENDPROC


PROC __AllocRegion(poo:PTR TO pool,size)
DEF mem=NIL:PTR TO puddleheader,
    hilf:PTR TO puddleheader,
    response

  size:=Max(poo.regionsize,size)+SIZEOF puddleheader

  /* Round it MEM_BLOCKSIZE.
  ** The system does it and it would be a pity to throw away all
  ** those bytes unused.
  */
  size:=size+(MEM_BLOCKSIZE-And(size,MEM_BLOCKMASK))

  REPEAT
    IF mem:=AllocMem(size,poo.flags)
      IF hilf:=poo.liststart
        WHILE hilf.next DO hilf:=hilf.next
        hilf.next:=mem
      ELSE
        poo.liststart:=mem
      ENDIF
      mem.size:=size
      mem.freesize :=size-SIZEOF puddleheader
      mem.freestart:=mem+SIZEOF puddleheader
      response:=0
    ELSE
      response:=EasyRequestArgs(NIL,
                                [20,0,'Error','Not enough memory - Need %ld Bytes free memory','Try it again|Abort'],
                                 NIL,[size])
    ENDIF
  UNTIL response=0
  IF mem=NIL THEN Throw("MEMP",MEM_NoMem)

ENDPROC mem


PROC initmem(mem:PTR TO puddleheader,size)
DEF mem2:PTR TO CHAR

  mem2:=mem.freestart
  mem.freesize :=mem.freesize-size
  mem.freestart:=mem2+size

ENDPROC mem2


EXPORT PROC __AllocPooled(poo:PTR TO pool,size)
DEF mem:REG PTR TO puddleheader

  /* list empty , or size larger than newsize?
  ** then allocate an new puddle and return the memory
  */
  IF (poo.liststart=NIL) OR  (size>poo.newsize)
    RETURN initmem(__AllocRegion(poo,size),size)
  ENDIF

  /* Search the list if we find a puddle with enough free memory
  */
  mem:=poo.liststart
  WHILE mem
    IF mem.freesize>=size
      RETURN initmem(mem,size)
    ENDIF
    mem:=mem.next
  ENDWHILE

  /* we could not find a matching puddle.
  ** Simply allocate a new one and initialize it.
  */
ENDPROC initmem(__AllocRegion(poo,size),size)

