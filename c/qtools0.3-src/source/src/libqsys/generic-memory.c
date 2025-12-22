/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#define	LIBQSYS_CORE
#include "../include/libqsys.h"

#ifdef	MEM_SIZETRACK
#define	FRONTWALL	0
#define	BACKWALL	0

#ifdef	MEM_ANALYSE
int memcounter = 0;
int mempeak = 0;
int memallocs = 0;
int mempeakallocs = 0;
#endif

#ifndef	TMALLOC
void *tmalloc(register int size)
{
  int *ret;

  /* use calloc instead ? */
  if ((ret = (int *)malloc(size + sizeof(int) + BACKWALL + FRONTWALL))) {
    /* printf("zero: alloc %lx, begin %lx, end %lx, size %d\n", ret, ret + ((sizeof(int) + FRONTWALL) / sizeof(int)), ((char *)(ret + ((sizeof(int) + FRONTWALL) / sizeof(int)))) + size, size); */
    __bzero(ret + (FRONTWALL / sizeof(int)) + 1, size);

#ifdef	MEM_ANALYSE
    memcounter += size + sizeof(int) + BACKWALL + FRONTWALL;

    memallocs++;
    if (memcounter > mempeak)
      mempeak = memcounter;
    if (memallocs > mempeakallocs)
      mempeakallocs = memallocs;
#endif
#ifdef	DEBUG_C
    oprintf("allocate %d bytes\n", size);
#endif
    *ret++ = size;
    ret += (FRONTWALL / sizeof(int));
  }
  return (void *)ret;
}
#endif

#ifndef	TFREE
void tfree(register void *adr)
{
  if (adr) {
#if defined(__amigaos__) && defined(DEBUG)
    int addr = (int)adr >> 28;

    if (addr) {
      eprintf("leak found for %lx\n", adr);
    }
    else {
      int *ret = (int *)adr - (FRONTWALL / sizeof(int));

#ifdef	MEM_ANALYSE
      memcounter -= *(ret - 1) - sizeof(int) - BACKWALL - FRONTWALL;

      memallocs--;
#endif
      free(--ret);
    }
#else
    int *ret = (int *)adr - (FRONTWALL / sizeof(int));

#ifdef	MEM_ANALYSE
    memcounter -= *(ret - 1) - sizeof(int) - BACKWALL - FRONTWALL;

    memallocs--;
#endif
    free(--ret);
#endif
  }
}
#endif

#ifndef	TSIZE
int tsize(register void *adr)
{
  if (adr)
    return *((int *)adr - (FRONTWALL / sizeof(int)) - 1);
  else
    return 0;
}
#endif

#ifndef	TREALLOC
void *trealloc(register void *adr, register int newsize)
{
  if (adr) {
    int *ret;
    int oldsize = tsize(adr);

    if ((ret = (int *)tmalloc(newsize))) {
      /* copy only valid bytes, leave more bytes cleared */
      __memcpy(ret, adr, oldsize < newsize ? oldsize : newsize);
    }

    tfree(adr);
    return (void *)ret;
  }
  else
    return tmalloc(newsize);
}
#endif
#endif

/*
 * an interface for temporary memtracking with automatic freeing after use
 */

struct memtrack {
  struct memtrack *next;
  int something[1];
};

struct memtrack *firstmalloc = 0;
struct memtrack *lastmalloc = 0;

#ifndef	KMALLOC
void *kmalloc(register int size)
{
  struct memtrack *ret;

  if ((ret = (struct memtrack *)tmalloc(size + sizeof(struct memtrack *)))) {
    if (!firstmalloc) {
      firstmalloc = ret;
      lastmalloc = ret;
    }
    else {
      lastmalloc->next = ret;
      lastmalloc = ret;
    }
  }
  return (void *)&ret->something[0];
}
#endif

#ifndef	KFREE
void kfree(register void)
{
  if (firstmalloc) {
    struct memtrack *first = firstmalloc;
    struct memtrack *next;

    while (first) {
      next = first->next;
      tfree(first);
      first = next;
    }

    firstmalloc = 0;
    lastmalloc = 0;
  }
}
#endif

#ifndef	SMALLOC
char *smalloc(register char *in)
{
  char *string = 0;

  if (in)
    if ((string = (char *)tmalloc(__strlen(in) + 1)))
      __strcpy(string, in);
  return string;
}
#endif

#ifndef	SKMALLOC
char *skmalloc(register char *in)
{
  char *string = 0;

  if (in)
    if ((string = (char *)kmalloc(__strlen(in) + 1)))
      __strcpy(string, in);
  return string;
}
#endif
