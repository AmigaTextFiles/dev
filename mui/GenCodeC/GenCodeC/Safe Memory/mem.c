#include "exec/types.h"
#include "exec/memory.h"
#include "stdio.h"

/*
 * FILE:
 *   mem.c
 *
 * DESCRIPTION:
 *     Replacement functions for AllocMem() and FreeMem() that provide
 *  enhanced error checking. These functions put a safety net around the
 *  Amiga's memory allocation routines. They manage their own list,
 *  watching for memory leaks, double frees, etc. safe_AllocMem() and
 *  safe_FreeMem() are functional replacements for AllocMem() and
 *  FreeMem(), while safe_ShowMemList() displays the memory blocks
 *  (and where in the sourcecode they were allocated) that have not
 *  yet been freed.
 *
 *     To convert a program to using these safe calls (which would probably
 *   only be used in the development stage), simply include the .h file,
 *   link the .o file, and place a call to safe_ShowMemList() and
 *   safe_ClearMemList before the program terminates.
 *
 *
 * USAGE:
 *     All access to the functions in this module are accessed via the
 *   macros in mem.h. Once mem.h is included into the source, all calls
 *   to AllocMem() and FreeMem() are replaced with safe_AllocMem() and
 *   safe_FreeMem().
 *
 *     Since safe_ShowMemList() and safe_ClearMemList() are not present in
 *   the normal OS, it is not compatible with s/ware not using the safe_
 *   functions. A simple setup is thus:
 *
 * #ifdef DEBUG
 * #include "mem.h"
 * #endif
 *
 * main()
 * {
 *   ...
 *   ...
 * #ifdef DEBUG
 *   ShowMemList()
 *   ClearMemList()
 * #endif
 * }
 *
 *     The calls to ShowMemList() & ClearMemList() could easily be placed
 *  in a break or exit trap, so that memory was automatically displayed &
 *  freed when the program used an exit(), or the user pressed ^C or ^D.
 *
 */


/*
 * STRUCT:
 *   MemNode
 *
 * DESCRIPTION:
 *     The MemNode structure is placed at the start of each memory block
 *   managed by the safe_ functions. It contains useful information like
 *   where in the source the block was allocated, how big the block is
 *   and the next block in the list.
 *
 * USAGE:
 *     It is completely internal to the safe_ suite of functions, no other
 *   source need know of it's existance.
 */

struct MemNode
{
  struct MemNode *child;             /* Next block in list        */

  char *file;                        /* File that allocated us    */
  ULONG line;                        /* Line we were allocated on */

  ULONG size;                        /* Size of memory block      */
};

static struct MemNode *head;

/*
 * FUNCTION:
 *   void *safe_AllocMem(Size, MemType, File, Line)
 *
 * DESCRIPTION:
 *     Peforms a call to AllocMem() with enhanced error checking. Access
 *   to this function should be through the macros in mem.h -ONLY-.
 *   Note that all memory allocated with the safe_ functions must be freed
 *   with the safe_ functions.
 *
 * ARGUMENTS:
 *   long Size;      Size of the block to allocate.
 *   long MemType;   Type of memory to request.
 *   char *File;     Calling file     (ie __FILE__)
 *   int  Line;      Calling line     (ie __LINE__)
 *
 * RETURNS:
 *   SUCCESS: A pointer to the new memory block
 *   FAILURE: 0
 *
 * WRITTEN:
 *   Friday 14-Dec-90 13:02:11 spb
 */

void *safe_AllocMem(Size, MemType, File, Line)
ULONG Size;
ULONG MemType;
char *File;
ULONG Line;
{
  struct MemNode *t;

  if(head)
    t = head;
  else
    t = 0;

  head = AllocMem(Size + sizeof(struct MemNode), MemType);

  if(head)
  {
    head->child = t;
    head->file  = File;
    head->line  = Line;
    head->size  = Size;

    return((void *)((long)head + sizeof(struct MemNode)));
  }

  return(0);
}

/*
 * FUNCTION:
 *   void safe_FreeMem(Address, Size, File, Line)
 *
 * DESCRIPTION:
 *     Peforms a FreeMem() with the enhanced error checking. Must be accessed
 *   through the macros in mem.h. Note that all memory allocated with the
 *   safe_ functions must be freed with the safe_ functions.
 *
 * ARGUMENTS:
 *   ULONG Address; Location of block to free
 *   ULONG Size;    Size of block to free
 *   char *File;    Calling file     (__FILE__)
 *   ULONG Line;    Calling line     (__LINE__)
 *
 * WRITTEN:
 *   Friday 14-Dec-90 13:02:20 spb
 */

void safe_FreeMem(Address, Size, File, Line)
ULONG Address;
ULONG Size;
char *File;
ULONG Line;
{
  struct MemNode *t1, *t2;

  t1 = head;
  t2 = 0;

  while(t1)
  {
    if(Address == (long)t1+sizeof(struct MemNode))
    {
      if(Size != t1->size)
      {
        fprintf(stdout, "%s %d: Incorrect free size. (%d instead of %d)\n",
                   File, Line, Size, t1->size);

        return;
      }


      if(t2)
        t2->child = t1->child; /* Remove block from the list */
      else
        head = t1->child;

      FreeMem(t1, sizeof(struct MemNode)+t1->size);
      return;
    }

    t2 = t1;
    t1 = t1->child;
  }

  fprintf(stdout, "%s %d: Free twice (?) FreeMem($%lx, %d)\n",
                   File, Line,                   Address, Size);

  return;
}

/*
 * FUNCTION:
 *   ULONG safe_ShowMemList(File, Line)
 *
 * DESCRIPTION:
 *     Displays a list of currently unfreed blocks (if there are any) that
 *   were allocated with safe_AllocMem. Along with each memory block
 *   is the file, function and line it was allocated from.
 *
 * ARGUMENTS:
 *   char *File;    Calling File (__FILE__)
 *   char *Line;    Calling Line (__LINE__)
 *
 * RETURNS:
 *   ULONG   Number of memoryblocks in the list.
 *
 * WRITTEN:
 *   Friday 14-Dec-90 13:02:26 spb
 */

ULONG safe_ShowMemList(File, Line)
char *File;
char *Line;
{
  ULONG c=0;
  struct MemNode *t;

  if(head)
  {
    t = head;
    fprintf(stdout, "%s %d: Memory List\n", File, Line);

    fprintf(stdout, "    %-12s %-12s %-16s %-4s\n",
           "Address", "Size", "File", "Line");
    fprintf(stdout, "    %-12s %-12s %-16s %-4s\n",
           "-------", "----", "----", "----");

    while(t)
    {
      fprintf(stdout, "    $%-11lx %-12d %-16s %-4d\n",
              t, t->size, t->file, t->line);

      t = t->child;
      c++;
    }
  }
  return(c);
}

/*
 * FUNCTION:
 *   ULONG safe_ClearMemList(File, Line)
 *
 * DESCRIPTION:
 *     Frees all the memoryblocks present in the safe_ list. This ensures
 *   the environment will get all it's memory back even though the program
 *   is faulty, speeding development time.
 *
 * ARGUMENTS:
 *   char *File; Calling file (__FILE__)
 *   char *Line; Calling line (__LINE__)
 *
 * RETURNS:
 *   long Number of blocks freed.
 *
 * WRITTEN:
 *   Friday 14-Dec-90 13:52:16 spb
 */

ULONG safe_ClearMemList(File, Line)
char *File;
char *Line;
{
  ULONG c=0;
  struct MemNode *t1, *t2;

  if(head)
  {
    t1 = head;
    fprintf(stdout, "%s %d: Freeing Memory List\n", File, Line);

    while(t1)
    {
      t2 = t1->child;
      FreeMem(t1, t1->size + sizeof(struct MemNode));
      t1 = t2;
      c++;
    }
  }

  head = 0;
  return(c);
}

