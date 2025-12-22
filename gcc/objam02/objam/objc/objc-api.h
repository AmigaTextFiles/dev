/*
** ObjectiveAmiga: GNU Objective-C Runtime API
** See GNU:lib/libobjam/ReadMe for details
*/


#ifndef __objc_api_INCLUDE_GNU
#define __objc_api_INCLUDE_GNU

#include <objc/objc.h>
#include "hash.h"
#include <stdio.h>


/*
** Set this variable nonzero to print a line describing each
** message that is sent.  (this is currently disabled)
*/
extern BOOL objc_trace;


/*
** This is a hook which is called by objc_lookup_class and
** objc_get_class if the runtime is not able to find the class.
** This may e.g. try to load in the class using dynamic loading.
** The function is guaranteed to be passed a non-NULL name string.
*/
extern OCClass* (*_objc_lookup_class)(const char *name);

Method_t class_get_class_method(MetaClass* class, SEL aSel);

Method_t class_get_instance_method(OCClass* class, SEL aSel);

OCClass* class_pose_as(OCClass* impostor, OCClass* superclass);

OCClass* objc_get_class(const char *name);

OCClass* objc_lookup_class(const char *name);

const char *sel_get_name(SEL selector);

SEL sel_get_uid(const char *name);

SEL sel_register_name(const char *name);

BOOL sel_is_mapped (SEL aSel);

static inline const char *class_get_class_name(OCClass* class)
{ return CLS_ISCLASS(class)?class->name:((class==Nil)?"Nil":0); }

static inline long class_get_instance_size(OCClass* class)
{ return CLS_ISCLASS(class)?class->instance_size:0; }

static inline MetaClass *class_get_meta_class(OCClass* class)
{ return CLS_ISCLASS(class)?class->class_pointer:Nil; }

static inline OCClass* class_get_super_class(OCClass* class)
{ return CLS_ISCLASS(class)?class->super_class:Nil; }

static inline int class_get_version(OCClass* class)
{ return CLS_ISCLASS(class)?class->version:-1; }

static inline BOOL class_is_class(OCClass* class)
{ return CLS_ISCLASS(class); }

static inline BOOL class_is_meta_class(OCClass* class)
{ return CLS_ISMETA(class); }

static inline void class_set_version(OCClass* class, long version)
{ if(CLS_ISCLASS(class)) class->version = version; }

static inline IMP method_get_imp(Method_t method)
{ return (method!=METHOD_NULL)?method->method_imp:(IMP)0; }

IMP get_imp (OCClass* class, SEL sel);


static inline OCClass *object_get_class(id object)
{
  return ((object!=nil)
	  ? (CLS_ISCLASS(object->class_pointer)
	     ? object->class_pointer
	     : (CLS_ISMETA(object->class_pointer)
		? (OCClass*)object
		: Nil))
	  : Nil);
}

static inline const char *object_get_class_name(id object)
{
  return ((object!=nil)?(CLS_ISCLASS(object->class_pointer)
                         ?object->class_pointer->name
                         :((OCClass*)object)->name)
	  :"Nil");
}

static inline MetaClass *object_get_meta_class(id object)
{
  return ((object!=nil)?(CLS_ISCLASS(object->class_pointer)
                         ?object->class_pointer->class_pointer
                         :(CLS_ISMETA(object->class_pointer)
                           ?object->class_pointer
                           :Nil))
	  :Nil);
}

static inline OCClass *object_get_super_class(id object)
{
  return ((object!=nil)?(CLS_ISCLASS(object->class_pointer)
                         ?object->class_pointer->super_class
                         :(CLS_ISMETA(object->class_pointer)
                           ?((OCClass*)object)->super_class
                           :Nil))
	  :Nil);
}

static inline BOOL object_is_class(id object)
{ return CLS_ISCLASS((OCClass*)object); }

static inline BOOL object_is_instance(id object)
{ return (object!=nil)&&CLS_ISCLASS(object->class_pointer); }

static inline BOOL object_is_meta_class(id object)
{ return CLS_ISMETA((OCClass*)object); }


#endif /* not __objc_api_INCLUDE_GNU */
