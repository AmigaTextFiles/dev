OPT MODULE
OPT PREPROCESS

MODULE 'exec/memory','exec/lists','exec/nodes','exec/execbase',
       'amigalib/lists'

->***  Version: $VER: Pools.c 1.0 (11.97.94) © D. Göhler
->***
->***  This source was *NEVER* tested and just typed in from the
->***  Amiga magazine, 10/94. Handle it with care.
->***  Adapted to match the definitions of LibAllocPooled() and
->***  LibFreePooled() by Jochen Wiedmann.
->***  AmigaE version by Piotr Gapinski


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
  DEF mh=NIL:PTR TO mh,
      mc=NIL:PTR TO mc

  mh:=AllocMem(size + SIZEOF mh,flags)
  IF mh<>NIL
    mc:=mh+1
    mc.next:=NIL
    mc.bytes:=size

    mh.ln.type:=NT_MEMORY
    mh.ln.name:=NIL
    mh.ln.succ:=NIL
    mh.ln.pred:=NIL
    mh.ln.pri:=0
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
  DEF mypool:PTR TO pool

  IF KickVersion(39) THEN RETURN CreatePool(flags,puddlesize,treshsize)
  mypool:=NIL
  IF treshsize <= puddlesize
    IF (mypool:=AllocMem(SIZEOF pool,MEMF_ANY))<>NIL
      mypool.flags:=flags
      mypool.puddlesize:=puddlesize
      mypool.treshsize:=treshsize
      newList(mypool.mhanchor)
      mypool.mhanchor.type:=NT_MEMORY
    ENDIF
  ENDIF
ENDPROC mypool


/**
***  LibDeletePool() is the counterpart of LibCreatePool().
**/
EXPORT PROC libDeletePool(pool: PTR TO pool)
  DEF mh:PTR TO mh

  IF KickVersion(39)
    DeletePool(pool)
  ELSEIF pool<>NIL
    WHILE Not(IsListEmpty(pool.mhanchor))
      mh:=pool.mhanchor.head
      Remove(mh)
      freeMemHeader(mh)
    ENDWHILE
    FreeMem(pool,SIZEOF pool)
  ENDIF
ENDPROC


/**
***  LibAllocPooled() is the AllocPooled() equivalent. In fact, it
***  calls AllocPooled(), if the OS is V39 or higher.
**/
PROC allocPuddle(pool:PTR TO pool,size)
  DEF mh=NIL:PTR TO mh,poolsize

  poolsize:=IF pool.puddlesize>(size+8) THEN pool.puddlesize ELSE (size+8)
  IF (mh:=allocMemHeader(poolsize,pool.flags))=NIL THEN RETURN FALSE
  AddHead(pool.mhanchor,mh)
  RETURN TRUE
ENDPROC


EXPORT PROC libAllocPooled(pool:PTR TO pool,size)
  DEF mh:PTR TO mh,newmem=NIL

  IF KickVersion(39) THEN RETURN AllocPooled(pool,size)
  IF (IsListEmpty(pool.mhanchor)) OR (size>=pool.treshsize)
    IF (allocPuddle(pool,size))=NIL THEN RETURN NIL
  ENDIF
  mh:=pool.mhanchor.head
  WHILE (mh.ln.succ)
    IF (newmem:=Allocate(mh,size))<>NIL THEN RETURN newmem
    mh:=mh.ln.succ
  ENDWHILE
  IF (allocPuddle(pool,size))=NIL THEN RETURN NIL
  mh:=pool.mhanchor.head
  RETURN Allocate(mh,size)
ENDPROC


/**
***  LibFreePooled() is the counterpart to LibAllocPooled().
**/
EXPORT PROC libFreePooled(pool:PTR TO pool,mem,size)
  DEF mh:PTR TO mh

  IF mem=NIL THEN RETURN
  mh:=pool.mhanchor.head
  WHILE (mh.ln.succ)
    IF (mem>=mh.lower) AND (mem<mh.upper)
      Deallocate(mh,mem,size)
      RETURN
    ENDIF
    mh:=mh.ln.succ
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


EXPORT PROC libFreeVecPooled(pool:PTR TO pool,memory)
  DEF memSize

  MOVE.L memory,A0
  MOVE.L -(A0),memSize
  libFreePooled(pool,memory,memSize)
ENDPROC
