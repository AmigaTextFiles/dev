OPT MODULE

MODULE  'exec/nodes'
MODULE  'exec/lists'

EXPORT OBJECT newlh     -> Newmemliste (Head)
 head   :ln             -> Erste Node der Liste
 tail   :ln             -> Letzte Node der Liste
 tailpred:ln            -> Vorletzte Node der Liste
 type   :CHAR           -> ListenTyp
 pad    :CHAR           -> UNBENUTZT
 task   :LONG           -> Adresse des Main-Tasks
ENDOBJECT

EXPORT OBJECT newmem    -> Node der newmemliste
 ln     :ln             -> ListNode-Struktur von Exec
 addr   :LONG           -> Angangsadresse des Blocks
 bytes  :LONG           -> Größe des Blockes in Bytes
 status :INT            -> Status des Blocks (MEMS_#?)
 type   :INT            -> Typ des Speichers (MEM, VEC, POOL, POOLVEC...)
 pool   :LONG           -> PTR zu einem Pool
ENDOBJECT

EXPORT OBJECT pool      -> Node für einen Pool
  mhanchor:lh           -> Exec-ListHead
  flags :LONG           -> Argumente für AllocMem ect...
  puddlesize:LONG       -> Normale Puddle-Größe
  treshsize:LONG        -> Größe die einen speziellen Puddle erfordert
ENDOBJECT

EXPORT CONST    MEMS_FREE=1,            -> Speicher ist bereits freigegeben worden
                MEMS_ALLOCATED=2,       -> Speicher wurde gerade allokiert...
                MEMS_REFRESHED=4        -> Ein Listenrefresh wurde gerade durchgeführt
EXPORT ENUM     MEMT_MEM,               -> Per AllocMem allokiert
                MEMT_VEC,               -> Per AllocVec allokiert
                MEMT_POOL,              -> Memory-Pool
                MEMT_PART,              -> Speicher wurde teilweise freigegeben!
                MEMT_LIBRARY            -> Es handelt sich um eine Library!
