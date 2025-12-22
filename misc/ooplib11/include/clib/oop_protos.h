#ifndef  CLIB_OOP_PROTOS_H
#define  CLIB_OOP_PROTOS_H

#include <exec/types.h>
#include <utility/hooks.h>

//   object management
APTR OOP_NewObject(APTR Class,APTR ArgList);
LONG OOP_DeleteObject(APTR Object);
LONG OOP_DoMethod(APTR Object,ULONG Method,ULONG *ArgList);
LONG OOP_DoSuperMethod(APTR Object,ULONG Method,ULONG *ArgList);
LONG OOP_DoPropagatedMethod(APTR Object,ULONG Method,ULONG *ArgList);
//   classlist management
LONG OOP_AddClass(APTR Class,STRPTR Name);
LONG OOP_RemClass(APTR Class);
APTR OOP_FindClass(STRPTR Name);
//   class management
LONG OOP_AddSuperClass(APTR Class,APTR SuperClass);
LONG OOP_RemSuperClass(APTR Class,APTR SuperClass);
LONG OOP_AddMethod(APTR Class,ULONG MethodID,struct Hook *Hook);
LONG OOP_RemMethod(APTR Class,ULONG MethodID);

#endif   /* CLIB_OOP_PROTOS_H */
