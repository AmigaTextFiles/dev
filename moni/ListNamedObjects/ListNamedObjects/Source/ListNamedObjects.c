/*

File: ListNamedObjects.c
Author: Neil Cafferkey

This program is in the public domain.

*/

#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/utility.h>

#define SysBase base->sys_base
#define DOSBase base->dos_base
#define UtilityBase base->utility_base

#define DOS_VERSION 36
#define UTILITY_VERSION 36

typedef ULONG UPINT;

struct Base
{
   struct ExecBase *sys_base;
   struct DosLibrary *dos_base;
   struct Library *utility_base;
   struct NamedObject *first_object;
};


IMPORT struct ExecBase *AbsExecBase;

const TEXT version_string[] = "$VER: ListNamedObjects 1.1 (29.7.2016)";

const TEXT dos_name[] = "dos.library";
const TEXT utility_name[] = "utility.library";


static VOID ListNameSpace(struct NamedObject *name_space, UWORD level,
   struct Base *base);


LONG Main(VOID)
{
   LONG error = 0;
   struct Base _base;
   struct Base *base = &_base;
   struct NamedObject *object, *last_object = NULL;

   /* Open libraries */

   SysBase = AbsExecBase;
   DOSBase = (APTR)OpenLibrary(dos_name, DOS_VERSION);
   if(DOSBase == NULL)
      return RETURN_FAIL;

   UtilityBase = OpenLibrary(utility_name, UTILITY_VERSION);
   if(UtilityBase == NULL)
      error = 1;

   /* List root namespace and its sub-namespaces recursively */

   if(error == 0)
   {
      base->first_object = NULL;
      ListNameSpace(NULL, 0, base);
   }

   /* Print error message */

   SetIoErr(error);
   PrintFault(error, NULL);

   /* Release resources and exit */

   if(UtilityBase != NULL)
      CloseLibrary(UtilityBase);
   CloseLibrary((APTR)DOSBase);

   return RETURN_OK;
}



static VOID ListNameSpace(struct NamedObject *name_space, UWORD level,
   struct Base *base)
{
   UWORD i;
   struct NamedObject *object, *last_object = NULL;

   while((object = FindNamedObject(name_space, NULL, last_object)) != NULL
      && object != base->first_object)
   {
      ReleaseNamedObject(last_object);
      last_object = object;

      /* We have to rely on undocumented behaviour here: if an attempt is
         made to list a non-namespace object, the root namespace is used
         instead. We detect that condition */

      if(level == 0 && base->first_object == NULL)
         base->first_object = object;

      /* Print the object's name and value, indented according to depth */

      for(i = 0; i < level; i++)
         PutStr(" ");
      Printf("%s: 0x%lx\n", NamedObjectName(object),
         (UPINT)object->no_Object);

      /* List the object's own namespace */

      ListNameSpace(object, level + 1, base);
   }
   ReleaseNamedObject(last_object);
}



