          IFND      LIBRARIES_TDDBASE_I
LIBRARIES_TDDBASE_I SET 1

          IFND      EXEC_TYPES_I
          INCLUDE   'exec/types.i'
          ENDC
          
          IFND      EXEC_SEMAPHORES_I
          INCLUDE   'exec/semaphores.i'
          ENDC

          IFND      EXEC_PORTS_I
          INCLUDE   'exec/ports.i'
          ENDC
          
          IFND      DOS_DOS_I
          INCLUDE   'dos/dos.i'
          ENDC

          IFND      UTILITY_TAGITEM_I
          INCLUDE   'utility/tagitem.i'
          ENDC

;
; This structure is the shared part of a database
;
          STRUCTURE DataBase,LN_SIZE

          ;
          ; Here can you find out who and how many programms that are 
          ; using this database at any time.
          ;
          UWORD UseCnt                  ; Number of opened databases
          STRUCT HandleList,MLH_SIZE    ; List with handlers
          STRUCT HandleSem,SS_SIZE      ; Semaphore to protect handlerlist

          ULONG DataID                  ; Identifies the contents of DBase
          ULONG FileType                ; Gives fileformat

          ULONG Flags                   ; Reserved for future usage

          ULONG Nodes                   ; Number of nodes that belongs to this dbase

          ; There exists private data below!


; This is the only FileType that is suported.
FILID_STATIC EQU    $44423130           ; 'DB10'

; Use this generic DataID if you do not wish to use datarecognizion.
DBID_NOID EQU       0

; These 2 DataID values are only for testing. Other DataID values can only
; be registerd via betasoft.
DBID_TEST1 EQU      1
DBID_TEST2 EQU      2

          ; This is the process-specific parts of each database.
          STRUCTURE DBHandle,0
          STRUCT    Node,MN_SIZE        ; Linkage in handlerlist.
          APTR      DBase               ; Points back to database.
          APTR      Process             ; The process this handle used by
          ULONG     Error               ; Last errorcode
          ;More private data follows!


;Error codes
ERR_NOERR    EQU    0         ; Everything went just fine.
ERR_NONNODE  EQU    1         ; You tried to access a non-existing node.
ERR_NOMEM    EQU    2         ; Ran out of memory.
ERR_DOSERR   EQU    3         ; FileIO error.
ERR_NOTDBASE EQU    4         ; Not a database-file.
ERR_NODEBUSY EQU    5         ; Cant get acess to node.


          ; This structure defines a node in memory/cache
          STRUCTURE DBNode,SS_SIZE
          UWORD dbn_Flags                   ; Flags, see below for bit-defs
          ULONG dbn_NodeNr                  ; This nodes number
          APTR  dbn_DataList;               ; List with all data
          APTR  dbn_LockProc;               ; The process that has a lock on node */

; NodeFlags
NF_Changed   EQU $0001                  ; You have changed contents of this node */
NF_New       EQU $0002                  ; Node has just been created
NF_Locked    EQU $0004                  ; Node has a "soft" lock on it

NB_Changed   EQU 0
NB_New       EQU 1
NB_Locked    EQU 2

; Flags for TDDB_GetNode()
MODEF_READ   EQU $0001                  ; Get read acess
MODEF_WRITE  EQU $0002                  ; Get read/write acess to nide
MODEF_NOWAIT EQU $0004                  ; Dont wait for it to become free

;Here comes some defines/macros to be used on field ID's

DATATYPES EQU $F0000000       ; These bits are reserved for datatype

INT       EQU $80000000       ; 32 bit value
STRING    EQU $40000000       ; NULL terminated string
BINARY    EQU $C0000000       ; Binary data, first ULONG is total size.

; These macros can be used to define correct FieldID values
IntTag    MACRO     ; FieldID
          Dc.L      INT+\1
          ENDM

StrTag    MACRO     ; FieldID
          Dc.L      STRING+\1
          ENDM

BinTag    MACRO     ; FieldID
          Dc.L      BINARY+\1
          ENDM

; /* These macros can be used to check a FieldID value against a datatype */
; #define IsControl(v) (CONTROL==(v & DATATYPES))
; #define IsInt(v)     (INT==(v & DATATYPES))
; #define IsString(v)  (STRING==(v & DATATYPES))
; #define IsBinary(v)  (BINARY==(v & DATATYPES))

          ; This structure is returned by TDDB_GetDataItem
          STRUCTURE DataStorage,0
          ULONG     ds_ID            ; Identifies the field data belongs to
          LONG      ds_Data          ; Data for IntTag fields
          LABEL     ds_String        ; String for StrTag fields
          LABEL     ds_Binary        ; Data pointer for BinTag fields.
          LABEL     ds_SIZE


; This message is allocated by you and then replyed when something happens.
          STRUCTURE UpdateMsg,MN_SIZE
          APTR      um_DBase            ; Points to origin database.
          APTR      um_Proc             ; The process causing this message
          ULONG     um_Type             ; What have happened?
          ULONG     um_NodeNr           ; On wich node did it happen?
          ULONG     um_MoreData         ; Is there more to know?
          LABEL     um_SIZE

; Types of UpdateMsg know today
MSG_NEWNODE    EQU  0         ; Node has been created.
MSG_DELNODE    EQU  1         ; Node has been deleted.
MSG_NODELOCK   EQU  2         ; Node is now to considered locked
MSG_NODEUNLOCK EQU  3         ; Node nolonger is locked
MSG_CHANGED    EQU  4         ; There are new data stored in it
MSG_USER       EQU  5         ; Caused by a call to TDDB_ShowUpdate()
MSG_ABORTED    EQU  6         ; Message has been aborted.
MSG_SWAP       EQU  7         ; Nodes are swaped, MoreData is number of
                              ; number of the other node.

; Tags for TDDB_SeekBase() and TDDB_Find#?()
 
SBT_Dummy     EQU   TAG_USER

SBT_StartNode EQU   (SBT_Dummy+1)       ; ti_Data is nodenr to start from
                                        ; instead of 0

          ENDC ;LIBRARIES_TDDBASE_I