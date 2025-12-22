/*
 * global_memory.c  V3.1
 *
 * ToolManager global memory management routines
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

#ifdef DEBUG
/* Debugging versions of memory functions. These work with Mungwall */

/* Local data structures */
struct MemoryData {
 struct MinNode md_Node;
 ULONG          md_Size;
 /* Rest of memory block follows here */
};

/* Local data */
static struct MinList MemoryList;
static BOOL           Initialized = FALSE;

/* Initialize memory managment */
#define DEBUGFUNCTION InitMemory
BOOL InitMemory(void)
{
 /* Initialize list */
 NewList((struct List *) &MemoryList);

 /* Set flag */
 Initialized = TRUE;

 INFORMATION_LOG(LOG0(Memory tracking enabled))

 return(TRUE);
}

/* Shut down memory management */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DeleteMemory
void DeleteMemory(void)
{
 /* List empty? */
 if ((Initialized == FALSE) || IsListEmpty((struct List *) &MemoryList)) {

  INFORMATION_LOG(LOG0(All memory was released))

 } else {
  struct MemoryData *md;

  ERROR_LOG(LOG0(The following memory has not been released))

  while (md = (struct MemoryData *) RemHead((struct List *) &MemoryList)) {

   ERROR_LOG(LOG2(Not released, "Block 0x%08lx Size %ld",
                  md + 1, md->md_Size))
   FreeVector(md + 1);
  }
 }

 /* Reset flag */
 Initialized = FALSE;
}

/* Get memory (no size tracking) */
void *GetMemory(ULONG size)
{
 return(GetVector(size));
}

/* Free memory (no size tracking) */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION FreeMemory
void FreeMemory(void *ptr, ULONG size)
{
 struct MemoryData *md = (struct MemoryData *) ptr - 1;

 /* Check sizes */
 if (size == (md->md_Size - sizeof(struct MemoryData))) {

  MEMORY_LOG(LOG2(Arguments, "Block 0x%08lx Size %ld", ptr, size))

 } else {

  ERROR_LOG(LOG3(Error, "Block 0x%08lx Size %ld != Orig %ld",
                 ptr, size, md->md_Size))
 }

 /* Remove memory block */
 Remove((struct Node *) md);
 FreeMem(md, md->md_Size);
}

/* Get memory (with size tracking) */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION GetVector
void *GetVector(ULONG size)
{
 struct MemoryData *md;

 /* Add size for our data structure */
 size += sizeof(struct MemoryData);

 /* Allocate memory, save size and move pointer to real mem. block */
 if (md = AllocMem(size, MEMF_PUBLIC)) {
  md->md_Size = size;

  /* Add block to memory list */
  AddTail((struct List *) &MemoryList, (struct Node *) md++);
 }

 MEMORY_LOG(LOG2(Result, "Block 0x%08lx Size %ld",
                 md, size - sizeof(struct MemoryData)))

 /* Return pointer to memory block */
 return(md);
}

/* Free memory (with size tracking) */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION FreeVector
void FreeVector(void *ptr)
{
 struct MemoryData *md = (struct MemoryData *) ptr - 1;

 MEMORY_LOG(LOG2(Arguments, "Block 0x%08lx Size %ld",
                 ptr, md->md_Size - sizeof(struct MemoryData)))

 /* Remove memory block */
 Remove((struct Node *) md);
 FreeMem(md, md->md_Size);
}

#else
/* The production code uses memory pools */

/* Local data structures */
struct Vector {
 ULONG v_Size;
 /* Rest of memory block follows here */
};

/* Local data */
static void *MemoryPool = NULL;

/* Initialize memory managment */
BOOL InitMemory(void)
{
 /* Allocate memory pool */
 return(MemoryPool = CreatePool(MEMF_PUBLIC, 8 * 1024, 6 * 1024));
}

/* Shut down memory management */
void DeleteMemory(void)
{
 if (MemoryPool) {
  DeletePool(MemoryPool);
  MemoryPool = NULL;
 }
}

/* Get memory (no size tracking) */
void *GetMemory(ULONG size)
{
 return(AllocPooled(MemoryPool, size));
}

/* Free memory (no size tracking) */
void FreeMemory(void *ptr, ULONG size)
{
 FreePooled(MemoryPool, ptr, size);
}

/* Get memory (with size tracking) */
void *GetVector(ULONG size)
{
 struct Vector *v;

 /* Add size for our data structure */
 size += sizeof(struct Vector);

 /* Allocate memory from pool, save size and move pointer to real mem. block */
 if (v = AllocPooled(MemoryPool, size)) (v++)->v_Size = size;

 /* Return pointer to memory block */
 return(v);
}

/* Free memory (with size tracking) */
void FreeVector(void *ptr)
{
 ULONG size = (--((struct Vector *) ptr))->v_Size;

 FreePooled(MemoryPool, ptr, size);
}
#endif
