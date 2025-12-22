/***********************************************************************/
/*                                                                     */
/*                                                                     */
/*                                                                     */
/*			Structures and definitions for machine coded modules           */
/*                                                                     */
/*                     version 93.01.31                                */
/*                                                                     */
/***********************************************************************/

#ifndef COMAL_H

#define COMAL_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif  /* EXEC_TYPES_H */

#ifndef LIBRARIES_DOS_H
#include <libraries/dos.h>
#endif  /* LIBRARIES_DOS_H */

struct ComalStruc
{
  UWORD BreakFlags;
  UWORD Flags;                   /* See definitions below               */
  UBYTE *CurrWorkBottom;         /* Current start of workspace          */
  UBYTE *CurrWorkTop;            /* Current top of workspace            */
  UBYTE *MinStack;               /* Safe low value of stack             */
  struct Screen *IO_Screen;      /* Input/output screen                 */
  struct MsgPort *CommPort;      /* Port to comunicate with parent      */
  char  *Id;                     /* ASCII ID string for this project    */
  struct PrgBuf *MainPrgBuf;     /* Main program buffer                 */
  struct PrgEnv *PrgEnv;         /* Current program environment         */
  UBYTE *WorkStart;              /* Start of workspace                  */
  UBYTE *WorkEnd;                /* End of useable workspace            */
  ULONG WorkLength;              /* Total length of workspace           */
  UBYTE *SortTable;              /* String sort table                   */
  UBYTE *ComalPath;              /* Home directory for comal            */
};

/* Break flags definitions  */
#define BF_ESC          0x01
#define BF_SingleStep   0x02
#define BF_Interrupt    0x04
#define BF_BreakPoint   0x08

/* Secondary break flags definitions  */
#define BF_LineStep     0x01

/* Flags definitions  */
#define F_ESCMINUS  0x0001       /* Trap escape key                     */
#define F_ESCPRESS  0x0002       /* Break pressed during TRAP ESC+      */
#define F_TRACEMODE 0x0004       /* Executing in TRACE-mode             */


struct Module
{
  struct Module *NextModule;        /* Link to next module structure    */
  UBYTE  *Name;                     /* Name of module                   */
  UBYTE  Type;                      /* Modules type - see below         */
  UBYTE  Flags;                     /* Flags - se below                 */
  union
  {
    struct PrgBuf *PrgBuf;          /* Pointer to program buffer        */
    BPTR   Segment;                 /* Pointer to modules segment list  */
  } PrgMem;
  struct PrgEnv *PrgEnv;            /* Only used in comal modules       */
  union
  {
    struct ModuleLine *ModuleLine;  /* Only used in comal modules       */
    char **TextArray;               /* Information text for code module */
  } Inf;
  WORD   NumType;                   /* Number of types defined in modul */
  struct ModuleType *Types;         /* Array of types defined in module */
  WORD   NumName;                   /* Number of names defined in modul */
  struct ModuleName *Names;         /* Array of exported names          */
  void   (*Signal)(ULONG);          /* Address of signal routine        */
};
/* Module types */
#define LOCALMODULE   1             /* Local module                     */
#define EXTERNMODULE  2             /* External module                  */
#define CODEMODULE    3             /* External machine coded module    */

/* Signal numbers */
#define SIG_CLOSE       1           /* Interpreter is closed            */
#define SIG_DISCARD     2           /* Module is being discarded        */
#define SIG_CLEAR       3           /* Program buffer is returned       */
#define SIG_RUN         4           /* Program execution starts         */
#define SIG_STOP        5           /* Execution stops (to be continued) */
#define SIG_END         6           /* End of execution (no continue)   */

/* Types  */
#define STRING_ID   -1
#define FLOAT_ID    -2
#define ULONG_ID    -3
#define LONG_ID     -4
#define UWORD_ID    -5
#define WORD_ID     -6
#define UBYTE_ID    -7
#define BYTE_ID     -8
#define STRUC_ID    -9
#define ARRAY_ID   -10
#define FUNC_ID    -11
#define PROC_ID    -12
#define POINTER_ID -13

/* Type descriptor for array  */

struct IndexRange
{
  LONG Lower;
  LONG NumberOf;
};

struct Array
{
  WORD TypeId;            /* Type identifier (right side in TYPE line)  */
  WORD ElementType;       /* Element type                               */
  ULONG Length;           /* Length of data                             */
  WORD *TypeDescriptor;   /* address of secondary type descriptor       */
  WORD NumDim;            /* Number of dimensions                       */
  LONG NumElement;        /* Total number of elements                   */
  struct IndexRange Index[1];
};


/* Type descriptor for FUNC/PROC */

struct Param
{
  UBYTE Flags;
  BYTE  SecondaryType;
  WORD  PrimaryType;
};

struct ProcType
{
  WORD TypeId;            /* Type identifier (right side in TYPE line)  */
  WORD ReturnType;        /* Return type (FUNC) or zero (PROC)          */
  WORD *TypeDescriptor;   /* Type descriptor for return type            */
  UWORD Flags;
  UBYTE StackUse1;        /* Stack use of type descriptors              */
  UBYTE StackUse0;        /* Primary parameter stack use                */
  UWORD NumPar;           /* Number of formal parameters                */
  struct Param Param[1];
};


struct ExceptStruc
{
	struct ExceptStruc *Next;
	ULONG SignalMask;
	void  (*ExceptRoutine)();
  APTR  IdField;
};

/************************************************************************/
/*                                                                      */
/*        Definitions for streams                                       */
/*                                                                      */
/*                                                                      */
/************************************************************************/

struct IoDevice
{
  struct IoDevice *NextDevice;
  UBYTE *Name;
  UWORD Type;
  UWORD Reserved;
  ULONG (*Open)(char *,UWORD,short *);
  void (*Close)(ULONG);
  short (*Read)(ULONG,UBYTE *,LONG *,ULONG);
  BOOL (*Write)(ULONG,UBYTE *,LONG *);
  short (*ReadLn)(ULONG,UBYTE *,LONG *);
  BOOL (*WriteLn)(ULONG,UBYTE *,LONG *);
  short (*Scan)(ULONG,UBYTE *,LONG *);
  union
  {
    BOOL (*Cursor)(ULONG,short *,short *);
    BOOL (*StrmPtr)(ULONG,LONG *);
  } Get;
  union
  {
    BOOL (*Cursor)(ULONG,short,short);
    BOOL (*StrmPtr)(ULONG,LONG);
  } Set;
  short (*StreamError)();
};

/* Standard stream numbers  */
#define StdInStream    -1
#define StdOutStream   -2

/* Device types */
#define SEQ_DEVICE   0
#define CRT_DEVICE   1
#define KBD_DEVICE   2
#define RBF_DEVICE   3

struct Stream
{
  struct Stream *NextStream;
  WORD Number;
  UWORD Flags;
  ULONG RecordLength;             /* Zero if sequential device          */
  struct IoDevice *Device;        /* Pointer to to device information   */
  ULONG StreamId;                 /* Stream identification              */
};

/* Stream flags */
#define READ_STREAM   0x0001
#define WRITE_STREAM  0x0002
#define END_OF_STREAM 0x0004

/* Stream access modes  */
#define ACCESSREAD   0x0001
#define ACCESSWRITE  0x0002
#define ACCESSNEW    0x0004

/* Open modes   */
#define READ_MODE     ACCESSREAD
#define APPEND_MODE   ACCESSWRITE
#define UPDATE_MODE   ACCESSREAD | ACCESSWRITE
#define REWRITE_MODE  ACCESSWRITE | ACCESSNEW

#endif

