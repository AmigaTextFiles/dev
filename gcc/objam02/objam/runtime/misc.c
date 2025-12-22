/*
** ObjectiveAmiga: Misc functions
** See GNU:lib/libobjam/ReadMe for details
*/


#include <exec/types.h>
#include <exec/memory.h>
#include <exec/exec.h>
#include <dos/dos.h>
#include <clib/alib_protos.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <stddef.h>

#include <clib/objc_protos.h>

#include <sys/cdefs.h>
#include <inline/stubs.h>

#include "misc.h"

#include "objclib.h" /* For the global data */
#include "zone.h" /* For quick access to the default zone */


void __objc_sprintf (const char *buf, const char *format, ...)
{
  RawDoFmt((char *)format, &format+1, (void (*))"\x16\xC0\x4E\x75", (char *)buf);
}


void __printf_callback()
{
  register BPTR output asm("a3");
  register LONG data asm("d0");

  FPutC(output,data);
}


void __objc_printf (const char *format, ...)
{
  RawDoFmt((char *)format, &format+1, __printf_callback, (APTR)Output());
}


int __objc_strcmp (const char *a, const char *b)
{
  int i=0;

  while(a[i]&&b[i])
  {
    if(a[i]<b[i]) return -1;
    else if(b[i]<a[i]) return 1;
    i++;
  }

  if(a[i]) return 1;
  else if(b[i]) return -1;
  else return 0;
}


char *__objc_strcpy (char *to, const char *from)
{
  int i=0;

  for(;;)
  {
    to[i]=from[i];
    if(!from[i]) break;
    i++;
  }

  return to;
}


void __objc_NewList (struct List *list)
{
  list->lh_Head=(struct Node *)(&(list->lh_Tail));
  list->lh_Tail=0;
  list->lh_TailPred=(struct Node *)(&(list->lh_Head));
}


void __objc_abort(void)
{
  register void *globaldata asm("a4");
  globaldata=libinitdata->globaldata;
  (*(libinitdata->abort))();
}


/******************************* misc functions */

static const char * __objc_nomem_str="Virtual memory exhausted";

void objc_fatal(const char* msg)
{
  printf("*** Objective C runtime error:\n  %s.\n  Aborting.\n",msg);
  abort();
}

void __objc_archiving_fatal(const char* format, int arg1)
{
  printf("*** Objective C archiving error:\n  ");
  printf(format,arg1);
  printf(".\n  Aborting.\n");
  abort();
}

void * __objc_xmalloc(int size)
{
  void *res;
  if(!(res=NXZoneMalloc(__DefaultMallocZone,(int)size))) objc_fatal(__objc_nomem_str);
  return res;
}

void * __objc_xmalloc_from_zone(int size, NXZone* zone)
{
  void *res;
  if(!(res=NXZoneMalloc(zone,(int)size))) objc_fatal(__objc_nomem_str);
  return res;
}

void * __objc_xrealloc(void* mem, int size)
{
  void *res;
  if(!(res=NXZoneRealloc(__DefaultMallocZone,mem,(int)size))) objc_fatal(__objc_nomem_str);
  return res;
}

void * __objc_xcalloc(int nelem, int size)
{
  void *res;
  if(!(res=NXZoneCalloc(__DefaultMallocZone,(int)nelem,(int)size))) objc_fatal(__objc_nomem_str);
  return res;
}

void __objc_xfree(void *mem)
{
  NXZoneFree(NXZoneFromPtr(mem),mem);
}
