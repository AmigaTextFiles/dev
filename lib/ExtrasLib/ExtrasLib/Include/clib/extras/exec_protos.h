#ifndef CLIB_EXTRAS_EXEC_PROTOS_H
#define CLIB_EXTRAS_EXEC_PROTOS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif

#ifndef EXTRAS_LIBS_H
#include <extras/libs.h>
#endif

#ifndef EXTRAS_MEM_H
#include <extras/mem.h>
#endif

BOOL ex_OpenLibs(ULONG Argc, 
              STRPTR ProgName, 
              STRPTR ErrorString, 
              STRPTR LibVerFmt, 
              STRPTR ButtonText, 
              struct Libs *Libs);
              
void ex_CloseLibs(struct Libs *Libs);

/*** EnqueueName.o ***/
void  EnqueueName(struct List *List,
                  struct Node *Node);

/**** Memory allocation ****/
BOOL MultiAllocVec (ULONG Flags, ULONG VecTag, ...  );
BOOL MultiAllocVecA(ULONG Flags, struct VecTag *VecTagList);
void MultiFreeVec  (ULONG Args , APTR MemBlock, ... );
void MultiFreeVecA (ULONG Args , APTR *MemBlockList );

BOOL MultiAllocMem (ULONG Flags, ULONG MemTag, ... );
BOOL MultiAllocMemA(ULONG Flags, struct MemTag *MemTagList);
void MultiFreeMem  (ULONG Args , ULONG MFMTag, ... );
void MultiFreeMemA (ULONG Args , struct FreeTag *FreeTagList );

BOOL MultiAllocPooled(APTR Pool, ULONG Flags, ULONG MAPTag, ... );
BOOL MultiAllocPooledA(APTR Pool, ULONG Flags, struct PoolTag *MAPTag);
void MultiFreePooled(APTR Pool, ULONG Args, ULONG FreeTag, ... );
void MultiFreePooledA(APTR Pool, ULONG Args, struct FreeTag *FreeTagList);

/* Obsolete */
BOOL OpenLibsWB ( STRPTR ProgName, struct Libs *Libs);
BOOL OpenLibsCLI( STRPTR ProgName ,struct Libs *Libs, 
                  STRPTR ErrorStr, STRPTR NameVerFmt);

#endif /* CLIB_EXTRAS_EXEC_PROTOS_H */
