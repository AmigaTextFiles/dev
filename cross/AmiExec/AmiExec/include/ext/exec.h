#ifndef EXT_EXEC_H
#define EXT_EXEC_H 1
/**************************************************************************** 

$Source: MASTER:include/ext/exec.h,v $
$Revision: 3.4 $
$Date: 1997/01/01 11:14:56 $

This file contains some "low-level" extensions of the standard CBM exec
includes.

****************************************************************************/
#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef  EXEC_NODES_H
#include <exec/nodes.h>
#endif

#ifndef  EXEC_MEMORY_H
#include <exec/memory.h>
#endif


/*--- Extensions to <exec/types.h>. ---*/

typedef short  IWORD;            /* Little Endian (Intel) word */
typedef long   ILONG;            /* Little Endian (Intel) long word */


/*--- Extensions to <exec/nodes.h>. ---*/

/* The ANode structure is for creating lists of non-nodes, or adding data
   to multiple lists. */

struct ANode
   {
   struct Node node;
   APTR   data;
   };


/*--- Extensions to <exec/resident.h>.  ---*/

/* Structures for AUTOINIT of resident modules. */

struct RtInitLib
   {
   ULONG space;
   APTR  funcTable;    
   APTR  dataTable;    
   APTR  initRoutine;  
   };

struct RtInitTask
   {
   BYTE  priority;
   void  (*entrypt)();
   ULONG stacksz;
   };

struct RtInitMem
   {
   ULONG size;   
   ULONG attributes;
   LONG  pri;
   APTR  base;
   char  *name;
   APTR  dest;
   };


/*--- Extensions to <exec/memory.h>. ---*/

/* A couple of handy memory types. */

#define  MEMF_STD    MEMF_ANY | MEMF_CLEAR  /* "standard" way to ask for memory */
#define  MEMF_BAT    MEMF_CHIP              /* battery backed up memory */


/*--- Extensions to <exec/ports.h>. ---*/

/* Define a user signal for sleep/wake coordination. */

#define SB_SLEEP     16                /* signal for sleep/wake coordination */
#define SF_SLEEP     (1 << SB_SLEEP)


/*--- Extensions to <exec/interrupts.h>. ---*/

/* Structs and such for manipulating the context of an interrupt. */

struct Registers
   {
   ULONG datreg[8];
   ULONG addreg[8];
   };

enum DATREGID {D0, D1, D2, D3, D4, D5, D6, D7};
enum ADDREGID {A0, A1, A2, A3, A4, A5, A6, A7};

struct Context
   {
   struct Registers registers;         /* address and data registers */
   UWORD  statreg;                     /* status registers */
   ULONG  pc;                          /* program counter */
   };


#define SRM_TRACE          0xC000
#define SRV_TRACE_NONE     0x0000
#define SRV_TRACE_ANY      0x8000
#define SRV_TRACE_CHANGE   0x4000



/* A Vector structure defines how an exception vector is to be initialized. */

struct Vector
   {
   LONG vectnum;
   void (*isr)();
   };


/* Prototypes for interrupt related procedures which are extensions to
   the Amiga Exec. */

APTR SetExceptVect(UBYTE vectnum, APTR code, UBYTE execintnum);



/*--- Extensions to <exec/libraries.h>. ---*/

/* The LibEntry structure describes the format of an entry in a library's
   vector table. */

struct LibEntry
   {
   UWORD opcode;              /* always MF_JMPLONG as defined below. */
   APTR  func;                /* ptr to a library procedure */
   };

#define LE_JMPLONG   0x4ef9   /* jmp instruction opcode */


/*--- Prototypes for startup code. ---*/

/* These are included here for backwards compatibility.  New code should
   pull in <ext/startup.h> to obtain these. */

void StdSetup(struct ExecBase *sysbase);                       /* libraries */
void __asm StdEntry(register __a6 struct ExecBase *sysbase);   /* tasks */   


#endif
