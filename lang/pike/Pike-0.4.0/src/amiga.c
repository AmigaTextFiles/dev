/*
   Amiga support module for Amiga Pike

   Copyright (c) 1997 by Bernhard Fastenrath
   (fasten@cs.bonn.edu / fasten@shw.com)

   This file may be distributed under the terms
   of the GNU General Public License.
*/

#include <exec/memory.h>
#include <proto/exec.h>

#include "global.h"
#include "memory.h"
#include "error.h"
#include "macros.h"

static void *pool = NULL;

void
amiga_exit (void)
{
  if (pool)
    DeletePool (pool);  
}

int
amiga_init (void)
{
  atexit (amiga_exit);

  if (!(pool = CreatePool (MEMF_PUBLIC, 4096, 4096)))
    error ("Out of memory.\n");
}

void *
malloc (size_t size)
{
  char *mem;

  size += sizeof (size_t);
  if (mem = AllocPooled (pool, size))
  {
    *(size_t *) mem = size;
    mem += sizeof (size_t);
  }
  return mem;
}

void *
calloc (size_t n, size_t s)
{
  size_t size = n * s;
  void *mem;

  if (mem = malloc (size))
    bzero (mem, size);
  return mem;
}

void *
realloc (void *b, size_t size)
{
  void *mem = NULL;
  size_t b_size;

  if (size)
  {
    mem = malloc (size);
  }
  if (b)
  {
    if (mem)
    {
      b_size = *(size_t *) ((char *) b - sizeof (size_t));
      bcopy (b, mem, size < b_size ? size : b_size);
    }
    if (mem || (!mem && size == 0))
      free (b);
  }
  return mem;
}

void
free (void *ptr)
{
  size_t size;

  (char *) ptr -= sizeof (size_t);
  size = *(size_t *) ptr;
  FreePooled (pool, ptr, size);
}
