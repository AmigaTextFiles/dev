/*
** ObjectiveAmiga: The implementation of class Object for Objective-C
** See GNU:lib/libobjam/ReadMe for details
*/


#import "Object.h"
#import "Protocol.h"

#include "objc-api.h"

#include <stdarg.h>
#include <fcntl.h>

extern int errno;


@implementation Object

+ initialize
{
  return self;
}

- init
{
  return self;
}

+ new
{
  return [[self alloc] init];
}

+ alloc
{
  return class_create_instance(self);
}

+ allocFromZone:(NXZone *)zone // NeXT only
{
  return class_create_instance_from_zone(self,zone);
}

- free
{
  return object_dispose(self);
}

- copy
{
  return [[self shallowCopy] deepen];
}

- copyFromZone:(NXZone *)zone
{
  return [object_copy_from_zone(self,zone) deepen];
}

- (NXZone *)zone // NeXT only
{
  return NXZoneFromPtr(self);
}

- shallowCopy
{
  return object_copy(self);
}

- deepen
{
  return self;
}

- deepCopy
{
  return [self copy];
}

- (OCClass*)class
{
  return object_get_class(self);
}

- (OCClass*)superclass
{
  return object_get_super_class(self);
}

- (OCClass*)superClass
{
  return object_get_super_class(self);
}

- (MetaClass*)metaClass
{
  return object_get_meta_class(self);
}

- (const char *)name
{
  return object_get_class_name(self);
}

- self
{
  return self;
}

- (unsigned int)hash
{
  return (size_t)self;
}

- (BOOL)isEqual:anObject
{
  return self==anObject;
}

- (void)printForDebugger // [stz] //-- - (void)printForDebugger:(NXStream *)stream;
{
  printf("*** Object dump:\n");
  printf("  Object named.....%s\n",[self name]);
  printf("  Of class.........%s\n",[[self class] name]);
  printf("  At address.......%x\n",(int)self);
  printf("  In zone at.......%x\n",[self zone]);
}

- (int)compare:anotherObject;
{
  if ([self isEqual:anotherObject])
    return 0;
  // Ordering objects by their address is pretty useless, 
  // so subclasses should override this is some useful way.
  else if (self > anotherObject)
    return 1;
  else 
    return -1;
}

- (BOOL)isMetaClass
{
  return NO;
}

- (BOOL)isClass
{
  return object_is_class(self);
}

- (BOOL)isInstance
{
  return object_is_instance(self);
}

- (BOOL)isKindOf:(OCClass*)aClassObject
{
  OCClass* class;

  for (class = self->isa; class!=Nil; class = class_get_super_class(class))
    if (class==aClassObject)
      return YES;
  return NO;
}

- (BOOL)isMemberOf:(OCClass*)aClassObject
{
  return self->isa==aClassObject;
}

- (BOOL)isKindOfClassNamed:(const char *)aClassName
{
  OCClass* class;

  if (aClassName!=NULL)
    for (class = self->isa; class!=Nil; class = class_get_super_class(class))
      if (!strcmp(class_get_class_name(class), aClassName))
        return YES;
  return NO;
}

- (BOOL)isMemberOfClassNamed:(const char *)aClassName
{
  return ((aClassName!=NULL)
          &&!strcmp(class_get_class_name(self->isa), aClassName));
}

+ (BOOL)instancesRespondTo:(SEL)aSel
{
  return class_get_instance_method(self, aSel)!=METHOD_NULL;
}

- (BOOL)respondsTo:(SEL)aSel
{
  return ((object_is_instance(self)
           ?class_get_instance_method(self->isa, aSel)
           :class_get_class_method(self->isa, aSel))!=METHOD_NULL);
}

+ (IMP)instanceMethodFor:(SEL)aSel
{
  return method_get_imp(class_get_instance_method(self, aSel));
}

// Indicates if the receiving class or instance conforms to the given protocol
// not usually overridden by subclasses
- (BOOL) conformsTo: (Protocol*)aProtocol
{
  int i;
  struct objc_protocol_list* proto_list;

  for (proto_list = isa->protocols;
       proto_list; proto_list = proto_list->next)
    {
      for (i=0; i < proto_list->count; i++)
      {
        if ([proto_list->list[i] conformsTo: aProtocol])
          return YES;
      }
    }

  if ([self superClass])
    return [[self superClass] conformsTo: aProtocol];
  else
    return NO;
}

- (IMP)methodFor:(SEL)aSel
{
  return (method_get_imp(object_is_instance(self)
                         ?class_get_instance_method(self->isa, aSel)
                         :class_get_class_method(self->isa, aSel)));
}

+ (struct objc_method_description *)descriptionForInstanceMethod:(SEL)aSel
{
  return ((struct objc_method_description *)
           class_get_instance_method(self, aSel));
}

- (struct objc_method_description *)descriptionForMethod:(SEL)aSel
{
  return ((struct objc_method_description *)
           (object_is_instance(self)
            ?class_get_instance_method(self->isa, aSel)
            :class_get_class_method(self->isa, aSel)));
}

- perform:(SEL)aSel
{
  IMP msg = objc_msg_lookup(self, aSel);
  if (!msg)
    return [self error:"invalid selector passed to %s", sel_get_name(_cmd)];
  return (*msg)(self, aSel);
}

- perform:(SEL)aSel with:anObject
{
  IMP msg = objc_msg_lookup(self, aSel);
  if (!msg)
    return [self error:"invalid selector passed to %s", sel_get_name(_cmd)];
  return (*msg)(self, aSel, anObject);
}

- perform:(SEL)aSel with:anObject1 with:anObject2
{
  IMP msg = objc_msg_lookup(self, aSel);
  if (!msg)
    return [self error:"invalid selector passed to %s", sel_get_name(_cmd)];
  return (*msg)(self, aSel, anObject1, anObject2);
}

- forward:(SEL)aSel :(arglist_t)argFrame
{
  return [self doesNotRecognize: aSel];
}

- performv:(SEL)aSel :(arglist_t)argFrame
{
  return objc_msg_sendv(self, aSel, argFrame);
}

+ poseAs:(OCClass*)aClassObject
{
  return class_pose_as(self, aClassObject);
}

- (OCClass*)transmuteClassTo:(OCClass*)aClassObject
{
  if (object_is_instance(self))
    if (class_is_class(aClassObject))
      if (class_get_instance_size(aClassObject)==class_get_instance_size(isa))
        if ([self isKindOf:aClassObject])
          {
            OCClass* old_isa = isa;
            isa = aClassObject;
            return old_isa;
          }
  return nil;
}

- subclassResponsibility:(SEL)aSel
{
  return [self error:"subclass should override %s", sel_get_name(aSel)];
}

- notImplemented:(SEL)aSel
{
  return [self error:"method %s not implemented", sel_get_name(aSel)];
}

- shouldNotImplement:(SEL)aSel
{
  return [self error:"%s should not implement %s", 
	             object_get_class_name(self), sel_get_name(aSel)];
}

- doesNotRecognize:(SEL)aSel
{
  return [self error:"%s does not recognize %s",
                     object_get_class_name(self), sel_get_name(aSel)];
}

- error:(const char *)aString, ...
{
#define FMT "error: %s (%s)\n%s\n"
  char fmt[(strlen((char*)FMT)+strlen((char*)object_get_class_name(self))
            +((aString!=NULL)?strlen((char*)aString):0)+8)];
  va_list ap;

  sprintf(fmt, FMT, object_get_class_name(self),
                    object_is_instance(self)?"instance":"class",
                    (aString!=NULL)?aString:"");
  va_start(ap, aString);
  /* _objc_error(self, fmt, ap); inlined: */
    vfprintf (stderr, fmt, ap);
    abort();
  va_end(ap);
  return nil;
#undef FMT
}

+ (int)version
{
  return class_get_version(self);
}

+ setVersion:(int)aVersion
{
  class_set_version(self, aVersion);
  return self;
}

+ (int)streamVersion: (TypedStream*)aStream
{
  if (aStream->mode == OBJC_READONLY) return objc_get_stream_class_version (aStream, self);
  else return class_get_version (self);
}

// These are used to write or read the instance variables 
// declared in this particular part of the object.  Subclasses
// should extend these, by calling [super read/write: aStream]
// before doing their own archiving.  These methods are private, in
// the sense that they should only be called from subclasses.

- read: (TypedStream*)aStream
{
  // [super read: aStream];  
  return self;
}

- write: (TypedStream*)aStream
{
  // [super write: aStream];
  return self;
}

- awake
{
  // [super awake];
  return self;
}

@end


@implementation Object (StepstoneArchiving)

+ readFrom:(STR)aFile
{
  TypedStream *stream;
  id newObject=nil;

  if(stream=objc_open_typed_stream_for_file(aFile,OBJC_READONLY))
  {
    objc_read_object(stream,&newObject);
    objc_close_typed_stream(stream);
    return newObject;
  }

  return nil;
}

- (BOOL)storeOn:(STR)aFile
{
  TypedStream *stream;

  if(stream=objc_open_typed_stream_for_file(aFile,OBJC_WRITEONLY))
  {
    objc_write_root_object(stream,self);
    objc_close_typed_stream(stream);
    return YES;
  }

  return NO;
}

@end


/* Unimplemented (Stepstone):

- (BOOL)isCopyOf:anObject;
- (BOOL)isSame:anObject;
- (BOOL)notEqual:anObject;
- (BOOL)notSame:anObject;
- (STR)describe;
- asGraph:(BOOL)unique;
- isOfSTR:(STR)aClassName;
- notImplemented;
- print;
- printOn:(IOD)anIOD;
- shouldNotImplement;
- show;
- subclassResponsibility;

*/
