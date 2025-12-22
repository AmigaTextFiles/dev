#ifndef LIBRARIES_TDDBASE_H
#define LIBRARIES_TDDBASE_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_SEMAPHORES_H
#include <exec/semaphores.h>
#endif

#ifndef DOS_DOS_H
#include <dos/dos.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

/*
 * This structure is the shared part of a database
 */
struct DataBase
{
          struct Node Node;             /* PRIVATE: Dont tuch */

          /*
           * Here can you find out who and how many programms that are 
     * using this database at any time.
     */
          UWORD UseCnt;                                                         /* Number of opened databases */
          struct MinList HandleList;                        /* List with handlers */
          struct SignalSemaphore HandleSem;

          ULONG DataID;                           /* Identifies the contents of DBase */
          ULONG FileType;                         /* Gives fileformat */

          ULONG Flags;                            /* Reserved for future usage */

          ULONG Nodes;                            /* Number of nodes that belongs to this dbase */

          /* There exists private data below */
};

#ifndef MakeID
#define MakeID(a,b,c,d)       ((a<<24)|(b<<16)|(c<<8)|d)
#endif

/* This is the only recognized FileType that is suported. */
#define   FILID_STATIC        MakeID('D','B','1','0')

/* Use this generic DataID if you do not wish to use datarecognizion. */
#define DBID_NOID             0

/* These 2 DataID values are only for testing. Other DataID values can only
 * be registerd via betasoft. */
#define DBID_TEST1            1
#defien DBID_TEST2            2

/* This is the process-specific parts of each database. */
struct DBHandle
{
          struct MinNode       Node;              /* Linkage in handlerlist. */
          struct DataBase *DBase;                 /* Points back to database */
          struct Process      *Process; /* The process this handle is on */
          ULONG                          Error;             /* Last errorcode */

          /* More private data follows! */
};

/* Error codes */
#define Err_NoErr             0                   /* Everything went just fine */
#define Err_NoNode            1                   /* You tried to access a non-existing node */
#define Err_NoMem             2                   /* Ran out of memory */
#define Err_DosErr            3                   /* FileIO error */
#define Err_NotDBase          4                   /* Not a database-file */
#define Err_NodeBusy          5                   /* Cant get acess to node */

/* This structure defines a node in memory */
struct DBNode
{
          struct SignalSemaphore Semaphore;       /* PRIVATE: DONT TOUCH! */
          UWORD Flags;                                                          /* Flags, see below for bit-defs */
          ULONG NodeNr;                                                         /* This nodes number */
          struct DataStorage *DataList;           /* List with all data */
          struct Process *LockProc;                         /* The process that has a lock on node */
};

/* NodeFlags */
#define NF_Changed  (1l<<0)             /* You have changed contents of this node */
#define NF_New                (1l<<1)             /* Node has just been created */
#define NF_Locked   (1l<<2)             /* Node has a "soft" lock on it */

#define NB_Changed  (0)
#define NB_New                (1)
#define NB_Locked   (2)

/* Flags for TDDB_GetNode() */
#define MODEF_READ            (1l<<0)             /* Get read acess */
#define MODEF_WRITE           (1l<<1)             /* Get read/write acess to nide */
#define MODEF_NOWAIT          (1l<<2)             /* Dont wait for it to become free */

/* Here comes some defines/macros to be used on field ID's */

#define DATATYPES   (0xf0000000)        /* These bits are reserved for datatype */

#define CONTROL     (0x00000000)        /* Internal controltags DONT TOUCH! */
#define INT                             (0x80000000)        /* 32 bit value */
#define STRING                (0x40000000)        /* NULL terminated string */
#define   BINARY              (0xc0000000)        /* Binary data */

/* These macros can be used to define correct FieldID values */
#define IntTag(v)   (INT + v)
#define StrTag(v)   (STRING + v)
#define BinTag(v)   (BINARY + v)

/* These macros can be used to check a FieldID value against a datatype */
#define IsControl(v) (CONTROL==(v & DATATYPES))
#define IsInt(v)    (INT==(v & DATATYPES))
#define IsString(v) (STRING==(v & DATATYPES))
#define IsBinary(v) (BINARY==(v & DATATYPES))

// This structure is returned by TDDB_GetDataItem()
struct DataStorage
{
          ULONG ds_ID;                                      /* Identifies the field data belongs to. */

          union
          {
                    ULONG     ds_Nummer;                    /* Data for IntTag */
                    STRPTR    ds_String;                    /* Pointer to StrTag string */
                    APTR      ds_Binary;                    /* Pointer to BinTag databuffer. */
          };
};

/* This message is allocated by you and then replyed when something happens. */
struct UpdateMsg
{
          struct Message Msg;
          struct DataBase *DBase;                 /* Points to origin database */
          struct Process *Proc;                   /* The process causing this message */
          ULONG Type;                                                 /* What have happened? */
          ULONG NodeNr;                                     /* To what node did it happen? */
          ULONG MoreData;                                   /* Is there more to know? */
};

/* Types of UpdateMsg know today */
#define MSG_NEWNODE           0                   /* Node has been created. */
#define MSG_DELNODE           1                   /* Node has been deleted. */
#define MSG_NODELOCK          2                   /* Node is now to considered locked */
#define MSG_NODEUNLOCK        3                   /* Node nolonger is locked */
#define MSG_CHANGED           4                   /* There are new data stored in it */
#define MSG_USER              5                   /* Caused by a call to TDDB_ShowUpdate() */
#define MSG_ABORTED           6                   /* Message has been aborted */
#define MSG_SWAP              7                   /* Nodes are swaped, MoreData is number of */
                                                                                /* the second node */

/*
 * Tags for TDDB_SeekBase() and TDDB_Find#?()
 */ 
#define SBT_Dummy             TAG_USER

#define SBT_StartNode         (SBT_Dummy+1)       /* ti_Data is nodenr to start from */
                                                                                                    /* instead of 0 */

#endif // LIBRARIES_TDDBASE_H