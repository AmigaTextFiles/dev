/*
** ObjectiveAmiga: Class related functions
** See GNU:lib/libobjam/ReadMe for details
*/


#include <proto/exec.h>

#include <libraries/objc.h>
#include <clib/objc_protos.h>

#include "misc.h" /* For the ANSI function emulations */
#include "zone.h" /* For quick access to the default zone */


id class_create_instance(OCClass* class)
{
  return class_create_instance_from_zone(class,__DefaultMallocZone);
}

id class_create_instance_from_zone(OCClass* class, NXZone* zone)
{
  id newObject = nil;
  if(CLS_ISCLASS(class)) newObject=(id)__objc_xmalloc_from_zone(class->instance_size,zone);
  if(newObject)
  {
    bzero (newObject, class->instance_size);
    newObject->class_pointer = class;
  }
  return newObject;
}

id object_copy(id object)
{
  return object_copy_from_zone(object,__DefaultMallocZone);
}

id object_copy_from_zone(id object, NXZone* zone)
{
  id copy;

  if(object) if(CLS_ISCLASS(object->class_pointer))
  {
    copy = class_create_instance_from_zone(object->class_pointer,zone);
    CopyMem((APTR)object, (APTR)copy, object->class_pointer->instance_size);
    return copy;
  }
  else return nil;
}


id object_dispose(id object)
{
  if(object) if(CLS_ISCLASS(object->class_pointer)) __objc_xfree((void *)object);
  return nil;
}
