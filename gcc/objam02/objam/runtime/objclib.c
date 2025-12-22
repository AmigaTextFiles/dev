/*
** ObjectiveAmiga: objc-*.library main module
** See GNU:lib/libobjam/ReadMe for details
*/


#define LIBIDSTRING "objc-5-2-3.library 2.1 (16.4.95)"
#define LIBVERSION  2
#define LIBREVISION 1


/****************************************************************** includes */

#include <exec/types.h>
#include <exec/execbase.h>
#include <dos/dosextens.h>
#include <proto/exec.h>
#include <headers/stabs.h>

#include <libraries/objc.h>
#include <clib/objc_protos.h>

#include "zone.h"
#include "atom.h"
#include "misc.h"


/******************************************************************* defines */

#ifdef AMIGAOS_39
#define OSLIBVERSION 39
#else
#define OSLIBVERSION 37
#endif


/******************************************************************* exports */

const BYTE LibName[]=OBJCNAME;
const BYTE LibIdString[]=LIBIDSTRING;
const UWORD LibVersion=LIBVERSION;
const UWORD LibRevision=LIBREVISION;


/******************************************************* global declarations */

struct ObjcBase *myLibPtr;
struct ExecBase *SysBase;
struct DosLibrary *DOSBase;
struct Library *UtilityBase;
struct Library *__UtilityBase;


/*********************************** user library initialization and cleanup */

static int Cleanup(void)
{
  if(__DefaultMallocZone) NXDestroyZone(__DefaultMallocZone);
  if(UtilityBase) CloseLibrary(UtilityBase);
  if(DOSBase) CloseLibrary((struct Library *)DOSBase);
  return 1;
}

int __UserLibInit(struct Library *myLib) /* CAUTION: This function may run in a forbidden state */
{
  /* setup your library base - to access library functions over *this* basePtr! */

  myLibPtr = (struct ObjcBase *)myLib;

  SysBase=*(struct ExecBase **)4;
  if(!(DOSBase=(struct DosLibrary *)OpenLibrary("dos.library",OSLIBVERSION))) return Cleanup();
  if(!(UtilityBase=OpenLibrary("utility.library",OSLIBVERSION))) return Cleanup();
  __UtilityBase=UtilityBase;
  if(!(__DefaultMallocZone=NXCreateZone(2*vm_page_size,vm_page_size,TRUE))) return Cleanup();
  if(!(__AtomList=(struct List *)NXZoneMalloc(__DefaultMallocZone,sizeof(struct List)))) return Cleanup();
  NewList(__AtomList);

  return 0;
}

void __UserLibCleanUp() /* CAUTION: This function runs in a forbidden state */
{
  Cleanup();
}


struct __objclib_init_data *libinitdata;

BOOL __objclib_init(struct __objclib_init_data *data)
{
  libinitdata=data;
  return TRUE;
}


/**************************************************************** jump table */

ADDTABL_1(__objclib_init,a0);

ADDTABL_3(NXCreateZone,d0,d1,d2);
ADDTABL_4(NXCreateChildZone,a0,d0,d1,d2);
ADDTABL_1(NXMergeZone,a0);
ADDTABL_1(NXZoneFromPtr,a1);
ADDTABL_1(NXDestroyZone,a0);
ADDTABL_2(NXZoneMalloc,a0,d0);
ADDTABL_3(NXZoneCalloc,a0,d0,d1);
ADDTABL_3(NXZoneRealloc,a0,a1,d0);
ADDTABL_2(NXZoneFree,a0,a1);
ADDTABL_2(NXNameZone,a0,a1);
ADDTABL_1(NXZonePtrInfo,a1);
ADDTABL_0(NXDefaultMallocZone);
ADDTABL_0(NXMallocCheck);

ADDTABL_1(NXUniqueString,a1);
ADDTABL_2(NXUniqueStringWithLength,a1,d0);
ADDTABL_1(NXUniqueStringNoCopy,a1);
ADDTABL_1(NXCopyStringBuffer,a1);
ADDTABL_2(NXCopyStringBufferFromZone,a1,a0);

ADDTABL_1(__objc_xmalloc,d0);
ADDTABL_2(__objc_xmalloc_from_zone,d0,a0);
ADDTABL_2(__objc_xrealloc,a0,d0);
ADDTABL_2(__objc_xcalloc,d0,d1);
ADDTABL_1(__objc_xfree,a0);

ADDTABL_1(objc_fatal,a0);
ADDTABL_2(__objc_archiving_fatal,a0,d0);
ADDTABL_1(class_create_instance,a1);
ADDTABL_2(class_create_instance_from_zone,a1,a0);
ADDTABL_1(object_copy,a1);
ADDTABL_2(object_copy_from_zone,a1,a0);
ADDTABL_1(object_dispose,a1);

ADDTABL_1(objc_aligned_size,a0);
ADDTABL_1(objc_sizeof_type,a0);
ADDTABL_1(objc_alignof_type,a0);
ADDTABL_1(objc_promoted_size,a0);
ADDTABL_1(objc_skip_type_qualifiers,a0);
ADDTABL_1(objc_skip_typespec,a0);
ADDTABL_1(objc_skip_offset,a0);
ADDTABL_1(objc_skip_argspec,a0);
ADDTABL_1(method_get_number_of_arguments,a1);
ADDTABL_1(method_get_sizeof_arguments,a1);
ADDTABL_3(method_get_first_argument,a1,a2,a0);
ADDTABL_2(method_get_next_argument,a2,a0);
ADDTABL_4(method_get_nth_argument,a1,a2,d0,a0);
ADDTABL_1(objc_get_type_qualifiers,a0);

ADDTABL_2(sarray_new,d0,a0);
ADDTABL_1(sarray_free,a1);
ADDTABL_1(sarray_lazy_copy,a1);
ADDTABL_2(sarray_realloc,a1,d0);
ADDTABL_3(sarray_at_put,a1,d0,a0);
ADDTABL_3(sarray_at_put_safe,a1,d0,a0);
ADDTABL_0(__objc_print_dtable_stats);

ADDTABL_END();
