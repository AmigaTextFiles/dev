OPT MODULE
OPT PREPROCESS,REG=5

->#define DEBUG
->#define TEST   -> for tests under OS v39+

MODULE 'exec/memory','exec/lists','exec/nodes','exec/execbase',
       'amigalib/lists'
#ifdef DEBUG
MODULE 'tools/debug'
#endif

/*
  Pools.c 1.0 (11.97.94) © D. Göhler
  This source was *NEVER* tested and just typed in from the
  Amiga magazine, 10/94. Handle it with care.
  Adapted to match the definitions of LibAllocPooled() and
  LibFreePooled() by Jochen Wiedmann.

  $VER: mempools v1.2 (19.07.96) AmigaE version by Piotr Gapiïski
  v1.1 (20.04.96) - first conversion
                  - added libAllocVecPooled() and libFreeVecPooled()
  v1.2 (19.07.96) - fixed problem with libAllocPooled()
*/

/**
***  The structure used for a pool.
**/
EXPORT OBJECT pool
  mhanchor:lh           /*  Puddle list                         */
  flags:LONG            /*  AllocMem argument                   */
  puddlesize:LONG       /*  Usual puddle size                   */
  treshsize:LONG        /*  Size that requires a special puddle */
ENDOBJECT

/**
***  AllocMemHeader() allocates a new block of RAM from the global
***  memory list.
**/
PROC allocMemHeader(size,flags)
  DEF mh:REG PTR TO mh,
      mc:REG PTR TO mc

  mh:=AllocMem(size + SIZEOF mh,flags)
  IF mh<>NIL
    mc:=mh+SIZEOF mh
    mc.next:=NIL
    mc.bytes:=size

    mh::ln.type:=NT_MEMORY
    mh::ln.name:=NIL
    mh::ln.succ:=NIL
    mh::ln.pred:=NIL
    mh::ln.pri:=0
    mh.first:=mc
    mh.lower:=mc
    mh.upper:=mc+size
    mh.free:=size
  ENDIF
ENDPROC mh

/**
***  FreeMemHeader() is the counterpart of AllocMemHeader().
**/
PROC freeMemHeader(mh:PTR TO mh)
  IF mh<>NIL THEN  FreeMem(mh,mh.upper-mh.lower+SIZEOF mh)
ENDPROC

/**
***  LibCreatePool() is the CreatePool() equivalent. In fact, it calls
***  CreatePool(), if the OS is V39 or higher.
**/
EXPORT PROC libCreatePool(flags,puddlesize,treshsize)
  DEF pool=NIL:REG PTR TO pool

#ifndef TEST
  IF KickVersion(39) THEN RETURN CreatePool(flags,puddlesize,treshsize)
#endif
  IF treshsize <= puddlesize
    IF (pool:=AllocMem(SIZEOF pool,MEMF_ANY))<>NIL
      pool.flags:=flags
      pool.puddlesize:=puddlesize
      pool.treshsize:=treshsize
      newList(pool::lh)
      pool::lh.type:=NT_MEMORY
      #ifdef DEBUG
        kputfmt('MEMPOOL created at $\h, flags=$\h, puddle=$\h, tresh=$h\n',
                [pool,pool.flags,pool.puddlesize,pool.treshsize])
      #endif
    ENDIF
  ENDIF
ENDPROC pool

/**
***  LibDeletePool() is the counterpart of LibCreatePool().
**/
EXPORT PROC libDeletePool(pool: PTR TO pool)
  DEF mh:PTR TO mh

#ifndef TEST
  IF KickVersion(39)
    DeletePool(pool)
  ELSEIF pool<>NIL
#endif
#ifdef TEST
  IF pool<>NIL
#endif
    WHILE Not(IsListEmpty(pool::lh))
      mh:=pool::lh.head
      Remove(mh)
      freeMemHeader(mh)
    ENDWHILE
    #ifdef DEBUG
      kputfmt('MEMPOOL disposed at $\h\n',[pool])
    #endif
    FreeMem(pool,SIZEOF pool)
  ENDIF
ENDPROC

/**
***  LibAllocPooled() is the AllocPooled() equivalent. In fact, it
***  calls AllocPooled(), if the OS is V39 or higher.
**/
PROC allocPuddle(pool:PTR TO pool,size)
  DEF mh=NIL:PTR TO mh,poolsize

  poolsize:=Max(pool.puddlesize,(size+8))
  IF (mh:=allocMemHeader(poolsize,pool.flags))=FALSE THEN RETURN FALSE
  AddHead(pool::lh,mh)
ENDPROC TRUE

EXPORT PROC libAllocPooled(pool:PTR TO pool,size)
  DEF mh:PTR TO mh,newmem=NIL

#ifndef TEST
  IF KickVersion(39) THEN RETURN AllocPooled(pool,size)
#endif
  IF (IsListEmpty(pool::lh)) OR (size>=pool.treshsize)
    IF (allocPuddle(pool,size))=FALSE THEN RETURN NIL
  ENDIF
  #ifdef DEBUG
    kputfmt('MEMPOOL alloc pool=$\h, flags=$\h, size=$\h\n',[pool,pool.flags,size])
  #endif
  mh:=pool::lh.head
  WHILE (mh::ln.succ)
    IF (newmem:=Allocate(mh,size))<>NIL THEN RETURN newmem
    mh:=mh::ln.succ
  ENDWHILE
  IF (allocPuddle(pool,size))=FALSE THEN RETURN NIL
  mh:=pool::lh.head
  RETURN Allocate(mh,size)
ENDPROC

/**
***  LibFreePooled() is the counterpart to LibAllocPooled().
**/
EXPORT PROC libFreePooled(pool:PTR TO pool,mem,size)
  DEF mh:PTR TO mh

  IF mem=NIL THEN RETURN
#ifndef TEST
  IF KickVersion(39) THEN RETURN FreePooled(pool,mem,size)
#endif
  #ifdef DEBUG
    kputfmt('MEMPOOL free pool=$\h, flags=$\h, size=$\h\n',[pool,pool.flags,size])
  #endif
  mh:=pool::lh.head
  WHILE (mh::ln.succ)
    IF (mem>=mh.lower) AND (mem<mh.upper)
      RETURN Deallocate(mh,mem,size)
    ENDIF
    mh:=mh::ln.succ
  ENDWHILE
ENDPROC

EXPORT PROC libAllocVecPooled(pool:PTR TO pool,memSize)
  DEF realSize,mem

  realSize:=memSize+4
  IF (mem:=libAllocPooled(pool,realSize))=NIL THEN RETURN
  MOVE.L mem,A0
  MOVE.L realSize,D0
  MOVE.L D0,(A0)+
  MOVE.L A0,D0
ENDPROC D0

EXPORT PROC libFreeVecPooled(pool:PTR TO pool,memory:PTR TO LONG)
  DEF realSize

  MOVE.L memory,A0
  MOVE.L -(A0),realSize
  MOVE.L A0,memory
  libFreePooled(pool,memory,realSize)
ENDPROC
