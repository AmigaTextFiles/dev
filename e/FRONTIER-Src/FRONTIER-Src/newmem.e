/* 
 *  NewMem - Erweitere Speicherallokierfunktionen für den Amiga
 * -======-
 * 
 * - Am Anfang (am besten als ERSTE Zeile) muß initNewMem(newmemlist) erfolgen!!
 * - Speicher wird wie gewohnt mit AllocMem, AllocVec angefordert und kann wie gewohnt mit FreeMem
 *   und FreeVec wieder freigegeben werden,daher also nur gerine Anpassungen in Syntaxform im Source er-
 *   forderlich (man muß nur den Namen der Routinen ändern, z.B. AllocMem -> newAllocMem, FreeMem->
 *   newFreeMem, AllocVec -> newAllocVec, FreeVec -> newFreeVec... und als Parameter >newmemlist< über-
 *   geben!). Außerdem muß im Source folgende Zeile eingefügt werden (vor CleanUP()), damit wird JEDER
 *   Speicher der nicht freigegeben wurde wieder dem System zugefügt und freigegeben:
 *   freeNewMem(newmemlist)
 * - Die Speicheranforderung verzögert sich nur geringfügig
 * - neue Routinen in diesem Modul:
 * 
 *      initNewMem(newmemlist,task=NIL)         -> Initialisiert die Memory-Liste (task=Optional!)
 *      newValid(addr,newmemlist)               -> Prüft, ob die Adresse in unserem Speicherbereich liegt
 *      newAddMem(addr,bytesize,newmemlist)     -> Fügt Exec-Speicher der newmemliste hinzu
 *      newAddVec(addr,newmemlist)              -> Fügt Exec-Speicher der newmemliste hinzu
 *      newCreatePool(flags,puddle,tresh,newmemlist)    -> Legt eine Poolstruktur für newAllocPool() an
 *      newDeletePool(pool,newmemlist)          -> löscht die Pool-Struktur von newCreatePool()
 *      newAllocMem(bytesize,attr,newmemlist)   -> Allokiert Speicher (wie AllocMem)
 *      newAllocVec(bytesize,attr,newmemlist)   -> Allokiert Speicher (wie AllocVec)
 *      newAllocPool(pool,bytesize,newmemlist)  -> Pool-Allokieren
 *      newFreeMem(block,bytesize,newmemlist)   -> Gibt Speicher frei (wie FreeMem)
 *      newFreePool(block,newmemlist)           -> Gibt den Pool frei (ACHTUNG! Pool-PTR wird NICHT benötigt!)
 *      newFreeVec(block,newmemlist)            -> Gibt Speicher frei (wie FreeVec)
 *      newFreeBlock(block,newmemlist)          -> Gibt JEDEN Typ von Speicher frei!
 *      newFreePart(block,bytesize,newmemlist)  -> Gibt einen Teil des Speichers frei
 *      freeNewMem(newmemlist)                  -> Gibt die Memory-Liste wieder frei
 * 
 *      newOpenLibrary(name,version,newmemlist) -> Öffnet eine Library
 *      newCloseLibrary(libptr,newmemlist)      -> Schließt eine Library
 *      
 *      
 *
 *      © 1996 THE DARK FRONTIER Softwareentwicklungen (Grundler "TurricaN" Mathias)
 */

OPT MODULE
OPT PREPROCESS

MODULE  'amigalib/lists'
MODULE  'exec/execbase'
MODULE  'exec/lists'
MODULE  'exec/memory'
MODULE  'exec/nodes'
MODULE  '*newmemory'

->  #define DEBUG

EXPORT PROC initNewMem(task=NIL)
 DEF newmemlist:PTR TO newlh
  NEW newmemlist
   newList(newmemlist)
    IF (task<>NIL)
     newmemlist.task:=task
    ELSE
     newmemlist.task:=FindTask(NIL)
    ENDIF
ENDPROC newmemlist

EXPORT PROC newValid(addr,newmemlist:PTR TO newlh)
 DEF    newmem=NIL:PTR TO newmem,
        nextmem
  Forbid()
  newmem:=newmemlist.head
   WHILE nextmem:=newmem.ln.succ
    IF (addr>newmem.addr) AND (addr<(newmem.addr+newmem.bytes))
     Permit()
      RETURN TRUE
    ENDIF
     newmem:=nextmem
   ENDWHILE
    Permit()
ENDPROC FALSE

EXPORT PROC newAddMem(addr,bytesize,newmemlist:PTR TO newlh)
 DEF    newmem:PTR TO newmem
  Forbid()
   NEW newmem
    IF newmem=NIL
     Permit()
      RETURN NIL
    ENDIF
     newmem.type:=MEMT_MEM
      newmem.status:=MEMS_ALLOCATED
       newmem.addr:=addr
        newmem.bytes:=bytesize
         IF newmem.addr=NIL
          END newmem
           Permit()
            RETURN NIL
         ENDIF
          newmem.ln.pri:=bytesize
           Enqueue(newmemlist,newmem)
            Permit()
ENDPROC TRUE

EXPORT PROC newOpenLibrary(name,ver,newmemlist:PTR TO newlh)
 DEF    newmem:PTR TO newmem
  Forbid()
   NEW newmem
    IF newmem=NIL
     Permit()
      RETURN NIL
    ELSE
     newmem.type:=MEMT_LIBRARY
      newmem.status:=MEMS_REFRESHED
       newmem.addr:=OpenLibrary(name,ver)
        newmem.bytes:=ver
         IF newmem.addr=NIL
          END newmem
           Permit()
            RETURN NIL
         ENDIF
    ENDIF
     newmem.ln.pri:=ver
      Enqueue(newmemlist,newmem)
       Permit()
ENDPROC newmem.addr

EXPORT PROC newCloseLibrary(libbase,newmemlist:PTR TO newlh)
 DEF    newmem:PTR TO newmem
  Forbid()
   newmem:=jumpmem(libbase,newmemlist)
    IF newmem.type = MEMT_LIBRARY
     IF newmem.status = MEMS_REFRESHED
      CloseLibrary(newmem.addr)
#ifdef DEBUG
     ELSE
 WriteF('Wrong Status for Library at $\h\n',newmem.addr)
#endif
     ENDIF
#ifdef DEBUG
    ELSE
 WriteF('Corrupt newmemlist, $\h isn`t a library-PTR\n',newmem.addr)
#endif
    ENDIF
     Remove(newmem)             -> Node entfernen
      END       newmem          -> Speicher freigeben
       Permit()
ENDPROC TRUE

EXPORT PROC newAddVec(addr,newmemlist:PTR TO newlh)
 DEF    newmem:PTR TO newmem,
        bytesize=0
  Forbid()
   NEW newmem
    IF newmem=NIL
     Permit()
      RETURN NIL
    ENDIF
     newmem.type:=MEMT_VEC
      newmem.status:=MEMS_ALLOCATED
       newmem.addr:=addr

MOVE.L addr,A0
MOVE.L -(A0),bytesize
MOVE.L A0,addr

        newmem.bytes:=bytesize-4
         IF newmem.addr=NIL
          END newmem
           Permit()
            RETURN NIL
         ENDIF
          newmem.ln.pri:=newmem.bytes
           Enqueue(newmemlist,newmem)
            Permit()
ENDPROC TRUE

EXPORT PROC freeNewMem(newmemlist:PTR TO newlh)
 DEF    newmem:PTR TO newmem,
        nextmem
 Forbid()
  newmem:=newmemlist.head
   WHILE nextmem:=newmem.ln.succ
    IF (newmem.status = MEMS_ALLOCATED) OR (newmem.status = MEMS_REFRESHED)
     IF (newmem.type = MEMT_MEM) OR (newmem.type = MEMT_PART)
      FreeMem(newmem.addr,newmem.bytes)
#ifdef DEBUG
 WriteF('\d-Bytes unfreed Mem at $\h\n',newmem.bytes,newmem.addr)
#endif
     ELSEIF newmem.type = MEMT_VEC
      FreeVec(newmem.addr)
#ifdef DEBUG
 WriteF('\d-Bytes unfreed Vec at $\h\n',newmem.bytes,newmem.addr)
#endif
     ELSEIF newmem.type = MEMT_POOL
      newFreePool(newmem.addr,newmemlist)
       newDeletePool(newmem.pool,newmemlist)
#ifdef DEBUG
 WriteF('\d-Bytes unfreed Pool at $\h\n',newmem.bytes,newmem.addr)
#endif
     ELSEIF newmem.type = MEMT_LIBRARY
      CloseLibrary(newmem.addr)
#ifdef DEBUG
 WriteF('Unclosed Library at $\h (ver:\d)\n',newmem.addr,newmem.bytes)
#endif
     ENDIF
    ENDIF
     END newmem
      newmem:=nextmem
   ENDWHILE
    END newmemlist
 Permit()
ENDPROC TRUE

EXPORT PROC newAllocMem(bytesize,attr,newmemlist)
 DEF    newmem=NIL:PTR TO newmem
  Forbid()
   NEW newmem
    IF newmem=NIL
     Permit()
      RETURN NIL
    ENDIF
     newmem.type:=MEMT_MEM
      newmem.status:=MEMS_ALLOCATED
       newmem.addr:=AllocMem(bytesize,attr OR MEMF_REVERSE)
        newmem.bytes:=bytesize
         IF newmem.addr=NIL
          END newmem
           Permit()
            RETURN NIL
         ENDIF
          newmem.ln.pri:=bytesize
           Enqueue(newmemlist,newmem)
            Permit()
ENDPROC newmem.addr

EXPORT PROC newAllocVec(bytesize,attr,newmemlist)       IS newAllocMem(bytesize,attr,newmemlist)
/*
 DEF    newmem=NIL:PTR TO newmem
  Forbid()
   NEW newmem
    IF newmem=NIL
     Permit()
      RETURN NIL
    ENDIF
     newmem.type:=MEMT_VEC
      newmem.status:=MEMS_ALLOCATED
       newmem.addr:=AllocVec(bytesize,attr OR MEMF_REVERSE)
        newmem.bytes:=bytesize
         IF newmem.addr=NIL
          END newmem
           RETURN NIL
         ENDIF
          newmem.ln.pri:=bytesize
           Enqueue(newmemlist,newmem)
            Permit()
ENDPROC newmem.addr
*/

EXPORT PROC newAllocPool(pool:PTR TO pool,bytesize,newmemlist:PTR TO newlh)
 DEF    newmem:PTR TO newmem
  Forbid()
   NEW newmem
    IF newmem=NIL
     END newmem
      Permit()
       RETURN FALSE
    ENDIF
     newmem.addr:=libAllocPooled(pool,bytesize)
      IF (newmem.addr=NIL)
       END newmem
        Permit()
         RETURN FALSE
      ENDIF
       newmem.ln.pri:=bytesize
        newmem.type:=MEMT_POOL
         newmem.status:=MEMS_ALLOCATED
          newmem.pool:=pool
           Enqueue(newmemlist,newmem)
            Permit()
ENDPROC newmem.addr

EXPORT PROC newFreePool(block,newmemlist)
 DEF    newmem:PTR TO newmem
 Forbid()
  newmem:=jumpmem(block,newmemlist)
   IF newmem.type=MEMT_POOL
    IF newmem.status = MEMS_FREE
#ifdef DEBUG
 WriteF('Pool at $\h was always free!\n',newmem.addr)
#endif
     Permit()
      RETURN NIL
    ENDIF
     newmem.status:=MEMS_REFRESHED
      libFreePooled(newmem.pool,newmem.addr,newmem.bytes)
       newmem.status:=MEMS_FREE
   ELSE
#ifdef DEBUG
 WriteF('newFreePool() should free a Mem or a Vec!!(\d) at $\h\n',newmem.type,newmem.addr)
#endif
    RETURN FALSE
   ENDIF
    Permit()
ENDPROC TRUE

EXPORT PROC newFreeMem(block,bytesize,newmemlist)
 DEF    newmem:PTR TO newmem
 Forbid()
  newmem:=jumpmem(block,newmemlist)
   IF newmem.type = MEMT_MEM
    IF newmem.status = MEMS_FREE
#ifdef DEBUG
 WriteF('Mem at $\h was always free!\n',newmem.addr)
#endif
     Permit()
      RETURN NIL
    ENDIF
     newmem.status:=MEMS_REFRESHED
#ifdef DEBUG
 IF newmem.bytes <> bytesize
  WriteF('Uncorrect Size of Mem to Free at $\h! (a:\d - f:\d)\n',newmem.addr,newmem.bytes,bytesize)
 ENDIF
#endif
      FreeMem(newmem.addr,newmem.bytes)
       newmem.status:=MEMS_FREE
   ELSE
#ifdef DEBUG
 WriteF('newFreeMem() should free a Vec or a Pool!!(\d) at $\h\n',newmem.type,newmem.addr)
#endif
   ENDIF
    Permit()
->       Remove(newmem)
ENDPROC TRUE

EXPORT PROC newFreeVec(block,newmemlist)
DEF    newmem:PTR TO newmem
 Forbid()
  newmem:=jumpmem(block,newmemlist)
   IF (newmem.type = MEMT_VEC) OR (newmem.type = MEMT_MEM)
    IF newmem.status = MEMS_FREE
#ifdef DEBUG
 WriteF('Vec at $\h was always free!\n',newmem.addr)
#endif
     Permit()
      RETURN NIL
    ENDIF
     newmem.status:=MEMS_REFRESHED
      IF (newmem.type = MEMT_MEM)
       FreeMem(newmem.addr,newmem.bytes)
      ELSEIF (newmem.type = MEMT_VEC)
       FreeVec(newmem.addr)
      ENDIF
       newmem.status:=MEMS_FREE
   ELSE
#ifdef DEBUG
 WriteF('newFreeVec() should free a Pool!!(\d) at $\h\n',newmem.type,newmem.addr)
#endif
   ENDIF
    Permit()
->       Remove(newmem)
ENDPROC TRUE

EXPORT PROC newFreeBlock(block,newmemlist)
 DEF    newmem:PTR TO newmem
  Forbid()
   newmem:=jumpmem(block,newmemlist)
   IF newmem.status = MEMS_FREE
#ifdef DEBUG
 WriteF('Block at $\h was always free!\n',newmem.addr)
#endif
    Permit()
     RETURN NIL
   ENDIF
    newmem.status:=MEMS_REFRESHED
     IF (newmem.type = MEMT_MEM) OR (newmem.type = MEMT_PART)
      FreeMem(newmem.addr,newmem.bytes)
     ELSEIF newmem.type = MEMT_VEC
      FreeVec(newmem.addr)
     ELSEIF newmem.type = MEMT_POOL
      newFreePool(block,newmemlist)
     ENDIF
      newmem.status:=MEMS_FREE
       Permit()
->       Remove(newmem)
ENDPROC TRUE

EXPORT PROC newFreePart(block,bytesize,newmemlist)
 DEF    newmem:PTR TO newmem,
        addr=0
 Forbid()
  newmem:=jumpmem(block,newmemlist)
   IF newmem.status = MEMS_FREE
#ifdef DEBUG
 WriteF('Part at $\h was always free!\n',newmem.addr)
#endif
    Permit()
     RETURN NIL
   ENDIF
    newmem.status:=MEMS_REFRESHED
     IF (newmem.type = MEMT_MEM) OR (newmem.type = MEMT_PART)
      Forbid()
       addr:=newmem.addr
        FreeMem(newmem.addr,bytesize)
         newmem.addr:=addr+bytesize             /* Neue Adresse errechnen!      */
          Permit()
     ELSEIF newmem.type = MEMT_VEC
      Forbid()                                  /* Multitasking AUS!            */
       addr:=newmem.addr
        FreeVec(newmem.addr)                    /* Gesamten speicher freigeben! */
         newmem.addr:=AllocAbs(newmem.bytes-bytesize,addr+bytesize)     /* Speicher wieder an der gleichen Stelle anfordern!)   */
          Permit()                              /* Multitasking an!             */
#ifdef DEBUG
     ELSEIF newmem.type = MEMT_POOL
WriteF('newFreePart() should free a Pool!!(\d) at $\h\n',newmem.type,newmem.addr)
#endif
     ENDIF
      newmem.type:=MEMT_PART
       newmem.status:=MEMS_ALLOCATED
        newmem.bytes:=newmem.bytes-bytesize
->       Remove(newmem)
          Permit()
ENDPROC newmem.addr

PROC jumpmem(addr,newmemlist:PTR TO newlh)
 DEF    newmem:PTR TO newmem
  Forbid()
   newmem:=newmemlist.head
    IF (newmem = NIL) OR (newmem.addr = addr) 
     Permit()
      RETURN newmem
    ENDIF
     REPEAT
      newmem:=newmem.ln.succ
     UNTIL (newmem = NIL) OR (newmem.addr = addr)
      Permit()
ENDPROC newmem

EXPORT PROC newCreatePool(flags,puddlesize,treshsize,newmemlist)
  DEF pool=NIL:REG PTR TO pool
 Forbid()
  IF treshsize <= puddlesize
    IF (pool:=newAllocMem(SIZEOF pool,MEMF_ANY,newmemlist))<>NIL
      pool.flags:=flags
      pool.puddlesize:=puddlesize
      pool.treshsize:=treshsize
      newList(pool::lh)
      pool::lh.type:=NT_MEMORY
    ENDIF
  ENDIF
 Permit()
ENDPROC pool

EXPORT PROC newDeletePool(pool: PTR TO pool,newmemlist)
  DEF mh:PTR TO mh
 Forbid()
  IF KickVersion(39)
    DeletePool(pool)
  ELSEIF pool<>NIL
    WHILE Not(IsListEmpty(pool::lh))
      mh:=pool::lh.head
      Remove(mh)
      freeMemHeader(mh,newmemlist)
    ENDWHILE
    FreeMem(pool,SIZEOF pool)
  ENDIF
 Permit()
ENDPROC

-> Ab hier die Memory-Pool-Funktionen!

PROC libAllocPooled(pool:PTR TO pool,size)
  DEF mh:PTR TO mh,newmem=NIL
  IF KickVersion(39) THEN RETURN AllocPooled(pool,size)
  IF (IsListEmpty(pool::lh)) OR (size>=pool.treshsize)
    IF (allocPuddle(pool,size))=FALSE THEN RETURN NIL
  ENDIF
  mh:=pool::lh.head
  WHILE (mh::ln.succ)
    IF (newmem:=Allocate(mh,size))<>NIL THEN RETURN newmem
    mh:=mh::ln.succ
  ENDWHILE
  IF (allocPuddle(pool,size))=FALSE THEN RETURN NIL
  mh:=pool::lh.head
  RETURN Allocate(mh,size)
ENDPROC

PROC allocPuddle(pool:PTR TO pool,size)
  DEF mh=NIL:PTR TO mh,poolsize

  poolsize:=Max(pool.puddlesize,(size+8))
  IF (mh:=allocMemHeader(poolsize,pool.flags))=FALSE THEN RETURN FALSE
  AddHead(pool::lh,mh)
ENDPROC TRUE

PROC libFreePooled(pool:PTR TO pool,mem,size)
  DEF mh:PTR TO mh

  IF mem=NIL THEN RETURN
  IF KickVersion(39) THEN RETURN FreePooled(pool,mem,size)
  mh:=pool::lh.head
  WHILE (mh::ln.succ)
    IF (mem>=mh.lower) AND (mem<mh.upper)
      RETURN Deallocate(mh,mem,size)
    ENDIF
    mh:=mh::ln.succ
  ENDWHILE
ENDPROC

PROC freeMemHeader(mh:PTR TO mh,newmemlist)
  IF mh<>NIL THEN  newFreeMem(mh,mh.upper-mh.lower+SIZEOF mh,newmemlist)
ENDPROC

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
